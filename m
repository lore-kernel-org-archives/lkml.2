Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0JYJIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:08:05 -0400
Received: from david.siemens.de ([192.35.17.14]:22440 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab0JYJIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:08:04 -0400
Message-ID: <4CC548C1.3060009@siemens.com>
Date: Mon, 25 Oct 2010 11:07:13 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] kvm: write protect memory after slot swap
References: <20101025012124.GA31262@redhat.com>
In-Reply-To: <20101025012124.GA31262@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.10.2010 03:21, Michael S. Tsirkin wrote:
> I have observed the following bug trigger:
> 
> 1. userspace calls GET_DIRTY_LOG
> 2. kvm_mmu_slot_remove_write_access is called and makes a page ro
> 3. page fault happens and makes the page writeable
>    fault is logged in the bitmap appropriately
> 4. kvm_vm_ioctl_get_dirty_log swaps slot pointers
> 
> a lot of time passes
> 
> 5. guest writes into the page
> 6. userspace calls GET_DIRTY_LOG
> 
> At point (5), bitmap is clean and page is writeable,
> thus, guest modification of memory is not logged
> and GET_DIRTY_LOG returns an empty bitmap.
> 

Cool, seems to be the key to the corruptions I've seen. Applying your
patch make them disappear.

> The rule is that all pages are either dirty in the current bitmap,
> or write-protected, which is violated here.
> 
> It seems that just moving kvm_mmu_slot_remove_write_access down
> to after the slot pointer swap should fix this bug.
> 
> Warning: completely untested.
> Please comment.
> Note: fix will be needed for -stable etc.

Assuming that a page cannot be write-enabled without having a dirty
entry in the old bitmap and due to the fact that user space won't get
hold of that old bitmap to read out the page before we reset write
access again, your patch should actually be safe.

If no one else sees some remaining race, let's get this applied upstream
ASAP and pushed down to the stable trees.

Thanks,
Jan

> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/x86/kvm/x86.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3a09c62..4ca1d7f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2912,10 +2912,6 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
>  		struct kvm_memslots *slots, *old_slots;
>  		unsigned long *dirty_bitmap;
>  
> -		spin_lock(&kvm->mmu_lock);
> -		kvm_mmu_slot_remove_write_access(kvm, log->slot);
> -		spin_unlock(&kvm->mmu_lock);
> -
>  		r = -ENOMEM;
>  		dirty_bitmap = vmalloc(n);
>  		if (!dirty_bitmap)
> @@ -2937,6 +2933,10 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
>  		dirty_bitmap = old_slots->memslots[log->slot].dirty_bitmap;
>  		kfree(old_slots);
>  
> +		spin_lock(&kvm->mmu_lock);
> +		kvm_mmu_slot_remove_write_access(kvm, log->slot);
> +		spin_unlock(&kvm->mmu_lock);
> +
>  		r = -EFAULT;
>  		if (copy_to_user(log->dirty_bitmap, dirty_bitmap, n)) {
>  			vfree(dirty_bitmap);

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
