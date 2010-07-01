Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab0GAS1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:27:25 -0400
Received: from kroah.org ([198.145.64.141]:40850 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159Ab0GASYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:31 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:18 2010
Message-Id: <20100701173218.549108925@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 139/149] KVM: MMU: Dont read pdptrs with mmu spinlock held in mmu_alloc_roots
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

On svm, kvm_read_pdptr() may require reading guest memory, which can sleep.

Push the spinlock into mmu_alloc_roots(), and only take it after we've read
the pdptr.

Tested-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
(cherry picked from commit 8facbbff071ff2b19268d3732e31badc60471e21)
---
 arch/x86/kvm/mmu.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2091,11 +2091,13 @@ static int mmu_alloc_roots(struct kvm_vc
 			direct = 1;
 		if (mmu_check_root(vcpu, root_gfn))
 			return 1;
+		spin_lock(&vcpu->kvm->mmu_lock);
 		sp = kvm_mmu_get_page(vcpu, root_gfn, 0,
 				      PT64_ROOT_LEVEL, direct,
 				      ACC_ALL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
+		spin_unlock(&vcpu->kvm->mmu_lock);
 		vcpu->arch.mmu.root_hpa = root;
 		return 0;
 	}
@@ -2117,11 +2119,14 @@ static int mmu_alloc_roots(struct kvm_vc
 			root_gfn = 0;
 		if (mmu_check_root(vcpu, root_gfn))
 			return 1;
+		spin_lock(&vcpu->kvm->mmu_lock);
 		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
 				      PT32_ROOT_LEVEL, direct,
 				      ACC_ALL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
+		spin_unlock(&vcpu->kvm->mmu_lock);
+
 		vcpu->arch.mmu.pae_root[i] = root | PT_PRESENT_MASK;
 	}
 	vcpu->arch.mmu.root_hpa = __pa(vcpu->arch.mmu.pae_root);
@@ -2485,7 +2490,9 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 		goto out;
 	spin_lock(&vcpu->kvm->mmu_lock);
 	kvm_mmu_free_some_pages(vcpu);
+	spin_unlock(&vcpu->kvm->mmu_lock);
 	r = mmu_alloc_roots(vcpu);
+	spin_lock(&vcpu->kvm->mmu_lock);
 	mmu_sync_roots(vcpu);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	if (r)


