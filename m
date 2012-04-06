Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab2DFVOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:14:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab2DFVOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:14:18 -0400
Date: Fri, 6 Apr 2012 14:14:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, corbet@lwn.net, eric.dumazet@gmail.com,
        markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        jmorris@namei.org
Subject: Re: [PATCH v17 09/15] seccomp: remove duplicated failure logging
Message-Id: <20120406141415.93f46bc6.akpm@linux-foundation.org>
In-Reply-To: <1333051320-30872-10-git-send-email-wad@chromium.org>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
	<1333051320-30872-10-git-send-email-wad@chromium.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012 15:01:54 -0500
Will Drewry <wad@chromium.org> wrote:

> From: Kees Cook <keescook@chromium.org>
> 
> This consolidates the seccomp filter error logging path and adds more
> details to the audit log.
> 
> ...
>
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
>
> ...
>
>  #define audit_inode(n,d) do { (void)(d); } while (0)
>  #define audit_inode_child(i,p) do { ; } while (0)
>  #define audit_core_dumps(i) do { ; } while (0)
> -#define audit_seccomp(i) do { ; } while (0)
> +#define audit_seccomp(i,s,c) do { ; } while (0)

Sigh.  Someone please convert all these to C.  That way we get
typechecking and don't need dopey party tricks like that "(void)(d)" to
squish compilation warnings.

> ...
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -67,6 +67,7 @@
>  #include <linux/syscalls.h>
>  #include <linux/capability.h>
>  #include <linux/fs_struct.h>
> +#include <linux/compat.h>
>  
>  #include "audit.h"
>  
> @@ -2710,13 +2711,18 @@ void audit_core_dumps(long signr)
>  	audit_log_end(ab);
>  }
>  
> -void __audit_seccomp(unsigned long syscall)
> +void __audit_seccomp(unsigned long syscall, long signr, int code)
>  {
>  	struct audit_buffer *ab;
>  
>  	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
> -	audit_log_abend(ab, "seccomp", SIGKILL);
> +	audit_log_abend(ab, "seccomp", signr);
>  	audit_log_format(ab, " syscall=%ld", syscall);
> +#ifdef CONFIG_COMPAT
> +	audit_log_format(ab, " compat=%d", is_compat_task());
> +#endif

We don't need the ifdef for compilation reasons now.

The question is: should we emit the compat= record on
non-compat-capable architectures?  Doing so would be safer - making it
conditional invites people to write x86-only usersapce.


