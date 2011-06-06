Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab1FFHVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:21:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53892 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab1FFHVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:21:53 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, cjb@laptop.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v2 1/3] dmaengine: add new dma API for max_segment_number
Date: Mon,  6 Jun 2011 15:30:12 +0800
Message-Id: <1307345414-26872-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
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
Changes since v1:
 * Update commit message to explain why the new api is needed

 include/linux/device.h      |    1 +
 include/linux/dma-mapping.h |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index c66111a..44cb2528 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -487,6 +487,7 @@ struct device_dma_parameters {
 	 * sg limitations.
 	 */
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

