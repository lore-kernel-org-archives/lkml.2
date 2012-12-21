Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab2LUNYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 08:24:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab2LUNYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 08:24:35 -0500
Message-ID: <1356096270.3625.37.camel@ul30vt.home>
Subject: Re: [PATCH 0/7] KVM: Alleviate mmu_lock hold time when we start
 dirty logging
From: Alex Williamson <alex.williamson@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 21 Dec 2012 06:24:30 -0700
In-Reply-To: <20121221085404.GQ29007@redhat.com>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
	 <20121219213037.b234f9d4f187df2132e65576@gmail.com>
	 <1355931777.3224.562.camel@bling.home>
	 <20121220140232.67733085.yoshikawa_takuya_b1@lab.ntt.co.jp>
	 <20121220125946.GB7750@amt.cnet> <20121220132255.GH17584@redhat.com>
	 <1356010887.10845.11.camel@ul30vt.home>
	 <20121220233545.95378d066b2ce61a76106a88@gmail.com>
	 <1356015343.10845.16.camel@ul30vt.home>
	 <20121221170250.067716b4.yoshikawa_takuya_b1@lab.ntt.co.jp>
	 <20121221085404.GQ29007@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 10:54 +0200, Gleb Natapov wrote:
> On Fri, Dec 21, 2012 at 05:02:50PM +0900, Takuya Yoshikawa wrote:
> > On Thu, 20 Dec 2012 07:55:43 -0700
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> > 
> > > > Yes, the fix should work, but I do not want to update the
> > > > generation from outside of update_memslots().
> > > 
> > > Ok, then:
> > >
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 87089dd..c7b5061 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -413,7 +413,8 @@ void kvm_exit(void);
> > >  
> > >  void kvm_get_kvm(struct kvm *kvm);
> > >  void kvm_put_kvm(struct kvm *kvm);
> > > -void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new);
> > > +void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new,
> > > +                     u64 last_generation);
> > >  
> > >  static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
> > >  {
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index c4c8ec1..06961ea 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -667,7 +667,8 @@ static void sort_memslots(struct kvm_memslots *slots)
> > >  		slots->id_to_index[slots->memslots[i].id] = i;
> > >  }
> > >  
> > > -void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)
> > > +void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new,
> > > +                     u64 last_generation)
> > >  {
> > >  	if (new) {
> > >  		int id = new->id;
> > > @@ -679,7 +680,7 @@ void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)
> > >  			sort_memslots(slots);
> > >  	}
> > >  
> > > -	slots->generation++;
> > > +	slots->generation = last_generation + 1;
> > >  }
> > >  
> > >  static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
> > > @@ -814,7 +815,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
> > >  		slot = id_to_memslot(slots, mem->slot);
> > >  		slot->flags |= KVM_MEMSLOT_INVALID;
> > >  
> > > -		update_memslots(slots, NULL);
> > > +		update_memslots(slots, NULL, kvm->memslots->generation);
> > >  
> > >  		old_memslots = kvm->memslots;
> > >  		rcu_assign_pointer(kvm->memslots, slots);
> > > @@ -862,7 +863,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
> > >  		memset(&new.arch, 0, sizeof(new.arch));
> > >  	}
> > >  
> > > -	update_memslots(slots, &new);
> > > +	update_memslots(slots, &new, kvm->memslots->generation);
> > >  	old_memslots = kvm->memslots;
> > >  	rcu_assign_pointer(kvm->memslots, slots);
> > >  	synchronize_srcu_expedited(&kvm->srcu);
> > > 
> > > > > The original patch can be reverted, there are no following dependencies,
> > > > > but the idea was that we're making the memslot array larger, so there
> > > > > could be more pressure in allocating it, so let's not trivially do extra
> > > > > frees and allocs.  Thanks,
> > > > 
> > > > I agree that the current set_memory_region() is not good for frequent updates.
> > > > But the alloc/free is not a major factor at the moment: flushing shadows should
> > > > be more problematic.
> > > 
> > > I don't understand why we'd throw away even a minor optimization that's
> > > so easy to fix.  We're not only removing a free/alloc, but we're being
> > > more friendly to the cache by avoiding the extra memcpy.  The above also
> > > makes the generation management a bit more explicit.  Thanks,
> > 
> > Looks good to me!
> > 
> Me too.
> 
> > I just wanted to keep the code readable, so no reason to object to
> > a clean solution.  Any chance to see the fix on kvm.git soon?
> > 
> Soon after Alex will send proper patch with Signed-off-by.

I'll test and do that first thing today, thanks,

Alex

