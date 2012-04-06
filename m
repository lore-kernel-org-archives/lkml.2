Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab2DFHPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:15:13 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51199 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab2DFHPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:15:11 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Subject: [RFC][PATCH 00/16] sched: SCHED_DEADLINE v4
Date: Fri,  6 Apr 2012 09:14:25 +0200
Message-Id: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

This is the take 4 for the SCHED_DEADLINE patchset.

Just to recap, the patchset introduces a new deadline based real-time
task scheduling policy --called SCHED_DEADLINE-- with bandwidth
isolation (aka "resource reservation") capabilities. It now supports
global/clustered multiprocessor scheduling through dynamic task
migrations.


 From the previous releases[1]:
  - all the comments and the fixes coming from the reviews we got have
    been considered and applied;
  - better handling of rq selection for dynamic task migration, by means
    of a cpupri equivalent for -deadline tasks (cpudl). The mechanism
    is simple and straightforward, but showed nice performance figures[2].
  - this time we sit on top of PREEMPT_RT (3.2.13-rt23); we continue to aim
    at mainline inclusion, but we also see -rt folks as immediate and
    interested users.

Still missing/incomplete:
  - (c)group based bandwidth management, and maybe scheduling. It seems
    some more discussion on what precisely we want is *really* needed
    for this point;
  - bandwidth inheritance (to replace deadline/priority inheritance).
    What's in the patchset is just very few more than a simple
    placeholder. More discussion on the right way to go is needed here.
    Some work has already been done, but it is still not ready for
    submission.

The development is taking place at:
   https://github.com/jlelli/sched-deadline

Check the repositories frequently if you're interested, and feel free to
e-mail me for any issue you run into.

Furthermore, we developed an application that you can use to test this
patchset:
  https://github.com/gbagnoli/rt-app 

We also set up a development mailing list: linux-dl[3].
You can subscribe from here:
http://feanor.sssup.it/mailman/listinfo/linux-dl
or via e-mail (send a message to linux-dl-request@retis.sssup.it with
just the word `help' as subject or in the body to receive info).

As already discussed we are planning to merge this work with the EDF
throttling patches [https://lkml.org/lkml/2010/2/23/239] but we still are in
the preliminary phases of the merge and we intend to use the feedback to this
post to help us decide on the direction it should take.

As said, patchset is on top of PREEMPT_RT (as of today). However, Insop
Song (from Ericsson) is maintaining a parallel branch for the current
tip/master (https://github.com/insop/sched-deadline2). Ericsson is in fact
evaluating the use of SCHED_DEADLINE for CPE (Customer Premise Equipment)
devices in order to reserve CPU bandwidth to processes.

The code was being jointly developed by ReTiS Lab (http://retis.sssup.it)
and Evidence S.r.l (http://www.evidence.eu.com) in the context of the ACTORS
EU-funded project (http://www.actors-project.eu). It is now also supported by
the S(o)OS EU-funded project (http://www.soos-project.eu/).
It has also some users, both in academic and applied research. Even if our
last release dates back almost a year we continued to get feedback
from Ericsson (see above), Wind River, Porto (ISEP), Trento and Malardalen
universities :-).

As usual, any kind of feedback is welcome and appreciated.

Thanks in advice and regards,

 - Juri

[1] http://lwn.net/Articles/376502, http://lwn.net/Articles/353797,
    http://lwn.net/Articles/412410
[2] http://retis.sssup.it/~jlelli/papers/Ospert11Lelli.pdf
[3] from the first linux-dl message:
    -linux-dl should become the place where discussions about real-time
     deadline scheduling on Linux take place (not only SCHED_DEADLINE).
     We felt the lack of a place where we can keep in touch with each
     other; we are all working on the same things, but probably from
     different viewpoints, and this is surely a point of strength.
     Anyway, our efforts need to be organized in some way, or at least it
     is important to know on what everyone is currently working as to not
     end up with "duplicate-efforts".-

Dario Faggioli (10):
      sched: add extended scheduling interface.
      sched: SCHED_DEADLINE data structures.
      sched: SCHED_DEADLINE policy implementation.
      sched: SCHED_DEADLINE avg_update accounting.
      sched: add schedstats for -deadline tasks.
      sched: add resource limits for -deadline tasks.
      sched: add latency tracing for -deadline tasks.
      sched: drafted deadline inheritance logic.
      sched: add bandwidth management for sched_dl.
      sched: add sched_dl documentation.

Juri Lelli (3):
      sched: SCHED_DEADLINE SMP-related data structures.
      sched: SCHED_DEADLINE push and pull logic
      sched: speed up -dl pushes with a push-heap.

Harald Gustafsson (1):
      sched: add period support for -deadline tasks.

Peter Zijlstra (1):
      rtmutex: turn the plist into an rb-tree.

 Documentation/scheduler/sched-deadline.txt |  147 +++
 arch/arm/include/asm/unistd.h              |    3 +
 arch/arm/kernel/calls.S                    |    3 +
 arch/x86/ia32/ia32entry.S                  |    3 +
 arch/x86/include/asm/unistd_32.h           |    5 +-
 arch/x86/include/asm/unistd_64.h           |    6 +
 arch/x86/kernel/syscall_table_32.S         |    3 +
 include/asm-generic/resource.h             |    7 +-
 include/linux/init_task.h                  |   10 +
 include/linux/rtmutex.h                    |   18 +-
 include/linux/sched.h                      |  154 +++-
 include/linux/syscalls.h                   |    7 +
 kernel/Makefile                            |    1 +
 kernel/fork.c                              |    8 +-
 kernel/hrtimer.c                           |    2 +-
 kernel/rtmutex-debug.c                     |   10 +-
 kernel/rtmutex.c                           |  162 +++-
 kernel/rtmutex_common.h                    |   24 +-
 kernel/sched.c                             |  866 ++++++++++++++-
 kernel/sched_cpudl.c                       |  208 ++++
 kernel/sched_cpudl.h                       |   34 +
 kernel/sched_debug.c                       |   43 +
 kernel/sched_dl.c                          | 1585 ++++++++++++++++++++++++++++
 kernel/sched_rt.c                          |    3 +-
 kernel/sched_stoptask.c                    |    2 +-
 kernel/sysctl.c                            |   14 +
 kernel/trace/trace_sched_wakeup.c          |   41 +-
 kernel/trace/trace_selftest.c              |   30 +-
 28 files changed, 3266 insertions(+), 133 deletions(-)
