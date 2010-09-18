Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab0IRTo6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:44:58 -0400
Received: from kroah.org ([198.145.64.141]:51610 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab0IRTCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:00 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:59 2010
Message-Id: <20100918185959.319261336@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Xiaotian Feng <dfeng@redhat.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [076/123] sched: Fix set_cpu_active() in cpu_down()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-fix-set_cpu_active-in-cpu_down.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <dfeng@redhat.com>

commit 9ee349ad6d326df3633d43f54202427295999c47 upstream

Sachin found cpu hotplug test failures on powerpc, which made
the kernel hang on his POWER box.

The problem is that we fail to re-activate a cpu when a
hot-unplug fails. Fix this by moving the de-activation into
_cpu_down after doing the initial checks.

Remove the synchronize_sched() calls and rely on those implied
by rebuilding the sched domains using the new mask.

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Tested-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170517.500272612@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/cpu.c |   24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -209,6 +209,7 @@ static int __ref _cpu_down(unsigned int
 		return -ENOMEM;
 
 	cpu_hotplug_begin();
+	set_cpu_active(cpu, false);
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
@@ -280,18 +281,6 @@ int __ref cpu_down(unsigned int cpu)
 		goto out;
 	}
 
-	set_cpu_active(cpu, false);
-
-	/*
-	 * Make sure the all cpus did the reschedule and are not
-	 * using stale version of the cpu_active_mask.
-	 * This is not strictly necessary becuase stop_machine()
-	 * that we run down the line already provides the required
-	 * synchronization. But it's really a side effect and we do not
-	 * want to depend on the innards of the stop_machine here.
-	 */
-	synchronize_sched();
-
 	err = _cpu_down(cpu, 0);
 
 out:
@@ -382,19 +371,12 @@ int disable_nonboot_cpus(void)
 		return error;
 	cpu_maps_update_begin();
 	first_cpu = cpumask_first(cpu_online_mask);
-	/* We take down all of the non-boot CPUs in one shot to avoid races
+	/*
+	 * We take down all of the non-boot CPUs in one shot to avoid races
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
 	cpumask_clear(frozen_cpus);
 
-	for_each_online_cpu(cpu) {
-		if (cpu == first_cpu)
-			continue;
-		set_cpu_active(cpu, false);
-	}
-
-	synchronize_sched();
-
 	printk("Disabling non-boot CPUs ...\n");
 	for_each_online_cpu(cpu) {
 		if (cpu == first_cpu)


