Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab2JLFot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 01:44:49 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44517 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab2JLFor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 01:44:47 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        andriy.shevchenko@linux.intel.com,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/3] dmaengine: dw_dmac: Enhance device tree support
Date: Fri, 12 Oct 2012 11:14:41 +0530
Message-Id: <91e41b4cc972d298f714cbd6f400569a9710304c.1350020375.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350020375.git.viresh.kumar@linaro.org>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350020375.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 12 Oct 2012 05:44:44.0872 (UTC) FILETIME=[AEDB3C80:01CDA83C]
X-MC-Unique: 112101206444600201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q9C5iuxK014283

dw_dmac driver already supports device tree but it used to have its platform
data passed the non-DT way.

This patch does following changes:
- pass platform data via DT, non-DT way still takes precedence if both are used.
- create generic filter routine
- Earlier slave information was made available by slave specific filter routines
  in chan->private field. Now, this information would be passed from within dmac
  DT node. Slave drivers would now be required to pass bus_id (a string) as
  parameter to this generic filter(), which would be compared against the slave
  data passed from DT, by the generic filter routine.
- Update binding document

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 Documentation/devicetree/bindings/dma/snps-dma.txt |  44 ++++++
 drivers/dma/dw_dmac.c                              | 147 +++++++++++++++++++++
 drivers/dma/dw_dmac_regs.h                         |   4 +
 include/linux/dw_dmac.h                            |  43 +++---
 4 files changed, 221 insertions(+), 17 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/snps-dma.txt b/Documentation/devicetree/bindings/dma/snps-dma.txt
index c0d85db..5bb3dfb 100644
--- a/Documentation/devicetree/bindings/dma/snps-dma.txt
+++ b/Documentation/devicetree/bindings/dma/snps-dma.txt
@@ -6,6 +6,26 @@ Required properties:
 - interrupt-parent: Should be the phandle for the interrupt controller
   that services interrupts for this device
 - interrupt: Should contain the DMAC interrupt number
+- nr_channels: Number of channels supported by hardware
+- is_private: The device channels should be marked as private and not for by the
+  general purpose DMA channel allocator. False if not passed.
+- chan_allocation_order: order of allocation of channel, 0 (default): ascending,
+  1: descending
+- chan_priority: priority of channels. 0 (default): increase from chan 0->n, 1:
+  increase from chan n->0
+- block_size: Maximum block size supported by the controller
+- nr_masters: Number of AHB masters supported by the controller
+- data_width: Maximum data width supported by hardware per AHB master
+  (0 - 8bits, 1 - 16bits, ..., 5 - 256bits)
+- slave_info:
+	- bus_id: name of this device channel, not just a device name since
+	  devices may have more than one channel e.g. "foo_tx". For using the
+	  dw_generic_filter(), slave drivers must pass exactly this string as
+	  param to filter function.
+	- cfg_hi: Platform-specific initializer for the CFG_HI register
+	- cfg_lo: Platform-specific initializer for the CFG_LO register
+	- src_master: src master for transfers on allocated channel.
+	- dst_master: dest master for transfers on allocated channel.
 
 Example:
 
@@ -14,4 +34,28 @@ Example:
 		reg = <0xfc000000 0x1000>;
 		interrupt-parent = <&vic1>;
 		interrupts = <12>;
+
+		nr_channels = <8>;
+		chan_allocation_order = <1>;
+		chan_priority = <1>;
+		block_size = <0xfff>;
+		nr_masters = <2>;
+		data_width = <3 3 0 0>;
+
+		slave_info {
+			uart0-tx {
+				bus_id = "uart0-tx";
+				cfg_hi = <0x4000>;	/* 0x8 << 11 */
+				cfg_lo = <0>;
+				src_master = <0>;
+				dst_master = <1>;
+			};
+			spi0-tx {
+				bus_id = "spi0-tx";
+				cfg_hi = <0x2000>;	/* 0x4 << 11 */
+				cfg_lo = <0>;
+				src_master = <0>;
+				dst_master = <0>;
+			};
+		};
 	};
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index c4b0eb3..9a7d084 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1179,6 +1179,58 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	dev_vdbg(chan2dev(chan), "%s: done\n", __func__);
 }
 
