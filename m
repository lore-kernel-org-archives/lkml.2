Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab1FOMDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 08:03:17 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:50627
	"EHLO CH1EHSOBE017.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750771Ab1FOMDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 08:03:14 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, <cjb@laptop.org>,
        <gregkh@suse.de>, <linux-mmc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <patches@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v3] dmaengine: add new dma API for max_segment_number
Date: Wed, 15 Jun 2011 20:08:41 +0800
Message-ID: <1308139721-4008-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <BANLkTi=-t9HVc6U6QY07su+c3WztsGoq3Q@mail.gmail.com>
References: <BANLkTi=-t9HVc6U6QY07su+c3WztsGoq3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like dma_set(get)_max_seg_size for max_segment_size, the patch adds
max_segment_number into device_dma_parameters and creates the
corresponding dmaengine API dma_set(get)_max_seg_number for it.

Here is the user story that tells the need of the new api.  The
mxs-mmc is the mmc host controller for Freescale MXS architecture.
There are a pair of  mmc host specific parameters max_seg_size and
max_segs that mxs-mmc host driver needs to tell mmc core, so that
mmc core can know how big each data segment could be and how many
segments could be handled one time in a scatter list by host driver.

The mxs-mmc driver is one user of dmaengine mxs-dma, and it will call
mxs-dma to transfer data in scatter list.  That is to say mxs-mmc has
no idea of what max_seg_size and max_segs should be, because they are
all mxs-dma capability parameters, and mxs-mmc needs to query them
from mxs-dma.

Right now, there is well defined dma api (dma_get_max_seg_size) for
mmc to query max_seg_size from dma driver, but the one for max_segs
is missing.  That's why mxs-mmc driver has to hard-code it.

The mxs-mmc is just one example to demonstrate the need of the new
api, and there are other mmc host drivers (mxcmmc on imx-dma is
another example) and possibly even other dmaengine users need this
new api to know the maximum segments that dma driver can handle per
dma call.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 include/linux/device.h      |   16 ++++++++++++----
 include/linux/dma-mapping.h |   15 +++++++++++++++
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index c66111a..f1152c5 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -481,12 +481,20 @@ extern int devres_release_group(struct device *dev, void *id);
 extern void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp);
 extern void devm_kfree(struct device *dev, void *p);
 
+/*
+ * device_dma_parameters is a property of DMA provider, and it belongs to the
+ * 'struct device' that actually provides DMA service, typically the drivers
+ * under drivers/dma, although in some cases the DMA provider and block device
+ * uses DMA service happen to be the same 'struct device'.
+ *
+ * It's not necessary for every single DMA providers to have this structure,
+ * because some DMA providers simply do not have these parameters/limitations.
+ * For those do have, the DMA providers should be responsible for setting the
+ * parameters up.
+ */
 struct device_dma_parameters {
-	/*
-	 * a low level driver may set these to teach IOMMU code about
-	 * sg limitations.
-	 */
 	unsigned int max_segment_size;
+	unsigned int max_segment_number;
 	unsigned long segment_boundary_mask;
 };
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index ba8319a..fd314f4 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -131,6 +131,21 @@ static inline unsigned int dma_set_max_seg_size(struct device *dev,
 		return -EIO;
 }
 
+static inline unsigned int dma_get_max_seg_number(struct device *dev)
+{
+	return dev->dma_parms ? dev->dma_parms->max_segment_number : 1;
+}
+
+static inline unsigned int dma_set_max_seg_number(struct device *dev,
+						  unsigned int number)
+{
+	if (dev->dma_parms) {
+		dev->dma_parms->max_segment_number = number;
+		return 0;
+	} else
+		return -EIO;
+}
+
 static inline unsigned long dma_get_seg_boundary(struct device *dev)
 {
 	return dev->dma_parms ?
-- 
1.7.4.1


