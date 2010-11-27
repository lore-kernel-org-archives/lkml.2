Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab0K0Kcx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:32:53 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34786 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752829Ab0K0K0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcFAO1p8Ex5Lcx2/2dsb2JhbACVC44Acr12hUcEimGFFA
Message-Id: <799862eb7c0ddb2b9c4bdb450035adb5f57b294f.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:56 +1100
Subject: [PATCH 26/46] fs: dcache reduce prune_one_dentry locking
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
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
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 23f6fed..4fa27b5 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -547,26 +547,29 @@ static void prune_one_dentry(struct dentry *dentry, struct dentry *parent)
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
-- 
1.7.1

