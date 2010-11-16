Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab0KPO1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:27:40 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:42892 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933273Ab0KPO1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:27:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQJAKMh4kx5Ldur/2dsb2JhbACVYYx9cr5mgnWCVgSKWA
Message-Id: <20101116142030.019717994@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:19 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 19/28] fs: dcache avoid starvation in dcache multi-step operations
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=dcache-multi-step-nostarve.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Long lived dcache "multi-step" operations which retry on rename seq can
be starved with a lot of rename activity. If they fail after the 1st pass,
take the rename_lock for writing to avoid further starvation.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/dcache.c |   56 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 14 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:40.000000000 +1100
@@ -937,10 +937,11 @@ int have_submounts(struct dentry *parent
 	struct dentry *this_parent;
 	struct list_head *next;
 	unsigned seq;
+	int locked = 0;
 
-rename_retry:
-	this_parent = parent;
 	seq = read_seqbegin(&rename_lock);
+again:
+	this_parent = parent;
 
 	if (d_mountpoint(parent))
 		goto positive;
@@ -985,7 +986,7 @@ int have_submounts(struct dentry *parent
 		/* might go back up the wrong parent if we have had a rename
 		 * or deletion */
 		if (this_parent != child->d_parent ||
-				read_seqretry(&rename_lock, seq)) {
+			 (!locked && read_seqretry(&rename_lock, seq))) {
 			spin_unlock(&this_parent->d_lock);
 			rcu_read_unlock();
 			goto rename_retry;
@@ -995,13 +996,22 @@ int have_submounts(struct dentry *parent
 		goto resume;
 	}
 	spin_unlock(&this_parent->d_lock);
-	if (read_seqretry(&rename_lock, seq))
+	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
+	if (locked)
+		write_sequnlock(&rename_lock);
 	return 0; /* No mount points found in tree */
 positive:
-	if (read_seqretry(&rename_lock, seq))
+	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
+	if (locked)
+		write_sequnlock(&rename_lock);
 	return 1;
+
+rename_retry:
+	locked = 1;
+	write_seqlock(&rename_lock);
+	goto again;
 }
 EXPORT_SYMBOL(have_submounts);
 
@@ -1025,11 +1035,11 @@ static int select_parent(struct dentry *
 	struct list_head *next;
 	unsigned seq;
 	int found = 0;
+	int locked = 0;
 
-rename_retry:
-	this_parent = parent;
 	seq = read_seqbegin(&rename_lock);
-
+again:
+	this_parent = parent;
 	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
@@ -1091,7 +1101,7 @@ static int select_parent(struct dentry *
 		/* might go back up the wrong parent if we have had a rename
 		 * or deletion */
 		if (this_parent != child->d_parent ||
-				read_seqretry(&rename_lock, seq)) {
+			(!locked && read_seqretry(&rename_lock, seq))) {
 			spin_unlock(&this_parent->d_lock);
 			rcu_read_unlock();
 			goto rename_retry;
@@ -1102,9 +1112,18 @@ static int select_parent(struct dentry *
 	}
 out:
 	spin_unlock(&this_parent->d_lock);
-	if (read_seqretry(&rename_lock, seq))
+	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
+	if (locked)
+		write_sequnlock(&rename_lock);
 	return found;
+
+rename_retry:
+	if (found)
+		return found;
+	locked = 1;
+	write_seqlock(&rename_lock);
+	goto again;
 }
 
 /**
@@ -2602,10 +2621,11 @@ void d_genocide(struct dentry *root)
 	struct dentry *this_parent;
 	struct list_head *next;
 	unsigned seq;
+	int locked = 0;
 
-rename_retry:
-	this_parent = root;
 	seq = read_seqbegin(&rename_lock);
+again:
+	this_parent = root;
 	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
@@ -2650,7 +2670,7 @@ void d_genocide(struct dentry *root)
 		/* might go back up the wrong parent if we have had a rename
 		 * or deletion */
 		if (this_parent != child->d_parent ||
-				read_seqretry(&rename_lock, seq)) {
+			 (!locked && read_seqretry(&rename_lock, seq))) {
 			spin_unlock(&this_parent->d_lock);
 			rcu_read_unlock();
 			goto rename_retry;
@@ -2660,8 +2680,16 @@ void d_genocide(struct dentry *root)
 		goto resume;
 	}
 	spin_unlock(&this_parent->d_lock);
-	if (read_seqretry(&rename_lock, seq))
+	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
+	if (locked)
+		write_sequnlock(&rename_lock);
+	return;
+
+rename_retry:
+	locked = 1;
+	write_seqlock(&rename_lock);
+	goto again;
 }
 
 /**


