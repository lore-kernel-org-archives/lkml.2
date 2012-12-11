Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab2LKSpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:45:36 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:47794 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab2LKSpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:45:34 -0500
Message-ID: <50C77F47.10601@linaro.org>
Date: Tue, 11 Dec 2012 10:45:27 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Arun Sharma <asharma@fb.com>, sanjay@google.com,
        Paul Turner <pjt@google.com>, David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC v3] Support volatile range for anon vma
References: <1355193255-7217-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1355193255-7217-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 06:34 PM, Minchan Kim wrote:
> This still is [RFC v3] because just passed my simple test
> with TCMalloc tweaking.
>
> I hope more inputs from user-space allocator people and test patch
> with their allocator because it might need design change of arena
> management design for getting real vaule.
>
> Changelog from v2
>
>   * Removing madvise(addr, length, MADV_NOVOLATILE).
>   * add vmstat about the number of discarded volatile pages
>   * discard volatile pages without promotion in reclaim path
>
> This is based on v3.6.
>
> - What's the madvise(addr, length, MADV_VOLATILE)?
>
>    It's a hint that user deliver to kernel so kernel can *discard*
>    pages in a range anytime.
>
> - What happens if user access page(ie, virtual address) discarded
>    by kernel?
>
>    The user can see zero-fill-on-demand pages as if madvise(DONTNEED).
>
> - What happens if user access page(ie, virtual address) doesn't
>    discarded by kernel?
>
>    The user can see old data without page fault.
>
> - What's different with madvise(DONTNEED)?
>
>    System call semantic
>
>    DONTNEED makes sure user always can see zero-fill pages after
>    he calls madvise while VOLATILE can see zero-fill pages or
>    old data.
I still need to really read and understand the patch, but at a high 
level I'm not sure how this works. So does the VOLATILE flag get cleared 
on any access, even if the pages have not been discarded? What happens 
if an application wants to store non-volatile data in an area that was 
once marked volatile. If there was never memory pressure, it seems the 
volatility would persist with no way of removing it.

Either way, I feel that with this revision, specifically dropping the 
NOVOLATILE call and the SIGBUS optimization the Mozilla folks suggested, 
your implementation has drifted quite far from the concept I'm pushing. 
While I hope we can still align the underlying mm implementation, I 
might ask that you use a different term for the semantics you propose, 
so we don't add too much confusion to the discussion.

Maybe you could call it DONTNEED_DEFERRED or something?

In the meantime, I'll be reading your patch in detail and seeing how we 
might be able to combine our differing approaches.

thanks
-john
