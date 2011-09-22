Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab1IVKnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 06:43:40 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:48584 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461Ab1IVKnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 06:43:39 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>
Subject: [PATCH 1/3] dmaengine: Allow controller drivers to set channel ids
Date: Thu, 22 Sep 2011 16:13:12 +0530
Message-ID: <63faf72913f4f35b0a542c859522e8333e878c95.1316687776.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently value of chan_id field is updated by dmaengine.c while the dma device
is registered. In some cases the controller driver may need to assign channel
numbers by itself. For example, dw_dmac.c wants to control the order in which
channels are allocated by dmaengine. So it added channels inside channel list of
dma_device in reverse order. Now channel 7 is allocated first and channel 0 is
allocated last.

But as the channel ids are updated by dmaengine, channel numbers in sysfs will
be overwritten if controller has added channels in reverse order. To represent
correct channel number in sysfs, it is required that dmaengine must not assume
that first channel in list is channel 0 and last is 7.

To handled this situation, chan_ids_set is passed by controller driver inside
struct dma_device. Controller drivers that need to set channel numbers
themselves must pass this field as true.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dmaengine.c   |    7 ++++++-
 include/linux/dmaengine.h |    5 +++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 0e5f684..1d09258 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -735,7 +735,12 @@ int dma_async_device_register(struct dma_device *device)
 			goto err_out;
 		}
 
-		chan->chan_id = chancnt++;
+		/* channel ids are set by controller drivers, don't update it */
+		if (!device->chan_ids_set)
+			chan->chan_id = chancnt;
+
+		chancnt++;
+
 		chan->dev->device.class = &dma_devclass;
 		chan->dev->device.parent = device->dev;
 		chan->dev->chan = chan;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 19cbe39..b4607f4 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -417,6 +417,8 @@ struct dma_tx_state {
  * @xor_align: alignment shift for xor operations
  * @pq_align: alignment shift for pq operations
  * @fill_align: alignment shift for memset operations
+ * @chan_ids_set: channel id's are already set by driver and must not be
+ * reinitialized by dmaengine.
  * @dev_id: unique device ID
  * @dev: struct device reference for dma mapping api
  * @device_alloc_chan_resources: allocate resources and return the
@@ -456,6 +458,9 @@ struct dma_device {
 	u8 fill_align;
 	#define DMA_HAS_PQ_CONTINUE (1 << 15)
 
+	/* sysfs */
+	bool chan_ids_set;
+
 	int dev_id;
 	struct device *dev;
 
-- 
1.7.2.2

