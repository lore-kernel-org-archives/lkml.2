Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0K0K1H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:27:07 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:6979 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323Ab0K0K1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:27:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcFAO1p8Ex5Lcx2/2dsb2JhbACVC44Acr12hUcEimGFFA
Message-Id: <219638b14eed01855f638628fd5d9d967d033a5b.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:55 +1100
Subject: [PATCH 25/46] fs: dcache reduce d_parent locking
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use RCU to simplify locking in dget_parent.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/dcache.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 9231748..23f6fed 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -406,24 +406,27 @@ struct dentry *dget_parent(struct dentry *dentry)
 	struct dentry *ret;
 
 repeat:
-	spin_lock(&dentry->d_lock);
+	/*
+	 * Don't need rcu_dereference because we re-check it was correct under
+	 * the lock.
+	 */
+	rcu_read_lock();
 	ret = dentry->d_parent;
-	if (!ret)
-		goto out;
-	if (dentry == ret) {
-		ret->d_count++;
-		goto out;
-	}
-	if (!spin_trylock(&ret->d_lock)) {
-		spin_unlock(&dentry->d_lock);
-		cpu_relax();
+	if (!ret) {
+		rcu_read_unlock();
+ 		goto out;
+ 	}
+	spin_lock(&ret->d_lock);
+	if (unlikely(ret != dentry->d_parent)) {
+		spin_unlock(&ret->d_lock);
+		rcu_read_unlock();
 		goto repeat;
 	}
+	rcu_read_unlock();
 	BUG_ON(!ret->d_count);
 	ret->d_count++;
 	spin_unlock(&ret->d_lock);
 out:
-	spin_unlock(&dentry->d_lock);
 	return ret;
 }
 EXPORT_SYMBOL(dget_parent);
-- 
1.7.1

