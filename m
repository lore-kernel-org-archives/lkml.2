Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab0LFKAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 05:00:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:55070 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab0LFKAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 05:00:20 -0500
Subject: Re: [PATCH]: Revert 2.6.36 chroot ttyname regression
From: Miklos Szeredi <mszeredi@suse.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        stable@kernel.org
In-Reply-To: <m1vd37lqx2.fsf@fess.ebiederm.org>
References: <m1vd37lqx2.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Dec 2010 11:00:13 +0100
Message-ID: <1291629613.23515.31.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-05 at 15:51 -0800, Eric W. Biederman wrote:
> As of 2.6.36 ttyname does not work in a chroot.  It has already
> been reported that screen breaks, and for me this breaks an automated
> distribution testsuite, that I need to preserve the ability to run
> the existing binaries on for several more years.  glibc 2.11.3 which
> has a fix for this is not an option.
> 
> The root cause of this breakage is:
> commit 8df9d1a4142311c084ffeeacb67cd34d190eff74
> Author: Miklos Szeredi <mszeredi@suse.cz>
> Date:   Tue Aug 10 11:41:41 2010 +0200
> 
>     vfs: show unreachable paths in getcwd and proc
>     
>     Prepend "(unreachable)" to path strings if the path is not reachable
>     from the current root.
>     
>     Two places updated are
>      - the return string from getcwd()
>      - and symlinks under /proc/$PID.
>     
>     Other uses of d_path() are left unchanged (we know that some old
>     software crashes if /proc/mounts is changed).
>     
>     Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> 
> So remove the nice sounding, but ultimately ill advised change to how
> /proc/fd symlinks work.

I didn't anticipate this problem, and reverting is probably the right
thing to do here.  But the fact remains: proc symlinks remain a badly
defined and, as a consequence, badly used interface.

Userspace assumes that these symlinks, when doing readlink on them, will
yield a valid absolute path that points to the same file (as did ttyname
in previous glibc's).  This is a false assumption because the file may
not be reachable due to it being unlinked, under a chroot, in a
different mount namespace, or on a detached mount, etc...

If the file is unlinked, we'll have "/path/to/old/name (deleted)" which
is an especially bad since it cannot be distinguished from an existing
file called "name (deleted)".

Do we want to do anything with this or should we just leave it broken?

One way to fix the "(unreachable)" thing without breaking ttyname() is
to do a forward pass on unreachable paths, checking whether the exact
same file is indeed reachable under the current root.  Not prepending
"(unreachable)" is defensible in this case because, even though the
dentry/vfsmount pair for the open file is unreachable from the current
root, the file itself *is* reachable under the same name.

Thoughts?

Thanks,
Miklos

> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> ---
> 
> Index: linux-2.6.37-rc4.x86_64/fs/proc/base.c
> ===================================================================
> --- linux-2.6.37-rc4.x86_64.orig/fs/proc/base.c
> +++ linux-2.6.37-rc4.x86_64/fs/proc/base.c
> @@ -1574,7 +1574,7 @@ static int do_proc_readlink(struct path 
>  	if (!tmp)
>  		return -ENOMEM;
>  
> -	pathname = d_path_with_unreachable(path, tmp, PAGE_SIZE);
> +	pathname = d_path(path, tmp, PAGE_SIZE);
>  	len = PTR_ERR(pathname);
>  	if (IS_ERR(pathname))
>  		goto out;


