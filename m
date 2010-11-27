Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab0K0P0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 10:26:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:37912 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab0K0PWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 10:22:42 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/16] x86: Use local variable to cache smp_processor_id() in setup_local_APIC()
Date: Sat, 27 Nov 2010 16:21:53 +0100
Message-Id: <1290871325-3055-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290871325-3055-1-git-send-email-tj@kernel.org>
References: <1290871325-3055-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Nov 2010 15:22:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a trivial clean up.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/apic.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3f838d5..2710f07 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1201,6 +1201,7 @@ static void __cpuinit lapic_setup_esr(void)
  */
 void __cpuinit setup_local_APIC(void)
 {
+	int cpu = smp_processor_id();
 	unsigned int value, queued;
 	int i, j, acked = 0;
 	unsigned long long tsc = 0, ntsc;
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
@@ -1368,7 +1367,7 @@ void __cpuinit setup_local_APIC(void)
 
 #ifdef CONFIG_X86_MCE_INTEL
 	/* Recheck CMCI information after local APIC is up on CPU #0 */
-	if (smp_processor_id() == 0)
+	if (cpu == 0)
 		cmci_recheck();
 #endif
 }
-- 
1.7.1

