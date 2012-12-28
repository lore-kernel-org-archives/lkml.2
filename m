Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab2L1UgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:36:23 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:49394 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab2L1UgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:36:14 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/24] cfq-iosched: Print sync-noidle information in blktrace messages
Date: Fri, 28 Dec 2012 12:35:28 -0800
Message-Id: <1356726946-26037-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

Currently we attach a character "S" or "A" to the cfqq<pid>, to represent
whether queues is sync or async. Add one more character "N" to represent
whether it is sync-noidle queue or sync queue. So now three different
type of queues will look as follows.

cfq1234S   --> sync queus
cfq1234SN  --> sync noidle queue
cfq1234A   --> Async queue

Previously S/A classification was being printed only if group scheduling
was enabled. This patch also makes sure that this classification is
displayed even if group idling is disabled.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5ad4cae..bc076f4 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -586,8 +586,9 @@ static inline void cfqg_put(struct cfq_group *cfqg)
 	char __pbuf[128];						\
 									\
 	blkg_path(cfqg_to_blkg((cfqq)->cfqg), __pbuf, sizeof(__pbuf));	\
-	blk_add_trace_msg((cfqd)->queue, "cfq%d%c %s " fmt, (cfqq)->pid, \
-			  cfq_cfqq_sync((cfqq)) ? 'S' : 'A',		\
+	blk_add_trace_msg((cfqd)->queue, "cfq%d%c%c %s " fmt, (cfqq)->pid, \
+			cfq_cfqq_sync((cfqq)) ? 'S' : 'A',		\
+			cfqq_type((cfqq)) == SYNC_NOIDLE_WORKLOAD ? 'N' : ' ',\
 			  __pbuf, ##args);				\
 } while (0)
 
@@ -675,7 +676,10 @@ static inline void cfqg_get(struct cfq_group *cfqg) { }
 static inline void cfqg_put(struct cfq_group *cfqg) { }
 
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
-	blk_add_trace_msg((cfqd)->queue, "cfq%d " fmt, (cfqq)->pid, ##args)
+	blk_add_trace_msg((cfqd)->queue, "cfq%d%c%c " fmt, (cfqq)->pid,	\
+			cfq_cfqq_sync((cfqq)) ? 'S' : 'A',		\
+			cfqq_type((cfqq)) == SYNC_NOIDLE_WORKLOAD ? 'N' : ' ',\
+				##args)
 #define cfq_log_cfqg(cfqd, cfqg, fmt, args...)		do {} while (0)
 
 static inline void cfqg_stats_update_io_add(struct cfq_group *cfqg,
-- 
1.8.0.2

