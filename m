Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428Ab1BPA6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:58:08 -0500
Received: from kroah.org ([198.145.64.141]:46151 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933325Ab1BPAv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:51:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:13 2011
Message-Id: <20110216002113.723232119@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com,
        avi@redhat.com, mtosatti@redhat.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [patch 147/176] KVM: MMU: Fix 32 bit legacy paging with NPT
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit f87f928882d080eaec8b0d76aecff003d664697d upstream.

This patch fixes 32 bit legacy paging with NPT enabled. The
mmu_check_root call on the top-level of the loop causes
root_gfn to take values (in the tdp_enabled path) which are
outside of guest memory. So the mmu_check_root call fails at
some point in the loop interation causing the guest to
tiple-fault.
This patch changes the mmu_check_root calls to the places
where they are really necessary. As a side-effect it
introduces a check for the root of a pae page table too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/mmu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2254,6 +2254,10 @@ static int mmu_alloc_roots(struct kvm_vc
 		return 0;
 	}
 	direct = !is_paging(vcpu);
+
+	if (mmu_check_root(vcpu, root_gfn))
+		return 1;
+
 	for (i = 0; i < 4; ++i) {
 		hpa_t root = vcpu->arch.mmu.pae_root[i];
 
@@ -2265,10 +2269,10 @@ static int mmu_alloc_roots(struct kvm_vc
 				continue;
 			}
 			root_gfn = pdptr >> PAGE_SHIFT;
+			if (mmu_check_root(vcpu, root_gfn))
+				return 1;
 		} else if (vcpu->arch.mmu.root_level == 0)
 			root_gfn = 0;
-		if (mmu_check_root(vcpu, root_gfn))
-			return 1;
 		if (tdp_enabled) {
 			direct = 1;
 			root_gfn = i << (30 - PAGE_SHIFT);


