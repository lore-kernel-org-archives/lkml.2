Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2ALXx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 18:53:57 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:38667 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755596Ab2ALXxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 18:53:53 -0500
Message-ID: <4F0F8029.9030508@xenotime.net>
Date: Thu, 12 Jan 2012 16:51:53 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH v3 2/3] seccomp_filters: system call filtering using BPF
References: <1326411506-16894-1-git-send-email-wad@chromium.org> <1326411506-16894-2-git-send-email-wad@chromium.org>
In-Reply-To: <1326411506-16894-2-git-send-email-wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2012 03:38 PM, Will Drewry wrote:
>  include/linux/prctl.h   |    3 +
>  include/linux/seccomp.h |   68 +++++-
>  kernel/Makefile         |    1 +
>  kernel/fork.c           |    4 +
>  kernel/seccomp.c        |    8 +
>  kernel/seccomp_filter.c |  620 +++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sys.c            |    4 +
>  security/Kconfig        |   12 +
>  8 files changed, 717 insertions(+), 3 deletions(-)
>  create mode 100644 kernel/seccomp_filter.c
> 
> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
> index cc7a4e9..0296871 100644
> --- a/include/linux/seccomp.h
> +++ b/include/linux/seccomp.h
> @@ -5,9 +5,28 @@
>  #ifdef CONFIG_SECCOMP
>  
>  #include <linux/thread_info.h>
> +#include <linux/types.h>
>  #include <asm/seccomp.h>
>  
> -typedef struct { int mode; } seccomp_t;
> +struct seccomp_filter;
> +/**
> + * struct seccomp_struct - the state of a seccomp'ed process
> + *
> + * @mode:
> + *     if this is 0, seccomp is not in use.
> + *             is 1, the process is under standard seccomp rules.
> + *             is 2, the process is only allowed to make system calls where
> + *                   associated filters evaluate successfully.
> + * @filter: Metadata for filter if using CONFIG_SECCOMP_FILTER.
> + *          @filter must only be accessed from the context of current as there
> + *          is no guard.
> + */
> +typedef struct seccomp_struct {
> +	int mode;
> +#ifdef CONFIG_SECCOMP_FILTER
> +	struct seccomp_filter *filter;
> +#endif
> +} seccomp_t;
>  
>  extern void __secure_computing(int);
>  static inline void secure_computing(int this_syscall)
> @@ -28,8 +47,7 @@ static inline int seccomp_mode(seccomp_t *s)
>  
>  #include <linux/errno.h>
>  
> -typedef struct { } seccomp_t;
> -
> +typedef struct seccomp_struct { } seccomp_t;
>  #define secure_computing(x) do { } while (0)
>  
>  static inline long prctl_get_seccomp(void)
> @@ -49,4 +67,48 @@ static inline int seccomp_mode(seccomp_t *s)
>  
>  #endif /* CONFIG_SECCOMP */
>  
> +#ifdef CONFIG_SECCOMP_FILTER
> +
> +
> +extern long prctl_attach_seccomp_filter(char __user *);
> +
> +extern struct seccomp_filter *get_seccomp_filter(struct seccomp_filter *);
> +extern void put_seccomp_filter(struct seccomp_filter *);
> +
> +extern int seccomp_test_filters(int);
> +extern void seccomp_filter_log_failure(int);
> +extern void seccomp_struct_fork(struct seccomp_struct *child,
> +				const struct seccomp_struct *parent);
> +
> +static inline void seccomp_struct_init_task(struct seccomp_struct *seccomp)
> +{
> +	seccomp->mode = 0;
> +	seccomp->filter = NULL;
> +}
> +
> +/* No locking is needed here because the task_struct will
> + * have no parallel consumers.
> + */

(in multiple places:) Kernel multi-line comment style is:

/*
 * first line of text
 * more stuff
 */


