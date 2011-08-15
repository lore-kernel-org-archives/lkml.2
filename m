Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab1HOEzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 00:55:24 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:65490 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1HOEzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 00:55:21 -0400
Message-ID: <4E48A6A6.4040706@oracle.com>
Date: Mon, 15 Aug 2011 12:55:02 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Greg Marsden <greg.marsden@oracle.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Jin <joe.jin@oracle.com>
Subject: [patch] xen-blkback: sync I/O after backend disconnected
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E48A6B2.004C:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When backend disconnect, sync IO requests to the disk.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>
---
 drivers/block/xen-blkback/xenbus.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 1a87f5b..da39d61 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -35,6 +35,7 @@ static void connect(struct backend_info *);
 static int connect_ring(struct backend_info *);
 static void backend_changed(struct xenbus_watch *, const char **,
 			    unsigned int);
+static void xen_vbd_sync(struct xen_vbd *vbd);
 
 struct xenbus_device *xen_blkbk_xenbus(struct backend_info *be)
 {
@@ -232,6 +233,7 @@ static void xen_blkif_disconnect(struct xen_blkif *blkif)
 		free_vm_area(blkif->blk_ring_area);
 		blkif->blk_rings.common.sring = NULL;
 	}
+	xen_vbd_sync(&blkif->vbd);
 }
 
 void xen_blkif_free(struct xen_blkif *blkif)
@@ -332,6 +334,12 @@ static void xen_vbd_free(struct xen_vbd *vbd)
 	vbd->bdev = NULL;
 }
 
+static void xen_vbd_sync(struct xen_vbd *vbd)
+{
+	if (vbd->bdev)
+		fsync_bdev(vbd->bdev);
+}
+
 static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 			  unsigned major, unsigned minor, int readonly,
 			  int cdrom)

