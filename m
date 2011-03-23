Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab1CWTDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 15:03:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54074 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab1CWTDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 15:03:33 -0400
Date: Wed, 23 Mar 2011 15:03:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>, viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 9/8] fs: simplify iget & friends
Message-ID: <20110323190327.GA6905@infradead.org>
References: <1300793023-3775-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300793023-3775-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge get_new_inode/get_new_inode_fast into iget5_locked/iget_locked
as those were the only callers.  Remove the internal ifind/ifind_fast
helpers - ifind_fast only had a single caller, and ifind had two
callers wanting it to do different things.  Also clean up the comments
in this area to focus on information important to a developer trying
to use it, instead of overloading them with implementation details.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/inode.c
===================================================================
--- xfs.orig/fs/inode.c	2011-03-23 12:52:49.898877203 +0100
+++ xfs/fs/inode.c	2011-03-23 12:52:57.066879923 +0100
@@ -930,20 +930,42 @@ void unlock_new_inode(struct inode *inod
 }
 EXPORT_SYMBOL(unlock_new_inode);
 
-/*
- * This is called without the inode hash lock held.. Be careful.
+/**
+ * iget5_locked - obtain an inode from a mounted file system
+ * @sb:		super block of file system
+ * @hashval:	hash value (usually inode number) to get
+ * @test:	callback used for comparisons between inodes
+ * @set:	callback used to initialize a new struct inode
+ * @data:	opaque data pointer to pass to @test and @set
  *
- * We no longer cache the sb_flags in i_flags - see fs.h
- *	-- rmk@arm.uk.linux.org
+ * Search for the inode specified by @hashval and @data in the inode cache,
+ * and if present it is return it with an increased reference count. This is
+ * a generalized version of iget_locked() for file systems where the inode
+ * number is not sufficient for unique identification of an inode.
+ *
+ * If the inode is not in cache, allocate a new inode and return it locked,
+ * hashed, and with the I_NEW flag set. The file system gets to fill it in
+ * before unlocking it via unlock_new_inode().
+ *
+ * Note both @test and @set are called with the inode_hash_lock held, so can't
+ * sleep.
  */
