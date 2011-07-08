Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab1GHI7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:59:06 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33122 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab1GHI7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:59:01 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] sst: avoid unnecessary firmware reloading for MRST
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 09:59:26 +0100
Message-ID: <20110708085921.18212.81014.stgit@bob.linux.org.uk>
In-Reply-To: <20110708085856.18212.35505.stgit@bob.linux.org.uk>
References: <20110708085856.18212.35505.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

SST HW on MRST doesn't need to reload the firmware during suspend/resume
cycle, so remove the extra workload. This also fix a bug that the firmware
sample rate can't be modified when there is no active playback/capture
stream.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intel_sst.c              |    5 ++++-
 drivers/staging/intel_sst/intel_sst_common.h       |    2 ++
 .../staging/intel_sst/intel_sst_drv_interface.c    |   10 ++++++++++
 3 files changed, 16 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst.c b/drivers/staging/intel_sst/intel_sst.c
index c0c144a..d892861 100644
--- a/drivers/staging/intel_sst/intel_sst.c
+++ b/drivers/staging/intel_sst/intel_sst.c
@@ -545,7 +545,10 @@ static int intel_sst_runtime_suspend(struct device *dev)
 	/* Move the SST state to Suspended */
 	mutex_lock(&sst_drv_ctx->sst_lock);
 	sst_drv_ctx->sst_state = SST_SUSPENDED;
-	sst_shim_write(sst_drv_ctx->shim, SST_CSR, csr.full);
+
+	/* Only needed by Medfield */
+	if (sst_drv_ctx->pci_id != SST_MRST_PCI_ID)
+		sst_shim_write(sst_drv_ctx->shim, SST_CSR, csr.full);
 	mutex_unlock(&sst_drv_ctx->sst_lock);
 	return 0;
 }
diff --git a/drivers/staging/intel_sst/intel_sst_common.h b/drivers/staging/intel_sst/intel_sst_common.h
index f8e9da6..870981b 100644
--- a/drivers/staging/intel_sst/intel_sst_common.h
+++ b/drivers/staging/intel_sst/intel_sst_common.h
@@ -420,6 +420,8 @@ struct intel_sst_drv {
 	unsigned int		max_streams;
 	unsigned int		*fw_cntx;
 	unsigned int		fw_cntx_size;
+
+	unsigned int		fw_downloaded;
 };
 
 extern struct intel_sst_drv *sst_drv_ctx;
diff --git a/drivers/staging/intel_sst/intel_sst_drv_interface.c b/drivers/staging/intel_sst/intel_sst_drv_interface.c
index 1021477..69daa14 100644
--- a/drivers/staging/intel_sst/intel_sst_drv_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_drv_interface.c
@@ -53,6 +53,13 @@ int sst_download_fw(void)
 	if (sst_drv_ctx->sst_state != SST_UN_INIT)
 		return -EPERM;
 
+	/* Reload firmware is not needed for MRST */
+	if ( (sst_drv_ctx->pci_id == SST_MRST_PCI_ID) && sst_drv_ctx->fw_downloaded) {
+		pr_debug("FW already downloaded, skip for MRST platform\n");
+		sst_drv_ctx->sst_state = SST_FW_RUNNING;
+		return 0;
+	}
+
 	snprintf(name, sizeof(name), "%s%04x%s", "fw_sst_",
 					sst_drv_ctx->pci_id, ".bin");
 
@@ -71,6 +78,9 @@ int sst_download_fw(void)
 	retval = sst_wait_timeout(sst_drv_ctx, &sst_drv_ctx->alloc_block[0]);
 	if (retval)
 		pr_err("fw download failed %d\n" , retval);
+	else
+		sst_drv_ctx->fw_downloaded = 1;
+
 end_restore:
 	release_firmware(fw_sst);
 	sst_drv_ctx->alloc_block[0].sst_id = BLOCK_UNINIT;

