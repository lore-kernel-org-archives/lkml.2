Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab1DQUGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 16:06:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34632 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab1DQUFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 16:05:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=XrNAGIRnb8PzwUwS53I18FHTKCnt/f2gqvr1jLOjWHtAutwK/HvnbsJ7XkRtVBXCUq
         liY1Uy6HoM/mZcZIUldtaIAYOAN9VRzJRyM978OATaND7JX1/ZnhaUk7nT5I8MoMHXo6
         Vsp4E/Fq5kW8FpKc6Kmm7ABrCQdj321eP+yLM=
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mattst88@gmail.com,
        linux-alpha@vger.kernel.org
Subject: [PATCH 2/4] alpha: Remove set but unused variables.
Date: Sun, 17 Apr 2011 13:05:24 -0700
Message-Id: <1303070726-32155-3-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1303070726-32155-1-git-send-email-rth@twiddle.net>
References: <1303070726-32155-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new warning in gcc 4.6.  Several of these variables are
used within #if 0 code, which probably ought to be removed.  Most
of the changes are legitimate cleanups.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/kernel/core_mcpcia.c  |   12 +++++-------
 arch/alpha/kernel/err_titan.c    |    4 +---
 arch/alpha/kernel/setup.c        |    6 +++---
 arch/alpha/kernel/smc37c93x.c    |    3 +--
 arch/alpha/kernel/sys_wildfire.c |    5 +++--
 5 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/alpha/kernel/core_mcpcia.c b/arch/alpha/kernel/core_mcpcia.c
