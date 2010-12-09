Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab0LIKr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:47:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:48456 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337Ab0LIKry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:47:54 -0500
Message-ID: <4D00B3B9.7060702@kernel.org>
Date: Thu, 09 Dec 2010 11:47:21 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org
Subject: [PATCH UPDATED#3 04/16] x86: setup_local_APIC() must always be called
 with preemption disabled
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-5-git-send-email-tj@kernel.org>
In-Reply-To: <1290871325-3055-5-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 10:47:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setup_local_APIC() is used to setup local APIC early during CPU
initialization and already assumes that preemption is disabled on
entry.  However, The function unnecessarily disables and enables
preemption and uses smp_processor_id() multiple times in and out of
the nested preemption disabled section.  This gives the wrong
impression that the function might be able to handle being called with
preemption enabled and/or migrated to another processor in the middle.

Make it clear that the function is always called with preemption
disabled, drop the confusing preemption disable block and call
smp_processor_id() once at the beginning of the function.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
---
As this function is causing undue confusion, let's go one step further
and make clear that it can't handle and was never meant to be called
with preemption enabled or migrated to another CPU in the middle.

The rest of series applies fine with this change and the git tree is
updated accordingly.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_32-numa

Thanks.

 arch/x86/kernel/apic/apic.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

Index: work/arch/x86/kernel/apic/apic.c
===================================================================
--- work.orig/arch/x86/kernel/apic/apic.c
+++ work/arch/x86/kernel/apic/apic.c
@@ -1195,12 +1195,15 @@ static void __cpuinit lapic_setup_esr(vo
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
