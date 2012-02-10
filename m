Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab2BJCwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 21:52:06 -0500
Received: from mail2.shareable.org ([80.68.89.115]:47036 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab2BJCwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 21:52:04 -0500
Date: Fri, 10 Feb 2012 02:51:14 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
        Andrew Lutomirski <luto@mit.edu>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
Message-ID: <20120210025114.GA8390@jl-vm1.vm.bytemark.co.uk>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <20120125193635.GA30311@redhat.com>
 <201201260032.57937.vda.linux@googlemail.com>
 <20120126184438.GA25629@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120126184438.GA25629@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 01/26, Denys Vlasenko wrote:
> >
> > On Wednesday 25 January 2012 20:36, Oleg Nesterov wrote:
> > >
> > > We can add the new events,
> > >
> > > 	PTRACE_EVENT_SYSCALL_ENTRY
> > > 	PTRACE_EVENT_SYSCALL_COMPAT_ENTRY
> > > 	PTRACE_EVENT_SYSCALL_EXIT
> > > 	PTRACE_EVENT_SYSCALL_COMPAT_EXIT
> >
> > We can get away with just the first one.
> > (1) It's unlikely people would want to get native sysentry events but not compat ones,
> > thus first two options can be combined into one;
> 
> Confused... Sure, we need the single option, or we could even report
> this unconditionally if PT_SEIZED.
> 
> I meant the different PTRACE_EVENT_* codes only.
> 
> > (2) syscall exit compat-ness is known from entry type - no need to indicate it; and
> > (3) if we would flag syscall entry with an event value in wait status, then syscall
> > exit will be already distinquisable.
> 
> Well, if we add _ENTRY then it looks more consistent to report _EXIT
> as well even if it is not that useful.
> 
> Doesn't matter. Nobody seem to like this, and afaics Linus has the
> good arguments against the arch-independent "consolidation".

Regarding distinction between ENTRY/EXIT:

  I agree only a buggy kernel should get out of sync, but are we sure
  the kernel is never buggy, and wouldn't this be nice protection, and
  an excuse for strace to drop the heuristics it currently does for
  this condition?

  The behaviour from fork() appears to have changed.  (This is from
  reading kernel code, I'm too lazy to try out old kernels.)  If I
  read correctly, before 2.5.35, Linux returned an EXIT event first to
  a child process if CLONE_PTRACE was used, and then it didn't, and
  then from 2.5.46 the tracer's use of PTRACE_EVENT_* determines if it
  does or not.

  So it's not surprising strace has heuristics... shame they're buggy
  (sigreturn can look like anything).

  Anyway, PTRACE_EVENT_* for syscall entry/exit just look prettier!

Regarding ABI indication:

  At least with new syscalls, a tracer that doesn't know about them
  will see they're unrecognised; whereas a different ABI sometimes
  looks like an innocent syscall so can trick the tracer.

  However the argument for putting this in register state that goes
  into core dumps and checkpoint/restart state instead is pretty good.

  I don't have a strong opinion.  It's unfortunate that the current
  method not only makes it easy to subvert a ptracer, it makes
  ptracing slow and racy on archs where it has to read the syscall
  instruction.  (Weirdly that includes ARM, despite ARM using a
  register these days and having a ptrace option to set, but not read,
  the syscall number).

  That really is an argument for making sure all archs have the
  syscall number and, if necessary, the type of syscall entry point,
  somewhere in the register set.

All the best,
-- Jamie
