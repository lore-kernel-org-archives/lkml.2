Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2LDI60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:58:26 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35771 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab2LDI6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:58:22 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 00/10] CPU hotplug: stop_machine()-free CPU hotplug
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org
Cc: sbw@mit.edu, tj@kernel.org, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, srivatsa.bhat@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2012 14:23:02 +0530
Message-ID: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120408-5816-0000-0000-000005AC3567
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
stop_machine()-free CPU hotplug.

Overview of the patches:
-----------------------

Patch 1 introduces the new APIs that can be used from atomic context, to
prevent CPUs from going offline.

Patches 2 to 6 convert various call-sites to use the new APIs.

Patches 7, 8 and 9 fix a KVM issue that comes into picture when we remove
stop_machine() from the CPU hotplug path. (Actually, patches 7 and 8 are
already in the kvm tree. Patch 9 is the fix we need, but I preserved the
other 2 as well so that the patches can apply easily without external
dependencies).

Patch 10 is the one which actually removes stop_machine() from the CPU
offline path.

Comments and suggestions welcome!

--
 Michael Wang (2):
      CPU hotplug: Introduce "stable" cpu online mask, for atomic hotplug readers
      smp, cpu hotplug: Fix smp_call_function_*() to prevent CPU offline properly

Paul E. McKenney (1):
      cpu: No more __stop_machine() in _cpu_down()

Srivatsa S. Bhat (4):
      smp, cpu hotplug: Fix on_each_cpu_*() to prevent CPU offline properly
      sched, cpu hotplug: Use stable online cpus in try_to_wake_up() & select_task_rq()
      kick_process(), cpu-hotplug: Prevent offlining of target CPU properly
      yield_to(), cpu-hotplug: Prevent offlining of other CPUs properly

Xiao Guangrong (3):
      KVM: VMX: fix invalid cpu passed to smp_call_function_single
      KVM: VMX: fix memory order between loading vmcs and clearing vmcs
      KVM: VMX: fix unsyc vmcs status when cpu is going down


  arch/x86/kvm/vmx.c      |   32 ++++++++++-
 include/linux/cpu.h     |    4 +
 include/linux/cpumask.h |    5 ++
 kernel/cpu.c            |  138 ++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/core.c     |   28 +++++++---
 kernel/smp.c            |   84 +++++++++++++++++------------
 6 files changed, 246 insertions(+), 45 deletions(-)



Thanks,
Srivatsa S. Bhat
IBM Linux Technology Center

