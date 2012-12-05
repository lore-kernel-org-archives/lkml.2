Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab2LEKBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:01:46 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:24645 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab2LEKBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:01:45 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lk2s7sEVU=
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: konrad.wilk@oracle.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, jbeulich@suse.com,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] xen/blkback: prevent leak of mode during multiple backend_changed calls
Date: Wed,  5 Dec 2012 11:01:37 +0100
Message-Id: <1354701697-5815-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

backend_changed might be called multiple times, which will leak
be->mode. free the previous value before storing the current mode value.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---

!! Not compile tested !!

 drivers/block/xen-blkback/xenbus.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index a6585a4..8650b19 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -502,7 +502,7 @@ static void backend_changed(struct xenbus_watch *watch,
 		= container_of(watch, struct backend_info, backend_watch);
 	struct xenbus_device *dev = be->dev;
 	int cdrom = 0;
-	char *device_type;
+	char *mode, *device_type;
 
 	DPRINTK("");
 
@@ -528,13 +528,15 @@ static void backend_changed(struct xenbus_watch *watch,
 		return;
 	}
 
-	be->mode = xenbus_read(XBT_NIL, dev->nodename, "mode", NULL);
-	if (IS_ERR(be->mode)) {
-		err = PTR_ERR(be->mode);
+	mode = xenbus_read(XBT_NIL, dev->nodename, "mode", NULL);
+	kfree(be->mode);
+	if (IS_ERR(mode)) {
+		err = PTR_ERR(mode);
 		be->mode = NULL;
 		xenbus_dev_fatal(dev, err, "reading mode");
 		return;
 	}
+	be->mode = mode;
 
 	device_type = xenbus_read(XBT_NIL, dev->otherend, "device-type", NULL);
 	if (!IS_ERR(device_type)) {
@@ -555,7 +557,7 @@ static void backend_changed(struct xenbus_watch *watch,
 		be->minor = minor;
 
 		err = xen_vbd_create(be->blkif, handle, major, minor,
-				 (NULL == strchr(be->mode, 'w')), cdrom);
+				 (NULL == strchr(mode, 'w')), cdrom);
 		if (err) {
 			be->major = 0;
 			be->minor = 0;
-- 
1.8.0.1

