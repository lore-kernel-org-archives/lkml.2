Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab0EKDo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 23:44:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159Ab0EKDov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 23:44:51 -0400
Date: Tue, 11 May 2010 00:28:28 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: avi@redhat.com, agraf@suse.de, yoshikawa.takuya@oss.ntt.co.jp,
       fernando@oss.ntt.co.jp, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
       kvm-ia64@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, x86@kernel.org, benh@kernel.crashing.org,
       paulus@samba.org, linuxppc-dev@ozlabs.org, arnd@arndb.de,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH RFC 10/12] KVM: move dirty bitmaps to user space
Message-ID: <20100511032827.GA3458@amt.cnet>
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
 <20100504220702.f8ba6ccc.takuya.yoshikawa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504220702.f8ba6ccc.takuya.yoshikawa@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 10:07:02PM +0900, Takuya Yoshikawa wrote:
> We move dirty bitmaps to user space.
> 
>  - Allocation and destruction: we use do_mmap() and do_munmap().
>    The new bitmap space is twice longer than the original one and we
>    use the additional space for double buffering: this makes it
>    possible to update the active bitmap while letting the user space
>    read the other one safely. For x86, we can also remove the vmalloc()
>    in kvm_vm_ioctl_get_dirty_log().
> 
>  - Bitmap manipulations: we replace all functions which access dirty
>    bitmaps with *_user() functions.
> 
>  - For ia64: moving the dirty bitmaps of memory slots does not affect
>    ia64 much because it's using a different place to store dirty logs
>    rather than the dirty bitmaps of memory slots: all we have to change
>    are sync and get of dirty log, so we don't need set_bit_user like
>    functions for ia64.
> 
> Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> CC: Avi Kivity <avi@redhat.com>
> CC: Alexander Graf <agraf@suse.de>
> ---
>  arch/ia64/kvm/kvm-ia64.c  |   15 +++++++++-
>  arch/powerpc/kvm/book3s.c |    5 +++-
>  arch/x86/kvm/x86.c        |   25 ++++++++----------
>  include/linux/kvm_host.h  |    3 +-
>  virt/kvm/kvm_main.c       |   62 +++++++++++++++++++++++++++++++++++++-------
>  5 files changed, 82 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
> index 17fd65c..03503e6 100644
> --- a/arch/ia64/kvm/kvm-ia64.c
> +++ b/arch/ia64/kvm/kvm-ia64.c
> @@ -1823,11 +1823,19 @@ static int kvm_ia64_sync_dirty_log(struct kvm *kvm,
>  	n = kvm_dirty_bitmap_bytes(memslot);
>  	base = memslot->base_gfn / BITS_PER_LONG;
>  
> +	r = -EFAULT;
> +	if (!access_ok(VERIFY_WRITE, memslot->dirty_bitmap, n))
> +		goto out;
> +
>  	for (i = 0; i < n/sizeof(long); ++i) {
>  		if (dirty_bitmap[base + i])
>  			memslot->is_dirty = true;
>  
> -		memslot->dirty_bitmap[i] = dirty_bitmap[base + i];
> +		if (__put_user(dirty_bitmap[base + i],
> +			       &memslot->dirty_bitmap[i])) {
> +			r = -EFAULT;
> +			goto out;
> +		}
>  		dirty_bitmap[base + i] = 0;
>  	}
>  	r = 0;
> @@ -1858,7 +1866,10 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
>  	if (memslot->is_dirty) {
>  		kvm_flush_remote_tlbs(kvm);
>  		n = kvm_dirty_bitmap_bytes(memslot);
> -		memset(memslot->dirty_bitmap, 0, n);
> +		if (clear_user(memslot->dirty_bitmap, n)) {
> +			r = -EFAULT;
> +			goto out;
> +		}
>  		memslot->is_dirty = false;
>  	}
>  	r = 0;
> diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> index 4b074f1..2a31d2f 100644
> --- a/arch/powerpc/kvm/book3s.c
> +++ b/arch/powerpc/kvm/book3s.c
> @@ -1210,7 +1210,10 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
>  			kvmppc_mmu_pte_pflush(vcpu, ga, ga_end);
>  
>  		n = kvm_dirty_bitmap_bytes(memslot);
> -		memset(memslot->dirty_bitmap, 0, n);
> +		if (clear_user(memslot->dirty_bitmap, n)) {
> +			r = -EFAULT;
> +			goto out;
> +		}
>  		memslot->is_dirty = false;
>  	}
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 023c7f8..32a3d94 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2760,40 +2760,37 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
>  	/* If nothing is dirty, don't bother messing with page tables. */
>  	if (memslot->is_dirty) {
>  		struct kvm_memslots *slots, *old_slots;
> -		unsigned long *dirty_bitmap;
> +		unsigned long __user *dirty_bitmap;
> +		unsigned long __user *dirty_bitmap_old;
>  
>  		spin_lock(&kvm->mmu_lock);
>  		kvm_mmu_slot_remove_write_access(kvm, log->slot);
>  		spin_unlock(&kvm->mmu_lock);
>  
> -		r = -ENOMEM;
> -		dirty_bitmap = vmalloc(n);
> -		if (!dirty_bitmap)
> +		dirty_bitmap = memslot->dirty_bitmap;
> +		dirty_bitmap_old = memslot->dirty_bitmap_old;
> +		r = -EFAULT;
> +		if (clear_user(dirty_bitmap_old, n))
>  			goto out;
> -		memset(dirty_bitmap, 0, n);
>  
>  		r = -ENOMEM;
>  		slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
> -		if (!slots) {
> -			vfree(dirty_bitmap);
> +		if (!slots)
>  			goto out;
> -		}
> +
>  		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
> -		slots->memslots[log->slot].dirty_bitmap = dirty_bitmap;
> +		slots->memslots[log->slot].dirty_bitmap = dirty_bitmap_old;
> +		slots->memslots[log->slot].dirty_bitmap_old = dirty_bitmap;
>  		slots->memslots[log->slot].is_dirty = false;
>  
>  		old_slots = kvm->memslots;
>  		rcu_assign_pointer(kvm->memslots, slots);
>  		synchronize_srcu_expedited(&kvm->srcu);
> -		dirty_bitmap = old_slots->memslots[log->slot].dirty_bitmap;
>  		kfree(old_slots);
>  
>  		r = -EFAULT;
> -		if (copy_to_user(log->dirty_bitmap, dirty_bitmap, n)) {
> -			vfree(dirty_bitmap);
> +		if (copy_in_user(log->dirty_bitmap, dirty_bitmap, n))
>  			goto out;
> -		}
> -		vfree(dirty_bitmap);
>  	} else {
>  		r = -EFAULT;
>  		if (clear_user(log->dirty_bitmap, n))
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0aa6ecb..c95e2b7 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -116,7 +116,8 @@ struct kvm_memory_slot {
>  	unsigned long npages;
>  	unsigned long flags;
>  	unsigned long *rmap;
> -	unsigned long *dirty_bitmap;
> +	unsigned long __user *dirty_bitmap;
> +	unsigned long __user *dirty_bitmap_old;
>  	bool is_dirty;
>  	struct {
>  		unsigned long rmap_pde;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3e3acad..ddcf65a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -437,8 +437,20 @@ out_err_nodisable:
>  
>  static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
>  {
> -	vfree(memslot->dirty_bitmap);
> +	unsigned long user_addr;
> +	unsigned long n = kvm_dirty_bitmap_bytes(memslot);
> +
> +	if (!memslot->dirty_bitmap)
> +		return;
> +
> +	user_addr = min((unsigned long)memslot->dirty_bitmap,
> +			(unsigned long)memslot->dirty_bitmap_old);
> +	down_write(&current->mm->mmap_sem);
> +	do_munmap(current->mm, user_addr, 2 * n);
> +	up_write(&current->mm->mmap_sem);
> +
>  	memslot->dirty_bitmap = NULL;
> +	memslot->dirty_bitmap_old = NULL;
>  }
>  
>  /*
> @@ -472,8 +484,12 @@ void kvm_free_physmem(struct kvm *kvm)
>  	int i;
>  	struct kvm_memslots *slots = kvm->memslots;
>  
> -	for (i = 0; i < slots->nmemslots; ++i)
> +	for (i = 0; i < slots->nmemslots; ++i) {
> +		/* VM process will exit: we don't unmap by ourselves. */
> +		slots->memslots[i].dirty_bitmap = NULL;
> +		slots->memslots[i].dirty_bitmap_old = NULL;
>  		kvm_free_physmem_slot(&slots->memslots[i], NULL);
> +	}
>  
>  	kfree(kvm->memslots);
>  }
> @@ -527,14 +543,35 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
>  
>  static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
>  {
> -	unsigned long dirty_bytes = kvm_dirty_bitmap_bytes(memslot);
> +	int err;
> +	unsigned long user_addr;
> +	unsigned long n = kvm_dirty_bitmap_bytes(memslot);
>  
> -	memslot->dirty_bitmap = vmalloc(dirty_bytes);
> -	if (!memslot->dirty_bitmap)
> -		return -ENOMEM;
> +	down_write(&current->mm->mmap_sem);
> +	user_addr = do_mmap(NULL, 0, 2 * n,
> +			    PROT_READ | PROT_WRITE,
> +			    MAP_PRIVATE | MAP_ANONYMOUS, 0);
> +	up_write(&current->mm->mmap_sem);
> +
> +	if (IS_ERR((void *)user_addr)) {
> +		err = PTR_ERR((void *)user_addr);
> +		goto out;
> +	}
> +
> +	memslot->dirty_bitmap = (unsigned long __user *)user_addr;
> +	memslot->dirty_bitmap_old = (unsigned long __user *)(user_addr + n);
> +	if (clear_user(memslot->dirty_bitmap, 2 * n)) {
> +		err = -EFAULT;
> +		goto out_unmap;
> +	}
>  
> -	memset(memslot->dirty_bitmap, 0, dirty_bytes);
>  	return 0;
> +out_unmap:
> +	down_write(&current->mm->mmap_sem);
> +	do_munmap(current->mm, user_addr, 2 * n);
> +	up_write(&current->mm->mmap_sem);
> +out:
> +	return err;
>  }
>  
>  /*
> @@ -799,7 +836,7 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
>  	n = kvm_dirty_bitmap_bytes(memslot);
>  
>  	r = -EFAULT;
> -	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
> +	if (copy_in_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
>  		goto out;
>  
>  	r = 0;
> @@ -1195,11 +1232,16 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
>  	gfn = unalias_gfn(kvm, gfn);
>  	memslot = gfn_to_memslot_unaliased(kvm, gfn);
>  	if (memslot && memslot->dirty_bitmap) {
> -		unsigned long rel_gfn = gfn - memslot->base_gfn;
> +		int nr = generic_le_bit_offset(gfn - memslot->base_gfn);
>  
> -		generic___set_le_bit(rel_gfn, memslot->dirty_bitmap);
> +		if (kvm_set_bit_user(nr, memslot->dirty_bitmap))
> +			goto out_fault;

mark_page_dirty is called with the mmu_lock spinlock held in set_spte.
Must find a way to move it outside of the spinlock section.

