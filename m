Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760937Ab2EWVoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:44:23 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42266 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab2EWVoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:44:20 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com
Subject: [RFC][PATCH 00/15] sched: SCHED_DEADLINE v5
Date: Wed, 23 May 2012 23:42:40 +0200
Message-Id: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

This is the take 5 for the SCHED_DEADLINE patchset.

The patchset introduces a new deadline based real-time task scheduling
policy --called SCHED_DEADLINE-- with bandwidth isolation (aka "resource
reservation") capabilities. It supports global/clustered multiprocessor
scheduling through dynamic task migrations.

 From the previous releases[1]:
  - comments and fixes coming from the reviews we got have been considered
    and mostly applied; still awaiting:

     * Steven Rostedt's "take into account the RT tasks" when migrating DL
       tasks; the DL push/pull mechanism will probably see major changes
       (RT tasks accounting included) on which we are currently working;
     * Peter Zijlstra's "gcc work-around"; based on a not yet mainline
       accepted patch;
     * Peter Zijlstra's "unify the use of nr_cpus_allowed" suggestion was
       addressed too; however this changes too are based on a not yet
       merged patch.
 
  - this release is on top of tip/master (as of today), so the actual news is
    the rebase on v3.4 :-); anyway, -rt guys can find -rt branches on the
    repo (more info below);

  - first two patches are Peter Zijlstra's math128; later patches are a
    use-case for them.

Still missing/incomplete:
  - (c)group based bandwidth management, and maybe scheduling;
  - bandwidth inheritance (to replace deadline/priority inheritance);
  - access control for non-root users (and related security concerns to
    address).

The development is taking place at:
   https://github.com/jlelli/sched-deadline

The repo has been cleaned-up, main branches are now:

 - mainline-dl: tracking tip/master (raw commits);
 - linux-rt-dl: tracking -rt releases;
 - linux-stable-rt-dl: tracking Rostedt's 3.2-stable-rt branch[2];
 - sched-dl-V5: this patchset on top of tip/master.

Check the repositories frequently if you're interested, and feel free to
e-mail me for any issue you run into.

Test application:
  https://github.com/gbagnoli/rt-app 

