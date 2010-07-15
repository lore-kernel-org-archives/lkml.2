Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970Ab0GORxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 13:53:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933930Ab0GORxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 13:53:38 -0400
Date: Thu, 15 Jul 2010 13:40:48 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/4] KVM: MMU: track dirty page in speculative path
 properly
Message-ID: <20100715164048.GA6980@amt.cnet>
References: <4C3C3518.7080505@cn.fujitsu.com>
 <4C3C35B7.50101@cn.fujitsu.com>
 <20100713220551.GB6370@amt.cnet>
 <4C3D11C6.4000101@cn.fujitsu.com>
 <20100714110926.GA26033@amt.cnet>
 <4C3DB942.3010709@cn.fujitsu.com>
 <20100714140626.GA28485@amt.cnet>
 <4C3EBC70.2030604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3EBC70.2030604@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 03:44:48PM +0800, Xiao Guangrong wrote:
> 
> 
> Marcelo Tosatti wrote:
> 
> >> How about just track access bit for speculative path, we set page both accessed and
> >> dirty(if it's writable) only if the access bit is set?
> > 
> > A useful thing to do would be to allow read-only mappings, in the fault
> > path (Lai sent a few patches in that direction sometime ago but there
> > was no follow up).
> > 
> > So in the case of a read-only fault from the guest, you'd inform
> > get_user_pages() that read-only access is acceptable (so swapcache pages
> > can be mapped, or qemu can mprotect(PROT_READ) guest memory).
> > 
> 
> Yeah, it's a great work, i guess Lai will post the new version soon.
> 
> And, even we do this, i think the page dirty track is still needed, right?
> Then, how about my new idea to track page dirty for speculative path, just
> as below draft patch does:
> 
> @@ -687,10 +687,11 @@ static void drop_spte(struct kvm *kvm, u64 *sptep, u64 new_spte)
>         if (!is_rmap_spte(old_spte))
>                 return;
>         pfn = spte_to_pfn(old_spte);
> -       if (old_spte & shadow_accessed_mask)
> +       if (old_spte & shadow_accessed_mask) {
>                 kvm_set_pfn_accessed(pfn);
> -       if (is_writable_pte(old_spte))
> -               kvm_set_pfn_dirty(pfn);
> +               if (is_writable_pte(old_spte))
> +                       kvm_set_pfn_dirty(pfn);
> +       }
>         rmap_remove(kvm, sptep);
>  }
>  
> @@ -1920,8 +1921,11 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>          * demand paging).
>          */
>         spte = shadow_base_present_pte | shadow_dirty_mask;
> -       if (!speculative)
> +       if (!speculative) {
>                 spte |= shadow_accessed_mask;
> +               if (is_writable_pte(*sptep))
> +                       kvm_set_pfn_dirty(pfn);
> +       }
>         if (!dirty)
>                 pte_access &= ~ACC_WRITE_MASK;
>         if (pte_access & ACC_EXEC_MASK)
> 
> It uses access bit to track both page accessed and page dirty, and it's rather cheap...

Xiao,

I don't understand it. What are you trying to achieve?
