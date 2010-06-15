Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab0FONzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:55:36 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:56224 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab0FONza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:55:30 -0400
Subject: [RFC][PATCH 2/9] rename x86 kvm->arch.n_alloc_mmu_pages
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 15 Jun 2010 06:55:20 -0700
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
In-Reply-To: <20100615135518.BC244431@kernel.beaverton.ibm.com>
Message-Id: <20100615135520.7B9E71AB@kernel.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Again, I think this is a poor choice of names.  This value truly
means, "the number of pages which _may_ be allocated".  But,
reading the value, "n_alloc_mmu_pages", I'm unable to think of
anything it should mean other than "the number of allocated mmu
pages", which is dead wrong.

It's really the high watermark, so let's give it a name to match:
nr_max_mmu_pages.  This change will make the next few patches
much more obvious and easy to read.


Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/include/asm/kvm_host.h |    2 +-
 linux-2.6.git-dave/arch/x86/kvm/mmu.c              |    8 ++++----
 linux-2.6.git-dave/arch/x86/kvm/x86.c              |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/x86/include/asm/kvm_host.h~rename-kvm_alloc arch/x86/include/asm/kvm_host.h
--- linux-2.6.git/arch/x86/include/asm/kvm_host.h~rename-kvm_alloc	2010-06-09 15:14:28.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/include/asm/kvm_host.h	2010-06-09 15:14:28.000000000 -0700
@@ -382,7 +382,7 @@ struct kvm_arch {
 
 	unsigned int n_free_mmu_pages;
 	unsigned int n_requested_mmu_pages;
-	unsigned int n_alloc_mmu_pages;
+	unsigned int n_max_mmu_pages;
 	atomic_t invlpg_counter;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	/*
diff -puN arch/x86/kvm/mmu.c~rename-kvm_alloc arch/x86/kvm/mmu.c
--- linux-2.6.git/arch/x86/kvm/mmu.c~rename-kvm_alloc	2010-06-09 15:14:28.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/kvm/mmu.c	2010-06-09 15:14:28.000000000 -0700
@@ -1522,7 +1522,7 @@ void kvm_mmu_change_mmu_pages(struct kvm
 {
 	int used_pages;
 
-	used_pages = kvm->arch.n_alloc_mmu_pages - kvm_mmu_available_pages(kvm);
+	used_pages = kvm->arch.n_max_mmu_pages - kvm_mmu_available_pages(kvm);
 	used_pages = max(0, used_pages);
 
 	/*
@@ -1546,9 +1546,9 @@ void kvm_mmu_change_mmu_pages(struct kvm
 	}
 	else
 		kvm->arch.n_free_mmu_pages += kvm_nr_mmu_pages
-					 - kvm->arch.n_alloc_mmu_pages;
+					 - kvm->arch.n_max_mmu_pages;
 
-	kvm->arch.n_alloc_mmu_pages = kvm_nr_mmu_pages;
+	kvm->arch.n_max_mmu_pages = kvm_nr_mmu_pages;
 }
 
 static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
@@ -2932,7 +2932,7 @@ static int mmu_shrink(int nr_to_scan, gf
 
 		idx = srcu_read_lock(&kvm->srcu);
 		spin_lock(&kvm->mmu_lock);
-		npages = kvm->arch.n_alloc_mmu_pages -
+		npages = kvm->arch.n_max_mmu_pages -
 			 kvm_mmu_available_pages(kvm);
 		cache_count += npages;
 		if (!kvm_freed && nr_to_scan > 0 && npages > 0) {
diff -puN arch/x86/kvm/x86.c~rename-kvm_alloc arch/x86/kvm/x86.c
--- linux-2.6.git/arch/x86/kvm/x86.c~rename-kvm_alloc	2010-06-09 15:14:28.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/kvm/x86.c	2010-06-09 15:14:28.000000000 -0700
@@ -2557,7 +2557,7 @@ static int kvm_vm_ioctl_set_nr_mmu_pages
 
 static int kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
 {
-	return kvm->arch.n_alloc_mmu_pages;
+	return kvm->arch.n_max_mmu_pages;
 }
 
 gfn_t unalias_gfn_instantiation(struct kvm *kvm, gfn_t gfn)
_
