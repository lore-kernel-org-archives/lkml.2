Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab1CAPHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:07:48 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:38341 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab1CAPHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:07:47 -0500
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] fs/9p: call vmtruncate before setattr 9p opeation
In-Reply-To: <20110301121012.GA15516@infradead.org>
References: <1298969484-16199-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1298969484-16199-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20110301121012.GA15516@infradead.org>
User-Agent: Notmuch/0.5-66-g70c5e2c (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Tue, 01 Mar 2011 20:37:23 +0530
Message-ID: <87hbbmev6c.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011 07:10:12 -0500, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Mar 01, 2011 at 02:21:20PM +0530, Aneesh Kumar K.V wrote:
> > We need to call vmtruncate before 9p setattr operation, otherwise we
> > could write back some dirty pages between setattr with ATTR_SIZE and vmtruncate
> > causing some truncated pages to be written back to server
> 
> Please read the documentation.  vmtruncate is deprecated and no new
> users may be added at this point.
> 

How about the below ? I am yet to test this with ltp ftest0* tests .

commit 110414649b3b56e968c70b3db1aba10e95a63043
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Tue Mar 1 20:33:57 2011 +0530

    fs/9p: Use truncate_setsize instead of vmtruncate
    
    convert vmtruncate usage to truncate_setsize
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index c6cef24..561c355 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -970,6 +970,10 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	struct p9_fid *fid;
 	struct p9_wstat wstat;
 
+	retval = inode_change_ok(dentry->d_inode, iattr);
+	if (retval)
+		return retval;
+
 	P9_DPRINTK(P9_DEBUG_VFS, "\n");
 	retval = -EPERM;
 	v9ses = v9fs_inode2v9ses(dentry->d_inode);
@@ -998,11 +1002,9 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 			wstat.n_gid = iattr->ia_gid;
 	}
 	if ((iattr->ia_valid & ATTR_SIZE) &&
-	    iattr->ia_size != i_size_read(dentry->d_inode)) {
-		retval = vmtruncate(dentry->d_inode, iattr->ia_size);
-		if (retval)
-			return retval;
-	}
+	    iattr->ia_size != i_size_read(dentry->d_inode))
+		truncate_setsize(dentry->d_inode, iattr->ia_size);
+
 	/* Write all dirty data */
 	if (S_ISREG(dentry->d_inode->i_mode))
 		filemap_write_and_wait(dentry->d_inode->i_mapping);
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 327c578..2e2d377 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -457,11 +457,9 @@ int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
 		return PTR_ERR(fid);
 
 	if ((iattr->ia_valid & ATTR_SIZE) &&
-	    iattr->ia_size != i_size_read(dentry->d_inode)) {
-		retval = vmtruncate(dentry->d_inode, iattr->ia_size);
-		if (retval)
-			return retval;
-	}
+	    iattr->ia_size != i_size_read(dentry->d_inode))
+		truncate_setsize(dentry->d_inode, iattr->ia_size);
+
 	/* Write all dirty data */
 	if (S_ISREG(dentry->d_inode->i_mode))
 		filemap_write_and_wait(dentry->d_inode->i_mapping);
