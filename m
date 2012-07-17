Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab2GQNwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:52:25 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51033 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2GQNwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:52:21 -0400
Message-ID: <50056E0D.1070905@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 21:52:13 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/9] KVM: x86: introduce set_mmio_exit_info
References: <50056DB8.7080702@linux.vnet.ibm.com>
In-Reply-To: <50056DB8.7080702@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071703-9264-0000-0000-000001EE0BF8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce set_mmio_exit_info to cleanup the common code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |   33 +++++++++++++++++----------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 875b8d8..8171836 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3759,9 +3759,6 @@ static int read_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 static int write_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 			   void *val, int bytes)
 {
-	struct kvm_mmio_fragment *frag = &vcpu->mmio_fragments[0];
-
-	memcpy(vcpu->run->mmio.data, frag->data, frag->len);
 	return X86EMUL_CONTINUE;
 }

@@ -3829,6 +3826,20 @@ mmio:
 	return X86EMUL_CONTINUE;
 }

+static void set_mmio_exit_info(struct kvm_vcpu *vcpu,
+			       struct kvm_mmio_fragment *frag, bool write)
+{
+	struct kvm_run *run = vcpu->run;
+
+	run->exit_reason = KVM_EXIT_MMIO;
+	run->mmio.phys_addr = frag->gpa;
+	run->mmio.len = frag->len;
+	run->mmio.is_write = vcpu->mmio_is_write = write;
+
+	if (write)
+		memcpy(run->mmio.data, frag->data, frag->len);
+}
+
 int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
 			void *val, unsigned int bytes,
 			struct x86_exception *exception,
@@ -3868,14 +3879,10 @@ int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
 		return rc;

 	gpa = vcpu->mmio_fragments[0].gpa;
-
 	vcpu->mmio_needed = 1;
 	vcpu->mmio_cur_fragment = 0;

-	vcpu->run->mmio.len = vcpu->mmio_fragments[0].len;
-	vcpu->run->mmio.is_write = vcpu->mmio_is_write = ops->write;
-	vcpu->run->exit_reason = KVM_EXIT_MMIO;
-	vcpu->run->mmio.phys_addr = gpa;
+	set_mmio_exit_info(vcpu, &vcpu->mmio_fragments[0], ops->write);

 	return ops->read_write_exit_mmio(vcpu, gpa, val, bytes);
 }
@@ -5485,7 +5492,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
  */
 static int complete_mmio(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
 	struct kvm_mmio_fragment *frag;
 	int r;

@@ -5496,7 +5502,7 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
 		/* Complete previous fragment */
 		frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment++];
 		if (!vcpu->mmio_is_write)
-			memcpy(frag->data, run->mmio.data, frag->len);
+			memcpy(frag->data, vcpu->run->mmio.data, frag->len);
 		if (vcpu->mmio_cur_fragment == vcpu->mmio_nr_fragments) {
 			vcpu->mmio_needed = 0;
 			if (vcpu->mmio_is_write)
@@ -5506,12 +5512,7 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
 		}
 		/* Initiate next fragment */
 		++frag;
-		run->exit_reason = KVM_EXIT_MMIO;
-		run->mmio.phys_addr = frag->gpa;
-		if (vcpu->mmio_is_write)
-			memcpy(run->mmio.data, frag->data, frag->len);
-		run->mmio.len = frag->len;
-		run->mmio.is_write = vcpu->mmio_is_write;
+		set_mmio_exit_info(vcpu, frag, vcpu->mmio_is_write);
 		return 0;

 	}
-- 
1.7.7.6

