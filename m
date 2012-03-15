Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031524Ab2COBou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 21:44:50 -0400
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:46505 "EHLO
	homiemail-a7.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1031223Ab2COBos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 21:44:48 -0400
Subject: [PATCH] KVM: VMX: call invvpid only when EPT is disabled
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Sheng Yang <sheng.yang@intel.com>
Cc: KVM <kvm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Thu, 15 Mar 2012 02:44:44 +0100
Message-ID: <1331775884.20336.2.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

With EPT enabled it is not required to explicitly run invvpid to invalidate tagged TLB entries, as
KVM does not force vm-exits for cr3 writes and invlpg. Run invvpid only when these instructions
are emulated and shadow pages are used.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 arch/x86/kvm/vmx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2c22fc7..51c7fb9 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2861,12 +2861,13 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 
 static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
 {
-	vpid_sync_context(to_vmx(vcpu));
 	if (enable_ept) {
 		if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 			return;
 		ept_sync_context(construct_eptp(vcpu->arch.mmu.root_hpa));
 	}
+	else
+		vpid_sync_context(to_vmx(vcpu));
 }
 
 static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
-- 
1.7.4.1



