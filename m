Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab0LHBDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:03:23 -0500
Received: from kroah.org ([198.145.64.141]:33667 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655Ab0LHBDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:19 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:44 2010
Message-Id: <20101208005743.943018873@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ken Sumrall <ksumrall@android.com>, Anfei <anfei.zhou@gmail.com>,
        "Anand V. Avati" <avati@gluster.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: [225/289] fuse: fix attributes after open(O_TRUNC)
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ken Sumrall <ksumrall@android.com>

commit a0822c55779d9319939eac69f00bb729ea9d23da upstream.

The attribute cache for a file was not being cleared when a file is opened
with O_TRUNC.

If the filesystem's open operation truncates the file ("atomic_o_trunc"
feature flag is set) then the kernel should invalidate the cached st_mtime
and st_ctime attributes.

Also i_size should be explicitly be set to zero as it is used sometimes
without refreshing the cache.

Signed-off-by: Ken Sumrall <ksumrall@android.com>
Cc: Anfei <anfei.zhou@gmail.com>
Cc: "Anand V. Avati" <avati@gluster.com>
Signed-off-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/file.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -134,6 +134,7 @@ EXPORT_SYMBOL_GPL(fuse_do_open);
 void fuse_finish_open(struct inode *inode, struct file *file)
 {
 	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = get_fuse_conn(inode);
 
 	if (ff->open_flags & FOPEN_DIRECT_IO)
 		file->f_op = &fuse_direct_io_file_operations;
@@ -141,6 +142,15 @@ void fuse_finish_open(struct inode *inod
 		invalidate_inode_pages2(inode->i_mapping);
 	if (ff->open_flags & FOPEN_NONSEEKABLE)
 		nonseekable_open(inode, file);
+	if (fc->atomic_o_trunc && (file->f_flags & O_TRUNC)) {
+		struct fuse_inode *fi = get_fuse_inode(inode);
+
+		spin_lock(&fc->lock);
+		fi->attr_version = ++fc->attr_version;
+		i_size_write(inode, 0);
+		spin_unlock(&fc->lock);
+		fuse_invalidate_attr(inode);
+	}
 }
 
 int fuse_open_common(struct inode *inode, struct file *file, bool isdir)


