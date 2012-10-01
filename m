Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2JATgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:36:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab2JATdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:33:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: tj@kernel.org, cgroups@vger.kernel.org, vgoyal@redhat.com
Subject: [PATCH 06/15] cfq-iosched: Print sync-noidle information in blktrace messages
Date: Mon,  1 Oct 2012 15:32:47 -0400
Message-Id: <1349119976-26837-7-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 block/cfq-iosched.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 573e668..619c680 100644
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
1.7.7.6

