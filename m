Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab1LGPQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 10:16:48 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51174 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab1LGPQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 10:16:47 -0500
Subject: [PATCH 1/2] mm: provide zone vmstat percpu drift bounds
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>
Date: Wed, 07 Dec 2011 19:16:41 +0300
Message-ID: <20111207151641.30334.84106.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmstat use per-cpu counters for accounting, so atomic part on struct zone has some drift.
Free-pages watermark logic has some protection against this innacuracy.
too-many-isolated checks has the same problem. This patch provides drift bounds for them.

Plus this patch reset zone->percpu_drift_mark if drift protection is no longer required,
this can happens after memory hotplug.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/mmzone.h |    3 +++
 mm/vmstat.c            |    6 +++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 188cb2f..401438d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -307,6 +307,9 @@ struct zone {
 	 */
 	unsigned long percpu_drift_mark;
 
+	/* Maximum vm_stat per-cpu counters drift */
+	unsigned long percpu_drift;
+
 	/*
 	 * We don't know if the memory that we're going to allocate will be freeable
 	 * or/and it will be released eventually, so to avoid totally wasting several
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 8fd603b..94540e1 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -172,16 +172,20 @@ void refresh_zone_stat_thresholds(void)
 			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
 							= threshold;
 
+		max_drift = num_online_cpus() * threshold;
+		zone->percpu_drift = max_drift;
+
 		/*
 		 * Only set percpu_drift_mark if there is a danger that
 		 * NR_FREE_PAGES reports the low watermark is ok when in fact
 		 * the min watermark could be breached by an allocation
 		 */
 		tolerate_drift = low_wmark_pages(zone) - min_wmark_pages(zone);
-		max_drift = num_online_cpus() * threshold;
 		if (max_drift > tolerate_drift)
 			zone->percpu_drift_mark = high_wmark_pages(zone) +
 					max_drift;
+		else
+			zone->percpu_drift_mark = 0;
 	}
 }
 

