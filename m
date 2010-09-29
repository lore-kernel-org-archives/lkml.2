Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab0I2IQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:16:31 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:45704 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab0I2IQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:16:29 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: "J. Bruce Fields" <bfields@fieldses.org>, sage@newdream.net
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, miklos@szeredi.hu,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V20 02/12] vfs: Add name to file handle conversion support
In-Reply-To: <20100928203045.GC10548@fieldses.org>
References: <1285702610-32733-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1285702610-32733-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100928203045.GC10548@fieldses.org>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Wed, 29 Sep 2010 13:46:23 +0530
Message-ID: <m3k4m57ync.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 16:30:45 -0400, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> On Wed, Sep 29, 2010 at 01:06:40AM +0530, Aneesh Kumar K.V wrote:
> > @@ -1042,3 +1043,131 @@ int nonseekable_open(struct inode *inode, struct file *filp)
> >  }
> >  
> >  EXPORT_SYMBOL(nonseekable_open);
> > +
> > +#ifdef CONFIG_EXPORTFS
> > +static long do_sys_name_to_handle(struct path *path,
> > +				  struct file_handle __user *ufh,
> > +				  int __user *mnt_id)
> > +{
> > +	long retval;
> > +	int handle_size;
> > +	struct file_handle f_handle;
> > +	struct file_handle *handle = NULL;
> > +
> > +	if (copy_from_user(&f_handle, ufh, sizeof(struct file_handle))) {
> > +		retval = -EFAULT;
> > +		goto err_out;
> > +	}
> > +	if (f_handle.handle_size > MAX_HANDLE_SZ) {
> 
> Couldn't handle_size also be negative?:
> 
> > +struct file_handle {
> > +	int handle_size;
> 
> Say the user passes in -1.
> 
> > +		retval = -EINVAL;
> > +		goto err_out;
> > +	}
> > +	handle = kmalloc(sizeof(struct file_handle) + f_handle.handle_size,
> > +			 GFP_KERNEL);
> 
> This succeeds, but allocates too little memory.
> 
> > +	if (!handle) {
> > +		retval = -ENOMEM;
> > +		goto err_out;
> > +	}
> > +
> > +	/* convert handle size to  multiple of sizeof(u32) */
> > +	handle_size = f_handle.handle_size >> 2;
> 
> Now handle_size is a large positive number.
> 
> > +
> > +	/* we ask for a non connected handle */
> > +	retval = exportfs_encode_fh(path->dentry,
> > +				    (struct fid *)handle->f_handle,
> > +				    &handle_size,  0);
> 
> So this succeeds, and writes past the end of the allocated handle.
> 
> As long as the interface is privileged hopefully this would be hard to
> abuse.  But how about just defining handle.handle_size and handle_size
> as unsigned?
> 
> The u32/bytes thing seems an easy source of mistakes.  Would it be
> possible to use "bytes" or "words" everywhere in place of "size" or
> "SZ"?  And, where possible, store only one or other other in a given
> variable.  (So do stuff like:
> 
> 	handle_words = f_handle_size >> 2;
> 	retval = exportfs_encode_fh(.,., &handle_words,.);
> 	handle->handle_type = retval;
> 	handle->handle_bytes = handle_words << 2;
> 	if (handle->handle_bytes > f_handle.handle_bytes) {
> 		...
> )

Updated the patch to do this. Instead of handle_words i used handle_dwords

> 
> By the way, apologies, I can't remember from last time: did you decide
> that overflow was really the only case when 255 would be returned from
> exportfs_encode_fs()?
> 

All in kernel file system other than cepth return 255 on overflow.
ceph return -ENOSPC when there is an EOVERFLOW case. (I also
need to fix Ceph to return minimum handle size). I guess ceph usage was
correct as per the existing documentation. But the current documentation
is wrong and all the file system was returning 255 instead of ENOSPC

We look at the returned handle size of exportfs_encode_fh and determine
the overflow case in open by handle code. May be i should fix that to
include both 255 and ENOSPC ?

	if ((handle->handle_bytes > f_handle.handle_bytes) ||
	    (retval == 255) || (retval == -ENOSPC)) {
		/* As per old exportfs_encode_fh documentation
		 * we could return ENOSPC to indicate overflow
		 * But file system returned 255 always. So handle
		 * both the values
		 */
		/*
		 * set the handle_size to zero so we copy only
		 * non variable part of the file_handle
		 */
		handle->handle_bytes = 0;
		retval = -EOVERFLOW;
      }

Attached ceph change below

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 4480cb1..e38423e 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -42,32 +42,37 @@ struct ceph_nfs_confh {
 static int ceph_encode_fh(struct dentry *dentry, u32 *rawfh, int *max_len,
 			  int connectable)
 {
+	int type;
 	struct ceph_nfs_fh *fh = (void *)rawfh;
 	struct ceph_nfs_confh *cfh = (void *)rawfh;
 	struct dentry *parent = dentry->d_parent;
 	struct inode *inode = dentry->d_inode;
-	int type;
+	int connected_handle_length = sizeof(*cfh)/4;
+	int handle_length = sizeof(*fh)/4;
 
 	/* don't re-export snaps */
 	if (ceph_snap(inode) != CEPH_NOSNAP)
 		return -EINVAL;
 
-	if (*max_len >= sizeof(*cfh)) {
+	if (*max_len >= connected_handle_length) {
 		dout("encode_fh %p connectable\n", dentry);
 		cfh->ino = ceph_ino(dentry->d_inode);
 		cfh->parent_ino = ceph_ino(parent->d_inode);
 		cfh->parent_name_hash = parent->d_name.hash;
-		*max_len = sizeof(*cfh);
+		*max_len = connected_handle_length;
 		type = 2;
-	} else if (*max_len > sizeof(*fh)) {
-		if (connectable)
-			return -ENOSPC;
+	} else if (*max_len >= handle_length) {
+		if (connectable) {
+			*max_len = connected_handle_length;
+			return 255;
+		}
 		dout("encode_fh %p\n", dentry);
 		fh->ino = ceph_ino(dentry->d_inode);
-		*max_len = sizeof(*fh);
+		*max_len = handle_length;
 		type = 1;
 	} else {
-		return -ENOSPC;
+		*max_len = handle_length;
+		return 255;
 	}
 	return type;
 }

-aneesh
