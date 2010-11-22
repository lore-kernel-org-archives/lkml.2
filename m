Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab0KVVqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 16:46:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757008Ab0KVVqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 16:46:24 -0500
Date: Mon, 22 Nov 2010 19:46:03 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/6] KVM: MMU: delay flush all tlbs on sync_page path
Message-ID: <20101122214602.GB7678@amt.cnet>
References: <4CE63CF4.80502@cn.fujitsu.com>
 <4CE63DE2.9050408@cn.fujitsu.com>
 <20101119161118.GB20279@amt.cnet>
 <4CE9E74E.7070908@cn.fujitsu.com>
 <20101122141925.GA30902@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101122141925.GA30902@amt.cnet>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 12:19:25PM -0200, Marcelo Tosatti wrote:
> On Mon, Nov 22, 2010 at 11:45:18AM +0800, Xiao Guangrong wrote:
> > On 11/20/2010 12:11 AM, Marcelo Tosatti wrote:
> > 
> > >>  void kvm_flush_remote_tlbs(struct kvm *kvm)
> > >>  {
> > >> +	int dirty_count = atomic_read(&kvm->tlbs_dirty);
> > >> +
> > >> +	smp_mb();
> > >>  	if (make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
> > >>  		++kvm->stat.remote_tlb_flush;
> > >> +	atomic_sub(dirty_count, &kvm->tlbs_dirty);
> > >>  }
> > > 
> > > This is racy because kvm_flush_remote_tlbs might be called without
> > > mmu_lock protection.
> > 
> > Sorry for my carelessness, it should be 'cmpxchg' here.
> > 
> > > You could decrease the counter on
> > > invalidate_page/invalidate_range_start only, 
> > 
> > I want to avoid a unnecessary tlbs flush, if tlbs have been flushed
> > after sync_page, then we don't need flush tlbs on invalidate_page/
> > invalidate_range_start path.
> > 
> > > these are not fast paths
> > > anyway.
> > > 
> > 
> > How about below patch? it just needs one atomic operation.
> > 
> > ---
> >  arch/x86/kvm/paging_tmpl.h |    4 ++--
> >  include/linux/kvm_host.h   |    2 ++
> >  virt/kvm/kvm_main.c        |    7 ++++++-
> >  3 files changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> > index dfb906f..e64192f 100644
> > --- a/arch/x86/kvm/paging_tmpl.h
> > +++ b/arch/x86/kvm/paging_tmpl.h
> > @@ -781,14 +781,14 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
> >  		gfn = gpte_to_gfn(gpte);
> >  
> >  		if (FNAME(map_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
> > -			kvm_flush_remote_tlbs(vcpu->kvm);
> > +			vcpu->kvm->tlbs_dirty++;
> >  			continue;
> >  		}
> >  
> >  		if (gfn != sp->gfns[i]) {
> >  			drop_spte(vcpu->kvm, &sp->spt[i],
> >  				      shadow_trap_nonpresent_pte);
> > -			kvm_flush_remote_tlbs(vcpu->kvm);
> > +			vcpu->kvm->tlbs_dirty++;
> >  			continue;
> >  		}
> >  
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 4bd663d..dafd90e 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -249,6 +249,7 @@ struct kvm {
> >  	struct mmu_notifier mmu_notifier;
> >  	unsigned long mmu_notifier_seq;
> >  	long mmu_notifier_count;
> > +	long tlbs_dirty;
> >  #endif
> >  };
> >  
> > @@ -377,6 +378,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu);
> >  void kvm_resched(struct kvm_vcpu *vcpu);
> >  void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
> >  void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
> > +
> >  void kvm_flush_remote_tlbs(struct kvm *kvm);
> >  void kvm_reload_remote_mmus(struct kvm *kvm);
> >  
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index fb93ff9..fe0a1a7 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -168,8 +168,12 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
> >  
> >  void kvm_flush_remote_tlbs(struct kvm *kvm)
> >  {
> > +	long dirty_count = kvm->tlbs_dirty;
> > +
> > +	smp_mb();
> >  	if (make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
> >  		++kvm->stat.remote_tlb_flush;
> 
> <---
> 
> > +	cmpxchg(&kvm->tlbs_dirty, dirty_count, 0);
> >  }
> 
> 
> Still problematic, if tlbs_dirty is set in the point indicated above.
> 
> Invalidate page should be quite rare, so checking for tlb_dirty only
> there is OK.
> 

My bad, the patch is fine.

