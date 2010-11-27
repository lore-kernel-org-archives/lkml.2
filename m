Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0K0K1C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:27:02 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:26161 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139Ab0K0K0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcFAO1p8Ex5Lcx2/2dsb2JhbACVC44Acr12hUcEimGFFA
Message-Id: <45b8bcdbee5f379c471c819b3149b9d0df371113.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:48 +1100
Subject: [PATCH 18/46] fs: increase d_name lock coverage
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cover d_name with d_lock in more cases, where there may be concurrent
modification to it.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/dcache.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 35420f7..7d0733b 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1361,16 +1361,20 @@ static struct dentry *__d_instantiate_unique(struct dentry *entry,
 	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
 		struct qstr *qstr = &alias->d_name;
 
+		spin_lock(&alias->d_lock);
 		if (qstr->hash != hash)
-			continue;
+			goto next;
 		if (alias->d_parent != entry->d_parent)
-			continue;
+			goto next;
 		if (qstr->len != len)
-			continue;
+			goto next;
 		if (memcmp(qstr->name, name, len))
-			continue;
-		dget_locked(alias);
+			goto next;
+		dget_locked_dlock(alias);
+		spin_unlock(&alias->d_lock);
 		return alias;
+next:
+		spin_unlock(&alias->d_lock);
 	}
 
 	__d_instantiate(entry, inode);
@@ -2298,7 +2302,9 @@ static int prepend_path(const struct path *path, struct path *root,
 		}
 		parent = dentry->d_parent;
 		prefetch(parent);
+		spin_lock(&dentry->d_lock);
 		error = prepend_name(buffer, buflen, &dentry->d_name);
+		spin_unlock(&dentry->d_lock);
 		if (!error)
 			error = prepend(buffer, buflen, "/", 1);
 		if (error)
@@ -2506,10 +2512,13 @@ static char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
 
 	while (!IS_ROOT(dentry)) {
 		struct dentry *parent = dentry->d_parent;
+		int error;
 
 		prefetch(parent);
-		if ((prepend_name(&end, &buflen, &dentry->d_name) != 0) ||
-		    (prepend(&end, &buflen, "/", 1) != 0))
+		spin_lock(&dentry->d_lock);
+		error = prepend_name(&end, &buflen, &dentry->d_name);
+		spin_unlock(&dentry->d_lock);
+		if (error != 0 || prepend(&end, &buflen, "/", 1) != 0)
 			goto Elong;
 
 		retval = end;
-- 
1.7.1

