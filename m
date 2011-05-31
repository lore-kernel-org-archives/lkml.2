Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab1EaTSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:18:47 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:46769 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1EaTSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:18:46 -0400
Date: Tue, 31 May 2011 15:10:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: [git pull v3.0-rc1] What branch to base fixes for v3.0-rc1 for block
 system?
Message-ID: <20110531191039.GA5269@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DE53F14.0097:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens,

I've got two tiny fixes for the xen-blkback (see below):

  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git for-jens/xen-blkback.fixes

and they are based on for-2.6.40/drivers branch. Is that the way you
prefer to pull patches from sub-trees? Or should I rebase it on 3.0-rc1?
Or should send bug-fixes just directly to Linus?

Dan Carpenter (1):
      xen/blkback: potential null dereference in error handling

Laszlo Ersek (1):
      xen/blkback: don't call vbd_size() if bd_disk is NULL

 drivers/block/xen-blkback/blkback.c |   10 ++++++----
 drivers/block/xen-blkback/xenbus.c  |    3 +--
 2 files changed, 7 insertions(+), 6 deletions(-)

And them combined:


diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index c73910c..e3c26d1 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -809,11 +809,13 @@ static int __init xen_blkif_init(void)
  failed_init:
 	kfree(blkbk->pending_reqs);
 	kfree(blkbk->pending_grant_handles);
-	for (i = 0; i < mmap_pages; i++) {
-		if (blkbk->pending_pages[i])
-			__free_page(blkbk->pending_pages[i]);
+	if (blkback->pending_pages) {
+		for (i = 0; i < mmap_pages; i++) {
+			if (blkbk->pending_pages[i])
+				__free_page(blkbk->pending_pages[i]);
+		}
+		kfree(blkbk->pending_pages);
 	}
-	kfree(blkbk->pending_pages);
 	kfree(blkbk);
 	blkbk = NULL;
 	return rc;
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 3457082..6cc0db1 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -357,14 +357,13 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 	}
 
 	vbd->bdev = bdev;
-	vbd->size = vbd_sz(vbd);
-
 	if (vbd->bdev->bd_disk == NULL) {
 		DPRINTK("xen_vbd_create: device %08x doesn't exist.\n",
 			vbd->pdevice);
 		xen_vbd_free(vbd);
 		return -ENOENT;
 	}
+	vbd->size = vbd_sz(vbd);
 
 	if (vbd->bdev->bd_disk->flags & GENHD_FL_CD || cdrom)
 		vbd->type |= VDISK_CDROM;
