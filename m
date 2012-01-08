Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab2AHHFG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 02:05:06 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48040 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab2AHHFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 02:05:05 -0500
MIME-Version: 1.0
Date: Sun, 8 Jan 2012 15:05:03 +0800
Message-ID: <CAJd=RBAqzawZ=jEFt7TrZgU0gaejMkfiBxzH7Y19qqNnsZrJGw@mail.gmail.com>
Subject: [PATCH] mm: vmscan: fix setting reclaim mode
From: Hillf Danton <dhillf@gmail.com>
To: linux-mm@kvack.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check for under memory pressure is corrected, then lumpy reclaim or
reclaim/compaction could be avoided either when for order-O reclaim or
when free pages are already low enough.


Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/vmscan.c	Thu Dec 29 20:20:16 2011
+++ b/mm/vmscan.c	Sun Jan  8 13:22:12 2012
@@ -365,8 +365,7 @@ out:
 	return ret;
 }

-static void set_reclaim_mode(int priority, struct scan_control *sc,
-				   bool sync)
+static void set_reclaim_mode(int priority, struct scan_control *sc, bool sync)
 {
 	reclaim_mode_t syncmode = sync ? RECLAIM_MODE_SYNC : RECLAIM_MODE_ASYNC;

@@ -381,13 +380,12 @@ static void set_reclaim_mode(int priorit
 		sc->reclaim_mode = RECLAIM_MODE_LUMPYRECLAIM;

 	/*
-	 * Avoid using lumpy reclaim or reclaim/compaction if possible by
-	 * restricting when its set to either costly allocations or when
-	 * under memory pressure
+	 * Avoid lumpy reclaim or reclaim/compaction either
+	 * when for order-O reclaim or when under memory pressure
 	 */
 	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
 		sc->reclaim_mode |= syncmode;
-	else if (sc->order && priority < DEF_PRIORITY - 2)
+	else if (sc->order && priority >= DEF_PRIORITY - 2)
 		sc->reclaim_mode |= syncmode;
 	else
 		sc->reclaim_mode = RECLAIM_MODE_SINGLE | RECLAIM_MODE_ASYNC;
