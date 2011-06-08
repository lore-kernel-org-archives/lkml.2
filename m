Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1FHDOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 23:14:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64823 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab1FHDO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 23:14:28 -0400
Message-ID: <4DEEE98E.6090102@cn.fujitsu.com>
Date: Wed, 08 Jun 2011 11:16:30 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 05/15] KVM: MMU: optimize to handle dirty bit
References: <4DEE205E.8000601@cn.fujitsu.com> <4DEE210E.2000404@cn.fujitsu.com>
In-Reply-To: <4DEE210E.2000404@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-08 11:14:12,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-08 11:14:14,
	Serialize complete at 2011-06-08 11:14:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 09:01 PM, Xiao Guangrong wrote:
> If dirty bit is not set, we can make the pte access read-only to avoid handing
> dirty bit everywhere

> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index b0c8184..67971da 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -106,6 +106,9 @@ static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte)
>  	unsigned access;
>  
>  	access = (gpte & (PT_WRITABLE_MASK | PT_USER_MASK)) | ACC_EXEC_MASK;
> +	if (!is_dirty_gpte(gpte))
> +		access &= ~ACC_WRITE_MASK;
> +

Sorry, it can break something: if the gpte is not on the last level and dirty bit
is set later, below patch should fix it, i'll merge it into in the next version.

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 4287dc8..6ceb5fd 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -101,12 +101,13 @@ static int FNAME(cmpxchg_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	return (ret != orig_pte);
 }
 
-static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte)
+static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte,
+				   bool last)
 {
 	unsigned access;
 
 	access = (gpte & (PT_WRITABLE_MASK | PT_USER_MASK)) | ACC_EXEC_MASK;
-	if (!is_dirty_gpte(gpte))
+	if (last && !is_dirty_gpte(gpte))
 		access &= ~ACC_WRITE_MASK;
 
 #if PTTYPE == 64
@@ -230,8 +231,6 @@ walk:
 			pte |= PT_ACCESSED_MASK;
 		}
 
-		pte_access = pt_access & FNAME(gpte_access)(vcpu, pte);
-
 		walker->ptes[walker->level - 1] = pte;
 
 		if ((walker->level == PT_PAGE_TABLE_LEVEL) ||
@@ -266,7 +265,7 @@ walk:
 			break;
 		}
 
-		pt_access = pte_access;
+		pt_access &= FNAME(gpte_access)(vcpu, pte, false);
 		--walker->level;
 	}
 
@@ -290,6 +289,7 @@ walk:
 		walker->ptes[walker->level - 1] = pte;
 	}
 
+	pte_access = pt_access & FNAME(gpte_access)(vcpu, pte, true);
 	walker->pt_access = pt_access;
 	walker->pte_access = pte_access;
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
@@ -369,7 +369,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		return;
 
 	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
-	pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
+	pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte, true);
 	pfn = gfn_to_pfn_atomic(vcpu->kvm, gpte_to_gfn(gpte));
 	if (mmu_invalid_pfn(pfn)) {
 		kvm_release_pfn_clean(pfn);
@@ -444,7 +444,8 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
 			continue;
 
-		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
+		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte,
+								  true);
 		gfn = gpte_to_gfn(gpte);
 		pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
 				      pte_access & ACC_WRITE_MASK);
@@ -790,7 +791,7 @@ static bool FNAME(sync_mmio_spte)(struct kvm_vcpu *vcpu,
 	if (unlikely(is_mmio_spte(*sptep))) {
 		gfn_t gfn = gpte_to_gfn(gpte);
 		unsigned access = sp->role.access & FNAME(gpte_access)(vcpu,
-							gpte);
+							gpte, true);
 
 		if (gfn != get_mmio_spte_gfn(*sptep)) {
 			__set_spte(sptep, shadow_trap_nonpresent_pte);
@@ -868,7 +869,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		}
 
 		nr_present++;
-		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
+		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte,
+								  true);
 		host_writable = sp->spt[i] & SPTE_HOST_WRITEABLE;
 
 		set_spte(vcpu, &sp->spt[i], pte_access, 0, 0,
