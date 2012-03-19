Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab2CSKtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:49:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab2CSKtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:49:42 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/12] GFS2: glock statistics gathering
Date: Mon, 19 Mar 2012 10:25:17 +0000
Message-Id: <1332152728-4027-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stats are divided into two sets: those relating to the
super block and those relating to an individual glock. The
super block stats are done on a per cpu basis in order to
try and reduce the overhead of gathering them. They are also
further divided by glock type.

In the case of both the super block and glock statistics,
the same information is gathered in each case. The super
block statistics are used to provide default values for
most of the glock statistics, so that newly created glocks
should have, as far as possible, a sensible starting point.

The statistics are divided into three pairs of mean and
variance, plus two counters. The mean/variance pairs are
smoothed exponential estimates and the algorithm used is
one which will be very familiar to those used to calculation
of round trip times in network code.

The three pairs of mean/variance measure the following
things:

 1. DLM lock time (non-blocking requests)
 2. DLM lock time (blocking requests)
 3. Inter-request time (again to the DLM)

A non-blocking request is one which will complete right
away, whatever the state of the DLM lock in question. That
currently means any requests when (a) the current state of
the lock is exclusive (b) the requested state is either null
or unlocked or (c) the "try lock" flag is set. A blocking
request covers all the other lock requests.

There are two counters. The first is there primarily to show
how many lock requests have been made, and thus how much data
has gone into the mean/variance calculations. The other counter
is counting queueing of holders at the top layer of the glock
code. Hopefully that number will be a lot larger than the number
of dlm lock requests issued.

So why gather these statistics? There are several reasons
we'd like to get a better idea of these timings:

1. To be able to better set the glock "min hold time"
2. To spot performance issues more easily
3. To improve the algorithm for selecting resource groups for
allocation (to base it on lock wait time, rather than blindly
using a "try lock")
Due to the smoothing action of the updates, a step change in
some input quantity being sampled will only fully be taken
into account after 8 samples (or 4 for the variance) and this
needs to be carefully considered when interpreting the
results.

Knowing both the time it takes a lock request to complete and
the average time between lock requests for a glock means we
can compute the total percentage of the time for which the
node is able to use a glock vs. time that the rest of the
cluster has its share. That will be very useful when setting
the lock min hold time.

The other point to remember is that all times are in
nanoseconds. Great care has been taken to ensure that we
measure exactly the quantities that we want, as accurately
as possible. There are always inaccuracies in any
measuring system, but I hope this is as accurate as we
can reasonably make it.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 351a3e7..dab2526 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -29,6 +29,7 @@
 #include <linux/rcupdate.h>
 #include <linux/rculist_bl.h>
 #include <linux/bit_spinlock.h>
+#include <linux/percpu.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -543,6 +544,11 @@ __acquires(&gl->gl_spin)
 		do_error(gl, 0); /* Fail queued try locks */
 	}
 	gl->gl_req = target;
+	set_bit(GLF_BLOCKING, &gl->gl_flags);
+	if ((gl->gl_req == LM_ST_UNLOCKED) ||
+	    (gl->gl_state == LM_ST_EXCLUSIVE) ||
+	    (lck_flags & (LM_FLAG_TRY|LM_FLAG_TRY_1CB)))
+		clear_bit(GLF_BLOCKING, &gl->gl_flags);
 	spin_unlock(&gl->gl_spin);
 	if (glops->go_xmote_th)
 		glops->go_xmote_th(gl);
@@ -744,6 +750,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 		return -ENOMEM;
 
 	atomic_inc(&sdp->sd_glock_disposal);
+	gl->gl_sbd = sdp;
 	gl->gl_flags = 0;
 	gl->gl_name = name;
 	atomic_set(&gl->gl_ref, 1);
@@ -752,12 +759,17 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	gl->gl_demote_state = LM_ST_EXCLUSIVE;
 	gl->gl_hash = hash;
 	gl->gl_ops = glops;
