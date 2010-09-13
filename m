Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab0IMF7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 01:59:33 -0400
Received: from smtp-out.google.com ([74.125.121.35]:61544 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab0IMF7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 01:59:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=W5zOeluDQGHMoWvQ5AbdJNqDLGOe1NhvB0zyFoXm67P61j4MD5HBIU3dKImLsx/6B
	QrUnTJLEnRAol8OAOCawg==
From: Michael Rubin <mrubin@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Cc: fengguang.wu@intel.com, jack@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, david@fromorbit.com,
        kosaki.motohiro@jp.fujitsu.com, npiggin@kernel.dk, hch@lst.de,
        axboe@kernel.dk, Michael Rubin <mrubin@google.com>
Subject: [PATCH 3/5] writeback: nr_dirtied and nr_written in /proc/vmstat
Date: Sun, 12 Sep 2010 22:58:11 -0700
Message-Id: <1284357493-20078-4-git-send-email-mrubin@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284357493-20078-1-git-send-email-mrubin@google.com>
References: <1284357493-20078-1-git-send-email-mrubin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To help developers and applications gain visibility into writeback
behaviour adding two entries to vm_stat_items and /proc/vmstat. This
will allow us to track the "written" and "dirtied" counts.

   # grep nr_dirtied /proc/vmstat
   nr_dirtied 3747
   # grep nr_written /proc/vmstat
   nr_written 3618

Signed-off-by: Michael Rubin <mrubin@google.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/mmzone.h |    2 ++
 mm/page-writeback.c    |    2 ++
 mm/vmstat.c            |    3 +++
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6e6e626..d0d7454 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -104,6 +104,8 @@ enum zone_stat_item {
 	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
 	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
 	NR_SHMEM,		/* shmem pages (included tmpfs/GEM pages) */
+	NR_FILE_DIRTIED,	/* accumulated dirty pages */
+	NR_WRITTEN,		/* accumulated written pages */
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
 	NUMA_MISS,		/* allocated in non intended node */
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index ae5f5d5..4d6ef9c 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1126,6 +1126,7 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
 {
 	if (mapping_cap_account_dirty(mapping)) {
 		__inc_zone_page_state(page, NR_FILE_DIRTY);
+		__inc_zone_page_state(page, NR_FILE_DIRTIED);
 		__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
 		task_dirty_inc(current);
 		task_io_account_write(PAGE_CACHE_SIZE);
@@ -1141,6 +1142,7 @@ EXPORT_SYMBOL(account_page_dirtied);
 void account_page_writeback(struct page *page)
 {
 	inc_zone_page_state(page, NR_WRITEBACK);
+	inc_zone_page_state(page, NR_WRITTEN);
 }
 EXPORT_SYMBOL(account_page_writeback);
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f389168..d448ef4 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -732,6 +732,9 @@ static const char * const vmstat_text[] = {
 	"nr_isolated_anon",
 	"nr_isolated_file",
 	"nr_shmem",
+	"nr_dirtied",
+	"nr_written",
+
 #ifdef CONFIG_NUMA
 	"numa_hit",
 	"numa_miss",
-- 
1.7.1

