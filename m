Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030794Ab2CNNMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 09:12:09 -0400
Received: from mail4.ccl.ru ([195.222.140.73]:59095 "EHLO mail4.ccl.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964930Ab2CNNME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 09:12:04 -0400
X-Greylist: delayed 652 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2012 09:12:03 EDT
From: Mike Sinkovsky <msink@permonline.ru>
To: linux-netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mike Sinkovsky <msink@permonline.ru>
Subject: [PATCH] Ethernet driver for the WIZnet W5300 chip
Date: Wed, 14 Mar 2012 18:00:35 +0500
Message-Id: <1331730035-11183-1-git-send-email-msink@permonline.ru>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on original driver from chip manufacturer, with many cleanups.
Hope now it is near to mainline kernel quality, but definitely need more
tuning. Any comments welcome.

Tested and used in production with Blackfin BF531 embedded processor.

Signed-off-by: Mike Sinkovsky <msink@permonline.ru>
---
 drivers/net/ethernet/Kconfig         |    1 +
 drivers/net/ethernet/Makefile        |    1 +
 drivers/net/ethernet/wiznet/Kconfig  |   45 +++
 drivers/net/ethernet/wiznet/Makefile |    1 +
 drivers/net/ethernet/wiznet/w5300.c  |  593 ++++++++++++++++++++++++++++++++++
 5 files changed, 641 insertions(+), 0 deletions(-)
 create mode 100755 drivers/net/ethernet/wiznet/Kconfig
 create mode 100755 drivers/net/ethernet/wiznet/Makefile
 create mode 100644 drivers/net/ethernet/wiznet/w5300.c

diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index 3474a61..e87313f 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -173,6 +173,7 @@ source "drivers/net/ethernet/tile/Kconfig"
 source "drivers/net/ethernet/toshiba/Kconfig"
 source "drivers/net/ethernet/tundra/Kconfig"
 source "drivers/net/ethernet/via/Kconfig"
+source "drivers/net/ethernet/wiznet/Kconfig"
 source "drivers/net/ethernet/xilinx/Kconfig"
 source "drivers/net/ethernet/xircom/Kconfig"
 
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index 08d5f03..d24db66 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -72,5 +72,6 @@ obj-$(CONFIG_TILE_NET) += tile/
 obj-$(CONFIG_NET_VENDOR_TOSHIBA) += toshiba/
 obj-$(CONFIG_NET_VENDOR_TUNDRA) += tundra/
 obj-$(CONFIG_NET_VENDOR_VIA) += via/
+obj-$(CONFIG_NET_VENDOR_WIZNET) += wiznet/
 obj-$(CONFIG_NET_VENDOR_XILINX) += xilinx/
 obj-$(CONFIG_NET_VENDOR_XIRCOM) += xircom/
diff --git a/drivers/net/ethernet/wiznet/Kconfig b/drivers/net/ethernet/wiznet/Kconfig
new file mode 100755
index 0000000..b565441
--- /dev/null
+++ b/drivers/net/ethernet/wiznet/Kconfig
@@ -0,0 +1,45 @@
+#
+# WIZnet device configuration
+#
+
+config NET_VENDOR_WIZNET
+	bool "WIZnet devices"
+	default y
+	---help---
+	  If you have a network (Ethernet) card belonging to this class, say Y
+	  and read the Ethernet-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about WIZnet devices. If you say Y, you will be asked 
+	  for your specific card in the following questions.
+
+if NET_VENDOR_WIZNET
+
+config WIZNET_W5300
+	tristate "WIZnet W5300 Ethernet support"
+	depends on ARM || BLACKFIN
+	---help---
+	  Support for WIZnet W5300 chips.
+
+	  W5300 is a single chip with integrated 10/100 Ethernet MAC, PHY
+	  and hardware TCP/IP stack, but this driver is limited to the 
+	  MAC and PHY functions only, onchip TCP/IP is unused.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called w5300.
+
+choice
+	prompt "WIZnet interface mode"
+	depends on NET_VENDOR_WIZNET
+	default WIZNET_BUS_INDIRECT
+
+config WIZNET_BUS_DIRECT
+	bool "Direct address bus mode"
+
+config WIZNET_BUS_INDIRECT
+	bool "Indirect address bus mode"
+endchoice
+
+endif # NET_VENDOR_WIZNET
diff --git a/drivers/net/ethernet/wiznet/Makefile b/drivers/net/ethernet/wiznet/Makefile
new file mode 100755
index 0000000..88e0a3e
--- /dev/null
+++ b/drivers/net/ethernet/wiznet/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_WIZNET_W5300) += w5300.o
diff --git a/drivers/net/ethernet/wiznet/w5300.c b/drivers/net/ethernet/wiznet/w5300.c
new file mode 100644
index 0000000..49f7b82
--- /dev/null
+++ b/drivers/net/ethernet/wiznet/w5300.c
@@ -0,0 +1,593 @@
+/*
+ * Ethernet driver for the WIZnet W5300 chip.
+ *
+ * Copyright (C) 2008-2009 WIZnet Co.,Ltd.
+ * Copyright (C) 2011 Taehun Kim <kth3321 <at> gmail.com>
+ * Copyright (C) 2012 Mike Sinkovsky
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/platform_device.h>
+
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/ioport.h>
+#include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+
+/*
+ * Frame size is hardwired to 1514 bytes,
+ * and MTU for 802.1Q frames must me set to 1496
+ */
+#define W5300_FRAME_SIZE	1514
+
+/*
+ * Device driver private data structure
+ */
+struct dev_private {
+	struct net_device *ndev;
+	void __iomem *base;
+	bool promisc_mode;
+	spinlock_t reg_lock;
+	struct napi_struct napi;
+};
+
+/***********************************************
+ * Lowlevel I/O functions
+ */
+
+#if defined(CONFIG_WIZNET_BUS_DIRECT)
+/*
+ * In direct address mode host system can directly access W5300 registers
+ * after mapping to Memory-mapped I/O Space.
+ *
+ * 0x400 bytes are required for memory space.
+ */
+
+static inline u16
+read_reg_u16(struct dev_private *priv, u16 addr)
+{
+	return ioread16(priv->base + addr);
+}
+
+static inline void
+write_reg_u16(struct dev_private *priv, u16 addr, u16 data)
+{
+	iowrite16(data, priv->base + addr);
+	mmiowb();
+}
+
+#elif defined(CONFIG_WIZNET_BUS_INDIRECT)
+/*
+ * In indirect address mode host system indirectly accesses registers by
+ * using Indirect Mode Address Register (IDM_AR) and Indirect Mode Data
+ * Register (IDM_DR), which are directly mapped to Memory-mapped I/O Space.
+ * Mode Register (MR) is directly accessible.
+ *
+ * Only 0x06 bytes are required for memory space.
+ */
+#define IDM_MR	0x00	/* Mode Register offset */
+#define IDM_AR	0x02	/* Indirect Mode Address Register offset */
+#define IDM_DR	0x04	/* Indirect Mode Data Register offset */
+
+static inline u16
+read_reg_u16(struct dev_private *priv, u16 addr)
+{
+	unsigned long flags;
+	u16 data;
+
+	spin_lock_irqsave(&priv->reg_lock, flags);
+	iowrite16(addr, priv->base + IDM_AR);
+	mmiowb();
+	data = ioread16(priv->base + IDM_DR);
+	spin_unlock_irqrestore(&priv->reg_lock, flags);
+
+	return data;
+}
+
+static inline void
+write_reg_u16(struct dev_private *priv, u16 addr, u16 data)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->reg_lock, flags);
+	iowrite16(addr, priv->base + IDM_AR);
+	mmiowb();
+	iowrite16(data, priv->base + IDM_DR);
+	mmiowb();
+	spin_unlock_irqrestore(&priv->reg_lock, flags);
+}
+
+#else
+#error unknown interface mode!
+#endif
+
+static inline u32
+read_reg_u32(struct dev_private *priv, u16 addr)
+{
+	u32 data;
+	data  = read_reg_u16(priv, addr) << 16;
+	data |= read_reg_u16(priv, addr + 2);
+	return data;
+}
+
+static inline void
+write_reg_u32(struct dev_private *priv, u16 addr, u32 data)
+{
+	write_reg_u16(priv, addr, data >> 16);
+	write_reg_u16(priv, addr + 2, data);
+}
+
+static void write_MR(struct dev_private *priv, u16 data)
+{
+	iowrite16(data, priv->base);
+	mmiowb();
+}
+
+#define DEFINE_REG_RD(ADDR, TYPE, NAME) \
+static inline TYPE read_##NAME(struct dev_private *priv) \
+{ \
+	return read_reg_##TYPE(priv, ADDR); \
+}
+#define DEFINE_REG_WR(ADDR, TYPE, NAME) \
+static inline void write_##NAME(struct dev_private *priv, TYPE data)		      \
+{ \
+	write_reg_##TYPE(priv, ADDR, data); \
+}
+#define DEFINE_REG_RW(ADDR, TYPE, NAME) \
+	DEFINE_REG_RD(ADDR, TYPE, NAME) \
+	DEFINE_REG_WR(ADDR, TYPE, NAME)
+
+DEFINE_REG_RW(0x002, u16, IR)		/* Interrupt Register */
+DEFINE_REG_WR(0x004, u16, IMR)		/* Interrupt Mask Register */
+DEFINE_REG_WR(0x008, u32, SHARL)	/* Source MAC address (0123) */
+DEFINE_REG_WR(0x00c, u16, SHARH)	/* Source MAC address (45) */
+DEFINE_REG_WR(0x020, u32, TMSRL)	/* Transmit Memory Size (0123) */
+DEFINE_REG_WR(0x024, u32, TMSRH)	/* Transmit Memory Size (4567) */
+DEFINE_REG_WR(0x028, u32, RMSRL)	/* Receive Memory Size (0123) */
+DEFINE_REG_WR(0x02c, u32, RMSRH)	/* Receive Memory Size (4567) */
+DEFINE_REG_WR(0x030, u16, MTYPE)	/* Memory Type */
+DEFINE_REG_RD(0x0fe, u16, IDR)		/* Chip ID register (=0x5300) */
+DEFINE_REG_WR(0x200, u16, S0MR)		/* S0 Mode Register */
+DEFINE_REG_RW(0x202, u16, S0CR)		/* S0 Command Register */
+DEFINE_REG_WR(0x204, u16, S0IMR)	/* S0 Interrupt Mask Register */
+DEFINE_REG_RW(0x206, u16, S0IR)		/* S0 Interrupt Register */
+DEFINE_REG_RD(0x208, u16, S0SSR)	/* S0 Socket Status Register */
+DEFINE_REG_WR(0x220, u32, S0TXWRSR)	/* S0 Transmit Size Register */
+DEFINE_REG_RD(0x228, u32, S0RXRSR)	/* S0 Received data Size */
+DEFINE_REG_WR(0x22e, u16, S0TXFIFO)	/* S0 Transmit FIFO */
+DEFINE_REG_RD(0x230, u16, S0RXFIFO)	/* S0 Receive FIFO */
+
+/* Mode Register values */
+#define MR_DBW		(1 << 15)	/* Data bus width */
+#define MR_MPF		(1 << 14)	/* Mac layer pause frame */
+#define MR_WDF(n)	(n << 11)	/* Write data fetch time */
+#define MR_RDH		(1 << 10)	/* Read data hold time */
+#define MR_FS		(1 << 8)	/* FIFO swap */
+#define MR_RST		(1 << 7)	/* S/W reset */
+#define MR_PB		(1 << 4)	/* Ping block */
+#define MR_DBS		(1 << 2)	/* Data bus swap */
+#define MR_IND		(1 << 0)	/* Indirect mode */
+
+#ifdef CONFIG_WIZNET_BUS_INDIRECT
+#define MR_VALUE	(MR_WDF(7) | MR_PB | MR_IND)
+#else
+#define MR_VALUE	(MR_WDF(7) | MR_PB)
+#endif
+
+/* IR/IMR register values */
+#define IR_S0		0x01		/* S0 interrupt */
+
+/* S0MR register values */
+#define S0MR_CLOSE	0x00		/* Close mode */
+#define S0MR_MACRAW	0x04		/* MAC RAW mode (promiscous) */
+#define S0MR_MACRAW_MF	0x44		/* MAC RAW mode (filtered) */
+
+/* S0CR register values */
+#define S0CR_OPEN	0x01		/* OPEN command */
+#define S0CR_CLOSE	0x10		/* CLOSE command */
+#define S0CR_SEND	0x20		/* SEND command */
+#define S0CR_RECV	0x40		/* RECV command */
+
+/* S0IR/S0IMR register values */
+#define S0IR_RECV	0x04		/* Receive interrupt */
+
+static int read_fifo(struct dev_private *priv, u8 *data, int len)
+{
+	if (unlikely(!data)) {
+		for (; len > 0; len -= 2)
+			read_S0RXFIFO(priv);
+		return 0;
+	}
+
+	for (; len > 0; len -= 2) {
+		u16 fifo = read_S0RXFIFO(priv);
+		*data++ = fifo >> 8;
+		*data++ = fifo;
+	}
+
+	return 0;
+}
+
+static int write_fifo(struct dev_private *priv, u8 *data, int len)
+{
+	for (; len > 0; len -= 2) {
+		u16 fifo = *data++ << 8;
+		fifo	|= *data++;
+		write_S0TXFIFO(priv, fifo);
+	}
+
+	return 0;
+}
+
+static void write_macaddr(struct dev_private *priv)
+{
+	struct net_device *ndev = priv->ndev;
+	write_SHARL(priv, ndev->dev_addr[0] << 24 |
+			  ndev->dev_addr[1] << 16 |
+			  ndev->dev_addr[2] << 8 |
+			  ndev->dev_addr[3]);
+	write_SHARH(priv, ndev->dev_addr[4] << 8 |
+			  ndev->dev_addr[5]);
+}
+
+static void reset_chip(struct dev_private *priv)
+{
+	write_MR(priv, MR_RST);
+	mdelay(5);
+	write_MR(priv, MR_VALUE);
+
+	write_IMR(priv, 0);
+
+	write_RMSRL(priv, 64 << 24);
+	write_RMSRH(priv, 0);
+	write_TMSRL(priv, 64 << 24);
+	write_TMSRH(priv, 0);
+	write_MTYPE(priv, 0x00ff);
+
+	write_macaddr(priv);
+}
+
+static inline int send_command(struct dev_private *priv, u16 cmd)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(100);
+
+	write_S0CR(priv, cmd);
+
+	while (read_S0CR(priv) != 0) {
+		if (time_after(jiffies, timeout))
+			return -EIO;
+		cpu_relax();
+	}
+
+	return 0;
+}
+
+/***********************************************
+ * Device driver functions / callbacks
+ */
+
+static void w5300_tx_timeout(struct net_device *ndev)
+{
+	struct dev_private *priv = netdev_priv(ndev);
+
+	netdev_err(ndev, "Transmit timeout!\n");
+
+	ndev->stats.tx_errors++;
+	reset_chip(priv);
+	netif_wake_queue(ndev);
+}
+
+static int w5300_start_tx(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct dev_private *priv = netdev_priv(ndev);
+	int err;
+
+	err = write_fifo(priv, skb->data, skb->len);
+	if (unlikely(err)) {
+		ndev->stats.tx_dropped++;
+		return NETDEV_TX_BUSY;
+	}
+
+	write_S0TXWRSR(priv, skb->len);
+	send_command(priv, S0CR_SEND);
+
+	ndev->stats.tx_packets++;
+	ndev->stats.tx_bytes += skb->len;
+	dev_kfree_skb(skb);
+
+	return NETDEV_TX_OK;
+}
+
+static int w5300_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct dev_private *priv = container_of(napi, struct dev_private, napi);
+	struct net_device *ndev = priv->ndev;
+	struct sk_buff *skb;
+	u16 frame_size;
+	int rx_count;
+
+	for (rx_count = 0; rx_count < budget; rx_count++) {
+		u32 fifo_size = read_S0RXRSR(priv);
+		if (fifo_size == 0)
+			break;
+
+		frame_size = read_S0RXFIFO(priv);
+
+		skb = netdev_alloc_skb(ndev, NET_IP_ALIGN +
+					     roundup(frame_size + 4, 2));
+		if (unlikely(!skb)) {
+			read_fifo(priv, NULL, frame_size + 4);
+			ndev->stats.rx_dropped++;
+			return -ENOMEM;
+		}
+
+		skb_reserve(skb, NET_IP_ALIGN);
+		skb_put(skb, frame_size);
+		read_fifo(priv, skb->data, frame_size + 4);
+
+		skb->protocol = eth_type_trans(skb, ndev);
+		netif_receive_skb(skb);
+		ndev->stats.rx_packets++;
+		ndev->stats.rx_bytes += frame_size;
+	}
+
+	if (rx_count < budget) {
+		write_IMR(priv, IR_S0);
+		napi_complete(napi);
+	}
+
+	return rx_count;
+}
+
+static irqreturn_t w5300_start_rx(int irq, void *ndev_instance)
+{
+	struct net_device *ndev = ndev_instance;
+	struct dev_private *priv = netdev_priv(ndev);
+
+	write_S0IR(priv, S0IR_RECV);
+
+	if (napi_schedule_prep(&priv->napi)) {
+		write_IMR(priv, 0);
+		__napi_schedule(&priv->napi);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void w5300_set_rx_mode(struct net_device *ndev)
+{
+	struct dev_private *priv = netdev_priv(ndev);
+
+	if (priv->promisc_mode == !!(ndev->flags & IFF_PROMISC))
+		return;
+
+	priv->promisc_mode = !!(ndev->flags & IFF_PROMISC);
+	write_S0MR(priv, priv->promisc_mode ? S0MR_MACRAW : S0MR_MACRAW_MF);
+	send_command(priv, S0CR_OPEN);
+}
+
+static int w5300_set_macaddr(struct net_device *ndev, void *addr)
+{
+	struct dev_private *priv = netdev_priv(ndev);
+	struct sockaddr *sock_addr = addr;
+
+	if (is_multicast_ether_addr(sock_addr->sa_data))
+		return -EADDRNOTAVAIL;
+
+	memcpy(ndev->dev_addr, sock_addr->sa_data, ETH_ALEN);
+	write_macaddr(priv);
+
+	return 0;
+}
+
+static int w5300_open(struct net_device *ndev)
+{
+	struct dev_private *priv = netdev_priv(ndev);
+	int mode = priv->promisc_mode ? S0MR_MACRAW : S0MR_MACRAW_MF;
+
+	if (!is_valid_ether_addr(ndev->dev_addr))
+		return -EINVAL;
+
+	write_S0IMR(priv, S0IR_RECV);
+	write_S0MR(priv, mode);
+	send_command(priv, S0CR_OPEN);
+	write_IMR(priv, IR_S0);
+
+	napi_enable(&priv->napi);
+	netif_start_queue(ndev);
+	netif_carrier_on(ndev);
+
+	return 0;
+}
+
+static int w5300_stop(struct net_device *ndev)
+{
+	struct dev_private *priv = netdev_priv(ndev);
+
+	write_IMR(priv, 0);
+	write_S0CR(priv, S0CR_CLOSE);
+
+	netif_carrier_off(ndev);
+	netif_stop_queue(ndev);
+	napi_disable(&priv->napi);
+
+	return 0;
+}
+
+static const struct net_device_ops netdev_ops = {
+	.ndo_open		= w5300_open,
+	.ndo_stop		= w5300_stop,
+	.ndo_start_xmit		= w5300_start_tx,
+	.ndo_tx_timeout		= w5300_tx_timeout,
+	.ndo_set_rx_mode	= w5300_set_rx_mode,
+	.ndo_set_mac_address	= w5300_set_macaddr,
+	.ndo_change_mtu		= eth_change_mtu,
+	.ndo_validate_addr	= eth_validate_addr,
+};
+
+static int __devinit w5300_probe(struct platform_device *pdev)
+{
+	struct net_device *ndev;
+	struct dev_private *priv;
+	struct resource *mem;
+	void __iomem *mem_base;
+	int mem_size;
+	int irq;
+	int err;
+
+	ndev = alloc_etherdev(sizeof(*priv));
+	if (!ndev) {
+		err = -ENOMEM;
+		goto err_do_devfree;
+	}
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	irq = platform_get_irq(pdev, 0);
+	if (!mem || irq < 0) {
+		err = -ENXIO;
+		goto err_do_devfree;
+	}
+	mem_size = resource_size(mem);
+
+	if (!request_mem_region(mem->start, mem_size, KBUILD_MODNAME)) {
+		err = -EBUSY;
+		goto err_do_devfree;
+	}
+	mem_base = ioremap(mem->start, mem_size);
+	if (!mem_base) {
+		err = -ENOMEM;
+		goto err_do_memrelease;
+	}
+
+	SET_NETDEV_DEV(ndev, &pdev->dev);
+	platform_set_drvdata(pdev, ndev);
+	priv = netdev_priv(ndev);
+	priv->ndev = ndev;
+	priv->base = mem_base;
+	priv->promisc_mode = false;
+	spin_lock_init(&priv->reg_lock);
+
+	ndev->mem_start = mem->start;
+	ndev->mem_end = mem->start + mem_size - 1;
+	ndev->irq = irq;
+	ndev->netdev_ops = &netdev_ops;
+	ndev->watchdog_timeo = 2 * HZ;
+	ether_setup(ndev);
+	dev_hw_addr_random(ndev, ndev->dev_addr);
+
+	reset_chip(priv);
+	if (read_IDR(priv) != 0x5300) {
+		err = -ENODEV;
+		goto err_do_iounmap;
+	}
+
+	err = request_irq(ndev->irq, w5300_start_rx,
+			  IRQ_TYPE_LEVEL_LOW, ndev->name, ndev);
+	if (err)
+		goto err_do_iounmap;
+
+	netif_napi_add(ndev, &priv->napi, w5300_napi_poll, 16);
+	err = register_netdev(ndev);
+	if (err)
+		goto err_do_irqfree;
+
+	netdev_info(ndev, "at 0x%lX irq %d\n", ndev->mem_start, ndev->irq);
+	return 0;
+
+err_do_irqfree:
+	free_irq(ndev->irq, ndev);
+err_do_iounmap:
+	iounmap(mem_base);
+err_do_memrelease:
+	release_mem_region(mem->start, resource_size(mem));
+err_do_devfree:
+	free_netdev(ndev);
+	platform_set_drvdata(pdev, NULL);
+	return err;
+}
+
+static int __devexit w5300_remove(struct platform_device *pdev)
+{
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct dev_private *priv = netdev_priv(ndev);
+
+	platform_set_drvdata(pdev, NULL);
+	unregister_netdev(ndev);
+
+	iounmap(priv->base);
+	release_mem_region(ndev->mem_start,
+			   ndev->mem_end - ndev->mem_start + 1);
+	free_irq(ndev->irq, ndev);
+
+	free_netdev(ndev);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int w5300_suspend(struct platform_device *pdev, pm_message_t mesg)
+{
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct dev_private *priv = netdev_priv(ndev);
+
+	if (netif_running(ndev)) {
+		netif_carrier_off(ndev);
+		netif_device_detach(ndev);
+
+		write_IMR(priv, 0);
+		send_command(priv, S0CR_CLOSE);
+	}
+
+	return 0;
+}
+
+static int w5300_resume(struct platform_device *pdev)
+{
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct dev_private *priv = netdev_priv(ndev);
+	int mode = priv->promisc_mode ? S0MR_MACRAW : S0MR_MACRAW_MF;
+
+	if (netif_running(ndev)) {
+		reset_chip(priv);
+		write_S0MR(priv, mode);
+		send_command(priv, S0CR_OPEN);
+		write_IMR(priv, IR_S0);
+
+		netif_device_attach(ndev);
+		netif_carrier_on(ndev);
+	}
+
+	return 0;
+}
+#endif /* CONFIG_PM */
+
+static struct platform_driver wiznet_w5300_driver = {
+	.driver		= {
+		.name	= KBUILD_MODNAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= w5300_probe,
+	.remove		= __devexit_p(w5300_remove),
+#ifdef CONFIG_PM
+	.suspend	= w5300_suspend,
+	.resume		= w5300_resume,
+#endif
+};
+
+module_platform_driver(wiznet_w5300_driver);
+
+MODULE_ALIAS("platform:" KBUILD_MODNAME);
+MODULE_DESCRIPTION("WIZnet W5300 Ethernet driver");
+MODULE_AUTHOR("Mike Sinkovsky <msink@permonline.ru>");
+MODULE_LICENSE("GPL");
-- 
1.6.3.3


