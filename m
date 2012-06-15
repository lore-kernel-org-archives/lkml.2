Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab2FOVtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:49:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43238 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab2FOVtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:49:47 -0400
Date: Sat, 16 Jun 2012 06:49:42 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: avi@redhat.com, mtosatti@redhat.com, agraf@suse.de, paulus@samba.org,
        aarcange@redhat.com, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: Introduce hva_to_gfn() for kvm_handle_hva()
Message-Id: <20120616064942.782494439992bd32046f7758@gmail.com>
In-Reply-To: <20120615203144.2cbcd88f.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120615203007.4f61bb17.yoshikawa.takuya@oss.ntt.co.jp>
	<20120615203144.2cbcd88f.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2012 20:31:44 +0900
Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp> wrote:

...

> diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> index d03eb6f..53716dd 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> @@ -767,15 +767,13 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
>  
>  	slots = kvm_memslots(kvm);
>  	kvm_for_each_memslot(memslot, slots) {
> -		unsigned long start = memslot->userspace_addr;
> -		unsigned long end;
> +		gfn_t gfn = hva_to_gfn(hva, memslot);
>  
> -		end = start + (memslot->npages << PAGE_SHIFT);
> -		if (hva >= start && hva < end) {
> -			gfn_t gfn_offset = (hva - start) >> PAGE_SHIFT;
> +		if (gfn >= memslot->base_gfn &&
> +		    gfn < memslot->base_gfn + memslot->npages) {

Here
...

> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index a2f3969..ba57b3b 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1199,14 +1199,10 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
>  	slots = kvm_memslots(kvm);
>  
>  	kvm_for_each_memslot(memslot, slots) {
> -		unsigned long start = memslot->userspace_addr;
> -		unsigned long end;
> -
> -		end = start + (memslot->npages << PAGE_SHIFT);
> -		if (hva >= start && hva < end) {
> -			gfn_t gfn_offset = (hva - start) >> PAGE_SHIFT;
> -			gfn_t gfn = memslot->base_gfn + gfn_offset;
> +		gfn_t gfn = hva_to_gfn(hva, memslot);
>  
> +		if (gfn >= memslot->base_gfn &&
> +		    gfn < memslot->base_gfn + memslot->npages) {

and here
...

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 27ac8a4..92b2029 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -740,6 +740,13 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
>  		(base_gfn >> KVM_HPAGE_GFN_SHIFT(level));
>  }
>  
> +static inline gfn_t hva_to_gfn(unsigned long hva, struct kvm_memory_slot *slot)
> +{
> +	gfn_t gfn_offset = (hva - slot->userspace_addr) >> PAGE_SHIFT;
> +
> +	return slot->base_gfn + gfn_offset;
> +}

Something wrong may happen when hva < slot->userspace_addr.

I will fix this after I get some feedback for other parts.

	Takuya
