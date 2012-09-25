Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab2IYKgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:36:33 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57719 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab2IYKgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:36:31 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/3] Create sched_select_cpu() and use it in workqueues
Date: Tue, 25 Sep 2012 16:06:05 +0530
Message-Id: <cover.1348568074.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <viresh.kumar@linaro.org>
References: <viresh.kumar@linaro.org>
X-OriginalArrivalTime: 25 Sep 2012 10:36:26.0179 (UTC) FILETIME=[9D6D0130:01CD9B09]
X-MC-Unique: 112092511362903501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8PAabb9025564

In order to save power, it would be useful to schedule work onto non-IDLE cpus
instead of waking up an IDLE one.

To achieve this, we need scheduler to guide kernel frameworks (like: timers &
workqueues) on which is the most preferred CPU that must be used for these
tasks.

This patchset is about implementing this concept.

The first patch adds sched_select_cpu() routine which returns the preferred cpu
which is non-idle. It accepts max level of sched domain, upto which we can
choose a CPU from. It can accept following options: SD_SIBLING, SD_MC, SD_BOOK,
SD_CPU or SD_NUMA.

Second and Third patch are about adapting this change in workqueue framework.

Earlier discussions over this concept were done at last LPC:
http://summit.linuxplumbersconf.org/lpc-2012/meeting/90/lpc2012-sched-timer-workqueue/

Figures:
--------

Test case 1:
- Performed on TC2 with ubuntu-devel
- Boot TC2 and run
 $ trace-cmd record -e workqueue_execute_start

This will trace only the points, where the work actually runs.

Do, this for 150 seconds.

Results:
---------
Domain 0: CPU 0-1
Domain 1: CPU 2-4


Base Kernel: Without my modifications:
-------------------------------------

CPU             No. of works run by CPU
-----           -----------------------
CPU0:           7
CPU1:           445
CPU2:           444
CPU3:           315
CPU4:           226


With my modifications:
----------------------

CPU             No. of works run by CPU
----            -----------------------
CPU0:           31
CPU2:           797
CPU3:           274
CPU4:           86


Test case 2:
-----------
I have created a small module, which does following:
- Create one work for each CPU (using queue_work_on(), so must schedule on that
  cpu)
- Above work, will queue "n" works for each cpu with queue_work(). These works
  are tracked within the module and results are printed at the end.

This gave similar results, with n ranging from 10 to 1000.

Viresh Kumar (3):
  sched: Create sched_select_cpu() to give preferred CPU for power
    saving
  workqueue: create __flush_delayed_work to avoid duplicating code
  workqueue: Schedule work on non-idle cpu instead of current one

 arch/arm/Kconfig      | 11 +++++++
 include/linux/sched.h | 11 +++++++
 kernel/sched/core.c   | 88 +++++++++++++++++++++++++++++++++++++++------------
 kernel/workqueue.c    | 36 ++++++++++++++-------
 4 files changed, 115 insertions(+), 31 deletions(-)

-- 
1.7.12.rc2.18.g61b472e


