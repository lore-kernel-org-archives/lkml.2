Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0ELIQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:16:24 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41934 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab0ELIQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:16:21 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 12 May 2010 10:16:41 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init() error
 recovery
To: linux-usb@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <994e1bf34d3b6f1fbc58c0f7ce61c7f258208ddd.1273651956.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In to places in fsg_common_init() an unconditional call to kfree()
on common was performed in error recovery which is not a valid
behaviour since fsg_common structure is not always allocated by
fsg_common_init().

To fix, the calls has been replaced with a goto to a proper error
recovery which does the correct thing.
---
 drivers/usb/gadget/f_mass_storage.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 6cfd2f4..9a59941 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2742,10 +2742,8 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 	/* Maybe allocate device-global string IDs, and patch descriptors */
 	if (fsg_strings[FSG_STRING_INTERFACE].id == 0) {
 		rc = usb_string_id(cdev);
-		if (rc < 0) {
-			kfree(common);
-			return ERR_PTR(rc);
-		}
+		if (unlikely(rc < 0))
+			goto error_release;
 		fsg_strings[FSG_STRING_INTERFACE].id = rc;
 		fsg_intf_desc.iInterface = rc;
 	}
@@ -2753,9 +2751,9 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 	/* Create the LUNs, open their backing files, and register the
 	 * LUN devices in sysfs. */
 	curlun = kzalloc(nluns * sizeof *curlun, GFP_KERNEL);
-	if (!curlun) {
-		kfree(common);
-		return ERR_PTR(-ENOMEM);
+	if (unlikely(!curlun)) {
+		rc = -ENOMEM;
+		goto error_release;
 	}
 	common->luns = curlun;
 
-- 
1.7.1

