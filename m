Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab0LGCng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:43:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49629 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab0LGCnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 21:43:35 -0500
Message-ID: <4CFDA066.6040009@cn.fujitsu.com>
Date: Tue, 07 Dec 2010 10:48:06 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] KVM: MMU: rename 'no_apf' to 'prefault'
References: <4CFD9D12.30709@cn.fujitsu.com>
In-Reply-To: <4CFD9D12.30709@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-07 10:43:36,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-07 10:43:37,
	Serialize complete at 2010-12-07 10:43:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 10:33 AM, Xiao Guangrong wrote:
> It's the speculative path if 'no_apf = 1' and we will specially handle this
> speculative path in the later patch, so 'prefault' is better to fit the sense
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    3 ++-
>  arch/x86/kvm/mmu.c              |   18 +++++++++---------
>  arch/x86/kvm/paging_tmpl.h      |    4 ++--
>  3 files changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index cfbcbfa..6dae67e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -241,7 +241,8 @@ struct kvm_mmu {
>  	void (*new_cr3)(struct kvm_vcpu *vcpu);
>  	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long root);
>  	unsigned long (*get_cr3)(struct kvm_vcpu *vcpu);
> -	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err, bool no_apf);
> +	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err,
> +			  bool prefoult);

Sorry for the noise, there is a typo, resent it.

Subject: [PATCH v5 1/3] KVM: MMU: rename 'no_apf' to 'prefault'

It's the speculative path if 'no_apf = 1' and we will specially handle this
speculative path in the later patch, so 'prefault' is better to fit the sense

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    3 ++-
 arch/x86/kvm/mmu.c              |   18 +++++++++---------
 arch/x86/kvm/paging_tmpl.h      |    4 ++--
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cfbcbfa..6dae67e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -241,7 +241,8 @@ struct kvm_mmu {
 	void (*new_cr3)(struct kvm_vcpu *vcpu);
 	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long root);
 	unsigned long (*get_cr3)(struct kvm_vcpu *vcpu);
-	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err, bool no_apf);
+	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err,
+			  bool prefault);
 	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
 				  struct x86_exception *fault);
 	void (*free)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d75ba1e..4954de9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2284,11 +2284,11 @@ static int kvm_handle_bad_page(struct kvm *kvm, gfn_t gfn, pfn_t pfn)
 	return 1;
 }
 
-static bool try_async_pf(struct kvm_vcpu *vcpu, bool no_apf, gfn_t gfn,
+static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			 gva_t gva, pfn_t *pfn, bool write, bool *writable);
 
 static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
-			 bool no_apf)
+			 bool prefault)
 {
 	int r;
 	int level;
@@ -2310,7 +2310,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, no_apf, gfn, v, &pfn, write, &map_writable))
+	if (try_async_pf(vcpu, prefault, gfn, v, &pfn, write, &map_writable))
 		return 0;
 
 	/* mmio */
@@ -2583,7 +2583,7 @@ static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gva_t vaddr,
 }
 
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
-				u32 error_code, bool no_apf)
+				u32 error_code, bool prefault)
 {
 	gfn_t gfn;
 	int r;
@@ -2599,7 +2599,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	gfn = gva >> PAGE_SHIFT;
 
 	return nonpaging_map(vcpu, gva & PAGE_MASK,
-			     error_code & PFERR_WRITE_MASK, gfn, no_apf);
+			     error_code & PFERR_WRITE_MASK, gfn, prefault);
 }
 
 static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
@@ -2621,7 +2621,7 @@ static bool can_do_async_pf(struct kvm_vcpu *vcpu)
 	return kvm_x86_ops->interrupt_allowed(vcpu);
 }
 
-static bool try_async_pf(struct kvm_vcpu *vcpu, bool no_apf, gfn_t gfn,
+static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			 gva_t gva, pfn_t *pfn, bool write, bool *writable)
 {
 	bool async;
@@ -2633,7 +2633,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool no_apf, gfn_t gfn,
 
 	put_page(pfn_to_page(*pfn));
 
-	if (!no_apf && can_do_async_pf(vcpu)) {
+	if (!prefault && can_do_async_pf(vcpu)) {
 		trace_kvm_try_async_get_page(gva, gfn);
 		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
 			trace_kvm_async_pf_doublefault(gva, gfn);
@@ -2649,7 +2649,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool no_apf, gfn_t gfn,
 }
 
 static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
-			  bool no_apf)
+			  bool prefault)
 {
 	pfn_t pfn;
 	int r;
@@ -2673,7 +2673,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, no_apf, gfn, gpa, &pfn, write, &map_writable))
+	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
 		return 0;
 
 	/* mmio */
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index d5a0a11..52b3e91 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -539,7 +539,7 @@ out_gpte_changed:
  *           a negative value on error.
  */
 static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
-			     bool no_apf)
+			     bool prefault)
 {
 	int write_fault = error_code & PFERR_WRITE_MASK;
 	int user_fault = error_code & PFERR_USER_MASK;
@@ -581,7 +581,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, no_apf, walker.gfn, addr, &pfn, write_fault,
+	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, write_fault,
 			 &map_writable))
 		return 0;
 
-- 
1.7.0.4
