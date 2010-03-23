Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab0CWWcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 18:32:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab0CWWcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 18:32:09 -0400
Message-ID: <4BA940E7.2030308@redhat.com>
Date: Tue, 23 Mar 2010 18:29:59 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       gregkh@novell.com, Corrado Zoccolo <czoccolo@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone	pressure
References: <20100322235053.GD9590@csn.ul.ie>
In-Reply-To: <20100322235053.GD9590@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 07:50 PM, Mel Gorman wrote:

> Test scenario
> =============
> X86-64 machine 1 socket 4 cores
> 4 consumer-grade disks connected as RAID-0 - software raid. RAID controller
> 	on-board and a piece of crap, and a decent RAID card could blow
> 	the budget.
> Booted mem=256 to ensure it is fully IO-bound and match closer to what
> 	Christian was doing

With that many disks, you can easily have dozens of megabytes
of data in flight to the disk at once.  That is a major
fraction of memory.

In fact, you might have all of the inactive file pages under
IO...

> 3. Page reclaim evict-once logic from 56e49d21 hurts really badly
> 	fix title: revertevict
> 	fixed in mainline? no
> 	affects: 2.6.31 to now
>
> 	For reasons that are not immediately obvious, the evict-once patches
> 	*really* hurt the time spent on congestion and the number of pages
> 	reclaimed. Rik, I'm afaid I'm punting this to you for explanation
> 	because clearly you tested this for AIM7 and might have some
> 	theories. For the purposes of testing, I just reverted the changes.

The patch helped IO tests with reasonable amounts of memory
available, because the VM can cache frequently used data
much more effectively.

This comes at the cost of caching less recently accessed
use-once data, which should not be an issue since the data
is only used once...

> Rik, any theory on evict-once?

No real theories yet, just the observation that your revert
appears to be buggy (see below) and the possibility that your
test may have all of the inactive file pages under IO...

Can you reproduce the stall if you lower the dirty limits?

>   static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
>   	struct zone *zone, struct scan_control *sc, int priority)
>   {
>   	int file = is_file_lru(lru);
>
> -	if (is_active_lru(lru)) {
> -		if (inactive_list_is_low(zone, sc, file))
> -		    shrink_active_list(nr_to_scan, zone, sc, priority, file);
> +	if (lru == LRU_ACTIVE_FILE) {
> +		shrink_active_list(nr_to_scan, zone, sc, priority, file);
>   		return 0;
>   	}

Your revert is buggy.  With this change, anonymous pages will
never get deactivated via shrink_list.
