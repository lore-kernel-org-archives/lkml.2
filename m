Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab0DVGPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:15:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64832 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab0DVGPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 02:15:44 -0400
Message-ID: <4BCFE8D5.4040408@cn.fujitsu.com>
Date: Thu, 22 Apr 2010 14:12:37 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/10] KVM MMU: move unsync/sync tracpoints to proper place
References: <4BCFE3D5.5070105@cn.fujitsu.com>
In-Reply-To: <4BCFE3D5.5070105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move unsync/sync tracepoints to the proper place, it's good
for us to obtain unsync page live time

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ddfa865..abf8bd4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1189,6 +1189,7 @@ static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm *kvm, gfn_t gfn)
 static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	WARN_ON(!sp->unsync);
+	trace_kvm_mmu_sync_page(sp);
 	sp->unsync = 0;
 	--kvm->stat.mmu_unsync;
 }
@@ -1202,7 +1203,6 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		return 1;
 	}
 
-	trace_kvm_mmu_sync_page(sp);
 	if (rmap_write_protect(vcpu->kvm, sp->gfn))
 		kvm_flush_remote_tlbs(vcpu->kvm);
 	kvm_unlink_unsync_page(vcpu->kvm, sp);
@@ -1730,7 +1730,6 @@ static int kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	struct kvm_mmu_page *s;
 	struct hlist_node *node, *n;
 
-	trace_kvm_mmu_unsync_page(sp);
 	index = kvm_page_table_hashfn(sp->gfn);
 	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
 	/* don't unsync if pagetable is shadowed with multiple roles */
@@ -1740,6 +1739,7 @@ static int kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		if (s->role.word != sp->role.word)
 			return 1;
 	}
+	trace_kvm_mmu_unsync_page(sp);
 	++vcpu->kvm->stat.mmu_unsync;
 	sp->unsync = 1;
 
-- 
1.6.1.2


