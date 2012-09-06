Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab2IFLbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:31:23 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:59687 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab2IFLbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:31:19 -0400
X-AuditID: b753bd60-95fd7ba000000c4c-43-504888edaf87
X-AuditID: b753bd60-95fd7ba000000c4c-43-504888edaf87
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 15/21] KVM: add tracepoint on enabling/disabling direct
 interrupt delivery
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:28:38 +0900
Message-ID: <20120906112837.13320.36521.stgit@kvmdev>
In-Reply-To: <20120906112718.13320.8231.stgit@kvmdev>
References: <20120906112718.13320.8231.stgit@kvmdev>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add trace event "kvm_set_direct_interrupt" to trace enabling/disabling
direct interrupt delivery on slave CPUs. At the event, the guest rip and
whether the feature is enabled or not is logged.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/kvm/trace.h |   18 ++++++++++++++++++
 arch/x86/kvm/vmx.c   |    2 ++
 arch/x86/kvm/x86.c   |    1 +
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index a71faf7..6081be7 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -551,6 +551,24 @@ TRACE_EVENT(kvm_pv_eoi,
 	TP_printk("apicid %x vector %d", __entry->apicid, __entry->vector)
 );
 
+TRACE_EVENT(kvm_set_direct_interrupt,
+	TP_PROTO(struct kvm_vcpu *vcpu, bool enabled),
+	TP_ARGS(vcpu, enabled),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	guest_rip	)
+		__field(	bool,	        enabled         )
+	),
+
+	TP_fast_assign(
+		__entry->guest_rip	= kvm_rip_read(vcpu);
+		__entry->enabled        = enabled;
+	),
+
+	TP_printk("rip 0x%lx enabled %d",
+		 __entry->guest_rip, __entry->enabled)
+);
+
 /*
  * Tracepoint for nested VMRUN
  */
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 605abea..6dc59c8 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1719,6 +1719,8 @@ static void vmx_set_direct_interrupt(struct kvm_vcpu *vcpu, bool enabled)
 	else
 		vmcs_set_bits(PIN_BASED_VM_EXEC_CONTROL,
 			      PIN_BASED_EXT_INTR_MASK);
+
+	trace_kvm_set_direct_interrupt(vcpu, enabled);
 }
 
 static void vmx_set_slave_mode(struct kvm_vcpu *vcpu, bool slave)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b7d28df..1449187 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6936,3 +6936,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_set_direct_interrupt);


