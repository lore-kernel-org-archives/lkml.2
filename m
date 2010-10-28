Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab0J1BiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 21:38:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33087 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932457Ab0J1BiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 21:38:22 -0400
Date: Thu, 28 Oct 2010 12:38:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the fsnotify tree with Linus' tree
Message-Id: <20101028123815.4afc6805.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Today's linux-next merge of the fsnotify tree got a conflict in
fs/notify/fsnotify.c between commit
4d4eb36679adbdd75495e1bbfe7ac40e4ae41dea ("fsnotify: use dget_parent")
from Linus' tree and commit b14be22c572d5d98e2ffebf63e2d1aa1f088875b
("fsnotify: call fsnotify_parent in perm events") from the fsnotify tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/notify/fsnotify.c
index 4498a20,f3f6aa7..0000000
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@@ -88,32 -88,58 +88,35 @@@ int __fsnotify_parent(struct path *path
  {
  	struct dentry *parent;
  	struct inode *p_inode;
 -	bool send = false;
 -	bool should_update_children = false;
+ 	int ret = 0;
  
  	if (!dentry)
  		dentry = path->dentry;
  
  	if (!(dentry->d_flags & DCACHE_FSNOTIFY_PARENT_WATCHED))
- 		return;
+ 		return 0;
  
 -	spin_lock(&dentry->d_lock);
 -	parent = dentry->d_parent;
 +	parent = dget_parent(dentry);
  	p_inode = parent->d_inode;
  
 -	if (fsnotify_inode_watches_children(p_inode)) {
 -		if (p_inode->i_fsnotify_mask & mask) {
 -			dget(parent);
 -			send = true;
 -		}
 -	} else {
 -		/*
 -		 * The parent doesn't care about events on it's children but
 -		 * at least one child thought it did.  We need to run all the
 -		 * children and update their d_flags to let them know p_inode
 -		 * doesn't care about them any more.
 -		 */
 -		dget(parent);
 -		should_update_children = true;
 -	}
 -
 -	spin_unlock(&dentry->d_lock);
 -
 -	if (send) {
 +	if (unlikely(!fsnotify_inode_watches_children(p_inode)))
 +		__fsnotify_update_child_dentry_flags(p_inode);
 +	else if (p_inode->i_fsnotify_mask & mask) {
  		/* we are notifying a parent so come up with the new mask which
  		 * specifies these are events which came from a child. */
  		mask |= FS_EVENT_ON_CHILD;
  
  		if (path)
- 			fsnotify(p_inode, mask, path, FSNOTIFY_EVENT_PATH,
- 				 dentry->d_name.name, 0);
+ 			ret = fsnotify(p_inode, mask, path, FSNOTIFY_EVENT_PATH,
+ 				       dentry->d_name.name, 0);
  		else
- 			fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE,
- 				 dentry->d_name.name, 0);
+ 			ret = fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE,
+ 				       dentry->d_name.name, 0);
 -		dput(parent);
  	}
  
 -	if (unlikely(should_update_children)) {
 -		__fsnotify_update_child_dentry_flags(p_inode);
 -		dput(parent);
 -	}
 +	dput(parent);
+ 
+ 	return ret;
  }
  EXPORT_SYMBOL_GPL(__fsnotify_parent);
  
