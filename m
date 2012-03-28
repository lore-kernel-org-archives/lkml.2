Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab2C1WwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:52:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38246 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758920Ab2C1Wvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:51:42 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/21] blkcg: BLKIO_STAT_CPU_SECTORS doesn't have subcounters
Date: Wed, 28 Mar 2012 15:51:12 -0700
Message-Id: <1332975091-10950-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332975091-10950-1-git-send-email-tj@kernel.org>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BLKIO_STAT_CPU_SECTORS doesn't need read/write/sync/async subcounters
and is counted by blkio_group_stats_cpu->sectors; however, it still
holds a member in blkio_group_stats_cpu->stat_arr_cpu.

Rearrange stat_type_cpu and define BLKIO_STAT_CPU_ARR_NR and use it
for stat_arr_cpu[] size so that only SERVICE_BYTES and SERVICED have
subcounters.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.h |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 1add3dc..2060d81 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -58,14 +58,17 @@ enum stat_type {
 
 /* Per cpu stats */
 enum stat_type_cpu {
-	BLKIO_STAT_CPU_SECTORS,
 	/* Total bytes transferred */
 	BLKIO_STAT_CPU_SERVICE_BYTES,
 	/* Total IOs serviced, post merge */
 	BLKIO_STAT_CPU_SERVICED,
-	BLKIO_STAT_CPU_NR
+
+	/* All the single valued stats go below this */
+	BLKIO_STAT_CPU_SECTORS,
 };
 
+#define BLKIO_STAT_CPU_ARR_NR	(BLKIO_STAT_CPU_SERVICED + 1)
+
 enum stat_sub_type {
 	BLKIO_STAT_READ = 0,
 	BLKIO_STAT_WRITE,
@@ -167,7 +170,7 @@ struct blkio_group_stats {
 /* Per cpu blkio group stats */
 struct blkio_group_stats_cpu {
 	uint64_t sectors;
-	uint64_t stat_arr_cpu[BLKIO_STAT_CPU_NR][BLKIO_STAT_TOTAL];
+	uint64_t stat_arr_cpu[BLKIO_STAT_CPU_ARR_NR][BLKIO_STAT_TOTAL];
 	struct u64_stats_sync syncp;
 };
 
-- 
1.7.7.3

