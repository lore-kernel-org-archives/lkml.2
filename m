Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab0H1LVI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 07:21:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57664 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab0H1LVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 07:21:05 -0400
Message-ID: <4C78F215.2040205@cn.fujitsu.com>
Date: Sat, 28 Aug 2010 19:25:09 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 5/5] KVM: MMU: remove count_rmaps()
References: <4C78F07E.1040709@cn.fujitsu.com>
In-Reply-To: <4C78F07E.1040709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing is checked in count_rmaps(), so remove it

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   38 --------------------------------------
 1 files changed, 0 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0d91f60..0bff4d5 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3606,43 +3606,6 @@ static void audit_mappings(struct kvm_vcpu *vcpu)
 						    2);
 }
 
-static int count_rmaps(struct kvm_vcpu *vcpu)
-{
-	struct kvm *kvm = vcpu->kvm;
-	struct kvm_memslots *slots;
-	int nmaps = 0;
-	int i, j, k, idx;
-
-	idx = srcu_read_lock(&kvm->srcu);
-	slots = kvm_memslots(kvm);
-	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
-		struct kvm_memory_slot *m = &slots->memslots[i];
-		struct kvm_rmap_desc *d;
-
-		for (j = 0; j < m->npages; ++j) {
-			unsigned long *rmapp = &m->rmap[j];
-
-			if (!*rmapp)
-				continue;
-			if (!(*rmapp & 1)) {
-				++nmaps;
-				continue;
-			}
-			d = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
-			while (d) {
-				for (k = 0; k < RMAP_EXT; ++k)
-					if (d->sptes[k])
-						++nmaps;
-					else
-						break;
-				d = d->more;
-			}
-		}
-	}
-	srcu_read_unlock(&kvm->srcu, idx);
-	return nmaps;
-}
-
 void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 {
 	unsigned long *rmapp;
@@ -3704,7 +3667,6 @@ static void check_mappings_rmap(struct kvm_vcpu *vcpu)
 static void audit_rmap(struct kvm_vcpu *vcpu)
 {
 	check_mappings_rmap(vcpu);
-	count_rmaps(vcpu);
 }
 
 static void audit_write_protection(struct kvm_vcpu *vcpu)
-- 
1.7.0.4

