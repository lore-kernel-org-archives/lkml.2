Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2G0Dtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 23:49:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab2G0DtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 23:49:11 -0400
Message-ID: <50120FA8.20409@redhat.com>
Date: Thu, 26 Jul 2012 23:48:56 -0400
From: Larry Woodman <lwoodman@redhat.com>
Reply-To: lwoodman@redhat.com
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120422 Thunderbird/10.0.4
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, Linux-MM <linux-mm@kvack.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Ken Chen <kenchen@google.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -alternative] mm: hugetlbfs: Close race during teardown
 of hugetlbfs shared page tables V2 (resend)
References: <20120720134937.GG9222@suse.de> <20120720141108.GH9222@suse.de> <20120720143635.GE12434@tiehlicka.suse.cz> <20120720145121.GJ9222@suse.de> <alpine.LSU.2.00.1207222033030.6810@eggly.anvils> <50118E7F.8000609@redhat.com>
In-Reply-To: <50118E7F.8000609@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 02:37 PM, Rik van Riel wrote:
> On 07/23/2012 12:04 AM, Hugh Dickins wrote:
>
>> I spent hours trying to dream up a better patch, trying various
>> approaches.  I think I have a nice one now, what do you think?  And
>> more importantly, does it work?  I have not tried to test it at all,
>> that I'm hoping to leave to you, I'm sure you'll attack it with gusto!
>>
>> If you like it, please take it over and add your comments and signoff
>> and send it in.  The second part won't come up in your testing, and 
>> could
>> be made a separate patch if you prefer: it's a related point that struck
>> me while I was playing with a different approach.
>>
>> I'm sorely tempted to leave a dangerous pair of eyes off the Cc,
>> but that too would be unfair.
>>
>> Subject-to-your-testing-
>> Signed-off-by: Hugh Dickins <hughd@google.com>
>
> This patch looks good to me.
>
> Larry, does Hugh's patch survive your testing?
>
>
Like I said earlier, no.  However, I finally set up a reproducer that 
only takes a few seconds
on a large system and this totally fixes the problem:

-------------------------------------------------------------------------------------------------------------------------
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c36febb..cc023b8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2151,7 +2151,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, 
struct mm_struct *src,
                         goto nomem;

                 /* If the pagetables are shared don't copy or take 
references */
-               if (dst_pte == src_pte)
+               if (*(unsigned long *)dst_pte == *(unsigned long *)src_pte)
                         continue;

                 spin_lock(&dst->page_table_lock);
---------------------------------------------------------------------------------------------------------------------------

When we compare what the src_pte & dst_pte point to instead of their 
addresses everything works,
I suspect there is a missing memory barrier somewhere ???

Larry

