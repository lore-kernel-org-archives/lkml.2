Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab0KWDIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 22:08:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62450 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab0KWDIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 22:08:46 -0500
Message-ID: <4CEB313C.1070507@cn.fujitsu.com>
Date: Tue, 23 Nov 2010 11:13:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/6] KVM: MMU: delay flush all tlbs on sync_page path
References: <4CE63CF4.80502@cn.fujitsu.com> <4CE63DE2.9050408@cn.fujitsu.com> <20101119161118.GB20279@amt.cnet> <4CE9E74E.7070908@cn.fujitsu.com> <20101122141925.GA30902@amt.cnet> <20101122214602.GB7678@amt.cnet>
In-Reply-To: <20101122214602.GB7678@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-23 11:09:03,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-23 11:09:03,
	Serialize complete at 2010-11-23 11:09:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2010 05:46 AM, Marcelo Tosatti wrote:

> 
> My bad, the patch is fine.
> 

Post the path with appropriate format and add some comments.

Subject: [PATCH v3 6/6] KVM: MMU: delay flush all tlbs on sync_page path
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Quote from Avi:
| I don't think we need to flush immediately; set a "tlb dirty" bit somewhere
| that is cleareded when we flush the tlb.  kvm_mmu_notifier_invalidate_page()
| can consult the bit and force a flush if set. 

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |   12 ++++++++++--
 include/linux/kvm_host.h   |    2 ++
 virt/kvm/kvm_main.c        |    7 ++++++-
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index a43f4cc..2b3d66c 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -746,6 +746,14 @@ static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
  * Using the cached information from sp->gfns is safe because:
  * - The spte has a reference to the struct page, so the pfn for a given gfn
  *   can't change unless all sptes pointing to it are nuked first.
+ *
+ * Note:
+ *   We should flush all tlbs if spte is dropped even though guest is
+ *   responsible for it. Since if we don't, kvm_mmu_notifier_invalidate_page
+ *   and kvm_mmu_notifier_invalidate_range_start detect the mapping page isn't
+ *   used by guest then tlbs are not flushed, so guest is allowed to access the
+ *   freed pages.
+ *   And we increase kvm->tlbs_dirty to delay tlbs flush in this case.
  */
 static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
@@ -781,14 +789,14 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		gfn = gpte_to_gfn(gpte);
 
 		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
-			kvm_flush_remote_tlbs(vcpu->kvm);
+			vcpu->kvm->tlbs_dirty++;
 			continue;
 		}
 
 		if (gfn != sp->gfns[i]) {
 			drop_spte(vcpu->kvm, &sp->spt[i],
 				      shadow_trap_nonpresent_pte);
-			kvm_flush_remote_tlbs(vcpu->kvm);
+			vcpu->kvm->tlbs_dirty++;
 			continue;
 		}
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f17beae..96a5e0b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -254,6 +254,7 @@ struct kvm {
 	struct mmu_notifier mmu_notifier;
 	unsigned long mmu_notifier_seq;
 	long mmu_notifier_count;
+	long tlbs_dirty;
 #endif
 };
 
@@ -382,6 +383,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu);
 void kvm_resched(struct kvm_vcpu *vcpu);
 void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
 void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
+
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_reload_remote_mmus(struct kvm *kvm);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fb93ff9..c4ee364 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -168,8 +168,12 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
+	int dirty_count = kvm->tlbs_dirty;
+
+	smp_mb();
 	if (make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
 		++kvm->stat.remote_tlb_flush;
+	cmpxchg(&kvm->tlbs_dirty, dirty_count, 0);
 }
 
 void kvm_reload_remote_mmus(struct kvm *kvm)
@@ -249,7 +253,7 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
 	kvm->mmu_notifier_seq++;
-	need_tlb_flush = kvm_unmap_hva(kvm, address);
+	need_tlb_flush = kvm_unmap_hva(kvm, address) | kvm->tlbs_dirty;
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 
@@ -293,6 +297,7 @@ static void kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	kvm->mmu_notifier_count++;
 	for (; start < end; start += PAGE_SIZE)
 		need_tlb_flush |= kvm_unmap_hva(kvm, start);
+	need_tlb_flush |= kvm->tlbs_dirty;
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 
-- 
1.7.0.4
