Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030270Ab2CSKtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:49:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261Ab2CSKtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:49:47 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/12] GFS2: Sort the ordered write list
Date: Mon, 19 Mar 2012 10:25:20 +0000
Message-Id: <1332152728-4027-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch sorts the ordered write list for GFS2 writes.
This increases the throughput for simultaneous writes.
For example, if you have ten processes, all doing:
dd if=/dev/zero of=/mnt/gfs2/fileX
on different files, the throughput will be much better.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 4d31379..b8fe7b7 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -19,6 +19,7 @@
 #include <linux/freezer.h>
 #include <linux/bio.h>
 #include <linux/writeback.h>
+#include <linux/list_sort.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -566,6 +567,20 @@ static void log_flush_commit(struct gfs2_sbd *sdp)
 	log_write_header(sdp, 0, 0);
 }
 
+int bd_cmp(void *priv, struct list_head *a, struct list_head *b)
+{
+	struct gfs2_bufdata *bda, *bdb;
+
+	bda = list_entry(a, struct gfs2_bufdata, bd_le.le_list);
+	bdb = list_entry(b, struct gfs2_bufdata, bd_le.le_list);
+
+	if (bda->bd_bh->b_blocknr < bdb->bd_bh->b_blocknr)
+		return -1;
+	if (bda->bd_bh->b_blocknr > bdb->bd_bh->b_blocknr)
+		return 1;
+	return 0;
+}
+
 static void gfs2_ordered_write(struct gfs2_sbd *sdp)
 {
 	struct gfs2_bufdata *bd;
@@ -573,6 +588,7 @@ static void gfs2_ordered_write(struct gfs2_sbd *sdp)
 	LIST_HEAD(written);
 
 	gfs2_log_lock(sdp);
+	list_sort(NULL, &sdp->sd_log_le_ordered, &bd_cmp);
 	while (!list_empty(&sdp->sd_log_le_ordered)) {
 		bd = list_entry(sdp->sd_log_le_ordered.next, struct gfs2_bufdata, bd_le.le_list);
 		list_move(&bd->bd_le.le_list, &written);
-- 
1.7.4

