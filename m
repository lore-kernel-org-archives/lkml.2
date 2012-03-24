Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab2CXCEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 22:04:10 -0400
Received: from ozlabs.org ([203.10.76.45]:47651 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab2CXCEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 22:04:07 -0400
Date: Sat, 24 Mar 2012 13:03:53 +1100
From: Anton Blanchard <anton@samba.org>
To: riel@redhat.com, aarcange@redhat.com, mel@csn.ul.ie,
        akpm@linux-foundation.org, hughd@google.com
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: kswapd stuck using 100% CPU
Message-ID: <20120324130353.48f2e4c8@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I booted the latest git today on a ppc64 box. When I pushed it into
swap I noticed both kswapd's were using 100% CPU and the soft lockup
detector suggested it was stuck in balance_pgdat:

BUG: soft lockup - CPU#7 stuck for 23s! [kswapd1:359]
Call Trace:
[c00000000015e190] .balance_pgdat+0x150/0x940 
[c00000000015eb2c] .kswapd+0x1ac/0x490
[c00000000009edbc] .kthread+0xbc/0xd0
[c00000000002142c] .kernel_thread+0x54/0x70

I haven't had time to bisect but I did notice we were looping here:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7658fd6..c92bad2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2945,9 +2959,11 @@ out:
 			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;
 
+#if 0
 			/* Would compaction fail due to lack of free memory? */
 			if (compaction_suitable(zone, order) == COMPACT_SKIPPED)
 				goto loop_again;
+#endif
 
 			/* Confirm the zone is balanced for order-0 */
 			if (!zone_watermark_ok(zone, 0,


After commenting it out the box is happy again.

Anton
