Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab1LNQFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:05:42 -0500
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:60345 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457Ab1LNQEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:04:46 -0500
X-AuditID: c1b4fb3d-b7cfeae000005b81-0b-4ee8c91a3dfa
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>
To: <lucas.demarchi@profusion.mobi>, <borislav.petkov@amd.com>,
        <tony.luck@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>
Subject: [PATCH 2/4] edac: i5100 probe for device 19 function 0
Date: Wed, 14 Dec 2011 17:04:28 +0100
Message-ID: <1323878670-26079-3-git-send-email-niklas.soderlund@ericsson.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323878670-26079-1-git-send-email-niklas.soderlund@ericsson.com>
References: <1323878670-26079-1-git-send-email-niklas.soderlund@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probe and store the device handle for the device 19 function 0 during
driver initialization. The device is used during fault injection.

Signed-off-by: Niklas Söderlund <niklas.soderlund@ericsson.com>
---
 drivers/edac/i5100_edac.c |   26 +++++++++++++++++++++++++-
 include/linux/pci_ids.h   |    1 +
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index 1319e59..3840674 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -333,6 +333,7 @@ struct i5100_priv {
 	unsigned ranksperchan;	/* number of ranks per channel */
 
 	struct pci_dev *mc;	/* device 16 func 1 */
+	struct pci_dev *mc_einj;/* device 19 func 0 */
 	struct pci_dev *ch0mm;	/* device 21 func 0 */
 	struct pci_dev *ch1mm;	/* device 22 func 0 */
 
@@ -968,7 +969,7 @@ static int __devinit i5100_init_one(struct pci_dev *pdev,
 	int rc;
 	struct mem_ctl_info *mci;
 	struct i5100_priv *priv;
-	struct pci_dev *ch0mm, *ch1mm;
+	struct pci_dev *ch0mm, *ch1mm, *einj;
 	int ret = 0;
 	u32 dw;
 	int ranksperch;
@@ -1033,6 +1034,22 @@ static int __devinit i5100_init_one(struct pci_dev *pdev,
 		goto bail_disable_ch1;
 	}
 
+
+	/* device 19, func 0, Error injection */
+	einj = pci_get_device_func(PCI_VENDOR_ID_INTEL,
+				    PCI_DEVICE_ID_INTEL_5100_19, 0);
+	if (!einj) {
+		ret = -ENODEV;
+		goto bail_einj;
+	}
+
+	rc = pci_enable_device(einj);
+	if (rc < 0) {
+		ret = rc;
+		goto bail_disable_einj;
+	}
+
+
 	mci->dev = &pdev->dev;
 
 	priv = mci->pvt_info;
@@ -1040,6 +1057,7 @@ static int __devinit i5100_init_one(struct pci_dev *pdev,
 	priv->mc = pdev;
 	priv->ch0mm = ch0mm;
 	priv->ch1mm = ch1mm;
+	priv->mc_einj = einj;
 
 	INIT_DELAYED_WORK(&(priv->i5100_scrubbing), i5100_refresh_scrubbing);
 
@@ -1102,6 +1120,12 @@ bail_scrub:
 	cancel_delayed_work_sync(&(priv->i5100_scrubbing));
 	edac_mc_free(mci);
 
+bail_disable_einj:
+	pci_disable_device(einj);
+
+bail_einj:
+	pci_dev_put(einj);
+
 bail_disable_ch1:
 	pci_disable_device(ch1mm);
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 2aaee0c..8bf149d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2732,6 +2732,7 @@
 #define PCI_DEVICE_ID_INTEL_IOAT_SNB9	0x3c2f
 #define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
 #define PCI_DEVICE_ID_INTEL_5100_16	0x65f0
+#define PCI_DEVICE_ID_INTEL_5100_19	0x65f3
 #define PCI_DEVICE_ID_INTEL_5100_21	0x65f5
 #define PCI_DEVICE_ID_INTEL_5100_22	0x65f6
 #define PCI_DEVICE_ID_INTEL_5400_ERR	0x4030
-- 
1.7.7.3

