Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2KYXcn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 18:32:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab2KYXcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 18:32:42 -0500
Message-ID: <50B2AA35.70803@redhat.com>
Date: Sun, 25 Nov 2012 18:31:01 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        akpm@linux-foundation.org, mgorman@suse.de, Valdis.Kletnieks@vt.edu,
        jirislaby@gmail.com, jslaby@suse.cz, zkabelac@redhat.com,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] mm,vmscan: free pages if compaction_suitable tells us
 to
References: <20121119202152.4B0E420004E@hpza10.eem.corp.google.com> <20121125175728.3db4ac6a@fem.tu-ilmenau.de> <20121125132950.11b15e38@annuminas.surriel.com> <20121125224433.GB2799@cmpxchg.org>
In-Reply-To: <20121125224433.GB2799@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2012 05:44 PM, Johannes Weiner wrote:
> On Sun, Nov 25, 2012 at 01:29:50PM -0500, Rik van Riel wrote:
>> On Sun, 25 Nov 2012 17:57:28 +0100
>> Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de> wrote:
>>
>>> With kernel 3.7-rc6 I've still problems with kswapd0 on my laptop
>>
>>> And this is most of the time. I've only observed this behavior on the
>>> laptop. Other systems don't show this.
>>
>> This suggests it may have something to do with small memory zones,
>> where we end up with the "funny" situation that the high watermark
>> (+ balance gap) for a particular zone is less than the low watermark
>> + 2<<order pages, which is the number of free pages required to keep
>> compaction_suitable happy.
>>
>> Could you try this patch?
>
> It's not quite enough because it's not reaching the conditions you
> changed, see analysis in https://lkml.org/lkml/2012/11/20/567

You are right, I forgot the preliminary loop in balance_pgdat().

> But even fixing it up (by adding the compaction_suitable() test in
> this preliminary scan over the zones and setting end_zone accordingly)
> is not enough because no actual reclaim happens at priority 12 in a
> small zone.  So the number of free pages is not actually changing and
> the compaction_suitable() checks keep the loop going.

Indeed, it is a hairy situation. I tried to come up with a simple
patch, but apparently that is not enough...

> The problem is fairly easy to reproduce, by the way.  Just boot with
> mem=800M to have a relatively small lowmem reserve in the DMA zone.
> Fill it up with page cache, then allocate transparent huge pages.
>
> With your patch and my fix to the preliminary zone loop, there won't
> be any hung task warnings anymore because kswapd actually calls
> shrink_slab() and there is a rescheduling point in there, but it still
> loops forever.
>
> It also seems a bit aggressive to try to balance a small zone like DMA
> for a huge page when it's not a GFP_DMA allocation, but none of these
> checks actually take the classzone into account.  Do we have any
> agreement over what this whole thing is supposed to be doing?

It is supposed to free memory, in order to:
1) allow allocations to succeed, and
2) balance memory pressure between zones

I think the compaction_suitable check in the final loop
over the zones is backwards.

We need to loop back to the start if compaction_suitable
returns COMPACT_SKIPPED for _every_ zone in the pgdat.

Does that sound reasonable?

I'll whip up a patch.

-- 
All rights reversed
