Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab0FONzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:55:50 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:42268 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779Ab0FONzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:55:46 -0400
Subject: [RFC][PATCH 9/9] make kvm mmu shrinker more aggressive
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 15 Jun 2010 06:55:30 -0700
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
In-Reply-To: <20100615135518.BC244431@kernel.beaverton.ibm.com>
Message-Id: <20100615135530.4565745D@kernel.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In a previous patch, we removed the 'nr_to_scan' tracking.
It was not being used to track the number of objects
scanned, so we stopped using it entirely.  Here, we
strart using it again.

The theory here is simple; if we already have the refcount
and the kvm->mmu_lock, then we should do as much work as
possible under the lock.  The downside is that we're less
fair about the KVM instances from which we reclaim.  Each
call to mmu_shrink() will tend to "pick on" one instance,
after which it gets moved to the end of the list and left
alone for a while.

If mmu_shrink() has already done a significant amount of
scanning, the use of 'nr_to_scan' inside shrink_kvm_mmu()
will also ensure that we do not over-reclaim when we have
already done a lot of work in this call.

In the end, this patch defines a "scan" as:
1. An attempt to acquire a refcount on a 'struct kvm'
2. freeing a kvm mmu page

This would probably be most ideal if we can expose some
of the work done by kvm_mmu_remove_some_alloc_mmu_pages()
as also counting as scanning, but I think we have churned
enough for the moment.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/kvm/mmu.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN arch/x86/kvm/mmu.c~make-shrinker-more-aggressive arch/x86/kvm/mmu.c
--- linux-2.6.git/arch/x86/kvm/mmu.c~make-shrinker-more-aggressive	2010-06-14 11:30:44.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/kvm/mmu.c	2010-06-14 11:38:04.000000000 -0700
@@ -2935,8 +2935,10 @@ static int shrink_kvm_mmu(struct kvm *kv
 
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
-	if (kvm->arch.n_used_mmu_pages > 0)
-		freed_pages = kvm_mmu_remove_some_alloc_mmu_pages(kvm);
+	while (nr_to_scan > 0 && kvm->arch.n_used_mmu_pages > 0) {
+		freed_pages += kvm_mmu_remove_some_alloc_mmu_pages(kvm);
+		nr_to_scan--;
+	}
 
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -2952,7 +2954,6 @@ static int shrink_kvm_mmu(struct kvm *kv
 static int mmu_shrink(int nr_to_scan, gfp_t gfp_mask)
 {
 	int err;
-	int freed;
 	struct kvm *kvm;
 
 	if (nr_to_scan == 0)
@@ -2989,11 +2990,11 @@ retry:
 	 * operation itself.
 	 */
 	spin_unlock(&kvm_lock);
-	freed = shrink_kvm_mmu(kvm, nr_to_scan);
+	nr_to_scan -= shrink_kvm_mmu(kvm, nr_to_scan);
 
 	kvm_put_kvm(kvm);
 
-	if (!freed && nr_to_scan > 0)
+	if (nr_to_scan > 0)
 		goto retry;
 
 out:
diff -puN arch/x86/kvm/x86.c~make-shrinker-more-aggressive arch/x86/kvm/x86.c
diff -puN arch/x86/include/asm/kvm_host.h~make-shrinker-more-aggressive arch/x86/include/asm/kvm_host.h
_
