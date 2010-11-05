Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab0KEFfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 01:35:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59386 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab0KEFfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 01:35:00 -0400
Message-ID: <4CD39886.4050909@cn.fujitsu.com>
Date: Fri, 05 Nov 2010 13:39:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: MMU: don not retry #PF for nonpaging guest
References: <4CD28B5F.1040205@cn.fujitsu.com> <4CD28BCA.1060907@cn.fujitsu.com> <20101104103548.GE6018@redhat.com>
In-Reply-To: <20101104103548.GE6018@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-05 13:35:24,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-05 13:35:25,
	Serialize complete at 2010-11-05 13:35:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2010 06:35 PM, Gleb Natapov wrote:
> On Thu, Nov 04, 2010 at 06:32:42PM +0800, Xiao Guangrong wrote:
>> nonpaing guest's 'direct_map' is also true, retry #PF for those
>> guests is useless, so use 'tdp_enabled' instead
>>
> nonpaging guest will not attempt async pf. 

Ah, my mistake, but why we can not attempt async pf for nonpaging guest?

> And by checking tdp_enabled
> here instead of direct_map we will screw nested ntp.
> 

It looks like something broken: apfs can generated in L2 guest (nested ntp guest)
and be retried in L1 guest.

Below patch fix it and let nonpaging guest support async pf. I'll post it properly
if you like. :-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7f20f2c..606978e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -600,6 +600,7 @@ struct kvm_x86_ops {
 struct kvm_arch_async_pf {
 	u32 token;
 	gfn_t gfn;
+	bool softmmu;
 };
 
 extern struct kvm_x86_ops *kvm_x86_ops;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f3fad4f..48ca312 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2286,7 +2286,10 @@ static int kvm_handle_bad_page(struct kvm *kvm, gfn_t gfn, pfn_t pfn)
 	return 1;
 }
 
-static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
+static bool try_async_pf(struct kvm_vcpu *vcpu, bool no_apf, gfn_t gfn,
+			 gva_t gva, pfn_t *pfn, bool write, bool *writable);
+
+static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn, bool no_apf)
 {
 	int r;
 	int level;
@@ -2307,7 +2310,9 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
-	pfn = gfn_to_pfn_prot(vcpu->kvm, gfn, write, &map_writable);
+
+	if (try_async_pf(vcpu, no_apf, gfn, v, &pfn, write, &map_writable))
+		return 0;
 
 	/* mmio */
 	if (is_error_pfn(pfn))
@@ -2594,7 +2599,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	gfn = gva >> PAGE_SHIFT;
 
 	return nonpaging_map(vcpu, gva & PAGE_MASK,
-			     error_code & PFERR_WRITE_MASK, gfn);
+			     error_code & PFERR_WRITE_MASK, gfn, no_apf);
 }
 
 static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
@@ -2602,6 +2607,7 @@ static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
 	struct kvm_arch_async_pf arch;
 	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
 	arch.gfn = gfn;
+	arch.softmmu = mmu_is_softmmu(vcpu);
 
 	return kvm_setup_async_pf(vcpu, gva, gfn, &arch);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2044302..d826d78 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6172,9 +6172,10 @@ EXPORT_SYMBOL_GPL(kvm_set_rflags);
 
 void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 {
+	bool softmmu = mmu_is_softmmu(vcpu);
 	int r;
 
-	if (!vcpu->arch.mmu.direct_map || is_error_page(work->page))
+	if (softmmu || work->arch.softmmu || is_error_page(work->page))
 		return;
 
 	r = kvm_mmu_reload(vcpu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2cea414..48796c7 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -55,6 +55,11 @@ static inline bool mmu_is_nested(struct kvm_vcpu *vcpu)
 	return vcpu->arch.walk_mmu == &vcpu->arch.nested_mmu;
 }
 
+static inline bool mmu_is_softmmu(struct kvm_vcpu *vcpu)
+{
+	return !tdp_enabled || mmu_is_nested(vcpu);
+}
+
 static inline int is_pae(struct kvm_vcpu *vcpu)
 {
 	return kvm_read_cr4_bits(vcpu, X86_CR4_PAE);

