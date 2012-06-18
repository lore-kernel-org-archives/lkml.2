Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab2FRMLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:11:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab2FRMLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:11:51 -0400
Message-ID: <4FDF1AFE.4000607@redhat.com>
Date: Mon, 18 Jun 2012 15:11:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: mtosatti@redhat.com, agraf@suse.de, paulus@samba.org, aarcange@redhat.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH 3/4] KVM: MMU: Make kvm_handle_hva() handle range of addresses
References: <20120615203007.4f61bb17.yoshikawa.takuya@oss.ntt.co.jp> <20120615203230.2c577652.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120615203230.2c577652.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2012 02:32 PM, Takuya Yoshikawa wrote:
> When guest's memory is backed by THP pages, MMU notifier needs to call
> kvm_unmap_hva(), which in turn leads to kvm_handle_hva(), in a loop to
> invalidate a range of pages which constitute one huge page:
> 
>   for each guest page
>     for each memslot
>       if page is in memslot
>         unmap using rmap
> 
> This means although every page in that range is expected to be found in
> the same memslot, we are forced to check unrelated memslots many times.
> If the guest has more memslots, the situation will become worse.
> 
> This patch, together with the following patch, solves this problem by
> introducing kvm_handle_hva_range() which makes the loop look like this:
> 
>   for each memslot
>     for each guest page in memslot
>       unmap using rmap
> 
> In this new processing, the actual work is converted to the loop over
> rmap array which is much more cache friendly than before.


Moreover, if the pages are in no slot (munmap of some non-guest memory),
then we're iterating over all those pages for no purpose.

> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index ba57b3b..3629f9b 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1185,10 +1185,13 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
>  	return 0;
>  }
>  
> -static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
> -			  unsigned long data,
> -			  int (*handler)(struct kvm *kvm, unsigned long *rmapp,
> -					 unsigned long data))
> +static int kvm_handle_hva_range(struct kvm *kvm,
> +				unsigned long start_hva,
> +				unsigned long end_hva,
> +				unsigned long data,
> +				int (*handler)(struct kvm *kvm,
> +					       unsigned long *rmapp,
> +					       unsigned long data))
>  {
>  	int j;
>  	int ret;
> @@ -1199,10 +1202,13 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
>  	slots = kvm_memslots(kvm);
>  
>  	kvm_for_each_memslot(memslot, slots) {
> -		gfn_t gfn = hva_to_gfn(hva, memslot);
> +		gfn_t gfn = hva_to_gfn(start_hva, memslot);
> +		gfn_t end_gfn = hva_to_gfn(end_hva, memslot);

These will return random results which you then use in min/max later, no?

> +
> +		gfn = max(gfn, memslot->base_gfn);
> +		end_gfn = min(end_gfn, memslot->base_gfn + memslot->npages);
>  
> -		if (gfn >= memslot->base_gfn &&
> -		    gfn < memslot->base_gfn + memslot->npages) {
> +		for (; gfn < end_gfn; gfn++) {
>  			ret = 0;
>  
>  			for (j = PT_PAGE_TABLE_LEVEL;
> @@ -1212,7 +1218,9 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
>  				rmapp = __gfn_to_rmap(gfn, j, memslot);
>  				ret |= handler(kvm, rmapp, data);

Potential for improvement: don't do 512 iterations on same large page.

Something like

    if ((gfn ^ prev_gfn) & mask(level))
        ret |= handler(...)

with clever selection of the first prev_gfn so it always matches (~gfn
maybe).


-- 
error compiling committee.c: too many arguments to function


