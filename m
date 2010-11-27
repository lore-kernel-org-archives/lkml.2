Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab0K0K0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:26:16 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34786 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564Ab0K0K0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doJ0glMEimE
Message-Id: <419734921a2063fb9b103e3c25c08c2e4e71cde7.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:50 +1100
Subject: [PATCH 20/46] fs: dcache avoid starvation in dcache multi-step operations
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Long lived dcache "multi-step" operations which retry on rename seq can
be starved with a lot of rename activity. If they fail after the 1st pass,
take the rename_lock for writing to avoid further starvation.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/dcache.c |   56 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index c4b2c5e..73f5552 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -937,10 +937,11 @@ int have_submounts(struct dentry *parent)
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
@@ -985,7 +986,7 @@ resume:
 		/* might go back up the wrong parent if we have had a rename
 		 * or deletion */
 		if (this_parent != child->d_parent ||
-				read_seqretry(&rename_lock, seq)) {
+			 (!locked && read_seqretry(&rename_lock, seq))) {
 			spin_unlock(&this_parent->d_lock);
 			rcu_read_unlock();
 			goto rename_retry;
@@ -995,13 +996,22 @@ resume:
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
 
@@ -1025,11 +1035,11 @@ static int select_parent(struct dentry * parent)
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
@@ -1091,7 +1101,7 @@ resume:
 		/* might go back up the wrong parent if we have had a rename
 		 * or deletion */
 		if (this_parent != child->d_parent ||
-				read_seqretry(&rename_lock, seq)) {
+			(!locked && read_seqretry(&rename_lock, seq))) {
 			spin_unlock(&this_parent->d_lock);
 			rcu_read_unlock();
 			goto rename_retry;
@@ -1102,9 +1112,18 @@ resume:
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
@@ -2650,7 +2670,7 @@ resume:
 		/* might go back up the wrong parent if we have had a rename
 		 * or deletion */
 		if (this_parent != child->d_parent ||
-				read_seqretry(&rename_lock, seq)) {
+			 (!locked && read_seqretry(&rename_lock, seq))) {
 			spin_unlock(&this_parent->d_lock);
 			rcu_read_unlock();
 			goto rename_retry;
@@ -2660,8 +2680,16 @@ resume:
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
-- 
1.7.1

