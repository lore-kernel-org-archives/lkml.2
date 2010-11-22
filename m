Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0KVDlK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 22:41:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51967 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756363Ab0KVDlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 22:41:08 -0500
Message-ID: <4CE9E74E.7070908@cn.fujitsu.com>
Date: Mon, 22 Nov 2010 11:45:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/6] KVM: MMU: delay flush all tlbs on sync_page path
References: <4CE63CF4.80502@cn.fujitsu.com> <4CE63DE2.9050408@cn.fujitsu.com> <20101119161118.GB20279@amt.cnet>
In-Reply-To: <20101119161118.GB20279@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-22 11:41:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-22 11:41:21,
	Serialize complete at 2010-11-22 11:41:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2010 12:11 AM, Marcelo Tosatti wrote:

>>  void kvm_flush_remote_tlbs(struct kvm *kvm)
>>  {
>> +	int dirty_count = atomic_read(&kvm->tlbs_dirty);
>> +
>> +	smp_mb();
>>  	if (make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
>>  		++kvm->stat.remote_tlb_flush;
>> +	atomic_sub(dirty_count, &kvm->tlbs_dirty);
>>  }
> 
> This is racy because kvm_flush_remote_tlbs might be called without
> mmu_lock protection.

Sorry for my carelessness, it should be 'cmpxchg' here.

> You could decrease the counter on
> invalidate_page/invalidate_range_start only, 

I want to avoid a unnecessary tlbs flush, if tlbs have been flushed
after sync_page, then we don't need flush tlbs on invalidate_page/
invalidate_range_start path.

> these are not fast paths
> anyway.
> 

How about below patch? it just needs one atomic operation.

---
 arch/x86/kvm/paging_tmpl.h |    4 ++--
 include/linux/kvm_host.h   |    2 ++
 virt/kvm/kvm_main.c        |    7 ++++++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index dfb906f..e64192f 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -781,14 +781,14 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		gfn = gpte_to_gfn(gpte);
 
 		if (FNAME(map_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
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
index 4bd663d..dafd90e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -249,6 +249,7 @@ struct kvm {
 	struct mmu_notifier mmu_notifier;
 	unsigned long mmu_notifier_seq;
 	long mmu_notifier_count;
+	long tlbs_dirty;
 #endif
 };
 
@@ -377,6 +378,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu);
 void kvm_resched(struct kvm_vcpu *vcpu);
 void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
 void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
+
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_reload_remote_mmus(struct kvm *kvm);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fb93ff9..fe0a1a7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -168,8 +168,12 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
+	long dirty_count = kvm->tlbs_dirty;
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
