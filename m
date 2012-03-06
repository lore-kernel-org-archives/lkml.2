Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030367Ab2CFI60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 03:58:26 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:52484 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758802Ab2CFI6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 03:58:00 -0500
Message-ID: <4F55D16F.5040107@linux.vnet.ibm.com>
Date: Tue, 06 Mar 2012 16:57:19 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/3] KVM: x86: trace mmio begin and complete
References: <4F55D110.2020609@linux.vnet.ibm.com>
In-Reply-To: <4F55D110.2020609@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12030608-2674-0000-0000-00000394A8F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'perf kvm-events' will use kvm_exit and kvm_mmio(read...) to calculate
mmio read emulated time for the old kernel, in order to trace mmio read
event more exactly, we add kvm_mmio_begin to trace the time when mmio read
begins

Also, add kvm_mmio_done to trace the time when mmio/pio is completed

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c         |   21 ++++++++++++++-------
 include/trace/events/kvm.h |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c9d99e5..09acecf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3808,9 +3808,12 @@ mmio:
 	/*
 	 * Is this MMIO handled locally?
 	 */
+	trace_kvm_mmio_begin(vcpu->vcpu_id, write, gpa);
 	handled = ops->read_write_mmio(vcpu, gpa, bytes, val);
-	if (handled == bytes)
+	if (handled == bytes) {
+		trace_kvm_mmio_done(vcpu->vcpu_id);
 		return X86EMUL_CONTINUE;
+	}

 	gpa += handled;
 	bytes -= handled;
@@ -3976,6 +3979,7 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	vcpu->arch.pio.size = size;

 	if (!kernel_pio(vcpu, vcpu->arch.pio_data)) {
+		trace_kvm_mmio_done(vcpu->vcpu_id);
 		vcpu->arch.pio.count = 0;
 		return 1;
 	}
@@ -4586,9 +4590,7 @@ restart:
 		inject_emulated_exception(vcpu);
 		r = EMULATE_DONE;
 	} else if (vcpu->arch.pio.count) {
-		if (!vcpu->arch.pio.in)
-			vcpu->arch.pio.count = 0;
-		else
+		if (vcpu->arch.pio.in)
 			writeback = false;
 		r = EMULATE_DO_MMIO;
 	} else if (vcpu->mmio_needed) {
@@ -4619,8 +4621,6 @@ int kvm_fast_pio_out(struct kvm_vcpu *vcpu, int size, unsigned short port)
 	unsigned long val = kvm_register_read(vcpu, VCPU_REGS_RAX);
 	int ret = emulator_pio_out_emulated(&vcpu->arch.emulate_ctxt,
 					    size, port, &val, 1);
-	/* do not return to emulator after return from userspace */
-	vcpu->arch.pio.count = 0;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(kvm_fast_pio_out);
@@ -5451,6 +5451,11 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.pio.count || vcpu->mmio_needed))
 		return 1;

+	if (vcpu->arch.pio.count && !vcpu->arch.pio.in) {
+		vcpu->arch.pio.count = 0;
+		goto exit;
+	}
+
 	if (vcpu->mmio_needed) {
 		vcpu->mmio_needed = 0;
 		if (!vcpu->mmio_is_write)
@@ -5467,7 +5472,7 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
 			return 0;
 		}
 		if (vcpu->mmio_is_write)
-			return 1;
+			goto exit;
 		vcpu->mmio_read_completed = 1;
 	}
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
@@ -5475,6 +5480,8 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 	if (r != EMULATE_DONE)
 		return 0;
+exit:
+	trace_kvm_mmio_done(vcpu->vcpu_id);
 	return 1;
 }

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 46e3cd8..16c8a6d 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -174,6 +174,43 @@ TRACE_EVENT(kvm_mmio,
 		  __entry->len, __entry->gpa, __entry->val)
 );

+TRACE_EVENT(kvm_mmio_begin,
+	TP_PROTO(unsigned int vcpu_id, bool rw, u64 gpa),
+	TP_ARGS(vcpu_id, rw, gpa),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, vcpu_id)
+		__field(int, type)
+		__field(u64, gpa)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu_id;
+		__entry->type = rw ? KVM_TRACE_MMIO_WRITE :
+				      KVM_TRACE_MMIO_READ;
+		__entry->gpa = gpa;
+	),
+
+	TP_printk("vcpu %u mmio %s gpa 0x%llx", __entry->vcpu_id,
+		  __print_symbolic(__entry->type, kvm_trace_symbol_mmio),
+		  __entry->gpa)
+);
+
+TRACE_EVENT(kvm_mmio_done,
+	TP_PROTO(unsigned int vcpu_id),
+	TP_ARGS(vcpu_id),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	vcpu_id		)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu_id;
+	),
+
+	TP_printk("vcpu %u", __entry->vcpu_id)
+);
+
 #define kvm_fpu_load_symbol	\
 	{0, "unload"},		\
 	{1, "load"}
-- 
1.7.7.6

