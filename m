Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab1AZHQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:16:35 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44685 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab1AZHQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:16:32 -0500
Date: Tue, 25 Jan 2011 23:16:26 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        axboe@kernel.dk, tytso@mit.edu, shli@kernel.org, neilb@suse.de,
        adilger.kernel@dilger.ca, jack@suse.cz, snitzer@redhat.com,
        linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
        linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
        josef@redhat.com
Subject: [PATCH 1/3] block: Create sysfs knobs to override FLUSH/FUA
	support flags
Message-ID: <20110126071626.GI27190@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20110126071200.GE32261@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126071200.GE32261@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is the first in a series to refactor the barrier= mount options out
of the filesystem code.  This patch adds sysfs knobs to disable flush and FUA;
of course, the automatic default is the safe choice, i.e. to leave them
enabled.  Obviously, only a seasoned administrator should ever be overriding
the defaults.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 block/blk-settings.c   |    1 +
 block/blk-sysfs.c      |   66 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    1 +
 3 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 36c8c1f..719c990 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -802,6 +802,7 @@ void blk_queue_flush(struct request_queue *q, unsigned int flush)
 		flush &= ~REQ_FUA;
 
 	q->flush_flags = flush & (REQ_FLUSH | REQ_FUA);
+	q->hw_flush_flags = q->flush_flags;
 }
 EXPORT_SYMBOL_GPL(blk_queue_flush);
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 41fb691..af872a8 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -31,6 +31,58 @@ queue_var_store(unsigned long *var, const char *page, size_t count)
 	return count;
 }
 
+static ssize_t queue_flushflag_ignore_show(struct request_queue *q, char *page,
+					   unsigned int which)
+{
+	if (!(q->hw_flush_flags & which))
+		return sprintf(page, "0\n");
+
+	if (!(q->flush_flags & which))
+		return sprintf(page, "1\n");
+
+	return sprintf(page, "0\n");
+}
+
+static ssize_t
+queue_flushflag_ignore_store(struct request_queue *q, const char *page,
+			     size_t count, unsigned int which)
+{
+	unsigned long ignore;
+	ssize_t ret = queue_var_store(&ignore, page, count);
+
+	if (!(q->hw_flush_flags & which))
+		return -EINVAL;
+
+	if (ignore)
+		q->flush_flags &= ~which;
+	else
+		q->flush_flags |= which;
+
+	return ret;
+}
+
+static ssize_t queue_ignore_flush_show(struct request_queue *q, char *page)
+{
+	return queue_flushflag_ignore_show(q, page, REQ_FLUSH);
+}
+
+static ssize_t queue_ignore_flush_store(struct request_queue *q,
+					const char *page, size_t count)
+{
+	return queue_flushflag_ignore_store(q, page, count, REQ_FLUSH);
+}
+
+static ssize_t queue_ignore_fua_show(struct request_queue *q, char *page)
+{
+	return queue_flushflag_ignore_show(q, page, REQ_FUA);
+}
+
+static ssize_t queue_ignore_fua_store(struct request_queue *q,
+				      const char *page, size_t count)
+{
+	return queue_flushflag_ignore_store(q, page, count, REQ_FUA);
+}
+
 static ssize_t queue_requests_show(struct request_queue *q, char *page)
 {
 	return queue_var_show(q->nr_requests, (page));
@@ -265,6 +317,18 @@ queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
 	return ret;
 }
 
+static struct queue_sysfs_entry queue_ignore_flush_entry = {
+	.attr = {.name = "ignore_flush", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_ignore_flush_show,
+	.store = queue_ignore_flush_store,
+};
+
+static struct queue_sysfs_entry queue_ignore_fua_entry = {
+	.attr = {.name = "ignore_fua", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_ignore_fua_show,
+	.store = queue_ignore_fua_store,
+};
+
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_requests_show,
@@ -380,6 +444,8 @@ static struct queue_sysfs_entry queue_random_entry = {
 };
 
 static struct attribute *default_attrs[] = {
+	&queue_ignore_flush_entry.attr,
+	&queue_ignore_fua_entry.attr,
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8a082a5..daa4e6b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -368,6 +368,7 @@ struct request_queue
 	 * for flush operations
 	 */
 	unsigned int		flush_flags;
+	unsigned int		hw_flush_flags;
 	unsigned int		flush_pending_idx:1;
 	unsigned int		flush_running_idx:1;
 	unsigned long		flush_pending_since;