-static struct inode *get_new_inode(struct super_block *sb,
-				struct hlist_head *head,
-				int (*test)(struct inode *, void *),
-				int (*set)(struct inode *, void *),
-				void *data)
+struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
+		int (*test)(struct inode *, void *),
+		int (*set)(struct inode *, void *), void *data)
 {
+	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
 	struct inode *inode;
 
+	spin_lock(&inode_hash_lock);
+	inode = find_inode(sb, head, test, data);
+	spin_unlock(&inode_hash_lock);
+
+	if (inode) {
+		wait_on_inode(inode);
+		return inode;
+	}
+
 	inode = alloc_inode(sb);
 	if (inode) {
 		struct inode *old;
@@ -985,16 +1007,34 @@ set_failed:
 	destroy_inode(inode);
 	return NULL;
 }
+EXPORT_SYMBOL(iget5_locked);
 
-/*
- * get_new_inode_fast is the fast path version of get_new_inode, see the
- * comment at iget_locked for details.
+/**
+ * iget_locked - obtain an inode from a mounted file system
+ * @sb:		super block of file system
+ * @ino:	inode number to get
+ *
+ * Search for the inode specified by @ino in the inode cache and if present
+ * return it with an increased reference count. This is for file systems
+ * where the inode number is sufficient for unique identification of an inode.
+ *
+ * If the inode is not in cache, allocate a new inode and return it locked,
+ * hashed, and with the I_NEW flag set.  The file system gets to fill it in
+ * before unlocking it via unlock_new_inode().
  */
-static struct inode *get_new_inode_fast(struct super_block *sb,
-				struct hlist_head *head, unsigned long ino)
+struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 {
+	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
 
+	spin_lock(&inode_hash_lock);
+	inode = find_inode_fast(sb, head, ino);
+	spin_unlock(&inode_hash_lock);
+	if (inode) {
+		wait_on_inode(inode);
+		return inode;
+	}
+
 	inode = alloc_inode(sb);
 	if (inode) {
 		struct inode *old;
@@ -1029,6 +1069,7 @@ static struct inode *get_new_inode_fast(
 	}
 	return inode;
 }
+EXPORT_SYMBOL(iget_locked);
 
 /*
  * search the inode cache for a matching inode number.
@@ -1112,100 +1153,32 @@ struct inode *igrab(struct inode *inode)
 EXPORT_SYMBOL(igrab);
 
 /**
- * ifind - internal function, you want ilookup5() or iget5().
+ * ilookup5_nowait - search for an inode in the inode cache
  * @sb:		super block of file system to search
- * @head:       the head of the list to search
+ * @hashval:	hash value (usually inode number) to search for
  * @test:	callback used for comparisons between inodes
  * @data:	opaque data pointer to pass to @test
- * @wait:	if true wait for the inode to be unlocked, if false do not
- *
- * ifind() searches for the inode specified by @data in the inode
- * cache. This is a generalized version of ifind_fast() for file systems where
- * the inode number is not sufficient for unique identification of an inode.
  *
+ * Search for the inode specified by @hashval and @data in the inode cache.
  * If the inode is in the cache, the inode is returned with an incremented
  * reference count.
  *
- * Otherwise NULL is returned.
+ * Note: I_NEW is not waited upon so you have to be very careful what you do
+ * with the returned inode.  You probably should be using ilookup5() instead.
  *
- * Note, @test is called with the inode_hash_lock held, so can't sleep.
+ * Note: @test is called with the inode_hash_lock held, so can't sleep.
  */
-static struct inode *ifind(struct super_block *sb,
-		struct hlist_head *head, int (*test)(struct inode *, void *),
-		void *data, const int wait)
+struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
+		int (*test)(struct inode *, void *), void *data)
 {
+	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
 	struct inode *inode;
 
 	spin_lock(&inode_hash_lock);
 	inode = find_inode(sb, head, test, data);
-	if (inode) {
-		spin_unlock(&inode_hash_lock);
-		if (likely(wait))
-			wait_on_inode(inode);
-		return inode;
-	}
-	spin_unlock(&inode_hash_lock);
-	return NULL;
-}
-
-/**
- * ifind_fast - internal function, you want ilookup() or iget().
- * @sb:		super block of file system to search
- * @head:       head of the list to search
- * @ino:	inode number to search for
- *
- * ifind_fast() searches for the inode @ino in the inode cache. This is for
- * file systems where the inode number is sufficient for unique identification
- * of an inode.
- *
- * If the inode is in the cache, the inode is returned with an incremented
- * reference count.
- *
- * Otherwise NULL is returned.
- */
-static struct inode *ifind_fast(struct super_block *sb,
-		struct hlist_head *head, unsigned long ino)
-{
-	struct inode *inode;
-
-	spin_lock(&inode_hash_lock);
-	inode = find_inode_fast(sb, head, ino);
-	if (inode) {
-		spin_unlock(&inode_hash_lock);
-		wait_on_inode(inode);
-		return inode;
-	}
 	spin_unlock(&inode_hash_lock);
-	return NULL;
-}
 
-/**
- * ilookup5_nowait - search for an inode in the inode cache
- * @sb:		super block of file system to search
- * @hashval:	hash value (usually inode number) to search for
- * @test:	callback used for comparisons between inodes
- * @data:	opaque data pointer to pass to @test
- *
- * ilookup5() uses ifind() to search for the inode specified by @hashval and
- * @data in the inode cache. This is a generalized version of ilookup() for
- * file systems where the inode number is not sufficient for unique
- * identification of an inode.
- *
- * If the inode is in the cache, the inode is returned with an incremented
- * reference count.  Note, the inode lock is not waited upon so you have to be
- * very careful what you do with the returned inode.  You probably should be
- * using ilookup5() instead.
- *
- * Otherwise NULL is returned.
- *
- * Note, @test is called with the inode_hash_lock held, so can't sleep.
- */
-struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
-		int (*test)(struct inode *, void *), void *data)
-{
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
-
-	return ifind(sb, head, test, data, 0);
+	return inode;
 }
 EXPORT_SYMBOL(ilookup5_nowait);
 
@@ -1216,24 +1189,24 @@ EXPORT_SYMBOL(ilookup5_nowait);
  * @test:	callback used for comparisons between inodes
  * @data:	opaque data pointer to pass to @test
  *
- * ilookup5() uses ifind() to search for the inode specified by @hashval and
- * @data in the inode cache. This is a generalized version of ilookup() for
- * file systems where the inode number is not sufficient for unique
- * identification of an inode.
- *
- * If the inode is in the cache, the inode lock is waited upon and the inode is
+ * Search for the inode specified by @hashval and @data in the inode cache,
+ * and if the inode is in the cache, return the inode with an incremented
+ * reference count.  Waits on I_NEW before returning the inode.
  * returned with an incremented reference count.
  *
