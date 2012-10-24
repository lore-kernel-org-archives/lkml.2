Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab2JXGIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:08:13 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:41143 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab2JXGIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:08:09 -0400
Message-ID: <508785BF.4090803@linux.vnet.ibm.com>
Date: Wed, 24 Oct 2012 14:07:59 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2] KVM: x86: fix vcpu->mmio_fragments overflow
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12102406-5140-0000-0000-0000023E946B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit b3356bf0dbb349 (KVM: emulator: optimize "rep ins" handling),
the pieces of io data can be collected and write them to the guest memory
or MMIO together

Unfortunately, kvm splits the mmio access into 8 bytes and store them to
vcpu->mmio_fragments. If the guest uses "rep ins" to move large data, it
will cause vcpu->mmio_fragments overflow

The bug can be exposed by isapc (-M isapc):

[23154.818733] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[ ......]
[23154.858083] Call Trace:
[23154.859874]  [<ffffffffa04f0e17>] kvm_get_cr8+0x1d/0x28 [kvm]
[23154.861677]  [<ffffffffa04fa6d4>] kvm_arch_vcpu_ioctl_run+0xcda/0xe45 [kvm]
[23154.863604]  [<ffffffffa04f5a1a>] ? kvm_arch_vcpu_load+0x17b/0x180 [kvm]

Actually, we can use one mmio_fragment to store a large mmio access then
split it when we pass the mmio-exit-info to userspace. After that, we only
need two entries to store mmio info for the cross-mmio pages access

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c       |   60 ++++++++++++++++++++++++++--------------------
 include/linux/kvm_host.h |   15 +----------
 2 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8b90dd5..ec07cd3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3781,7 +3781,7 @@ static int write_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 {
 	struct kvm_mmio_fragment *frag = &vcpu->mmio_fragments[0];

-	memcpy(vcpu->run->mmio.data, frag->data, frag->len);
+	memcpy(vcpu->run->mmio.data, frag->data, min(8u, frag->len));
 	return X86EMUL_CONTINUE;
 }

@@ -3834,18 +3834,11 @@ mmio:
 	bytes -= handled;
 	val += handled;

-	while (bytes) {
-		unsigned now = min(bytes, 8U);
-
-		frag = &vcpu->mmio_fragments[vcpu->mmio_nr_fragments++];
-		frag->gpa = gpa;
-		frag->data = val;
-		frag->len = now;
-
-		gpa += now;
-		val += now;
-		bytes -= now;
-	}
+	WARN_ON(vcpu->mmio_nr_fragments >= KVM_MAX_MMIO_FRAGMENTS);
+	frag = &vcpu->mmio_fragments[vcpu->mmio_nr_fragments++];
+	frag->gpa = gpa;
+	frag->data = val;
+	frag->len = bytes;
 	return X86EMUL_CONTINUE;
 }

@@ -3892,7 +3885,7 @@ int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
 	vcpu->mmio_needed = 1;
 	vcpu->mmio_cur_fragment = 0;

-	vcpu->run->mmio.len = vcpu->mmio_fragments[0].len;
+	vcpu->run->mmio.len = min(8u, vcpu->mmio_fragments[0].len);
 	vcpu->run->mmio.is_write = vcpu->mmio_is_write = ops->write;
 	vcpu->run->exit_reason = KVM_EXIT_MMIO;
 	vcpu->run->mmio.phys_addr = gpa;
@@ -5524,28 +5517,44 @@ static int complete_emulated_pio(struct kvm_vcpu *vcpu)
  *
  * read:
  *   for each fragment
- *     write gpa, len
- *     exit
- *     copy data
+ *     for each mmio piece in the fragment
+ *       write gpa, len
+ *       exit
+ *       copy data
  *   execute insn
  *
  * write:
  *   for each fragment
- *      write gpa, len
- *      copy data
- *      exit
+ *     for each mmio piece in the fragment
+ *       write gpa, len
+ *       copy data
+ *       exit
  */
 static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 	struct kvm_mmio_fragment *frag;
+	unsigned len;

 	BUG_ON(!vcpu->mmio_needed);

 	/* Complete previous fragment */
-	frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment++];
+	frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment];
+	len = min(8u, frag->len);
 	if (!vcpu->mmio_is_write)
-		memcpy(frag->data, run->mmio.data, frag->len);
+		memcpy(frag->data, run->mmio.data, len);
+
+	if (frag->len <= 8) {
+		/* Switch to the next fragment. */
+		frag++;
+		vcpu->mmio_cur_fragment++;
+	} else {
+		/* Go forward to the next mmio piece. */
+		frag->data += len;
+		frag->gpa += len;
+		frag->len -= len;
+	}
+
 	if (vcpu->mmio_cur_fragment == vcpu->mmio_nr_fragments) {
 		vcpu->mmio_needed = 0;
 		if (vcpu->mmio_is_write)
@@ -5553,13 +5562,12 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 		vcpu->mmio_read_completed = 1;
 		return complete_emulated_io(vcpu);
 	}
-	/* Initiate next fragment */
-	++frag;
+
 	run->exit_reason = KVM_EXIT_MMIO;
 	run->mmio.phys_addr = frag->gpa;
 	if (vcpu->mmio_is_write)
-		memcpy(run->mmio.data, frag->data, frag->len);
-	run->mmio.len = frag->len;
+		memcpy(run->mmio.data, frag->data, min(8u, frag->len));
+	run->mmio.len = min(8u, frag->len);
 	run->mmio.is_write = vcpu->mmio_is_write;
 	vcpu->arch.complete_userspace_io = complete_emulated_mmio;
 	return 0;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e235068..a92f4fd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -42,19 +42,8 @@
  */
 #define KVM_MEMSLOT_INVALID	(1UL << 16)

-/*
- * If we support unaligned MMIO, at most one fragment will be split into two:
- */
-#ifdef KVM_UNALIGNED_MMIO
-#  define KVM_EXTRA_MMIO_FRAGMENTS 1
-#else
-#  define KVM_EXTRA_MMIO_FRAGMENTS 0
-#endif
-
-#define KVM_USER_MMIO_SIZE 8
-
-#define KVM_MAX_MMIO_FRAGMENTS \
-	(KVM_MMIO_SIZE / KVM_USER_MMIO_SIZE + KVM_EXTRA_MMIO_FRAGMENTS)
+/* Two fragments for cross MMIO pages. */
+#define KVM_MAX_MMIO_FRAGMENTS	2

 /*
  * For the normal pfn, the highest 12 bits should be zero,
-- 
1.7.7.6

