Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab2HUMTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:19:41 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57976 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320Ab2HUMTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:19:23 -0400
From: Stany MARCEL <stany.marcel@novasys-ingenierie.com>
To: linux-m68k@vger.kernel.org
Cc: geert@linux-m68k.org, linux-kernel@vger.kernel.org,
        Stany MARCEL <stany.marcel@novasys-ingenierie.com>
Subject: [PATCH 3/3] Add support to M54xx DMA FEC Driver
Date: Tue, 21 Aug 2012 14:18:51 +0200
Message-Id: <1345551531-15348-3-git-send-email-stany.marcel@novasys-ingenierie.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345551531-15348-1-git-send-email-stany.marcel@novasys-ingenierie.com>
References: <1345551531-15348-1-git-send-email-stany.marcel@novasys-ingenierie.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stany MARCEL <stany.marcel@novasys-ingenierie.com>
---

 This driver is an adaption of the one given by freescale for kernel 2.6.25.

 Tested with kernel 3.4.8 with arch/m68k backported from linux-m68k head
 2 FEC configured with shared phy

 drivers/net/ethernet/freescale/Kconfig     |   27 +-
 drivers/net/ethernet/freescale/Makefile    |    1 +
 drivers/net/ethernet/freescale/fec_m54xx.c | 1589 ++++++++++++++++++++++++++++
 drivers/net/ethernet/freescale/fec_m54xx.h |  237 +++++
 4 files changed, 1853 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/freescale/fec_m54xx.c
 create mode 100644 drivers/net/ethernet/freescale/fec_m54xx.h

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index 3574e14..cef3c62 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -7,7 +7,8 @@ config NET_VENDOR_FREESCALE
 	default y
 	depends on FSL_SOC || QUICC_ENGINE || CPM1 || CPM2 || PPC_MPC512x || \
 		   M523x || M527x || M5272 || M528x || M520x || M532x || \
-		   ARCH_MXC || ARCH_MXS || (PPC_MPC52xx && PPC_BESTCOMM)
+		   M54xx || ARCH_MXC || ARCH_MXS || \
+		   (PPC_MPC52xx && PPC_BESTCOMM)
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
@@ -53,6 +54,30 @@ config FEC_MPC52xx_MDIO
 	  If not sure, enable.
 	  If compiled as module, it will be called fec_mpc52xx_phy.

+config FEC_M54xx
+	tristate "MCF547x/MCF548x Fast Ethernet Controller support"
+	depends on M54xx
+	select MCD_DMA
+	help
+	  The MCF547x and MCF548x have a built-in Fast Ethernet Controller.
+	  Saying Y here will include support for this device in the kernel.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called fecm.
+
+config FEC_M54xx_ENABLE_FEC2
+	bool "Enable the second FEC"
+	depends on FEC_M54xx
+	help
+	  This enables the second FEC on the 547x/548x. If you want to use
+	  it, say Y.
+
+config FEC_M54xx_SHARED_PHY
+	bool "Shared PHY interface(on some ColdFire designs)"
+	depends on FEC_M54xx_ENABLE_FEC2
+	help
+	  Say Y here if both PHYs are controlled via a single channel.
+
 source "drivers/net/ethernet/freescale/fs_enet/Kconfig"

 config FSL_PQ_MDIO
diff --git a/drivers/net/ethernet/freescale/Makefile b/drivers/net/ethernet/freescale/Makefile
index 1752488..64dba64 100644
--- a/drivers/net/ethernet/freescale/Makefile
+++ b/drivers/net/ethernet/freescale/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_FEC_MPC52xx) += fec_mpc52xx.o
 ifeq ($(CONFIG_FEC_MPC52xx_MDIO),y)
 	obj-$(CONFIG_FEC_MPC52xx) += fec_mpc52xx_phy.o
 endif
+obj-$(CONFIG_FEC_M54xx) += fec_m54xx.o
 obj-$(CONFIG_FS_ENET) += fs_enet/
 obj-$(CONFIG_FSL_PQ_MDIO) += fsl_pq_mdio.o
 obj-$(CONFIG_GIANFAR) += gianfar_driver.o
