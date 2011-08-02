Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab1HBLH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:07:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49877 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753553Ab1HBLHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:07:23 -0400
Message-ID: <4E37DADE.1070306@cn.fujitsu.com>
Date: Tue, 02 Aug 2011 19:09:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 05/12] KVM: x86: fast emulate repeat string write instructions
References: <4E37DA49.1040000@cn.fujitsu.com>
In-Reply-To: <4E37DA49.1040000@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-02 19:06:18,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-02 19:06:19,
	Serialize complete at 2011-08-02 19:06:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We usually use repeat string instructions to clear the page, for example,
we call memset to clear a page table, stosb is used in this function, and
repeated for 1024 times, that means we should occupy mmu lock for 1024 times
and walking shadow page cache for 1024 times, it is terrible

In fact, if it is the repeat string instructions emulated and it is not a
IO/MMIO access, we can zap all the corresponding shadow pages and return to the
guest, then the mapping can became writable and we can directly write the page

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_emulate.h |    1 +
 arch/x86/kvm/x86.c                 |   37 +++++++++++++++++++++++++++++------
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 049a6f5..66abd82 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -245,6 +245,7 @@ struct x86_emulate_ctxt {
 	bool perm_ok; /* do not check permissions if true */
 	bool only_vendor_specific_insn;
 	bool page_table_written_insn;
+	bool pio_mmio_emulate;
 
 	bool have_exception;
 	struct x86_exception exception;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5400a65..64f920d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4073,7 +4073,7 @@ struct read_write_emulator_ops {
 	int (*read_write_prepare)(struct kvm_vcpu *vcpu, void *val,
 				  int bytes);
 	int (*read_write_emulate)(struct kvm_vcpu *vcpu, gpa_t gpa,
-				  void *val, int bytes);
+				  void *val, int bytes, int *retvalue);
 	int (*read_write_mmio)(struct kvm_vcpu *vcpu, gpa_t gpa,
 			       int bytes, void *val);
 	int (*read_write_exit_mmio)(struct kvm_vcpu *vcpu, gpa_t gpa,
@@ -4095,18 +4095,37 @@ static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
 }
 
 static int read_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
-			void *val, int bytes)
+			void *val, int bytes, int *retvalue)
 {
+	*retvalue = X86EMUL_CONTINUE;
 	return !kvm_read_guest(vcpu->kvm, gpa, val, bytes);
 }
 
 static int write_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
-			 void *val, int bytes)
+			 void *val, int bytes, int *retvalue)
 {
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
+	bool page_table_written = ctxt->page_table_written_insn;
 
-	return emulator_write_phys(vcpu, gpa, val, bytes,
-				   ctxt->page_table_written_insn);
+	*retvalue = X86EMUL_CONTINUE;
+
+	/*
+	 * Zap the shadow page and retry the instruction if it is
+	 * the repetition instruction and no need to be emulated
+	 * for every repetition(neither io access nor mmio access).
+	 * The later access can make the page writable and #PF
+	 * can be avoided.
+	 *
+	 * We can not do this if the guest is in real mode since all
+	 * exceptions are intercepted in real mode, if the emulation
+	 * is caused by exception, we will retry this emulation for every.
+	 */
+	if (ctxt->rep_prefix && !ctxt->pio_mmio_emulate && is_protmode(vcpu)) {
+		page_table_written = false;
+		*retvalue = X86EMUL_RETRY_INSTR;
+	}
+
+	return emulator_write_phys(vcpu, gpa, val, bytes, page_table_written);
 }
 
 static int write_mmio(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes, void *val)
@@ -4167,10 +4186,12 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 	if (ret)
 		goto mmio;
 
-	if (ops->read_write_emulate(vcpu, gpa, val, bytes))
-		return X86EMUL_CONTINUE;
+	if (ops->read_write_emulate(vcpu, gpa, val, bytes, &ret))
+		return ret;
 
 mmio:
+	vcpu->arch.emulate_ctxt.pio_mmio_emulate = true;
+
 	/*
 	 * Is this MMIO handled locally?
 	 */
@@ -4336,6 +4357,7 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 {
 	trace_kvm_pio(!in, port, size, count);
 
+	vcpu->arch.emulate_ctxt.pio_mmio_emulate = true;
 	vcpu->arch.pio.port = port;
 	vcpu->arch.pio.in = in;
 	vcpu->arch.pio.count  = count;
@@ -4828,6 +4850,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		ctxt->have_exception = false;
 		ctxt->perm_ok = false;
 		ctxt->page_table_written_insn = false;
+		ctxt->pio_mmio_emulate = false;
 
 		ctxt->only_vendor_specific_insn
 			= emulation_type & EMULTYPE_TRAP_UD;
-- 
1.7.5.4

