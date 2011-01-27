Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab1A0AKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:10:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40468 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab1A0AKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:10:36 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4D40B8C0.1040704@np.css.fujitsu.com>
Date: Thu, 27 Jan 2011 09:13:52 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>,
        =?UTF-8?B?QUtQTeOAgA==?= <akpm@linux-foundation.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Huang Ying <ying.huang@intel.com>, LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Fix unsuitable behavior for poisoned tail pages of
 THP.
References: <4D3E63B8.4040701@np.css.fujitsu.com> <20110125224635.GL926@random.random>
In-Reply-To: <20110125224635.GL926@random.random>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrea
(2011/01/26 7:46), Andrea Arcangeli wrote:
> On Tue, Jan 25, 2011 at 02:46:32PM +0900, Jin Dongming wrote:
>> When a tail page of THP is poisoned, memory-failure will do
>> nothing except setting poison flag, while the expected behavior is
>> that the process, who is using the poisoned tail page, should be
>> killed.
>>
>> The above problem is caused by lru checking of the poisoned tail page
>> of THP. Because PG_lru flag is only set on the head page of
>> THP, the check always consider the poisoned tail page as NON
>> lru page.
>>
>> So avoid checking NON lru for THP, as like as hugetlb.
>>
>> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
>> Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>> ---
>>  mm/memory-failure.c |   27 +++++++++++++++------------
>>  1 files changed, 15 insertions(+), 12 deletions(-)
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index 5396603..44a1bdf 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -1046,19 +1046,22 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
>>  	 * The check (unnecessarily) ignores LRU pages being isolated and
>>  	 * walked by the page reclaim code, however that's not a big loss.
>>  	 */
>> -	if (!PageLRU(p) && !PageHuge(p))
>> -		shake_page(p, 0);
>> -	if (!PageLRU(p) && !PageHuge(p)) {
>> -		/*
>> -		 * shake_page could have turned it free.
>> -		 */
>> -		if (is_free_buddy_page(p)) {
>> -			action_result(pfn, "free buddy, 2nd try", DELAYED);
>> -			return 0;
>> +	if (!PageCompound(p)) {
> 
> Here the check could become a:
> 
>         if (!PageHuge(p) && !PageTransCompound(p))
> 
I will modify it.

Thanks.

Best Regards,
Jin Dongming

> so the whole branch is optimized away at build time when both
> hugetlbfs and THP are set =n (or in archs not supporting either of
> those).
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


