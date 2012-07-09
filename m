Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab2GIJDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 05:03:13 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60306 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2GIJDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 05:03:10 -0400
Message-ID: <4FFA9E45.6070008@linux.vnet.ibm.com>
Date: Mon, 09 Jul 2012 17:03:01 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/2] KVM: X86: introduce set_mmio_exit_info
References: <4FFA9E16.10001@linux.vnet.ibm.com>
In-Reply-To: <4FFA9E16.10001@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12070909-8256-0000-0000-0000033CB445
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce set_mmio_exit_info to cleanup the common code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |   33 +++++++++++++++++----------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7445545..7771f45 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3755,9 +3755,6 @@ static int read_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 static int write_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 			   void *val, int bytes)
 {
-	struct kvm_mmio_fragment *frag = &vcpu->mmio_fragments[0];
-
-	memcpy(vcpu->run->mmio.data, frag->data, frag->len);
 	return X86EMUL_CONTINUE;
 }

@@ -3825,6 +3822,20 @@ mmio:
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
@@ -3864,14 +3875,10 @@ int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
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
@@ -5490,7 +5497,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
  */
 static int complete_mmio(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
 	struct kvm_mmio_fragment *frag;
 	int r;

@@ -5501,7 +5507,7 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
 		/* Complete previous fragment */
 		frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment++];
 		if (!vcpu->mmio_is_write)
-			memcpy(frag->data, run->mmio.data, frag->len);
+			memcpy(frag->data, vcpu->run->mmio.data, frag->len);
 		if (vcpu->mmio_cur_fragment == vcpu->mmio_nr_fragments) {
 			vcpu->mmio_needed = 0;
 			if (vcpu->mmio_is_write)
@@ -5511,12 +5517,7 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
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

