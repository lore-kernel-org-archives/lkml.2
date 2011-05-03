Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1ECQxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:53:05 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45625 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab1ECQxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:53:00 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 12:52:53 EDT
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 03/23] intel_sst: fix unload bugs
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:32:13 +0100
Message-ID: <20110503163212.24853.44073.stgit@bob.linux.org.uk>
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@intel.com>

The current driver remove was erroneous and causes
errors when unloading or loading second time

This patch fixes both of these issues

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Ramesh Babu K V <ramesh.babu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intel_sst.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst.c b/drivers/staging/intel_sst/intel_sst.c
index 2f21f42..c40e00a 100644
--- a/drivers/staging/intel_sst/intel_sst.c
+++ b/drivers/staging/intel_sst/intel_sst.c
@@ -371,7 +371,8 @@ free_mad_wq:
 	destroy_workqueue(sst_drv_ctx->mad_wq);
 do_free_drv_ctx:
 	kfree(sst_drv_ctx);
-	pr_err("Probe failed with 0x%x\n", ret);
+	sst_drv_ctx = NULL;
+	pr_err("Probe failed with %d\n", ret);
 	return ret;
 }
 
@@ -407,11 +408,9 @@ static void __devexit intel_sst_remove(struct pci_dev *pci)
 	destroy_workqueue(sst_drv_ctx->post_msg_wq);
 	destroy_workqueue(sst_drv_ctx->mad_wq);
 	kfree(sst_drv_ctx);
-	pci_release_region(pci, 1);
-	pci_release_region(pci, 2);
-	pci_release_region(pci, 3);
-	pci_release_region(pci, 4);
-	pci_release_region(pci, 5);
+	sst_drv_ctx = NULL;
+	pci_release_regions(pci);
+	pci_disable_device(pci);
 	pci_set_drvdata(pci, NULL);
 }
 
@@ -604,6 +603,7 @@ static void __exit intel_sst_exit(void)
 	pci_unregister_driver(&driver);
 
 	pr_debug("driver unloaded\n");
+	sst_drv_ctx = NULL;
 	return;
 }
 

