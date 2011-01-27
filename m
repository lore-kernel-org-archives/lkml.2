Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab1A0AJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:09:31 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40443 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab1A0AJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:09:30 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4D40B874.6000203@np.css.fujitsu.com>
Date: Thu, 27 Jan 2011 09:12:36 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>,
        =?UTF-8?B?QUtQTeOAgA==?= <akpm@linux-foundation.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Huang Ying <ying.huang@intel.com>, LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Isolate only one page of anonymous THP
References: <4D3E63A0.9000301@np.css.fujitsu.com> <20110125224244.GK926@random.random>
In-Reply-To: <20110125224244.GK926@random.random>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrea
(2011/01/26 7:42), Andrea Arcangeli wrote:
> Hello Jin,
> 
> On Tue, Jan 25, 2011 at 02:46:08PM +0900, Jin Dongming wrote:
>> When the tail page of THP is poisoned, the head page will be
>> poisoned too.
>>
>> Lets make an assumption like following:
>>   1. Guest OS is running on KVM.
>>   2. Two processes(A and B) on Guest OS use pages in the same THP
>>      of Host.
>>      - process A is using the head page.
>>      - process B is using the tail pages.
>>
>>   So when the tail page is poisoned, process B should be killed.
>>   But process A is killed and process B is still alive in fact.
> 
> Do we have paravirt memory-failure support to actually kill single
> processes in guest depending on which page they run on instead of the
> whole guest?
Yes.
When the guest is running on KVM, such functionality is supported.

> 
>>   The reason for process A killed is that the head page is poisoned
>>   when the tail page is poisoned and the address reported
>>   with sigbus is the address of head page not the poisoned tail page.
>>
>>   The reason for process B alive is that PG_hwpoisoned of the poisoned
>>   tail page is cleared after the poisoned THP is split and the address
>>   reported with sigbus is the address of head page.
> 
> Agree about the fact we mark the head page poisoned instead of the
> tail page and it's not accurate as it should.
> 
>> It is expected that the process using the poisoned tail page is killed,
>> but not that the process using the healthy head page is killed.
>>
>> So it is better to avoid poisoning other than the page which is really
>> poisoned.
>>   (While we poison all pages in a huge page in case of hugetlb,
>>    we can do this for THP thanks to split_huge_page().)
> 
> Yes we can be more accurate with THP thanks to your change to
> __split_huge_page_refcount, full agreement with your huge_memory.c change.
> 
>>
>> Here we fix two parts:
>>   1. poison the real poisoned page only.
> 
> Agreed.
> 
>>   2. make the poisoned page work as the poisoned regular
>>      page(4k page).
> 
> You're adding one more unsafe compound_head() usage.
> 
> This is not a remark not specific to this patch, and I pointed this
> out already in some header commit of THP, but it likely got lost in
> the noise so I remind it here (and no, I don't expect everyone to read
> the headers, you're already doing great job at reading the code and
> the details of split_huge_page internals to fix these bits).
> 
> So in short my remark is that most compound_head() are broken for
> hugetlbfs too in memory-failure.c.
> 
> I introduced a compound_trans_head that can be used safely like
> memory-failure does in most places:
> 
> get_page_unless_zero(compound_head(pfn_to_page(pfn))) -> unsafe for THP and hugetlbfs (current status)
> get_page_unless_zero(compound_trans_head(pfn_to_page(pfn))) -> safe only for THP
> 
> I didn't go search and replace compound_trans_head in memory-failure
> because it would remain broken for hugetlbfs... so it wasn't
> definitive solution.
> 
> I however made a compound_trans_order that is safe for both (hugetlbfs
> I doubt frees the page from under you like split_huge_page could do,
> so after get_page_unless_zero succeeds on the head, hugetlbfs should
> be safe calling both compound_order or compound_trans_order, THP
> instead needs compound_trans_order). I'm afraid however that in some
> place compound_trans_order may be still unsafe for hugetlbfs if
> compound_trans_order is called on a hugetlbfs page before getting its
> refcount (it's definitely safe for THP instead).
> 
> I'm uncertain if it's worth to fix these races considering it's
> hardware failure we're talking about, so maybe math guarantee isn't
> needed for something that deals with an imperfect world that can crash
> anyway if the memory failure happens in a kernel .text. hugetlbfs
> allocations usually are static and practically only used by commercial
> DB, so it's almost impossible to hit the race in any practical case
> (unless you exercise it while the db shutsdown). It's your call...
> 
> If we don't fix the race for hugetlbfs, then you can go ahead and
> replace compound_head with compound_trans_head for every place where
> __split_huge_page_refcount can run from under you, and then THP will
> be math-safe. Very easy fix.
> 
> NOTE: when memcg calls compound_order it's safe because it's calling
> it always on the head page. Also if you call compound_order inside a
> page_table_lock when the hugepmd page isn't set to splitting yet, it's
> safe. The unsafe is taking an arbitrary pfn, convert to page struct,
> and run compound_order or compound_head on it, and it's equally unsafe
> for hugetlbfs and THP. The difference is, after get_page_unless_zero
> succeeds on hugetlbfs then you're safe calling compound_order, while
> for THP split_huge_page can still run and so compound_trans_order is
> needed.
> 
>> @@ -906,6 +907,14 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
>>  	}
>>  
>>  	/*
>> +	 * ppage: poisoned page
>> +	 *   if p is regular page(4k page) or THP(anonymous),
>> +	 *        ppage == real poisoned page;
>> +	 *   else p is hugetlb or others, ppage == head page.
>> +	 */
>> +	ppage = compound_head(p);
>> +
>> +	/*
>>  	 * First collect all the processes that have the page
>>  	 * mapped in dirty form.  This has to be done before try_to_unmap,
>>  	 * because ttu takes the rmap data structures down.
> 
> I would suggest to change it like this pseudocode:
> 
>  if (PageTransHuge(hpage)) {
>    /* verify that this isn't a hugetlbfs head page, the check for
>    PageAnon is just for avoid tripping a split_huge_page internal
>    debug check, as split_huge_page refuses to deal with anything that
>    isn't an anon page. PageAnon can't go away from under us because we
>    hold a refcount on the hpage, without a refcount on the hpage
>    split_huge_page can't be safely called in the first place, having a
>    refcount on the tail isn't enough to be safe. */
>    if (!PageHuge(hpage) && PageAnon(hpage)) {
>      if (split_huge_page(hpage)) {
>       /*
>        * The vma/anon_vma was freed from under us, the page should be
>        * unused, let it be freed by releasing it.
>        */
>        /* comment for you: we must make sure to mark the already unused pages poisoned */
>        return SWAP_FAIL;
>      }
>      hpage = p;
>    }
>  }
> 
OK. I will modify this part.

Thanks.

Best Regards,
Jin Dongming
> 
> Something like that, which also avoids to call a second compound_head
> at all for CONFIG_TRANSPARENT_HUGEPAGE=n as the whole block goes away.
> 
> Thanks a lot for looking into the THP memory-failure support, I
> appreciate!
> 
> Andrea
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


