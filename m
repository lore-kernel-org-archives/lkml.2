Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab1ISVzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:55:12 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:12168 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab1ISVzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:55:09 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E77B96D.40101@am.sony.com>
Date: Mon, 19 Sep 2011 14:51:41 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: <tglx@linutronix.de>, <linux-rt-users@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] preempt-rt: convert blackfin boot_lock to raw
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The blackfin boot_lock is used by the secondary processor startup code.
The locking task is the idle thread, which has
idle->sched_class == &idle_sched_class.
idle_sched_class->enqueue_task == NULL, so if the idle task blocks on the
lock, the attempt to wake it when the lock becomes available will fail:

try_to_wake_up()
   ...
      activate_task()
         enqueue_task()
            p->sched_class->enqueue_task(rq, p, flags)

Fix by converting boot_lock to a raw spin lock.

This has not been compile or boot tested.  The fix was needed by arm, this
patch is for all other instances of "boot_lock" in other architectures.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 arch/blackfin/mach-bf561/smp.c |   10 	5 +	5 -	0 !
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: b/arch/blackfin/mach-bf561/smp.c
===================================================================
--- a/arch/blackfin/mach-bf561/smp.c
+++ b/arch/blackfin/mach-bf561/smp.c
@@ -13,7 +13,7 @@
 #include <asm/dma.h>
 #include <asm/time.h>
 
-static DEFINE_SPINLOCK(boot_lock);
+static DEFINE_RAW_SPINLOCK(boot_lock);
 
 /*
  * platform_init_cpus() - Tell the world about how many cores we
@@ -70,8 +70,8 @@ void __cpuinit platform_secondary_init(u
 
 	/* We are done with local CPU inits, unblock the boot CPU. */
 	set_cpu_online(cpu, true);
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
+	raw_spin_lock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 }
 
 int __cpuinit platform_boot_secondary(unsigned int cpu, struct task_struct *idle)
@@ -80,7 +80,7 @@ int __cpuinit platform_boot_secondary(un
 
 	printk(KERN_INFO "Booting Core B.\n");
 
-	spin_lock(&boot_lock);
+	raw_spin_lock(&boot_lock);
 
 	if ((bfin_read_SYSCR() & COREB_SRAM_INIT) == 0) {
 		/* CoreB already running, sending ipi to wakeup it */
@@ -101,7 +101,7 @@ int __cpuinit platform_boot_secondary(un
 
 	if (cpu_online(cpu)) {
 		/* release the lock and let coreb run */
-		spin_unlock(&boot_lock);
+		raw_spin_unlock(&boot_lock);
 		return 0;
 	} else
 		panic("CPU%u: processor failed to boot\n", cpu);

