Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0K0Kfz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:35:55 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34780 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393Ab0K0KZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:25:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcFAO1p8Ex5Lcx2/2dsb2JhbACVC44Acr12hUcEimGFFA
Message-Id: <2d1d8ffc4acea8b6c4e5b58bb1653b3f0e7071e2.1290852958.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@suse.de>
Date: Sat, 27 Nov 2010 20:56:03 +1100
Subject: [PATCH 01/46] Revert "fs: use RCU read side protection in d_validate"
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 3825bdb7ed920845961f32f364454bee5f469abb.

Patch is broken, you can't dget() without holding any locks!

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/dcache.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 23702a9..cc2b938 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1491,26 +1491,33 @@ out:
  * This is used by ncpfs in its readdir implementation.
  * Zero is returned in the dentry is invalid.
  */
-int d_validate(struct dentry *dentry, struct dentry *parent)
+ 
+int d_validate(struct dentry *dentry, struct dentry *dparent)
 {
-	struct hlist_head *head = d_hash(parent, dentry->d_name.hash);
-	struct hlist_node *node;
-	struct dentry *d;
+	struct hlist_head *base;
+	struct hlist_node *lhp;
 
 	/* Check whether the ptr might be valid at all.. */
 	if (!kmem_ptr_validate(dentry_cache, dentry))
-		return 0;
-	if (dentry->d_parent != parent)
-		return 0;
+		goto out;
 
-	rcu_read_lock();
-	hlist_for_each_entry_rcu(d, node, head, d_hash) {
-		if (d == dentry) {
-			dget(dentry);
+	if (dentry->d_parent != dparent)
+		goto out;
+
+	spin_lock(&dcache_lock);
+	base = d_hash(dparent, dentry->d_name.hash);
+	hlist_for_each(lhp,base) { 
+		/* hlist_for_each_entry_rcu() not required for d_hash list
+		 * as it is parsed under dcache_lock
+		 */
+		if (dentry == hlist_entry(lhp, struct dentry, d_hash)) {
+			__dget_locked(dentry);
+			spin_unlock(&dcache_lock);
 			return 1;
 		}
 	}
-	rcu_read_unlock();
+	spin_unlock(&dcache_lock);
+out:
 	return 0;
 }
 EXPORT_SYMBOL(d_validate);
-- 
1.7.1

