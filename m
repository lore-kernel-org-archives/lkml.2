Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227Ab0EUQyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:54:17 -0400
Received: from kroah.org ([198.145.64.141]:39072 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934196Ab0EUQyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <David.Woodhouse@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Ming Lei <tom.leiming@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tomas Winkler <tomas.winkler@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/38] firmware_class: fix memory leak - free allocated pages
Date: Fri, 21 May 2010 09:53:32 -0700
Message-Id: <1274460848-11377-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
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
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Singed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
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
1.7.0.3

