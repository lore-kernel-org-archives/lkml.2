Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab2BWL1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 06:27:38 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:41709 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab2BWL1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 06:27:35 -0500
Date: Thu, 23 Feb 2012 20:33:53 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com
Subject: [PATCH 1/4] KVM: MMU: Split the main body of rmap_write_protect()
 off from others
Message-Id: <20120223203353.ae79e816.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120223203300.241510a6.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120223203300.241510a6.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will use this in the following patch to implement another function
which needs to write protect pages using the rmap information.

Note that there is a small change in debug printing for large pages:
we do not differentiate them from others to avoid duplicating code.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 arch/x86/kvm/mmu.c |   53 ++++++++++++++++++++++++++-------------------------
 1 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ff053ca..67857bd 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1010,42 +1010,43 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }
 
-int kvm_mmu_rmap_write_protect(struct kvm *kvm, u64 gfn,
-			       struct kvm_memory_slot *slot)
+static int __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
 {
-	unsigned long *rmapp;
-	u64 *spte;
-	int i, write_protected = 0;
+	u64 *spte = NULL;
+	int write_protected = 0;
 
-	rmapp = __gfn_to_rmap(gfn, PT_PAGE_TABLE_LEVEL, slot);
-	spte = rmap_next(rmapp, NULL);
-	while (spte) {
+	while ((spte = rmap_next(rmapp, spte))) {
 		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
-		if (is_writable_pte(*spte)) {
+
+		if (!is_writable_pte(*spte))
+			continue;
+
+		if (level == PT_PAGE_TABLE_LEVEL) {
 			mmu_spte_update(spte, *spte & ~PT_WRITABLE_MASK);
-			write_protected = 1;
+		} else {
+			BUG_ON(!is_large_pte(*spte));
+			drop_spte(kvm, spte);
+			--kvm->stat.lpages;
+			spte = NULL;
 		}
-		spte = rmap_next(rmapp, spte);
+
+		write_protected = 1;
 	}
 
-	/* check for huge page mappings */
-	for (i = PT_DIRECTORY_LEVEL;
+	return write_protected;
+}
+
+int kvm_mmu_rmap_write_protect(struct kvm *kvm, u64 gfn,
+			       struct kvm_memory_slot *slot)
+{
+	unsigned long *rmapp;
+	int i, write_protected = 0;
+
+	for (i = PT_PAGE_TABLE_LEVEL;
 	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
 		rmapp = __gfn_to_rmap(gfn, i, slot);
-		spte = rmap_next(rmapp, NULL);
-		while (spte) {
-			BUG_ON(!(*spte & PT_PRESENT_MASK));
-			BUG_ON(!is_large_pte(*spte));
-			pgprintk("rmap_write_protect(large): spte %p %llx %lld\n", spte, *spte, gfn);
-			if (is_writable_pte(*spte)) {
-				drop_spte(kvm, spte);
-				--kvm->stat.lpages;
-				spte = NULL;
-				write_protected = 1;
-			}
-			spte = rmap_next(rmapp, spte);
-		}
+		write_protected |= __rmap_write_protect(kvm, rmapp, i);
 	}
 
 	return write_protected;
-- 
1.7.5.4

