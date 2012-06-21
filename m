Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab2FUItm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:49:42 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:38888 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758885Ab2FUItk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:49:40 -0400
Date: Thu, 21 Jun 2012 17:49:24 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: agraf@suse.de, paulus@samba.org, aarcange@redhat.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [PATCH 1/6] KVM: MMU: Use __gfn_to_rmap() to clean up
 kvm_handle_hva()
Message-Id: <20120621174924.24ae896c.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120621174842.22779780.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120621174842.22779780.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can treat every level uniformly.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 arch/x86/kvm/mmu.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3b53d9e..d3e7e6a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1205,14 +1205,14 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 			gfn_t gfn_offset = (hva - start) >> PAGE_SHIFT;
 			gfn_t gfn = memslot->base_gfn + gfn_offset;
 
-			ret = handler(kvm, &memslot->rmap[gfn_offset], data);
+			ret = 0;
 
-			for (j = 0; j < KVM_NR_PAGE_SIZES - 1; ++j) {
-				struct kvm_lpage_info *linfo;
+			for (j = PT_PAGE_TABLE_LEVEL;
+			     j < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++j) {
+				unsigned long *rmapp;
 
-				linfo = lpage_info_slot(gfn, memslot,
-							PT_DIRECTORY_LEVEL + j);
-				ret |= handler(kvm, &linfo->rmap_pde, data);
+				rmapp = __gfn_to_rmap(gfn, j, memslot);
+				ret |= handler(kvm, rmapp, data);
 			}
 			trace_kvm_age_page(hva, memslot, ret);
 			retval |= ret;
-- 
1.7.5.4

