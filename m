Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab0FXDXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:23:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:48498 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab0FXDQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:16:04 -0400
Message-Id: <20100624030727.325161715@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:23 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 11/52] fs: dcache scale nr_dentry
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-dcache-scale-nr_dentry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make dentry_stat_t.nr_dentry an atomic_t type, and move it from under
dcache_lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/dcache.c            |   20 +++++++++-----------
 include/linux/dcache.h |    4 ++--
 kernel/sysctl.c        |    6 ++++++
 3 files changed, 17 insertions(+), 13 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -88,6 +88,7 @@ static struct hlist_head *dentry_hashtab
 
 /* Statistics gathering. */
 struct dentry_stat_t dentry_stat = {
+	.nr_dentry = ATOMIC_INIT(0),
 	.age_limit = 45,
 };
 
@@ -106,11 +107,11 @@ static void d_callback(struct rcu_head *
 }
 
 /*
- * no dcache_lock, please.  The caller must decrement dentry_stat.nr_dentry
- * inside dcache_lock.
+ * no dcache_lock, please.
  */
 static void d_free(struct dentry *dentry)
 {
+	atomic_dec(&dentry_stat.nr_dentry);
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
 	/* if dentry was never inserted into hash, immediate free is OK */
@@ -217,7 +218,6 @@ static struct dentry *d_kill(struct dent
 	struct dentry *parent;
 
 	list_del(&dentry->d_u.d_child);
-	dentry_stat.nr_dentry--;	/* For d_free, below */
 	/*drops the locks, at that point nobody can reach this dentry */
 	dentry_iput(dentry);
 	if (IS_ROOT(dentry))
@@ -787,10 +787,7 @@ static void shrink_dcache_for_umount_sub
 				    struct dentry, d_u.d_child);
 	}
 out:
-	/* several dentries were freed, need to correct nr_dentry */
-	spin_lock(&dcache_lock);
-	dentry_stat.nr_dentry -= detached;
-	spin_unlock(&dcache_lock);
+	return;
 }
 
 /*
@@ -1047,11 +1044,12 @@ struct dentry *d_alloc(struct dentry * p
 		INIT_LIST_HEAD(&dentry->d_u.d_child);
 	}
 
-	spin_lock(&dcache_lock);
-	if (parent)
+	if (parent) {
+		spin_lock(&dcache_lock);
 		list_add(&dentry->d_u.d_child, &parent->d_subdirs);
-	dentry_stat.nr_dentry++;
-	spin_unlock(&dcache_lock);
+		spin_unlock(&dcache_lock);
+	}
+	atomic_inc(&dentry_stat.nr_dentry);
 
 	return dentry;
 }
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -37,8 +37,8 @@ struct qstr {
 };
 
 struct dentry_stat_t {
-	int nr_dentry;
-	int nr_unused;
+	atomic_t nr_dentry;
+	int nr_unused;		/* protected by dcache_lru_lock */
 	int age_limit;          /* age in seconds */
 	int want_pages;         /* pages requested by system */
 	int dummy[2];
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -1371,6 +1371,12 @@ static struct ctl_table fs_table[] = {
 		.extra2		= &sysctl_nr_open_max,
 	},
 	{
+		/*
+		 * dentry_stat has an atomic_t member, so this is a bit of
+		 * a hack, but it works for the moment, and I won't bother
+		 * changing it now because we'll probably want to change to
+		 * a more scalable counter anyway.
+		 */
 		.procname	= "dentry-state",
 		.data		= &dentry_stat,
 		.maxlen		= 6*sizeof(int),


