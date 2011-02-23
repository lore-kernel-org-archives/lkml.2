Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab1BWJQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:16:04 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49827 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab1BWJQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:16:00 -0500
Date: Wed, 23 Feb 2011 09:15:32 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>,
        Clemens Ladisch <cladisch@googlemail.com>,
        alsa-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified -
	5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in
	kswapd for GFP_ATOMIC order > 0
Message-ID: <20110223091532.GJ15652@csn.ul.ie>
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net> <4D6367B3.9050306@googlemail.com> <20110222134047.GT13092@random.random> <20110222161513.GC13092@random.random> <4D63F6C0.7060204@internode.on.net> <20110222194325.GE31195@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110222194325.GE31195@random.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 08:43:25PM +0100, Andrea Arcangeli wrote:
> On Wed, Feb 23, 2011 at 04:17:44AM +1030, Arthur Marsh wrote:
> > OK, these patches applied together against upstream didn't cause a crash 
> > but I did observe:
> > 
> > significant slowdowns of MIDI playback (moreso than in previous cases, 
> > and with less than 20 Meg of swap file in use);
> > 

Can this be replicated with on-board audio hardware or is there something
specific about the card? e.g. those typically driven by snd-intel8x0 or
snd_hda_intel

Unfortunately the original mail is a bit light on details on how this was
reproduced and I didn't find a thread with more details. It looks like it's
simply playing a midi file while the system is under load but less clear
on what the symptoms are (audio skipping maybe?). I'll start with using
irqs-off tracer to see can I replicate a similar style of issue without
depending on sound.

> > kswapd0 sharing equal top place in CPU usage at times (e.g. 20 percent).
> > 
> > If I should try only one of the patches or something else entirely, 
> > please let me know.
> 
> For Mel: with z1, kswapd used only 0.1-3.9 percent of CPU while he
> loaded other applications.
> 

What's the usage otherwise?

As that patch has been NAKd by Rik on the grounds it eliminates the "balance
gap" entirely, can it be checked if the patch below keeps the CPU usage low
as well please?

> We may need a way to put kswapd in all uncompactable mode to solve
> this, logic 3 just trying not to disable the all unreclaimable logic
> seems not enough. I.e. if compact_zone_order doesn't return
> COMPACT_COMPLETE, stop the compaction loop in kswapd. Then we can put
> back in the COMPACT_MODE_KSWAPD return COMPACT_CONTINUE in
> compact_finished as the caller will throttle it (and it won't run more
> than one scan before putting kswapd to sleep in all uncompactable mode).
> 

Should be possible. I'm not going to develop such a patch now though and
instead have a stab at replicating some of the exhibited problems (high
kswapd CPU usage, long interrupt disabled times etc).

Can the following patch be tested as a potential replacement for z1
please?

==== CUT HERE ====
vmscan: kswapd should not free an excessive number of pages when balancing small zones

When reclaiming for order-0 pages, kswapd requires that all zones be
balanced. Each cycle through balance_pgdat() does background ageing on all
zones if necessary and applies equal pressure on the inactive zone unless
a lot of pages are free already.

A "lot of free pages" is defined as a "balance gap" above the high watermark
which is currently 7*high_watermark. Historically this was reasonable as
min_free_kbytes was small. However, on systems using huge pages, it is
recommended that min_free_kbytes is higher and it is tuned with hugeadm
--set-recommended-min_free_kbytes. With the introduction of transparent
huge page support, this recommended value is also applied. On X86-64 with
4G of memory, min_free_kbytes becomes 67584 so one would expect around 68M
of memory to be free. The Normal zone is approximately 35000 pages so under
even normal memory pressure such as copying a large file, it gets exhausted
quickly. As it is getting exhausted, kswapd applies pressure equally to all
zones, including the DMA32 zone. DMA32 is approximately 700,000 pages with
a high watermark of around 23,000 pages. In this situation, kswapd will
reclaim around (23000*8 where 8 is the high watermark + balance gap of 7 *
high watermark) pages or 718M of pages before the zone is ignored. What
the user sees is that free memory far higher than it should be.

To avoid an excessive number of pages being reclaimed from the larger zones,
explicitely defines the "balance gap" to be either 1% of the zone or the
low watermark for the zone, whichever is smaller.  While kswapd will check
all zones to apply pressure, it'll ignore zones that meets the (high_wmark +
balance_gap) watermark.

To test this, 80G were copied from a paritition and the amount of memory
being used was recorded. A comparison of a patch and unpatched kernel
can be seen at
http://www.csn.ul.ie/~mel/postings/minfree-20110222/memory-usage-hydra.ps
and shows that kswapd is not reclaiming as much memory with the patch
applied.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/swap.h |    9 +++++++++
 mm/vmscan.c          |   16 +++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4d55932..a57c6e7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -155,6 +155,15 @@ enum {
 #define SWAP_CLUSTER_MAX 32
 #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
 
+/*
+ * Ratio between the present memory in the zone and the "gap" that
+ * we're allowing kswapd to shrink in addition to the per-zone high
+ * wmark, even for zones that already have the high wmark satisfied,
+ * in order to provide better per-zone lru behavior. We are ok to
+ * spend not more than 1% of the memory for this zone balancing "gap".
+ */
+#define KSWAPD_ZONE_BALANCE_GAP_RATIO 100
+
 #define SWAP_MAP_MAX	0x3e	/* Max duplication count, in first swap_map */
 #define SWAP_MAP_BAD	0x3f	/* Note pageblock is bad, in first swap_map */
 #define SWAP_HAS_CACHE	0x40	/* Flag page is cached, in first swap_map */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 17497d0..0c83530 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2388,6 +2388,7 @@ loop_again:
 			int compaction;
 			struct zone *zone = pgdat->node_zones + i;
 			int nr_slab;
+			unsigned long balance_gap;
 
 			if (!populated_zone(zone))
 				continue;
@@ -2404,11 +2405,20 @@ loop_again:
 			mem_cgroup_soft_limit_reclaim(zone, order, sc.gfp_mask);
 
 			/*
-			 * We put equal pressure on every zone, unless one
-			 * zone has way too many pages free already.
+			 * We put equal pressure on every zone, unless
+			 * one zone has way too many pages free
+			 * already. The "too many pages" is defined
+			 * as the high wmark plus a "gap" where the
+			 * gap is either the low watermark or 1%
+			 * of the zone, whichever is smaller.
 			 */
+			balance_gap = min(low_wmark_pages(zone),
+				(zone->present_pages +
+					KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
+				KSWAPD_ZONE_BALANCE_GAP_RATIO);
 			if (!zone_watermark_ok_safe(zone, order,
-					8*high_wmark_pages(zone), end_zone, 0))
+					high_wmark_pages(zone) + balance_gap,
+					end_zone, 0))
 				shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
