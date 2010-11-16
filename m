Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306Ab0KPOYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:24:03 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32788 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758625Ab0KPOX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:23:59 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogKAKMh4kx5Ldur/2dsb2JhbACUX4ECjH1yvmaFSwSKWIUQ
Message-Id: <20101116142030.517382183@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:24 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 24/28] fs: dcache reduce d_parent locking
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=fs-dget_parent-opt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use RCU to simplify locking in dget_parent.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/dcache.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:52:38.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:38.000000000 +1100
@@ -406,24 +406,27 @@ struct dentry *dget_parent(struct dentry
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


