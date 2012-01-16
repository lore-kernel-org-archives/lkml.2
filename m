Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2APJcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:32:25 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:38386 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab2APJcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:32:23 -0500
Message-ID: <4F13EE9B.9020901@linux.vnet.ibm.com>
Date: Mon, 16 Jan 2012 17:32:11 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/3] KVM: improve trace events of vmexit/mmio/ioport
References: <4F13EE3D.2070602@linux.vnet.ibm.com>
In-Reply-To: <4F13EE3D.2070602@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011609-8256-0000-0000-000000E31281
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- trace vcpu_id for these events
- add kvm_mmio_done to trace the time when mmio/ioport emulation is completed

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/trace.h       |   33 ++++++++++++++++++++++++++-------
 arch/x86/kvm/x86.c         |   19 +++++++++++++------
 include/trace/events/kvm.h |   32 +++++++++++++++++++++++++-------
 3 files changed, 64 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 911d264..e556458 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -91,11 +91,12 @@ TRACE_EVENT(kvm_hv_hypercall,
  * Tracepoint for PIO.
  */
 TRACE_EVENT(kvm_pio,
-	TP_PROTO(unsigned int rw, unsigned int port, unsigned int size,
-		 unsigned int count),
-	TP_ARGS(rw, port, size, count),
+	TP_PROTO(unsigned int vcpu_id, unsigned int rw, unsigned int port,
+		 unsigned int size, unsigned int count),
+	TP_ARGS(vcpu_id, rw, port, size, count),

 	TP_STRUCT__entry(
+		__field(	unsigned int,	vcpu_id		)
 		__field(	unsigned int, 	rw		)
 		__field(	unsigned int, 	port		)
 		__field(	unsigned int, 	size		)
@@ -103,17 +104,33 @@ TRACE_EVENT(kvm_pio,
 	),

 	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_id;
 		__entry->rw		= rw;
 		__entry->port		= port;
 		__entry->size		= size;
 		__entry->count		= count;
 	),

-	TP_printk("pio_%s at 0x%x size %d count %d",
-		  __entry->rw ? "write" : "read",
+	TP_printk("vcpu %u pio_%s at 0x%x size %d count %d",
+		  __entry->vcpu_id, __entry->rw ? "write" : "read",
 		  __entry->port, __entry->size, __entry->count)
 );

+TRACE_EVENT(kvm_pio_done,
+	TP_PROTO(unsigned int vcpu_id),
+	TP_ARGS(vcpu_id),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	vcpu_id		)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_id;
+	),
+
+	TP_printk("vcpu %u", __entry->vcpu_id)
+);
+
 /*
  * Tracepoint for cpuid.
  */
