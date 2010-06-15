Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab0FON4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:56:40 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49725 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab0FONze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:55:34 -0400
Subject: [RFC][PATCH 8/9] reduce kvm_lock hold times in mmu_skrink()
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 15 Jun 2010 06:55:29 -0700
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
In-Reply-To: <20100615135518.BC244431@kernel.beaverton.ibm.com>
Message-Id: <20100615135528.01AC8966@kernel.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mmu_shrink() is effectively single-threaded since the global
kvm_lock is held over the entire function.

I beleive its only use here is for synchronization of the
vm_list.  Instead of using the kvm_lock to ensure
consistency of the list, we instead obtain a kvm_get_kvm()
reference.  This keeps the kvm object on the vm_list while
we shrink it.

Since we don't need the lock to maintain the list any more,
we can drop it.  We'll reacquire it if we need to get another
object off.

This leads to a larger number of atomic ops, but reduces
lock hold times: the typical latency vs. throughput debate.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/kvm/mmu.c |   48 ++++++++++++++++++++++++++--------
 linux-2.6.git-dave/kernel/profile.c   |    2 +
 2 files changed, 40 insertions(+), 10 deletions(-)

diff -puN arch/x86/kvm/mmu.c~optimize_shrinker-3 arch/x86/kvm/mmu.c
--- linux-2.6.git/arch/x86/kvm/mmu.c~optimize_shrinker-3	2010-06-11 08:39:17.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/kvm/mmu.c	2010-06-11 08:39:17.000000000 -0700
@@ -2930,7 +2930,8 @@ static int kvm_mmu_remove_some_alloc_mmu
 
 static int shrink_kvm_mmu(struct kvm *kvm, int nr_to_scan)
 {
-	int idx, freed_pages;
+	int idx;
+	int freed_pages = 0;
 
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
@@ -2950,23 +2951,50 @@ static int shrink_kvm_mmu(struct kvm *kv
 
 static int mmu_shrink(int nr_to_scan, gfp_t gfp_mask)
 {
+	int err;
+	int freed;
 	struct kvm *kvm;
 
 	if (nr_to_scan == 0)
 		goto out;
 
+retry:
+	nr_to_scan--;
 	spin_lock(&kvm_lock);
-
-	list_for_each_entry(kvm, &vm_list, vm_list) {
-		int freed = shrink_kvm_mmu(kvm, nr_to_scan);
-		if (!freed)
-			continue;
-
-		list_move_tail(&kvm->vm_list, &vm_list);
-		break;
+	if (list_empty(&vm_list)) {
+		spin_unlock(&kvm_lock);
+		goto out;
 	}
-
+	kvm = list_first_entry(&vm_list, struct kvm, vm_list);
+	/*
+	 * With a reference to the kvm object, it can not go away
+	 * nor get removed from the vm_list.
+	 */
+	err = kvm_get_kvm(kvm);
+	/* Did someone race and start destroying the kvm object? */
+	if (err) {
+		spin_unlock(&kvm_lock);
+		goto retry;
+	}
+	/*
+	 * Stick this kvm on the end of the list so the next
+	 * interation will shrink a different one.  Do this here
+	 * so that we normally don't have to reacquire the lock.
+	 */
+	list_move_tail(&kvm->vm_list, &vm_list);
+	/*
+	 * Which lets us release the global lock, holding it for
+	 * the minimal amount of time possible, and ensuring that
+	 * we don't hold it during the (presumably slow) shrink
+	 * operation itself.
+	 */
 	spin_unlock(&kvm_lock);
+	freed = shrink_kvm_mmu(kvm, nr_to_scan);
+
+	kvm_put_kvm(kvm);
+
+	if (!freed && nr_to_scan > 0)
+		goto retry;
 
 out:
 	return kvm_total_used_mmu_pages;
diff -puN virt/kvm/kvm_main.c~optimize_shrinker-3 virt/kvm/kvm_main.c
diff -puN kernel/profile.c~optimize_shrinker-3 kernel/profile.c
--- linux-2.6.git/kernel/profile.c~optimize_shrinker-3	2010-06-11 09:09:43.000000000 -0700
+++ linux-2.6.git-dave/kernel/profile.c	2010-06-11 09:12:24.000000000 -0700
@@ -314,6 +314,8 @@ void profile_hits(int type, void *__pc, 
 	if (prof_on != type || !prof_buffer)
 		return;
 	pc = min((pc - (unsigned long)_stext) >> prof_shift, prof_len - 1);
+	if ((pc == prof_len - 1) && printk_ratelimit())
+		printk("profile_hits(%d, %p, %d)\n", type, __pc, nr_hits);
 	i = primary = (pc & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
 	secondary = (~(pc << 1) & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
 	cpu = get_cpu();
_