index 381fec0..da7bcc3 100644
--- a/arch/alpha/kernel/core_mcpcia.c
+++ b/arch/alpha/kernel/core_mcpcia.c
@@ -88,7 +88,7 @@ conf_read(unsigned long addr, unsigned char type1,
 {
 	unsigned long flags;
 	unsigned long mid = MCPCIA_HOSE2MID(hose->index);
-	unsigned int stat0, value, temp, cpu;
+	unsigned int stat0, value, cpu;
 
 	cpu = smp_processor_id();
 
@@ -101,7 +101,7 @@ conf_read(unsigned long addr, unsigned char type1,
 	stat0 = *(vuip)MCPCIA_CAP_ERR(mid);
 	*(vuip)MCPCIA_CAP_ERR(mid) = stat0;
 	mb();
-	temp = *(vuip)MCPCIA_CAP_ERR(mid);
+	*(vuip)MCPCIA_CAP_ERR(mid);
 	DBG_CFG(("conf_read: MCPCIA_CAP_ERR(%d) was 0x%x\n", mid, stat0));
 
 	mb();
@@ -136,7 +136,7 @@ conf_write(unsigned long addr, unsigned int value, unsigned char type1,
 {
 	unsigned long flags;
 	unsigned long mid = MCPCIA_HOSE2MID(hose->index);
-	unsigned int stat0, temp, cpu;
+	unsigned int stat0, cpu;
 
 	cpu = smp_processor_id();
 
@@ -145,7 +145,7 @@ conf_write(unsigned long addr, unsigned int value, unsigned char type1,
 	/* Reset status register to avoid losing errors.  */
 	stat0 = *(vuip)MCPCIA_CAP_ERR(mid);
 	*(vuip)MCPCIA_CAP_ERR(mid) = stat0; mb();
-	temp = *(vuip)MCPCIA_CAP_ERR(mid);
+	*(vuip)MCPCIA_CAP_ERR(mid);
 	DBG_CFG(("conf_write: MCPCIA CAP_ERR(%d) was 0x%x\n", mid, stat0));
 
 	draina();
@@ -157,7 +157,7 @@ conf_write(unsigned long addr, unsigned int value, unsigned char type1,
 	*((vuip)addr) = value;
 	mb();
 	mb();  /* magic */
-	temp = *(vuip)MCPCIA_CAP_ERR(mid); /* read to force the write */
+	*(vuip)MCPCIA_CAP_ERR(mid); /* read to force the write */
 	mcheck_expected(cpu) = 0;
 	mb();
 
@@ -572,12 +572,10 @@ mcpcia_print_system_area(unsigned long la_ptr)
 void
 mcpcia_machine_check(unsigned long vector, unsigned long la_ptr)
 {
-	struct el_common *mchk_header;
 	struct el_MCPCIA_uncorrected_frame_mcheck *mchk_logout;
 	unsigned int cpu = smp_processor_id();
 	int expected;
 
-	mchk_header = (struct el_common *)la_ptr;
 	mchk_logout = (struct el_MCPCIA_uncorrected_frame_mcheck *)la_ptr;
 	expected = mcheck_expected(cpu);
 
diff --git a/arch/alpha/kernel/err_titan.c b/arch/alpha/kernel/err_titan.c
index c3b3781..14b26c4 100644
--- a/arch/alpha/kernel/err_titan.c
+++ b/arch/alpha/kernel/err_titan.c
@@ -533,8 +533,6 @@ static struct el_subpacket_annotation el_titan_annotations[] = {
 static struct el_subpacket *
 el_process_regatta_subpacket(struct el_subpacket *header)
 {
-	int status;
-
 	if (header->class != EL_CLASS__REGATTA_FAMILY) {
 		printk("%s  ** Unexpected header CLASS %d TYPE %d, aborting\n",
 		       err_print_prefix,
@@ -551,7 +549,7 @@ el_process_regatta_subpacket(struct el_subpacket *header)
 		printk("%s  ** Occurred on CPU %d:\n", 
 		       err_print_prefix,
 		       (int)header->by_type.regatta_frame.cpuid);
-		status = privateer_process_logout_frame((struct el_common *)
+		privateer_process_logout_frame((struct el_common *)
 			header->by_type.regatta_frame.data_start, 1);
 		break;
 	default:
diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index d2634e4..edbddcb 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -1404,8 +1404,6 @@ determine_cpu_caches (unsigned int cpu_type)
 	case PCA56_CPU:
 	case PCA57_CPU:
 	  {
-		unsigned long cbox_config, size;
-
 		if (cpu_type == PCA56_CPU) {
 			L1I = CSHAPE(16*1024, 6, 1);
 			L1D = CSHAPE(8*1024, 5, 1);
@@ -1415,10 +1413,12 @@ determine_cpu_caches (unsigned int cpu_type)
 		}
 		L3 = -1;
 
+#if 0
+		unsigned long cbox_config, size;
+
 		cbox_config = *(vulp) phys_to_virt (0xfffff00008UL);
 		size = 512*1024 * (1 << ((cbox_config >> 12) & 3));
 
-#if 0
 		L2 = ((cbox_config >> 31) & 1 ? CSHAPE (size, 6, 1) : -1);
 #else
 		L2 = external_cache_probe(512*1024, 6);
diff --git a/arch/alpha/kernel/smc37c93x.c b/arch/alpha/kernel/smc37c93x.c
index 3e6a289..6886b83 100644
--- a/arch/alpha/kernel/smc37c93x.c
+++ b/arch/alpha/kernel/smc37c93x.c
@@ -79,7 +79,6 @@
 static unsigned long __init SMCConfigState(unsigned long baseAddr)
 {
 	unsigned char devId;
-	unsigned char devRev;
 
 	unsigned long configPort;
 	unsigned long indexPort;
@@ -100,7 +99,7 @@ static unsigned long __init SMCConfigState(unsigned long baseAddr)
 		devId = inb(dataPort);
 		if (devId == VALID_DEVICE_ID) {
 			outb(DEVICE_REV, indexPort);
-			devRev = inb(dataPort);
+			/* unsigned char devRev = */ inb(dataPort);
 			break;
 		}
 		else
diff --git a/arch/alpha/kernel/sys_wildfire.c b/arch/alpha/kernel/sys_wildfire.c
index d3cb28b..d92cdc7 100644
--- a/arch/alpha/kernel/sys_wildfire.c
+++ b/arch/alpha/kernel/sys_wildfire.c
@@ -156,7 +156,6 @@ static void __init
 wildfire_init_irq_per_pca(int qbbno, int pcano)
 {
 	int i, irq_bias;
-	unsigned long io_bias;
 	static struct irqaction isa_enable = {
 		.handler	= no_action,
 		.name		= "isa_enable",
@@ -165,10 +164,12 @@ wildfire_init_irq_per_pca(int qbbno, int pcano)
 	irq_bias = qbbno * (WILDFIRE_PCA_PER_QBB * WILDFIRE_IRQ_PER_PCA)
 		 + pcano * WILDFIRE_IRQ_PER_PCA;
 
+#if 0
+	unsigned long io_bias;
+
 	/* Only need the following for first PCI bus per PCA. */
 	io_bias = WILDFIRE_IO(qbbno, pcano<<1) - WILDFIRE_IO_BIAS;
 
-#if 0
 	outb(0, DMA1_RESET_REG + io_bias);
 	outb(0, DMA2_RESET_REG + io_bias);
 	outb(DMA_MODE_CASCADE, DMA2_MODE_REG + io_bias);
-- 
1.7.4.2

