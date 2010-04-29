Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291Ab0D3TLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:11:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:3401 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757836Ab0D3Q7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:59:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,296,1270450800"; 
   d="scan'208";a="794060136"
From: Tomas Winkler <tomas.winkler@intel.com>
To: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Ming Lei <tom.leiming@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v2] firmware_class: fix memory leak - free allocated pages
Date: Thu, 29 Apr 2010 21:26:17 +0300
Message-Id: <1272565577-26587-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.6.6.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>

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
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: fix authorship of the patch

 drivers/base/firmware_class.c |   28 ++++++++++++++++++++++------
 include/linux/firmware.h      |    1 +
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 985da11..8200adc 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -130,6 +130,20 @@ static ssize_t firmware_loading_show(struct device *dev,
 	return sprintf(buf, "%d\n", loading);
 }
 
+static void firmware_free_data(struct firmware *fw)
+{
+	int i;
+	vunmap(fw->data);
+	fw->data = NULL;
+	if (fw->pages) {
+		for (i = 0; i < PFN_UP(fw->size); i++)
+			__free_page(fw->pages[i]);
+		kfree(fw->pages);
+	}
+	fw->pages = NULL;
+	fw->size = 0;
+}
+
 /* Some architectures don't have PAGE_KERNEL_RO */
 #ifndef PAGE_KERNEL_RO
 #define PAGE_KERNEL_RO PAGE_KERNEL
@@ -162,21 +176,20 @@ static ssize_t firmware_loading_store(struct device *dev,
 			mutex_unlock(&fw_lock);
 			break;
 		}
-		vfree(fw_priv->fw->data);
-		fw_priv->fw->data = NULL;
+		firmware_free_data(fw_priv->fw);
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
@@ -184,7 +197,10 @@ static ssize_t firmware_loading_store(struct device *dev,
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
@@ -578,7 +594,7 @@ release_firmware(const struct firmware *fw)
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

