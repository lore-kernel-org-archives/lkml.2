Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab2HGJyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:54:52 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:36272 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab2HGJyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:54:50 -0400
Message-ID: <5020E5E2.4080603@linux.vnet.ibm.com>
Date: Tue, 07 Aug 2012 17:54:42 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 11/12] KVM: x86: introduce set_mmio_exit_info
References: <5020E423.9080004@linux.vnet.ibm.com>
In-Reply-To: <5020E423.9080004@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12080709-5564-0000-0000-000003EA2E75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce set_mmio_exit_info to cleanup the common code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |   33 +++++++++++++++++----------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4c86239..8cde327 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3761,9 +3761,6 @@ static int read_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 static int write_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 			   void *val, int bytes)
 {
-	struct kvm_mmio_fragment *frag = &vcpu->mmio_fragments[0];
-
-	memcpy(vcpu->run->mmio.data, frag->data, frag->len);
 	return X86EMUL_CONTINUE;
 }

@@ -3831,6 +3828,20 @@ mmio:
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
@@ -3870,14 +3881,10 @@ int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
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
@@ -5486,7 +5493,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
  */
 static int complete_mmio(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
 	struct kvm_mmio_fragment *frag;
 	int r;

@@ -5497,7 +5503,7 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
 		/* Complete previous fragment */
 		frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment++];
 		if (!vcpu->mmio_is_write)
-			memcpy(frag->data, run->mmio.data, frag->len);
+			memcpy(frag->data, vcpu->run->mmio.data, frag->len);
 		if (vcpu->mmio_cur_fragment == vcpu->mmio_nr_fragments) {
 			vcpu->mmio_needed = 0;
 			if (vcpu->mmio_is_write)
@@ -5507,12 +5513,7 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
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

