Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179Ab0G3R0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:26:24 -0400
Received: from kroah.org ([198.145.64.141]:52148 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758865Ab0G3RUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:20:02 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:12 2010
Message-Id: <20100730171511.969646411@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:16:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [136/165] KVM: MMU: invalidate and flush on spte small->large page size change
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

Always invalidate spte and flush TLBs when changing page size, to make
sure different sized translations for the same address are never cached
in a CPU's TLB.

Currently the only case where this occurs is when a non-leaf spte pointer is
overwritten by a leaf, large spte entry. This can happen after dirty
logging is disabled on a memslot, for example.

Noticed by Andrea.

KVM-Stable-Tag
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
(cherry picked from commit 3be2264be3c00865116f997dc53ebcc90fe7fc4b)
---
 arch/x86/kvm/mmu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1901,6 +1901,8 @@ static void mmu_set_spte(struct kvm_vcpu
 
 			child = page_header(pte & PT64_BASE_ADDR_MASK);
 			mmu_page_remove_parent_pte(child, sptep);
+			__set_spte(sptep, shadow_trap_nonpresent_pte);
+			kvm_flush_remote_tlbs(vcpu->kvm);
 		} else if (pfn != spte_to_pfn(*sptep)) {
 			pgprintk("hfn old %lx new %lx\n",
 				 spte_to_pfn(*sptep), pfn);