+bool dw_generic_filter(struct dma_chan *chan, void *param)
+{
+	struct dw_dma *dw = to_dw_dma(chan->device);
+	static struct dw_dma *last_dw;
+	static char *last_bus_id;
+	int found = 0, i = -1;
+
+	/*
+	 * dmaengine framework calls this routine for all channels of all dma
+	 * controller, until true is returned. If 'param' bus_id is not
+	 * registered with a dma controller (dw), then there is no need of
+	 * running below function for all channels of dw.
+	 *
+	 * This block of code does this by saving the parameters of last
+	 * failure. If dw and param are same, i.e. trying on same dw with
+	 * different channel, return false.
+	 */
+	if (last_dw) {
+		if ((last_bus_id == param) && (last_dw == dw))
+			return false;
+	}
+
+	/*
+	 * Return true:
+	 * - If dw_dma's platform data is not filled with slave info, then all
+	 *   dma controllers are fine for transfer.
+	 * - Or if param is NULL
+	 */
+	if (!dw->sd || !param)
+		return true;
+
+	while (++i < dw->sd_count) {
+		if (!strcmp(dw->sd[i].bus_id, param)) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found) {
+		last_dw = dw;
+		last_bus_id = param;
+		return false;
+	}
+
+	chan->private = &dw->sd[i];
+	last_dw = NULL;
+	last_bus_id = NULL;
+
+	return true;
+}
+EXPORT_SYMBOL(dw_generic_filter);
+
 /* --------------------- Cyclic DMA API extensions -------------------- */
 
 /**
@@ -1462,6 +1514,96 @@ static void dw_dma_off(struct dw_dma *dw)
 		dw->chan[i].initialized = false;
 }
 
+#ifdef CONFIG_OF
+static struct dw_dma_platform_data *
+__devinit dw_dma_parse_dt(struct platform_device *pdev)
+{
+	struct device_node *sn, *cn, *np = pdev->dev.of_node;
+	struct dw_dma_platform_data *pdata;
+	struct dw_dma_slave *sd;
+	u32 count, val, arr[4];
+
+	if (!np) {
+		dev_err(&pdev->dev, "Missing DT data\n");
+		return NULL;
+	}
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	if (of_property_read_u32(np, "nr_channels", &pdata->nr_channels))
+		return NULL;
+
+	if (of_property_read_bool(np, "is_private"))
+		pdata->is_private = true;
+
+	if (!of_property_read_u32(np, "chan_allocation_order",
+				&val))
+		pdata->chan_allocation_order = (unsigned char)val;
+
+	if (!of_property_read_u32(np, "chan_priority", &val))
+		pdata->chan_priority = (unsigned char)val;
+
+	if (!of_property_read_u32(np, "block_size", &val))
+		pdata->block_size = (unsigned short)val;
+
+	if (!of_property_read_u32(np, "nr_masters", &val)) {
+		if (val > 4)
+			return NULL;
+
+		pdata->nr_masters = (unsigned char)val;
+	}
+
+	if (!of_property_read_u32_array(np, "data_width", arr,
+				pdata->nr_masters))
+		for (count = 0; count < pdata->nr_masters; count++)
+			pdata->data_width[count] = arr[count];
+
+	/* parse slave data */
+	sn = of_find_node_by_name(np, "slave_info");
+	if (!sn)
+		return pdata;
+
+	count = 0;
+	/* calculate number of slaves */
+	for_each_child_of_node(sn, cn)
+		count++;
+
+	if (!count)
+		return NULL;
+
+	sd = devm_kzalloc(&pdev->dev, sizeof(*sd) * count, GFP_KERNEL);
+	if (!sd)
+		return NULL;
+
+	count = 0;
+	for_each_child_of_node(sn, cn) {
+		of_property_read_string(cn, "bus_id", &sd[count].bus_id);
+		of_property_read_u32(cn, "cfg_hi", &sd[count].cfg_hi);
+		of_property_read_u32(cn, "cfg_lo", &sd[count].cfg_lo);
+		if (!of_property_read_u32(cn, "src_master", &val))
+			sd[count].src_master = (u8)val;
+
+		if (!of_property_read_u32(cn, "dst_master", &val))
+			sd[count].dst_master = (u8)val;
+
+		sd[count].dma_dev = &pdev->dev;
+		count++;
+	}
+
+	pdata->sd = sd;
+	pdata->sd_count = count;
+
+	return pdata;
+}
+#else
+static inline int dw_dma_parse_dt(struct platform_device *pdev)
+{
+	return -ENOSYS;
+}
+#endif
+
 static int __devinit dw_probe(struct platform_device *pdev)
 {
 	struct dw_dma_platform_data *pdata;
@@ -1478,6 +1620,9 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	int			i;
 
 	pdata = dev_get_platdata(&pdev->dev);
+	if (!pdata)
+		pdata = dw_dma_parse_dt(pdev);
+
 	if (!pdata || pdata->nr_channels > DW_DMA_MAX_NR_CHANNELS)
 		return -EINVAL;
 
@@ -1512,6 +1657,8 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	clk_prepare_enable(dw->clk);
 
 	dw->regs = regs;
+	dw->sd = pdata->sd;
+	dw->sd_count = pdata->sd_count;
 
 	/* get hardware configuration parameters */
 	if (autocfg) {
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index ff39fa6..5cc61ba 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -231,6 +231,10 @@ struct dw_dma {
 	struct tasklet_struct	tasklet;
 	struct clk		*clk;
 
+	/* slave information */
+	struct dw_dma_slave	*sd;
+	unsigned int		sd_count;
+
 	u8			all_chan_mask;
 
 	/* hardware configuration */
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index 62a6190..4d1c8c3 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -15,6 +15,26 @@
 #include <linux/dmaengine.h>
 
 /**
+ * struct dw_dma_slave - Controller-specific information about a slave
+ *
+ * @dma_dev: required DMA master device. Depricated.
+ * @bus_id: name of this device channel, not just a device name since
+ *          devices may have more than one channel e.g. "foo_tx"
+ * @cfg_hi: Platform-specific initializer for the CFG_HI register
+ * @cfg_lo: Platform-specific initializer for the CFG_LO register
+ * @src_master: src master for transfers on allocated channel.
+ * @dst_master: dest master for transfers on allocated channel.
+ */
+struct dw_dma_slave {
+	struct device		*dma_dev;
+	const char		*bus_id;
+	u32			cfg_hi;
+	u32			cfg_lo;
+	u8			src_master;
+	u8			dst_master;
+};
+
+/**
  * struct dw_dma_platform_data - Controller configuration parameters
  * @nr_channels: Number of channels supported by hardware (max 8)
  * @is_private: The device channels should be marked as private and not for
@@ -25,6 +45,8 @@
  * @nr_masters: Number of AHB masters supported by the controller
  * @data_width: Maximum data width supported by hardware per AHB master
  *		(0 - 8bits, 1 - 16bits, ..., 5 - 256bits)
+ * @sd: slave specific data. Used for configuring channels
+ * @sd_count: count of slave data structures passed.
  */
 struct dw_dma_platform_data {
 	unsigned int	nr_channels;
@@ -38,6 +60,9 @@ struct dw_dma_platform_data {
 	unsigned short	block_size;
 	unsigned char	nr_masters;
 	unsigned char	data_width[4];
+
+	struct dw_dma_slave *sd;
+	unsigned int sd_count;
 };
 
 /* bursts size */
@@ -52,23 +77,6 @@ enum dw_dma_msize {
 	DW_DMA_MSIZE_256,
 };
 
-/**
- * struct dw_dma_slave - Controller-specific information about a slave
- *
- * @dma_dev: required DMA master device
- * @cfg_hi: Platform-specific initializer for the CFG_HI register
- * @cfg_lo: Platform-specific initializer for the CFG_LO register
- * @src_master: src master for transfers on allocated channel.
- * @dst_master: dest master for transfers on allocated channel.
- */
-struct dw_dma_slave {
-	struct device		*dma_dev;
-	u32			cfg_hi;
-	u32			cfg_lo;
-	u8			src_master;
-	u8			dst_master;
-};
-
 /* Platform-configurable bits in CFG_HI */
 #define DWC_CFGH_FCMODE		(1 << 0)
 #define DWC_CFGH_FIFO_MODE	(1 << 1)
@@ -106,5 +114,6 @@ void dw_dma_cyclic_stop(struct dma_chan *chan);
 dma_addr_t dw_dma_get_src_addr(struct dma_chan *chan);
 
 dma_addr_t dw_dma_get_dst_addr(struct dma_chan *chan);
+bool dw_generic_filter(struct dma_chan *chan, void *param);
 
 #endif /* DW_DMAC_H */
-- 
1.7.12.rc2.18.g61b472e


