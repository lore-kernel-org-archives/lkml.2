Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab0KJXup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:50:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757322Ab0KJXuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:50:44 -0500
Date: Wed, 10 Nov 2010 15:49:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
        kees.cook@canonical.com, security@kernel.org
Subject: Re: [PATCH v3] Restrict unprivileged access to kernel syslog
Message-Id: <20101110154956.83a3f84d.akpm@linux-foundation.org>
In-Reply-To: <1289431735.3847.9.camel@dan>
References: <1289431735.3847.9.camel@dan>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010 18:28:55 -0500
Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> The kernel syslog contains debugging information that is often useful
> during exploitation of other vulnerabilities, such as kernel heap
> addresses.  Rather than futilely attempt to sanitize hundreds (or
> thousands) of printk statements and simultaneously cripple useful
> debugging functionality, it is far simpler to create an option that
> prevents unprivileged users from reading the syslog.
> 
> This patch, loosely based on grsecurity's GRKERNSEC_DMESG, creates the
> dmesg_restrict sysctl.  When set to "0", the default, no restrictions
> are enforced.  When set to "1", only users with CAP_SYS_ADMIN can read
> the kernel syslog via dmesg(8) or other mechanisms.
> 
> v3 sets a default for the config, renames to
> CONFIG_SECURITY_DMESG_RESTRICT to be consistent with the sysctl name,
> and adds Acks.
> 

The patch adds trailing whitespace.  checkpatch detects it.

> CC: stable <stable@kernel.org>

hm.  Reasons for this?

> ...
>
> +dmesg_restrict:
> +
> +This toggle indicates whether unprivileged users are prevented 
> +from using dmesg(8) to view messages from the kernel's log
> +buffer.  By default, it is set to (0), resulting in no 
> +restrictions.  When set to (1), users must have CAP_SYS_ADMIN
> +to use dmesg(8).

Actually, the default depends on CONFIG_SECURITY_DMESG_RESTRICT ;)

> +==============================================================
> +
>  domainname & hostname:
>  
>  These files can be used to set the NIS/YP domainname and the
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 450092c..f0d0088 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -293,6 +293,7 @@ extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
>  				   unsigned int interval_msec);
>  
>  extern int printk_delay_msec;
> +extern int dmesg_restrict;
>  
>  /*
>   * Print a one-time message (analogous to WARN_ONCE() et al):
> diff --git a/kernel/printk.c b/kernel/printk.c
> index b2ebaee..38e7d58 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -261,6 +261,12 @@ static inline void boot_delay_msec(void)
>  }
>  #endif
>  
> +#ifdef CONFIG_SECURITY_DMESG_RESTRICT
> +int dmesg_restrict = 1;
> +#else
> +int dmesg_restrict;
> +#endif

You might be able to make this an int type and do

int dmesg_restrict = CONFIG_SECURITY_DMESG_RESTRICT;

We did a trick like that with CONFIG_BASE_SMALL:

int whatever = CONFIG_BASE_SMALL ? 2 : 42;

otoh you might decide not to bother, in which case, this?

--- a/Documentation/sysctl/kernel.txt~restrict-unprivileged-access-to-kernel-syslog-fix
+++ a/Documentation/sysctl/kernel.txt
@@ -216,11 +216,14 @@ to decide what to do with it.
 
 dmesg_restrict:
 
-This toggle indicates whether unprivileged users are prevented
-from using dmesg(8) to view messages from the kernel's log
-buffer.  By default, it is set to (0), resulting in no
-restrictions.  When set to (1), users must have CAP_SYS_ADMIN
-to use dmesg(8).
+This toggle indicates whether unprivileged users are prevented from using
+dmesg(8) to view messages from the kernel's log buffer.  When
+dmesg_restrict is set to (0) there are no restrictions.  When
+dmesg_restrict is set set to (1), users must have CAP_SYS_ADMIN to use
+dmesg(8).
+
+The kernel config option CONFIG_SECURITY_DMESG_RESTRICT sets the default
+value of dmesg_restrict.
 
 ==============================================================
 
_

