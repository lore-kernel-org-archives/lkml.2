Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab1FYVeG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 17:34:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab1FYVeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 17:34:04 -0400
Message-ID: <4E065433.3020502@redhat.com>
Date: Sat, 25 Jun 2011 17:33:39 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?UMOhZHJhaWcgQnJh?= =?UTF-8?B?ZHk=?= <P@draigBrady.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin King <colin.king@canonical.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andrew Lutomirski <luto@mit.edu>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] mm: vmscan: Correct check for kswapd sleeping in
 sleeping_prematurely
References: <1308926697-22475-1-git-send-email-mgorman@suse.de> <1308926697-22475-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1308926697-22475-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2011 10:44 AM, Mel Gorman wrote:
> During allocator-intensive workloads, kswapd will be woken frequently
> causing free memory to oscillate between the high and min watermark.
> This is expected behaviour.
>
> A problem occurs if the highest zone is small.  balance_pgdat()
> only considers unreclaimable zones when priority is DEF_PRIORITY
> but sleeping_prematurely considers all zones. It's possible for this
> sequence to occur
>
>    1. kswapd wakes up and enters balance_pgdat()
>    2. At DEF_PRIORITY, marks highest zone unreclaimable
>    3. At DEF_PRIORITY-1, ignores highest zone setting end_zone
>    4. At DEF_PRIORITY-1, calls shrink_slab freeing memory from
>          highest zone, clearing all_unreclaimable. Highest zone
>          is still unbalanced
>    5. kswapd returns and calls sleeping_prematurely
>    6. sleeping_prematurely looks at *all* zones, not just the ones
>       being considered by balance_pgdat. The highest small zone
>       has all_unreclaimable cleared but but the zone is not
>       balanced. all_zones_ok is false so kswapd stays awake
>
> This patch corrects the behaviour of sleeping_prematurely to check
> the zones balance_pgdat() checked.
>
> Reported-and-tested-by: Pádraig Brady<P@draigBrady.com>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
