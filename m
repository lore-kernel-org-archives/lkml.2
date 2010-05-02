Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab0EBIVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 04:21:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:45057 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472Ab0EBIV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 04:21:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,311,1270450800"; 
   d="scan'208";a="794699583"
From: Tomas Winkler <tomas.winkler@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Kay Sievers <kay.sievers@vrfy.org>
Cc: David Woodhouse <David.Woodhouse@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Ming Lei <tom.leiming@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v3] firmware_class: fix memory leak - free allocated pages
Date: Sun,  2 May 2010 11:21:21 +0300
Message-Id: <1272788481-23066-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.6.6.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <David.Woodhouse@intel.com>

fix memory leak introduced by the patch 6e03a201bbe:
firmware: speed up request_firmware()

1. vfree won't release pages there were allocated explicitly and mapped
using vmap. The memory has to be vunmap-ed and the pages needs
to be freed explicitly

2. page array is moved into the 'struct
firmware' so that we can free it from release_firmware()
and not only in fw_dev_release()

The fix doesn't break the firmware load speed.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Singed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: fix authorship of the patch
V3: fix const struct firmware breakage

 drivers/base/firmware_class.c |   26 ++++++++++++++++++++------
 include/linux/firmware.h      |    1 +
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 985da11..4c70b91 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -130,6 +130,17 @@ static ssize_t firmware_loading_show(struct device *dev,
 	return sprintf(buf, "%d\n", loading);
 }
 
+static void firmware_free_data(const struct firmware *fw)
+{
+	int i;
+	vunmap(fw->data);
+	if (fw->pages) {
+		for (i = 0; i < PFN_UP(fw->size); i++)
+			__free_page(fw->pages[i]);
+		kfree(fw->pages);
+	}
+}
+
 /* Some architectures don't have PAGE_KERNEL_RO */
 #ifndef PAGE_KERNEL_RO
 #define PAGE_KERNEL_RO PAGE_KERNEL
@@ -162,21 +173,21 @@ static ssize_t firmware_loading_store(struct device *dev,
 			mutex_unlock(&fw_lock);
 			break;
 		}
-		vfree(fw_priv->fw->data);
-		fw_priv->fw->data = NULL;
+		firmware_free_data(fw_priv->fw);
+		memset(fw_priv->fw, 0, sizeof(struct firmware));
+		/* If the pages are not owned by 'struct firmware' */
 		for (i = 0; i < fw_priv->nr_pages; i++)
 			__free_page(fw_priv->pages[i]);
 		kfree(fw_priv->pages);
 		fw_priv->pages = NULL;
 		fw_priv->page_array_size = 0;
 		fw_priv->nr_pages = 0;
-		fw_priv->fw->size = 0;
 		set_bit(FW_STATUS_LOADING, &fw_priv->status);
 		mutex_unlock(&fw_lock);
 		break;
 	case 0:
 		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
-			vfree(fw_priv->fw->data);
+			vunmap(fw_priv->fw->data);
 			fw_priv->fw->data = vmap(fw_priv->pages,
 						 fw_priv->nr_pages,
 						 0, PAGE_KERNEL_RO);
@@ -184,7 +195,10 @@ static ssize_t firmware_loading_store(struct device *dev,
 				dev_err(dev, "%s: vmap() failed\n", __func__);
 				goto err;
 			}
-			/* Pages will be freed by vfree() */
+			/* Pages are now owned by 'struct firmware' */
+			fw_priv->fw->pages = fw_priv->pages;
+			fw_priv->pages = NULL;
+
 			fw_priv->page_array_size = 0;
 			fw_priv->nr_pages = 0;
 			complete(&fw_priv->completion);
@@ -578,7 +592,7 @@ release_firmware(const struct firmware *fw)
 			if (fw->data == builtin->data)
 				goto free_fw;
 		}
-		vfree(fw->data);
+		firmware_free_data(fw);
 	free_fw:
 		kfree(fw);
 	}
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 043811f..53d1e6c 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -12,6 +12,7 @@
 struct firmware {
 	size_t size;
 	const u8 *data;
+	struct page **pages;
 };
 
 struct device;
-- 
1.6.6.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

