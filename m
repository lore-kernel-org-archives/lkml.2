Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab2LUI2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:28:39 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:57091 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab2LUI2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:28:22 -0500
Date: Fri, 21 Dec 2012 17:05:41 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] KVM: Alleviate mmu_lock hold time when we start
 dirty logging
Message-Id: <20121221170541.d2299618.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <1356015343.10845.16.camel@ul30vt.home>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
	<20121219213037.b234f9d4f187df2132e65576@gmail.com>
	<1355931777.3224.562.camel@bling.home>
	<20121220140232.67733085.yoshikawa_takuya_b1@lab.ntt.co.jp>
	<20121220125946.GB7750@amt.cnet>
	<20121220132255.GH17584@redhat.com>
	<1356010887.10845.11.camel@ul30vt.home>
	<20121220233545.95378d066b2ce61a76106a88@gmail.com>
	<1356015343.10845.16.camel@ul30vt.home>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012 07:55:43 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> > Yes, the fix should work, but I do not want to update the
> > generation from outside of update_memslots().
> 
> Ok, then:
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 87089dd..c7b5061 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -413,7 +413,8 @@ void kvm_exit(void);
>  
>  void kvm_get_kvm(struct kvm *kvm);
>  void kvm_put_kvm(struct kvm *kvm);
> -void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new);
> +void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new,
> +                     u64 last_generation);
>  
>  static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
>  {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c4c8ec1..06961ea 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -667,7 +667,8 @@ static void sort_memslots(struct kvm_memslots *slots)
>  		slots->id_to_index[slots->memslots[i].id] = i;
>  }
>  
> -void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)
> +void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new,
> +                     u64 last_generation)
>  {
>  	if (new) {
>  		int id = new->id;
> @@ -679,7 +680,7 @@ void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)
>  			sort_memslots(slots);
>  	}
>  
> -	slots->generation++;
> +	slots->generation = last_generation + 1;
>  }
>  
>  static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
> @@ -814,7 +815,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		slot = id_to_memslot(slots, mem->slot);
>  		slot->flags |= KVM_MEMSLOT_INVALID;
>  
> -		update_memslots(slots, NULL);
> +		update_memslots(slots, NULL, kvm->memslots->generation);
>  
>  		old_memslots = kvm->memslots;
>  		rcu_assign_pointer(kvm->memslots, slots);
> @@ -862,7 +863,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		memset(&new.arch, 0, sizeof(new.arch));
>  	}
>  
> -	update_memslots(slots, &new);
> +	update_memslots(slots, &new, kvm->memslots->generation);
>  	old_memslots = kvm->memslots;
>  	rcu_assign_pointer(kvm->memslots, slots);
>  	synchronize_srcu_expedited(&kvm->srcu);
> 
> > > The original patch can be reverted, there are no following dependencies,
> > > but the idea was that we're making the memslot array larger, so there
> > > could be more pressure in allocating it, so let's not trivially do extra
> > > frees and allocs.  Thanks,
> > 
> > I agree that the current set_memory_region() is not good for frequent updates.
> > But the alloc/free is not a major factor at the moment: flushing shadows should
> > be more problematic.
> 
> I don't understand why we'd throw away even a minor optimization that's
> so easy to fix.  We're not only removing a free/alloc, but we're being
> more friendly to the cache by avoiding the extra memcpy.  The above also
> makes the generation management a bit more explicit.  Thanks,

Looks good to me!

I just wanted to keep the code readable, so no reason to object to
a clean solution.  Any chance to see the fix on kvm.git soon?

Thanks,
	Takuya
