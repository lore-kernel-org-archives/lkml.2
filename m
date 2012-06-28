Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab2F1GJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:09:06 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47862 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588Ab2F1GIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:08:48 -0400
X-AuditID: 0ac90646-9b4c8ba000003485-a4-4febf4ede662
X-AuditID: 0ac90646-9b4c8ba000003485-a4-4febf4ede662
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC PATCH 15/18] KVM: vmx: Add definitions PIN_BASED_PREEMPTION_TIMER
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 28 Jun 2012 15:08:37 +0900
Message-ID: <20120628060837.19298.3263.stgit@localhost.localdomain>
In-Reply-To: <20120628060719.19298.43879.stgit@localhost.localdomain>
References: <20120628060719.19298.43879.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some definitions to use PIN_BASED_PREEMPTION_TIMER.

When PIN_BASED_PREEMPTION_TIMER is enabled, the guest will exit
with reason=EXIT_REASON_PREEMPTION_TIMER when the counter specified in
VMX_PREEMPTION_TIMER_VALUE becomes 0.
This patch also adds a dummy handler for EXIT_REASON_PREEMPTION_TIMER,
which just goes back to VM execution soon.

These are currently intended only to be used with avoid entering the
guest on a slave CPU when vmx_prevent_run(vcpu, 1) is called.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/include/asm/vmx.h |    3 +++
 arch/x86/kvm/trace.h       |    1 +
 arch/x86/kvm/vmx.c         |    7 +++++++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 31f180c..5ff43b1 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -65,6 +65,7 @@
 #define PIN_BASED_EXT_INTR_MASK                 0x00000001
 #define PIN_BASED_NMI_EXITING                   0x00000008
 #define PIN_BASED_VIRTUAL_NMIS                  0x00000020
+#define PIN_BASED_PREEMPTION_TIMER              0x00000040
 
 #define VM_EXIT_SAVE_DEBUG_CONTROLS             0x00000002
 #define VM_EXIT_HOST_ADDR_SPACE_SIZE            0x00000200
@@ -195,6 +196,7 @@ enum vmcs_field {
 	GUEST_INTERRUPTIBILITY_INFO     = 0x00004824,
 	GUEST_ACTIVITY_STATE            = 0X00004826,
 	GUEST_SYSENTER_CS               = 0x0000482A,
+	VMX_PREEMPTION_TIMER_VALUE      = 0x0000482E,
 	HOST_IA32_SYSENTER_CS           = 0x00004c00,
 	CR0_GUEST_HOST_MASK             = 0x00006000,
 	CR4_GUEST_HOST_MASK             = 0x00006002,
@@ -279,6 +281,7 @@ enum vmcs_field {
 #define EXIT_REASON_APIC_ACCESS         44
 #define EXIT_REASON_EPT_VIOLATION       48
 #define EXIT_REASON_EPT_MISCONFIG       49
+#define EXIT_REASON_PREEMPTION_TIMER	52
 #define EXIT_REASON_WBINVD		54
 #define EXIT_REASON_XSETBV		55
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 911d264..28b4df8 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -218,6 +218,7 @@ TRACE_EVENT(kvm_apic,
 	{ EXIT_REASON_APIC_ACCESS,		"APIC_ACCESS" }, \
 	{ EXIT_REASON_EPT_VIOLATION,		"EPT_VIOLATION" }, \
 	{ EXIT_REASON_EPT_MISCONFIG,		"EPT_MISCONFIG" }, \
+	{ EXIT_REASON_PREEMPTION_TIMER,		"PREEMPTION_TIMER" }, \
 	{ EXIT_REASON_WBINVD,			"WBINVD" }
 
 #define SVM_EXIT_REASONS \
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3aea448..2c987d1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4347,6 +4347,12 @@ static int handle_external_interrupt(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_preemption_timer(struct kvm_vcpu *vcpu)
+{
+	/* Nothing */
+	return 1;
+}
+
 static int handle_triple_fault(struct kvm_vcpu *vcpu)
 {
 	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
@@ -5645,6 +5651,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_VMON]                    = handle_vmon,
 	[EXIT_REASON_TPR_BELOW_THRESHOLD]     = handle_tpr_below_threshold,
 	[EXIT_REASON_APIC_ACCESS]             = handle_apic_access,
+	[EXIT_REASON_PREEMPTION_TIMER]        = handle_preemption_timer,
 	[EXIT_REASON_WBINVD]                  = handle_wbinvd,
 	[EXIT_REASON_XSETBV]                  = handle_xsetbv,
 	[EXIT_REASON_TASK_SWITCH]             = handle_task_switch,


