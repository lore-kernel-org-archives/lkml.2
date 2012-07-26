Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab2GZVeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:34:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51347 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab2GZVbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:31:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Nai Xia <nai.xia@gmail.com>, Johannes Weiner <jweiner@redhat.com>
Subject: [ 30/40] mm: vmscan: do not OOM if aborting reclaim to start compaction
Date: Thu, 26 Jul 2012 14:29:48 -0700
Message-Id: <20120726211413.835714018@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211411.164006056@linuxfoundation.org>
References: <20120726211424.GA7709@kroah.com>
 <20120726211411.164006056@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 7335084d446b83cbcb15da80497d03f0c1dc9e21 upstream.

Stable note: Not tracked in Bugzilla. This patch makes later patches
	easier to apply but otherwise has little to justify it. The
	problem it fixes was never observed but the source of the
	theoretical problem did not exist for very long.

During direct reclaim it is possible that reclaim will be aborted so that
compaction can be attempted to satisfy a high-order allocation.  If this
decision is made before any pages are reclaimed, it is possible that 0 is
returned to the page allocator potentially triggering an OOM.  This has
not been observed but it is a possibility so this patch addresses it.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 mm/vmscan.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2240,6 +2240,7 @@ static unsigned long do_try_to_free_page
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long writeback_threshold;
+	bool should_abort_reclaim;
 
 	get_mems_allowed();
 	delayacct_freepages_start();
@@ -2251,7 +2252,8 @@ static unsigned long do_try_to_free_page
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token(sc->mem_cgroup);
-		if (shrink_zones(priority, zonelist, sc))
+		should_abort_reclaim = shrink_zones(priority, zonelist, sc);
+		if (should_abort_reclaim)
 			break;
 
 		/*
@@ -2318,6 +2320,10 @@ out:
 	if (oom_killer_disabled)
 		return 0;
 
+	/* Aborting reclaim to try compaction? don't OOM, then */
+	if (should_abort_reclaim)
+		return 1;
+
 	/* top priority shrink_zones still had more to do? don't OOM, then */
 	if (scanning_global_lru(sc) && !all_unreclaimable(zonelist, sc))
 		return 1;


