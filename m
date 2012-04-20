Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab2DTI36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 04:29:58 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:33609 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab2DTI34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 04:29:56 -0400
Message-ID: <4F911B92.7040502@linux.vnet.ibm.com>
Date: Fri, 20 Apr 2012 16:17:22 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 1/9] KVM: MMU: return bool in __rmap_write_protect
References: <4F911B74.4040305@linux.vnet.ibm.com>
In-Reply-To: <4F911B74.4040305@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12042008-5816-0000-0000-000002364C69
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
index 29ad6f9..4a3cc18 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1041,11 +1041,12 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
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
@@ -1066,7 +1067,7 @@ static int __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level
 			sptep = rmap_get_first(*rmapp, &iter);
 		}

-		write_protected = 1;
+		write_protected = true;
 	}

 	return write_protected;
@@ -1097,12 +1098,12 @@ void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
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

@@ -1691,7 +1692,7 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,

 	kvm_mmu_pages_init(parent, &parents, &pages);
 	while (mmu_unsync_walk(parent, &pages)) {
-		int protected = 0;
+		bool protected = false;

 		for_each_sp(pages, sp, parents, i)
 			protected |= rmap_write_protect(vcpu->kvm, sp->gfn);
-- 
1.7.7.6

