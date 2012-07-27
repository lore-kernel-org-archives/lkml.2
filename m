Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab2G0KLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:11:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab2G0KLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 06:11:08 -0400
Message-ID: <5012692F.5080501@redhat.com>
Date: Fri, 27 Jul 2012 06:10:55 -0400
From: Larry Woodman <lwoodman@redhat.com>
Reply-To: lwoodman@redhat.com
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120422 Thunderbird/10.0.4
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Michal Hocko <mhocko@suse.cz>, Linux-MM <linux-mm@kvack.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Ken Chen <kenchen@google.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -alternative] mm: hugetlbfs: Close race during teardown
 of hugetlbfs shared page tables V2 (resend)
References: <20120720134937.GG9222@suse.de> <20120720141108.GH9222@suse.de> <20120720143635.GE12434@tiehlicka.suse.cz> <20120720145121.GJ9222@suse.de> <alpine.LSU.2.00.1207222033030.6810@eggly.anvils> <50118E7F.8000609@redhat.com> <50120FA8.20409@redhat.com>
In-Reply-To: <50120FA8.20409@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 11:48 PM, Larry Woodman wrote:


Mel, did you see this???

Larry

>> This patch looks good to me.
>>
>> Larry, does Hugh's patch survive your testing?
>>
>>
>
> Like I said earlier, no.  However, I finally set up a reproducer that 
> only takes a few seconds
> on a large system and this totally fixes the problem:
>
> ------------------------------------------------------------------------------------------------------------------------- 
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index c36febb..cc023b8 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2151,7 +2151,7 @@ int copy_hugetlb_page_range(struct mm_struct 
> *dst, struct mm_struct *src,
>                         goto nomem;
>
>                 /* If the pagetables are shared don't copy or take 
> references */
> -               if (dst_pte == src_pte)
> +               if (*(unsigned long *)dst_pte == *(unsigned long 
> *)src_pte)
>                         continue;
>
>                 spin_lock(&dst->page_table_lock);
> --------------------------------------------------------------------------------------------------------------------------- 
>
>
> When we compare what the src_pte & dst_pte point to instead of their 
> addresses everything works,
> I suspect there is a missing memory barrier somewhere ???
>
> Larry
>

