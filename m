Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab2LFDvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 22:51:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab2LFDvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 22:51:38 -0500
Message-ID: <1354765897.3224.71.camel@bling.home>
Subject: Re: [RFC PATCH 5/6] kvm: Re-introduce memslots->nmemslots
From: Alex Williamson <alex.williamson@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, gleb@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 05 Dec 2012 20:51:37 -0700
In-Reply-To: <20121206014507.GA9890@amt.cnet>
References: <20121203231912.3661.57179.stgit@bling.home>
	 <20121203233936.3661.69261.stgit@bling.home>
	 <20121205212629.GD20260@amt.cnet> <1354748573.3224.63.camel@bling.home>
	 <20121206014507.GA9890@amt.cnet>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-05 at 23:45 -0200, Marcelo Tosatti wrote:
> On Wed, Dec 05, 2012 at 04:02:53PM -0700, Alex Williamson wrote:
> > On Wed, 2012-12-05 at 19:26 -0200, Marcelo Tosatti wrote:
> > > On Mon, Dec 03, 2012 at 04:39:36PM -0700, Alex Williamson wrote:
> > > > struct kvm_memory_slot is currently 52 bytes (LP64), not counting the
> > > > arch data.  On x86 this means the memslot array to support a tiny 32+3
> > > > entries (user+private) is over 2k.  We'd like to support more slots
> > > > so that we can support more assigned devices, but it doesn't make
> > > > sense to penalize everyone by using a statically allocated array.
> > > > This allows us to start introducing a grow-able array.
> > > > 
> > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > ---
> > > >  arch/ia64/kvm/kvm-ia64.c     |    2 +-
> > > >  arch/powerpc/kvm/book3s_hv.c |    2 +-
> > > >  arch/x86/kvm/vmx.c           |    1 +
> > > >  arch/x86/kvm/x86.c           |    4 +++-
> > > >  include/linux/kvm_host.h     |    9 ++++++---
> > > >  virt/kvm/kvm_main.c          |   10 ++++++----
> > > >  6 files changed, 18 insertions(+), 10 deletions(-)
> > > > 
> > > > diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
> > > > index 012e5dd..96401b5 100644
> > > > --- a/arch/ia64/kvm/kvm-ia64.c
> > > > +++ b/arch/ia64/kvm/kvm-ia64.c
> > > > @@ -1836,7 +1836,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
> > > >  
> > > >  	memslot = id_to_memslot(kvm->memslots, log->slot);
> > > >  	r = -ENOENT;
> > > > -	if (!memslot->dirty_bitmap)
> > > > +	if (!memslots || !memslot->dirty_bitmap)
> > > >  		goto out;
> > > >  
> > > >  	kvm_ia64_sync_dirty_log(kvm, memslot);
> > > > diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> > > > index 56067db..0417190 100644
> > > > --- a/arch/powerpc/kvm/book3s_hv.c
> > > > +++ b/arch/powerpc/kvm/book3s_hv.c
> > > > @@ -1267,7 +1267,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
> > > >  
> > > >  	memslot = id_to_memslot(kvm->memslots, log->slot);
> > > >  	r = -ENOENT;
> > > > -	if (!memslot->dirty_bitmap)
> > > > +	if (!memslot || !memslot->dirty_bitmap)
> > > >  		goto out;
> > > >  
> > > >  	n = kvm_dirty_bitmap_bytes(memslot);
> > > > diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> > > > index 2bb9157..07fdd90 100644
> > > > --- a/arch/x86/kvm/vmx.c
> > > > +++ b/arch/x86/kvm/vmx.c
> > > > @@ -2751,6 +2751,7 @@ static gva_t rmode_tss_base(struct kvm *kvm)
> > > >  
> > > >  		slots = kvm_memslots(kvm);
> > > >  		slot = id_to_memslot(slots, KVM_PRIVATE_MEM_SLOTS);
> > > > +		BUG_ON(!slot);
> > > >  		base_gfn = slot->base_gfn + slot->npages - 3;
> > > >  
> > > >  		return base_gfn << PAGE_SHIFT;
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index 8765485..53fe9b2 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -3139,9 +3139,11 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
> > > >  		goto out;
> > > >  
> > > >  	memslot = id_to_memslot(kvm->memslots, log->slot);
> > > > +	r = -ENOENT;
> > > > +	if (!memslot)
> > > > +		goto out;
> > > >  
> > > >  	dirty_bitmap = memslot->dirty_bitmap;
> > > > -	r = -ENOENT;
> > > >  	if (!dirty_bitmap)
> > > >  		goto out;
> > > >  
> > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > index 7b3d5c4..1955a4e 100644
> > > > --- a/include/linux/kvm_host.h
> > > > +++ b/include/linux/kvm_host.h
> > > > @@ -313,6 +313,7 @@ struct kvm_irq_routing_table {};
> > > >   * to get the memslot by its id.
> > > >   */
> > > >  struct kvm_memslots {
> > > > +	int nmemslots;
> > > >  	u64 generation;
> > > >  	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
> > > >  };
> > > > @@ -397,7 +398,7 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
> > > >  
> > > >  #define kvm_for_each_memslot(memslot, slots)	\
> > > >  	for (memslot = &slots->memslots[0];	\
> > > > -	      memslot < slots->memslots + KVM_MEM_SLOTS_NUM && memslot->npages;\
> > > > +	      memslot < slots->memslots + slots->nmemslots && memslot->npages;\
> > > >  		memslot++)
> > > >  
> > > >  int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
> > > > @@ -424,10 +425,12 @@ static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
> > > >  static inline struct kvm_memory_slot *
> > > >  id_to_memslot(struct kvm_memslots *slots, int id)
> > > >  {
> > > > -	int index = slots->memslots[id].id_to_index;
> > > >  	struct kvm_memory_slot *slot;
> > > >  
> > > > -	slot = &slots->memslots[index];
> > > > +	if (id >= slots->nmemslots)
> > > > +		return NULL;
> > > > +
> > > > +	slot = &slots->memslots[slots->memslots[id].id_to_index];
> > > >  
> > > >  	WARN_ON(slot->id != id);
> > > >  	return slot;
> > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > index 3ce2664..ebd3960 100644
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > > @@ -444,7 +444,9 @@ static void kvm_init_memslots_id(struct kvm *kvm)
> > > >  	int i;
> > > >  	struct kvm_memslots *slots = kvm->memslots;
> > > >  
> > > > -	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
> > > > +	slots->nmemslots = KVM_MEM_SLOTS_NUM;
> > > > +
> > > > +	for (i = 0; i < kvm->memslots->nmemslots; i++)
> > > >  		slots->memslots[i].id_to_index = slots->memslots[i].id = i;
> > > >  }
> > > >  
> > > > @@ -658,10 +660,10 @@ static void sort_memslots(struct kvm_memslots *slots)
> > > >  {
> > > >  	int i;
> > > >  
> > > > -	sort(slots->memslots, KVM_MEM_SLOTS_NUM,
> > > > +	sort(slots->memslots, slots->nmemslots,
> > > >  	      sizeof(struct kvm_memory_slot), cmp_memslot, NULL);
> > > >  
> > > > -	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
> > > > +	for (i = 0; i < slots->nmemslots; i++)
> > > >  		slots->memslots[slots->memslots[i].id].id_to_index = i;
> > > >  }
> > > >  
> > > > @@ -898,7 +900,7 @@ int kvm_get_dirty_log(struct kvm *kvm,
> > > >  
> > > >  	memslot = id_to_memslot(kvm->memslots, log->slot);
> > > >  	r = -ENOENT;
> > > > -	if (!memslot->dirty_bitmap)
> > > > +	if (!memslot || !memslot->dirty_bitmap)
> > > >  		goto out;
> > > >  
> > > >  	n = kvm_dirty_bitmap_bytes(memslot);
> > > 
> > > I suppose this should be checked earlier, not at id_to_memslot time.
> > > eg for kvm_get_dirty_log at 
> > > 
> > >         r = -EINVAL;
> > >         if (log->slot >= KVM_MEMORY_SLOTS)
> > >                 goto out;
> > > 
> > > time
> > 
> > id_to_memslot seems like a good place to catch all the users since
> > that's the only way to get a slot from a slot id after the array is
> > sorted.  We need to check both is the slot in bounds (EINVAL), but also
> > is it allocated (ENOENT).  id_to_memslot could both of these if we
> > wanted to switch it to ERR_PTR.  Thanks,
> > 
> > Alex
> 
> There should never be a reference to a slot out of bounds by KVM itself
> (BUG_ON). Only userspace can attempt a reference to such slot.

If I understand correctly, you're saying this last chunk is unique
because kvm_get_dirty_log() is an internal interface and the test should
be restricted to callers from userspace interfaces, namely
kvm_vm_ioctl_get_dirty_log().  That sounds reasonable; book3s_pr seems
to be the only caller that relies on kvm_get_dirty_log() validating the
slot.  Thanks,

Alex

