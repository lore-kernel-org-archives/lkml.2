Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab1BWRBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:01:47 -0500
Received: from gir.skynet.ie ([193.1.99.77]:42549 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932211Ab1BWRBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:01:46 -0500
Date: Wed, 23 Feb 2011 17:01:17 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Clemens Ladisch <cladisch@googlemail.com>,
        alsa-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified -
	5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in
	kswapd for GFP_ATOMIC order > 0
Message-ID: <20110223170117.GK15652@csn.ul.ie>
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net> <4D6367B3.9050306@googlemail.com> <20110222134047.GT13092@random.random> <20110222161513.GC13092@random.random> <4D63F6C0.7060204@internode.on.net> <20110222194325.GE31195@random.random> <20110223091532.GJ15652@csn.ul.ie> <4D64F26D.1050803@internode.on.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4D64F26D.1050803@internode.on.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 10:11:33PM +1030, Arthur Marsh wrote:
>
>
> Mel Gorman wrote, on 23/02/11 19:45:
>> On Tue, Feb 22, 2011 at 08:43:25PM +0100, Andrea Arcangeli wrote:
>>> On Wed, Feb 23, 2011 at 04:17:44AM +1030, Arthur Marsh wrote:
>>>> OK, these patches applied together against upstream didn't cause a crash
>>>> but I did observe:
>>>>
>>>> significant slowdowns of MIDI playback (moreso than in previous cases,
>>>> and with less than 20 Meg of swap file in use);
>>>>
>>
>> Can this be replicated with on-board audio hardware or is there something
>> specific about the card? e.g. those typically driven by snd-intel8x0 or
>> snd_hda_intel
>
> This card (Soundblaster Audigy 2 ZS - SB0350) has an on-board wavetable  
> synthesiser. To perform a test with sound hardware included on a  
> motherboard, one would need to connect the pc to an external synthesiser  
> to play the MIDI signal from the sound hardware on the motherboard.
>

Nuts. Nonetheless, I wrote some tools to track worst IRQ-disabled latencies
over time and identify the top offenders. Sure enough in my own very basic
tests, compaction was showing up as disabling IRQs for a massive length of
time. It wasn't a common occurance in my tests but they are very basic and
it's not necessarily the *only* source of IRQs being disabled too long but
it was the first one I found.

I regret that yet more patches are being blasted around but I hope the included
figures will convince you to run yet-another-test. I don't know how you are
measuring how long IRQs are being disabled and when it's a problem but it's
what I'm more interested in right now than the kswapd CPU usage which I'm
still in the process of gathering data to analyse.

==== CUT HERE ====
mm: compaction: Minimise the time IRQs are disabled while isolating free pages

compaction_alloc() isolates free pages to be used as migration targets.
While its scanning, IRQs are disabled on the mistaken assumption the scanning
was short. Analysis showed that IRQs were in fact being disabled for a
substantial length of time. A simple test was run using large anonymous
mappings with transparent hugepage support enabled to trigger frequent
compactions. A monitor sampled what the worst IRQs-off latencies were and
a post-processing tool found the following;

Event compaction_alloc..compaction_alloc                 3014 us count    1
Event compaction_alloc..compaction_alloc                 2954 us count    1
Event compaction_alloc..compaction_alloc                 1803 us count    1
Event compaction_alloc..compaction_alloc                 1303 us count    1
Event compaction_alloc..compaction_alloc                 1291 us count    1
Event compaction_alloc..compaction_alloc                  911 us count    1
Event compaction_alloc..compaction_alloc                  753 us count    1
Event compaction_alloc..compaction_alloc                  747 us count    1
Event compaction_alloc..compaction_alloc                  610 us count    1
Event split_huge_page..add_to_swap                        583 us count    1
Event split_huge_page..add_to_swap                        531 us count    1
Event split_huge_page..add_to_swap                        262 us count    1
Event split_huge_page..add_to_swap                        258 us count    1
Event split_huge_page..add_to_swap                        256 us count    1
Event split_huge_page..add_to_swap                        252 us count    1
Event split_huge_page..add_to_swap                        248 us count    1
Event split_huge_page..add_to_swap                        247 us count    2
Event compaction_alloc..compaction_alloc                  134 us count    1
Event shrink_inactive_list..shrink_zone                    85 us count    1
Event ftrace_module_notify..ftrace_module_notify           80 us count    1
Event shrink_inactive_list..shrink_zone                    76 us count    1
Event shrink_inactive_list..shrink_zone                    47 us count    1
Event save_args..restore_args                              40 us count    1
Event save_args..restore_args                              39 us count    1
Event save_args..call_softirq                              38 us count    1
Event save_args..call_softirq                              36 us count    2
Event save_args..call_softirq                              35 us count    2
Event save_args..call_softirq                              34 us count    2
Event drain_array..cache_reap                              31 us count    1
Event cfq_kick_queue..__blk_run_queue                      29 us count    1
Event save_args..restore_args                              28 us count    1
Event save_args..call_softirq                              28 us count    3
Event save_args..call_softirq                              27 us count    2
Event save_args..restore_args                              27 us count    1
Event mempool_free_slab..mempool_free_slab                 26 us count    1
Event drain_array..cache_reap                              26 us count    2
Event save_args..call_softirq                              26 us count   10
Event mempool_free_slab..mempool_free_slab                 25 us count    1
Event save_args..call_softirq                              25 us count    4
Event save_args..call_softirq                              23 us count    2
Event ____pagevec_lru_add..__lru_cache_add                  2 us count    1

i.e. compaction is disabled IRQs for a prolonged period of time - 3ms in
one instance. The full report generated by the tool can be found at
http://www.csn.ul.ie/~mel/postings/irqs-disabled-2.6.38-rc6.txt .
This patch reduces the time IRQs are disabled by simply disabling IRQs
at the last possible minute. An updated IRQs-off summary report then
looks like;

Event shrink_inactive_list..shrink_zone                  2075 us count    1
Event shrink_inactive_list..shrink_zone                   686 us count    1
Event split_huge_page..add_to_swap                        535 us count    1
Event split_huge_page..add_to_swap                        269 us count    1
Event split_huge_page..add_to_swap                        265 us count    1
Event split_huge_page..add_to_swap                        264 us count    1
Event shrink_inactive_list..shrink_zone                   261 us count    1
Event split_huge_page..add_to_swap                        255 us count    1
Event split_huge_page..add_to_swap                        253 us count    1
Event split_huge_page..add_to_swap                        252 us count    1
Event split_huge_page..add_to_swap                        250 us count    1
Event split_huge_page..add_to_swap                        239 us count    1
Event split_huge_page..add_to_swap                        237 us count    1
Event shrink_inactive_list..shrink_zone                   205 us count    1
Event compact_zone..compact_zone_order                    162 us count    1
Event compact_zone..compact_zone_order                    136 us count    1
Event compact_zone..compact_zone_order                    134 us count    1
Event compact_zone..compact_zone_order                    114 us count    1
Event shrink_inactive_list..shrink_zone                   114 us count    1
Event compact_zone..compact_zone_order                    111 us count    1
Event shrink_inactive_list..shrink_zone                    95 us count    1
Event shrink_inactive_list..shrink_zone                    91 us count    2
Event shrink_inactive_list..shrink_zone                    90 us count    1
Event ftrace_module_notify..ftrace_module_notify           89 us count    1
Event shrink_inactive_list..shrink_zone                    89 us count    1
Event shrink_inactive_list..shrink_zone                    88 us count    2
Event shrink_inactive_list..shrink_zone                    86 us count    1
Event shrink_inactive_list..shrink_zone                    84 us count    2
Event shrink_inactive_list..shrink_zone                    70 us count    1
Event save_args..restore_args                              46 us count    1
Event mempool_free_slab..mempool_free_slab                 43 us count    1
Event mempool_free_slab..mempool_free_slab                 38 us count    1
Event save_args..restore_args                              37 us count    1
Event mempool_free_slab..mempool_free_slab                 37 us count    1
Event save_args..call_softirq                              36 us count    2
Event save_args..call_softirq                              35 us count    1
Event save_args..restore_args                              35 us count    1
Event mempool_free_slab..mempool_free_slab                 34 us count    1
Event save_args..call_softirq                              34 us count    1
Event save_args..restore_args                              33 us count    1
Event save_args..call_softirq                              33 us count    2
Event save_args..call_softirq                              32 us count    1
Event save_args..restore_args                              30 us count    1
Event save_args..call_softirq                              30 us count    1
Event drain_array..cache_reap                              30 us count    1
Event save_args..restore_args                              29 us count    1
Event scsi_request_fn..process_one_work                    29 us count    1
Event save_args..call_softirq                              29 us count    1
Event save_args..call_softirq                              28 us count    2
Event save_args..call_softirq                              27 us count    5
Event drain_array..cache_reap                              26 us count    1
Event save_args..call_softirq                              26 us count    8
Event save_args..call_softirq                              25 us count    6
Event save_args..call_softirq                              24 us count    2
Event __wake_up..__wake_up                                  2 us count    1

A full report is again available at
http://www.csn.ul.ie/~mel/postings/irqs-disabled-2.6.38-rc6-compactirq-v1r1.txt
. As should be obvious, IRQ disabled latencies due to compaction are
almost elimimnated for this particular test. As a bonus, the test also
completed far faster

MMTests Statistics: duration
					   vanilla compactirq-v1r1
User/Sys Time Running Test (seconds)         28.63     18.68
Total Elapsed Time (seconds)                162.81     85.83

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/compaction.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 8be430b8..f47de94 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -155,7 +155,6 @@ static void isolate_freepages(struct zone *zone,
 	 * pages on cc->migratepages. We stop searching if the migrate
 	 * and free page scanners meet or enough free pages are isolated.
 	 */
-	spin_lock_irqsave(&zone->lock, flags);
 	for (; pfn > low_pfn && cc->nr_migratepages > nr_freepages;
 					pfn -= pageblock_nr_pages) {
 		unsigned long isolated;
@@ -178,9 +177,18 @@ static void isolate_freepages(struct zone *zone,
 		if (!suitable_migration_target(page))
 			continue;
 
-		/* Found a block suitable for isolating free pages from */
-		isolated = isolate_freepages_block(zone, pfn, freelist);
-		nr_freepages += isolated;
+		/*
+		 * Found a block suitable for isolating free pages from. Now
+		 * we disabled interrupts, double check things are ok and
+		 * isolate the pages. This is to minimise the time IRQs
+		 * are disabled
+		 */
+		spin_lock_irqsave(&zone->lock, flags);
+		if (suitable_migration_target(page)) {
+			isolated = isolate_freepages_block(zone, pfn, freelist);
+			nr_freepages += isolated;
+		}
+		spin_unlock_irqrestore(&zone->lock, flags);
 
 		/*
 		 * Record the highest PFN we isolated pages from. When next
@@ -190,7 +198,6 @@ static void isolate_freepages(struct zone *zone,
 		if (isolated)
 			high_pfn = max(high_pfn, pfn);
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
 
 	/* split_free_page does not map the pages */
 	list_for_each_entry(page, freelist, lru) {
