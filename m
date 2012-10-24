Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422730Ab2JXVyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:54:51 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58575 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422696Ab2JXVyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:54:47 -0400
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
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org
Subject: [RFC][PATCH 00/16] sched: SCHED_DEADLINE v6
Date: Wed, 24 Oct 2012 14:53:38 -0700
Message-Id: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

This is the take 6 for the SCHED_DEADLINE patchset.

The patchset introduces a new deadline based real-time task scheduling
policy --called SCHED_DEADLINE-- with bandwidth isolation (aka "resource
reservation") capabilities. It supports global/clustered multiprocessor
scheduling through dynamic task migrations.

 From the previous releases[1]:
  - comments and fixes coming from the reviews we got have been considered
    and applied;

  - the use of nr_cpus_allowed has been unified;
 
  - this release is on top of tip/master (as of today), so this is also
    a rebase on top of 3.7-rc2;

  - patch 14/16 modifies real-time bandwidth management and makes dl_bw
    a subquota of rt_bw (comments on this are very welcome!);

  - tested on ARM (thanks to Claudio Scordino for testing and and patches).

(My) TODOs:
  - keep up with mainline (as usual);
  - rebase on top of 3.6.2-rt4 PREEMPT_RT patchset;
  - provide details and numbers about possible use-cases;
  - power aware scheduling for HMP (some code is there, but not yet
    ready for submission);
  - setup a website to collect all information regarding the project
    in just one single place.

The development is taking place at:
   https://github.com/jlelli/sched-deadline

Main branches:

 - mainline-dl: tracking tip/master (raw commits);
 - linux-rt-dl: tracking PREEMPT_RT releases (outdated);
 - sched-dl-V6: this patchset on top of tip/master.

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

Acknowledgements:
  I owe special thanks to Fabio Checconi and Dario Faggioli for technical (and
  moral :P) support. Thanks to Peter Zijlstra, Steven Rostedt and all the others
  that reviewed and/or contributed to improve the patchset quality. Thanks also
  to Insop Song for trying to give the project an "industrial" use case and to
  Claudio Scordino for testing and advertisement.

As usual, any kind of feedback is welcome and appreciated.

Thanks in advice and regards,

 - Juri

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

Harald Gustafsson (1):
  sched: add period support for -deadline tasks.

Juri Lelli (3):
  sched: SCHED_DEADLINE SMP-related data structures & logic.
  sched: make dl_bw a sub-quota of rt_bw
  sched: speed up -dl pushes with a push-heap.

Peter Zijlstra (3):
  math128: Introduce various 128bit primitives
  math128, x86_64: Implement {mul,add}_u128 in 64bit asm
  rtmutex: turn the plist into an rb-tree.

 Documentation/scheduler/sched-deadline.txt |  164 +++
 arch/alpha/include/asm/Kbuild              |    1 +
 arch/arm/include/asm/Kbuild                |    1 +
 arch/arm/include/asm/unistd.h              |    2 +-
 arch/arm/include/uapi/asm/unistd.h         |    3 +
 arch/arm/kernel/calls.S                    |    3 +
 arch/avr32/include/asm/Kbuild              |    2 +
 arch/blackfin/include/asm/Kbuild           |    1 +
 arch/c6x/include/asm/Kbuild                |    1 +
 arch/cris/include/asm/Kbuild               |    1 +
 arch/frv/include/asm/Kbuild                |    3 +
 arch/h8300/include/asm/Kbuild              |    1 +
 arch/hexagon/include/asm/Kbuild            |    1 +
 arch/ia64/include/asm/Kbuild               |    1 +
 arch/m32r/include/asm/Kbuild               |    1 +
 arch/m68k/include/asm/Kbuild               |    1 +
 arch/microblaze/include/asm/Kbuild         |    1 +
 arch/mips/include/asm/Kbuild               |    1 +
 arch/mn10300/include/asm/Kbuild            |    1 +
 arch/openrisc/include/asm/Kbuild           |    1 +
 arch/parisc/include/asm/Kbuild             |    2 +-
 arch/powerpc/include/asm/Kbuild            |    1 +
 arch/s390/include/asm/Kbuild               |    2 +-
 arch/score/include/asm/Kbuild              |    1 +
 arch/sh/include/asm/Kbuild                 |    1 +
 arch/sparc/include/asm/Kbuild              |    1 +
 arch/tile/include/asm/Kbuild               |    1 +
 arch/um/include/asm/Kbuild                 |    2 +-
 arch/unicore32/include/asm/Kbuild          |    1 +
 arch/x86/include/asm/Kbuild                |    1 +
 arch/x86/include/asm/math128.h             |   39 +
 arch/x86/syscalls/syscall_32.tbl           |    3 +
 arch/x86/syscalls/syscall_64.tbl           |    4 +-
 arch/xtensa/include/asm/Kbuild             |    1 +
 include/asm-generic/math128.h              |    4 +
 include/linux/init_task.h                  |   10 +
 include/linux/math128.h                    |  180 +++
 include/linux/rtmutex.h                    |   18 +-
 include/linux/sched.h                      |  152 ++-
 include/linux/syscalls.h                   |    7 +
 include/uapi/linux/sched.h                 |    1 +
 kernel/fork.c                              |    8 +-
 kernel/futex.c                             |    2 +
 kernel/hrtimer.c                           |    2 +-
 kernel/rtmutex-debug.c                     |   10 +-
 kernel/rtmutex.c                           |  163 ++-
 kernel/rtmutex_common.h                    |   22 +-
 kernel/sched/Makefile                      |    4 +-
 kernel/sched/core.c                        |  645 ++++++++++-
 kernel/sched/cpudl.c                       |  208 ++++
 kernel/sched/cpudl.h                       |   33 +
 kernel/sched/debug.c                       |   46 +
 kernel/sched/dl.c                          | 1650 ++++++++++++++++++++++++++++
 kernel/sched/rt.c                          |    2 +-
 kernel/sched/sched.h                       |  139 +++
 kernel/sched/stop_task.c                   |    2 +-
 kernel/sysctl.c                            |    7 +
 kernel/trace/trace_sched_wakeup.c          |   44 +-
 kernel/trace/trace_selftest.c              |   28 +-
 lib/Makefile                               |    2 +-
 lib/math128.c                              |   40 +
 61 files changed, 3555 insertions(+), 125 deletions(-)
 create mode 100644 Documentation/scheduler/sched-deadline.txt
 create mode 100644 arch/x86/include/asm/math128.h
 create mode 100644 include/asm-generic/math128.h
 create mode 100644 include/linux/math128.h
 create mode 100644 kernel/sched/cpudl.c
 create mode 100644 kernel/sched/cpudl.h
 create mode 100644 kernel/sched/dl.c
 create mode 100644 lib/math128.c

-- 
1.7.9.5

