Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613Ab2AKQx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:53:56 -0500
Received: from mailgw12.technion.ac.il ([132.68.225.12]:54382 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab2AKQxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:53:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJe9DU+ERM5e/2dsb2JhbABCrGuBBYFzAQUnUhBRITYGE79QjB0EoAKHSA
X-IronPort-AV: E=Sophos;i="4.71,493,1320616800"; 
   d="scan'208";a="74150933"
From: Nadav Amit <namit@cs.technion.ac.il>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nadav Amit <namit@cs.technion.ac.il>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [PATCH 2/2] KVM: Fix writeback on page boundary that propagate changes in spite of #PF
Date: Wed, 11 Jan 2012 18:53:31 +0200
Message-Id: <1326300811-17065-2-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1326300811-17065-1-git-send-email-namit@cs.technion.ac.il>
References: <1326300811-17065-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consider the case in which an instruction emulation writeback is performed on a page boundary.
In such case, if a #PF occurs on the second page, the write to the first page already occurred and cannot be retracted.
Therefore, validation of the second page access must be performed prior to writeback.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 arch/x86/kvm/x86.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05fd3d7..7af3d67 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3626,6 +3626,8 @@ struct read_write_emulator_ops {
 			       int bytes, void *val);
 	int (*read_write_exit_mmio)(struct kvm_vcpu *vcpu, gpa_t gpa,
 				    void *val, int bytes);
+	gpa_t (*read_write_validate)(struct kvm_vcpu *vcpu, gva_t gva,
+				     struct x86_exception *exception);
 	bool write;
 };
 
@@ -3686,6 +3688,7 @@ static struct read_write_emulator_ops write_emultor = {
 	.read_write_emulate = write_emulate,
 	.read_write_mmio = write_mmio,
 	.read_write_exit_mmio = write_exit_mmio,
+	.read_write_validate = kvm_mmu_gva_to_gpa_write,
 	.write = true,
 };
 
@@ -3750,6 +3753,16 @@ int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
 		int rc, now;
 
 		now = -addr & ~PAGE_MASK;
+
+		/* First check there is no page-fault on the next page */
+		if (ops->read_write_validate &&
+			ops->read_write_validate(vcpu, addr+now, exception) ==
+			UNMAPPED_GVA) {
+			/* #PF on the first page should be reported first */
+			ops->read_write_validate(vcpu, addr, exception);
+			return X86EMUL_PROPAGATE_FAULT;
+		}
+
 		rc = emulator_read_write_onepage(addr, val, now, exception,
 						 vcpu, ops);
 
-- 
1.7.4.1

