Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab2BAKwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 05:52:14 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:46794 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954Ab2BAKwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 05:52:11 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <cjb@laptop.org>, <rmk+kernel@arm.linux.org.uk>,
        <linus.walleij@linaro.org>, <ulf.hansson@stericsson.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <egtvedt@samfundet.no>, <hskinnemoen@gmail.com>,
        <kernel@pengutronix.de>, <perex@perex.cz>,
        <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH V3 04/12] dmaengine/amba-pl08x: Take flow controller info from DMA_SLAVE_CONFIG
Date: Wed, 1 Feb 2012 16:12:20 +0530
Message-ID: <c60812d9d0d0c6b93f59da973650e01c92b17ebd.1328091915.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
In-Reply-To: <cover.1328091915.git.viresh.kumar@st.com>
References: <cover.1328091915.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flow controller information is passed now from DMA_SLAVE_CONFIG option. This
patch makes changes in pl08x driver to use device_fc from it instead of platform
data.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c   |    4 +++-
 include/linux/amba/pl08x.h |    8 ++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 9ebceca..e1a71f0 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1139,6 +1139,8 @@ static int dma_set_runtime_config(struct dma_chan *chan,
 	cctl |= burst << PL080_CONTROL_SB_SIZE_SHIFT;
 	cctl |= burst << PL080_CONTROL_DB_SIZE_SHIFT;
 
+	plchan->device_fc = config->device_fc;
+
 	if (plchan->runtime_direction == DMA_DEV_TO_MEM) {
 		plchan->src_addr = config->src_addr;
 		plchan->src_cctl = pl08x_cctl(cctl) | PL080_CONTROL_DST_INCR |
@@ -1370,7 +1372,7 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 		return NULL;
 	}
 
-	if (plchan->cd->device_fc)
+	if (plchan->device_fc)
 		tmp = (direction == DMA_MEM_TO_DEV) ? PL080_FLOW_MEM2PER_PER :
 			PL080_FLOW_PER2MEM_PER;
 	else
diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
index 033f6aa..2c58853 100644
--- a/include/linux/amba/pl08x.h
+++ b/include/linux/amba/pl08x.h
@@ -47,9 +47,6 @@ enum {
  * @muxval: a number usually used to poke into some mux regiser to
  * mux in the signal to this channel
  * @cctl_opt: default options for the channel control register
- * @device_fc: Flow Controller Settings for ccfg register. Only valid for slave
- * channels. Fill with 'true' if peripheral should be flow controller. Direction
- * will be selected at Runtime.
  * @addr: source/target address in physical memory for this DMA channel,
  * can be the address of a FIFO register for burst requests for example.
  * This can be left undefined if the PrimeCell API is used for configuring
@@ -68,7 +65,6 @@ struct pl08x_channel_data {
 	int max_signal;
 	u32 muxval;
 	u32 cctl;
-	bool device_fc;
 	dma_addr_t addr;
 	bool circular_buffer;
 	bool single;
@@ -183,6 +179,9 @@ enum pl08x_dma_chan_state {
  * @host: a pointer to the host (internal use)
  * @state: whether the channel is idle, paused, running etc
  * @slave: whether this channel is a device (slave) or for memcpy
+ * @device_fc: Flow Controller Settings for ccfg register. Only valid for slave
+ * channels. Fill with 'true' if peripheral should be flow controller. Direction
+ * will be selected at Runtime.
  * @waiting: a TX descriptor on this channel which is waiting for a physical
  * channel to become available
  */
@@ -205,6 +204,7 @@ struct pl08x_dma_chan {
 	struct pl08x_driver_data *host;
 	enum pl08x_dma_chan_state state;
 	bool slave;
+	bool device_fc;
 	struct pl08x_txd *waiting;
 };
 
-- 
1.7.8.110.g4cb5d

