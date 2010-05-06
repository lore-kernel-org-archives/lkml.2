Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab0EFPuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:50:16 -0400
Received: from mail-va3.bigfish.com ([216.32.180.112]:46473 "EHLO
	mail68-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753227Ab0EFPuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:50:14 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i2a8h87h43h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0L20837-01-HH5-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 7/7] oprofile/x86: make AMD IBS hotplug capable
Date: Thu, 6 May 2010 15:26:14 +0200
Message-ID: <1273152374-9392-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1273152374-9392-1-git-send-email-robert.richter@amd.com>
References: <1273152374-9392-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current IBS code is not hotplug capable. An offline cpu might not be
initialized or deinitialized properly. This patch fixes this by
removing on_each_cpu() functions. The IBS init/deinit code is executed
in the per-cpu functions model->setup_ctrs() and model->cpu_down()
which are also called by hotplug notifiers. model->cpu_down() replaces
model->exit() that became obsolete.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c      |    4 +-
 arch/x86/oprofile/op_model_amd.c |   54 +++++++++++--------------------------
 arch/x86/oprofile/op_x86_model.h |    2 +-
 3 files changed, 19 insertions(+), 41 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 2a08672..b28d2f1 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -397,6 +397,8 @@ static void nmi_cpu_shutdown(void *dummy)
 	apic_write(APIC_LVTPC, per_cpu(saved_lvtpc, cpu));
 	apic_write(APIC_LVTERR, v);
 	nmi_cpu_restore_registers(msrs);
+	if (model->cpu_down)
+		model->cpu_down();
 }
 
 static void nmi_cpu_up(void *dummy)
@@ -769,6 +771,4 @@ void op_nmi_exit(void)
 {
 	if (using_nmi)
 		exit_sysfs();
-	if (model->exit)
-		model->exit();
 }
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 384c524..b67a6b5 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -374,6 +374,15 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 		val |= op_x86_get_ctrl(model, &counter_config[virt]);
 		wrmsrl(msrs->controls[i].addr, val);
 	}
+
+	if (ibs_caps)
+		setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_NMI, 0);
+}
+
+static void op_amd_cpu_shutdown(void)
+{
+	if (ibs_caps)
+		setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
 }
 
 static int op_amd_check_ctrs(struct pt_regs * const regs,
@@ -436,28 +445,16 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 	op_amd_stop_ibs();
 }
 
-static u8 ibs_eilvt_off;
-
-static inline void apic_init_ibs_nmi_per_cpu(void *arg)
-{
-	ibs_eilvt_off = setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_NMI, 0);
-}
-
-static inline void apic_clear_ibs_nmi_per_cpu(void *arg)
-{
-	setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
-}
-
-static int init_ibs_nmi(void)
+static int __init_ibs_nmi(void)
 {
 #define IBSCTL_LVTOFFSETVAL		(1 << 8)
 #define IBSCTL				0x1cc
 	struct pci_dev *cpu_cfg;
 	int nodes;
 	u32 value = 0;
+	u8 ibs_eilvt_off;
 
-	/* per CPU setup */
-	on_each_cpu(apic_init_ibs_nmi_per_cpu, NULL, 1);
+	ibs_eilvt_off = setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
 
 	nodes = 0;
 	cpu_cfg = NULL;
@@ -487,21 +484,15 @@ static int init_ibs_nmi(void)
 	return 0;
 }
 
-/* uninitialize the APIC for the IBS interrupts if needed */
-static void clear_ibs_nmi(void)
-{
-	on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
-}
-
 /* initialize the APIC for the IBS interrupts if available */
-static void ibs_init(void)
+static void init_ibs(void)
 {
 	ibs_caps = get_ibs_caps();
 
 	if (!ibs_caps)
 		return;
 
-	if (init_ibs_nmi()) {
+	if (__init_ibs_nmi()) {
 		ibs_caps = 0;
 		return;
 	}
@@ -510,14 +501,6 @@ static void ibs_init(void)
 	       (unsigned)ibs_caps);
 }
 
-static void ibs_exit(void)
-{
-	if (!ibs_caps)
-		return;
-
-	clear_ibs_nmi();
-}
-
 static int (*create_arch_files)(struct super_block *sb, struct dentry *root);
 
 static int setup_ibs_files(struct super_block *sb, struct dentry *root)
@@ -566,17 +549,12 @@ static int setup_ibs_files(struct super_block *sb, struct dentry *root)
 
 static int op_amd_init(struct oprofile_operations *ops)
 {
-	ibs_init();
+	init_ibs();
 	create_arch_files = ops->create_files;
 	ops->create_files = setup_ibs_files;
 	return 0;
 }
 
-static void op_amd_exit(void)
-{
-	ibs_exit();
-}
-
 struct op_x86_model_spec op_amd_spec = {
 	.num_counters		= NUM_COUNTERS,
 	.num_controls		= NUM_COUNTERS,
@@ -584,9 +562,9 @@ struct op_x86_model_spec op_amd_spec = {
 	.reserved		= MSR_AMD_EVENTSEL_RESERVED,
 	.event_mask		= OP_EVENT_MASK,
 	.init			= op_amd_init,
-	.exit			= op_amd_exit,
 	.fill_in_addresses	= &op_amd_fill_in_addresses,
 	.setup_ctrs		= &op_amd_setup_ctrs,
+	.cpu_down		= &op_amd_cpu_shutdown,
 	.check_ctrs		= &op_amd_check_ctrs,
 	.start			= &op_amd_start,
 	.stop			= &op_amd_stop,
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 5514013..89017fa 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -40,10 +40,10 @@ struct op_x86_model_spec {
 	u64		reserved;
 	u16		event_mask;
 	int		(*init)(struct oprofile_operations *ops);
-	void		(*exit)(void);
 	int		(*fill_in_addresses)(struct op_msrs * const msrs);
 	void		(*setup_ctrs)(struct op_x86_model_spec const *model,
 				      struct op_msrs const * const msrs);
+	void		(*cpu_down)(void);
 	int		(*check_ctrs)(struct pt_regs * const regs,
 				      struct op_msrs const * const msrs);
 	void		(*start)(struct op_msrs const * const msrs);
-- 
1.7.0.3