-	snprintf(gl->gl_strname, GDLM_STRNAME_BYTES, "%8x%16llx", name.ln_type, (unsigned long long)number);
+	gl->gl_dstamp = ktime_set(0, 0);
+	preempt_disable();
+	/* We use the global stats to estimate the initial per-glock stats */
+	gl->gl_stats = this_cpu_ptr(sdp->sd_lkstats)->lkstats[glops->go_type];
+	preempt_enable();
+	gl->gl_stats.stats[GFS2_LKS_DCOUNT] = 0;
+	gl->gl_stats.stats[GFS2_LKS_QCOUNT] = 0;
 	memset(&gl->gl_lksb, 0, sizeof(struct dlm_lksb));
 	gl->gl_lksb.sb_lvbptr = gl->gl_lvb;
 	gl->gl_tchange = jiffies;
 	gl->gl_object = NULL;
-	gl->gl_sbd = sdp;
 	gl->gl_hold_time = GL_GLOCK_DFT_HOLD;
 	INIT_DELAYED_WORK(&gl->gl_work, glock_work_func);
 	INIT_WORK(&gl->gl_delete, delete_work_func);
@@ -999,6 +1011,8 @@ fail:
 	}
 	set_bit(GLF_QUEUED, &gl->gl_flags);
 	trace_gfs2_glock_queue(gh, 1);
+	gfs2_glstats_inc(gl, GFS2_LKS_QCOUNT);
+	gfs2_sbstats_inc(gl, GFS2_LKS_QCOUNT);
 	if (likely(insert_pt == NULL)) {
 		list_add_tail(&gh->gh_list, &gl->gl_holders);
 		if (unlikely(gh->gh_flags & LM_FLAG_PRIORITY))
@@ -1658,6 +1672,8 @@ static const char *gflags2str(char *buf, const struct gfs2_glock *gl)
 		*p++ = 'L';
 	if (gl->gl_object)
 		*p++ = 'o';
+	if (test_bit(GLF_BLOCKING, gflags))
+		*p++ = 'b';
 	*p = 0;
 	return buf;
 }
@@ -1714,8 +1730,78 @@ out:
 	return error;
 }
 
+static int gfs2_glstats_seq_show(struct seq_file *seq, void *iter_ptr)
+{
+	struct gfs2_glock *gl = iter_ptr;
+
+	seq_printf(seq, "G: n:%u/%llx rtt:%lld/%lld rttb:%lld/%lld irt:%lld/%lld dcnt: %lld qcnt: %lld\n",
+		   gl->gl_name.ln_type,
+		   (unsigned long long)gl->gl_name.ln_number,
+		   (long long)gl->gl_stats.stats[GFS2_LKS_SRTT],
+		   (long long)gl->gl_stats.stats[GFS2_LKS_SRTTVAR],
+		   (long long)gl->gl_stats.stats[GFS2_LKS_SRTTB],
+		   (long long)gl->gl_stats.stats[GFS2_LKS_SRTTVARB],
+		   (long long)gl->gl_stats.stats[GFS2_LKS_SIRT],
+		   (long long)gl->gl_stats.stats[GFS2_LKS_SIRTVAR],
+		   (long long)gl->gl_stats.stats[GFS2_LKS_DCOUNT],
+		   (long long)gl->gl_stats.stats[GFS2_LKS_QCOUNT]);
+	return 0;
+}
+
+static const char *gfs2_gltype[] = {
+	"type",
+	"reserved",
+	"nondisk",
+	"inode",
+	"rgrp",
+	"meta",
+	"iopen",
+	"flock",
+	"plock",
+	"quota",
+	"journal",
+};
+
+static const char *gfs2_stype[] = {
+	[GFS2_LKS_SRTT]		= "srtt",
+	[GFS2_LKS_SRTTVAR]	= "srttvar",
+	[GFS2_LKS_SRTTB]	= "srttb",
+	[GFS2_LKS_SRTTVARB]	= "srttvarb",
+	[GFS2_LKS_SIRT]		= "sirt",
+	[GFS2_LKS_SIRTVAR]	= "sirtvar",
+	[GFS2_LKS_DCOUNT]	= "dlm",
+	[GFS2_LKS_QCOUNT]	= "queue",
+};
+
+#define GFS2_NR_SBSTATS (ARRAY_SIZE(gfs2_gltype) * ARRAY_SIZE(gfs2_stype))
+
+static int gfs2_sbstats_seq_show(struct seq_file *seq, void *iter_ptr)
+{
+	struct gfs2_glock_iter *gi = seq->private;
+	struct gfs2_sbd *sdp = gi->sdp;
+	unsigned index = gi->hash >> 3;
+	unsigned subindex = gi->hash & 0x07;
+	s64 value;
+	int i;
+
+	if (index == 0 && subindex != 0)
+		return 0;
 
+	seq_printf(seq, "%-10s %8s:", gfs2_gltype[index],
+		   (index == 0) ? "cpu": gfs2_stype[subindex]);
 
+	for_each_possible_cpu(i) {
+                const struct gfs2_pcpu_lkstats *lkstats = per_cpu_ptr(sdp->sd_lkstats, i);
+		if (index == 0) {
+			value = i;
+		} else {
+			value = lkstats->lkstats[index - 1].stats[subindex];
+		}
+		seq_printf(seq, " %15lld", (long long)value);
+	}
+	seq_putc(seq, '\n');
+	return 0;
+}
 
 int __init gfs2_glock_init(void)
 {
@@ -1828,6 +1914,35 @@ static int gfs2_glock_seq_show(struct seq_file *seq, void *iter_ptr)
 	return dump_glock(seq, iter_ptr);
 }
 
