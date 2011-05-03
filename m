Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab1ECQx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:53:28 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45638 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab1ECQx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:53:26 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 19/23] intel_sst: fix runtime pm issue
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:37:48 +0100
Message-ID: <20110503163602.24853.35611.stgit@bob.linux.org.uk>
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chandramouli Narayanan <chandramouli.narayanan@intel.com>

Use correct api for enabling/disabling runtime pm.  Additionally,
fix runtime suspend/resume to not duplicate pci core functions

Signed-off-by: Chandramouli Narayanan <chandramouli.narayanan@intel.com>
Tested-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intel_sst.c |   47 +++++++++++++++++++++++++++------
 1 files changed, 38 insertions(+), 9 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst.c b/drivers/staging/intel_sst/intel_sst.c
index e7c2617..c0c144a 100644
--- a/drivers/staging/intel_sst/intel_sst.c
+++ b/drivers/staging/intel_sst/intel_sst.c
@@ -340,9 +340,9 @@ static int __devinit intel_sst_probe(struct pci_dev *pci,
 		sst_shim_write(sst_drv_ctx->shim, SST_CSR, csr);
 	}
 	sst_drv_ctx->lpe_stalled = 0;
-	pm_runtime_set_active(&pci->dev);
-	pm_runtime_enable(&pci->dev);
+	pci_set_drvdata(pci, sst_drv_ctx);
 	pm_runtime_allow(&pci->dev);
+	pm_runtime_put_noidle(&pci->dev);
 	pr_debug("...successfully done!!!\n");
 	return ret;
 
@@ -389,6 +389,8 @@ do_free_drv_ctx:
 */
 static void __devexit intel_sst_remove(struct pci_dev *pci)
 {
+	pm_runtime_get_noresume(&pci->dev);
+	pm_runtime_forbid(&pci->dev);
 	pci_dev_put(sst_drv_ctx->pci);
 	mutex_lock(&sst_drv_ctx->sst_lock);
 	sst_drv_ctx->sst_state = SST_UN_INIT;
@@ -410,7 +412,7 @@ static void __devexit intel_sst_remove(struct pci_dev *pci)
 	destroy_workqueue(sst_drv_ctx->process_msg_wq);
 	destroy_workqueue(sst_drv_ctx->post_msg_wq);
 	destroy_workqueue(sst_drv_ctx->mad_wq);
-	kfree(sst_drv_ctx);
+	kfree(pci_get_drvdata(pci));
 	sst_drv_ctx = NULL;
 	pci_release_regions(pci);
 	pci_disable_device(pci);
@@ -522,18 +524,45 @@ int intel_sst_resume(struct pci_dev *pci)
 	return 0;
 }
 
+/* The runtime_suspend/resume is pretty much similar to the legacy suspend/resume with the noted exception below:
+ * The PCI core takes care of taking the system through D3hot and restoring it back to D0 and so there is
+ * no need to duplicate that here.
+ */
 static int intel_sst_runtime_suspend(struct device *dev)
 {
-	struct pci_dev *pci_dev = to_pci_dev(dev);
-	pr_debug("runtime_suspend called\n");
-	return intel_sst_suspend(pci_dev, PMSG_SUSPEND);
+	union config_status_reg csr;
+
+	pr_debug("intel_sst_runtime_suspend called\n");
+	if (sst_drv_ctx->stream_cnt) {
+		pr_err("active streams,not able to suspend\n");
+		return -EBUSY;
+	}
+	/*save fw context*/
+	sst_save_dsp_context();
+	/*Assert RESET on LPE Processor*/
+	csr.full = sst_shim_read(sst_drv_ctx->shim, SST_CSR);
+	csr.full = csr.full | 0x2;
+	/* Move the SST state to Suspended */
+	mutex_lock(&sst_drv_ctx->sst_lock);
+	sst_drv_ctx->sst_state = SST_SUSPENDED;
+	sst_shim_write(sst_drv_ctx->shim, SST_CSR, csr.full);
+	mutex_unlock(&sst_drv_ctx->sst_lock);
+	return 0;
 }
 
 static int intel_sst_runtime_resume(struct device *dev)
 {
-	struct pci_dev *pci_dev = to_pci_dev(dev);
-	pr_debug("runtime_resume called\n");
-	return intel_sst_resume(pci_dev);
+
+	pr_debug("intel_sst_runtime_resume called\n");
+	if (sst_drv_ctx->sst_state != SST_SUSPENDED) {
+		pr_err("SST is not in suspended state\n");
+		return 0;
+	}
+
+	mutex_lock(&sst_drv_ctx->sst_lock);
+	sst_drv_ctx->sst_state = SST_UN_INIT;
+	mutex_unlock(&sst_drv_ctx->sst_lock);
+	return 0;
 }
 
 static int intel_sst_runtime_idle(struct device *dev)

