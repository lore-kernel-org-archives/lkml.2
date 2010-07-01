Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab0GAVTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:19:50 -0400
Received: from kroah.org ([198.145.64.141]:33270 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933173Ab0GAVPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:34 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:02 2010
Message-Id: <20100701174302.650257645@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [191/200] KVM: MMU: Segregate shadow pages with different cr0.wp
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

When cr0.wp=0, we may shadow a gpte having u/s=1 and r/w=0 with an spte
having u/s=0 and r/w=1.  This allows excessive access if the guest sets
cr0.wp=1 and accesses through this spte.

Fix by making cr0.wp part of the base role; we'll have different sptes for
the two cases and the problem disappears.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

(Cherry-picked from commit 3dbe141595faa48a067add3e47bba3205b79d33c)
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -180,6 +180,7 @@ union kvm_mmu_page_role {
 		unsigned invalid:1;
 		unsigned cr4_pge:1;
 		unsigned nxe:1;
+		unsigned cr0_wp:1;
 	};
 };
 
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -223,7 +223,7 @@ void kvm_mmu_set_mask_ptes(u64 user_mask
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);
 
-static int is_write_protection(struct kvm_vcpu *vcpu)
+static bool is_write_protection(struct kvm_vcpu *vcpu)
 {
 	return kvm_read_cr0_bits(vcpu, X86_CR0_WP);
 }
@@ -2439,6 +2439,7 @@ static int init_kvm_softmmu(struct kvm_v
 		r = paging32_init_context(vcpu);
 
 	vcpu->arch.mmu.base_role.glevels = vcpu->arch.mmu.root_level;
+	vcpu->arch.mmu.base_role.cr0_wp = is_write_protection(vcpu);
 
 	return r;
 }