+static void *gfs2_sbstats_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct gfs2_glock_iter *gi = seq->private;
+
+	gi->hash = *pos;
+	if (*pos >= GFS2_NR_SBSTATS)
+		return NULL;
+	preempt_disable();
+	return SEQ_START_TOKEN;
+}
+
+static void *gfs2_sbstats_seq_next(struct seq_file *seq, void *iter_ptr,
+				   loff_t *pos)
+{
+	struct gfs2_glock_iter *gi = seq->private;
+	(*pos)++;
+	gi->hash++;
+	if (gi->hash >= GFS2_NR_SBSTATS) {
+		preempt_enable();
+		return NULL;
+	}
+	return SEQ_START_TOKEN;
+}
+
+static void gfs2_sbstats_seq_stop(struct seq_file *seq, void *iter_ptr)
+{
+	preempt_enable();
+}
+
 static const struct seq_operations gfs2_glock_seq_ops = {
 	.start = gfs2_glock_seq_start,
 	.next  = gfs2_glock_seq_next,
@@ -1835,7 +1950,21 @@ static const struct seq_operations gfs2_glock_seq_ops = {
 	.show  = gfs2_glock_seq_show,
 };
 
-static int gfs2_debugfs_open(struct inode *inode, struct file *file)
+static const struct seq_operations gfs2_glstats_seq_ops = {
+	.start = gfs2_glock_seq_start,
+	.next  = gfs2_glock_seq_next,
+	.stop  = gfs2_glock_seq_stop,
+	.show  = gfs2_glstats_seq_show,
+};
+
+static const struct seq_operations gfs2_sbstats_seq_ops = {
+	.start = gfs2_sbstats_seq_start,
+	.next  = gfs2_sbstats_seq_next,
+	.stop  = gfs2_sbstats_seq_stop,
+	.show  = gfs2_sbstats_seq_show,
+};
+
+static int gfs2_glocks_open(struct inode *inode, struct file *file)
 {
 	int ret = seq_open_private(file, &gfs2_glock_seq_ops,
 				   sizeof(struct gfs2_glock_iter));
@@ -1847,9 +1976,49 @@ static int gfs2_debugfs_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-static const struct file_operations gfs2_debug_fops = {
+static int gfs2_glstats_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open_private(file, &gfs2_glstats_seq_ops,
+				   sizeof(struct gfs2_glock_iter));
+	if (ret == 0) {
+		struct seq_file *seq = file->private_data;
+		struct gfs2_glock_iter *gi = seq->private;
+		gi->sdp = inode->i_private;
+	}
+	return ret;
+}
+
+static int gfs2_sbstats_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open_private(file, &gfs2_sbstats_seq_ops,
+				   sizeof(struct gfs2_glock_iter));
+	if (ret == 0) {
+		struct seq_file *seq = file->private_data;
+		struct gfs2_glock_iter *gi = seq->private;
+		gi->sdp = inode->i_private;
+	}
+	return ret;
+}
+
+static const struct file_operations gfs2_glocks_fops = {
+	.owner   = THIS_MODULE,
+	.open    = gfs2_glocks_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release_private,
+};
+
+static const struct file_operations gfs2_glstats_fops = {
 	.owner   = THIS_MODULE,
-	.open    = gfs2_debugfs_open,
+	.open    = gfs2_glstats_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release_private,
+};
+
+static const struct file_operations gfs2_sbstats_fops = {
+	.owner   = THIS_MODULE,
+	.open	 = gfs2_sbstats_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
 	.release = seq_release_private,
@@ -1863,20 +2032,45 @@ int gfs2_create_debugfs_file(struct gfs2_sbd *sdp)
 	sdp->debugfs_dentry_glocks = debugfs_create_file("glocks",
 							 S_IFREG | S_IRUGO,
 							 sdp->debugfs_dir, sdp,
-							 &gfs2_debug_fops);
+							 &gfs2_glocks_fops);
 	if (!sdp->debugfs_dentry_glocks)
-		return -ENOMEM;
+		goto fail;
+
+	sdp->debugfs_dentry_glstats = debugfs_create_file("glstats",
+							S_IFREG | S_IRUGO,
+							sdp->debugfs_dir, sdp,
+							&gfs2_glstats_fops);
+	if (!sdp->debugfs_dentry_glstats)
+		goto fail;
+
+	sdp->debugfs_dentry_sbstats = debugfs_create_file("sbstats",
+							S_IFREG | S_IRUGO,
+							sdp->debugfs_dir, sdp,
+							&gfs2_sbstats_fops);
+	if (!sdp->debugfs_dentry_sbstats)
+		goto fail;
 
 	return 0;
+fail:
+	gfs2_delete_debugfs_file(sdp);
+	return -ENOMEM;
 }
 
 void gfs2_delete_debugfs_file(struct gfs2_sbd *sdp)
 {
-	if (sdp && sdp->debugfs_dir) {
+	if (sdp->debugfs_dir) {
 		if (sdp->debugfs_dentry_glocks) {
 			debugfs_remove(sdp->debugfs_dentry_glocks);
 			sdp->debugfs_dentry_glocks = NULL;
 		}
+		if (sdp->debugfs_dentry_glstats) {
+			debugfs_remove(sdp->debugfs_dentry_glstats);
+			sdp->debugfs_dentry_glstats = NULL;
+		}
+		if (sdp->debugfs_dentry_sbstats) {
+			debugfs_remove(sdp->debugfs_dentry_sbstats);
+			sdp->debugfs_dentry_sbstats = NULL;
+		}
 		debugfs_remove(sdp->debugfs_dir);
 		sdp->debugfs_dir = NULL;
 	}
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 97742a7..4d546df 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -19,6 +19,8 @@
 #include <linux/rculist_bl.h>
 #include <linux/completion.h>
 #include <linux/rbtree.h>
+#include <linux/ktime.h>
+#include <linux/percpu.h>
 
 #define DIO_WAIT	0x00000010
 #define DIO_METADATA	0x00000020
@@ -205,6 +207,22 @@ struct gfs2_glock_operations {
 };
 
 enum {
+	GFS2_LKS_SRTT = 0,	/* Non blocking smoothed round trip time */
+	GFS2_LKS_SRTTVAR = 1,	/* Non blocking smoothed variance */
+	GFS2_LKS_SRTTB = 2,	/* Blocking smoothed round trip time */
+	GFS2_LKS_SRTTVARB = 3,	/* Blocking smoothed variance */
+	GFS2_LKS_SIRT = 4,	/* Smoothed Inter-request time */
+	GFS2_LKS_SIRTVAR = 5,	/* Smoothed Inter-request variance */
+	GFS2_LKS_DCOUNT = 6,	/* Count of dlm requests */
+	GFS2_LKS_QCOUNT = 7,	/* Count of gfs2_holder queues */
+	GFS2_NR_LKSTATS
+};
+
+struct gfs2_lkstats {
+	s64 stats[GFS2_NR_LKSTATS];
+};
+
+enum {
 	/* States */
 	HIF_HOLDER		= 6,  /* Set for gh that "holds" the glock */
 	HIF_FIRST		= 7,
@@ -238,10 +256,12 @@ enum {
 	GLF_QUEUED			= 12,
 	GLF_LRU				= 13,
 	GLF_OBJECT			= 14, /* Used only for tracing */
+	GLF_BLOCKING			= 15,
 };
 
 struct gfs2_glock {
 	struct hlist_bl_node gl_list;
+	struct gfs2_sbd *gl_sbd;
 	unsigned long gl_flags;		/* GLF_... */
 	struct lm_lockname gl_name;
 	atomic_t gl_ref;
@@ -261,16 +281,14 @@ struct gfs2_glock {
 	struct list_head gl_holders;
 
 	const struct gfs2_glock_operations *gl_ops;
-	char gl_strname[GDLM_STRNAME_BYTES];
+	ktime_t gl_dstamp;
+	struct gfs2_lkstats gl_stats;
 	struct dlm_lksb gl_lksb;
 	char gl_lvb[32];
 	unsigned long gl_tchange;
 	void *gl_object;
 
 	struct list_head gl_lru;
-
-	struct gfs2_sbd *gl_sbd;
-
 	struct list_head gl_ail_list;
 	atomic_t gl_ail_count;
 	atomic_t gl_revokes;
@@ -560,8 +578,14 @@ struct lm_lockstruct {
 	uint32_t *ls_recover_result; /* result of last jid recovery */
 };
 
+struct gfs2_pcpu_lkstats {
+	/* One struct for each glock type */
+	struct gfs2_lkstats lkstats[10];
+};
+
 struct gfs2_sbd {
 	struct super_block *sd_vfs;
+	struct gfs2_pcpu_lkstats __percpu *sd_lkstats;
 	struct kobject sd_kobj;
 	unsigned long sd_flags;	/* SDF_... */
 	struct gfs2_sb_host sd_sb;
@@ -725,8 +749,23 @@ struct gfs2_sbd {
 
 	unsigned long sd_last_warning;
 	struct dentry *debugfs_dir;    /* debugfs directory */
-	struct dentry *debugfs_dentry_glocks; /* for debugfs */
+	struct dentry *debugfs_dentry_glocks;
+	struct dentry *debugfs_dentry_glstats;
+	struct dentry *debugfs_dentry_sbstats;
 };
 
+static inline void gfs2_glstats_inc(struct gfs2_glock *gl, int which)
+{
+	gl->gl_stats.stats[which]++;
+}
+
+static inline void gfs2_sbstats_inc(const struct gfs2_glock *gl, int which)
+{
+	const struct gfs2_sbd *sdp = gl->gl_sbd;
+	preempt_disable();
+	this_cpu_ptr(sdp->sd_lkstats)->lkstats[gl->gl_name.ln_type].stats[which]++;
+	preempt_enable();
+}
+
 #endif /* __INCORE_DOT_H__ */
 
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 8944d1e..f8411bd 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -18,14 +18,106 @@
 #include "glock.h"
 #include "util.h"
 #include "sys.h"
+#include "trace_gfs2.h"
 
 extern struct workqueue_struct *gfs2_control_wq;
 
+/**
+ * gfs2_update_stats - Update time based stats
+ * @mv: Pointer to mean/variance structure to update
+ * @sample: New data to include
+ *
+ * @delta is the difference between the current rtt sample and the
+ * running average srtt. We add 1/8 of that to the srtt in order to
+ * update the current srtt estimate. The varience estimate is a bit
+ * more complicated. We subtract the abs value of the @delta from
+ * the current variance estimate and add 1/4 of that to the running
+ * total.
+ *
+ * Note that the index points at the array entry containing the smoothed
+ * mean value, and the variance is always in the following entry
+ *
+ * Reference: TCP/IP Illustrated, vol 2, p. 831,832
+ * All times are in units of integer nanoseconds. Unlike the TCP/IP case,
+ * they are not scaled fixed point.
+ */
+
+static inline void gfs2_update_stats(struct gfs2_lkstats *s, unsigned index,
+				     s64 sample)
+{
+	s64 delta = sample - s->stats[index];
+	s->stats[index] += (delta >> 3);
+	index++;
+	s->stats[index] += ((abs64(delta) - s->stats[index]) >> 2);
+}
+
+/**
+ * gfs2_update_reply_times - Update locking statistics
+ * @gl: The glock to update
+ *
+ * This assumes that gl->gl_dstamp has been set earlier.
+ *
+ * The rtt (lock round trip time) is an estimate of the time
+ * taken to perform a dlm lock request. We update it on each
+ * reply from the dlm.
+ *
+ * The blocking flag is set on the glock for all dlm requests
+ * which may potentially block due to lock requests from other nodes.
+ * DLM requests where the current lock state is exclusive, the
+ * requested state is null (or unlocked) or where the TRY or
+ * TRY_1CB flags are set are classified as non-blocking. All
+ * other DLM requests are counted as (potentially) blocking.
+ */
+static inline void gfs2_update_reply_times(struct gfs2_glock *gl)
+{
+	struct gfs2_pcpu_lkstats *lks;
+	const unsigned gltype = gl->gl_name.ln_type;
+	unsigned index = test_bit(GLF_BLOCKING, &gl->gl_flags) ?
+			 GFS2_LKS_SRTTB : GFS2_LKS_SRTT;
+	s64 rtt;
+
+	preempt_disable();
+	rtt = ktime_to_ns(ktime_sub(ktime_get_real(), gl->gl_dstamp));
+	lks = this_cpu_ptr(gl->gl_sbd->sd_lkstats);
+	gfs2_update_stats(&gl->gl_stats, index, rtt);		/* Local */
+	gfs2_update_stats(&lks->lkstats[gltype], index, rtt);	/* Global */
+	preempt_enable();
+
+	trace_gfs2_glock_lock_time(gl, rtt);
+}
+
+/**
+ * gfs2_update_request_times - Update locking statistics
+ * @gl: The glock to update
+ *
+ * The irt (lock inter-request times) measures the average time
+ * between requests to the dlm. It is updated immediately before
+ * each dlm call.
+ */
+
+static inline void gfs2_update_request_times(struct gfs2_glock *gl)
+{
+	struct gfs2_pcpu_lkstats *lks;
+	const unsigned gltype = gl->gl_name.ln_type;
+	ktime_t dstamp;
+	s64 irt;
+
+	preempt_disable();
+	dstamp = gl->gl_dstamp;
+	gl->gl_dstamp = ktime_get_real();
+	irt = ktime_to_ns(ktime_sub(gl->gl_dstamp, dstamp));
+	lks = this_cpu_ptr(gl->gl_sbd->sd_lkstats);
+	gfs2_update_stats(&gl->gl_stats, GFS2_LKS_SIRT, irt);		/* Local */
+	gfs2_update_stats(&lks->lkstats[gltype], GFS2_LKS_SIRT, irt);	/* Global */
+	preempt_enable();
+}
+ 
 static void gdlm_ast(void *arg)
 {
 	struct gfs2_glock *gl = arg;
 	unsigned ret = gl->gl_state;
 
+	gfs2_update_reply_times(gl);
 	BUG_ON(gl->gl_lksb.sb_flags & DLM_SBF_DEMOTED);
 
 	if (gl->gl_lksb.sb_flags & DLM_SBF_VALNOTVALID)
@@ -111,7 +203,7 @@ static int make_mode(const unsigned int lmstate)
 static u32 make_flags(const u32 lkid, const unsigned int gfs_flags,
 		      const int req)
 {
-	u32 lkf = 0;
+	u32 lkf = DLM_LKF_VALBLK;
 
 	if (gfs_flags & LM_FLAG_TRY)
 		lkf |= DLM_LKF_NOQUEUE;
@@ -138,26 +230,43 @@ static u32 make_flags(const u32 lkid, const unsigned int gfs_flags,
 	if (lkid != 0) 
 		lkf |= DLM_LKF_CONVERT;
 
-	lkf |= DLM_LKF_VALBLK;
-
 	return lkf;
 }
 
+static void gfs2_reverse_hex(char *c, u64 value)
+{
+	while (value) {
+		*c-- = hex_asc[value & 0x0f];
+		value >>= 4;
+	}
+}
+
 static int gdlm_lock(struct gfs2_glock *gl, unsigned int req_state,
 		     unsigned int flags)
 {
 	struct lm_lockstruct *ls = &gl->gl_sbd->sd_lockstruct;
 	int req;
 	u32 lkf;
+	char strname[GDLM_STRNAME_BYTES] = "";
 
 	req = make_mode(req_state);
 	lkf = make_flags(gl->gl_lksb.sb_lkid, flags, req);
-
+	gfs2_glstats_inc(gl, GFS2_LKS_DCOUNT);
+	gfs2_sbstats_inc(gl, GFS2_LKS_DCOUNT);
+	if (gl->gl_lksb.sb_lkid) {
+		gfs2_update_request_times(gl);
+	} else {
+		memset(strname, ' ', GDLM_STRNAME_BYTES - 1);
+		strname[GDLM_STRNAME_BYTES - 1] = '\0';
+		gfs2_reverse_hex(strname + 7, gl->gl_name.ln_type);
+		gfs2_reverse_hex(strname + 23, gl->gl_name.ln_number);
+		gl->gl_dstamp = ktime_get_real();
+	}
 	/*
 	 * Submit the actual lock request.
 	 */
 
-	return dlm_lock(ls->ls_dlm, req, &gl->gl_lksb, lkf, gl->gl_strname,
+	return dlm_lock(ls->ls_dlm, req, &gl->gl_lksb, lkf, strname,
 			GDLM_STRNAME_BYTES - 1, 0, gdlm_ast, gl, gdlm_bast);
 }
 
@@ -172,6 +281,10 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 		return;
 	}
 
+	clear_bit(GLF_BLOCKING, &gl->gl_flags);
+	gfs2_glstats_inc(gl, GFS2_LKS_DCOUNT);
+	gfs2_sbstats_inc(gl, GFS2_LKS_DCOUNT);
+	gfs2_update_request_times(gl);
 	error = dlm_unlock(ls->ls_dlm, gl->gl_lksb.sb_lkid, DLM_LKF_VALBLK,
 			   NULL, gl);
 	if (error) {
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 24f609c..a55baa7 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -68,6 +68,12 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 
 	sb->s_fs_info = sdp;
 	sdp->sd_vfs = sb;
+	sdp->sd_lkstats = alloc_percpu(struct gfs2_pcpu_lkstats);
+	if (!sdp->sd_lkstats) {
+		kfree(sdp);
+		return NULL;
+	}
+
 	set_bit(SDF_NOJOURNALID, &sdp->sd_flags);
 	gfs2_tune_init(&sdp->sd_tune);
 
@@ -1221,6 +1227,7 @@ fail_sys:
 	gfs2_sys_fs_del(sdp);
 fail:
 	gfs2_delete_debugfs_file(sdp);
+	free_percpu(sdp->sd_lkstats);
 	kfree(sdp);
 	sb->s_fs_info = NULL;
 	return error;
@@ -1393,6 +1400,7 @@ static void gfs2_kill_sb(struct super_block *sb)
 	shrink_dcache_sb(sb);
 	kill_block_super(sb);
 	gfs2_delete_debugfs_file(sdp);
+	free_percpu(sdp->sd_lkstats);
 	kfree(sdp);
 }
 
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index 5d07609..dfa89cd 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -11,6 +11,7 @@
 #include <linux/dlmconstants.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/writeback.h>
+#include <linux/ktime.h>
 #include "incore.h"
 #include "glock.h"
 
@@ -43,7 +44,8 @@
 	{(1UL << GLF_FROZEN),			"F" },		\
 	{(1UL << GLF_QUEUED),			"q" },		\
 	{(1UL << GLF_LRU),			"L" },		\
-	{(1UL << GLF_OBJECT),			"o" })
+	{(1UL << GLF_OBJECT),			"o" },		\
+	{(1UL << GLF_BLOCKING),			"b" })
 
 #ifndef NUMPTY
 #define NUMPTY
@@ -236,6 +238,62 @@ TRACE_EVENT(gfs2_glock_queue,
 		  glock_trace_name(__entry->state))
 );
 
+/* DLM sends a reply to GFS2 */
+TRACE_EVENT(gfs2_glock_lock_time,
+
+	TP_PROTO(const struct gfs2_glock *gl, s64 tdiff),
+
+	TP_ARGS(gl, tdiff),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev		)
+		__field(	u64,	glnum		)
+		__field(	u32,	gltype		)
+		__field(	int,	status		)
+		__field(	char,	flags		)
+		__field(	s64,	tdiff		)
+		__field(	s64,	srtt		)
+		__field(	s64,	srttvar		)
+		__field(	s64,	srttb		)
+		__field(	s64,	srttvarb	)
+		__field(	s64,	sirt		)
+		__field(	s64,	sirtvar		)
+		__field(	s64,	dcount		)
+		__field(	s64,	qcount		)
+	),
+
+	TP_fast_assign(
+		__entry->dev            = gl->gl_sbd->sd_vfs->s_dev;
+		__entry->glnum          = gl->gl_name.ln_number;
+		__entry->gltype         = gl->gl_name.ln_type;
+		__entry->status		= gl->gl_lksb.sb_status;
+		__entry->flags		= gl->gl_lksb.sb_flags;
+		__entry->tdiff		= tdiff;
+		__entry->srtt		= gl->gl_stats.stats[GFS2_LKS_SRTT];
+		__entry->srttvar	= gl->gl_stats.stats[GFS2_LKS_SRTTVAR];
+		__entry->srttb		= gl->gl_stats.stats[GFS2_LKS_SRTTB];
+		__entry->srttvarb	= gl->gl_stats.stats[GFS2_LKS_SRTTVARB];
+		__entry->sirt		= gl->gl_stats.stats[GFS2_LKS_SIRT];
+		__entry->sirtvar	= gl->gl_stats.stats[GFS2_LKS_SIRTVAR];
+		__entry->dcount		= gl->gl_stats.stats[GFS2_LKS_DCOUNT];
+		__entry->qcount		= gl->gl_stats.stats[GFS2_LKS_QCOUNT];
+	),
+
+	TP_printk("%u,%u glock %d:%lld status:%d flags:%02x tdiff:%lld srtt:%lld/%lld srttb:%lld/%lld sirt:%lld/%lld dcnt:%lld qcnt:%lld",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->gltype,
+		  (unsigned long long)__entry->glnum,
+		  __entry->status, __entry->flags,
+		  (long long)__entry->tdiff,
+		  (long long)__entry->srtt,
+		  (long long)__entry->srttvar,
+		  (long long)__entry->srttb,
+		  (long long)__entry->srttvarb,
+		  (long long)__entry->sirt,
+		  (long long)__entry->sirtvar,
+		  (long long)__entry->dcount,
+		  (long long)__entry->qcount)
+);
+
 /* Section 2 - Log/journal
  *
  * Objectives:
-- 
1.7.4

