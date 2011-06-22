Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab1FVO2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:28:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56046 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758066Ab1FVO2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:28:43 -0400
Message-ID: <4E01FC91.9020800@cn.fujitsu.com>
Date: Wed, 22 Jun 2011 22:30:41 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 06/22] KVM: x86: cleanup the code of read/write emulation
References: <4E01FBC9.3020009@cn.fujitsu.com>
In-Reply-To: <4E01FBC9.3020009@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:28:16,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:28:17,
	Serialize complete at 2011-06-22 22:28:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the read/write operation to remove the same code

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |  149 ++++++++++++++++-----------------------------------
 1 files changed, 47 insertions(+), 102 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 887714f..baa5a11 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3965,85 +3965,6 @@ static int vcpu_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 	return 0;
 }
 
-static int emulator_read_emulated_onepage(unsigned long addr,
-					  void *val,
-					  unsigned int bytes,
-					  struct x86_exception *exception,
-					  struct kvm_vcpu *vcpu)
-{
-	gpa_t gpa;
-	int handled, ret;
-
-	if (vcpu->mmio_read_completed) {
-		memcpy(val, vcpu->mmio_data, bytes);
-		trace_kvm_mmio(KVM_TRACE_MMIO_READ, bytes,
-			       vcpu->mmio_phys_addr, *(u64 *)val);
-		vcpu->mmio_read_completed = 0;
-		return X86EMUL_CONTINUE;
-	}
-
-	ret = vcpu_gva_to_gpa(vcpu, addr, &gpa, exception, false);
-
-	if (ret < 0)
-		return X86EMUL_PROPAGATE_FAULT;
-
-	if (ret)
-		goto mmio;
-
-	if (!kvm_read_guest(vcpu->kvm, gpa, val, bytes))
-		return X86EMUL_CONTINUE;
-
-mmio:
-	/*
-	 * Is this MMIO handled locally?
-	 */
-	handled = vcpu_mmio_read(vcpu, gpa, bytes, val);
-
-	if (handled == bytes)
-		return X86EMUL_CONTINUE;
-
-	gpa += handled;
-	bytes -= handled;
-	val += handled;
-
-	trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, bytes, gpa, 0);
-
-	vcpu->mmio_needed = 1;
-	vcpu->run->exit_reason = KVM_EXIT_MMIO;
-	vcpu->run->mmio.phys_addr = vcpu->mmio_phys_addr = gpa;
-	vcpu->mmio_size = bytes;
-	vcpu->run->mmio.len = min(vcpu->mmio_size, 8);
-	vcpu->run->mmio.is_write = vcpu->mmio_is_write = 0;
-	vcpu->mmio_index = 0;
-
-	return X86EMUL_IO_NEEDED;
-}
-
-static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
-				  unsigned long addr,
-				  void *val,
-				  unsigned int bytes,
-				  struct x86_exception *exception)
-{
-	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-
-	/* Crossing a page boundary? */
-	if (((addr + bytes - 1) ^ addr) & PAGE_MASK) {
-		int rc, now;
-
-		now = -addr & ~PAGE_MASK;
-		rc = emulator_read_emulated_onepage(addr, val, now, exception,
-							vcpu);
-		if (rc != X86EMUL_CONTINUE)
-			return rc;
-		addr += now;
-		val += now;
-		bytes -= now;
-	}
-	return emulator_read_emulated_onepage(addr, val, bytes, exception,
-						vcpu);
-}
-
 int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 			const void *val, int bytes)
 {
@@ -4128,16 +4049,22 @@ static struct read_write_emulator_ops write_emultor = {
 	.write = true,
 };
 
-static int emulator_write_emulated_onepage(unsigned long addr,
-					   const void *val,
-					   unsigned int bytes,
-					   struct x86_exception *exception,
-					   struct kvm_vcpu *vcpu)
+static int emulator_read_write_onepage(unsigned long addr, void *val,
+				       unsigned int bytes,
+				       struct x86_exception *exception,
+				       struct kvm_vcpu *vcpu,
+				       struct read_write_emulator_ops *ops)
+
 {
-	gpa_t                 gpa;
+	gpa_t gpa;
 	int handled, ret;
+	bool write = ops->write;
+
+	if (ops->read_write_prepare &&
+	      ops->read_write_prepare(vcpu, val, bytes))
+		return X86EMUL_CONTINUE;
 
-	ret = vcpu_gva_to_gpa(vcpu, addr, &gpa, exception, true);
+	ret = vcpu_gva_to_gpa(vcpu, addr, &gpa, exception, write);
 
 	if (ret < 0)
 		return X86EMUL_PROPAGATE_FAULT;
@@ -4146,15 +4073,14 @@ static int emulator_write_emulated_onepage(unsigned long addr,
 	if (ret)
 		goto mmio;
 
-	if (emulator_write_phys(vcpu, gpa, val, bytes))
+	if (ops->read_write_emulate(vcpu, gpa, val, bytes))
 		return X86EMUL_CONTINUE;
 
 mmio:
-	trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, bytes, gpa, *(u64 *)val);
 	/*
 	 * Is this MMIO handled locally?
 	 */
-	handled = vcpu_mmio_write(vcpu, gpa, bytes, val);
+	handled = ops->read_write_mmio(vcpu, gpa, bytes, val);
 	if (handled == bytes)
 		return X86EMUL_CONTINUE;
 
@@ -4163,23 +4089,20 @@ mmio:
 	val += handled;
 
 	vcpu->mmio_needed = 1;
-	memcpy(vcpu->mmio_data, val, bytes);
 	vcpu->run->exit_reason = KVM_EXIT_MMIO;
 	vcpu->run->mmio.phys_addr = vcpu->mmio_phys_addr = gpa;
 	vcpu->mmio_size = bytes;
 	vcpu->run->mmio.len = min(vcpu->mmio_size, 8);
-	vcpu->run->mmio.is_write = vcpu->mmio_is_write = 1;
-	memcpy(vcpu->run->mmio.data, vcpu->mmio_data, 8);
+	vcpu->run->mmio.is_write = vcpu->mmio_is_write = write;
 	vcpu->mmio_index = 0;
 
-	return X86EMUL_CONTINUE;
+	return ops->read_write_exit_mmio(vcpu, gpa, val, bytes);
 }
 
-int emulator_write_emulated(struct x86_emulate_ctxt *ctxt,
-			    unsigned long addr,
-			    const void *val,
-			    unsigned int bytes,
-			    struct x86_exception *exception)
+int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
+			void *val, unsigned int bytes,
+			struct x86_exception *exception,
+			struct read_write_emulator_ops *ops)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 
@@ -4188,16 +4111,38 @@ int emulator_write_emulated(struct x86_emulate_ctxt *ctxt,
 		int rc, now;
 
 		now = -addr & ~PAGE_MASK;
-		rc = emulator_write_emulated_onepage(addr, val, now, exception,
-						     vcpu);
+		rc = emulator_read_write_onepage(addr, val, now, exception,
+						 vcpu, ops);
+
 		if (rc != X86EMUL_CONTINUE)
 			return rc;
 		addr += now;
 		val += now;
 		bytes -= now;
 	}
-	return emulator_write_emulated_onepage(addr, val, bytes, exception,
-					       vcpu);
+
+	return emulator_read_write_onepage(addr, val, bytes, exception,
+					   vcpu, ops);
+}
+
+static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
+				  unsigned long addr,
+				  void *val,
+				  unsigned int bytes,
+				  struct x86_exception *exception)
+{
+	return emulator_read_write(ctxt, addr, val, bytes,
+				   exception, &read_emultor);
+}
+
+int emulator_write_emulated(struct x86_emulate_ctxt *ctxt,
+			    unsigned long addr,
+			    const void *val,
+			    unsigned int bytes,
+			    struct x86_exception *exception)
+{
+	return emulator_read_write(ctxt, addr, (void *)val, bytes,
+				   exception, &write_emultor);
 }
 
 #define CMPXCHG_TYPE(t, ptr, old, new) \
-- 
1.7.5.4

