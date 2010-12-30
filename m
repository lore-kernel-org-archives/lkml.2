Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab0L3Xyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 18:54:38 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33631 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab0L3Xyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:54:37 -0500
Date: Fri, 31 Dec 2010 10:54:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@vger.kernel.org>
Subject: linux-next: manual merge of the vfs-scale tree with the  tree
Message-Id: <20101231105432.ee0a7488.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

Today's linux-next merge of the vfs-scale tree got a conflict in
Documentation/filesystems/Locking between commit
b83be6f20a0e468f715b14225c9f897538dfe5ad ("update
Documentation/filesystems/Locking") from Linus' tree and various commits
from the vfs-scale tree.

I fixed it up (as best I could - see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/filesystems/Locking
index 7686e76,c1a7e72..0000000
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@@ -18,13 -22,15 +22,14 @@@ prototypes
  	char *(*d_dname)((struct dentry *dentry, char *buffer, int buflen);
  
  locking rules:
- 		dcache_lock	rename_lock	->d_lock	may block
- d_revalidate:	no		no		no		yes
- d_hash		no		no		no		yes
- d_compare:	no		yes		no		no 
- d_delete:	yes		no		yes		no
- d_release:	no		no		no		yes
- d_iput:		no		no		no		yes
 -	none have BKL
+ 		rename_lock	->d_lock	may block	rcu-walk
+ d_revalidate:	no		no		yes		no
+ d_revalidate_rcu:no		no		yes (ref-walk)	maybe
+ d_hash		no		no		no		maybe
+ d_compare:	yes		no		no		maybe
+ d_delete:	no		yes		no		no
+ d_release:	no		no		yes		no
+ d_iput:		no		no		yes		no
  d_dname:	no		no		no		no
  
  --------------------------- inode_operations --------------------------- 
@@@ -41,11 -47,12 +46,13 @@@ ata *)
  	int (*rename) (struct inode *, struct dentry *,
  			struct inode *, struct dentry *);
  	int (*readlink) (struct dentry *, char __user *,int);
 -	int (*follow_link) (struct dentry *, struct nameidata *);
 +	void * (*follow_link) (struct dentry *, struct nameidata *);
 +	void (*put_link) (struct dentry *, struct nameidata *, void *);
  	void (*truncate) (struct inode *);
- 	int (*permission) (struct inode *, int, struct nameidata *);
+ 	int (*permission) (struct inode *, int);
+ 	int (*permission_rcu) (struct inode *, int, unsigned int);
  	int (*check_acl)(struct inode *, int);
+ 	int (*check_acl_rcu)(struct inode *, int, unsigned int);
  	int (*setattr) (struct dentry *, struct iattr *);
  	int (*getattr) (struct vfsmount *, struct dentry *, struct kstat *);
  	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
@@@ -74,7 -77,7 +81,8 @@@ put_link:	n
  truncate:	yes		(see below)
  setattr:	yes
  permission:	no
+ permission_rcu: no (may not block if called in rcu-walk mode)
 +check_acl:	no
  getattr:	no
  setxattr:	yes
  getxattr:	no
