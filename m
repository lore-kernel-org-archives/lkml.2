Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab2HPO5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:57:10 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40013 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753804Ab2HPO5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:57:06 -0400
Date: Thu, 16 Aug 2012 18:57:00 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120816145700.GB13382@moon>
References: <20120815092116.700948346@openvz.org>
 <20120815092409.591460800@openvz.org>
 <20120815204546.GC25062@fieldses.org>
 <20120815210237.GF25421@moon>
 <20120815220622.GA28054@fieldses.org>
 <20120816062448.GA32081@moon>
 <20120816123814.GD1209@moon>
 <20120816124703.GE28054@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816124703.GE28054@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 08:47:03AM -0400, J. Bruce Fields wrote:
> On Thu, Aug 16, 2012 at 04:38:14PM +0400, Cyrill Gorcunov wrote:
> > On Thu, Aug 16, 2012 at 10:24:48AM +0400, Cyrill Gorcunov wrote:
> > > > > > On the other hand, if you want a real filehandle then wouldn't you want
> > > > > > to e.g. call the filesystem's ->encode_fh() if necessary, as
> > > > > > exportfs_encode_fh() does?
> > > > > 
> > > > > Well, one of the problem I hit when I've been trying to use encode_fh
> > > > > is that every new implementation of encode_fh will require some size
> > > > > (even unknown) in buffer where encoded data pushed. Correct me please
> > > > > if I'm wrong. But with export_encode_inode_fh there is a small buffer
> > > > > with pretty known size needed on stack needed for printing data in
> > > > > fdinfo.
> > > > 
> > > > You can just give encode_fh a too-small data and let it fail if it's not
> > > > big enough.
> > > > 
> > > > (In practice I think everyone supports NFSv3 filehandles which have a
> > > > maximum size of 64 bytes.)
> > > 
> > > I'll think about it, thanks!
> > 
> > Hi Bruce, thinking a bit more I guess using general encode_fh is not that
> > convenient since it operates with dentries while our fdinfo output deals
> > with inodes. Thus I should either provide some new encode_fh variant
> > which would deal with inodes directly without "parents".
> 
> I can't see why that wouldn't work.

Guys, would the patch below be more-less acceptible?
In inotify I think we could pass "parent" as NULL and use general
encode engine then (ie it will look like someone called for
name_to_handle_at on inotify target).

---
fs, exportfs: Add exportfs_encode_inode_fh helper

This helpers allows to use per-sb encode_fh
functionality where inodes come in as arguments
(say the caller has no dentries to provide).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
---
 fs/exportfs/expfs.c      |   19 ++++++++++++++-----
 include/linux/exportfs.h |    2 ++
 2 files changed, 16 insertions(+), 5 deletions(-)

Index: linux-2.6.git/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.git.orig/fs/exportfs/expfs.c
+++ linux-2.6.git/fs/exportfs/expfs.c
@@ -341,10 +341,21 @@ static int export_encode_fh(struct inode
 	return type;
 }
 
+int exportfs_encode_inode_fh(struct inode *inode, struct fid *fid,
+			     int *max_len, struct inode *parent)
+{
+	const struct export_operations *nop = inode->i_sb->s_export_op;
+
+	if (nop)
+		return nop->encode_fh(inode, fid->raw, max_len, parent);
+
+	return export_encode_fh(inode, fid, max_len, parent);
+}
+EXPORT_SYMBOL_GPL(exportfs_encode_inode_fh);
+
 int exportfs_encode_fh(struct dentry *dentry, struct fid *fid, int *max_len,
 		int connectable)
 {
-	const struct export_operations *nop = dentry->d_sb->s_export_op;
 	int error;
 	struct dentry *p = NULL;
 	struct inode *inode = dentry->d_inode, *parent = NULL;
@@ -357,10 +368,8 @@ int exportfs_encode_fh(struct dentry *de
 		 */
 		parent = p->d_inode;
 	}
-	if (nop->encode_fh)
-		error = nop->encode_fh(inode, fid->raw, max_len, parent);
-	else
-		error = export_encode_fh(inode, fid, max_len, parent);
+
+	error = exportfs_encode_inode_fh(inode, fid, max_len, parent);
 	dput(p);
 
 	return error;
Index: linux-2.6.git/include/linux/exportfs.h
===================================================================
--- linux-2.6.git.orig/include/linux/exportfs.h
+++ linux-2.6.git/include/linux/exportfs.h
@@ -177,6 +177,8 @@ struct export_operations {
 	int (*commit_metadata)(struct inode *inode);
 };
 
+extern int exportfs_encode_inode_fh(struct inode *inode, struct fid *fid,
+				    int *max_len, struct inode *parent);
 extern int exportfs_encode_fh(struct dentry *dentry, struct fid *fid,
 	int *max_len, int connectable);
 extern struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
