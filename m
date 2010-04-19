Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab0DSVo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:44:59 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:56498 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab0DSVo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:44:58 -0400
Date: Mon, 19 Apr 2010 23:44:12 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       gregkh@novell.com, Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone pressure
Message-ID: <20100419214412.GB5336@cmpxchg.org>
References: <20100322235053.GD9590@csn.ul.ie> <4BA940E7.2030308@redhat.com> <20100324145028.GD2024@csn.ul.ie> <4BCC4B0C.8000602@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCC4B0C.8000602@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 02:22:36PM +0200, Christian Ehrhardt wrote:
> So now coming to the probably most critical part - the evict once discussion in this thread.
> I'll try to explain what I found in the meanwhile - let me know whats unclear and I'll add data etc.
> 
> In the past we identified that "echo 3 > /proc/sys/vm/drop_caches" helps to improve the accuracy of the used testcase by lowering the noise from 5-8% to <1%.
> Therefore I ran all tests and verifications with that drops.
> In the meanwhile I unfortunately discovered that Mel's fix only helps for the cases when the caches are dropped.
> Without it seems to be bad all the time. So don't cast the patch away due to that discovery :-)
> 
> On the good side I was also able to analyze a few more things due to that insight - and it might give us new data to debug the root cause.
> Like Mel I also had identified "56e49d21 vmscan: evict use-once pages first" to be related in the past. But without the watermark wait fix, unapplying it 56e49d21 didn't change much for my case so I left this analysis path.
> 
> But now after I found dropping caches is the key to "get back good performance" and "subsequent writes for bad performance" even with watermark wait applied I checked what else changes:
> - first write/read load after reboot or dropping caches -> read TP good
> - second write/read load after reboot or dropping caches -> read TP bad
> => so what changed.
> 
> I went through all kind of logs and found something in the system activity report which very probably is related to 56e49d21.
> When issuing subsequent writes after I dropped caches to get a clean start I get this in Buffers/Caches from Meminfo:
> 
> pre write 1
> Buffers:             484 kB
> Cached:             5664 kB
> pre write 2
> Buffers:           33500 kB
> Cached:           149856 kB
> pre write 3
> Buffers:           65564 kB
> Cached:           115888 kB
> pre write 4
> Buffers:           85556 kB
> Cached:            97184 kB
> 
> It stays at ~85M with more writes which is approx 50% of my free 160M memory.

Ok, so I am the idiot that got quoted on 'the active set is not too big, so
buffer heads are not a problem when avoiding to scan it' in eternal history.

But the threshold inactive/active ratio for skipping active file pages is
actually 1:1.

The easiest 'fix' is probably to change that ratio, 2:1 (or even 3:1?) appears
to be a bit more natural anyway?  Below is a patch that changes it to 2:1.
Christian, can you check if it fixes your regression?

Additionally, we can always scan active file pages but only deactivate them
when the ratio is off and otherwise strip buffers of clean pages.

What do people think?

	Hannes

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f4ede99..a4aea76 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -898,7 +898,7 @@ int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg)
 	inactive = mem_cgroup_get_local_zonestat(memcg, LRU_INACTIVE_FILE);
 	active = mem_cgroup_get_local_zonestat(memcg, LRU_ACTIVE_FILE);
 
-	return (active > inactive);
+	return (active > inactive / 2);
 }
 
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3ff3311..8f1a846 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1466,7 +1466,7 @@ static int inactive_file_is_low_global(struct zone *zone)
 	active = zone_page_state(zone, NR_ACTIVE_FILE);
 	inactive = zone_page_state(zone, NR_INACTIVE_FILE);
 
-	return (active > inactive);
+	return (active > inactive / 2);
 }
 
 /**

