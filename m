Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab1JCNve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:51:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756052Ab1JCNuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:50:37 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, kvm@vger.kernel.org, joerg.roedel@amd.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl
Subject: [PATCH 7/9] KVM, VMX: add support for switching of PERF_GLOBAL_CTRL
Date: Mon,  3 Oct 2011 15:49:53 +0200
Message-Id: <1317649795-18259-8-git-send-email-gleb@redhat.com>
In-Reply-To: <1317649795-18259-1-git-send-email-gleb@redhat.com>
References: <1317649795-18259-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some cpus have special support for switching PERF_GLOBAL_CTRL msr.
Add logic to detect if such support exists and works properly and extend
msr switching code to use it if available. Also extend number of generic
msr switching entries to 8.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/vmx.c |   98 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 89 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f3ec38f..e4cc3c2 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -118,7 +118,7 @@ module_param(ple_gap, int, S_IRUGO);
 static int ple_window = KVM_VMX_DEFAULT_PLE_WINDOW;
 module_param(ple_window, int, S_IRUGO);
 
-#define NR_AUTOLOAD_MSRS 1
+#define NR_AUTOLOAD_MSRS 8
 #define VMCS02_POOL_SIZE 1
 
 struct vmcs {
@@ -622,6 +622,7 @@ static unsigned long *vmx_msr_bitmap_legacy;
 static unsigned long *vmx_msr_bitmap_longmode;
 
 static bool cpu_has_load_ia32_efer;
+static bool cpu_has_load_perf_global_ctrl;
 
 static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
 static DEFINE_SPINLOCK(vmx_vpid_lock);
@@ -1195,10 +1196,29 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
 {
 	unsigned i;
 	struct msr_autoload *m = &vmx->msr_autoload;
+	u32 entry_load, exit_load;
+	bool done = false;
 
-	if (msr == MSR_EFER && cpu_has_load_ia32_efer) {
-		vmcs_clear_bits(VM_ENTRY_CONTROLS, VM_ENTRY_LOAD_IA32_EFER);
-		vmcs_clear_bits(VM_EXIT_CONTROLS, VM_EXIT_LOAD_IA32_EFER);
+	switch (msr) {
+	case MSR_EFER:
+		if (cpu_has_load_ia32_efer) {
+			entry_load = VM_ENTRY_LOAD_IA32_EFER;
+			exit_load = VM_EXIT_LOAD_IA32_EFER;
+			done = true;
+		}
+		break;
+	case MSR_CORE_PERF_GLOBAL_CTRL:
+		if (cpu_has_load_perf_global_ctrl) {
+			entry_load = VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+			exit_load = VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+			done = true;
+		}
+		break;
+	}
+
+	if (done) {
+		vmcs_clear_bits(VM_ENTRY_CONTROLS, entry_load);
+		vmcs_clear_bits(VM_EXIT_CONTROLS, exit_load);
 		return;
 	}
 
@@ -1220,12 +1240,36 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 {
 	unsigned i;
 	struct msr_autoload *m = &vmx->msr_autoload;
+	unsigned long guest_val_vmcs, host_val_vmcs;
+	u32 entry_load, exit_load;
+	bool done = false;
+
+	switch (msr) {
+	case MSR_EFER:
+		if (cpu_has_load_ia32_efer) {
+			guest_val_vmcs = GUEST_IA32_EFER;
+			host_val_vmcs = HOST_IA32_EFER;
+			entry_load = VM_ENTRY_LOAD_IA32_EFER;
+			exit_load = VM_EXIT_LOAD_IA32_EFER;
+			done = true;
+		}
+		break;
+	case MSR_CORE_PERF_GLOBAL_CTRL:
+		if (cpu_has_load_perf_global_ctrl) {
+			guest_val_vmcs = GUEST_IA32_PERF_GLOBAL_CTRL;
+			host_val_vmcs = HOST_IA32_PERF_GLOBAL_CTRL;
+			entry_load = VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+			exit_load = VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+			done = true;
+		}
+		break;
+	}
 
-	if (msr == MSR_EFER && cpu_has_load_ia32_efer) {
-		vmcs_write64(GUEST_IA32_EFER, guest_val);
-		vmcs_write64(HOST_IA32_EFER, host_val);
-		vmcs_set_bits(VM_ENTRY_CONTROLS, VM_ENTRY_LOAD_IA32_EFER);
-		vmcs_set_bits(VM_EXIT_CONTROLS, VM_EXIT_LOAD_IA32_EFER);
+	if (done) {
+		vmcs_write64(guest_val_vmcs, guest_val);
+		vmcs_write64(host_val_vmcs, host_val);
+		vmcs_set_bits(VM_ENTRY_CONTROLS, entry_load);
+		vmcs_set_bits(VM_EXIT_CONTROLS, exit_load);
 		return;
 	}
 
@@ -2455,6 +2499,42 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 		&& allow_1_setting(MSR_IA32_VMX_EXIT_CTLS,
 				   VM_EXIT_LOAD_IA32_EFER);
 
+	cpu_has_load_perf_global_ctrl =
+		allow_1_setting(MSR_IA32_VMX_ENTRY_CTLS,
+				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
+		&& allow_1_setting(MSR_IA32_VMX_EXIT_CTLS,
+				   VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
+
+	/*
+	 * Some cpus support VM_ENTRY_(LOAD|SAVE)_IA32_PERF_GLOBAL_CTRL
+	 * but due to arrata below it can't be used. Workaround is to use
+	 * msr load mechanism to switch IA32_PERF_GLOBAL_CTRL.
+	 *
+	 * VM Exit May Incorrectly Clear IA32_PERF_GLOBAL_CTRL [34:32]
+	 *
+	 * AAK155             (model 26)
+	 * AAP115             (model 30)
+	 * AAT100             (model 37)
+	 * BC86,AAY89,BD102   (model 44)
+	 * BA97               (model 46)
+	 *
+	 */
+	if (cpu_has_load_perf_global_ctrl && boot_cpu_data.x86 == 0x6) {
+		switch (boot_cpu_data.x86_model) {
+		case 26:
+		case 30:
+		case 37:
+		case 44:
+		case 46:
+			cpu_has_load_perf_global_ctrl = false;
+			printk_once(KERN_WARNING"kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
+					"does not work properly. Using workaround\n");
+			break;
+		default:
+			break;
+		}
+	}
+
 	return 0;
 }
 
-- 
1.7.5.3

