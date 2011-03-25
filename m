Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1CYPxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:53:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37487 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab1CYPxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:53:30 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: Jens Axboe <jens.axboe@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>,
        Milton Miller <miltonm@bga.com>, WANG Cong <xiyou.wangcong@gmail.com>
Subject: [PATCH] generic-ipi: Initialize call_single_queue before enabling interrupt
Date: Fri, 25 Mar 2011 11:52:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: HidemaruMail 5.38 (WinNT,501)
Message-Id: <C7CBEB049FD464indou.takao@jp.fujitsu.com>
X-Antivirus: avast! (VPS 110325-0, 2011/03/25), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Actually this is a v2 patch but I post with new subject.
The first post is here.

[PATCH][KDUMP] Ignore spurious IPI
http://www.gossamer-threads.com/lists/linux/kernel/1356389

The problem I found is that kdump(2nd kernel) sometimes hangs up due to
pending IPI from 1st kernel. Kernel panic occurs because IPI comes
before call_single_queue is initialized, so this patch moves
init_call_single_data() so that it can be called before
local_irq_enable().

The details of the problem is below.

(1)
2nd kernel boot up

(2)
A pending IPI from 1st kernel comes after unmasking interrupts at the
following point.

asmlinkage void __init start_kernel(void)
{
(snip)
    time_init();
    profile_init();
    if (!irqs_disabled())
            printk(KERN_CRIT "start_kernel(): bug: interrupts were "
                             "enabled early\n");
    early_boot_irqs_disabled = false;
    local_irq_enable(); <=======================================HERE

(3)
Kernel tries to handle the interrupt, but call_single_queue is not
initialized yet at this point. As a result, in the
generic_smp_call_function_single_interrupt(), NULL pointer dereference
occurs when list_replace_init() tries to access &q->list.next.

Any comments would be appreciated.

Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
---
 include/linux/smp.h |    1 +
 init/main.c         |    1 +
 kernel/smp.c        |   18 +++++++++++-------
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 6dc95ca..0b81bba 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -114,6 +114,7 @@ int on_each_cpu(smp_call_func_t func, void *info, int wait);
 void smp_prepare_boot_cpu(void);
 
 extern unsigned int setup_max_cpus;
+void init_call_single_data(void);
 
 #else /* !SMP */
 
diff --git a/init/main.c b/init/main.c
index 33c37c3..02a7617 100644
--- a/init/main.c
+++ b/init/main.c
@@ -631,6 +631,7 @@ asmlinkage void __init start_kernel(void)
 		printk(KERN_CRIT "start_kernel(): bug: interrupts were "
 				 "enabled early\n");
 	early_boot_irqs_disabled = false;
+	init_call_single_data();
 	local_irq_enable();
 
 	/* Interrupts are enabled now so all GFP allocations are safe. */
diff --git a/kernel/smp.c b/kernel/smp.c
index 7cbd0f2..f119610 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -74,9 +74,19 @@ static struct notifier_block __cpuinitdata hotplug_cfd_notifier = {
 	.notifier_call		= hotplug_cfd,
 };
 
-static int __cpuinit init_call_single_data(void)
+static int __cpuinit init_hotplug_cfd(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
+
+	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
+	register_cpu_notifier(&hotplug_cfd_notifier);
+
+	return 0;
+}
+early_initcall(init_hotplug_cfd);
+
+void __init init_call_single_data(void)
+{
 	int i;
 
 	for_each_possible_cpu(i) {
@@ -85,13 +95,7 @@ static int __cpuinit init_call_single_data(void)
 		raw_spin_lock_init(&q->lock);
 		INIT_LIST_HEAD(&q->list);
 	}
-
-	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
-	register_cpu_notifier(&hotplug_cfd_notifier);
-
-	return 0;
 }
-early_initcall(init_call_single_data);
 
 /*
  * csd_lock/csd_unlock used to serialize access to per-cpu csd resources

