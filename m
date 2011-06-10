Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1FJHiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 03:38:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55506 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1FJHiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 03:38:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF1C9DE.4070605@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 16:38:06 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: tglx@linutronix.de
CC: rientjes@google.com, linux@arm.linux.org.uk, dbaryshkov@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com,
        akpm@linux-foundation.org, pavel@ucw.cz
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
 instead of failing
References: <1306922672-9012-1-git-send-email-dbaryshkov@gmail.com> <BANLkTinBkdVd90g3-uiQP41z1S1sXUdRmQ@mail.gmail.com> <BANLkTikrRRzGLbMD47_xJz+xpgftCm1C2A@mail.gmail.com> <alpine.DEB.2.00.1106011017260.13089@chino.kir.corp.google.com> <20110601181918.GO3660@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1106012043080.3078@ionos> <alpine.DEB.2.00.1106011205410.17065@chino.kir.corp.google.com> <alpine.LFD.2.02.1106012134120.3078@ionos>
In-Reply-To: <alpine.LFD.2.02.1106012134120.3078@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/02 4:46), Thomas Gleixner wrote:
> On Wed, 1 Jun 2011, David Rientjes wrote:
>> On Wed, 1 Jun 2011, Thomas Gleixner wrote:
>>
>>>> That is NOT an unreasonable request, but it seems that its far too much
>>>> to ask of you.
>>>
>>> Full ack.
>>>
>>> David,
>>>
>>> stop that nonsense already. You changed the behaviour and broke stuff
>>> which was working fine before for whatever reason. That behaviour was
>>> in the kernel for ages and we tolerated the abuse.
>>>
>>
>> Did I nack this patch and not realize it?
> 
> No, you did not realize anything.
>  
>> Does my patch fix the warning for pxaficp_ir that would still be emitted 
>> with this patch?  If the driver uses GFP_DMA and nobody from the arm side 
> 
> Your patch does not fix anything. It papers over the problem and
> that's the f@&^%%@^#ing wrong approach.
> 
> And just to be clear. You CANNOT fix a warning. You can fix the code
> which causes the warning, but that's not what your patch is
> doing. Your patch HIDES the problem.
> 
>> is prepared to remove it yet, then I'd suggest merging my patch until that 
>> can be determined.  Otherwise, you have no guarantees about where the 
>> memory is actually coming from.
> 
> Did you actually try to understand what I wrote? 
> 
> You decided that it's a BUG just because it should not be allowed. So
> you changed the behaviour, which was perfectly fine before.
> 
> Now you try to paper over the problem by selecting ZONE_DMA and refuse
> to give a grace period of _ONE_ kernel release.
> 
> IOW, you are preventing that the abusers of GFP_DMA are fixed
> properly.
> 
> I can see that you neither have the bandwidth nor the knowledge to
> analyse each user of GFP_DMA. And that should tell you something.
> 
> If you cannot fix it yourself, then f*(&!@$#ng not break it.


Then, the revert patch is here.




>From beaf8c4457fffeb3a4bfb3a5109fbcddcfc686cb Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 15:27:06 +0900
Subject: [PATCH] Revert "mm: fail GFP_DMA allocations when ZONE_DMA is not configured"

Dmitry Eremin-Solenikov reported IrDA driver on PXA started to fail
after commit a197b59ae (mm: fail GFP_DMA allocations when ZONE_DMA
is not configured). Pavel Mechek mentioned it also broke zaurus.

Even though the concept of commit a197b59ae is correct. It's no worth
to break ARM. Thus this should be reverted until finished to audit
all GFP_DMA users.

This reverts commit a197b59ae6e8bee56fcef37ea2482dc08414e2ac.

Reported-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Reported-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/page_alloc.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a4e1db3..4e8985a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2247,10 +2247,6 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,

 	if (should_fail_alloc_page(gfp_mask, order))
 		return NULL;
-#ifndef CONFIG_ZONE_DMA
-	if (WARN_ON_ONCE(gfp_mask & __GFP_DMA))
-		return NULL;
-#endif

 	/*
 	 * Check the zones suitable for the gfp_mask contain at least one
-- 
1.7.3.1






