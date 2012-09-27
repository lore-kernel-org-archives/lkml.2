Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab2I0JEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 05:04:42 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49416 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2I0JEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 05:04:40 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 0/3] Create sched_select_cpu() and use it in workqueues
Date: Thu, 27 Sep 2012 14:34:02 +0530
Message-Id: <cover.1348736069.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 27 Sep 2012 09:04:13.0146 (UTC) FILETIME=[104EABA0:01CD9C8F]
X-MC-Unique: 112092710041400901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8R94mgJ004056

Hi All,

This is V2 of my sched_select_cpu() work.

In order to save power, it would be useful to schedule work onto non-IDLE cpus
instead of waking up an IDLE one.

To achieve this, we need scheduler to guide kernel frameworks (like: timers &
workqueues) on which is the most preferred CPU that must be used for these
tasks.

This patchset is about implementing this concept.

- The first patch adds sched_select_cpu() routine which returns the preferred
  cpu which is non-idle. 
- Second patch removes idle_cpu() calls from timer & hrtimer.
- Third patch is about adapting this change in workqueue framework.

Earlier discussions over v1 can be found here:
http://www.mail-archive.com/linaro-dev@lists.linaro.org/msg13342.html

Earlier discussions over this concept were done at last LPC:
http://summit.linuxplumbersconf.org/lpc-2012/meeting/90/lpc2012-sched-timer-workqueue/

Module created for testing this behavior is present here:
http://git.linaro.org/gitweb?p=people/vireshk/module.git;a=summary

Following are the steps followed in test module:
1. Run single work on each cpu
2. This work will start a timer after x (tested with 10) jiffies of delay
3. Timer routine queues a work... (This may be called from idle or non-idle cpu)
   and starts the same timer again STEP 3 is done for n number of times (i.e.
   queuing n works, one after other)
4. All works will call a single routine, which will count following per cpu:
 - Total works processed by a CPU
 - Total works processed by a CPU, which are queued from it
 - Total works processed by a CPU, which aren't queued from it

Setup:
-----
- ARM Vexpress TC2 - big.LITTLE CPU
- Core 0-1: A15, 2-4: A7
- rootfs: linaro-ubuntu-nano

Results:
-------
Without Workqueue Modification, i.e. PATCH 3/3:
[ 2493.022335] Workqueue Analyser: works processsed by CPU0, Total: 1000, Own: 0, migrated: 0
[ 2493.047789] Workqueue Analyser: works processsed by CPU1, Total: 1000, Own: 0, migrated: 0
[ 2493.072918] Workqueue Analyser: works processsed by CPU2, Total: 1000, Own: 0, migrated: 0
[ 2493.098576] Workqueue Analyser: works processsed by CPU3, Total: 1000, Own: 0, migrated: 0
[ 2493.123702] Workqueue Analyser: works processsed by CPU4, Total: 1000, Own: 0, migrated: 0

With Workqueue Modification, i.e. PATCH 3/3:
[ 2493.022335] Workqueue Analyser: works processsed by CPU0, Total: 1002, Own: 999, migrated: 3
[ 2493.047789] Workqueue Analyser: works processsed by CPU1, Total: 998,  Own: 997, migrated: 1
[ 2493.072918] Workqueue Analyser: works processsed by CPU2, Total: 1013, Own: 996, migrated: 17
[ 2493.098576] Workqueue Analyser: works processsed by CPU3, Total: 998,  Own: 993, migrated: 5
[ 2493.123702] Workqueue Analyser: works processsed by CPU4, Total: 989,  Own: 987, migrated: 2

V1->V2
-----
- New SD_* macros removed now and earlier ones used
- sched_select_cpu() rewritten and it includes the check on current cpu's
  idleness.
- cpu_idle() calls from timer and hrtimer removed now.
- Patch 2/3 from V1, removed as it doesn't apply to latest workqueue branch from
  tejun.
- CONFIG_MIGRATE_WQ removed and so is wq_select_cpu()
- sched_select_cpu() called only from __queue_work()
- got tejun/for-3.7 branch in my tree, before making workqueue changes.

Viresh Kumar (3):
  sched: Create sched_select_cpu() to give preferred CPU for power
    saving
  timer: hrtimer: Don't check idle_cpu() before calling
    get_nohz_timer_target()
  workqueue: Schedule work on non-idle cpu instead of current one

 include/linux/sched.h | 16 ++++++++++--
 kernel/hrtimer.c      |  2 +-
 kernel/sched/core.c   | 69 +++++++++++++++++++++++++++++++--------------------
 kernel/timer.c        |  9 ++++---
 kernel/workqueue.c    |  2 +-
 5 files changed, 63 insertions(+), 35 deletions(-)

-- 
1.7.12.rc2.18.g61b472e


