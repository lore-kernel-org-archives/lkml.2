Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431Ab1BPA6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:58:24 -0500
Received: from kroah.org ([198.145.64.141]:46143 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933378Ab1BPAv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:51:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:13 2011
Message-Id: <20110216002113.623536886@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com,
        avi@redhat.com, mtosatti@redhat.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 146/176] KVM: MMU: Fix incorrect direct gfn for unpaged mode shadow
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Avi Kivity <avi@redhat.com>

commit c093b8b46c5f0dd12d799f0d6a3b579863df72f6 upstream.

We use the physical address instead of the base gfn for the four
PAE page directories we use in unpaged mode.  When the guest accesses
an address above 1GB that is backed by a large host page, a BUG_ON()
in kvm_mmu_set_gfn() triggers.

Resolves: https://bugzilla.kernel.org/show_bug.cgi?id=21962
Reported-and-tested-by: Nicolas Prochazka <prochazka.nicolas@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2271,7 +2271,7 @@ static int mmu_alloc_roots(struct kvm_vc
 			return 1;
 		if (tdp_enabled) {
 			direct = 1;
-			root_gfn = i << 30;
+			root_gfn = i << (30 - PAGE_SHIFT);
 		}
 		spin_lock(&vcpu->kvm->mmu_lock);
 		kvm_mmu_free_some_pages(vcpu);


