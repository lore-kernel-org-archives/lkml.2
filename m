Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab1I1XRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:17:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453Ab1I1WnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:43:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:35 2011
Message-Id: <20110928220135.146466980@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [093/244] fs/9p: Add fid before dentry instantiation
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit 5441ae5eb3614d3c28f77073370738a2820c88e4 upstream.

d_instantiate marks the dentry positive. So a parallel lookup and mkdir of
the directory can find dentry that doesn't have fid attached. This can result
in both the code path doing v9fs_fid_add which results in v9fs_dentry leak.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/9p/vfs_inode.c      |    4 +---
 fs/9p/vfs_inode_dotl.c |    8 ++++----
 2 files changed, 5 insertions(+), 7 deletions(-)

--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -633,13 +633,11 @@ v9fs_create(struct v9fs_session_info *v9
 		P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n", err);
 		goto error;
 	}
-	d_instantiate(dentry, inode);
 	err = v9fs_fid_add(dentry, fid);
 	if (err < 0)
 		goto error;
-
+	d_instantiate(dentry, inode);
 	return ofid;
-
 error:
 	if (ofid)
 		p9_client_clunk(ofid);
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -281,10 +281,10 @@ v9fs_vfs_create_dotl(struct inode *dir,
 		P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n", err);
 		goto error;
 	}
-	d_instantiate(dentry, inode);
 	err = v9fs_fid_add(dentry, fid);
 	if (err < 0)
 		goto error;
+	d_instantiate(dentry, inode);
 
 	/* Now set the ACL based on the default value */
 	v9fs_set_create_acl(dentry, &dacl, &pacl);
@@ -403,10 +403,10 @@ static int v9fs_vfs_mkdir_dotl(struct in
 				err);
 			goto error;
 		}
-		d_instantiate(dentry, inode);
 		err = v9fs_fid_add(dentry, fid);
 		if (err < 0)
 			goto error;
+		d_instantiate(dentry, inode);
 		fid = NULL;
 	} else {
 		/*
@@ -657,10 +657,10 @@ v9fs_vfs_symlink_dotl(struct inode *dir,
 					err);
 			goto error;
 		}
-		d_instantiate(dentry, inode);
 		err = v9fs_fid_add(dentry, fid);
 		if (err < 0)
 			goto error;
+		d_instantiate(dentry, inode);
 		fid = NULL;
 	} else {
 		/* Not in cached mode. No need to populate inode with stat */
@@ -810,10 +810,10 @@ v9fs_vfs_mknod_dotl(struct inode *dir, s
 				err);
 			goto error;
 		}
-		d_instantiate(dentry, inode);
 		err = v9fs_fid_add(dentry, fid);
 		if (err < 0)
 			goto error;
+		d_instantiate(dentry, inode);
 		fid = NULL;
 	} else {
 		/*


