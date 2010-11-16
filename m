Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab0KPO0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:26:22 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:3958 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758535Ab0KPOXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:23:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogKAKMh4kx5Ldur/2dsb2JhbACUX4ECjH1yvmaFSwSKWIUQ
Message-Id: <20101116142029.816863760@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:17 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 17/28] fs: increase d_name lock coverage
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=fs-dcache-lock-d_name.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cover d_name with d_lock in more cases, where there may be concurrent
modification to it.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/dcache.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:42.000000000 +1100
@@ -1361,16 +1361,20 @@ static struct dentry *__d_instantiate_un
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
@@ -2298,7 +2302,9 @@ static int prepend_path(const struct pat
 		}
 		parent = dentry->d_parent;
 		prefetch(parent);
+		spin_lock(&dentry->d_lock);
 		error = prepend_name(buffer, buflen, &dentry->d_name);
+		spin_unlock(&dentry->d_lock);
 		if (!error)
 			error = prepend(buffer, buflen, "/", 1);
 		if (error)
@@ -2506,10 +2512,13 @@ static char *__dentry_path(struct dentry
 
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


