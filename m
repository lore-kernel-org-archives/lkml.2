Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab1LSEbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 23:31:53 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:46511 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146Ab1LSEbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 23:31:18 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH V1 Resend 1/3] dmaengine: Allow controller drivers to set channel ids
Date: Mon, 19 Dec 2011 10:00:58 +0530
Message-ID: <de4a7d1855fb9366d3e5deac97efabfda9942486.1324268691.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
In-Reply-To: <cover.1324268691.git.viresh.kumar@st.com>
References: <cover.1324268691.git.viresh.kumar@st.com>
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
index a6c6051..38feff3 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -736,7 +736,12 @@ int dma_async_device_register(struct dma_device *device)
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
index 5532bb8..56f0dd2 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -497,6 +497,8 @@ struct dma_tx_state {
  * @xor_align: alignment shift for xor operations
  * @pq_align: alignment shift for pq operations
  * @fill_align: alignment shift for memset operations
+ * @chan_ids_set: channel id's are already set by driver and must not be
+ * reinitialized by dmaengine.
  * @dev_id: unique device ID
  * @dev: struct device reference for dma mapping api
  * @device_alloc_chan_resources: allocate resources and return the
@@ -537,6 +539,9 @@ struct dma_device {
 	u8 fill_align;
 	#define DMA_HAS_PQ_CONTINUE (1 << 15)
 
+	/* sysfs */
+	bool chan_ids_set;
+
 	int dev_id;
 	struct device *dev;
 
-- 
1.7.8.110.g4cb5d

