Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab0K3QRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:17:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:47346 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab0K3QRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:17:46 -0500
Message-ID: <4CF5238F.7020300@kernel.org>
Date: Tue, 30 Nov 2010 17:17:19 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org
Subject: [PATCH UPDATED 04/16] x86: Use local variable to cache smp_processor_id()
 in setup_local_APIC()
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-5-git-send-email-tj@kernel.org>
In-Reply-To: <1290871325-3055-5-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 30 Nov 2010 16:17:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: x86: Use local variable to cache smp_processor_id() in setup_local_APIC()

This is a trivial clean up.

* Move initialization of @cpu inside preemption disabled region as
  suggested by Cyrill Gorcunov.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
---
Updated as suggested.  Git tree updated too.

Thanks.

 arch/x86/kernel/apic/apic.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

Index: work/arch/x86/kernel/apic/apic.c
===================================================================
--- work.orig/arch/x86/kernel/apic/apic.c
+++ work/arch/x86/kernel/apic/apic.c
@@ -1202,7 +1202,7 @@ static void __cpuinit lapic_setup_esr(vo
 void __cpuinit setup_local_APIC(void)
 {
 	unsigned int value, queued;
-	int i, j, acked = 0;
+	int cpu, i, j, acked = 0;
 	unsigned long long tsc = 0, ntsc;
 	long long max_loops = cpu_khz;

@@ -1226,6 +1226,7 @@ void __cpuinit setup_local_APIC(void)
 	perf_events_lapic_init();

 	preempt_disable();
+	cpu = smp_processor_id();

 	/*
 	 * Double-check whether this APIC is really registered.
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
