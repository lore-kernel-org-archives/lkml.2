Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab0LJMtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 07:49:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:44511 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762Ab0LJMtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 07:49:16 -0500
Date: Fri, 10 Dec 2010 12:48:55 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, penberg@kernel.org, gorcunov@gmail.com,
        tj@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, gorcunov@gmail.com
In-Reply-To: <4D00B3B9.7060702@kernel.org>
References: <4D00B3B9.7060702@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic-cleanups] x86: apic: Cleanup and simplify setup_local_APIC()
Message-ID: <tip-0aa002fe602939370e9476e5ec32b562000a0425@git.kernel.org>
Git-Commit-ID: 0aa002fe602939370e9476e5ec32b562000a0425
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Dec 2010 12:48:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0aa002fe602939370e9476e5ec32b562000a0425
Gitweb:     http://git.kernel.org/tip/0aa002fe602939370e9476e5ec32b562000a0425
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Thu, 9 Dec 2010 11:47:21 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 10 Dec 2010 13:46:26 +0100

x86: apic: Cleanup and simplify setup_local_APIC()

setup_local_APIC() is used to setup local APIC early during CPU
initialization and already assumes that preemption is disabled on
entry. However, The function unnecessarily disables and enables
preemption and uses smp_processor_id() multiple times in and out of
the nested preemption disabled section. This gives the wrong
impression that the function might be able to handle being called with
preemption enabled and/or migrated to another processor in the middle.

Make it clear that the function is always called with preemption
disabled, drop the confusing preemption disable block and call
smp_processor_id() once at the beginning of the function.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: brgerst@gmail.com
LKML-Reference: <4D00B3B9.7060702@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 8933936..c0f6426 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1195,12 +1195,15 @@ static void __cpuinit lapic_setup_esr(void)
 			oldvalue, value);
 }
 
-
 /**
  * setup_local_APIC - setup the local APIC
+ *
+ * Used to setup local APIC while initializing BSP or bringin up APs.
+ * Always called with preemption disabled.
  */
 void __cpuinit setup_local_APIC(void)
 {
+	int cpu = smp_processor_id();
 	unsigned int value, queued;
 	int i, j, acked = 0;
 	unsigned long long tsc = 0, ntsc;
@@ -1225,8 +1228,6 @@ void __cpuinit setup_local_APIC(void)
 #endif
 	perf_events_lapic_init();
 
-	preempt_disable();
-
 	/*
 	 * Double-check whether this APIC is really registered.
 	 * This is meaningless in clustered apic mode, so we skip it.
@@ -1342,21 +1343,19 @@ void __cpuinit setup_local_APIC(void)
 	 * TODO: set up through-local-APIC from through-I/O-APIC? --macro
 	 */
 	value = apic_read(APIC_LVT0) & APIC_LVT_MASKED;
-	if (!smp_processor_id() && (pic_mode || !value)) {
+	if (!cpu && (pic_mode || !value)) {
 		value = APIC_DM_EXTINT;
-		apic_printk(APIC_VERBOSE, "enabled ExtINT on CPU#%d\n",
-				smp_processor_id());
+		apic_printk(APIC_VERBOSE, "enabled ExtINT on CPU#%d\n", cpu);
 	} else {
 		value = APIC_DM_EXTINT | APIC_LVT_MASKED;
-		apic_printk(APIC_VERBOSE, "masked ExtINT on CPU#%d\n",
-				smp_processor_id());
+		apic_printk(APIC_VERBOSE, "masked ExtINT on CPU#%d\n", cpu);
 	}
 	apic_write(APIC_LVT0, value);
 
 	/*
 	 * only the BP should see the LINT1 NMI signal, obviously.
 	 */
-	if (!smp_processor_id())
+	if (!cpu)
 		value = APIC_DM_NMI;
 	else
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
@@ -1364,11 +1363,9 @@ void __cpuinit setup_local_APIC(void)
 		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write(APIC_LVT1, value);
 
-	preempt_enable();
-
 #ifdef CONFIG_X86_MCE_INTEL
 	/* Recheck CMCI information after local APIC is up on CPU #0 */
-	if (smp_processor_id() == 0)
+	if (!cpu)
 		cmci_recheck();
 #endif
 }
