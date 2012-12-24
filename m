Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab2LXQxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 11:53:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab2LXQxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 11:53:30 -0500
Date: Mon, 24 Dec 2012 17:53:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 1/4] signalfd: add ability to return siginfo in a raw
	format
Message-ID: <20121224165306.GA9553@redhat.com>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org> <1356336807-5517-2-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356336807-5517-2-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24, Andrey Vagin wrote:
>
> signalfd should be called with the flag SFD_RAW for that.
>
> signalfd_siginfo is not full for siginfo with a negative si_code.
> copy_siginfo_to_user() is copied a full siginfo to user-space, if
> si_code is negative.  signalfd_copyinfo() doesn't do that and can't be
> expanded, because it has not compatiable format with siginfo_t.

Yes, but otoh perhaps we should change (fix) signalfd_siginfo/copyinfo,
its "default" case makes no sense if si_code < 0.

> Another problem is that a constant __SI_* is removed from si_code.

OK, so you add the additional put_user(kinfo->si_code). Again, in
this case we can extend signalfd_siginfo perhaps...

Anyway, the patch doesn't look right.

> +static int signalfd_copy_raw_info(struct signalfd_siginfo __user *siginfo,
> +					siginfo_t *kinfo)
> +{
> +	siginfo_t *uinfo = (siginfo_t *) siginfo;
> +	int err;
> +
> +	BUILD_BUG_ON(sizeof(siginfo_t) != sizeof(struct signalfd_siginfo));
> +
> +	err = __clear_user(uinfo, sizeof(*uinfo));
> +	err |= copy_siginfo_to_user(uinfo, kinfo);

This probably needs copy_siginfo_to_user32() if is_compat_task...

> +	err |= __put_user(kinfo->si_code, &uinfo->si_code);

__put_user() is not safe? This allows to write to the kernel memory.

> @@ -286,6 +308,11 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
>  				       O_RDWR | (flags & (O_CLOEXEC | O_NONBLOCK)));
>  		if (ufd < 0)
>  			kfree(ctx);
> +		else if (flags & SFD_RAW) {
> +			struct fd f = fdget(ufd);
> +			f.file->f_flags |= flags & SFD_RAW;

Well, but this is racy. How we can know that fdget(ufd) still
points to the same file created by anon_inode_getfd? Not to
mention f.file can be NULL.

Another CLONE_FILES thread can do close() right after fd_install().
And it can also do dup3().

Oleg.