Development mailing list: linux-dl; you can subscribe from here:
http://feanor.sssup.it/mailman/listinfo/linux-dl
or via e-mail (send a message to linux-dl-request@retis.sssup.it with
just the word `help' as subject or in the body to receive info).

There is also a parallel branch maintained by Insop Song (from Ericsson)
(https://github.com/insop/sched-deadline2). Ericsson is in fact evaluating
the use of SCHED_DEADLINE for CPE (Customer Premise Equipment) devices in
order to reserve CPU bandwidth to processes.

The code was being jointly developed by ReTiS Lab (http://retis.sssup.it)
and Evidence S.r.l (http://www.evidence.eu.com) in the context of the ACTORS
EU-funded project (http://www.actors-project.eu). It is now also supported by
the S(o)OS EU-funded project (http://www.soos-project.eu/).
It has also some users, both in academic and applied research. We got
positive feedbacks from Ericsson (see above), Wind River, Porto (ISEP), Trento,
Lund and Malardalen universities.

As usual, any kind of feedback is welcome and appreciated.

Thanks in advice and regards,

 - Juri

[1] http://lwn.net/Articles/376502, http://lwn.net/Articles/353797,
    http://lwn.net/Articles/412410, http://lwn.net/Articles/490944
[2] http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/README

Dario Faggioli (9):
      sched: add sched_class->task_dead.
      sched: add extended scheduling interface.
      sched: SCHED_DEADLINE structures & implementation.
      sched: SCHED_DEADLINE avg_update accounting.
      sched: add schedstats for -deadline tasks.
      sched: add latency tracing for -deadline tasks.
      sched: drafted deadline inheritance logic.
      sched: add bandwidth management for sched_dl.
      sched: add sched_dl documentation.

Peter Zijlstra (3):
      math128: Introduce various 128bit primitives
      math128, x86_64: Implement {mul,add}_u128 in 64bit asm
      rtmutex: turn the plist into an rb-tree.

Juri Lelli (2):
      sched: SCHED_DEADLINE SMP-related data structures & logic.
      sched: speed up -dl pushes with a push-heap.

Harald Gustafsson (1):
      sched: add period support for -deadline tasks.

 Documentation/scheduler/sched-deadline.txt |  164 +++
 arch/alpha/include/asm/Kbuild              |    1 +
 arch/arm/include/asm/Kbuild                |    1 +
 arch/arm/include/asm/unistd.h              |    3 +
 arch/arm/kernel/calls.S                    |    3 +
 arch/avr32/include/asm/Kbuild              |    1 +
 arch/blackfin/include/asm/Kbuild           |    1 +
 arch/c6x/include/asm/Kbuild                |    1 +
 arch/cris/include/asm/Kbuild               |    1 +
 arch/frv/include/asm/Kbuild                |    1 +
 arch/h8300/include/asm/Kbuild              |    1 +
 arch/hexagon/include/asm/Kbuild            |    1 +
 arch/ia64/include/asm/Kbuild               |    1 +
 arch/m32r/include/asm/Kbuild               |    1 +
 arch/m68k/include/asm/Kbuild               |    1 +
 arch/microblaze/include/asm/Kbuild         |    1 +
 arch/mips/include/asm/Kbuild               |    1 +
 arch/mn10300/include/asm/Kbuild            |    1 +
 arch/openrisc/include/asm/Kbuild           |    1 +
 arch/parisc/include/asm/Kbuild             |    1 +
 arch/powerpc/include/asm/Kbuild            |    1 +
 arch/s390/include/asm/Kbuild               |    1 +
 arch/score/include/asm/Kbuild              |    1 +
 arch/sh/include/asm/Kbuild                 |    1 +
 arch/sparc/include/asm/Kbuild              |    1 +
 arch/tile/include/asm/Kbuild               |    1 +
 arch/um/include/asm/Kbuild                 |    1 +
 arch/unicore32/include/asm/Kbuild          |    1 +
 arch/x86/include/asm/math128.h             |   39 +
 arch/x86/syscalls/syscall_32.tbl           |    3 +
 arch/x86/syscalls/syscall_64.tbl           |    3 +
 arch/xtensa/include/asm/Kbuild             |    1 +
 include/asm-generic/math128.h              |    4 +
 include/linux/init_task.h                  |   10 +
 include/linux/math128.h                    |  180 +++
 include/linux/rtmutex.h                    |   18 +-
 include/linux/sched.h                      |  155 ++-
 include/linux/syscalls.h                   |    7 +
 kernel/fork.c                              |    8 +-
 kernel/hrtimer.c                           |    2 +-
 kernel/rtmutex-debug.c                     |   10 +-
 kernel/rtmutex.c                           |  161 ++-
 kernel/rtmutex_common.h                    |   22 +-
 kernel/sched/Makefile                      |    4 +-
 kernel/sched/core.c                        |  689 +++++++++++-
 kernel/sched/cpudl.c                       |  208 ++++
 kernel/sched/cpudl.h                       |   33 +
 kernel/sched/debug.c                       |   46 +
 kernel/sched/dl.c                          | 1646 ++++++++++++++++++++++++++++
 kernel/sched/rt.c                          |    2 +-
 kernel/sched/sched.h                       |  143 +++
 kernel/sched/stop_task.c                   |    2 +-
 kernel/sysctl.c                            |   14 +
 kernel/trace/trace_sched_wakeup.c          |   44 +-
 kernel/trace/trace_selftest.c              |   30 +-
 lib/Makefile                               |    2 +-
 lib/math128.c                              |   40 +
 57 files changed, 3586 insertions(+), 135 deletions(-)
