Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab1IHX3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:29:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269Ab1IHX3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:29:45 -0400
Subject: Why I want PTRACE_O_TRACESTOP option
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 08 Sep 2011 18:50:01 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1315500802.18043.45.camel@dhcp-25-63.brq.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing that rationale behind my proposal to turn PT_SEIZED bit
into an ordinary ptrace option is not well understood,
I need to explain it better.

A bit of history I gleaned by comparing old kernels.

In the time immemorial, in pre-2.4.0 days, someone added
PTRACE_SETOPTIONS, as an architecture-specific ptrace op,
with a single option bit, PTRACE_O_TRACESYSGOOD == 1 (bit 0).
In 2.4.0, only i386, mips64, sh supported it.

In other words, someone introduced PTRACE_SETOPTIONS as
a fix for one of ptrace problems (namely, for the problem
that syscall stop is not distinguishable from SIGTRAP).

In 2.4.x kernels and in 2.5 until 2.5.45 inclusive,
more architectures copied this code, but no new options
were introduced.

Then Daniel Jacobowitz in 2002 consolidated cut-n-paste
code - made archtecture-independent PTRACE_SETOPTIONS
(that's why there is PTRACE_OLDSETOPTIONS - arch-dependent
ops have different range assigned to them), and added new
option bits: PTRACE_O_TRACEFORK, PTRACE_O_TRACEVFORK,
PTRACE_O_TRACECLONE, PTRACE_O_TRACEEXEC. (He did more
than this, but I track history of ptrace options here).
https://lkml.org/lkml/2002/9/18/291
https://lkml.org/lkml/2002/9/18/293
https://lkml.org/lkml/2002/9/18/294
These option bits took bit positions 1,2,3,4.
Corresponding generated PTRACE_EVENTs have values 1,2,3,4.
These options made it easier to catch children
of ptraced processes, and to suppress notorious
post-execve SIGTRAP.
These changes went into 2.5.46.

In 2003, Daniel added two more options - see
https://lkml.org/lkml/2003/2/6/160 -
PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT.
Naturally, they took bits 5 and 6,
and corresponding PTRACE_EVENTs have values 5 and 6.
These options made it possible to examine process state
at exit, and to know when it's safe to reinsert breakpoints
into vfork parent.
These changes went into 2.5.60.

Now we came and decided to tackle next batch of ptrace bugs:
non-working group-stops and SIGSTOP races on (auto-)attach.
Second bug can't be fixed by PTRACE_SETOPTIONS, so we had to add
new attach command, PTRACE_SEIZE. We also added a new event,
PTRACE_EVENT_STOP, which took on next available value, 7.
Feeling emboldened, we hooked new group-stop machinery to the same
internal PT_SEIZE bit which indicates that tracee was seized,
instead of adding an option, as people before us did.

Consider what will happen when a next ptrace fix will require
a way to change ptrace API at runtime. A new option will likely
be introduced, say, PTRACE_O_TRACEPONY, with next available
bit position 7, and perhaps some new event will be generated,
PTRACE_EVENT_PONY, with value.... yes, it can't be 7,
PTRACE_EVENT_STOP took it. So it will probably be 8.

Which will look illogical. Why bit position doesn't match event value?
Why PTRACE_SEIZE people decided to be special and broke
established pattern of matching option bits and event values?

Of course, by that time it will be too late to fix it!


That's why I propose to not go down that path. Instead, try to match
the previous pattern of ptrace evolution more closely. Do not introduce
hidden PT_SEIZE bit. Instead, introduce just another option bit with bit
position 7. Since setting options on attach is needed anyway
and we are going to implement it in PTRACE_SEIZE, the "SIGSTOP races on
(auto-)attach can't be fixed by PTRACE_SETOPTIONS" problem no longer
exists: we _can_ set this new option on attach now.

That's how I ended up with the proposal to introduce option
PTRACE_O_TRACESTOP = (1 << 7) which matches PTRACE_EVENT_STOP = 7 we
already added.

I do not do it specifically in order to make fixed group-stop behavior
settable by PTRACE_SETOPTIONS too (even though this will be a side
effect of proposed change). In fact, in light of possible races on API
switch I think we should recommend to userspace to set all options
at attach time, via PTRACE_SEIZE. I believe even today there are races
already: setting PTRACE_O_TRACEEXEC can race with post-execve SIGTRAP
generation, for example. We won't be introducing a new problem.


Is my proposal clearer now? What do you guys think?

-- 
vda


