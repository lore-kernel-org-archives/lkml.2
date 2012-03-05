Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab2CERUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:20:08 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49030 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab2CERUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:20:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.190.8 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Mon, 5 Mar 2012 09:20:00 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120305172000.GQ22536@google.com>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
 <20120223144336.58742e1b.akpm@linux-foundation.org>
 <20120223230123.GL22536@google.com>
 <20120223231204.GM22536@google.com>
 <20120227182220.GD27677@redhat.com>
 <20120229190354.GC5930@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120229190354.GC5930@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

Sorry about the delay.  Was off last week.

On Wed, Feb 29, 2012 at 02:03:54PM -0500, Vivek Goyal wrote:
> Ok, more debugging revealed that culprit here is "floppy" driver module.
> It instanciates a queue but never registers a disk against it. Better
> skip such queues/groups. Here is the patch.

Urgh.. I hate that driver.  I ended up folding the following patch in
the series right after "blkcg: kill the mind-bending blkg->dev".

Thanks.

Subject: blkcg: skip blkg printing if q isn't associated with disk

blk-cgroup printing code currently assumes that there is a device/disk
associated with every queue in the system, but modules like floppy,
can instantiate request queues without registering disk which can lead
to oops.

Skip the queue/blkg which don't have dev/disk associated with them.

-tj: Factored out backing_dev_info check into blkg_dev_name().

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

Index: work/block/blk-cgroup.c
===================================================================
--- work.orig/block/blk-cgroup.c
+++ work/block/blk-cgroup.c
@@ -951,13 +951,24 @@ static int blkiocg_file_write(struct cgr
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
@@ -1049,9 +1060,9 @@ static int blkio_read_blkg_stats(struct 
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {
-		const char *dname = dev_name(blkg->q->backing_dev_info.dev);
+		const char *dname = blkg_dev_name(blkg);
 
-		if (BLKIOFILE_POLICY(cft->private) != blkg->plid)
+		if (!dname || BLKIOFILE_POLICY(cft->private) != blkg->plid)
 			continue;
 		if (pcpu)
 			cgroup_total += blkio_get_stat_cpu(blkg, cb, dname,
