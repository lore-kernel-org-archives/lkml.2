Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab2FTLov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:44:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab2FTLod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:44:33 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 17/17] mm: Account for the number of times direct reclaimers get throttled
Date: Wed, 20 Jun 2012 12:44:12 +0100
Message-Id: <1340192652-31658-18-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1340192652-31658-1-git-send-email-mgorman@suse.de>
References: <1340192652-31658-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under significant pressure when writing back to network-backed storage,
direct reclaimers may get throttled. This is expected to be a
short-lived event and the processes get woken up again but processes do
get stalled. This patch counts how many times such stalling occurs. It's
up to the administrator whether to reduce these stalls by increasing
min_free_kbytes.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/vm_event_item.h |    1 +
 mm/vmscan.c                   |    3 +++
 mm/vmstat.c                   |    1 +
 3 files changed, 5 insertions(+)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 06f8e38..57f7b10 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -30,6 +30,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGSTEAL_DIRECT),
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
+		PGSCAN_DIRECT_THROTTLE,
 #ifdef CONFIG_NUMA
 		PGSCAN_ZONE_RECLAIM_FAILED,
 #endif
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bf8625c..bcc65c5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2166,6 +2166,9 @@ static void throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 	if (pfmemalloc_watermark_ok(pgdat))
 		return;
 
+	/* Account for the throttling */
+	count_vm_event(PGSCAN_DIRECT_THROTTLE);
+
 	/*
 	 * If the caller cannot enter the filesystem, it's possible that it
 	 * is due to the caller holding an FS lock or performing a journal
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 1bbbbd9..df7a674 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -745,6 +745,7 @@ const char * const vmstat_text[] = {
 	TEXTS_FOR_ZONES("pgsteal_direct")
 	TEXTS_FOR_ZONES("pgscan_kswapd")
 	TEXTS_FOR_ZONES("pgscan_direct")
+	"pgscan_direct_throttle",
 
 #ifdef CONFIG_NUMA
 	"zone_reclaim_failed",
-- 
1.7.9.2

