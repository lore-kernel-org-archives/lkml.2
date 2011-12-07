Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1LGHcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 02:32:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58074 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab1LGHcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 02:32:50 -0500
Date: Wed, 7 Dec 2011 08:30:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Rik van Riel <riel@redhat.com>,
        Federica Teodori <federica.teodori@googlemail.com>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        kernel-hardening@lists.openwall.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2011.1] fs: symlink restrictions on sticky directories
Message-ID: <20111207073051.GB16942@elte.hu>
References: <20111206235815.GA21764@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206235815.GA21764@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> Past objections and rebuttals could be summarized as:
> 
>  - Violates POSIX.
>    - POSIX didn't consider this situation and it's not useful to follow
>      a broken specification at the cost of security.

Correct.

>  - Might break unknown applications that use this feature.
>    - Applications that break because of the change are easy to spot and
>      fix. Applications that are vulnerable to symlink ToCToU by not having
>      the change aren't. Additionally, no applications have yet been found
>      that rely on this behavior.

Are there *known* applications that break?

>  - Applications should just use mkstemp() or O_CREATE|O_EXCL.
>    - True, but applications are not perfect, and new software is written
>      all the time that makes these mistakes; blocking this flaw at the
>      kernel is a single solution to the entire class of vulnerability.

Right.

>  - This should live in the core VFS.
>    - This should live in an LSM. (https://lkml.org/lkml/2010/5/31/135)
>  - This should live in an LSM.
>    - This should live in the core VFS. (https://lkml.org/lkml/2010/8/2/188)

Ugh - and people continue to get exploited from a preventable, 
fixable and already fixed VFS design flaw.

> This patch is based on the patch in Openwall and grsecurity, 
> along with suggestions from Al Viro. I have added a sysctl to 
> enable the protected behavior, documentation, and a 
> ratelimited warning.

> +config PROTECTED_STICKY_SYMLINKS
> +	bool "Protect symlink following in sticky world-writable directories"
> +	help
> +	  A long-standing class of security issues is the symlink-based
> +	  time-of-check-time-of-use race, most commonly seen in
> +	  world-writable directories like /tmp. The common method of
> +	  exploitation of this flaw is to cross privilege boundaries
> +	  when following a given symlink (i.e. a root process follows
> +	  a malicious symlink belonging to another user).
> +
> +	  Enabling this solves the problem by permitting symlinks to only
> +	  be followed when outside a sticky world-writable directory,
> +	  or when the uid of the symlink and follower match, or when
> +	  the directory and symlink owners match.

Unless there are known apps that regress, shouldnt this be 
default y? Even if we were forced to not actually release such a 
final kernel, doing it in -rc1 would flush weird apps out of the 
woodwork.

> +int protected_sticky_symlinks =

__read_mostly, most emphatically.

> +static inline int
> +may_follow_link(struct dentry *dentry, struct nameidata *nameidata)
> +{
> +	int error = 0;
> +	const struct inode *parent;
> +	const struct inode *inode;
> +	const struct cred *cred;
> +
> +	if (!protected_sticky_symlinks)
> +		return 0;
> +
> +	/* Allowed if owner and follower match. */
> +	cred = current_cred();
> +	inode = dentry->d_inode;
> +	if (cred->fsuid == inode->i_uid)
> +		return 0;
> +
> +	/* Check parent directory mode and owner. */
> +	spin_lock(&dentry->d_lock);
> +	parent = dentry->d_parent->d_inode;
> +	if ((parent->i_mode & (S_ISVTX|S_IWOTH)) == (S_ISVTX|S_IWOTH) &&
> +	    parent->i_uid != inode->i_uid) {
> +		error = -EACCES;
> +	}
> +	spin_unlock(&dentry->d_lock);

Taking the global /tmp and /lib, /usr/lib dentry spinlocks here 
every time we follow a symlink is a bit sad: there are a lot of 
high-profile symlinks in a Linux installation in those places, 
followed by non-owners.

Nor is it really a realistic race that happens often: neither 
/tmp nor the library directories are being renamed or their 
permissions changed all that often for this parent lock taking 
to matter in practice.

Couldnt we somehow export this information outside the dentry 
lock, allowing safe lockless access to it?

> +
> +	if (error) {
> +		char name[sizeof(current->comm)];
> +		printk_ratelimited(KERN_NOTICE "non-matching-uid symlink "
> +			"following attempted in sticky world-writable "
> +			"directory by %s (fsuid %d)\n",
> +			get_task_comm(name, current), cred->fsuid);

I don't think the get_task_comm() extra layer is really 
necessary here - this is called in the *current* task's context 
- and it's not like that tasks are changing their own names all 
that often while they are busy executing VFS code, right? The 
race with some other task writing to /proc/PID/comm is 
uninteresting.

The more important piece of forensic information to log would be 
the file name that got attempted and perhaps the directory name 
as well. If there's an unknown hole in an unknown privileged app 
then this warning alone does not give the admin any clues where 
to look - the name of the expoiting task is probably obfuscated 
anyway, it's the identity of the attack vector that matters - 
and that name can generally not be controlled and obfuscated by 
the attacker.

If those issues are resolved:

 Reviewed-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
