Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934961Ab0KQQTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:19:00 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48250 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934951Ab0KQQS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:18:58 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 4/7] sst: Construct fw string name runtime
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 17 Nov 2010 15:58:59 +0000
Message-ID: <20101117155856.21681.87271.stgit@localhost.localdomain>
In-Reply-To: <20101117155748.21681.71501.stgit@localhost.localdomain>
References: <20101117155748.21681.71501.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@intel.com>

The firmware name for each platform is appended by PCI id of device.
This patch makes use of pci id to construct the string rather than
hardcode the string.

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intel_sst_common.h       |    3 +--
 .../staging/intel_sst/intel_sst_drv_interface.c    |   11 ++++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst_common.h b/drivers/staging/intel_sst/intel_sst_common.h
index a828824..e0c6339 100644
--- a/drivers/staging/intel_sst/intel_sst_common.h
+++ b/drivers/staging/intel_sst/intel_sst_common.h
@@ -33,10 +33,9 @@
 
 /* driver names */
 #define SST_DRV_NAME "intel_sst_driver"
-#define SST_FW_FILENAME_MRST "fw_sst_080a.bin"
-#define SST_FW_FILENAME_MFLD "fw_sst_082f.bin"
 #define SST_MRST_PCI_ID 0x080A
 #define SST_MFLD_PCI_ID 0x082F
+#define PCI_ID_LENGTH 4
 #define SST_SUSPEND_DELAY 2000
 
 enum sst_states {
diff --git a/drivers/staging/intel_sst/intel_sst_drv_interface.c b/drivers/staging/intel_sst/intel_sst_drv_interface.c
index 1ff6420..eeae06d 100644
--- a/drivers/staging/intel_sst/intel_sst_drv_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_drv_interface.c
@@ -46,13 +46,14 @@ int sst_download_fw(void)
 {
 	int retval;
 	const struct firmware *fw_sst;
-	const char *name;
+	char name[20];
+
 	if (sst_drv_ctx->sst_state != SST_UN_INIT)
 		return -EPERM;
-	if (sst_drv_ctx->pci_id == SST_MRST_PCI_ID)
-		name = SST_FW_FILENAME_MRST;
-	else
-		name = SST_FW_FILENAME_MFLD;
+
+	snprintf(name, sizeof(name), "%s%04x%s", "fw_sst_",
+					sst_drv_ctx->pci_id, ".bin");
+
 	pr_debug("sst: Downloading %s FW now...\n", name);
 	retval = request_firmware(&fw_sst, name, &sst_drv_ctx->pci->dev);
 	if (retval) {

