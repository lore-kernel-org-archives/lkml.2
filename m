Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423386Ab2LGRjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 12:39:22 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:60692 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423089Ab2LGRjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 12:39:19 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 0/9] CPU hotplug: stop_machine()-free CPU hotplug
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        oleg@redhat.com
Cc: sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        srivatsa.bhat@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 07 Dec 2012 23:07:45 +0530
Message-ID: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120717-5564-0000-0000-000005AFF20D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset removes CPU hotplug's dependence on stop_machine() from the CPU
offline path and provides an alternative (set of APIs) to preempt_disable() to
prevent CPUs from going offline, which can be invoked from atomic context.

This is an RFC patchset with only a few call-sites of preempt_disable()
converted to the new APIs for now, and the main goal is to get feedback on the
design of the new atomic APIs and see if it serves as a viable replacement for
stop_machine()-free CPU hotplug. A brief description of the algorithm is
available in the "Changes in vN" section.

Overview of the patches:
-----------------------

Patch 1 introduces the new APIs that can be used from atomic context, to
prevent CPUs from going offline.

Patch 2 is a cleanup; it converts preprocessor macros to static inline
functions.

Patches 3 to 8 convert various call-sites to use the new APIs.

Patch 9 is the one which actually removes stop_machine() from the CPU
offline path.

Changes in v3:
--------------
* Dropped the _light() and _full() variants of the APIs. Provided a single
  interface: get/put_online_cpus_atomic().

* Completely redesigned the synchronization mechanism again, to make it
  fast and scalable at the reader-side in the fast-path (when no hotplug
  writers are active). This new scheme also ensures that there is no
  possibility of deadlocks due to circular locking dependency.
  In summary, this provides the scalability and speed of per-cpu rwlocks
  (without actually using them), while avoiding the downside (deadlock
  possibilities) which is inherent in any per-cpu locking scheme that is
  meant to compete with preempt_disable()/enable() in terms of flexibility.

  The problem with using per-cpu locking to replace preempt_disable()/enable
  was explained here:
  https://lkml.org/lkml/2012/12/6/290

  Basically we use per-cpu counters (for scalability) when no writers are
  active, and then switch to global rwlocks (for lock-safety) when a writer
  becomes active. It is a slightly complex scheme, but it is based on
  standard principles of distributed algorithms.

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

Links to previous versions:
v2: https://lkml.org/lkml/2012/12/5/322
v1: https://lkml.org/lkml/2012/12/4/88

Comments and suggestions welcome!

--
 Paul E. McKenney (1):
      cpu: No more __stop_machine() in _cpu_down()

Srivatsa S. Bhat (8):
      CPU hotplug: Provide APIs to prevent CPU offline from atomic context
      CPU hotplug: Convert preprocessor macros to static inline functions
      smp, cpu hotplug: Fix smp_call_function_*() to prevent CPU offline properly
      smp, cpu hotplug: Fix on_each_cpu_*() to prevent CPU offline properly
      sched, cpu hotplug: Use stable online cpus in try_to_wake_up() & select_task_rq()
      kick_process(), cpu-hotplug: Prevent offlining of target CPU properly
      yield_to(), cpu-hotplug: Prevent offlining of other CPUs properly
      kvm, vmx: Add atomic synchronization with CPU Hotplug


  arch/x86/kvm/vmx.c  |    8 +-
 include/linux/cpu.h |    8 +-
 kernel/cpu.c        |  254 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/core.c |   22 ++++
 kernel/smp.c        |   63 ++++++++-----
 5 files changed, 321 insertions(+), 34 deletions(-)



Thanks,
Srivatsa S. Bhat
IBM Linux Technology Center

