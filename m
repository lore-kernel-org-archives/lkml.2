Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0EaTKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:10:22 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58703 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173Ab0EaTKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:10:18 -0400
Date: Mon, 31 May 2010 12:07:54 -0700
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
Message-ID: <20100531190754.GF4098@outflux.net>
References: <20100531030402.GQ6056@outflux.net>
 <20100531112314.373b0f26@lxorguk.ukuu.org.uk>
 <20100531175008.GC4098@outflux.net>
 <20100531190936.03076096@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531190936.03076096@lxorguk.ukuu.org.uk>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 07:09:36PM +0100, Alan Cox wrote:
> On Mon, 31 May 2010 10:50:08 -0700
> Kees Cook <kees.cook@canonical.com> wrote:
> > On Mon, May 31, 2010 at 11:23:14AM +0100, Alan Cox wrote:
> > > 1.We have things like SELinux so you can write rules to bound apps
> > >   which should be able to do this, if not then we should fix the security
> > >   policy to generally solve it
> > 
> > This requires that policy be written for all applications ever, which isn't
> > feasible.
> 
> Wrong, you can write a generic policy then write exceptions.

This depends on your LSM.  And some people run with no LSM at all.

> > nasty side-effect of making all my applications fail.  This patch isn't
> > that intrusive.  :)
> 
> I would disagree there, and it seems Christoph and others likjewise.

I think there is a difference between "offensive" and "intrusive".  The
patch itself is about 4 lines of logic.  That in itself isn't intrusive.
But a lot of people (now and in the past) find the change in VFS semantics
offensive.  What I'd like to do is get people to really think about what
this change means -- it's blocking a specific pathological situation that
has no positive outcome.  If we can all agree "this needs to be fixed",
then we can work on a common solution.

> > I do not believe there are any applications that depend on following
> > symlinks in sticky world-writable directories.  Besides, just because
> > something lacks source doesn't mean I can't change its behavior via binary
> > editing or LD_PRELOAD.  I do not feel that non-existent hypothetical
> > applications needing this feature is a sufficient reason to reject the
> > patch.
> 
> Maybe you are right - but you can do this without a kernel patch or as a
> security module and leave the rest of the kernel alone.

I see this as a flaw in DAC.  As such, I'd like to see it fixed globally.

> Plan 9 solved this years ago. Linux added the necessary per user /tmp (or
> per session /tmp if you prefer) support years ago.

Right, I don't disagree on this point -- having per-user /tmp is great, but
it hasn't happened because it's not trivial.  I feel that fixing symlink
following and per-user /tmp are tangential issues, both worthy of being
fixed.  And I realize we disagree on this point.  :)

> > > This is of minimal use - current->comm is arbitary and user controlled.
> > 
> > It's used strictly for reporting.  I'm open to other suggestions -- I just
> > want to give a system admin some information in the case where an
> > application is being attacked with /tmp symlink races.
> 
> current->comm can be a random mess of control codes, it could include a
> newline to fool the printk paths. You don't printk user provided
> untrusted bits...

Right, of course.  I was, however, modelling this off of existing warnings,
though perhaps I didn't do it right.  Here is kernel/capabilities.c,
warn_legacy_capability_use():

                printk(KERN_INFO "warning: `%s' uses 32-bit capabilities"
                       " (legacy support in use)\n",
                       get_task_comm(name, current));

If this is unsafe, then all users of get_task_comm() should be audited.  I
had the impression that current->comm was sanitized very early... hm, it's
not.  It's sanitized for newlines in fs/proc/array.c task_name(), but not
by other callers.  Seems like the sanitizing should happen in
get_task_comm().  Thoughts?

> So how does root override the DAC override ignore when she needs to ?

By turning off the entire sysctl.  It's designed to protect privileged
users, so it doesn't make sense to have it be bypassed.

> I've yet to meet a game that tries to share a /tmp file across users.

Well, right, that was my point -- no such application needs to follow
symlinks in /tmp across users.  Such symlinks would be impossible to create
with per-user /tmp mounts.  So, if per-user /tmp is a viable solution to
symlink races, then so is denying cross-user symlink following.

> At best you fix one of a zillion /tmp problems and corner cases from
> rootfs cross linking into /var/mail to quota avoidance. Putting /tmp into
> a per user context fixes the lot (and doesn't break screen for users).

IIRC, screen, when setuid, allows users to share screen sessions (following
some system-defined ACLs) but it does it via the /tmp directory trees it
creates.  Per-user /tmp would break this (but yes, it's solvable using some
kind of /var/lib/screen which maybe even already exists).

> You can do it in an existing LSM, you can write your own new LSM if you
> want. This is why we have LSM hooks.

Right, I'm well aware of that.  I was hoping to solve this problem for all
Linux users, since it has no operational downside.

> The fact you can do it already rather clearly says your patch is not
> needed. If you must do it then write your own Ubuntu LSM, that way nobody
> has to care.

I'm slightly sensitive here, as people (hi Greg KH :P) like to take
pot-shots at Ubuntu sometimes, so apologies if I've misunderstood you.
For some reason you've specifically brought up Ubuntu, which makes me
wonder if this patch would have been received differently if I had sent
it from my personal email account.  Regardless, you seem to be saying
a few things, and I want to make sure I get it:

 1) "I don't want this change to symlink logic in the mainline kernel"
 2) "Go add it to Ubuntu only"
 3) "Nobody will care if Ubuntu carries this patch"

I'm hoping to change your mind about #1 -- it has no downsides and only has
benefits.

#2 is already done -- but my goal is to protect everyone else.  While a
large share of Linux users run an Ubuntu kernel, there are still a lot of
other people that will continue to suffer from this vulnerability, and I
have what I feel is a moral obligation to try to get this fixed globally.

For #3, if by "nobody" you mean "no Linux kernel developer", then
I think your opinion lack credence since I consider myself a Linux
kernel developer (not a huge one, but I do contribute).  And I do care
about this, obviously.  If by "nobody" you mean "nobody using Linux",
then I again think your opinion lacks credence since I've already had
a few people glad to see this fixed in Ubuntu.  That's more than zero
people, so not "nobody".  If instead, by "nobody" you mean "no Linux VFS
developer" than I'm just puzzled since that would imply that all Linux VFS
developers don't care about fixing this problem (which I can't believe).
Or at least they don't care if the semantics change, as long as it's
not in the VFS core, which also makes no sense to me.  Either the logic
changes or it doesn't.  And since it needs to be changed, it seems that
everyone should be working together to fix it.

If instead, you mean "if it's changed in an LSM, then VFS developers
don't have to think about it", then I remain puzzled, since it's so
clearly in need of being fixed.  What does it matter where it goes?

> If you want to actually *fix* /tmp then you want a per
> login user or per session /tmp. A per session /tmp does confuse a few
> things, a per login user tmp works nicely. About the only thing you do
> need to tweak slightly is the gdm/kdm handing off of the session - both
> to do the mount and to migrate the X socket into it.

I totally agree.  But I view it as tangential to solving symlink races
(even though it does address it, that solution is a much different
endeavour).

What is the path to take for having this change in the mainline kernel,
and LSM-agnostic?  I want to see it solved globally.

Thanks,

-Kees

-- 
Kees Cook
Ubuntu Security Team
