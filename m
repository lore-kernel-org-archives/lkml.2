Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab2LESoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:44:22 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:32900 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2LESoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:44:20 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 00/10][RESEND] CPU hotplug: stop_machine()-free CPU
 hotplug
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        oleg@redhat.com
Cc: sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        srivatsa.bhat@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 00:12:50 +0530
Message-ID: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120518-9574-0000-0000-000005A0A490
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resending because I forgot to CC lkml last time. Please send your replies to
this thread instead of the previous (non-public) one. Sorry for the trouble!]

Hi,

This patchset removes CPU hotplug's dependence on stop_machine() from the CPU
offline path and provides an alternative (set of APIs) to preempt_disable() to
prevent CPUs from going offline, which can be invoked from atomic context.

This is an RFC patchset with only a few call-sites of preempt_disable()
converted to the new APIs for now, and the main goal is to get feedback on the
design of the new atomic APIs and see if it serves as a viable replacement for
stop_machine()-free CPU hotplug.

Overview of the patches:
-----------------------

Patch 1 introduces the new APIs that can be used from atomic context, to
prevent CPUs from going offline. This set of APIs is for "light" atomic
hotplug readers (the term "light" is explained in the changelog/comments).

Patch 2 introduces the new APIs for "full" atomic hotplug readers.

Patch 3 is a cleanup; it converts preprocessor macros to static inline
functions.

Patches 4 to 9 convert various call-sites to use the new APIs.
(Patches 4 to 8 deal with "light" readers, patch 9 deals with a "full"
reader. Together, they demonstrate how to use these APIs effectively).

Patch 10 is the one which actually removes stop_machine() from the CPU
offline path.


Changes in v2:
-------------
* Completely redesigned the synchronization scheme to avoid using any extra
  cpumasks.

* Provided APIs for 2 types of atomic hotplug readers: "light" (for
  light-weight) and "full". We wish to have more "light" readers than
  the "full" ones, to avoid indirectly inducing the "stop_machine effect"
  without even actually using stop_machine().

  And the patches show that it _is_ generally true: 5 patches deal with
  "light" readers, whereas only 1 patch deals with a "full" reader.

  Also, the "light" readers happen to be in very hot paths. So it makes a
  lot of sense to have such a distinction and a corresponding light-weight
  API.

v1: https://lkml.org/lkml/2012/12/4/88

Comments and suggestions welcome!

--
 Paul E. McKenney (1):
      cpu: No more __stop_machine() in _cpu_down()

Srivatsa S. Bhat (9):
      CPU hotplug: Provide APIs for "light" atomic readers to prevent CPU offline
      CPU hotplug: Provide APIs for "full" atomic readers to prevent CPU offline
      CPU hotplug: Convert preprocessor macros to static inline functions
      smp, cpu hotplug: Fix smp_call_function_*() to prevent CPU offline properly
      smp, cpu hotplug: Fix on_each_cpu_*() to prevent CPU offline properly
      sched, cpu hotplug: Use stable online cpus in try_to_wake_up() & select_task_rq()
      kick_process(), cpu-hotplug: Prevent offlining of target CPU properly
      yield_to(), cpu-hotplug: Prevent offlining of other CPUs properly
      kvm, vmx: Add full atomic synchronization with CPU Hotplug


  arch/x86/kvm/vmx.c  |    8 ++-
 include/linux/cpu.h |   12 ++++-
 kernel/cpu.c        |  136 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/core.c |   22 +++++++-
 kernel/smp.c        |   64 +++++++++++++++---------
 5 files changed, 210 insertions(+), 32 deletions(-)



Thanks,
Srivatsa S. Bhat
IBM Linux Technology Center

