Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab1BVHq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 02:46:56 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:39309 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795Ab1BVHqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 02:46:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAC72Yk120uZw/2dsb2JhbAChaYRZdLtjhV4EkWg
Message-ID: <4D6369E8.7080708@internode.on.net>
Date: Tue, 22 Feb 2011 18:16:48 +1030
From: Arthur Marsh <arthur.marsh@internode.on.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-AU; rv:1.9.2.13) Gecko/20101213 Icedove/3.1.7
MIME-Version: 1.0
To: Clemens Ladisch <cladisch@googlemail.com>
CC: Andrea Arcangeli <aarcange@redhat.com>, alsa-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified
 - 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd
 for GFP_ATOMIC order > 0
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net> <4D6367B3.9050306@googlemail.com>
In-Reply-To: <4D6367B3.9050306@googlemail.com>
Content-Type: multipart/mixed;
 boundary="------------080006040102040407020407"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080006040102040407020407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Clemens Ladisch wrote, on 22/02/11 18:07:
> Arthur Marsh wrote:
>> I'm experiencing MIDI playback slow-downs when I'm observing kswapd0
>> active (a few percent of cpu in top output) in recent kernels.
>>
>> I git-bisected the problem down to:
>>
>> commit 5a03b051ed87e72b959f32a86054e1142ac4cf55
>> Author: Andrea Arcangeli<aarcange@redhat.com>
>> Date:   Thu Jan 13 15:47:11 2011 -0800
>>
>>       thp: use compaction in kswapd for GFP_ATOMIC order>  0
>>
>>       This takes advantage of memory compaction to properly generate pages of
>>       order>  0 if regular page reclaim fails and priority level becomes more
>>       severe and we don't reach the proper watermarks.
>>
>>       Signed-off-by: Andrea Arcangeli<aarcange@redhat.com>
>>       Signed-off-by: Andrew Morton<akpm@linux-foundation.org>
>>       Signed-off-by: Linus Torvalds<torvalds@linux-foundation.org>
>>
>> I ran git-bisect over the weekend, building and installing ALSA 1.0.24
>> with each kernel. After identifying the above commit, I rebuilt the 2.6
>> head with that commit reverted and verified that the problem was no
>> longer present.
>
> Apparently, huge page compaction disables interrupts for much too long.
>
>> MIDI playback was via aplaymidi -p 17:0 to a Soundblaster Audigy 2 ZS
>> (SB0350) wavetable.
>
> The ALSA sequencer uses either the system timer or an HR timer at 1 kHz
> to deliver MIDI commands (notes); the wavetable driver requires its own
> interrupts in regular 5.3 ms intervals.
>
>
> Regards,
> Clemens
>

Hi, Andrea Arcangeli's "z1" patch (attached) solved the problem for me, 
even with significant swap activity.

Regards,

Arthur.

--------------080006040102040407020407
Content-Type: text/plain;
 name="z1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="z1"

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 17497d0..5718bca 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2385,7 +2385,6 @@ loop_again:
 		 * cause too much scanning of the lower zones.
 		 */
 		for (i = 0; i <= end_zone; i++) {
-			int compaction;
 			struct zone *zone = pgdat->node_zones + i;
 			int nr_slab;
 
@@ -2408,7 +2407,7 @@ loop_again:
 			 * zone has way too many pages free already.
 			 */
 			if (!zone_watermark_ok_safe(zone, order,
-					8*high_wmark_pages(zone), end_zone, 0))
+					high_wmark_pages(zone), end_zone, 0))
 				shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
@@ -2416,24 +2415,23 @@ loop_again:
 			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
 
-			compaction = 0;
+#if 0
 			if (order &&
 			    zone_watermark_ok(zone, 0,
 					       high_wmark_pages(zone),
 					      end_zone, 0) &&
 			    !zone_watermark_ok(zone, order,
 					       high_wmark_pages(zone),
-					       end_zone, 0)) {
+					       end_zone, 0))
 				compact_zone_order(zone,
 						   order,
 						   sc.gfp_mask, false,
 						   COMPACT_MODE_KSWAPD);
-				compaction = 1;
-			}
+#endif
 
 			if (zone->all_unreclaimable)
 				continue;
-			if (!compaction && nr_slab == 0 &&
+			if (nr_slab == 0 &&
 			    !zone_reclaimable(zone))
 				zone->all_unreclaimable = 1;
 			/*

--------------080006040102040407020407--
