Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab1FYXSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 19:18:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab1FYXSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 19:18:18 -0400
Message-ID: <4E066CA0.7060802@redhat.com>
Date: Sat, 25 Jun 2011 19:17:52 -0400
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
Subject: Re: [PATCH 4/4] mm: vmscan: Only read new_classzone_idx from pgdat
 when reclaiming successfully
References: <1308926697-22475-1-git-send-email-mgorman@suse.de> <1308926697-22475-5-git-send-email-mgorman@suse.de>
In-Reply-To: <1308926697-22475-5-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2011 10:44 AM, Mel Gorman wrote:
> During allocator-intensive workloads, kswapd will be woken frequently
> causing free memory to oscillate between the high and min watermark.
> This is expected behaviour.  Unfortunately, if the highest zone is
> small, a problem occurs.
>
> When balance_pgdat() returns, it may be at a lower classzone_idx than
> it started because the highest zone was unreclaimable. Before checking
> if it should go to sleep though, it checks pgdat->classzone_idx which
> when there is no other activity will be MAX_NR_ZONES-1. It interprets
> this as it has been woken up while reclaiming, skips scheduling and
> reclaims again. As there is no useful reclaim work to do, it enters
> into a loop of shrinking slab consuming loads of CPU until the highest
> zone becomes reclaimable for a long period of time.
>
> There are two problems here. 1) If the returned classzone or order is
> lower, it'll continue reclaiming without scheduling. 2) if the highest
> zone was marked unreclaimable but balance_pgdat() returns immediately
> at DEF_PRIORITY, the new lower classzone is not communicated back to
> kswapd() for sleeping.
>
> This patch does two things that are related. If the end_zone is
> unreclaimable, this information is communicated back. Second, if
> the classzone or order was reduced due to failing to reclaim, new
> information is not read from pgdat and instead an attempt is made to go
> to sleep. Due to this, it is also necessary that pgdat->classzone_idx
> be initialised each time to pgdat->nr_zones - 1 to avoid re-reads
> being interpreted as wakeups.
>
> Reported-and-tested-by: Pádraig Brady<P@draigBrady.com>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
