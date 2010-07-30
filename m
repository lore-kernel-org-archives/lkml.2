Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab0G3RqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:46:05 -0400
Received: from kroah.org ([198.145.64.141]:36077 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425Ab0G3Rfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:35:47 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:12 2010
Message-Id: <20100730173112.571252522@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:31:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [109/140] KVM: SVM: Handle MCEs early in the vmexit process
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

This patch moves handling of the MC vmexits to an earlier
point in the vmexit. The handle_exit function is too late
because the vcpu might alreadry have changed its physical
cpu.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
(cherry picked from commit fe5913e4e1700cbfc337f4b1da9ddb26f6a55586)
---
 arch/x86/kvm/svm.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1255,7 +1255,7 @@ static int nm_interception(struct vcpu_s
 	return 1;
 }
 
-static int mc_interception(struct vcpu_svm *svm)
+static void svm_handle_mce(struct vcpu_svm *svm)
 {
 	/*
 	 * On an #MC intercept the MCE handler is not called automatically in
@@ -1265,6 +1265,11 @@ static int mc_interception(struct vcpu_s
 		"int $0x12\n");
 	/* not sure if we ever come back to this point */
 
+	return;
+}
+
+static int mc_interception(struct vcpu_svm *svm)
+{
 	return 1;
 }
 
@@ -2820,6 +2825,14 @@ static void svm_vcpu_run(struct kvm_vcpu
 		vcpu->arch.regs_avail &= ~(1 << VCPU_EXREG_PDPTR);
 		vcpu->arch.regs_dirty &= ~(1 << VCPU_EXREG_PDPTR);
 	}
+
+	/*
+	 * We need to handle MC intercepts here before the vcpu has a chance to
+	 * change the physical cpu
+	 */
+	if (unlikely(svm->vmcb->control.exit_code ==
+		     SVM_EXIT_EXCP_BASE + MC_VECTOR))
+		svm_handle_mce(svm);
 }
 
 #undef R


