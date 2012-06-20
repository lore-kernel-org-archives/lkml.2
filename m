Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab2FTH5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:57:06 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:33231 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab2FTH5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:57:03 -0400
Message-ID: <4FE18245.3040307@linux.vnet.ibm.com>
Date: Wed, 20 Jun 2012 15:56:53 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v7 01/10] KVM: MMU: return bool in __rmap_write_protect
References: <4FE1822D.8010002@linux.vnet.ibm.com>
In-Reply-To: <4FE1822D.8010002@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062007-5564-0000-0000-000003446ADF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reture value of __rmap_write_protect is either 1 or 0, use
true/false instead of these

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24dd43d..fad5c91 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1051,11 +1051,12 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }

-static int __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
+static bool
+__rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
-	int write_protected = 0;
+	bool write_protected = false;

 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
 		BUG_ON(!(*sptep & PT_PRESENT_MASK));
@@ -1076,7 +1077,7 @@ static int __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level
 			sptep = rmap_get_first(*rmapp, &iter);
 		}

-		write_protected = 1;
+		write_protected = true;
 	}

 	return write_protected;
@@ -1107,12 +1108,12 @@ void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	}
 }

-static int rmap_write_protect(struct kvm *kvm, u64 gfn)
+static bool rmap_write_protect(struct kvm *kvm, u64 gfn)
 {
 	struct kvm_memory_slot *slot;
 	unsigned long *rmapp;
 	int i;
-	int write_protected = 0;
+	bool write_protected = false;

 	slot = gfn_to_memslot(kvm, gfn);

@@ -1703,7 +1704,7 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,

 	kvm_mmu_pages_init(parent, &parents, &pages);
 	while (mmu_unsync_walk(parent, &pages)) {
-		int protected = 0;
+		bool protected = false;

 		for_each_sp(pages, sp, parents, i)
 			protected |= rmap_write_protect(vcpu->kvm, sp->gfn);
-- 
1.7.7.6

