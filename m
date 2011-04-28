Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab1D1O4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:56:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932904Ab1D1O4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:56:50 -0400
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is and
 how it works.
From: Eric Paris <eparis@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, agl@chromium.org, jmorris@namei.org,
        rostedt@goodmis.org, Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 28 Apr 2011 10:56:09 -0400
In-Reply-To: <20110428070636.GC952@elte.hu>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	 <1303960136-14298-4-git-send-email-wad@chromium.org>
	 <20110428070636.GC952@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1304002571.2101.38.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 09:06 +0200, Ingo Molnar wrote:
> * Will Drewry <wad@chromium.org> wrote:
> 
> > +A collection of filters may be supplied via prctl, and the current set of
> > +filters is exposed in /proc/<pid>/seccomp_filter.
> > +
> > +For instance,
> > +  const char filters[] =
> > +    "sys_read: (fd == 1) || (fd == 2)\n"
> > +    "sys_write: (fd == 0)\n"
> > +    "sys_exit: 1\n"
> > +    "sys_exit_group: 1\n"
> > +    "on_next_syscall: 1";
> > +  prctl(PR_SET_SECCOMP, 2, filters);
> > +
> > +This will setup system call filters for read, write, and exit where reading can
> > +be done only from fds 1 and 2 and writing to fd 0.  The "on_next_syscall" directive tells
> > +seccomp to not enforce the ruleset until after the next system call is run.  This allows
> > +for launchers to apply system call filters to a binary before executing it.
> > +
> > +Once enabled, the access may only be reduced.  For example, a set of filters may be:
> > +
> > +  sys_read: 1
> > +  sys_write: 1
> > +  sys_mmap: 1
> > +  sys_prctl: 1
> > +
> > +Then it may call the following to drop mmap access:
> > +  prctl(PR_SET_SECCOMP, 2, "sys_mmap: 0");
> 
> Ok, color me thoroughly impressed

Me too!

> I've Cc:-ed Linus and Andrew: are you guys opposed to such flexible, dynamic 
> filters conceptually? I think we should really think hard about the actual ABI 
> as this could easily spread to more applications than Chrome/Chromium.

I'll definitely port QEMU to use this new interface rather than my more
rigid flexible (haha "rigid flexible") seccomp.  I'll see if I run into
any issues with this ABI in that porting...

> Btw., i also think that such an approach is actually the sane(r) design to 
> implement security modules: using such filters is far more flexible than the 
> typical LSM approach of privileged user-space uploading various nasty objects 
> into kernel space and implementing silly (and limited and intrusive) hooks 
> there, like SElinux and the other security modules do.

Then you are wrong.  There's no question that this interface can provide
great extensions to the current discretionary functionality provided by
legacy security controls but if you actually want to mediate what tasks
can do to other tasks or can do to arbitrary objects on the system this
doesn't cut it.  Every system call that takes or uses a structure as an
argument or that uses copy_from_user (for something other than just
unparsed data) is uncontrollable.

This approach is great and with careful coding of userspace apps can be
made very useful in constraining those apps, but a replacement for
mandatory access control it is not.

> This approach also has the ability to become recursive (gets inherited by child 
> tasks, which could add their own filters) and unprivileged - unlike LSMs.

LSMs have that ability.  There's nothing to prevent a module loading
service to allow unpriv applications to further constrain themselves.
It's just the different between DAC and MAC.  You are clearly a DAC guy,
and there is no question this change is great in that mindset,  but you
don't seem to understand either the flexibility of the LSM or the
purpose of some of the modules implemented on top of the LSM.

> I like this *a lot* more than any security sandboxing approach i've seen 
> before.

I like this *a lot*.  It will be a HUGE addition to the security
sandboxing approaches I've seen before.

-Eric

