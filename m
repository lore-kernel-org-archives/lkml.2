Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965134Ab1KJDjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:39:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965125Ab1KJDjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:39:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:50 2011
Message-Id: <20111109213150.749862901@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jim Rees <rees@umich.edu>,
        Benny Halevy <bhalevy@tonian.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [086/264] pnfsblock: fix return code confusion
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Rees <rees@umich.edu>

commit 516f2e24faa7548a61d9ba790958528469c2e284 upstream.

Always return PTR_ERR, not NULL, from nfs4_blk_get_deviceinfo and
nfs4_blk_decode_device.

Check for IS_ERR, not NULL, in bl_set_layoutdriver when calling
nfs4_blk_get_deviceinfo.

Signed-off-by: Jim Rees <rees@umich.edu>
Signed-off-by: Benny Halevy <bhalevy@tonian.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/blocklayout/blocklayout.c    |   20 ++++++++++++--------
 fs/nfs/blocklayout/blocklayoutdev.c |   13 ++++++++-----
 2 files changed, 20 insertions(+), 13 deletions(-)

--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -805,7 +805,7 @@ nfs4_blk_get_deviceinfo(struct nfs_serve
 			struct nfs4_deviceid *d_id)
 {
 	struct pnfs_device *dev;
-	struct pnfs_block_dev *rv = NULL;
+	struct pnfs_block_dev *rv;
 	u32 max_resp_sz;
 	int max_pages;
 	struct page **pages = NULL;
@@ -823,18 +823,20 @@ nfs4_blk_get_deviceinfo(struct nfs_serve
 	dev = kmalloc(sizeof(*dev), GFP_NOFS);
 	if (!dev) {
 		dprintk("%s kmalloc failed\n", __func__);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	pages = kzalloc(max_pages * sizeof(struct page *), GFP_NOFS);
 	if (pages == NULL) {
 		kfree(dev);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	for (i = 0; i < max_pages; i++) {
 		pages[i] = alloc_page(GFP_NOFS);
-		if (!pages[i])
+		if (!pages[i]) {
+			rv = ERR_PTR(-ENOMEM);
 			goto out_free;
+		}
 	}
 
 	memcpy(&dev->dev_id, d_id, sizeof(*d_id));
@@ -847,8 +849,10 @@ nfs4_blk_get_deviceinfo(struct nfs_serve
 	dprintk("%s: dev_id: %s\n", __func__, dev->dev_id.data);
 	rc = nfs4_proc_getdeviceinfo(server, dev);
 	dprintk("%s getdevice info returns %d\n", __func__, rc);
-	if (rc)
+	if (rc) {
+		rv = ERR_PTR(rc);
 		goto out_free;
+	}
 
 	rv = nfs4_blk_decode_device(server, dev);
  out_free:
@@ -866,7 +870,7 @@ bl_set_layoutdriver(struct nfs_server *s
 	struct pnfs_devicelist *dlist = NULL;
 	struct pnfs_block_dev *bdev;
 	LIST_HEAD(block_disklist);
-	int status = 0, i;
+	int status, i;
 
 	dprintk("%s enter\n", __func__);
 
@@ -898,8 +902,8 @@ bl_set_layoutdriver(struct nfs_server *s
 		for (i = 0; i < dlist->num_devs; i++) {
 			bdev = nfs4_blk_get_deviceinfo(server, fh,
 						       &dlist->dev_id[i]);
-			if (!bdev) {
-				status = -ENODEV;
+			if (IS_ERR(bdev)) {
+				status = PTR_ERR(bdev);
 				goto out_error;
 			}
 			spin_lock(&b_mt_id->bm_lock);
--- a/fs/nfs/blocklayout/blocklayoutdev.c
+++ b/fs/nfs/blocklayout/blocklayoutdev.c
@@ -131,7 +131,7 @@ struct pnfs_block_dev *
 nfs4_blk_decode_device(struct nfs_server *server,
 		       struct pnfs_device *dev)
 {
-	struct pnfs_block_dev *rv = NULL;
+	struct pnfs_block_dev *rv;
 	struct block_device *bd = NULL;
 	struct rpc_pipe_msg msg;
 	struct bl_msg_hdr bl_msg = {
@@ -141,7 +141,7 @@ nfs4_blk_decode_device(struct nfs_server
 	uint8_t *dataptr;
 	DECLARE_WAITQUEUE(wq, current);
 	struct bl_dev_msg *reply = &bl_mount_reply;
-	int offset, len, i;
+	int offset, len, i, rc;
 
 	dprintk("%s CREATING PIPEFS MESSAGE\n", __func__);
 	dprintk("%s: deviceid: %s, mincount: %d\n", __func__, dev->dev_id.data,
@@ -168,8 +168,10 @@ nfs4_blk_decode_device(struct nfs_server
 
 	dprintk("%s CALLING USERSPACE DAEMON\n", __func__);
 	add_wait_queue(&bl_wq, &wq);
-	if (rpc_queue_upcall(bl_device_pipe->d_inode, &msg) < 0) {
+	rc = rpc_queue_upcall(bl_device_pipe->d_inode, &msg);
+	if (rc < 0) {
 		remove_wait_queue(&bl_wq, &wq);
+		rv = ERR_PTR(rc);
 		goto out;
 	}
 
@@ -187,8 +189,9 @@ nfs4_blk_decode_device(struct nfs_server
 
 	bd = nfs4_blkdev_get(MKDEV(reply->major, reply->minor));
 	if (IS_ERR(bd)) {
-		dprintk("%s failed to open device : %ld\n",
-			__func__, PTR_ERR(bd));
+		rc = PTR_ERR(bd);
+		dprintk("%s failed to open device : %d\n", __func__, rc);
+		rv = ERR_PTR(rc);
 		goto out;
 	}
 


