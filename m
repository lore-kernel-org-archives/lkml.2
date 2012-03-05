Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab2CEU7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:59:55 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:58223 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2CEU7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:59:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.213.163 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Mon, 5 Mar 2012 12:59:49 -0800
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: [PATCH 17.5] blkcg: skip blkg printing if q isn't associated with
 disk
Message-ID: <20120305205949.GA1263@google.com>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329875223-5102-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 753d7ea85c1d8648a9edb84539849018631335ea Mon Sep 17 00:00:00 2001
From: Vivek Goyal <vgoyal@redhat.com>
Date: Mon, 5 Mar 2012 12:54:07 -0800

blk-cgroup printing code currently assumes that there is a device/disk
associated with every queue in the system, but modules like floppy,
can instantiate request queues without registering disk which can lead
to oops.

Skip the queue/blkg which don't have dev/disk associated with them.

-tj: Factored out backing_dev_info check into blkg_dev_name().

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
This causes series of minor conflicts with following patches.  I'll
write about it in a reply to the top post.

Thanks.

 block/blk-cgroup.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8742af3..7694236 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -951,13 +951,24 @@ static int blkiocg_file_write(struct cgroup *cgrp, struct cftype *cft,
 	return ret;
 }
 
+static const char *blkg_dev_name(struct blkio_group *blkg)
+{
+	/* some drivers (floppy) instantiate a queue w/o disk registered */
+	if (blkg->q->backing_dev_info.dev)
+		return dev_name(blkg->q->backing_dev_info.dev);
+	return NULL;
+}
+
 static void blkio_print_group_conf(struct cftype *cft, struct blkio_group *blkg,
 				   struct seq_file *m)
 {
-	const char *dname = dev_name(blkg->q->backing_dev_info.dev);
+	const char *dname = blkg_dev_name(blkg);
 	int fileid = BLKIOFILE_ATTR(cft->private);
 	int rw = WRITE;
 
+	if (!dname)
+		return;
+
 	switch (blkg->plid) {
 		case BLKIO_POLICY_PROP:
 			if (blkg->conf.weight)
@@ -1049,9 +1060,9 @@ static int blkio_read_blkg_stats(struct blkio_cgroup *blkcg,
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {
-		const char *dname = dev_name(blkg->q->backing_dev_info.dev);
+		const char *dname = blkg_dev_name(blkg);
 
-		if (BLKIOFILE_POLICY(cft->private) != blkg->plid)
+		if (!dname || BLKIOFILE_POLICY(cft->private) != blkg->plid)
 			continue;
 		if (pcpu)
 			cgroup_total += blkio_get_stat_cpu(blkg, cb, dname,
-- 
1.7.7.3

