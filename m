Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0EaSCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 14:02:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53079 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754073Ab0EaSCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 14:02:32 -0400
Date: Mon, 31 May 2010 19:09:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <kees.cook@canonical.com>
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
Message-ID: <20100531190936.03076096@lxorguk.ukuu.org.uk>
In-Reply-To: <20100531175008.GC4098@outflux.net>
References: <20100531030402.GQ6056@outflux.net>
	<20100531112314.373b0f26@lxorguk.ukuu.org.uk>
	<20100531175008.GC4098@outflux.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010 10:50:08 -0700
Kees Cook <kees.cook@canonical.com> wrote:

> Hi Alan,
> 
> On Mon, May 31, 2010 at 11:23:14AM +0100, Alan Cox wrote:
> > 1.We have things like SELinux so you can write rules to bound apps
> >   which should be able to do this, if not then we should fix the security
> >   policy to generally solve it
> 
> This requires that policy be written for all applications ever, which isn't
> feasible.

Wrong, you can write a generic policy then write exceptions.

> > 2. If it worries you that much then you can *fix* /tmp/ for good using
> > the work Al Viro did years ago on mountpoints. Give people their
> > own /tmp. End of problem.
> 
> This has the same flaws in interoperability that you mention below for
> hypothetical binary games.

Not that I can see - please explain.

> nasty side-effect of making all my applications fail.  This patch isn't
> that intrusive.  :)

I would disagree there, and it seems Christoph and others likjewise.

> I do not believe there are any applications that depend on following
> symlinks in sticky world-writable directories.  Besides, just because
> something lacks source doesn't mean I can't change its behavior via binary
> editing or LD_PRELOAD.  I do not feel that non-existent hypothetical
> applications needing this feature is a sufficient reason to reject the
> patch.

Maybe you are right - but you can do this without a kernel patch or as a
security module and leave the rest of the kernel alone.

> Yes, everything is buggy -- I am seeking to solve a specific class
> of security issue so that those bugs don't turn into an more serious problem.
> One that has been fully solved with no known bad side-effects in a
> hand-full of distros for possibly more than 10 years now.

Plan 9 solved this years ago. Linux added the necessary per user /tmp (or
per session /tmp if you prefer) support years ago.

> > > +		printk_ratelimited(KERN_NOTICE "non-matching-uid symlink "
> > > +			"following attempted in sticky-directory by "
> > > +			"%s (fsuid %d)\n", current->comm, cred->fsuid);
> > 
> > This is of minimal use - current->comm is arbitary and user controlled.
> 
> It's used strictly for reporting.  I'm open to other suggestions -- I just
> want to give a system admin some information in the case where an
> application is being attacked with /tmp symlink races.

current->comm can be a random mess of control codes, it could include a
newline to fool the printk paths. You don't printk user provided
untrusted bits...

> This should specifically ignore DAC override.  In most cases, it is root we
> are trying to protect from the symlink race.

So how does root override the DAC override ignore when she needs to ?

> 
> > Give your users their own /tmp. No kernel mods, no misbehaviours, no
> > weirdomatic path walking hackery. No kernel patch needed that I can see.
> 
> Some real applications expect to share /tmp (e.g. "screen").  Splitting up
> /tmp for every user isn't quickly feasible and requires every distro
> change.  I would note that separate /tmp also breaks the hypothetical
> binary game if it really is required to follow cross-uid symlinks.

I've yet to meet a game that tries to share a /tmp file across users.

> Fixing this in the kernel is trivial.  Fixing this in userspace is not
> trivial -- it requires that every distro change the very semantics of
> how /tmp works.  I can't say that's a bad idea, but I can say that
> it will not be globally successful.  This kernel changes breaks no
> applications, and fixes a whole class of problem forever, is small,
> and has well-defined rules.

At best you fix one of a zillion /tmp problems and corner cases from
rootfs cross linking into /var/mail to quota avoidance. Putting /tmp into
a per user context fixes the lot (and doesn't break screen for users).

> I would prefer it be solved at the VFS layer.  Doing it in commoncaps
> is possible (and is even what I proposed), but I want to avoid having
> everyone punt this patch around to different subsystem maintainers.

You can do it in an existing LSM, you can write your own new LSM if you
want. This is why we have LSM hooks.

> It's a real problem. I have proposed a real solution. If it's not okay,
> I'd like to see an alternative solution that you're comfortable with
> that fixes it to the same global scope.  (i.e. not userspace or tied to
> a specific LSM.)

The fact you can do it already rather clearly says your patch is not
needed. If you must do it then write your own Ubuntu LSM, that way nobody
has to care. If you want to actually *fix* /tmp then you want a per
login user or per session /tmp. A per session /tmp does confuse a few
things, a per login user tmp works nicely. About the only thing you do
need to tweak slightly is the gdm/kdm handing off of the session - both
to do the mount and to migrate the X socket into it.

Alan