- * Otherwise NULL is returned.
+ * This is a generalized version of ilookup() for file systems where the
+ * inode number is not sufficient for unique identification of an inode.
  *
- * Note, @test is called with the inode_hash_lock held, so can't sleep.
+ * Note: @test is called with the inode_hash_lock held, so can't sleep.
  */
 struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode *inode = ilookup5_nowait(sb, hashval, test, data);
 
-	return ifind(sb, head, test, data, 1);
+	if (inode)
+		wait_on_inode(inode);
+	return inode;
 }
 EXPORT_SYMBOL(ilookup5);
 
@@ -1242,92 +1215,23 @@ EXPORT_SYMBOL(ilookup5);
  * @sb:		super block of file system to search
  * @ino:	inode number to search for
  *
- * ilookup() uses ifind_fast() to search for the inode @ino in the inode cache.
- * This is for file systems where the inode number is sufficient for unique
- * identification of an inode.
- *
- * If the inode is in the cache, the inode is returned with an incremented
- * reference count.
- *
- * Otherwise NULL is returned.
+ * Search for the inode @ino in the inode cache, and if the inode is in the
+ * cache, the inode is returned with an incremented reference count.
  */
 struct inode *ilookup(struct super_block *sb, unsigned long ino)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
-
-	return ifind_fast(sb, head, ino);
-}
-EXPORT_SYMBOL(ilookup);
-
-/**
- * iget5_locked - obtain an inode from a mounted file system
- * @sb:		super block of file system
- * @hashval:	hash value (usually inode number) to get
- * @test:	callback used for comparisons between inodes
- * @set:	callback used to initialize a new struct inode
- * @data:	opaque data pointer to pass to @test and @set
- *
- * iget5_locked() uses ifind() to search for the inode specified by @hashval
- * and @data in the inode cache and if present it is returned with an increased
- * reference count. This is a generalized version of iget_locked() for file
- * systems where the inode number is not sufficient for unique identification
- * of an inode.
- *
- * If the inode is not in cache, get_new_inode() is called to allocate a new
- * inode and this is returned locked, hashed, and with the I_NEW flag set. The
- * file system gets to fill it in before unlocking it via unlock_new_inode().
- *
- * Note both @test and @set are called with the inode_hash_lock held, so can't
- * sleep.
- */
-struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
-		int (*test)(struct inode *, void *),
-		int (*set)(struct inode *, void *), void *data)
-{
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
 	struct inode *inode;
 
-	inode = ifind(sb, head, test, data, 1);
-	if (inode)
-		return inode;
-	/*
-	 * get_new_inode() will do the right thing, re-trying the search
-	 * in case it had to block at any point.
-	 */
-	return get_new_inode(sb, head, test, set, data);
-}
-EXPORT_SYMBOL(iget5_locked);
-
-/**
- * iget_locked - obtain an inode from a mounted file system
- * @sb:		super block of file system
- * @ino:	inode number to get
- *
- * iget_locked() uses ifind_fast() to search for the inode specified by @ino in
- * the inode cache and if present it is returned with an increased reference
- * count. This is for file systems where the inode number is sufficient for
- * unique identification of an inode.
- *
- * If the inode is not in cache, get_new_inode_fast() is called to allocate a
- * new inode and this is returned locked, hashed, and with the I_NEW flag set.
- * The file system gets to fill it in before unlocking it via
- * unlock_new_inode().
- */
-struct inode *iget_locked(struct super_block *sb, unsigned long ino)
-{
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
-	struct inode *inode;
+	spin_lock(&inode_hash_lock);
+	inode = find_inode_fast(sb, head, ino);
+	spin_unlock(&inode_hash_lock);
 
-	inode = ifind_fast(sb, head, ino);
 	if (inode)
-		return inode;
-	/*
-	 * get_new_inode_fast() will do the right thing, re-trying the search
-	 * in case it had to block at any point.
-	 */
-	return get_new_inode_fast(sb, head, ino);
+		wait_on_inode(inode);
+	return inode;
 }
-EXPORT_SYMBOL(iget_locked);
+EXPORT_SYMBOL(ilookup);
 
 int insert_inode_locked(struct inode *inode)
 {
