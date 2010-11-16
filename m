Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295Ab0KPO0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:26:12 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:2280 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758641Ab0KPOYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:24:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogKAKMh4kx5Ldur/2dsb2JhbACUX4ECjH1yvmaFSwSKWIUQ
Message-Id: <20101116142030.612454500@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:25 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 25/28] fs: dcache reduce prune_one_dentry locking
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=dcache-prune_one_dentry-less-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prune_one_dentry can avoid quite a bit of locking in the common case where
ancestors have an elevated refcount. Alternatively, we could have gone the
other way and made fewer trylocks in the case where d_count goes to zero, but
is probably less common.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/dcache.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:52:38.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:38.000000000 +1100
@@ -547,26 +547,29 @@ static void prune_one_dentry(struct dent
 	 * Prune ancestors.
 	 */
 	while (dentry) {
-		spin_lock(&dcache_inode_lock);
-again:
+relock:
 		spin_lock(&dentry->d_lock);
+		if (dentry->d_count > 1) {
+			dentry->d_count--;
+			spin_unlock(&dentry->d_lock);
+	 		return;
+	 	}
+		if (!spin_trylock(&dcache_inode_lock)) {
+relock2:
+			spin_unlock(&dentry->d_lock);
+			cpu_relax();
+			goto relock;
+		}
+
 		if (IS_ROOT(dentry))
 			parent = NULL;
 		else
 			parent = dentry->d_parent;
 		if (parent && !spin_trylock(&parent->d_lock)) {
-			spin_unlock(&dentry->d_lock);
-			goto again;
-		}
-		dentry->d_count--;
-		if (dentry->d_count) {
-			if (parent)
-				spin_unlock(&parent->d_lock);
-			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_inode_lock);
-			return;
+			goto relock2;
 		}
-
+		dentry->d_count--;
 		dentry_lru_del(dentry);
 		__d_drop(dentry);
 		dentry = d_kill(dentry, parent);