> +static inline void seccomp_struct_free_task(struct seccomp_struct *seccomp)
> +{
> +	put_seccomp_filter(seccomp->filter);
> +	seccomp->filter = NULL;
> +}
> +
> +#else  /* CONFIG_SECCOMP_FILTER */
> +
> +#include <linux/errno.h>
> +
> +struct seccomp_filter { };
> +/* Macros consume the unused dereference by the caller. */
> +#define seccomp_struct_init_task(_seccomp) do { } while (0);
> +#define seccomp_struct_fork(_tsk, _orig) do { } while (0);
> +#define seccomp_struct_free_task(_seccomp) do { } while (0);
> +
> +static inline long prctl_attach_seccomp_filter(char __user *a2)
> +{
> +	return -ENOSYS;
> +}
> +
> +#endif  /* CONFIG_SECCOMP_FILTER */
>  #endif /* _LINUX_SECCOMP_H */


> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 57d4b13..78719be 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -47,6 +47,14 @@ void __secure_computing(int this_syscall)
>  				return;
>  		} while (*++syscall);
>  		break;
> +#ifdef CONFIG_SECCOMP_FILTER
> +	case 2:

Can we get macros (defines) for these @modes instead of using
inline constants?

> +		if (seccomp_test_filters(this_syscall) == 0)
> +			return;
> +
> +		seccomp_filter_log_failure(this_syscall);
> +		break;
> +#endif
>  	default:
>  		BUG();
>  	}
> diff --git a/kernel/seccomp_filter.c b/kernel/seccomp_filter.c
> new file mode 100644
> index 0000000..108a3f3
> --- /dev/null
> +++ b/kernel/seccomp_filter.c
> @@ -0,0 +1,620 @@
> +/* bpf program-based system call filtering
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright (C) 2011 The Chromium OS Authors <chromium-os-dev@chromium.org>
> + */
> +
...

> +/* seccomp_struct_fork: manages inheritance on fork

/**
  * seccomp_struct_fork - manages inheritance on fork

> + * @child: forkee's seccomp_struct
> + * @parent: forker's seccomp_struct
> + * Ensures that @child inherit a seccomp_filter iff seccomp is enabled
> + * and the set of filters is marked as 'enabled'.
> + */
> +void seccomp_struct_fork(struct seccomp_struct *child,
> +			 const struct seccomp_struct *parent)
> +{
> +	if (!parent->mode)
> +		return;
> +	child->mode = parent->mode;
> +	child->filter = get_seccomp_filter(parent->filter);
> +}
> +
> +/* Returns a pointer to the BPF evaluator after checking the offset and size
> + * boundaries.  The signature almost matches the signature from
> + * net/core/filter.c with the hopes of sharing code in the future.

Use kernel multi-line comment style.

> + */
> +static const void *load_pointer(const u8 *buf, size_t buflen,
> +				int offset, size_t size,
> +				void *unused)
> +{
> +	if (offset >= buflen)
> +		goto fail;
> +	if (offset < 0)
> +		goto fail;
> +	if (size > buflen - offset)
> +		goto fail;
> +	return buf + offset;
> +fail:
> +	return NULL;
> +}
> +

> diff --git a/security/Kconfig b/security/Kconfig
> index 51bd5a0..77b1106 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -84,6 +84,18 @@ config SECURITY_DMESG_RESTRICT
>  
>  	  If you are unsure how to answer this question, answer N.
>  
> +config SECCOMP_FILTER
> +	bool "Enable seccomp-based system call filtering"
> +	select SECCOMP
> +	depends on EXPERIMENTAL
> +	help
> +	  This kernel feature expands CONFIG_SECCOMP to allow computing
> +	  in environments with reduced kernel access dictated by a system
> +	  call filter, expressed in BPF, installed by the application itself
> +	  through prctl(2).

This help text is only useful to someone who already knows what it does/means
IMO.

> +
> +	  See Documentation/prctl/seccomp_filter.txt for more detail.

Yes, I'll look at that..


> +
>  config SECURITY
>  	bool "Enable different security models"
>  	depends on SYSFS


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
