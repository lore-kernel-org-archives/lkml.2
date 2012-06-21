Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab2FUIZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:25:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758723Ab2FUIZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:25:10 -0400
Message-ID: <4FE2DA5B.4080706@redhat.com>
Date: Thu, 21 Jun 2012 11:24:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, mtosatti@redhat.com,
        agraf@suse.de, paulus@samba.org, aarcange@redhat.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: MMU: Make kvm_handle_hva() handle range of addresses
References: <20120615203007.4f61bb17.yoshikawa.takuya@oss.ntt.co.jp> <20120615203230.2c577652.yoshikawa.takuya@oss.ntt.co.jp> <4FDF1AFE.4000607@redhat.com> <20120619224648.bbb360c6eeae9887de7b1f93@gmail.com>
In-Reply-To: <20120619224648.bbb360c6eeae9887de7b1f93@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 04:46 PM, Takuya Yoshikawa wrote:
> On Mon, 18 Jun 2012 15:11:42 +0300
> Avi Kivity <avi@redhat.com> wrote:
> 
>> Potential for improvement: don't do 512 iterations on same large page.
>> 
>> Something like
>> 
>>     if ((gfn ^ prev_gfn) & mask(level))
>>         ret |= handler(...)
>> 
>> with clever selection of the first prev_gfn so it always matches (~gfn
>> maybe).
> 
> 
> I thought up a better solution:
> 
> 1. Separate rmap_pde from lpage_info->write_count and
>    make this a simple array. (I once tried this.)
> 

This has the potential to increase cache misses, but I don't think it's
a killer.  The separation can simplify other things as well.


> 2. Use gfn_to_index() and loop over rmap array:
>  ...
>   /* intersection check */
>   start = max(start, memslot->userspace_addr);
>   end = min(end, memslot->userspace_addr +
>                  (memslot->npages << PAGE_SHIFT));
>   if (start > end)
>       continue;
> 
>   /* hva to gfn conversion */
>   gfn_start = hva_to_gfn_memslot(start);
>   gfn_end = hva_to_gfn_memslot(end);
> 
>   /* main part */
>   for each level {
>       rmapp = __gfn_to_rmap(gfn_start, level, memslot);
>       for (idx = gfn_to_index(gfn_start, memslot->base_gfn, level);
>            idx < gfn_to_index(gfn_end, memslot->base_gfn, level); idx++) {
>               ...
>           /* loop over rmap array */
>           ret |= handler(kvm, rmapp + idx, data);
>       }
>   }
> 

Probably want idx <= gfn_to_index(gfn_end-1, ...) otherwise we fail on
small slots.

-- 
error compiling committee.c: too many arguments to function


