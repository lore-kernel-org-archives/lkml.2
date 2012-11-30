Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531Ab2K3THv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:07:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:59814 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993093Ab2K3TCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Luigi Semenzato <semenzato@google.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Sonny Rao <sonnyrao@google.com>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        CAI Qian <caiqian@redhat.com>
Subject: [ 48/54] mm: vmscan: check for fatal signals iff the process was throttled
Date: Fri, 30 Nov 2012 10:56:19 -0800
Message-Id: <20121130185212.740469578@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 50694c28f1e1dbea18272980d265742a5027fb63 upstream.

Commit 5515061d22f0 ("mm: throttle direct reclaimers if PF_MEMALLOC
reserves are low and swap is backed by network storage") introduced a
check for fatal signals after a process gets throttled for network
storage.  The intention was that if a process was throttled and got
killed that it should not trigger the OOM killer.  As pointed out by
Minchan Kim and David Rientjes, this check is in the wrong place and too
broad.  If a system is in am OOM situation and a process is exiting, it
can loop in __alloc_pages_slowpath() and calling direct reclaim in a
loop.  As the fatal signal is pending it returns 1 as if it is making
forward progress and can effectively deadlock.

This patch moves the fatal_signal_pending() check after throttling to
throttle_direct_reclaim() where it belongs.  If the process is killed
while throttled, it will return immediately without direct reclaim
except now it will have TIF_MEMDIE set and will use the PFMEMALLOC
reserves.

Minchan pointed out that it may be better to direct reclaim before
returning to avoid using the reserves because there may be pages that
can easily reclaim that would avoid using the reserves.  However, we do
no such targetted reclaim and there is no guarantee that suitable pages
are available.  As it is expected that this throttling happens when
swap-over-NFS is used there is a possibility that the process will
instead swap which may allocate network buffers from the PFMEMALLOC
reserves.  Hence, in the swap-over-nfs case where a process can be
throtted and be killed it can use the reserves to exit or it can
potentially use reserves to swap a few pages and then exit.  This patch
takes the option of using the reserves if necessary to allow the process
exit quickly.

If this patch passes review it should be considered a -stable candidate
for 3.6.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |   37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2176,9 +2176,12 @@ static bool pfmemalloc_watermark_ok(pg_d
  * Throttle direct reclaimers if backing storage is backed by the network
  * and the PFMEMALLOC reserve for the preferred node is getting dangerously
  * depleted. kswapd will continue to make progress and wake the processes
- * when the low watermark is reached
+ * when the low watermark is reached.
+ *
+ * Returns true if a fatal signal was delivered during throttling. If this
+ * happens, the page allocator should not consider triggering the OOM killer.
  */
-static void throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
+static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 					nodemask_t *nodemask)
 {
 	struct zone *zone;
@@ -2193,13 +2196,20 @@ static void throttle_direct_reclaim(gfp_
 	 * processes to block on log_wait_commit().
 	 */
 	if (current->flags & PF_KTHREAD)
-		return;
+		goto out;
+
+	/*
+	 * If a fatal signal is pending, this process should not throttle.
+	 * It should return quickly so it can exit and free its memory
+	 */
+	if (fatal_signal_pending(current))
+		goto out;
 
 	/* Check if the pfmemalloc reserves are ok */
 	first_zones_zonelist(zonelist, high_zoneidx, NULL, &zone);
 	pgdat = zone->zone_pgdat;
 	if (pfmemalloc_watermark_ok(pgdat))
-		return;
+		goto out;
 
 	/* Account for the throttling */
 	count_vm_event(PGSCAN_DIRECT_THROTTLE);
@@ -2215,12 +2225,20 @@ static void throttle_direct_reclaim(gfp_
 	if (!(gfp_mask & __GFP_FS)) {
 		wait_event_interruptible_timeout(pgdat->pfmemalloc_wait,
 			pfmemalloc_watermark_ok(pgdat), HZ);
-		return;
+
+		goto check_pending;
 	}
 
 	/* Throttle until kswapd wakes the process */
 	wait_event_killable(zone->zone_pgdat->pfmemalloc_wait,
 		pfmemalloc_watermark_ok(pgdat));
+
+check_pending:
+	if (fatal_signal_pending(current))
+		return true;
+
+out:
+	return false;
 }
 
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
@@ -2242,13 +2260,12 @@ unsigned long try_to_free_pages(struct z
 		.gfp_mask = sc.gfp_mask,
 	};
 
-	throttle_direct_reclaim(gfp_mask, zonelist, nodemask);
-
 	/*
-	 * Do not enter reclaim if fatal signal is pending. 1 is returned so
-	 * that the page allocator does not consider triggering OOM
+	 * Do not enter reclaim if fatal signal was delivered while throttled.
+	 * 1 is returned so that the page allocator does not OOM kill at this
+	 * point.
 	 */
-	if (fatal_signal_pending(current))
+	if (throttle_direct_reclaim(gfp_mask, zonelist, nodemask))
 		return 1;
 
 	trace_mm_vmscan_direct_reclaim_begin(order,


