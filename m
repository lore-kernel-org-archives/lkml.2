Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab0FON4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:56:43 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49007 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab0FONze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:55:34 -0400
Subject: [RFC][PATCH 6/9] remove kvm_freed variable
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 15 Jun 2010 06:55:26 -0700
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
In-Reply-To: <20100615135518.BC244431@kernel.beaverton.ibm.com>
Message-Id: <20100615135526.C4002017@kernel.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In mmu_shrink(), we walk the vm_list to try and free some
of the mmu objects.  If we did this over and over again, we
would unfairly bias the shrinking at the beginning of the
list.  So, if a KVM instance gets successfully shrunk, then
we move it to the end of the vm_list.  This keeps things
fair.

With the global mmu object counter, we no longer need to
look at each kvm object on the vm_list during each
mmu_shrink() operation.  So, move the list manipulation
to inside of the loop, and get rid of the 'kvm_freed'
variable since we no longer need to store it.

This also removes the manipulation of the 'nr_to_scan'
variable.  It use in here was questionable, especially
since it was being decremented even in cases where no
scanning was taking place: when building the counter.
Interestingly enough, removing it here does not affect
the reclaim behavior at all.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/kvm/mmu.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN arch/x86/kvm/mmu.c~optimize_shrinker-2 arch/x86/kvm/mmu.c
--- linux-2.6.git/arch/x86/kvm/mmu.c~optimize_shrinker-2	2010-06-14 10:24:48.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/kvm/mmu.c	2010-06-14 10:24:48.000000000 -0700
@@ -2951,7 +2951,6 @@ static int shrink_kvm_mmu(struct kvm *kv
 static int mmu_shrink(int nr_to_scan, gfp_t gfp_mask)
 {
 	struct kvm *kvm;
-	struct kvm *kvm_freed = NULL;
 
 	if (nr_to_scan == 0)
 		goto out;
@@ -2959,18 +2958,14 @@ static int mmu_shrink(int nr_to_scan, gf
 	spin_lock(&kvm_lock);
 
 	list_for_each_entry(kvm, &vm_list, vm_list) {
-		if (nr_to_scan <= 0)
-			break;
+		int freed = shrink_kvm_mmu(kvm, nr_to_scan);
+		if (!freed)
+			continue;
 
-		shrink_kvm_mmu(kvm, nr_to_scan);
-		if (!kvm_freed)
-			kvm_freed = kvm;
-		nr_to_scan--;
+		list_move_tail(&kvm->vm_list, &vm_list);
+		break;
 	}
 
-	if (kvm_freed)
-		list_move_tail(&kvm_freed->vm_list, &vm_list);
-
 	spin_unlock(&kvm_lock);
 
 out:
_
