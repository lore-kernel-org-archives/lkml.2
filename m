Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0H1Cln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 22:41:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10276 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab0H1ClO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 22:41:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=N+CwSa1CnWBhVyCdPP5XtXs79cnSN/e/xLdYPthN1C4EYxDEln4q2S1wV/LOHkRFD
	7xKlAyj9PXGc8AECbTfKg==
From: Michael Rubin <mrubin@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Cc: fengguang.wu@intel.com, jack@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, david@fromorbit.com,
        kosaki.motohiro@jp.fujitsu.com, npiggin@kernel.dk, hch@lst.de,
        axboe@kernel.dk, Michael Rubin <mrubin@google.com>
Subject: [PATCH 4/4] writeback: Reporting dirty thresholds in /proc/vmstat
Date: Fri, 27 Aug 2010 19:40:27 -0700
Message-Id: <1282963227-31867-5-git-send-email-mrubin@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282963227-31867-1-git-send-email-mrubin@google.com>
References: <1282963227-31867-1-git-send-email-mrubin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already exposes the user desired thresholds in /proc/sys/vm
with dirty_background_ratio and background_ratio. But the kernel may
alter the number requested without giving the user any indication that
is the case.

Knowing the actual ratios the kernel is honoring can help app developers
understand how their buffered IO will be sent to the disk.

        $ grep threshold /proc/vmstat
        nr_dirty_threshold 409111
        nr_dirty_background_threshold 818223

Signed-off-by: Michael Rubin <mrubin@google.com>
---
 include/linux/mmzone.h |    2 ++
 mm/vmstat.c            |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index d42f179..ad48963 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -106,6 +106,8 @@ enum zone_stat_item {
 	NR_SHMEM,		/* shmem pages (included tmpfs/GEM pages) */
 	NR_FILE_PAGES_DIRTIED,	/* number of times pages get dirtied */
 	NR_PAGES_CLEANED,	/* number of times pages enter writeback */
+	NR_DIRTY_THRESHOLD,	/* writeback threshold */
+	NR_DIRTY_BG_THRESHOLD,	/* bg writeback threshold */
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
 	NUMA_MISS,		/* allocated in non intended node */
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 8521475..2342010 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -17,6 +17,7 @@
 #include <linux/vmstat.h>
 #include <linux/sched.h>
 #include <linux/math64.h>
+#include <linux/writeback.h>
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
@@ -734,6 +735,8 @@ static const char * const vmstat_text[] = {
 	"nr_shmem",
 	"nr_dirtied",
 	"nr_cleaned",
+	"nr_dirty_threshold",
+	"nr_dirty_background_threshold",
 
 #ifdef CONFIG_NUMA
 	"numa_hit",
@@ -917,6 +920,8 @@ static void *vmstat_start(struct seq_file *m, loff_t *pos)
 		return ERR_PTR(-ENOMEM);
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 		v[i] = global_page_state(i);
+
+	global_dirty_limits(v + NR_DIRTY_BG_THRESHOLD, v + NR_DIRTY_THRESHOLD);
 #ifdef CONFIG_VM_EVENT_COUNTERS
 	e = v + NR_VM_ZONE_STAT_ITEMS;
 	all_vm_events(e);
-- 
1.7.1