diff --git a/drivers/net/ethernet/freescale/fec_m54xx.c b/drivers/net/ethernet/freescale/fec_m54xx.c
new file mode 100644
index 0000000..dba1526
--- /dev/null
+++ b/drivers/net/ethernet/freescale/fec_m54xx.c
@@ -0,0 +1,1589 @@
+/*
+ * Copyright 2007-2009 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Author: Kurt Mahan, kmahan@freescale.com
+ *
+ * Copyright 2012 Stany MARCEL <smarcel@novasys-ingenierie.com> Linux
+ * 3.4 port
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/ptrace.h>
+#include <linux/errno.h>
+#include <linux/ioport.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/phy.h>
+#include <linux/delay.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/bitops.h>
+
+#include <asm/coldfire.h>
+#include <asm/mcfsim.h>
+
+#include <asm/dma.h>
+#include <asm/MCD_dma.h>
+#include <asm/m54xxsram.h>
+#include <asm/virtconvert.h>
+#include <asm/irq.h>
+
+#include "fec_m54xx.h"
+
+#ifdef	CONFIG_FEC_M54xx_ENABLE_FEC2
+#define	M54XX_FEC_MAX_PORTS	2
+#define	M54XX_FEC2
+#else
+#define	M54XX_FEC_MAX_PORTS	1
+#undef	M54XX_FEC2
+#endif
+
+#define VERSION "0.20"
+MODULE_DESCRIPTION("DMA Fast Ethernet Controller driver ver " VERSION);
+
+/* fec private */
+struct m54xx_fec_priv {
+	struct net_device *netdev;				/* owning net device */
+	void *txbuf[M54XX_FEC_TX_BUF_NUMBER];			/* tx buffer ptrs */
+	MCD_bufDescFec *txdesc;					/* tx descriptor ptrs */
+	volatile unsigned int current_tx;			/* current tx desc index */
+	volatile unsigned int next_tx;				/* next tx desc index */
+	unsigned int current_rx;				/* current rx desc index */
+	MCD_bufDescFec *rxdesc;					/* rx descriptor ptrs */
+	struct sk_buff *askb_rx[M54XX_FEC_RX_BUF_NUMBER];	/* rx SKB ptrs */
+	unsigned int initiator_rx;				/* rx dma initiator */
+	unsigned int initiator_tx;				/* tx dma initiator */
+	int fec_rx_channel;					/* rx dma channel */
+	int fec_tx_channel;					/* tx dma channel */
+	int rx_requestor;					/* rx dma requestor */
+	int tx_requestor;					/* tx dma requestor */
+	void *interrupt_fec_rx_handler;				/* dma rx handler */
+	void *interrupt_fec_tx_handler;				/* dma tx handler */
+	unsigned char *mac_addr;				/* private fec mac addr */
+	struct net_device_stats stat;				/* stats ptr */
+	spinlock_t lock;
+	int rxflag;
+	struct tasklet_struct tasklet_reinit;
+	int index;						/* fec hw number */
+	struct phy_device *phydev;
+	struct mii_bus *mdio_bus;
+	int  duplex;
+	int  link;
+	int  speed;
+};
+
+struct net_device *m54xx_fec_dev[M54XX_FEC_MAX_PORTS];
+
+/* FEC functions */
+static int __init m54xx_fec_init(void);
+static struct net_device_stats *m54xx_fec_get_stat(struct net_device *dev);
+static int m54xx_fec_open(struct net_device *dev);
+static int m54xx_fec_close(struct net_device *nd);
+static int m54xx_fec_tx(struct sk_buff *skb, struct net_device *dev);
+static void m54xx_fec_set_multicast_list(struct net_device *nd);
+static int m54xx_fec_set_mac_address(struct net_device *dev, void *p);
+static void m54xx_fec_tx_timeout(struct net_device *dev);
+static void m54xx_fec_interrupt_fec_tx_handler(struct net_device *dev);
+static void m54xx_fec_interrupt_fec_rx_handler(struct net_device *dev);
+static irqreturn_t m54xx_fec_interrupt_handler(int irq, void *dev_id);
+static void m54xx_fec_interrupt_fec_tx_handler_fec0(void);
+static void m54xx_fec_interrupt_fec_rx_handler_fec0(void);
+static void m54xx_fec_interrupt_fec_reinit(unsigned long data);
+
+/* default fec0 address */
+unsigned char m54xx_fec_mac_addr_fec0[6] = { 0x00, 0x11, 0x22, 0x33, 0x44, 0x50 };
+
+#ifdef M54XX_FEC2
+/* default fec1 address */
+unsigned char m54xx_fec_mac_addr_fec1[6] = { 0x00, 0x11, 0x22, 0x33, 0x44, 0x51 };
+#endif
+
+extern unsigned char uboot_enet0[];
+extern unsigned char uboot_enet1[];
+
+#ifndef MODULE
+int m54xx_fec_str_to_mac(char *str_mac, unsigned char* addr);
+int __init m54xx_fec_mac_setup0(char *s);
+#endif
+
+
+#ifdef M54XX_FEC2
+void m54xx_fec_interrupt_fec_tx_handler_fec1(void);
+void m54xx_fec_interrupt_fec_rx_handler_fec1(void);
+#endif
+
+#ifndef MODULE
+int __init m54xx_fec_mac_setup1(char *s);
+#endif
+
+module_init(m54xx_fec_init);
+/* module_exit(m54xx_fec_cleanup); */
+
+__setup("mac0=", m54xx_fec_mac_setup0);
+
+#ifdef M54XX_FEC2
+__setup("mac1=", m54xx_fec_mac_setup1);
+#endif
+
+#define mk_mii_read(REG)	(0x60020000 | ((REG & 0x1f) << 18))
+#define mk_mii_write(REG, VAL)	(0x50020000 | ((REG & 0x1f) << 18) |	\
+				 (VAL & 0xffff))
+
+
+static int m54xx_fec_mdio_read(struct mii_bus *bus,
+				  int phy_id, int reg)
+{
+	int ret;
+#ifdef CONFIG_FEC_M54xx_SHARED_PHY
+	unsigned long base_addr = (unsigned long)M54XX_FEC_BASE_ADDR_FEC0;
+#else
+	struct net_device *dev = bus->priv;
+	unsigned long base_addr = (unsigned long) dev->base_addr;
+#endif
+	int tries = 100;
+
+	/* Clear the MII interrupt bit */
+	M54XX_FEC_EIR(base_addr) = M54XX_FEC_EIR_MII;
+
+	/* Write to the MII management frame register */
+	M54XX_FEC_MMFR(base_addr) = mk_mii_read(reg) | (phy_id << 23);
+
+	/* Wait for the reading */
+	while (!(M54XX_FEC_EIR(base_addr) & M54XX_FEC_EIR_MII)) {
+		udelay(10);
+
+		if (!tries) {
+			printk(KERN_ERR "%s timeout\n", __func__);
+			return -ETIMEDOUT;
+		}
+		tries--;
+	}
+
+	/* Clear the MII interrupt bit */
+	M54XX_FEC_EIR(base_addr) = M54XX_FEC_EIR_MII;
+	ret = M54XX_FEC_MMFR(base_addr) & 0x0000FFFF;
+	return ret;
+}
+
+static int m54xx_fec_mdio_write(struct mii_bus *bus,
+				   int phy_id, int reg, u16 data)
+{
+	int ret;
+#ifdef CONFIG_FEC_M54xx_SHARED_PHY
+	unsigned long base_addr = (unsigned long)M54XX_FEC_BASE_ADDR_FEC0;
+#else
+	struct net_device *dev = bus->priv;
+	unsigned long base_addr = (unsigned long) dev->base_addr;
+#endif
+	int tries = 100;
+
+	printk(KERN_ERR "%s base_addr %lx, phy_id %x, reg %x, data %x\n",
+	       __func__, base_addr, phy_id, reg, data);
+	/* Clear the MII interrupt bit */
+	M54XX_FEC_EIR(base_addr) = M54XX_FEC_EIR_MII;
+
+	/*  Write to the MII management frame register */
+	M54XX_FEC_MMFR(base_addr) = mk_mii_write(reg, data) | (phy_id << 23);
+
+	/* Wait for the writing */
+	while (!(M54XX_FEC_EIR(base_addr) & M54XX_FEC_EIR_MII)) {
+		udelay(10);
+		if (!tries) {
+			printk(KERN_ERR "%s timeout\n", __func__);
+			return -ETIMEDOUT;
+		}
+		tries--;
+	}
+	/* Clear the MII interrupt bit */
+	M54XX_FEC_EIR(base_addr) = M54XX_FEC_EIR_MII;
+	ret = M54XX_FEC_MMFR(base_addr) & 0x0000FFFF;
+
+	return ret;
+}
+
+static void m54xx_fec_adjust_link(struct net_device *dev)
+{
+	struct m54xx_fec_priv *priv = netdev_priv(dev);
+	struct phy_device *phydev = priv->phydev;
+	int new_state = 0;
+
+	if (phydev->link != PHY_DOWN) {
+		if (phydev->duplex != priv->duplex) {
+			new_state = 1;
+			priv->duplex = phydev->duplex;
+		}
+
+		if (phydev->speed != priv->speed) {
+			new_state = 1;
+			priv->speed = phydev->speed;
+		}
+
+		if (priv->link == PHY_DOWN) {
+			new_state = 1;
+			priv->link = phydev->link;
+		}
+	} else if (priv->link) {
+		new_state = 1;
+		priv->link = PHY_DOWN;
+		priv->speed = 0;
+		priv->duplex = -1;
+	}
+
+	if (new_state)
+		phy_print_status(phydev);
+}
+
+static int m54xx_fec_init_phy(struct net_device *dev)
+{
+	struct m54xx_fec_priv *priv = netdev_priv(dev);
+	struct phy_device *phydev = NULL;
+	int i;
+	int startnode;
+
+#ifdef CONFIG_FEC_M54xx_SHARED_PHY
+	if (priv->index == 0)
+		startnode = 0;
+	else if (priv->index == 1) {
+		struct m54xx_fec_priv *priv0 = netdev_priv(m54xx_fec_dev[0]);
+		startnode = priv0->phydev->addr + 1;
+	} else
+		startnode = 0;
+#else
+	startnode = 0;
+#endif
+#ifdef M54XX_FEC_DEBUG
+	printk(KERN_ERR "%s priv->index %x, startnode %x\n",
+	       __func__, priv->index, startnode);
+#endif
+	/* search for connect PHY device */
+	for (i = startnode; i < PHY_MAX_ADDR; i++) {
+		struct phy_device *const tmp_phydev =
+			priv->mdio_bus->phy_map[i];
+
+		if (!tmp_phydev) {
+#ifdef M54XX_FEC_DEBUG
+			printk(KERN_INFO "%s no PHY here at"
+			       "mii_bus->phy_map[%d]\n",
+			       __func__, i);
+#endif
+			continue; /* no PHY here... */
+		}
+		phydev = tmp_phydev;
+#ifdef M54XX_FEC_DEBUG
+		printk(KERN_INFO "%s find PHY here at"
+		       "mii_bus->phy_map[%d]\n",
+		       __func__, i);
+#endif
+		break; /* found it */
+	}
+
+	/* now we are supposed to have a proper phydev, to attach to... */
+	if (!phydev) {
+		printk(KERN_INFO "%s: Don't found any phy device at all\n",
+		       dev->name);
+		return -ENODEV;
+	}
+
+	priv->link = 0;
+	priv->speed = 0;
+	priv->duplex = 0;
+#ifdef M54XX_FEC_DEBUG
+	printk(KERN_INFO "%s phydev_busid %s\n", __func__, dev_name(&phydev->dev));
+#endif
+
+	phydev = phy_connect(dev, dev_name(&phydev->dev),
+			     &m54xx_fec_adjust_link,
+			     0,
+			     PHY_INTERFACE_MODE_MII);
+
+	phydev->supported &= (SUPPORTED_10baseT_Half |
+			      SUPPORTED_10baseT_Full |
+			      SUPPORTED_100baseT_Half |
+			      SUPPORTED_100baseT_Full |
+			      SUPPORTED_Autoneg |
+			      SUPPORTED_Pause |
+			      SUPPORTED_MII);
+	phydev->advertising = phydev->supported;
+
+
+
+	if (IS_ERR(phydev)) {
+		printk(KERN_ERR " %s phy_connect failed\n", __func__);
+		return PTR_ERR(phydev);
+	}
+
+	printk(KERN_INFO "M54xx FEC attached phy %i to driver %s %s\n",
+	       phydev->addr,
+	       phydev->drv->name,
+	       dev_name(&phydev->dev));
+	priv->phydev = phydev;
+	return 0;
+}
+
+static int m54xx_fec_mdio_register(struct net_device *dev,
+				   int slot)
+{
+	int err = 0;
+	struct m54xx_fec_priv *fp = netdev_priv(dev);
+
+	fp->mdio_bus = mdiobus_alloc();
+	if (!fp->mdio_bus) {
+		printk(KERN_ERR "ethernet mdiobus_alloc fail\n");
+		return -ENOMEM;
+	}
+
+	if (slot == 0) {
+		fp->mdio_bus->name = "Coldfire FEC MII 0 Bus";
+		strcpy(fp->mdio_bus->id, "0");
+	} else if (slot == 1) {
+		fp->mdio_bus->name = "Coldfire FEC MII 1 Bus";
+		strcpy(fp->mdio_bus->id, "1");
+	} else {
+		printk(KERN_ERR "Now coldfire can not"
+		       "support more than 2 mii bus\n");
+	}
+
+	fp->mdio_bus->read = &m54xx_fec_mdio_read;
+	fp->mdio_bus->write = &m54xx_fec_mdio_write;
+	fp->mdio_bus->priv = dev;
+	err = mdiobus_register(fp->mdio_bus);
+	if (err) {
+		mdiobus_free(fp->mdio_bus);
+		printk(KERN_ERR "%s: ethernet mdiobus_register fail %d\n",
+		       dev->name, err);
+		return -EIO;
+	}
+
+	printk(KERN_INFO "mdiobus_register %s ok\n",
+	       fp->mdio_bus->name);
+	return err;
+}
+
+static const struct net_device_ops m547x_fec_netdev_ops = {
+	.ndo_open = m54xx_fec_open,
+	.ndo_stop = m54xx_fec_close,
+	.ndo_start_xmit = m54xx_fec_tx,
+	.ndo_set_rx_mode = m54xx_fec_set_multicast_list,
+	.ndo_set_mac_address = m54xx_fec_set_mac_address,
+	.ndo_tx_timeout = m54xx_fec_tx_timeout,
+	.ndo_get_stats = m54xx_fec_get_stat,
+};
+
+/**
+ * Initialize a FEC device
+ */
+int m54xx_fec_enet_init(struct net_device *dev, int slot)
+{
+	struct m54xx_fec_priv *fp = netdev_priv(dev);
+	int i;
+
+	fp->index = slot;
+	fp->netdev = dev;
+	m54xx_fec_dev[slot] = dev;
+
+	if (slot == 0) {
+		/* disable fec0 */
+		M54XX_FEC_ECR(M54XX_FEC_BASE_ADDR_FEC0) = M54XX_FEC_ECR_DISABLE;
+
+		/* setup the interrupt handler */
+		dev->irq = 64 + M54XX_ISC_FEC0;
+
+		if (request_irq(dev->irq, m54xx_fec_interrupt_handler,
+				IRQF_DISABLED, "ColdFire FEC 0", dev)) {
+			dev->irq = 0;
+			printk(KERN_ERR "Cannot allocate FEC0 IRQ\n");
+		}
+
+		/* fec base address */
+		dev->base_addr = M54XX_FEC_BASE_ADDR_FEC0;
+
+		/* requestor numbers */
+		fp->rx_requestor = DMA_FEC0_RX;
+		fp->tx_requestor = DMA_FEC0_TX;
+
+		/* m54xx_fec0 handlers */
+		fp->interrupt_fec_rx_handler =
+			m54xx_fec_interrupt_fec_rx_handler_fec0;
+		fp->interrupt_fec_tx_handler =
+			m54xx_fec_interrupt_fec_tx_handler_fec0;
+
+		/* tx descriptors */
+		fp->txdesc = (void *)M54XX_FEC_TX_DESC_FEC0;
+
+		/* rx descriptors */
+		fp->rxdesc = (void *)M54XX_FEC_RX_DESC_FEC0;
+
+		/* mac addr
+		   if (uboot_enet0[0] || uboot_enet0[1] || uboot_enet0[2] ||
+		   uboot_enet0[3] || uboot_enet0[4] || uboot_enet0[5]) {
+		   use uboot enet 0 addr
+		   memcpy(m54xx_fec_mac_addr_fec0, uboot_enet0, 6);
+		   }*/
+		m54xx_fec_mac_addr_fec0[0] =
+			(M54XX_FEC_PALR(M54XX_FEC_BASE_ADDR_FEC0) >> 24) & 0xFF;
+		m54xx_fec_mac_addr_fec0[1] =
+			(M54XX_FEC_PALR(M54XX_FEC_BASE_ADDR_FEC0) >> 16) & 0xFF;
+		m54xx_fec_mac_addr_fec0[2] =
+			(M54XX_FEC_PALR(M54XX_FEC_BASE_ADDR_FEC0) >> 8) & 0xFF;
+		m54xx_fec_mac_addr_fec0[3] =
+			(M54XX_FEC_PALR(M54XX_FEC_BASE_ADDR_FEC0)) & 0xFF;
+		m54xx_fec_mac_addr_fec0[4] =
+			(M54XX_FEC_PAUR(M54XX_FEC_BASE_ADDR_FEC0) >> 24) & 0xFF;
+		m54xx_fec_mac_addr_fec0[5] =
+			(M54XX_FEC_PAUR(M54XX_FEC_BASE_ADDR_FEC0) >> 16) & 0xFF;
+
+		fp->mac_addr = m54xx_fec_mac_addr_fec0;
+	} else {
+		/* disable fec1 */
+		M54XX_FEC_ECR(M54XX_FEC_BASE_ADDR_FEC1) = M54XX_FEC_ECR_DISABLE;
+#ifdef M54XX_FEC2
+		/* setup the interrupt handler */
+		dev->irq = 64 + M54XX_ISC_FEC1;
+
+		if (request_irq(dev->irq, m54xx_fec_interrupt_handler,
+				IRQF_DISABLED, "ColdFire FEC 1", dev)) {
+			dev->irq = 0;
+			printk(KERN_ERR "Cannot allocate FEC1 IRQ\n");
+		}
+
+		/* fec base address */
+		dev->base_addr = M54XX_FEC_BASE_ADDR_FEC1;
+
+		/* requestor numbers */
+		fp->rx_requestor = DMA_FEC1_RX;
+		fp->tx_requestor = DMA_FEC1_TX;
+
+		/* fec1 handlers */
+		fp->interrupt_fec_rx_handler =
+			m54xx_fec_interrupt_fec_rx_handler_fec1;
+		fp->interrupt_fec_tx_handler =
+			m54xx_fec_interrupt_fec_tx_handler_fec1;
+
+		/* tx descriptors */
+		fp->txdesc = (void *)M54XX_FEC_TX_DESC_FEC1;
+
+		/* rx descriptors */
+		fp->rxdesc = (void *)M54XX_FEC_RX_DESC_FEC1;
+
+		/* mac addr
+		   if (uboot_enet1[0] || uboot_enet1[1] || uboot_enet1[2] ||
+		   uboot_enet1[3] || uboot_enet1[4] || uboot_enet1[5]) {
+		   use uboot enet 1 addr
+		   memcpy(m54xx_fec_mac_addr_fec1, uboot_enet1, 6);
+		   }*/
+		m54xx_fec_mac_addr_fec1[0] =
+			(M54XX_FEC_PALR(M54XX_FEC_BASE_ADDR_FEC1) >> 24) & 0xFF;
+		m54xx_fec_mac_addr_fec1[1] =
+			(M54XX_FEC_PALR(M54XX_FEC_BASE_ADDR_FEC1) >> 16) & 0xFF;
+		m54xx_fec_mac_addr_fec1[2] =
+			(M54XX_FEC_PALR(M54XX_FEC_BASE_ADDR_FEC1) >> 8) & 0xFF;
+		m54xx_fec_mac_addr_fec1[3] =
+			(M54XX_FEC_PALR(M54XX_FEC_BASE_ADDR_FEC1)) & 0xFF;
+		m54xx_fec_mac_addr_fec1[4] =
+			(M54XX_FEC_PAUR(M54XX_FEC_BASE_ADDR_FEC1) >> 24) & 0xFF;
+		m54xx_fec_mac_addr_fec1[5] =
+			(M54XX_FEC_PAUR(M54XX_FEC_BASE_ADDR_FEC1) >> 16) & 0xFF;
+
+		fp->mac_addr = m54xx_fec_mac_addr_fec1;
+#endif
+	}
+
+	/* clear MIB */
+	memset((void *) (dev->base_addr + 0x200), 0, M54XX_FEC_MIB_LEN);
+
+	/* clear the statistics structure */
+	memset((void *) &(fp->stat), 0,
+	       sizeof(struct net_device_stats));
+
+	/* grab the FEC initiators */
+	dma_set_initiator(fp->tx_requestor);
+	fp->initiator_tx = dma_get_initiator(fp->tx_requestor);
+	dma_set_initiator(fp->rx_requestor);
+	fp->initiator_rx = dma_get_initiator(fp->rx_requestor);
+
+	/* reset the DMA channels */
+	fp->fec_rx_channel = -1;
+	fp->fec_tx_channel = -1;
+
+	for (i = 0; i < M54XX_FEC_RX_BUF_NUMBER; i++)
+		fp->askb_rx[i] = NULL;
+
+	/* initialize the pointers to the socket buffers */
+	for (i = 0; i < M54XX_FEC_TX_BUF_NUMBER; i++)
+		fp->txbuf[i] = NULL;
+
+	ether_setup(dev);
+
+
+	dev->netdev_ops	= &m547x_fec_netdev_ops;
+	dev->watchdog_timeo = M54XX_FEC_TX_TIMEOUT * HZ;
+
+	memcpy(dev->dev_addr, fp->mac_addr, ETH_ALEN);
+
+	spin_lock_init(&fp->lock);
+
+	/* Initialize FEC/I2C/IRQ Pin Assignment Register*/
+	M54XX_FEC_GPIO_PAR_FECI2CIRQ &= 0xF;
+	M54XX_FEC_GPIO_PAR_FECI2CIRQ |= M54XX_FEC_FECI2CIRQ;
+
+	return 0;
+}
+
+
+/**
+ * Module Initialization
+ */
+int __init m54xx_fec_init(void)
+{
+	struct net_device *dev;
+	int i;
+	int err;
+	struct m54xx_fec_priv *fep;
+
+	printk(KERN_INFO "M54xx FEC ENET (DMA) Version %s\n", VERSION);
+	if (M54XX_FEC_MAX_PORTS > 1)
+	{
+		printk(KERN_INFO "M54xx FEC %d ports\n", M54XX_FEC_MAX_PORTS);
+#ifdef CONFIG_FEC_M54xx_SHARED_PHY
+		printk(KERN_INFO "M54xx FEC Shared PHY\n");
+#endif
+	}
+	else
+	{
+		printk(KERN_INFO "M54xx FEC 1 port\n");
+	}
+
+	for (i = 0; i < M54XX_FEC_MAX_PORTS; i++) {
+		dev = alloc_etherdev(sizeof(struct m54xx_fec_priv));
+		if (!dev)
+			return -ENOMEM;
+		err = m54xx_fec_enet_init(dev, i);
+		if (err) {
+			free_netdev(dev);
+			continue;
+		}
+
+		fep = netdev_priv(dev);
+		M54XX_FEC_MSCR(dev->base_addr) = M54XX_FEC_MII_SPEED;
+#ifdef CONFIG_FEC_M54xx_SHARED_PHY
+		if (i == 0)
+			err = m54xx_fec_mdio_register(dev, i);
+		else {
+			struct m54xx_fec_priv *priv0 = netdev_priv(m54xx_fec_dev[0]);
+			fep->mdio_bus = priv0->mdio_bus;
+			printk(KERN_INFO "FEC%d SHARED the %s ok\n",
+			       i, fep->mdio_bus->name);
+		}
+#else
+		err = m54xx_fec_mdio_register(dev, i);
+#endif
+		if (err) {
+			printk(KERN_ERR "%s: ethernet fec_mdio_register\n",
+			       dev->name);
+			free_netdev(dev);
+			return -ENOMEM;
+		}
+
+		if (register_netdev(dev) != 0) {
+			free_netdev(dev);
+			return -EIO;
+		}
+
+		printk(KERN_INFO "%s: ethernet %pM\n",
+		       dev->name, dev->dev_addr);
+	}
+	return 0;
+}
+
+/**
+ * Stop a device
+ */
+void m54xx_fec_stop(struct net_device *dev)
+{
+	struct m54xx_fec_priv *fp = netdev_priv(dev);
+
+	dma_remove_initiator(fp->initiator_tx);
+	dma_remove_initiator(fp->initiator_rx);
+
+	if (dev->irq)
+		free_irq(dev->irq, dev);
+}
+
+/**
+ * m54xx_fec_open
+ *
+ * @brief This function performs the initialization of
+ *				of FEC and corresponding KS8721 transiver
+ *
+ * RETURNS: If no error occurs, this function returns zero.
+ */
+int m54xx_fec_open(struct net_device *dev)
+{
+	struct m54xx_fec_priv *fp = netdev_priv(dev);
+	unsigned long base_addr = (unsigned long) dev->base_addr;
+	int fduplex;
+	int i;
+	int channel;
+	int error_code = -EBUSY;
+
+	fp->link = 0;
+	fp->duplex = 0;
+	fp->speed = 0;
+	m54xx_fec_init_phy(dev);
+	phy_start(fp->phydev);
+
+	/* Receive the DMA channels */
+	channel = dma_set_channel_fec(fp->rx_requestor);
+
+	if (channel == -1) {
+		printk(KERN_ERR "M54xx FEC DMA RX channel cannot be reserved\n");
+		goto ERRORS;
+	}
+
+	fp->fec_rx_channel = channel;
+
+	dma_connect(channel, (int) fp->interrupt_fec_rx_handler);
+
+	channel = dma_set_channel_fec(fp->tx_requestor);
+
+	if (channel == -1) {
+		printk(KERN_ERR "M54xx FEC DMA RX channel cannot be reserved\n");
+		goto ERRORS;
+	}
+
+	fp->fec_tx_channel = channel;
+
+	dma_connect(channel, (int) fp->interrupt_fec_tx_handler);
+
+	/* init tasklet for controller reinitialization */
+	tasklet_init(&fp->tasklet_reinit,
+		     m54xx_fec_interrupt_fec_reinit, (unsigned long) dev);
+
+	/* Reset FIFOs */
+	M54XX_FEC_FECFRST(base_addr) |= M54XX_FEC_SW_RST | M54XX_FEC_RST_CTL;
+	M54XX_FEC_FECFRST(base_addr) &= ~M54XX_FEC_SW_RST;
+
+	/* Reset and disable FEC */
+	M54XX_FEC_ECR(base_addr) = M54XX_FEC_ECR_RESET;
+
+	udelay(10);
+
+	/* Clear all events */
+	M54XX_FEC_EIR(base_addr) = M54XX_FEC_EIR_CLEAR;
+
+	/* Reset FIFO status */
+	M54XX_FEC_FECTFSR(base_addr) = M54XX_FEC_FECTFSR_MSK;
+	M54XX_FEC_FECRFSR(base_addr) = M54XX_FEC_FECRFSR_MSK;
+
+	/* Set the default address */
+	M54XX_FEC_PALR(base_addr) = (fp->mac_addr[0] << 24) |
+		(fp->mac_addr[1] << 16) |
+		(fp->mac_addr[2] << 8) |
+		fp->mac_addr[3];
+	M54XX_FEC_PAUR(base_addr) = (fp->mac_addr[4] << 24) |
+		(fp->mac_addr[5] << 16) | 0x8808;
+
+	/* Reset the group address descriptor */
+	M54XX_FEC_GALR(base_addr) = 0x00000000;
+	M54XX_FEC_GAUR(base_addr) = 0x00000000;
+
+	/* Reset the individual address descriptor */
+	M54XX_FEC_IALR(base_addr) = 0x00000000;
+	M54XX_FEC_IAUR(base_addr) = 0x00000000;
+
+	/* Set the receive control register */
+	M54XX_FEC_RCR(base_addr) = M54XX_FEC_RCR_MAX_FRM_SIZE | M54XX_FEC_RCR_MII;
+
+	/* Set the receive FIFO control register */
+	/*M54XX_FEC_FECRFCR(base_addr) =
+	 * M54XX_FEC_FECRFCR_FRM | M54XX_FEC_FECRFCR_GR | M54XX_FEC_FECRFCR_MSK;*/
+	M54XX_FEC_FECRFCR(base_addr) = M54XX_FEC_FECRFCR_FRM | M54XX_FEC_FECRFCR_GR
+		| (M54XX_FEC_FECRFCR_MSK
+		   /* disable all but ...*/
+		   & ~M54XX_FEC_FECRFCR_FAE
+		   /* enable frame accept error*/
+		   & ~M54XX_FEC_FECRFCR_RXW
+		   /* enable receive wait condition*/
+		   /*& ~M54XX_FEC_FECRFCR_UF*/
+		   /* enable FIFO underflow*/
+			);
+
+	/* Set the receive FIFO alarm register */
+	M54XX_FEC_FECRFAR(base_addr) = M54XX_FEC_FECRFAR_ALARM;
+
+	/* Set the transmit FIFO control register */
+	/*M54XX_FEC_FECTFCR(base_addr) =
+	  M54XX_FEC_FECTFCR_FRM | M54XX_FEC_FECTFCR_GR | M54XX_FEC_FECTFCR_MSK;*/
+	M54XX_FEC_FECTFCR(base_addr) = M54XX_FEC_FECTFCR_FRM | M54XX_FEC_FECTFCR_GR
+		| (M54XX_FEC_FECTFCR_MSK
+		   /* disable all but ... */
+		   & ~M54XX_FEC_FECTFCR_FAE
+		   /* enable frame accept error */
+		   /* & ~M54XX_FEC_FECTFCR_TXW */
+		   /*enable transmit wait condition*/
+		   /*& ~M54XX_FEC_FECTFCR_UF*/
+		   /*enable FIFO underflow*/
+		   & ~M54XX_FEC_FECTFCR_OF);
+	/* enable FIFO overflow */
+
+	/* Set the transmit FIFO alarm register */
+	M54XX_FEC_FECTFAR(base_addr) = M54XX_FEC_FECTFAR_ALARM;
+
+	/* Set the Tx FIFO watermark */
+	M54XX_FEC_FECTFWR(base_addr) = M54XX_FEC_FECTFWR_XWMRK;
+
+	/* Enable the transmitter to append the CRC */
+	M54XX_FEC_CTCWR(base_addr) = M54XX_FEC_CTCWR_TFCW_CRC;
+
+	/* Enable the ethernet interrupts */
+	/*M54XX_FEC_EIMR(base_addr) = M54XX_FEC_EIMR_MASK;*/
+	M54XX_FEC_EIMR(base_addr) = M54XX_FEC_EIMR_DISABLE
+		| M54XX_FEC_EIR_LC
+		| M54XX_FEC_EIR_RL
+		| M54XX_FEC_EIR_HBERR
+		| M54XX_FEC_EIR_XFUN
+		| M54XX_FEC_EIR_XFERR
+		| M54XX_FEC_EIR_RFERR;
+
+#if 0
+	error_code = init_transceiver(base_addr, &fduplex);
+	if (error_code != 0) {
+		printk(KERN_ERR "Initialization of the "
+		       "transceiver is failed\n");
+		goto ERRORS;
+	}
+#else
+	fduplex = 1;
+#endif
+	if (fduplex)
+		/* Enable the full duplex mode */
+		M54XX_FEC_TCR(base_addr) = M54XX_FEC_TCR_FDEN | M54XX_FEC_TCR_HBC;
+	else
+		/* Disable reception of frames while transmitting */
+		M54XX_FEC_RCR(base_addr) |= M54XX_FEC_RCR_DRT;
+
+	/* Enable MIB */
+	M54XX_FEC_MIBC(base_addr) = M54XX_FEC_MIBC_ENABLE;
+
+	/* Enable M54XX_FEC */
+	M54XX_FEC_ECR(base_addr) |= M54XX_FEC_ECR_ETHEREN;
+	M54XX_FEC_MSCR(dev->base_addr) = M54XX_FEC_MII_SPEED;
+	/* Initialize tx descriptors and start DMA for the transmission */
+	for (i = 0; i < M54XX_FEC_TX_BUF_NUMBER; i++)
+		fp->txdesc[i].statCtrl = MCD_FEC_INTERRUPT;
+
+	fp->txdesc[i - 1].statCtrl |= MCD_FEC_WRAP;
+
+	fp->current_tx = fp->next_tx = 0;
+
+	MCD_startDma(fp->fec_tx_channel, (char *) fp->txdesc, 0,
+		     (unsigned char *) &(M54XX_FEC_FECTFDR(base_addr)), 0,
+		     M54XX_FEC_MAX_FRM_SIZE, 0, fp->initiator_tx,
+		     M54XX_FEC_TX_DMA_PRI, MCD_FECTX_DMA | MCD_INTERRUPT,
+		     MCD_NO_CSUM | MCD_NO_BYTE_SWAP);
+
+	/* Initialize rx descriptors and start DMA for the reception */
+	for (i = 0; i < M54XX_FEC_RX_BUF_NUMBER; i++) {
+		fp->askb_rx[i] = alloc_skb(M54XX_FEC_MAXBUF_SIZE + 16, GFP_DMA);
+		if (!fp->askb_rx[i]) {
+			fp->rxdesc[i].dataPointer = 0;
+			fp->rxdesc[i].statCtrl = 0;
+			fp->rxdesc[i].length = 0;
+		} else {
+			skb_reserve(fp->askb_rx[i], 16);
+			fp->askb_rx[i]->dev = dev;
+			fp->rxdesc[i].dataPointer =
+				(unsigned int)virt_to_phys(fp->askb_rx[i]->tail);
+			fp->rxdesc[i].statCtrl =
+				MCD_FEC_BUF_READY | MCD_FEC_INTERRUPT;
+			fp->rxdesc[i].length = M54XX_FEC_MAXBUF_SIZE;
+		}
+	}
+
+	fp->rxdesc[i - 1].statCtrl |= MCD_FEC_WRAP;
+	fp->current_rx = 0;
+
+	MCD_startDma(fp->fec_rx_channel, (char *) fp->rxdesc, 0,
+		     (unsigned char *) &(M54XX_FEC_FECRFDR(base_addr)), 0,
+		     M54XX_FEC_MAX_FRM_SIZE, 0, fp->initiator_rx,
+		     M54XX_FEC_RX_DMA_PRI, MCD_FECRX_DMA | MCD_INTERRUPT,
+		     MCD_NO_CSUM | MCD_NO_BYTE_SWAP);
+
+	netif_start_queue(dev);
+	return 0;
+
+ERRORS:
+
+	/* Remove the channels and return with the error code */
+	if (fp->fec_rx_channel != -1) {
+		dma_disconnect(fp->fec_rx_channel);
+		dma_remove_channel_by_number(fp->fec_rx_channel);
+		fp->fec_rx_channel = -1;
+	}
+
+	if (fp->fec_tx_channel != -1) {
+		dma_disconnect(fp->fec_tx_channel);
+		dma_remove_channel_by_number(fp->fec_tx_channel);
+		fp->fec_tx_channel = -1;
+	}
+
+	return error_code;
+}
+
+/**
+ * m54xx_fec_close
+ *
+ * @brief This function performs the graceful stop of the
+ *				transmission and disables FEC
+ *
+ * RETURNS: This function always returns zero.
+ */
+int m54xx_fec_close(struct net_device *dev)
+{
+	struct m54xx_fec_priv *fp = netdev_priv(dev);
+	unsigned long base_addr = (unsigned long) dev->base_addr;
+	unsigned long time;
+	int i;
+
+	netif_stop_queue(dev);
+	phy_disconnect(fp->phydev);
+	phy_stop(fp->phydev);
+	/* Perform the graceful stop */
+	M54XX_FEC_TCR(base_addr) |= M54XX_FEC_TCR_GTS;
+
+	time = jiffies;
+
+	/* Wait for the graceful stop */
+	while (!(M54XX_FEC_EIR(base_addr) & M54XX_FEC_EIR_GRA) && jiffies - time <
+	       (M54XX_FEC_GR_TIMEOUT * HZ))
+		schedule();
+
+	/* Disable M54XX_FEC */
+	M54XX_FEC_ECR(base_addr) = M54XX_FEC_ECR_DISABLE;
+
+	/* Reset the DMA channels */
+	spin_lock_irq(&fp->lock);
+	MCD_killDma(fp->fec_tx_channel);
+	spin_unlock_irq(&fp->lock);
+	dma_remove_channel_by_number(fp->fec_tx_channel);
+	dma_disconnect(fp->fec_tx_channel);
+	fp->fec_tx_channel = -1;
+
+	for (i = 0; i < M54XX_FEC_TX_BUF_NUMBER; i++) {
+		if (fp->txbuf[i]) {
+			kfree(fp->txbuf[i]);
+			fp->txbuf[i] = NULL;
+		}
+	}
+
+	spin_lock_irq(&fp->lock);
+	MCD_killDma(fp->fec_rx_channel);
+	spin_unlock_irq(&fp->lock);
+
+	dma_remove_channel_by_number(fp->fec_rx_channel);
+	dma_disconnect(fp->fec_rx_channel);
+	fp->fec_rx_channel = -1;
+
+	for (i = 0; i < M54XX_FEC_RX_BUF_NUMBER; i++) {
+		if (fp->askb_rx[i]) {
+			kfree_skb(fp->askb_rx[i]);
+			fp->askb_rx[i] = NULL;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * +m54xx_fec_get_stat
+ *
+ * RETURNS: This function returns the statistical information.
+ */
+struct net_device_stats *m54xx_fec_get_stat(struct net_device *dev)
+{
+	struct m54xx_fec_priv *fp = netdev_priv(dev);
+	unsigned long base_addr = dev->base_addr;
+
+	/* Receive the statistical information */
+	fp->stat.rx_packets = M54XX_FECSTAT_RMON_R_PACKETS(base_addr);
+	fp->stat.tx_packets = M54XX_FECSTAT_RMON_T_PACKETS(base_addr);
+	fp->stat.rx_bytes = M54XX_FECSTAT_RMON_R_OCTETS(base_addr);
+	fp->stat.tx_bytes = M54XX_FECSTAT_RMON_T_OCTETS(base_addr);
+
+	fp->stat.multicast = M54XX_FECSTAT_RMON_R_MC_PKT(base_addr);
+	fp->stat.collisions = M54XX_FECSTAT_RMON_T_COL(base_addr);
+
+	fp->stat.rx_length_errors =
+		M54XX_FECSTAT_RMON_R_UNDERSIZE(base_addr) +
+		M54XX_FECSTAT_RMON_R_OVERSIZE(base_addr) +
+		M54XX_FECSTAT_RMON_R_FRAG(base_addr) +
+		M54XX_FECSTAT_RMON_R_JAB(base_addr);
+	fp->stat.rx_crc_errors = M54XX_FECSTAT_IEEE_R_CRC(base_addr);
+	fp->stat.rx_frame_errors = M54XX_FECSTAT_IEEE_R_ALIGN(base_addr);
+	fp->stat.rx_over_errors = M54XX_FECSTAT_IEEE_R_MACERR(base_addr);
+
+	fp->stat.tx_carrier_errors = M54XX_FECSTAT_IEEE_T_CSERR(base_addr);
+	fp->stat.tx_fifo_errors = M54XX_FECSTAT_IEEE_T_MACERR(base_addr);
+	fp->stat.tx_window_errors = M54XX_FECSTAT_IEEE_T_LCOL(base_addr);
+
+	/* I hope that one frame doesn't have more than one error */
+	fp->stat.rx_errors = fp->stat.rx_length_errors +
+		fp->stat.rx_crc_errors +
+		fp->stat.rx_frame_errors +
+		fp->stat.rx_over_errors +
+		fp->stat.rx_dropped;
+	fp->stat.tx_errors = fp->stat.tx_carrier_errors +
+		fp->stat.tx_fifo_errors +
+		fp->stat.tx_window_errors +
+		fp->stat.tx_aborted_errors +
+		fp->stat.tx_heartbeat_errors +
+		fp->stat.tx_dropped;
+
+	return &fp->stat;
+}
+
+/**
+ * m54xx_fec_set_multicast_list
+ *
+ * @brief This function sets the frame filtering parameters
+ */
+void m54xx_fec_set_multicast_list(struct net_device *dev)
+{
+	unsigned int crc, data;
+	int i, j;
+	unsigned long base_addr = (unsigned long) dev->base_addr;
+
+	if (dev->flags & IFF_PROMISC || dev->flags & IFF_ALLMULTI) {
+		/* Allow all incoming frames */
+		M54XX_FEC_GALR(base_addr) = 0xFFFFFFFF;
+		M54XX_FEC_GAUR(base_addr) = 0xFFFFFFFF;
+		return ;
+	}
+
+	/* Reset the group address register */
+	M54XX_FEC_GALR(base_addr) = 0x00000000;
+	M54XX_FEC_GAUR(base_addr) = 0x00000000;
+
+	if (!netdev_mc_empty(dev)) {
+		struct netdev_hw_addr *ha;
+
+		netdev_for_each_mc_addr(ha, dev) {
+			/* Processing must be only for the group addresses */
+			if (!(ha->addr[0] & 1))
+				continue;
+
+			/* Calculate crc value for the current address */
+			crc = 0xFFFFFFFF;
+			for (i = 0; i < 6; i++) {
+				for (j = 0, data = ha->addr[i];
+				     j < 8;  j++, data >>= 1) {
+					if ((crc ^ data) & 1)
+						crc = (crc >> 1) ^ M54XX_FEC_CRCPOL;
+					else
+						crc >>= 1;
+				}
+			}
+
+			/* Add this value */
+			crc >>= 26;
+			crc &= 0x3F;
+			if (crc > 31)
+				M54XX_FEC_GAUR(base_addr) |= 0x1 << (crc - 32);
+			else
+				M54XX_FEC_GALR(base_addr) |= 0x1 << crc;
+		}
+	}
+}
+
+/**
+ * m54xx_fec_set_mac_address
+ *
+ * @brief This function sets the MAC address
+ */
+int m54xx_fec_set_mac_address(struct net_device *dev, void *p)
+{
+	struct m54xx_fec_priv *fp = netdev_priv(dev);
+	unsigned long base_addr = (unsigned long) dev->base_addr;
+	struct sockaddr *addr = p;
+
+	if (netif_running(dev))
+		return -EBUSY;
+
+	/* Copy a new address to the device structure */
+	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+
+	/* Copy a new address to the private structure */
+	memcpy(fp->mac_addr, addr->sa_data, 6);
+
+	/* Set the address to the registers */
+	M54XX_FEC_PALR(base_addr) = (fp->mac_addr[0] << 24) |
+		(fp->mac_addr[1] << 16) |
+		(fp->mac_addr[2] << 8) |
+		fp->mac_addr[3];
+	M54XX_FEC_PAUR(base_addr) = (fp->mac_addr[4] << 24) |
+		(fp->mac_addr[5] << 16) |
+		0x8808;
+
+	return 0;
+}
+
+/**
+ * m54xx_fec_tx
+ *
+ * @brief This function starts transmission of the frame using DMA
+ *
+ * RETURNS: This function always returns zero.
+ */
+int m54xx_fec_tx(struct sk_buff *skb, struct net_device *dev)
+{
+	struct m54xx_fec_priv *fp = netdev_priv(dev);
+	void *data, *data_aligned;
+	int offset;
+
+	data = kmalloc(skb->len + 15, GFP_DMA | GFP_ATOMIC);
+
+	if (!data) {
+		fp->stat.tx_dropped++;
+		dev_kfree_skb(skb);
+		return 0;
+	}
+
+	offset = (((unsigned long)virt_to_phys(data) + 15) & 0xFFFFFFF0) -
+		(unsigned long)virt_to_phys(data);
+	data_aligned = (void *)((unsigned long)data + offset);
+	memcpy(data_aligned, skb->data, skb->len);
+
+	/* flush data cache before initializing
+	 * the descriptor and starting DMA */
+
+	spin_lock_irq(&fp->lock);
+
+	/* Initialize the descriptor */
+	fp->txbuf[fp->next_tx] = data;
+	fp->txdesc[fp->next_tx].dataPointer
+		= (unsigned int) virt_to_phys(data_aligned);
+	fp->txdesc[fp->next_tx].length = skb->len;
+	fp->txdesc[fp->next_tx].statCtrl
+		|= (MCD_FEC_END_FRAME | MCD_FEC_BUF_READY);
+	fp->next_tx = (fp->next_tx + 1) & M54XX_FEC_TX_INDEX_MASK;
+
+	if (fp->txbuf[fp->current_tx]
+	    && fp->current_tx == fp->next_tx)
+		netif_stop_queue(dev);
+
+	spin_unlock_irq(&fp->lock);
+
+	/* Tell the DMA to continue the transmission */
+	MCD_continDma(fp->fec_tx_channel);
+
+	dev_kfree_skb(skb);
+
+	dev->trans_start = jiffies;
+
+	return 0;
+}
+
+/**
+ * m54xx_fec_tx_timeout
+ *
+ * @brief If the interrupt processing of received frames was lost
+ *		and DMA stopped the reception, this function clears
+ *		the transmission descriptors and starts DMA
+ *
+ */
+void m54xx_fec_tx_timeout(struct net_device *dev)
+{
+	int i;
+	struct m54xx_fec_priv *fp = netdev_priv(dev);
+	unsigned long base_addr = (unsigned long) dev->base_addr;
+
+	spin_lock_irq(&fp->lock);
+	MCD_killDma(fp->fec_tx_channel);
+	for (i = 0; i < M54XX_FEC_TX_BUF_NUMBER; i++) {
+		if (fp->txbuf[i]) {
+			kfree(fp->txbuf[i]);
+			fp->txbuf[i] = NULL;
+		}
+		fp->txdesc[i].statCtrl = MCD_FEC_INTERRUPT;
+	}
+	fp->txdesc[i - 1].statCtrl |= MCD_FEC_WRAP;
+
+	fp->current_tx = fp->next_tx = 0;
+
+	/* Reset FIFOs */
+	M54XX_FEC_FECFRST(base_addr) |= M54XX_FEC_SW_RST;
+	M54XX_FEC_FECFRST(base_addr) &= ~M54XX_FEC_SW_RST;
+
+	/* Reset and disable M54XX_FEC */
+	/* M54XX_FEC_ECR(base_addr) = M54XX_FEC_ECR_RESET; */
+
+	/* Enable M54XX_FEC */
+	M54XX_FEC_ECR(base_addr) |= M54XX_FEC_ECR_ETHEREN;
+
+	MCD_startDma(fp->fec_tx_channel, (char *) fp->txdesc, 0,
+		     (unsigned char *) &(M54XX_FEC_FECTFDR(base_addr)), 0,
+		     M54XX_FEC_MAX_FRM_SIZE, 0, fp->initiator_tx,
+		     M54XX_FEC_TX_DMA_PRI, MCD_FECTX_DMA | MCD_INTERRUPT,
+		     MCD_NO_CSUM | MCD_NO_BYTE_SWAP);
+
+	spin_unlock_irq(&fp->lock);
+
+	netif_wake_queue(dev);
+
+}
+
+/**
+ * m54xx_fec_interrupt_tx_handler
+ *
+ * @brief This function is called when the data
+ *		transmission from the buffer to the FEC is completed.
+ *
+ */
+void m54xx_fec_interrupt_fec_tx_handler(struct net_device *dev)
+{
+	struct m54xx_fec_priv *fp = netdev_priv(dev);
+
+	/* Release the socket buffer */
+	if (fp->txbuf[fp->current_tx]) {
+		kfree(fp->txbuf[fp->current_tx]);
+		fp->txbuf[fp->current_tx] = NULL;
+	}
+	fp->current_tx =
+		(fp->current_tx + 1) & M54XX_FEC_TX_INDEX_MASK;
+
+	if (MCD_dmaStatus(fp->fec_tx_channel) == MCD_DONE) {
+		for (; fp->current_tx != fp->next_tx;
+		     fp->current_tx =
+			     (fp->current_tx + 1)
+			     & M54XX_FEC_TX_INDEX_MASK) {
+			if (fp->txbuf[fp->current_tx]) {
+				kfree(fp->txbuf[
+					      fp->current_tx]);
+				fp->txbuf[fp->current_tx]
+					= NULL;
+			}
+		}
+	}
+
+	if (netif_queue_stopped(dev))
+		netif_wake_queue(dev);
+}
+
+/**
+ * m54xx_fec_interrupt_rx_handler
+ *
+ * @brief This function is called when the data
+ *		reception from the FEC to the reception buffer is completed.
+ *
+ */
+void m54xx_fec_interrupt_fec_rx_handler(struct net_device *dev)
+{
+	struct m54xx_fec_priv *fp = netdev_priv(dev);
+	struct sk_buff *skb;
+	int i;
+
+	fp->rxflag = 1;
+	/* Some buffers can be missed */
+	if (!(fp->rxdesc[fp->current_rx].statCtrl
+	      & MCD_FEC_END_FRAME)) {
+		/* Find a valid index */
+		for (i = 0; ((i < M54XX_FEC_RX_BUF_NUMBER) &&
+			     !(fp->rxdesc[
+				       fp->current_rx].statCtrl
+			       & MCD_FEC_END_FRAME)); i++,
+			     (fp->current_rx =
+			      (fp->current_rx + 1)
+			      & M54XX_FEC_RX_INDEX_MASK))
+			/* NOP */;
+
+		if (i == M54XX_FEC_RX_BUF_NUMBER) {
+			/* There are no data to process */
+			/* Tell the DMA to continue the reception */
+			MCD_continDma(fp->fec_rx_channel);
+
+			fp->rxflag = 0;
+
+			return;
+		}
+	}
+
+	for (; fp->rxdesc[fp->current_rx].statCtrl
+		     & MCD_FEC_END_FRAME;
+	     fp->current_rx = (fp->current_rx + 1)
+		     & M54XX_FEC_RX_INDEX_MASK) {
+		if ((fp->rxdesc[fp->current_rx].length
+		     <= M54XX_FEC_MAXBUF_SIZE) &&
+		    (fp->rxdesc[fp->current_rx].length
+		     > 4)) {
+			/* --tym-- */
+			skb = fp->askb_rx[fp->current_rx];
+			if (!skb)
+				fp->stat.rx_dropped++;
+			else {
+				/*
+				 * flush data cache before initializing
+				 * the descriptor and starting DMA
+				 */
+				skb_put(skb,
+					(fp->rxdesc[
+						fp->current_rx].length - 4));
+				skb->protocol = eth_type_trans(skb, dev);
+				netif_rx(skb);
+			}
+			fp->rxdesc[fp->current_rx].statCtrl &=
+				~MCD_FEC_END_FRAME;
+			/* allocate new skbuff */
+			fp->askb_rx[fp->current_rx] =
+				alloc_skb(M54XX_FEC_MAXBUF_SIZE + 16,
+					  /*GFP_ATOMIC |*/ GFP_DMA);
+			if (!fp->askb_rx[fp->current_rx]) {
+				fp->rxdesc[
+					fp->current_rx].dataPointer
+					= 0;
+				fp->rxdesc[
+					fp->current_rx].length = 0;
+				fp->stat.rx_dropped++;
+			} else {
+				skb_reserve(
+					fp->askb_rx[fp->current_rx], 16);
+				fp->askb_rx[fp->current_rx]->dev = dev;
+
+				/*
+				 * flush data cache before initializing
+				 * the descriptor and starting DMA
+				 */
+
+				fp->rxdesc[
+					fp->current_rx].dataPointer =
+					(unsigned int) virt_to_phys(
+						fp->askb_rx[
+							fp->current_rx]->tail);
+				fp->rxdesc[
+					fp->current_rx].length =
+					M54XX_FEC_MAXBUF_SIZE;
+				fp->rxdesc[
+					fp->current_rx].statCtrl |=
+					MCD_FEC_BUF_READY;
+
+				/*
+				 * flush data cache before initializing
+				 * the descriptor and starting DMA
+				 */
+			}
+		}
+
+	}
+
+	/* Tell the DMA to continue the reception */
+	MCD_continDma(fp->fec_rx_channel);
+
+	fp->rxflag = 0;
+}
+
+/**
+ * m54xx_fec_interrupt_handler
+ *
+ * @brief This function is called when some special errors occur
+ *
+ */
+irqreturn_t m54xx_fec_interrupt_handler(int irq, void *dev_id)
+{
+
+	struct net_device *dev = (struct net_device *)dev_id;
+	struct m54xx_fec_priv *fp = netdev_priv(dev);
+	unsigned long base_addr = (unsigned long) dev->base_addr;
+	unsigned long events;
+
+	/* Read and clear the events */
+	events = M54XX_FEC_EIR(base_addr) & M54XX_FEC_EIMR(base_addr);
+
+	if (events & M54XX_FEC_EIR_HBERR) {
+		fp->stat.tx_heartbeat_errors++;
+		M54XX_FEC_EIR(base_addr) = M54XX_FEC_EIR_HBERR;
+	}
+
+	/* receive/transmit FIFO error */
+	if (((events & M54XX_FEC_EIR_RFERR) != 0)
+	    || ((events & M54XX_FEC_EIR_XFERR) != 0)) {
+		/* kill DMA receive channel */
+		MCD_killDma(fp->fec_rx_channel);
+
+		/* kill running transmission by DMA */
+		MCD_killDma(fp->fec_tx_channel);
+
+		/* Reset FIFOs */
+		M54XX_FEC_FECFRST(base_addr) |= M54XX_FEC_SW_RST;
+		M54XX_FEC_FECFRST(base_addr) &= ~M54XX_FEC_SW_RST;
+
+		/* reset receive FIFO status register */
+		M54XX_FEC_FECRFSR(base_addr) = M54XX_FEC_FECRFSR_FAE |
+			M54XX_FEC_FECRFSR_RXW |
+			M54XX_FEC_FECRFSR_UF;
+
+		/* reset transmit FIFO status register */
+		M54XX_FEC_FECTFSR(base_addr) = M54XX_FEC_FECTFSR_FAE |
+			M54XX_FEC_FECTFSR_TXW |
+			M54XX_FEC_FECTFSR_UF |
+			M54XX_FEC_FECTFSR_OF;
+
+		/* reset RFERR and XFERR event */
+		M54XX_FEC_EIR(base_addr) = M54XX_FEC_EIR_RFERR | M54XX_FEC_EIR_XFERR;
+
+		/* stop queue */
+		netif_stop_queue(dev);
+
+		/* execute reinitialization as tasklet */
+		tasklet_schedule(&fp->tasklet_reinit);
+
+		fp->stat.rx_dropped++;
+	}
+
+	/* transmit FIFO underrun */
+	if ((events & M54XX_FEC_EIR_XFUN) != 0) {
+		/* reset XFUN event */
+		M54XX_FEC_EIR(base_addr) = M54XX_FEC_EIR_XFUN;
+		fp->stat.tx_aborted_errors++;
+	}
+
+	/* late collision */
+	if ((events & M54XX_FEC_EIR_LC) != 0) {
+		/* reset LC event */
+		M54XX_FEC_EIR(base_addr) = M54XX_FEC_EIR_LC;
+		fp->stat.tx_aborted_errors++;
+	}
+
+	/* collision retry limit */
+	if ((events & M54XX_FEC_EIR_RL) != 0) {
+		/* reset RL event */
+		M54XX_FEC_EIR(base_addr) = M54XX_FEC_EIR_RL;
+		fp->stat.tx_aborted_errors++;
+	}
+	return 0;
+}
+
+/**
+ * m54xx_fec_interrupt_reinit
+ *
+ * @brief This function is called from interrupt handler
+ *		when controller must be reinitialized.
+ *
+ */
+void m54xx_fec_interrupt_fec_reinit(unsigned long data)
+{
+	int i;
+	struct net_device *dev = (struct net_device *)data;
+	struct m54xx_fec_priv *fp = netdev_priv(dev);
+	unsigned long base_addr = (unsigned long) dev->base_addr;
+
+	/* Initialize reception descriptors and start DMA for the reception */
+	for (i = 0; i < M54XX_FEC_RX_BUF_NUMBER; i++) {
+		if (!fp->askb_rx[i]) {
+			fp->askb_rx[i] = alloc_skb(M54XX_FEC_MAXBUF_SIZE + 16,
+						   GFP_ATOMIC | GFP_DMA);
+			if (!fp->askb_rx[i]) {
+				fp->rxdesc[i].dataPointer = 0;
+				fp->rxdesc[i].statCtrl = 0;
+				fp->rxdesc[i].length = 0;
+				continue;
+			}
+			fp->askb_rx[i]->dev = dev;
+			skb_reserve(fp->askb_rx[i], 16);
+		}
+		fp->rxdesc[i].dataPointer =
+			(unsigned int) virt_to_phys(fp->askb_rx[i]->tail);
+		fp->rxdesc[i].statCtrl =
+			MCD_FEC_BUF_READY | MCD_FEC_INTERRUPT;
+		fp->rxdesc[i].length = M54XX_FEC_MAXBUF_SIZE;
+	}
+
+	fp->rxdesc[i - 1].statCtrl |= MCD_FEC_WRAP;
+	fp->current_rx = 0;
+
+	/* restart frame transmission */
+	for (i = 0; i < M54XX_FEC_TX_BUF_NUMBER; i++) {
+		if (fp->txbuf[i]) {
+			kfree(fp->txbuf[i]);
+			fp->txbuf[i] = NULL;
+			fp->stat.tx_dropped++;
+		}
+		fp->txdesc[i].statCtrl = MCD_FEC_INTERRUPT;
+	}
+	fp->txdesc[i - 1].statCtrl |= MCD_FEC_WRAP;
+	fp->current_tx = fp->next_tx = 0;
+
+	/* flush entire data cache before restarting the DMA */
+
+	/* restart DMA from beginning */
+	MCD_startDma(fp->fec_rx_channel,
+		     (char *) fp->rxdesc, 0,
+		     (unsigned char *) &(M54XX_FEC_FECRFDR(base_addr)), 0,
+		     M54XX_FEC_MAX_FRM_SIZE, 0, fp->initiator_rx,
+		     M54XX_FEC_RX_DMA_PRI, MCD_FECRX_DMA | MCD_INTERRUPT,
+		     MCD_NO_CSUM | MCD_NO_BYTE_SWAP);
+
+	MCD_startDma(fp->fec_tx_channel, (char *) fp->txdesc, 0,
+		     (unsigned char *) &(M54XX_FEC_FECTFDR(base_addr)), 0,
+		     M54XX_FEC_MAX_FRM_SIZE, 0, fp->initiator_tx,
+		     M54XX_FEC_TX_DMA_PRI, MCD_FECTX_DMA | MCD_INTERRUPT,
+		     MCD_NO_CSUM | MCD_NO_BYTE_SWAP);
+
+	/* Enable M54XX_FEC */
+	M54XX_FEC_ECR(base_addr) |= M54XX_FEC_ECR_ETHEREN;
+
+	netif_wake_queue(dev);
+}
+
+/**
+ * m54xx_fec_interrupt_tx_handler_fec0
+ *
+ * @brief This is the DMA interrupt handler using	 for FEC0
+ *		transmission.
+ *
+ */
+void m54xx_fec_interrupt_fec_tx_handler_fec0(void)
+{
+	m54xx_fec_interrupt_fec_tx_handler(m54xx_fec_dev[0]);
+}
+
+#ifdef M54XX_FEC2
+/**
+ * m54xx_fec_interrupt_tx_handler_fec1
+ *
+ * @brief This is the DMA interrupt handler using for the FEC1
+ *		transmission.
+ *
+ */
+void m54xx_fec_interrupt_fec_tx_handler_fec1(void)
+{
+	m54xx_fec_interrupt_fec_tx_handler(m54xx_fec_dev[1]);
+}
+#endif
+
+/**
+ * m54xx_fec_interrupt_rx_handler_fec0
+ *
+ * @brief This is the DMA interrupt handler using for the FEC0
+ *		reception.
+ *
+ */
+void m54xx_fec_interrupt_fec_rx_handler_fec0(void)
+{
+	m54xx_fec_interrupt_fec_rx_handler(m54xx_fec_dev[0]);
+}
+
+#ifdef M54XX_FEC2
+/**
+ * m54xx_fec_interrupt_rx_handler_fec1
+ *
+ * @brief This is the DMA interrupt handler using for the FEC1
+ *		reception.
+ *
+ */
+void m54xx_fec_interrupt_fec_rx_handler_fec1(void)
+{
+	m54xx_fec_interrupt_fec_rx_handler(m54xx_fec_dev[1]);
+}
+
+#endif
+
+#ifndef MODULE
+/**
+ * m54xx_fec_mac_setup0
+ *
+ * @brief This function sets the MAC address of FEC0 from command line
+ *
+ */
+int __init m54xx_fec_mac_setup0(char *s)
+{
+	if (!s || !*s)
+		return 1;
+
+	if (m54xx_fec_str_to_mac(s, m54xx_fec_mac_addr_fec0))
+		printk(KERN_ERR "The MAC address of FEC0 "
+		       "cannot be set from command line");
+	return 1;
+}
+
+#ifdef M54XX_FEC2
+
+/**
+ * m54xx_fec_mac_setup1
+ *
+ * @brief This function sets the MAC address of FEC1 from command line
+ *
+ */
+int __init m54xx_fec_mac_setup1(char *s)
+{
+	if (!s || !*s)
+		return 1;
+
+	if (m54xx_fec_str_to_mac(s, m54xx_fec_mac_addr_fec1))
+		printk(KERN_ERR "The MAC address of FEC1 "
+		       "cannot be set from command line\n");
+	return 1;
+}
+#endif
+
+/**
+ * m54xx_fec_str_to_mac
+ *
+ * @brief This function interprets the character string into MAC addr
+ *
+ */
+int m54xx_fec_str_to_mac(char *str_mac, unsigned char* addr)
+{
+	unsigned long val;
+	char c;
+	unsigned long octet[6], *octetptr = octet;
+	int i;
+
+again:
+	val = 0;
+	while ((c = *str_mac) != '\0') {
+		if ((c >= '0') && (c <= '9')) {
+			val = (val * 16) + (c - '0');
+			str_mac++;
+			continue;
+		} else if (((c >= 'a') && (c <= 'f'))
+			   || ((c >= 'A') && (c <= 'F'))) {
+			val = (val << 4) +
+				(c + 10 -
+				 (((c >= 'a') && (c <= 'f')) ? 'a' : 'A'));
+			str_mac++;
+			continue;
+		}
+		break;
+	}
+	if (*str_mac == ':') {
+		*octetptr++ = val, str_mac++;
+		if (octetptr >= octet + 6)
+			return 1;
+		goto again;
+	}
+
+	/* Check for trailing characters */
+	if (*str_mac && !(*str_mac == ' '))
+		return 1;
+
+	*octetptr++ = val;
+
+	if ((octetptr - octet) == 6) {
+		for (i = 0; i <= 6; i++)
+			addr[i] = octet[i];
+	} else
+		return 1;
+
+	return 0;
+}
+#endif
diff --git a/drivers/net/ethernet/freescale/fec_m54xx.h b/drivers/net/ethernet/freescale/fec_m54xx.h
new file mode 100644
index 0000000..8a1455f
--- /dev/null
+++ b/drivers/net/ethernet/freescale/fec_m54xx.h
@@ -0,0 +1,237 @@
+#ifndef _FEC_M54XX_H_
+#define _FEC_M54XX_H_
+
+#define M54XX_FEC_BASE_ADDR_FEC0	((unsigned int)MCF_MBAR + 0x9000)
+#define M54XX_FEC_BASE_ADDR_FEC1	((unsigned int)MCF_MBAR + 0x9800)
+
+#define M54XX_ISC_FEC1			(38)
+#define M54XX_ISC_FEC0			(39)
+
+#define M54XX_FEC_FECI2CIRQ		(0xFFC0)
+#define M54XX_FEC_GPIO_PAR_FECI2CIRQ					\
+	(*(volatile unsigned short *)((unsigned int)MCF_MBAR + 0xA44))
+
+#define M54XX_FEC_ECR_DISABLE		(0x00000000)
+
+#define M54XX_FEC_ECR(x)			\
+	(*(volatile unsigned int *)(x + 0x024))
+#define M54XX_FEC_EIR(x)			\
+	(*(volatile unsigned int *)(x + 0x004))
+#define M54XX_FEC_PALR(x)			\
+	(*(volatile unsigned int *)(x + 0x0E4))
+#define M54XX_FEC_PAUR(x)			\
+	(*(volatile unsigned int *)(x + 0x0E8))
+#define M54XX_FEC_IALR(x)			\
+	(*(volatile unsigned int *)(x + 0x11C))
+#define M54XX_FEC_IAUR(x)			\
+	(*(volatile unsigned int *)(x + 0x118))
+#define M54XX_FEC_GALR(x)			\
+	(*(volatile unsigned int *)(x + 0x124))
+#define M54XX_FEC_GAUR(x)			\
+	(*(volatile unsigned int *)(x + 0x120))
+#define M54XX_FEC_RCR(x)			\
+	(*(volatile unsigned int *)(x + 0x084))
+#define M54XX_FEC_FECRFCR(x)			\
+	(*(volatile unsigned int *)(x + 0x18C))
+#define M54XX_FEC_FECRFAR(x)			\
+	(*(volatile unsigned int *)(x + 0x198))
+#define M54XX_FEC_FECTFCR(x)			\
+	(*(volatile unsigned int *)(x + 0x1AC))
+#define M54XX_FEC_FECTFAR(x)			\
+	(*(volatile unsigned int *)(x + 0x1B8))
+#define M54XX_FEC_FECTFWR(x)			\
+	(*(volatile unsigned int *)(x + 0x144))
+#define M54XX_FEC_CTCWR(x)			\
+	(*(volatile unsigned int *)(x + 0x1C8))
+#define M54XX_FEC_EIMR(x)			\
+	(*(volatile unsigned int *)(x + 0x008))
+#define M54XX_FEC_TCR(x)			\
+	(*(volatile unsigned int *)(x + 0x0C4))
+#define M54XX_FEC_MIBC(x)			\
+	(*(volatile unsigned int *)(x + 0x064))
+#define M54XX_FEC_MSCR(x)			\
+	(*(volatile unsigned int *)(x + 0x044))
+#define M54XX_FEC_FECTFDR(x)			\
+	(*(volatile unsigned int *)(x + 0x1A4))
+#define M54XX_FEC_FECRFDR(x)			\
+	(*(volatile unsigned int *)(x + 0x184))
+#define M54XX_FEC_FECTFSR(x)			\
+	(*(volatile unsigned int *)(x + 0x1A8))
+#define M54XX_FEC_FECRFSR(x)			\
+	(*(volatile unsigned int *)(x + 0x188))
+#define M54XX_FECSTAT_RMON_R_PACKETS(x)		\
+	(*(volatile unsigned int *)(x + 0x284))
+#define M54XX_FECSTAT_RMON_T_PACKETS(x)		\
+	(*(volatile unsigned int *)(x + 0x204))
+#define M54XX_FECSTAT_RMON_R_OCTETS(x)		\
+	(*(volatile unsigned int *)(x + 0x2C4))
+#define M54XX_FECSTAT_RMON_T_OCTETS(x)		\
+	(*(volatile unsigned int *)(x + 0x244))
+#define M54XX_FECSTAT_RMON_R_UNDERSIZE(x)	\
+	(*(volatile unsigned int *)(x + 0x294))
+#define M54XX_FECSTAT_RMON_R_OVERSIZE(x)	\
+	(*(volatile unsigned int *)(x + 0x298))
+#define M54XX_FECSTAT_RMON_R_FRAG(x)		\
+	(*(volatile unsigned int *)(x + 0x29C))
+#define M54XX_FECSTAT_RMON_R_JAB(x)		\
+	(*(volatile unsigned int *)(x + 0x2A0))
+#define M54XX_FECSTAT_RMON_R_MC_PKT(x)		\
+	(*(volatile unsigned int *)(x + 0x28C))
+#define M54XX_FECSTAT_RMON_T_COL(x)		\
+	(*(volatile unsigned int *)(x + 0x224))
+#define M54XX_FECSTAT_IEEE_R_ALIGN(x)		\
+	(*(volatile unsigned int *)(x + 0x2D4))
+#define M54XX_FECSTAT_IEEE_R_CRC(x)		\
+	(*(volatile unsigned int *)(x + 0x2D0))
+#define M54XX_FECSTAT_IEEE_R_MACERR(x)		\
+	(*(volatile unsigned int *)(x + 0x2D8))
+#define M54XX_FECSTAT_IEEE_T_CSERR(x)		\
+	(*(volatile unsigned int *)(x + 0x268))
+#define M54XX_FECSTAT_IEEE_T_MACERR(x)		\
+	(*(volatile unsigned int *)(x + 0x264))
+#define M54XX_FECSTAT_IEEE_T_LCOL(x)		\
+	(*(volatile unsigned int *)(x + 0x25C))
+#define M54XX_FECSTAT_IEEE_R_OCTETS_OK(x)	\
+	(*(volatile unsigned int *)(x + 0x2E0))
+#define M54XX_FECSTAT_IEEE_T_OCTETS_OK(x)	\
+	(*(volatile unsigned int *)(x + 0x274))
+#define M54XX_FECSTAT_IEEE_R_DROP(x)		\
+	(*(volatile unsigned int *)(x + 0x2C8))
+#define M54XX_FECSTAT_IEEE_T_DROP(x)		\
+	(*(volatile unsigned int *)(x + 0x248))
+#define M54XX_FECSTAT_IEEE_R_FRAME_OK(x)	\
+	(*(volatile unsigned int *)(x + 0x2CC))
+#define M54XX_FECSTAT_IEEE_T_FRAME_OK(x)	\
+	(*(volatile unsigned int *)(x + 0x24C))
+#define M54XX_FEC_MMFR(x)			\
+	(*(volatile unsigned int *)(x + 0x040))
+#define M54XX_FEC_FECFRST(x)			\
+	(*(volatile unsigned int *)(x + 0x1C4))
+
+#define M54XX_FEC_MAX_FRM_SIZE			(1518)
+#define M54XX_FEC_MAXBUF_SIZE			(1520)
+
+/* Register values */
+#define M54XX_FEC_ECR_RESET			(0x00000001)
+#define M54XX_FEC_EIR_CLEAR			(0xFFFFFFFF)
+#define M54XX_FEC_EIR_RL			(0x00100000)
+#define M54XX_FEC_EIR_HBERR			(0x80000000)
+#define M54XX_FEC_EIR_BABR			(0x40000000)
+/* babbling receive error */
+#define M54XX_FEC_EIR_BABT			(0x20000000)
+/* babbling transmit error */
+#define M54XX_FEC_EIR_TXF			(0x08000000)
+/* transmit frame interrupt */
+#define M54XX_FEC_EIR_MII			(0x00800000)
+/* MII interrupt */
+#define M54XX_FEC_EIR_LC			(0x00200000)
+/* late collision */
+#define M54XX_FEC_EIR_XFUN			(0x00080000)
+/* transmit FIFO underrun */
+#define M54XX_FEC_EIR_XFERR			(0x00040000)
+/* transmit FIFO error */
+#define M54XX_FEC_EIR_RFERR			(0x00020000)
+/* receive FIFO error */
+#define M54XX_FEC_RCR_MAX_FRM_SIZE		(M54XX_FEC_MAX_FRM_SIZE << 16)
+#define M54XX_FEC_RCR_MII			(0x00000004)
+#define M54XX_FEC_FECRFCR_FAE			(0x00400000)
+/* frame accept error */
+#define M54XX_FEC_FECRFCR_RXW			(0x00200000)
+/* receive wait condition */
+#define M54XX_FEC_FECRFCR_UF			(0x00100000)
+/* receive FIFO underflow */
+#define M54XX_FEC_FECRFCR_FRM			(0x08000000)
+#define M54XX_FEC_FECRFCR_GR			(0x7 << 24)
+
+#define M54XX_FEC_EIMR_DISABLE			(0x00000000)
+
+#define M54XX_FEC_FECRFAR_ALARM			(0x300)
+#define M54XX_FEC_FECTFCR_FRM			(0x08000000)
+#define M54XX_FEC_FECTFCR_GR			(0x7 << 24)
+#define M54XX_FEC_FECTFCR_FAE			(0x00400000)
+/* frame accept error */
+#define M54XX_FEC_FECTFCR_TXW			(0x00040000)
+/* transmit wait condition */
+#define M54XX_FEC_FECTFCR_UF			(0x00100000)
+/* transmit FIFO underflow */
+#define M54XX_FEC_FECTFCR_OF			(0x00080000)
+/* transmit FIFO overflow */
+
+#define M54XX_FEC_FECTFAR_ALARM			(0x100)
+#define M54XX_FEC_FECTFWR_XWMRK			(0x00000000)
+
+#define M54XX_FEC_FECTFSR_MSK			(0xC0B00000)
+#define M54XX_FEC_FECTFSR_TXW			(0x40000000)
+/* transmit wait condition */
+#define M54XX_FEC_FECTFSR_FAE			(0x00800000)
+/* frame accept error */
+#define M54XX_FEC_FECTFSR_UF			(0x00200000)
+/* transmit FIFO underflow */
+#define M54XX_FEC_FECTFSR_OF			(0x00100000)
+/* transmit FIFO overflow */
+
+#define M54XX_FEC_FECRFSR_MSK			(0x80F00000)
+#define M54XX_FEC_FECRFSR_FAE			(0x00800000)
+/* frame accept error */
+#define M54XX_FEC_FECRFSR_RXW			(0x00400000)
+/* receive wait condition */
+#define M54XX_FEC_FECRFSR_UF			(0x00200000)
+/* receive FIFO underflow */
+
+#define M54XX_FEC_CTCWR_TFCW_CRC		(0x03000000)
+#define M54XX_FEC_TCR_FDEN			(0x00000004)
+#define M54XX_FEC_TCR_HBC			(0x00000002)
+#define M54XX_FEC_RCR_DRT			(0x00000002)
+#define M54XX_FEC_EIMR_MASK			(M54XX_FEC_EIR_RL | M54XX_FEC_EIR_HBERR)
+#define M54XX_FEC_ECR_ETHEREN			(0x00000002)
+#define M54XX_FEC_FECTFCR_MSK			(0x00FC0000)
+#define M54XX_FEC_FECRFCR_MSK			(0x00F80000)
+#define M54XX_FEC_EIR_GRA			(0x10000000)
+#define M54XX_FEC_TCR_GTS			(0x00000001)
+#define M54XX_FEC_MIBC_ENABLE			(0x00000000)
+#define M54XX_FEC_MIB_LEN			(228)
+#define M54XX_FEC_PHY_ADDR			(0x01)
+
+#define M54XX_FEC_RX_DMA_PRI			(6)
+#define M54XX_FEC_TX_DMA_PRI			(6)
+
+#define M54XX_FEC_TX_BUF_NUMBER			(8)
+#define M54XX_FEC_RX_BUF_NUMBER			(64)
+
+#define M54XX_FEC_TX_INDEX_MASK			(0x7)
+#define M54XX_FEC_RX_INDEX_MASK			(0x3f)
+
+#define M54XX_FEC_RX_DESC_FEC0			SYS_SRAM_FEC_START
+#define M54XX_FEC_TX_DESC_FEC0						\
+	(M54XX_FEC_RX_DESC_FEC0 + M54XX_FEC_RX_BUF_NUMBER * sizeof(MCD_bufDescFec))
+
+#define M54XX_FEC_RX_DESC_FEC1				\
+	(SYS_SRAM_FEC_START + SYS_SRAM_FEC_SIZE/2)
+#define M54XX_FEC_TX_DESC_FEC1						\
+	(M54XX_FEC_RX_DESC_FEC1 + M54XX_FEC_RX_BUF_NUMBER * sizeof(MCD_bufDescFec))
+
+#define M54XX_FEC_EIR_MII			(0x00800000)
+#define M54XX_FEC_MMFR_READ			(0x60020000)
+#define M54XX_FEC_MMFR_WRITE			(0x50020000)
+
+#define M54XX_FEC_FLAGS_RX			(0x00000001)
+
+#define M54XX_FEC_CRCPOL			(0xEDB88320)
+
+#define M54XX_FEC_MII_TIMEOUT			(2)
+#define M54XX_FEC_GR_TIMEOUT			(1)
+#define M54XX_FEC_TX_TIMEOUT			(1)
+#define M54XX_FEC_RX_TIMEOUT			(1)
+
+#define M54XX_FEC_SW_RST			0x2000000
+#define M54XX_FEC_RST_CTL			0x1000000
+
+int m54xx_fec_read_mii(unsigned int base_addr, unsigned int pa, unsigned int ra,
+		       unsigned int *data);
+int m54xx_fec_write_mii(unsigned int base_addr, unsigned int pa, unsigned int ra,
+			unsigned int data);
+
+#define M54XX_FEC_MII_SPEED			\
+	((MCF_CLK / 2) / ((2500000 / 2) * 2))
+
+#endif
--
1.7.9.5

