Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304Ab1GDQ1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:27:05 -0400
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:52430 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758293Ab1GDQ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:27:03 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: RDMA: Check for NULL mode in .devnode methods
Date: Mon,  4 Jul 2011 09:26:57 -0700
Message-Id: <1309796817-25293-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.de>

Commits 71c29bd5c235 ("IB/uverbs: Add devnode method to set
path/mode") and c3af0980ce01 ("IB: Add devnode methods to cm_class and
umad_class") added devnode methods that set the mode.  However, these
methods don't check for a NULL mode, and so we get a crash when
unloading modules because devtmpfs_delete_node() calls
device_get_devnode() with mode == NULL.

Add the missing checks.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>

[ Also fix cm.c.  - Roland ]

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
Linus, please apply -- this fixes a regression introduced in 3.0-rc1.

 drivers/infiniband/core/cm.c          |    3 ++-
 drivers/infiniband/core/uverbs_main.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index f62f52f..fc0f2bd 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3641,7 +3641,8 @@ static struct kobj_type cm_port_obj_type = {
 
 static char *cm_devnode(struct device *dev, mode_t *mode)
 {
-	*mode = 0666;
+	if (mode)
+		*mode = 0666;
 	return kasprintf(GFP_KERNEL, "infiniband/%s", dev_name(dev));
 }
 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index e49a85f..56898b6 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -826,7 +826,8 @@ static void ib_uverbs_remove_one(struct ib_device *device)
 
 static char *uverbs_devnode(struct device *dev, mode_t *mode)
 {
-	*mode = 0666;
+	if (mode)
+		*mode = 0666;
 	return kasprintf(GFP_KERNEL, "infiniband/%s", dev_name(dev));
 }
 
