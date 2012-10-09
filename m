Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab2JIGx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:53:57 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37287 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2JIGxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:53:54 -0400
From: Robin Dong <robin.k.dong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>, Tejun Heo <tj@kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <boyu.mt@taobao.com>
Subject: [PATCH V3] block/throttle: Add IO throttled information in blkio.throttle
Date: Tue,  9 Oct 2012 14:53:45 +0800
Message-Id: <1349765625-4020-1-git-send-email-robin.k.dong@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Dong <sanbai@taobao.com>

Currently, if the IO is throttled by io-throttle, the SA has no idea of
the situation and can't report it to the real application user about
that he/she has to do something. So this patch adds a new interface
named blkio.throttle.io_queued which indicates how many IOs are
currently throttled.

The nr_queued[] of struct throtl_grp is of type "unsigned int" and updates
to it are atomic both at 32bit and 64bit platforms, so we could just
read tg->nr_queued only under blkcg->lock.

Changelog from v2:
	Use nr-queued[] of struct throtl_grp for stats instaed of adding new blkg_rwstat.

Cc: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 block/blk-throttle.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index a9664fa..e410448 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -953,6 +953,32 @@ static u64 tg_prfill_cpu_rwstat(struct seq_file *sf,
 	return __blkg_prfill_rwstat(sf, pd, &rwstat);
 }
 
+static u64 tg_prfill_io_queued(struct seq_file *sf,
+				struct blkg_policy_data *pd, int off)
+{
+	static const char *rwstr[] = {
+		[READ]	= "Read",
+		[WRITE]	= "Write",
+	};
+	struct throtl_grp *tg = pd_to_tg(pd);
+	const char *dname = NULL;
+	unsigned int v;
+	int i;
+
+	if (pd->blkg->q->backing_dev_info.dev)
+		dname = dev_name(pd->blkg->q->backing_dev_info.dev);
+
+	if (!dname)
+		return 0;
+
+	for (i = 0; i <= WRITE; i++)
+		seq_printf(sf, "%s %s %u\n", dname, rwstr[i], tg->nr_queued[i]);
+
+	v = tg->nr_queued[READ] + tg->nr_queued[WRITE];
+	seq_printf(sf, "%s Total %u\n", dname, v);
+	return v;
+}
+
 static int tg_print_cpu_rwstat(struct cgroup *cgrp, struct cftype *cft,
 			       struct seq_file *sf)
 {
@@ -963,6 +989,16 @@ static int tg_print_cpu_rwstat(struct cgroup *cgrp, struct cftype *cft,
 	return 0;
 }
 
+static int tg_print_io_queued(struct cgroup *cgrp, struct cftype *cft,
+			       struct seq_file *sf)
+{
+	struct blkcg *blkcg = cgroup_to_blkcg(cgrp);
+
+	blkcg_print_blkgs(sf, blkcg, tg_prfill_io_queued, &blkcg_policy_throtl,
+			  cft->private, true);
+	return 0;
+}
+
 static u64 tg_prfill_conf_u64(struct seq_file *sf, struct blkg_policy_data *pd,
 			      int off)
 {
@@ -1085,6 +1121,10 @@ static struct cftype throtl_files[] = {
 		.private = offsetof(struct tg_stats_cpu, serviced),
 		.read_seq_string = tg_print_cpu_rwstat,
 	},
+	{
+		.name = "throttle.io_queued",
+		.read_seq_string = tg_print_io_queued,
+	},
 	{ }	/* terminate */
 };
 
-- 
1.7.1

