Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab0IXQdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:33:16 -0400
Received: from kroah.org ([198.145.64.141]:38477 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932775Ab0IXQ2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:45 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:20 2010
Message-Id: <20100924162619.930810250@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        mtosatti@redhat.com, avi@redhat.com,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [58/80] KVM: MMU: fix mmu notifier invalidate handler for huge spte
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Andrea Arcangeli <aarcange@redhat.com>

commit 6e3e243c3b6e0bbd18c6ce0fbc12bc3fe2d77b34 upstream.

The index wasn't calculated correctly (off by one) for huge spte so KVM guest
was unstable with transparent hugepages.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/mmu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -799,8 +799,12 @@ static int kvm_handle_hva(struct kvm *kv
 			ret = handler(kvm, &memslot->rmap[gfn_offset], data);
 
 			for (j = 0; j < KVM_NR_PAGE_SIZES - 1; ++j) {
-				int idx = gfn_offset;
-				idx /= KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL + j);
+				unsigned long idx;
+				int nr;
+
+				nr = KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL+j);
+				idx = (memslot->base_gfn+gfn_offset) / nr -
+					memslot->base_gfn / nr;
 				ret |= handler(kvm,
 					&memslot->lpage_info[j][idx].rmap_pde,
 					data);


