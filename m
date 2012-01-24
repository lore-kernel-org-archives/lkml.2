Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab2AXCmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:42:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab2AXCmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:42:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:25 2012
Message-Id: <20120124023925.783044267@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Boaz Harrosh <bharrosh@panasas.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [021/129] pnfs-obj: Must return layout on IO error
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2865
Lines: 82

From: Boaz Harrosh <bharrosh@panasas.com>

commit fe0fe83585f88346557868a803a479dfaaa0688a upstream.

As mandated by the standard. In case of an IO error, a pNFS
objects layout driver must return it's layout. This is because
all device errors are reported to the server as part of the
layout return buffer.

This is implemented the same way PNFS_LAYOUTRET_ON_SETATTR
is done, through a bit flag on the pnfs_layoutdriver_type->flags
member. The flag is set by the layout driver that wants a
layout_return preformed at pnfs_ld_{write,read}_done in case
of an error.
(Though I have not defined a wrapper like pnfs_ld_layoutret_on_setattr
 because this code is never called outside of pnfs.c and pnfs IO
 paths)

Without this patch 3.[0-2] Kernels leak memory and have an annoying
WARN_ON after every IO error utilizing the pnfs-obj driver.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/objlayout/objio_osd.c |    3 ++-
 fs/nfs/pnfs.c                |   12 ++++++++++++
 fs/nfs/pnfs.h                |    1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

--- a/fs/nfs/objlayout/objio_osd.c
+++ b/fs/nfs/objlayout/objio_osd.c
@@ -551,7 +551,8 @@ static const struct nfs_pageio_ops objio
 static struct pnfs_layoutdriver_type objlayout_type = {
 	.id = LAYOUT_OSD2_OBJECTS,
 	.name = "LAYOUT_OSD2_OBJECTS",
-	.flags                   = PNFS_LAYOUTRET_ON_SETATTR,
+	.flags                   = PNFS_LAYOUTRET_ON_SETATTR |
+				   PNFS_LAYOUTRET_ON_ERROR,
 
 	.alloc_layout_hdr        = objlayout_alloc_layout_hdr,
 	.free_layout_hdr         = objlayout_free_layout_hdr,
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1178,6 +1178,15 @@ void pnfs_ld_write_done(struct nfs_write
 		put_lseg(data->lseg);
 		data->lseg = NULL;
 		dprintk("pnfs write error = %d\n", data->pnfs_error);
+		if (NFS_SERVER(data->inode)->pnfs_curr_ld->flags &
+						PNFS_LAYOUTRET_ON_ERROR) {
+			/* Don't lo_commit on error, Server will needs to
+			 * preform a file recovery.
+			 */
+			clear_bit(NFS_INO_LAYOUTCOMMIT,
+				  &NFS_I(data->inode)->flags);
+			pnfs_return_layout(data->inode);
+		}
 	}
 	data->mds_ops->rpc_release(data);
 }
@@ -1267,6 +1276,9 @@ static void pnfs_ld_handle_read_error(st
 	put_lseg(data->lseg);
 	data->lseg = NULL;
 	dprintk("pnfs write error = %d\n", data->pnfs_error);
+	if (NFS_SERVER(data->inode)->pnfs_curr_ld->flags &
+						PNFS_LAYOUTRET_ON_ERROR)
+		pnfs_return_layout(data->inode);
 
 	nfs_pageio_init_read_mds(&pgio, data->inode);
 
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -68,6 +68,7 @@ enum {
 enum layoutdriver_policy_flags {
 	/* Should the pNFS client commit and return the layout upon a setattr */
 	PNFS_LAYOUTRET_ON_SETATTR	= 1 << 0,
+	PNFS_LAYOUTRET_ON_ERROR		= 1 << 1,
 };
 
 struct nfs4_deviceid_node;


