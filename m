Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab0FXDQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:48443 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab0FXDPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:46 -0400
Message-Id: <20100624030729.244753419@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:35 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 23/52] fs: dcache percpu nr_dentry
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=dcache-percpu-nr_dentry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nr_dentry stat is a globally touched cacheline and atomic operation
twice over the lifetime of a dentry. It is used for the benfit of userspace
only. We could make a per-cpu counter or something for it, but it is only
accessed via proc, so we could use slab stats.

XXX: must implement slab routines to return stats for a single cache, and
implement the proc handler.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/dcache.c            |    5 +----
 include/linux/dcache.h |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -105,7 +105,7 @@ static struct dcache_hash_bucket *dentry
 
 /* Statistics gathering. */
 struct dentry_stat_t dentry_stat = {
-	.nr_dentry = ATOMIC_INIT(0),
+	.nr_dentry = 0,
 	.age_limit = 45,
 };
 
@@ -146,7 +146,6 @@ static void d_callback(struct rcu_head *
  */
 static void d_free(struct dentry *dentry)
 {
-	atomic_dec(&dentry_stat.nr_dentry);
 	BUG_ON(dentry->d_count);
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
@@ -1249,8 +1248,6 @@ struct dentry *d_alloc(struct dentry * p
 		spin_unlock(&parent->d_lock);
 	}
 
-	atomic_inc(&dentry_stat.nr_dentry);
-
 	return dentry;
 }
 EXPORT_SYMBOL(d_alloc);
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -38,7 +38,7 @@ struct qstr {
 };
 
 struct dentry_stat_t {
-	atomic_t nr_dentry;
+	int nr_dentry;		/* unused */
 	int nr_unused;		/* protected by dcache_lru_lock */
 	int age_limit;          /* age in seconds */
 	int want_pages;         /* pages requested by system */


