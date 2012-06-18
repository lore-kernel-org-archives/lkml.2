Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab2FRL6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:58:10 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34886
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120Ab2FRL6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:58:08 -0400
Date: Mon, 18 Jun 2012 07:58:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org, dhowells@redhat.com, mszeredi@suse.cz
Subject: Re: [PATCH 00/21] vfs: atomic open v6 (part 2)
Message-ID: <20120618115804.GA4048@infradead.org>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
 <20120610034921.GB30000@ZenIV.linux.org.uk>
 <20120610111056.GD30000@ZenIV.linux.org.uk>
 <20120610175605.GE30000@ZenIV.linux.org.uk>
 <20120610222745.GG30000@ZenIV.linux.org.uk>
 <20120617203755.GA31478@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120617203755.GA31478@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 04:37:55PM -0400, Christoph Hellwig wrote:
> vfs.git#master fails xfstests 005 (Test symlinks & ELOOP) for me. I'll
> try to get it bisected tomorrow, unless anyone gets to it earlier.

this failure was caused by

	"namei.c: let follow_link() do put_link() on failure"

and the reason was that we didn't do a proper path_put when failing
inside follow_link().  Fix that should be squashed in below.  With this
xfstests 049 is still failing, I'll look into that next.


Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2012-06-18 12:17:08.084097978 +0200
+++ linux-2.6/fs/namei.c	2012-06-18 13:39:29.764224510 +0200
@@ -597,18 +591,19 @@ static inline void put_link(struct namei
 static __always_inline int
 follow_link(struct path *link, struct nameidata *nd, void **p)
 {
-	int error;
 	struct dentry *dentry = link->dentry;
+	int error;
+	char *s;
 
 	BUG_ON(nd->flags & LOOKUP_RCU);
 
 	if (link->mnt == nd->path.mnt)
 		mntget(link->mnt);
 
-	if (unlikely(current->total_link_count >= 40)) {
-		path_put(&nd->path);
-		return -ELOOP;
-	}
+	error = -ELOOP;
+	if (unlikely(current->total_link_count >= 40))
+		goto out_put_nd_path;
+
 	cond_resched();
 	current->total_link_count++;
 
@@ -616,31 +611,36 @@ follow_link(struct path *link, struct na
 	nd_set_link(nd, NULL);
 
 	error = security_inode_follow_link(link->dentry, nd);
-	if (error) {
-		path_put(&nd->path);
-		return error;
-	}
+	if (error)
+		goto out_put_nd_path;
 
 	nd->last_type = LAST_BIND;
 	*p = dentry->d_inode->i_op->follow_link(dentry, nd);
 	error = PTR_ERR(*p);
-	if (!IS_ERR(*p)) {
-		char *s = nd_get_link(nd);
-		error = 0;
-		if (s)
-			error = __vfs_follow_link(nd, s);
-		else if (nd->last_type == LAST_BIND) {
-			nd->flags |= LOOKUP_JUMPED;
-			nd->inode = nd->path.dentry->d_inode;
-			if (nd->inode->i_op->follow_link) {
-				/* stepped on a _really_ weird one */
-				path_put(&nd->path);
-				error = -ELOOP;
-			}
+	if (IS_ERR(*p))
+		goto out_put_link;
+
+	error = 0;
+	s = nd_get_link(nd);
+	if (s) {
+		error = __vfs_follow_link(nd, s);
+	} else if (nd->last_type == LAST_BIND) {
+		nd->flags |= LOOKUP_JUMPED;
+		nd->inode = nd->path.dentry->d_inode;
+		if (nd->inode->i_op->follow_link) {
+			/* stepped on a _really_ weird one */
+			path_put(&nd->path);
+			error = -ELOOP;
 		}
-		if (unlikely(error))
-			put_link(nd, link, p);
 	}
+	if (unlikely(error))
+		put_link(nd, link, p);
+	return error;
+
+out_put_nd_path:
+	path_put(&nd->path);
+out_put_link:
+	path_put(link);
 	return error;
 }
 
