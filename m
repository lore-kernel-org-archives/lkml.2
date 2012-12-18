Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2LRWaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:30:21 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59431 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2LRWaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:30:16 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 17:30:16 EST
MIME-Version: 1.0
In-Reply-To: <1355867449-3209-1-git-send-email-coreyb@linux.vnet.ibm.com>
References: <1355867449-3209-1-git-send-email-coreyb@linux.vnet.ibm.com>
Date: Tue, 18 Dec 2012 16:22:18 -0600
Message-ID: <CABqD9hbw2kT1PYiHRNSq+xVEDQdYPVqrJv78Sa4DiSnvWJ97cQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] seccomp: Add SECCOMP_RET_INFO return value
From: Will Drewry <wad@chromium.org>
To: Corey Bryant <coreyb@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        jmorris@namei.org, pmoore@redhat.com, otubo@linux.vnet.ibm.com,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch!

On Tue, Dec 18, 2012 at 3:50 PM, Corey Bryant <coreyb@linux.vnet.ibm.com> wrote:
> Adds a new return value to seccomp filters that causes an
> informational kernel message to be printed.  The message
> includes the system call number.

I don't have strong opinions about this either way, but here are the
points that led me to drop a _LOG return value in the past:
- ptrace can cover this awkwardly (user)
- ftrace can cover this awkwardly (system/root)
- audit can cover this without an allow
- _TRAP can be used to implement this
- There's no good way to give back the log data.

I've been relying on SECCOMP_RET_TRAP:
- trap on failure, log, then die
- trap on failure, log, then jump to a whitelisted re-entry point to
resume the syscall
while others I've spoken with have been using the audit path to track
denied values -- not so great for soft-failures :)

[snip]
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 5af44b5..854f628 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -433,6 +433,10 @@ int __secure_computing(int this_syscall)
>                                 goto skip;  /* Explicit request to skip. */
>
>                         return 0;
> +               case SECCOMP_RET_INFO:
> +                       if (printk_ratelimit())
> +                               pr_info("seccomp: syscall=%d\n", this_syscall);

The arch value will also be needed to make this reliably meaningful
(how was the syscall called).

That aside, I worry that pr_info is the wrong place for a random user
on the machine to log to for this, but I may be wrong, rather than a
dedicated ringbufffer, etc.  So if this is for a user with privs, then
a SECCOMP_RET_AUDIT might make sense.  Feedback to a local user seems
tricky in general. I don't know :)  I just decided to deal with it in
userland even if it is slightly painful.

Thanks!
will
