Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab0EaRxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 13:53:07 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39020 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756033Ab0EaRxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 13:53:01 -0400
Date: Mon, 31 May 2010 10:50:08 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
Message-ID: <20100531175008.GC4098@outflux.net>
References: <20100531030402.GQ6056@outflux.net>
 <20100531112314.373b0f26@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531112314.373b0f26@lxorguk.ukuu.org.uk>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Mon, May 31, 2010 at 11:23:14AM +0100, Alan Cox wrote:
> 1.We have things like SELinux so you can write rules to bound apps
>   which should be able to do this, if not then we should fix the security
>   policy to generally solve it

This requires that policy be written for all applications ever, which isn't
feasible.

> 2. If it worries you that much then you can *fix* /tmp/ for good using
> the work Al Viro did years ago on mountpoints. Give people their
> own /tmp. End of problem.

This has the same flaws in interoperability that you mention below for
hypothetical binary games.

> (If you fill your computer with concrete it will also violate POSIX but
> it will be more secure than your proposal. Both will of course has some
> impact on applications).

Well, my point was that in the past, a stand-alone objection was that it
violates POSIX.  I don't feel that this is a sufficient objection -- POSIX
did not consider this corner-case.  Filling my computer with concrete has a
nasty side-effect of making all my applications fail.  This patch isn't
that intrusive.  :)

> What if they are things like binary only games - now you can neither turn
> on your feature nor fix the app if you want to use it. If it was using
> SELinux or similar rules you could create a single exception rule. If it
> was using per user /tmp nobody would have to do anything

I do not believe there are any applications that depend on following
symlinks in sticky world-writable directories.  Besides, just because
something lacks source doesn't mean I can't change its behavior via binary
editing or LD_PRELOAD.  I do not feel that non-existent hypothetical
applications needing this feature is a sufficient reason to reject the
patch.

> >  - Applications should just use mkstemp() or O_CREATE|O_EXCL.
> >    - True, but applications are not perfect, and new software is written
> >      all the time that makes these mistakes; blocking this flaw at the
> >      kernel is a single solution to the entire class of vulnerability.
> 
> So new software is also being written all the time which has other holes.
> Actually its also according to your argument being written all the time
> so it'll break if you turn the feature on ?

Yes, everything is buggy -- I am seeking to solve a specific class
of security issue so that those bugs don't turn into an more serious problem.
One that has been fully solved with no known bad side-effects in a
hand-full of distros for possibly more than 10 years now.

> > +The default value is "0".  To disable this protection, setting a value of "1"
> > +will allow symlinks in sticky world-writable directories to be followed by
> > +anyone.
> 
> Wrong way around. You don't enable non-compliance and misbehaviour by
> default. For it to be any use you need a userspace adapted to run on your
> odd environment, so your distro can flip the flag from Linux mode to odd.

I'm happy to make that adjustment.

> > +	if ((parent->i_mode & (S_ISVTX|S_IWOTH)) == (S_ISVTX|S_IWOTH) &&
> > +	    parent->i_uid != inode->i_uid &&
> > +	    cred->fsuid != inode->i_uid) {
> > +		printk_ratelimited(KERN_NOTICE "non-matching-uid symlink "
> > +			"following attempted in sticky-directory by "
> > +			"%s (fsuid %d)\n", current->comm, cred->fsuid);
> 
> This is of minimal use - current->comm is arbitary and user controlled.

It's used strictly for reporting.  I'm open to other suggestions -- I just
want to give a system admin some information in the case where an
application is being attacked with /tmp symlink races.

> Also are we guaranteed to hold enough locks here to stop the parent uid
> changing ?

I don't know the answer to that -- I'm happy to add any needed locking.

> You've also stopped root doing this. Given DAC override that makes no
> sense and is asking to confuse stuff.

This should specifically ignore DAC override.  In most cases, it is root we
are trying to protect from the symlink race.

> Give your users their own /tmp. No kernel mods, no misbehaviours, no
> weirdomatic path walking hackery. No kernel patch needed that I can see.

Some real applications expect to share /tmp (e.g. "screen").  Splitting up
/tmp for every user isn't quickly feasible and requires every distro
change.  I would note that separate /tmp also breaks the hypothetical
binary game if it really is required to follow cross-uid symlinks.

I know that for the VFS folks, this is not a popular patch.  I have no
illusions there, but I want to find a kernel solution that is acceptable.
Fixing this in the kernel is trivial.  Fixing this in userspace is not
trivial -- it requires that every distro change the very semantics of
how /tmp works.  I can't say that's a bad idea, but I can say that
it will not be globally successful.  This kernel changes breaks no
applications, and fixes a whole class of problem forever, is small,
and has well-defined rules.

I would prefer it be solved at the VFS layer.  Doing it in commoncaps
is possible (and is even what I proposed), but I want to avoid having
everyone punt this patch around to different subsystem maintainers.

It's a real problem. I have proposed a real solution. If it's not okay,
I'd like to see an alternative solution that you're comfortable with
that fixes it to the same global scope.  (i.e. not userspace or tied to
a specific LSM.)

Thanks,

-Kees

-- 
Kees Cook
Ubuntu Security Team
