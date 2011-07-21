Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab1GUPhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 11:37:36 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59036 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab1GUPhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 11:37:33 -0400
Date: Fri, 22 Jul 2011 00:37:22 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin King <colin.king@canonical.com>,
        Andrew Lutomirski <luto@mit.edu>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Stop kswapd consuming 100% CPU when highest zone is
 small
Message-ID: <20110721153722.GD1713@barrios-desktop>
References: <1308926697-22475-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308926697-22475-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 03:44:53PM +0100, Mel Gorman wrote:
> (Built this time and passed a basic sniff-test.)
> 
> During allocator-intensive workloads, kswapd will be woken frequently
> causing free memory to oscillate between the high and min watermark.
> This is expected behaviour.  Unfortunately, if the highest zone is
> small, a problem occurs.
> 
> This seems to happen most with recent sandybridge laptops but it's
> probably a co-incidence as some of these laptops just happen to have
> a small Normal zone. The reproduction case is almost always during
> copying large files that kswapd pegs at 100% CPU until the file is
> deleted or cache is dropped.
> 
> The problem is mostly down to sleeping_prematurely() keeping kswapd
> awake when the highest zone is small and unreclaimable and compounded
> by the fact we shrink slabs even when not shrinking zones causing a lot
> of time to be spent in shrinkers and a lot of memory to be reclaimed.
> 
> Patch 1 corrects sleeping_prematurely to check the zones matching
> 	the classzone_idx instead of all zones.
> 
> Patch 2 avoids shrinking slab when we are not shrinking a zone.
> 
> Patch 3 notes that sleeping_prematurely is checking lower zones against
> 	a high classzone which is not what allocators or balance_pgdat()
> 	is doing leading to an artifical believe that kswapd should be
> 	still awake.
> 
> Patch 4 notes that when balance_pgdat() gives up on a high zone that the
> 	decision is not communicated to sleeping_prematurely()
> 
> This problem affects 2.6.38.8 for certain and is expected to affect
> 2.6.39 and 3.0-rc4 as well. If accepted, they need to go to -stable
> to be picked up by distros and this series is against 3.0-rc4. I've
> cc'd people that reported similar problems recently to see if they
> still suffer from the problem and if this fixes it.
> 

Good!
This patch solved the problem.
But there is still a mystery.

In log, we could see excessive shrink_slab calls.
And as you know, we had merged patch which adds cond_resched where last of the function
in shrink_slab. So other task should get the CPU and we should not see
100% CPU of kswapd, I think.

Do you have any idea about this?

>  mm/vmscan.c |   59 +++++++++++++++++++++++++++++++++++------------------------
>  1 files changed, 35 insertions(+), 24 deletions(-)
> 
> -- 
> 1.7.3.4
> 

-- 
Kind regards,
Minchan Kim
