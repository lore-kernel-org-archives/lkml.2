Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab2FRL7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:59:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab2FRL7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:59:44 -0400
Message-ID: <4FDF1826.3070006@redhat.com>
Date: Mon, 18 Jun 2012 14:59:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: mtosatti@redhat.com, agraf@suse.de, paulus@samba.org, aarcange@redhat.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH 2/4] KVM: Introduce hva_to_gfn() for kvm_handle_hva()
References: <20120615203007.4f61bb17.yoshikawa.takuya@oss.ntt.co.jp> <20120615203144.2cbcd88f.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120615203144.2cbcd88f.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2012 02:31 PM, Takuya Yoshikawa wrote:
> This restricts hva handling in mmu code and makes it easier to extend
> kvm_handle_hva() so that it can treat a range of addresses later in this
> patch series.
> 
> 
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

First you convert it, then you check if the conversion worked?  Let's
make is a straightforward check-then-convert (or check-and-convert).

>  			ret = 0;
>  
>  			for (j = PT_PAGE_TABLE_LEVEL;
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

Should be named hva_to_gfn_memslot(), like the below, to emphasise it
isn't generic.

> +
>  static inline unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot,
>  					       gfn_t gfn)
>  {
> 


-- 
error compiling committee.c: too many arguments to function