@@ -280,6 +297,7 @@ TRACE_EVENT(kvm_exit,
 	TP_ARGS(exit_reason, vcpu, isa),

 	TP_STRUCT__entry(
+		__field(	unsigned int,	vcpu_id		)
 		__field(	unsigned int,	exit_reason	)
 		__field(	unsigned long,	guest_rip	)
 		__field(	u32,	        isa             )
@@ -288,6 +306,7 @@ TRACE_EVENT(kvm_exit,
 	),

 	TP_fast_assign(
+		__entry->vcpu_id	= vcpu->vcpu_id;
 		__entry->exit_reason	= exit_reason;
 		__entry->guest_rip	= kvm_rip_read(vcpu);
 		__entry->isa            = isa;
@@ -295,8 +314,8 @@ TRACE_EVENT(kvm_exit,
 					   &__entry->info2);
 	),

-	TP_printk("reason %s rip 0x%lx info %llx %llx",
-		 (__entry->isa == KVM_ISA_VMX) ?
+	TP_printk("vcpu %u reason %s rip 0x%lx info %llx %llx",
+		 __entry->vcpu_id, (__entry->isa == KVM_ISA_VMX) ?
 		 __print_symbolic(__entry->exit_reason, VMX_EXIT_REASONS) :
 		 __print_symbolic(__entry->exit_reason, SVM_EXIT_REASONS),
 		 __entry->guest_rip, __entry->info1, __entry->info2)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0d41cfc..cf54478 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3684,7 +3684,8 @@ static int write_mmio(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes, void *val)
 static int read_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 			  void *val, int bytes)
 {
-	trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, bytes, gpa, 0);
+	trace_kvm_mmio(vcpu->vcpu_id, KVM_TRACE_MMIO_READ_UNSATISFIED,
+		       bytes, gpa, 0);
 	return X86EMUL_IO_NEEDED;
 }

@@ -3740,11 +3741,14 @@ mmio:
 	/*
 	 * Is this MMIO handled locally?
 	 */
-	trace_kvm_mmio(write ? KVM_TRACE_MMIO_WRITE : KVM_TRACE_MMIO_READ,
-			bytes, gpa, *(u64 *)val);
+	trace_kvm_mmio(vcpu->vcpu_id,
+		       write ? KVM_TRACE_MMIO_WRITE : KVM_TRACE_MMIO_READ,
+		       bytes, gpa, *(u64 *)val);
 	handled = ops->read_write_mmio(vcpu, gpa, bytes, val);
-	if (handled == bytes)
+	if (handled == bytes) {
+		trace_kvm_mmio_done(vcpu->vcpu_id);
 		return X86EMUL_CONTINUE;
+	}

 	gpa += handled;
 	bytes -= handled;
@@ -3902,7 +3906,7 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 			       unsigned short port, void *val,
 			       unsigned int count, bool in)
 {
-	trace_kvm_pio(!in, port, size, count);
+	trace_kvm_pio(vcpu->vcpu_id, !in, port, size, count);

 	vcpu->arch.pio.port = port;
 	vcpu->arch.pio.in = in;
@@ -3910,6 +3914,7 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	vcpu->arch.pio.size = size;

 	if (!kernel_pio(vcpu, vcpu->arch.pio_data)) {
+		trace_kvm_mmio_done(vcpu->vcpu_id);
 		vcpu->arch.pio.count = 0;
 		return 1;
 	}
@@ -5399,7 +5404,7 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
 			return 0;
 		}
 		if (vcpu->mmio_is_write)
-			return 1;
+			goto exit;
 		vcpu->mmio_read_completed = 1;
 	}
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
@@ -5407,6 +5412,8 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 	if (r != EMULATE_DONE)
 		return 0;
+exit:
+	trace_kvm_mmio_done(vcpu->vcpu_id);
 	return 1;
 }

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 46e3cd8..20b9f17 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -152,28 +152,46 @@ TRACE_EVENT(kvm_ack_irq,
 	{ KVM_TRACE_MMIO_WRITE, "write" }

 TRACE_EVENT(kvm_mmio,
-	TP_PROTO(int type, int len, u64 gpa, u64 val),
-	TP_ARGS(type, len, gpa, val),
+	TP_PROTO(unsigned int vcpu_id, int type, int len, u64 gpa, u64 val),
+	TP_ARGS(vcpu_id, type, len, gpa, val),

 	TP_STRUCT__entry(
-		__field(	u32,	type		)
-		__field(	u32,	len		)
-		__field(	u64,	gpa		)
-		__field(	u64,	val		)
+		__field(	unsigned int,	vcpu_id	)
+		__field(	u32,		type	)
+		__field(	u32,		len	)
+		__field(	u64,		gpa	)
+		__field(	u64,		val	)
 	),

 	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_id;
 		__entry->type		= type;
 		__entry->len		= len;
 		__entry->gpa		= gpa;
 		__entry->val		= val;
 	),

-	TP_printk("mmio %s len %u gpa 0x%llx val 0x%llx",
+	TP_printk("vcpu %u mmio %s len %u gpa 0x%llx val 0x%llx",
+		  __entry->vcpu_id,
 		  __print_symbolic(__entry->type, kvm_trace_symbol_mmio),
 		  __entry->len, __entry->gpa, __entry->val)
 );

+TRACE_EVENT(kvm_mmio_done,
+	TP_PROTO(unsigned int vcpu_id),
+	TP_ARGS(vcpu_id),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	vcpu_id		)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_id;
+	),
+
+	TP_printk("vcpu %u", __entry->vcpu_id)
+);
+
 #define kvm_fpu_load_symbol	\
 	{0, "unload"},		\
 	{1, "load"}
-- 
1.7.7.5

