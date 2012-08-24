Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab2HXBPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 21:15:53 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:40071 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab2HXBPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 21:15:44 -0400
From: Dong Hao <haodong@linux.vnet.ibm.com>
To: avi@redhat.com, acme@infradead.org, mtosatti@redhat.com, mingo@elte.hu
Cc: xiaoguangrong@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v7 2/3] KVM: x86: trace mmio begin and complete
Date: Fri, 24 Aug 2012 09:15:28 +0800
Message-Id: <1345770929-13667-3-git-send-email-haodong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345770929-13667-1-git-send-email-haodong@linux.vnet.ibm.com>
References: <1345770929-13667-1-git-send-email-haodong@linux.vnet.ibm.com>
x-cbid: 12082401-8372-0000-0000-0000038D7249
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

'perf kvm stat record/report' will use kvm_exit and kvm_mmio(read...) to
calculate mmio read emulated time for the old kernel, in order to trace
mmio read event more exactly, we add kvm_mmio_begin to trace the time when
mmio read begins, also, add kvm_io_done to trace the time when mmio/pio is
completed

[ Dong Hao <haodong@linux.vnet.ibm.com>: rebase it on current kvm tree ]
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Dong Hao <haodong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c         |   32 ++++++++++++++++++++------------
 include/trace/events/kvm.h |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 42bce48..b90394d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3828,9 +3828,12 @@ mmio:
 	/*
 	 * Is this MMIO handled locally?
 	 */
+	trace_kvm_mmio_begin(vcpu->vcpu_id, write, gpa);
 	handled = ops->read_write_mmio(vcpu, gpa, bytes, val);
-	if (handled == bytes)
+	if (handled == bytes) {
+		trace_kvm_io_done(vcpu->vcpu_id);
 		return X86EMUL_CONTINUE;
+	}
 
 	gpa += handled;
 	bytes -= handled;
@@ -4025,6 +4028,7 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	vcpu->arch.pio.size = size;
 
 	if (!kernel_pio(vcpu, vcpu->arch.pio_data)) {
+		trace_kvm_io_done(vcpu->vcpu_id);
 		vcpu->arch.pio.count = 0;
 		return 1;
 	}
@@ -4625,9 +4629,7 @@ restart:
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
@@ -4658,8 +4660,6 @@ int kvm_fast_pio_out(struct kvm_vcpu *vcpu, int size, unsigned short port)
 	unsigned long val = kvm_register_read(vcpu, VCPU_REGS_RAX);
 	int ret = emulator_pio_out_emulated(&vcpu->arch.emulate_ctxt,
 					    size, port, &val, 1);
-	/* do not return to emulator after return from userspace */
-	vcpu->arch.pio.count = 0;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(kvm_fast_pio_out);
@@ -5509,11 +5509,16 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 	struct kvm_mmio_fragment *frag;
-	int r;
+	int r = 1;
 
 	if (!(vcpu->arch.pio.count || vcpu->mmio_needed))
 		return 1;
 
+	if (vcpu->arch.pio.count && !vcpu->arch.pio.in) {
+		vcpu->arch.pio.count = 0;
+		goto exit;
+	}
+
 	if (vcpu->mmio_needed) {
 		/* Complete previous fragment */
 		frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment++];
@@ -5521,8 +5526,10 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
 			memcpy(frag->data, run->mmio.data, frag->len);
 		if (vcpu->mmio_cur_fragment == vcpu->mmio_nr_fragments) {
 			vcpu->mmio_needed = 0;
+
 			if (vcpu->mmio_is_write)
-				return 1;
+				goto exit;
+
 			vcpu->mmio_read_completed = 1;
 			goto done;
 		}
@@ -5539,11 +5546,12 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
 	}
 done:
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
-	r = emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
+	r = emulate_instruction(vcpu, EMULTYPE_NO_DECODE) == EMULATE_DONE;
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
-	if (r != EMULATE_DONE)
-		return 0;
-	return 1;
+
+exit:
+	trace_kvm_io_done(vcpu->vcpu_id);
+	return r;
 }
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 7ef9e75..d4182fa 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -177,6 +177,43 @@ TRACE_EVENT(kvm_mmio,
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
+TRACE_EVENT(kvm_io_done,
+	TP_PROTO(unsigned int vcpu_id),
+	TP_ARGS(vcpu_id),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, vcpu_id)
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
1.7.2.5

