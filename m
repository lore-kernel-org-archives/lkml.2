Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab1I2Cah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 22:30:37 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:2375 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab1I2CaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 22:30:12 -0400
X-SpamScore: -12
X-BigFish: VS-12(zzbf3W853kzz1202hzz84d07h8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Gang <Gang.Liu@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <B11780@freescale.com>, <r61911@freescale.com>,
        Liu Gang <Gang.Liu@freescale.com>, Li Yang <leoli@freescale.com>,
        Jin Qing <b24347@freescale.com>
Subject: [PATCH 2/4] fsl-rio: Add two ports and rapidio message units support
Date: Thu, 29 Sep 2011 10:28:59 +0800
Message-ID: <1317263341-19010-2-git-send-email-Gang.Liu@freescale.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1317263341-19010-1-git-send-email-Gang.Liu@freescale.com>
References: <1317263341-19010-1-git-send-email-Gang.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually, freescale rapidio endpoint can support one 1X or two 4X LP-Serial link interfaces,
and rapidio message transactions can be implemented by two message units. This patch adds the
support of two rapidio ports and initializes message unit 0 and message unit 1. And these ports
and message units can work simultaneously.

Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Jin Qing <b24347@freescale.com>
Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
---
 arch/powerpc/sysdev/fsl_rio.c |  336 +++++++++++++++++++++----------
 arch/powerpc/sysdev/fsl_rio.h |   73 +++++++-
 arch/powerpc/sysdev/fsl_rmu.c |  434 ++++++++++++++++++++---------------------
 3 files changed, 502 insertions(+), 341 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 9484484..c7f8080 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -45,7 +45,6 @@
 #define RIO_PORT1_IECSR		0x10130
 #define RIO_PORT2_IECSR		0x101B0
 
-#define RIO_ATMU_REGS_OFFSET	0x10c00
 #define RIO_GCCSR		0x13c
 #define RIO_ESCSR		0x158
 #define ESCSR_CLEAR		0x07120204
@@ -74,6 +73,11 @@
 		: "b" (addr), "i" (-EFAULT), "0" (err))
 
 void __iomem *rio_regs_win;
+void __iomem *rmu_regs_win;
+resource_size_t rio_law_start;
+
+struct fsl_rio_dbell *dbell;
+struct fsl_rio_pw *pw;
 
 #ifdef CONFIG_E500
 int fsl_rio_mcheck_exception(struct pt_regs *regs)
@@ -120,7 +124,7 @@ static int fsl_local_config_read(struct rio_mport *mport,
 {
 	struct rio_priv *priv = mport->priv;
 	pr_debug("fsl_local_config_read: index %d offset %8.8x\n", index,
-		offset);
+		 offset);
 	*data = in_be32(priv->regs_win + offset);
 
 	return 0;
@@ -173,7 +177,7 @@ fsl_rio_config_read(struct rio_mport *mport, int index, u16 destid,
 	pr_debug
 		("fsl_rio_config_read:"
 		" index %d destid %d hopcount %d offset %8.8x len %d\n",
-	     index, destid, hopcount, offset, len);
+		index, destid, hopcount, offset, len);
 
 	/* 16MB maintenance window possible */
 	/* allow only aligned access to maintenance registers */
@@ -230,8 +234,8 @@ fsl_rio_config_write(struct rio_mport *mport, int index, u16 destid,
 	u8 *data;
 	pr_debug
 		("fsl_rio_config_write:"
-		"index %d destid %d hopcount %d offset %8.8x len %d val %8.8x\n",
-	     index, destid, hopcount, offset, len, val);
+		" index %d destid %d hopcount %d offset %8.8x len %d val %8.8x\n",
+		index, destid, hopcount, offset, len, val);
 
 	/* 16MB maintenance windows possible */
 	/* allow only aligned access to maintenance registers */
@@ -260,7 +264,7 @@ fsl_rio_config_write(struct rio_mport *mport, int index, u16 destid,
 	return 0;
 }
 
-void fsl_rio_port_error_handler(struct rio_mport *port, int offset)
+void fsl_rio_port_error_handler(int offset)
 {
 	/*XXX: Error recovery is not implemented, we just clear errors */
 	out_be32((u32 *)(rio_regs_win + RIO_LTLEDCSR), 0);
@@ -331,12 +335,17 @@ int fsl_rio_setup(struct platform_device *dev)
 	struct rio_mport *port;
 	struct rio_priv *priv;
 	int rc = 0;
-	const u32 *dt_range, *cell;
-	struct resource regs;
-	int rlen;
+	const u32 *dt_range, *cell, *ports_num;
+	u32 active_ports = 0;
+	struct resource regs, rmu_regs;
+	struct device_node *np, *rmu_node;
+	int rlen, len;
 	u32 ccsr;
 	u64 law_start, law_size;
 	int paw, aw, sw;
+	int i;
+	static int tmp;
+	struct device_node *rmu_np[MAX_MSG_UNIT_NUM] = {NULL};
 
 	if (!dev->dev.of_node) {
 		dev_err(&dev->dev, "Device OF-Node is NULL");
@@ -360,6 +369,14 @@ int fsl_rio_setup(struct platform_device *dev)
 		return -EFAULT;
 	}
 
+	ports_num = of_get_property(dev->dev.of_node,
+		"fsl,rio-num-ports", &len);
+	if (!ports_num || len < sizeof(*ports_num)) {
+		dev_err(&dev->dev, "Can't get %s property 'rio-num-ports'\n",
+				dev->dev.of_node->full_name);
+		return -EFAULT;
+	}
+
 	/* Get node address wide */
 	cell = of_get_property(dev->dev.of_node, "#address-cells", NULL);
 	if (cell)
@@ -378,8 +395,17 @@ int fsl_rio_setup(struct platform_device *dev)
 	law_start = of_read_number(dt_range + aw, paw);
 	law_size = of_read_number(dt_range + aw + paw, sw);
 
+	rio_law_start = law_start;
+
 	dev_info(&dev->dev, "LAW start 0x%016llx, size 0x%016llx.\n",
 			law_start, law_size);
+	rio_regs_win = ioremap(regs.start, resource_size(&regs));
+
+	if (!rio_regs_win) {
+		printk(KERN_ERR "Unable to map rio register window\n");
+		rc = -ENOMEM;
+		goto err_rio_regs;
+	}
 
 	ops = kzalloc(sizeof(struct rio_ops), GFP_KERNEL);
 	if (!ops) {
@@ -390,130 +416,224 @@ int fsl_rio_setup(struct platform_device *dev)
 	ops->lcwrite = fsl_local_config_write;
 	ops->cread = fsl_rio_config_read;
 	ops->cwrite = fsl_rio_config_write;
+	ops->dsend = fsl_rio_doorbell_send;
 	ops->pwenable = fsl_rio_pw_enable;
-
-	port = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);
-	if (!port) {
+	ops->open_outb_mbox = fsl_open_outb_mbox;
+	ops->open_inb_mbox = fsl_open_inb_mbox;
+	ops->close_outb_mbox = fsl_close_outb_mbox;
+	ops->close_inb_mbox = fsl_close_inb_mbox;
+	ops->add_outb_message = fsl_add_outb_message;
+	ops->add_inb_buffer = fsl_add_inb_buffer;
+	ops->get_inb_message = fsl_get_inb_message;
+
+	dbell = kzalloc(sizeof(struct fsl_rio_dbell), GFP_KERNEL);
+	if (!(dbell)) {
+		printk(KERN_ERR "Can't alloc memory for 'fsl_rio_dbell'\n");
 		rc = -ENOMEM;
-		goto err_port;
+		goto err_dbell;
 	}
-	port->index = 0;
-
-	priv = kzalloc(sizeof(struct rio_priv), GFP_KERNEL);
-	if (!priv) {
-		printk(KERN_ERR "Can't alloc memory for 'priv'\n");
+	dbell->dev = &dev->dev;
+
+	dbell->bellirq = irq_of_parse_and_map(dev->dev.of_node, 2);
+	dev_info(&dev->dev, "bellirq: %d\n", dbell->bellirq);
+	dbell->dbell_regs = (struct rio_dbell_regs *)(rio_regs_win +
+					RIO_S_DBELL_REGS_OFFSET);
+	dbell->dbell_atmu_regs = (struct rio_atmu_regs *)(rio_regs_win +
+					RIO_ATMU_REGS_DBELL_OFFSET);
+	/* Configure outbound doorbell window */
+	out_be32(&dbell->dbell_atmu_regs->rowbar,
+			(law_start + RIO_MAINT_WIN_SIZE) >> 12);
+	/* 4k window size */
+	out_be32(&dbell->dbell_atmu_regs->rowar, DOORBELL_ROWAR_EN |
+			DOORBELL_ROWAR_NREAD | DOORBELL_ROWAR_RES |
+			DOORBELL_ROWAR_SIZE);
+	fsl_rio_doorbell_init(dbell);
+
+	pw = kzalloc(sizeof(struct fsl_rio_pw), GFP_KERNEL);
+	if (!(pw)) {
+		printk(KERN_ERR "Can't alloc memory for 'fsl_rio_pw'\n");
+		rc = -ENOMEM;
+		goto err_pw;
+	}
+	pw->dev = &dev->dev;
+	pw->pwirq = irq_of_parse_and_map(dev->dev.of_node, 0);
+	dev_info(&dev->dev, "pwirq: %d\n", pw->pwirq);
+	pw->pw_regs = (struct rio_pw_regs *)(rio_regs_win +
+					RIO_S_PW_REGS_OFFSET);
+	fsl_rio_port_write_init(pw);
+
+	rmu_node = of_parse_phandle(dev->dev.of_node, "rmu-handle", 0);
+	if (!rmu_node)
+		goto err_rmu;
+
+	rc = of_address_to_resource(rmu_node, 0, &rmu_regs);
+	if (rc) {
+		dev_err(&dev->dev, "Can't get %s property 'reg'\n",
+				rmu_node->full_name);
+		goto err_rmu;
+	}
+	rmu_regs_win = ioremap(rmu_regs.start, resource_size(&rmu_regs));
+	if (!rmu_regs_win) {
+		printk(KERN_ERR "Unable to map rmu register window\n");
 		rc = -ENOMEM;
-		goto err_priv;
+		goto err_rmu;
 	}
 
-	INIT_LIST_HEAD(&port->dbells);
-	port->iores.start = law_start;
-	port->iores.end = law_start + law_size - 1;
-	port->iores.flags = IORESOURCE_MEM;
-	port->iores.name = "rio_io_win";
-
-	if (request_resource(&iomem_resource, &port->iores) < 0) {
-		dev_err(&dev->dev, "RIO: Error requesting master port region"
-			" 0x%016llx-0x%016llx\n",
-			(u64)port->iores.start, (u64)port->iores.end);
-			rc = -ENOMEM;
-			goto err_res;
+	for_each_child_of_node(rmu_node, np) {
+		rmu_np[tmp] = np;
+		tmp++;
 	}
 
-	priv->pwirq = irq_of_parse_and_map(dev->dev.of_node, 0);
-	dev_info(&dev->dev, "pwirq: %d\n", priv->pwirq);
-	strcpy(port->name, "RIO0 mport");
-
-	priv->dev = &dev->dev;
-
-	port->ops = ops;
-	port->priv = priv;
-	port->phys_efptr = 0x100;
-
-	priv->regs_win = ioremap(regs.start, resource_size(&regs));
-	rio_regs_win = priv->regs_win;
-
-	/* Probe the master port phy type */
-	ccsr = in_be32(priv->regs_win + RIO_CCSR);
-	port->phy_type = (ccsr & 1) ? RIO_PHY_SERIAL : RIO_PHY_PARALLEL;
-	dev_info(&dev->dev, "RapidIO PHY type: %s\n",
-			(port->phy_type == RIO_PHY_PARALLEL) ? "parallel" :
-			((port->phy_type == RIO_PHY_SERIAL) ? "serial" :
-			 "unknown"));
-	/* Checking the port training status */
-	if (in_be32((priv->regs_win + RIO_ESCSR)) & 1) {
-		dev_err(&dev->dev, "Port is not ready. "
-			"Try to restart connection...\n");
-		switch (port->phy_type) {
-		case RIO_PHY_SERIAL:
-			/* Disable ports */
-			out_be32(priv->regs_win + RIO_CCSR, 0);
-			/* Set 1x lane */
-			setbits32(priv->regs_win + RIO_CCSR, 0x02000000);
-			/* Enable ports */
-			setbits32(priv->regs_win + RIO_CCSR, 0x00600000);
-			break;
-		case RIO_PHY_PARALLEL:
-			/* Disable ports */
-			out_be32(priv->regs_win + RIO_CCSR, 0x22000000);
-			/* Enable ports */
-			out_be32(priv->regs_win + RIO_CCSR, 0x44000000);
-			break;
+	for (i = 0; i < *ports_num; i++) {
+		port = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);
+		if (!port)
+			continue;
+
+		port->index = i;
+
+		priv = kzalloc(sizeof(struct rio_priv), GFP_KERNEL);
+		if (!priv) {
+			printk(KERN_ERR "Can't alloc memory for 'priv'\n");
+			kfree(port);
+			continue;
+		}
+
+		INIT_LIST_HEAD(&port->dbells);
+		port->iores.start = law_start + i *
+					(law_size >> (ilog2(*ports_num)));
+		port->iores.end = port->iores.start +
+					(law_size >> (ilog2(*ports_num)))
+					- 1;
+		port->iores.flags = IORESOURCE_MEM;
+		port->iores.name = "rio_io_win";
+
+		if (request_resource(&iomem_resource, &port->iores) < 0) {
+			dev_err(&dev->dev, "RIO: Error requesting master port region"
+				" 0x%016llx-0x%016llx\n",
+				(u64)port->iores.start, (u64)port->iores.end);
+				kfree(priv);
+				kfree(port);
+				continue;
 		}
-		msleep(100);
-		if (in_be32((priv->regs_win + RIO_ESCSR)) & 1) {
-			dev_err(&dev->dev, "Port restart failed.\n");
-			rc = -ENOLINK;
-			goto err;
+		sprintf(port->name, "RIO mport %d", i);
+
+		priv->dev = &dev->dev;
+
+		port->ops = ops;
+		port->priv = priv;
+		port->phys_efptr = 0x100;
+
+		priv->regs_win = rio_regs_win;
+
+		/* Probe the master port phy type */
+		ccsr = in_be32(priv->regs_win + RIO_CCSR + i*0x20);
+		port->phy_type = (ccsr & 1) ? RIO_PHY_SERIAL : RIO_PHY_PARALLEL;
+		dev_info(&dev->dev, "RapidIO PHY type: %s\n",
+				(port->phy_type == RIO_PHY_PARALLEL) ?
+				"parallel" :
+				((port->phy_type == RIO_PHY_SERIAL) ? "serial" :
+				 "unknown"));
+		/* Checking the port training status */
+		if (in_be32((priv->regs_win + RIO_ESCSR + i*0x20)) & 1) {
+			dev_err(&dev->dev, "Port %d is not ready. "
+				"Try to restart connection...\n", i);
+			switch (port->phy_type) {
+			case RIO_PHY_SERIAL:
+				/* Disable ports */
+				out_be32(priv->regs_win
+					+ RIO_CCSR + i*0x20, 0);
+				/* Set 1x lane */
+				setbits32(priv->regs_win
+					+ RIO_CCSR + i*0x20, 0x02000000);
+				/* Enable ports */
+				setbits32(priv->regs_win
+					+ RIO_CCSR + i*0x20, 0x00600000);
+				break;
+			case RIO_PHY_PARALLEL:
+				/* Disable ports */
+				out_be32(priv->regs_win
+					+ RIO_CCSR + i*0x20, 0x22000000);
+				/* Enable ports */
+				out_be32(priv->regs_win
+					+ RIO_CCSR + i*0x20, 0x44000000);
+				break;
+			}
+			msleep(100);
+			if (in_be32((priv->regs_win
+					+ RIO_ESCSR + i*0x20)) & 1) {
+				dev_err(&dev->dev,
+					"Port %d restart failed.\n", i);
+				release_resource(&port->iores);
+				kfree(priv);
+				kfree(port);
+				continue;
+			}
+			dev_info(&dev->dev, "Port %d restart success!\n", i);
 		}
-		dev_info(&dev->dev, "Port restart success!\n");
-	}
-	fsl_rio_info(&dev->dev, ccsr);
+		fsl_rio_info(&dev->dev, ccsr);
 
-	port->sys_size = (in_be32((priv->regs_win + RIO_PEF_CAR))
+		port->sys_size = (in_be32((priv->regs_win + RIO_PEF_CAR))
 					& RIO_PEF_CTLS) >> 4;
-	dev_info(&dev->dev, "RapidIO Common Transport System size: %d\n",
-			port->sys_size ? 65536 : 256);
+		dev_info(&dev->dev, "RapidIO Common Transport System size: %d\n",
+				port->sys_size ? 65536 : 256);
+
+		if (rio_register_mport(port)) {
+			release_resource(&port->iores);
+			kfree(priv);
+			kfree(port);
+			continue;
+		}
+		if (port->host_deviceid >= 0)
+			out_be32(priv->regs_win + RIO_GCCSR, RIO_PORT_GEN_HOST |
+				RIO_PORT_GEN_MASTER | RIO_PORT_GEN_DISCOVERED);
+		else
+			out_be32(priv->regs_win + RIO_GCCSR,
+				RIO_PORT_GEN_MASTER);
 
-	if (rio_register_mport(port))
-		goto err;
+		priv->atmu_regs = (struct rio_atmu_regs *)(priv->regs_win
+			+ ((i == 0) ? RIO_ATMU_REGS_PORT1_OFFSET :
+			RIO_ATMU_REGS_PORT2_OFFSET));
 
-	if (port->host_deviceid >= 0)
-		out_be32(priv->regs_win + RIO_GCCSR, RIO_PORT_GEN_HOST |
-			RIO_PORT_GEN_MASTER | RIO_PORT_GEN_DISCOVERED);
-	else
-		out_be32(priv->regs_win + RIO_GCCSR, 0x00000000);
+		priv->maint_atmu_regs = priv->atmu_regs + 1;
 
-	priv->atmu_regs = (struct rio_atmu_regs *)(priv->regs_win
-					+ RIO_ATMU_REGS_OFFSET);
-	priv->maint_atmu_regs = priv->atmu_regs + 1;
+		/* Set to receive any dist ID for serial RapidIO controller. */
+		if (port->phy_type == RIO_PHY_SERIAL)
+			out_be32((priv->regs_win
+				+ RIO_ISR_AACR + i*0x80), RIO_ISR_AACR_AA);
 
-	/* Set to receive any dist ID for serial RapidIO controller. */
-	if (port->phy_type == RIO_PHY_SERIAL)
-		out_be32((priv->regs_win + RIO_ISR_AACR), RIO_ISR_AACR_AA);
+		/* Configure maintenance transaction window */
+		out_be32(&priv->maint_atmu_regs->rowbar,
+			port->iores.start >> 12);
+		out_be32(&priv->maint_atmu_regs->rowar,
+			 0x80077000 | (ilog2(RIO_MAINT_WIN_SIZE) - 1));
 
-	/* Configure maintenance transaction window */
-	out_be32(&priv->maint_atmu_regs->rowbar, law_start >> 12);
-	out_be32(&priv->maint_atmu_regs->rowar,
-		 0x80077000 | (ilog2(RIO_MAINT_WIN_SIZE) - 1));
+		priv->maint_win = ioremap(port->iores.start,
+				RIO_MAINT_WIN_SIZE);
 
-	priv->maint_win = ioremap(law_start, RIO_MAINT_WIN_SIZE);
+		fsl_rio_setup_rmu(port, rmu_np[i]);
 
-	fsl_rio_setup_rmu(port, dev->dev.of_node);
+		dbell->mport[i] = port;
 
-	fsl_rio_port_write_init(port);
+		active_ports++;
+	}
+
+	if (!active_ports) {
+		rc = -ENOLINK;
+		goto err;
+	}
 
 	return 0;
 err:
-	iounmap(priv->regs_win);
-	release_resource(&port->iores);
-err_res:
-	kfree(priv);
-err_priv:
-	kfree(port);
-err_port:
+	iounmap(rmu_regs_win);
+err_rmu:
+	kfree(pw);
+err_pw:
+	kfree(dbell);
+err_dbell:
 	kfree(ops);
 err_ops:
+	iounmap(rio_regs_win);
+err_rio_regs:
 	return rc;
 }
 
diff --git a/arch/powerpc/sysdev/fsl_rio.h b/arch/powerpc/sysdev/fsl_rio.h
index f888a1e..b9e7d1f 100644
--- a/arch/powerpc/sysdev/fsl_rio.h
+++ b/arch/powerpc/sysdev/fsl_rio.h
@@ -36,6 +36,24 @@
 #define RIO_MAINT_WIN_SIZE	0x400000
 #define RIO_LTLEDCSR		0x0608
 
+#define DOORBELL_ROWAR_EN	0x80000000
+#define DOORBELL_ROWAR_TFLOWLV	0x08000000 /* highest priority level */
+#define DOORBELL_ROWAR_PCI	0x02000000 /* PCI window */
+#define DOORBELL_ROWAR_NREAD	0x00040000 /* NREAD */
+#define DOORBELL_ROWAR_MAINTRD	0x00070000  /* maintenance read */
+#define DOORBELL_ROWAR_RES	0x00002000 /* wrtpy: reserverd */
+#define DOORBELL_ROWAR_MAINTWD	0x00007000
+#define DOORBELL_ROWAR_SIZE	0x0000000b /* window size is 4k */
+
+#define RIO_ATMU_REGS_PORT1_OFFSET	0x10c00
+#define RIO_ATMU_REGS_PORT2_OFFSET	0x10e00
+#define RIO_S_DBELL_REGS_OFFSET	0x13400
+#define RIO_S_PW_REGS_OFFSET	0x134e0
+#define RIO_ATMU_REGS_DBELL_OFFSET	0x10C40
+
+#define MAX_MSG_UNIT_NUM	2
+#define MAX_PORT_NUM		4
+
 struct rio_atmu_regs {
 	 u32 rowtar;
 	 u32 rowtear;
@@ -45,6 +63,11 @@ struct rio_atmu_regs {
 	 u32 pad3[3];
 };
 
+struct rio_dbell_ring {
+	void *virt;
+	dma_addr_t phys;
+};
+
 struct rio_port_write_msg {
 	 void *virt;
 	 dma_addr_t phys;
@@ -53,26 +76,62 @@ struct rio_port_write_msg {
 	 u32 discard_count;
 };
 
-struct rio_priv {
+struct fsl_rio_dbell {
+	struct rio_mport *mport[MAX_PORT_NUM];
 	struct device *dev;
-	void __iomem *regs_win;
-	struct rio_atmu_regs __iomem *atmu_regs;
-	struct rio_atmu_regs __iomem *maint_atmu_regs;
-	void __iomem *maint_win;
+	struct rio_dbell_regs __iomem *dbell_regs;
+	struct rio_atmu_regs __iomem *dbell_atmu_regs;
+	void __iomem *dbell_win;
+	struct rio_dbell_ring dbell_ring;
+	int bellirq;
+};
+
+struct fsl_rio_pw {
+	struct device *dev;
+	struct rio_pw_regs __iomem *pw_regs;
 	struct rio_port_write_msg port_write_msg;
 	int pwirq;
 	struct work_struct pw_work;
 	struct kfifo pw_fifo;
 	spinlock_t pw_fifo_lock;
+};
+
+struct rio_priv {
+	struct device *dev;
+	void __iomem *regs_win;
+	struct rio_atmu_regs __iomem *atmu_regs;
+	struct rio_atmu_regs __iomem *maint_atmu_regs;
+	void __iomem *maint_win;
 	void *rmm_handle; /* RapidIO message manager(unit) Handle */
 };
 
 extern void __iomem *rio_regs_win;
+extern void __iomem *rmu_regs_win;
+
+extern resource_size_t rio_law_start;
+
+extern struct fsl_rio_dbell *dbell;
+extern struct fsl_rio_pw *pw;
 
 extern int fsl_rio_setup_rmu(struct rio_mport *mport,
 	struct device_node *node);
-extern int fsl_rio_port_write_init(struct rio_mport *mport);
+extern int fsl_rio_port_write_init(struct fsl_rio_pw *pw);
 extern int fsl_rio_pw_enable(struct rio_mport *mport, int enable);
-extern void fsl_rio_port_error_handler(struct rio_mport *port, int offset);
+extern void fsl_rio_port_error_handler(int offset);
+extern int fsl_rio_doorbell_init(struct fsl_rio_dbell *dbell);
+
+extern int fsl_rio_doorbell_send(struct rio_mport *mport,
+				int index, u16 destid, u16 data);
+extern int fsl_add_outb_message(struct rio_mport *mport,
+	struct rio_dev *rdev,
+	int mbox, void *buffer, size_t len);
+extern int fsl_open_outb_mbox(struct rio_mport *mport,
+	void *dev_id, int mbox, int entries);
+extern void fsl_close_outb_mbox(struct rio_mport *mport, int mbox);
+extern int fsl_open_inb_mbox(struct rio_mport *mport,
+	void *dev_id, int mbox, int entries);
+extern void fsl_close_inb_mbox(struct rio_mport *mport, int mbox);
+extern int fsl_add_inb_buffer(struct rio_mport *mport, int mbox, void *buf);
+extern void *fsl_get_inb_message(struct rio_mport *mport, int mbox);
 
 #endif
diff --git a/arch/powerpc/sysdev/fsl_rmu.c b/arch/powerpc/sysdev/fsl_rmu.c
index 0a3e6cf..4686db3 100644
--- a/arch/powerpc/sysdev/fsl_rmu.c
+++ b/arch/powerpc/sysdev/fsl_rmu.c
@@ -36,8 +36,8 @@
 		(((struct rio_priv *)(mport->priv))->rmm_handle)
 
 /* RapidIO definition irq, which read from OF-tree */
-#define IRQ_RIO_PW(m)		(((struct rio_priv *)(m->priv))->pwirq)
-#define IRQ_RIO_BELL(m) (((struct fsl_rmu *)(GET_RMM_HANDLE(m)))->bellirq)
+#define IRQ_RIO_PW(m)		(((struct fsl_rio_pw *)(m))->pwirq)
+#define IRQ_RIO_BELL(m) (((struct fsl_rio_dbell *)(m))->bellirq)
 #define IRQ_RIO_TX(m) (((struct fsl_rmu *)(GET_RMM_HANDLE(m)))->txirq)
 #define IRQ_RIO_RX(m) (((struct fsl_rmu *)(GET_RMM_HANDLE(m)))->rxirq)
 
@@ -113,61 +113,53 @@
 #define DBELL_INF(x)		(*(u16 *)(x + DOORBELL_INFO_OFFSET))
 
 struct rio_msg_regs {
-	u32 omr;	/* 0xD_3000 - Outbound message 0 mode register */
-	u32 osr;	/* 0xD_3004 - Outbound message 0 status register */
+	u32 omr;
+	u32 osr;
 	u32 pad1;
-	u32 odqdpar;	/* 0xD_300C - Outbound message 0 descriptor queue
-			   dequeue pointer address register */
+	u32 odqdpar;
 	u32 pad2;
-	u32 osar;	/* 0xD_3014 - Outbound message 0 source address
-			   register */
-	u32 odpr;	/* 0xD_3018 - Outbound message 0 destination port
-			   register */
-	u32 odatr;	/* 0xD_301C - Outbound message 0 destination attributes
-			   Register*/
-	u32 odcr;	/* 0xD_3020 - Outbound message 0 double-word count
-			   register */
+	u32 osar;
+	u32 odpr;
+	u32 odatr;
+	u32 odcr;
 	u32 pad3;
-	u32 odqepar;	/* 0xD_3028 - Outbound message 0 descriptor queue
-			   enqueue pointer address register */
+	u32 odqepar;
 	u32 pad4[13];
-	u32 imr;	/* 0xD_3060 - Inbound message 0 mode register */
-	u32 isr;	/* 0xD_3064 - Inbound message 0 status register */
+	u32 imr;
+	u32 isr;
 	u32 pad5;
-	u32 ifqdpar;	/* 0xD_306C - Inbound message 0 frame queue dequeue
-			   pointer address register*/
+	u32 ifqdpar;
 	u32 pad6;
-	u32 ifqepar;	/* 0xD_3074 - Inbound message 0 frame queue enqueue
-			   pointer address register */
-	u32 pad7[226];
-	u32 odmr;	/* 0xD_3400 - Outbound doorbell mode register */
-	u32 odsr;	/* 0xD_3404 - Outbound doorbell status register */
+	u32 ifqepar;
+	u32 pad7;
+};
+
+struct rio_dbell_regs {
+	u32 odmr;
+	u32 odsr;
 	u32 res0[4];
-	u32 oddpr;	/* 0xD_3418 - Outbound doorbell destination port
-			   register */
-	u32 oddatr;	/* 0xD_341c - Outbound doorbell destination attributes
-			   register */
+	u32 oddpr;
+	u32 oddatr;
 	u32 res1[3];
-	u32 odretcr;	/* 0xD_342C - Outbound doorbell retry error threshold
-			   configuration register */
+	u32 odretcr;
 	u32 res2[12];
-	u32 dmr;	/* 0xD_3460 - Inbound doorbell mode register */
-	u32 dsr;	/* 0xD_3464 - Inbound doorbell status register */
+	u32 dmr;
+	u32 dsr;
 	u32 pad8;
-	u32 dqdpar;	/* 0xD_346C - Inbound doorbell queue dequeue Pointer
-			   address register */
+	u32 dqdpar;
 	u32 pad9;
-	u32 dqepar;	/* 0xD_3474 - Inbound doorbell Queue enqueue pointer
-			   address register */
+	u32 dqepar;
 	u32 pad10[26];
-	u32 pwmr;	/* 0xD_34E0 - Inbound port-write mode register */
-	u32 pwsr;	/* 0xD_34E4 - Inbound port-write status register */
-	u32 epwqbar;	/* 0xD_34E8 - Extended Port-Write Queue Base Address
-			   register */
-	u32 pwqbar;	/* 0xD_34EC - Inbound port-write queue base address
-			   register */
 };
 
+struct rio_pw_regs {
+	u32 pwmr;
+	u32 pwsr;
+	u32 epwqbar;
+	u32 pwqbar;
+};
+
+
 struct rio_tx_desc {
 	u32 res1;
 	u32 saddr;
@@ -179,11 +171,6 @@ struct rio_tx_desc {
 	u32 res4;
 };
 
-struct rio_dbell_ring {
-	void *virt;
-	dma_addr_t phys;
-};
-
 struct rio_msg_tx_ring {
 	void *virt;
 	dma_addr_t phys;
@@ -204,13 +191,9 @@ struct rio_msg_rx_ring {
 };
 
 struct fsl_rmu {
-	struct rio_atmu_regs __iomem *dbell_atmu_regs;
-	void __iomem *dbell_win;
 	struct rio_msg_regs __iomem *msg_regs;
-	struct rio_dbell_ring dbell_ring;
 	struct rio_msg_tx_ring msg_tx_ring;
 	struct rio_msg_rx_ring msg_rx_ring;
-	int bellirq;
 	int txirq;
 	int rxirq;
 };
@@ -247,9 +230,11 @@ fsl_rio_tx_handler(int irq, void *dev_instance)
 	if (osr & RIO_MSG_OSR_EOMI) {
 		u32 dqp = in_be32(&rmu->msg_regs->odqdpar);
 		int slot = (dqp - rmu->msg_tx_ring.phys) >> 5;
-		port->outb_msg[0].mcback(port, rmu->msg_tx_ring.dev_id, -1,
-				slot);
-
+		if (port->outb_msg[0].mcback != NULL) {
+			port->outb_msg[0].mcback(port, rmu->msg_tx_ring.dev_id,
+					-1,
+					slot);
+		}
 		/* Ack the end-of-message interrupt */
 		out_be32(&rmu->msg_regs->osr, RIO_MSG_OSR_EOMI);
 	}
@@ -284,12 +269,14 @@ fsl_rio_rx_handler(int irq, void *dev_instance)
 	/* XXX Need to check/dispatch until queue empty */
 	if (isr & RIO_MSG_ISR_DIQI) {
 		/*
-		 * We implement *only* mailbox 0, but can receive messages
-		 * for any mailbox/letter to that mailbox destination. So,
-		 * make the callback with an unknown/invalid mailbox number
-		 * argument.
-		 */
-		port->inb_msg[0].mcback(port, rmu->msg_rx_ring.dev_id, -1, -1);
+		* Can receive messages for any mailbox/letter to that
+		* mailbox destination. So, make the callback with an
+		* unknown/invalid mailbox number argument.
+		*/
+		if (port->inb_msg[0].mcback != NULL)
+			port->inb_msg[0].mcback(port, rmu->msg_rx_ring.dev_id,
+				-1,
+				-1);
 
 		/* Ack the queueing interrupt */
 		out_be32(&rmu->msg_regs->isr, RIO_MSG_ISR_DIQI);
@@ -311,27 +298,27 @@ static irqreturn_t
 fsl_rio_dbell_handler(int irq, void *dev_instance)
 {
 	int dsr;
-	struct rio_mport *port = (struct rio_mport *)dev_instance;
-	struct fsl_rmu *rmu = GET_RMM_HANDLE(port);
+	struct fsl_rio_dbell *fsl_dbell = (struct fsl_rio_dbell *)dev_instance;
+	int i;
 
-	dsr = in_be32(&rmu->msg_regs->dsr);
+	dsr = in_be32(&fsl_dbell->dbell_regs->dsr);
 
 	if (dsr & DOORBELL_DSR_TE) {
 		pr_info("RIO: doorbell reception error\n");
-		out_be32(&rmu->msg_regs->dsr, DOORBELL_DSR_TE);
+		out_be32(&fsl_dbell->dbell_regs->dsr, DOORBELL_DSR_TE);
 		goto out;
 	}
 
 	if (dsr & DOORBELL_DSR_QFI) {
 		pr_info("RIO: doorbell queue full\n");
-		out_be32(&rmu->msg_regs->dsr, DOORBELL_DSR_QFI);
+		out_be32(&fsl_dbell->dbell_regs->dsr, DOORBELL_DSR_QFI);
 	}
 
 	/* XXX Need to check/dispatch until queue empty */
 	if (dsr & DOORBELL_DSR_DIQI) {
 		u32 dmsg =
-			(u32) rmu->dbell_ring.virt +
-			(in_be32(&rmu->msg_regs->dqdpar) & 0xfff);
+			(u32) fsl_dbell->dbell_ring.virt +
+			(in_be32(&fsl_dbell->dbell_regs->dqdpar) & 0xfff);
 		struct rio_dbell *dbell;
 		int found = 0;
 
@@ -340,35 +327,45 @@ fsl_rio_dbell_handler(int irq, void *dev_instance)
 			" sid %2.2x tid %2.2x info %4.4x\n",
 			DBELL_SID(dmsg), DBELL_TID(dmsg), DBELL_INF(dmsg));
 
-		list_for_each_entry(dbell, &port->dbells, node) {
-			if ((dbell->res->start <= DBELL_INF(dmsg)) &&
-				(dbell->res->end >= DBELL_INF(dmsg))) {
-				found = 1;
-				break;
+		for (i = 0; i < MAX_PORT_NUM; i++) {
+			if (fsl_dbell->mport[i]) {
+				list_for_each_entry(dbell,
+					&fsl_dbell->mport[i]->dbells, node) {
+					if ((dbell->res->start
+						<= DBELL_INF(dmsg))
+						&& (dbell->res->end
+						>= DBELL_INF(dmsg))) {
+						found = 1;
+						break;
+					}
+				}
+				if (found && dbell->dinb) {
+					dbell->dinb(fsl_dbell->mport[i],
+						dbell->dev_id, DBELL_SID(dmsg),
+						DBELL_TID(dmsg),
+						DBELL_INF(dmsg));
+					break;
+				}
 			}
 		}
-		if (found) {
-			dbell->dinb(port, dbell->dev_id,
-					DBELL_SID(dmsg),
-					DBELL_TID(dmsg), DBELL_INF(dmsg));
-		} else {
+
+		if (!found) {
 			pr_debug
 				("RIO: spurious doorbell,"
 				" sid %2.2x tid %2.2x info %4.4x\n",
 				DBELL_SID(dmsg), DBELL_TID(dmsg),
 				DBELL_INF(dmsg));
 		}
-		setbits32(&rmu->msg_regs->dmr, DOORBELL_DMR_DI);
-		out_be32(&rmu->msg_regs->dsr, DOORBELL_DSR_DIQI);
+		setbits32(&fsl_dbell->dbell_regs->dmr, DOORBELL_DMR_DI);
+		out_be32(&fsl_dbell->dbell_regs->dsr, DOORBELL_DSR_DIQI);
 	}
 
 out:
 	return IRQ_HANDLED;
 }
 
-void msg_unit_error_handler(struct rio_mport *port)
+void msg_unit_error_handler(void)
 {
-	struct fsl_rmu *rmu = GET_RMM_HANDLE(port);
 
 	/*XXX: Error recovery is not implemented, we just clear errors */
 	out_be32((u32 *)(rio_regs_win + RIO_LTLEDCSR), 0);
@@ -378,10 +375,10 @@ void msg_unit_error_handler(struct rio_mport *port)
 	out_be32((u32 *)(rio_regs_win + RIO_OM0SR), OMSR_CLEAR);
 	out_be32((u32 *)(rio_regs_win + RIO_OM1SR), OMSR_CLEAR);
 
-	out_be32(&rmu->msg_regs->odsr, ODSR_CLEAR);
-	out_be32(&rmu->msg_regs->dsr, IDSR_CLEAR);
+	out_be32(&dbell->dbell_regs->odsr, ODSR_CLEAR);
+	out_be32(&dbell->dbell_regs->dsr, IDSR_CLEAR);
 
-	out_be32(&rmu->msg_regs->pwsr, IPWSR_CLEAR);
+	out_be32(&pw->pw_regs->pwsr, IPWSR_CLEAR);
 }
 
 /**
@@ -396,18 +393,15 @@ static irqreturn_t
 fsl_rio_port_write_handler(int irq, void *dev_instance)
 {
 	u32 ipwmr, ipwsr;
-	struct rio_mport *port = (struct rio_mport *)dev_instance;
-	struct rio_priv *priv = port->priv;
-	struct fsl_rmu *rmu;
+	struct fsl_rio_pw *pw = (struct fsl_rio_pw *)dev_instance;
 	u32 epwisr, tmp;
 
-	rmu = GET_RMM_HANDLE(port);
-	epwisr = in_be32(priv->regs_win + RIO_EPWISR);
+	epwisr = in_be32(rio_regs_win + RIO_EPWISR);
 	if (!(epwisr & RIO_EPWISR_PW))
 		goto pw_done;
 
-	ipwmr = in_be32(&rmu->msg_regs->pwmr);
-	ipwsr = in_be32(&rmu->msg_regs->pwsr);
+	ipwmr = in_be32(&pw->pw_regs->pwmr);
+	ipwsr = in_be32(&pw->pw_regs->pwsr);
 
 #ifdef DEBUG_PW
 	pr_debug("PW Int->IPWMR: 0x%08x IPWSR: 0x%08x (", ipwmr, ipwsr);
@@ -428,60 +422,60 @@ fsl_rio_port_write_handler(int irq, void *dev_instance)
 		/* Save PW message (if there is room in FIFO),
 		 * otherwise discard it.
 		 */
-		if (kfifo_avail(&priv->pw_fifo) >= RIO_PW_MSG_SIZE) {
-			priv->port_write_msg.msg_count++;
-			kfifo_in(&priv->pw_fifo, priv->port_write_msg.virt,
+		if (kfifo_avail(&pw->pw_fifo) >= RIO_PW_MSG_SIZE) {
+			pw->port_write_msg.msg_count++;
+			kfifo_in(&pw->pw_fifo, pw->port_write_msg.virt,
 				 RIO_PW_MSG_SIZE);
 		} else {
-			priv->port_write_msg.discard_count++;
+			pw->port_write_msg.discard_count++;
 			pr_debug("RIO: ISR Discarded Port-Write Msg(s) (%d)\n",
-				 priv->port_write_msg.discard_count);
+				 pw->port_write_msg.discard_count);
 		}
 		/* Clear interrupt and issue Clear Queue command. This allows
 		 * another port-write to be received.
 		 */
-		out_be32(&rmu->msg_regs->pwsr,	RIO_IPWSR_QFI);
-		out_be32(&rmu->msg_regs->pwmr, ipwmr | RIO_IPWMR_CQ);
+		out_be32(&pw->pw_regs->pwsr,	RIO_IPWSR_QFI);
+		out_be32(&pw->pw_regs->pwmr, ipwmr | RIO_IPWMR_CQ);
 
-		schedule_work(&priv->pw_work);
+		schedule_work(&pw->pw_work);
 	}
 
 	if ((ipwmr & RIO_IPWMR_EIE) && (ipwsr & RIO_IPWSR_TE)) {
-		priv->port_write_msg.err_count++;
+		pw->port_write_msg.err_count++;
 		pr_debug("RIO: Port-Write Transaction Err (%d)\n",
-			 priv->port_write_msg.err_count);
+			 pw->port_write_msg.err_count);
 		/* Clear Transaction Error: port-write controller should be
 		 * disabled when clearing this error
 		 */
-		out_be32(&rmu->msg_regs->pwmr, ipwmr & ~RIO_IPWMR_PWE);
-		out_be32(&rmu->msg_regs->pwsr,	RIO_IPWSR_TE);
-		out_be32(&rmu->msg_regs->pwmr, ipwmr);
+		out_be32(&pw->pw_regs->pwmr, ipwmr & ~RIO_IPWMR_PWE);
+		out_be32(&pw->pw_regs->pwsr,	RIO_IPWSR_TE);
+		out_be32(&pw->pw_regs->pwmr, ipwmr);
 	}
 
 	if (ipwsr & RIO_IPWSR_PWD) {
-		priv->port_write_msg.discard_count++;
+		pw->port_write_msg.discard_count++;
 		pr_debug("RIO: Port Discarded Port-Write Msg(s) (%d)\n",
-			 priv->port_write_msg.discard_count);
-		out_be32(&rmu->msg_regs->pwsr, RIO_IPWSR_PWD);
+			 pw->port_write_msg.discard_count);
+		out_be32(&pw->pw_regs->pwsr, RIO_IPWSR_PWD);
 	}
 
 pw_done:
 	if (epwisr & RIO_EPWISR_PINT1) {
-		tmp = in_be32(priv->regs_win + RIO_LTLEDCSR);
+		tmp = in_be32(rio_regs_win + RIO_LTLEDCSR);
 		pr_debug("RIO_LTLEDCSR = 0x%x\n", tmp);
-		fsl_rio_port_error_handler(port, 0);
+		fsl_rio_port_error_handler(0);
 	}
 
 	if (epwisr & RIO_EPWISR_PINT2) {
-		tmp = in_be32(priv->regs_win + RIO_LTLEDCSR);
+		tmp = in_be32(rio_regs_win + RIO_LTLEDCSR);
 		pr_debug("RIO_LTLEDCSR = 0x%x\n", tmp);
-		fsl_rio_port_error_handler(port, 1);
+		fsl_rio_port_error_handler(1);
 	}
 
 	if (epwisr & RIO_EPWISR_MU) {
-		tmp = in_be32(priv->regs_win + RIO_LTLEDCSR);
+		tmp = in_be32(rio_regs_win + RIO_LTLEDCSR);
 		pr_debug("RIO_LTLEDCSR = 0x%x\n", tmp);
-		msg_unit_error_handler(port);
+		msg_unit_error_handler();
 	}
 
 	return IRQ_HANDLED;
@@ -489,18 +483,18 @@ pw_done:
 
 static void fsl_pw_dpc(struct work_struct *work)
 {
-	struct rio_priv *priv = container_of(work, struct rio_priv, pw_work);
+	struct fsl_rio_pw *pw = container_of(work, struct fsl_rio_pw, pw_work);
 	unsigned long flags;
 	u32 msg_buffer[RIO_PW_MSG_SIZE/sizeof(u32)];
 
 	/*
 	 * Process port-write messages
 	 */
-	spin_lock_irqsave(&priv->pw_fifo_lock, flags);
-	while (kfifo_out(&priv->pw_fifo, (unsigned char *)msg_buffer,
+	spin_lock_irqsave(&pw->pw_fifo_lock, flags);
+	while (kfifo_out(&pw->pw_fifo, (unsigned char *)msg_buffer,
 			 RIO_PW_MSG_SIZE)) {
 		/* Process one message */
-		spin_unlock_irqrestore(&priv->pw_fifo_lock, flags);
+		spin_unlock_irqrestore(&pw->pw_fifo_lock, flags);
 #ifdef DEBUG_PW
 		{
 		u32 i;
@@ -517,31 +511,28 @@ static void fsl_pw_dpc(struct work_struct *work)
 #endif
 		/* Pass the port-write message to RIO core for processing */
 		rio_inb_pwrite_handler((union rio_pw_msg *)msg_buffer);
-		spin_lock_irqsave(&priv->pw_fifo_lock, flags);
+		spin_lock_irqsave(&pw->pw_fifo_lock, flags);
 	}
-	spin_unlock_irqrestore(&priv->pw_fifo_lock, flags);
+	spin_unlock_irqrestore(&pw->pw_fifo_lock, flags);
 }
 
 /**
  * fsl_rio_pw_enable - enable/disable port-write interface init
  * @mport: Master port implementing the port write unit
- * @enable: 1=enable; 0=disable port-write message handling
+ * @enable:    1=enable; 0=disable port-write message handling
  */
 int fsl_rio_pw_enable(struct rio_mport *mport, int enable)
 {
-	struct fsl_rmu *rmu;
 	u32 rval;
 
-	rmu = GET_RMM_HANDLE(mport);
-
-	rval = in_be32(&rmu->msg_regs->pwmr);
+	rval = in_be32(&pw->pw_regs->pwmr);
 
 	if (enable)
 		rval |= RIO_IPWMR_PWE;
 	else
 		rval &= ~RIO_IPWMR_PWE;
 
-	out_be32(&rmu->msg_regs->pwmr, rval);
+	out_be32(&pw->pw_regs->pwmr, rval);
 
 	return 0;
 }
@@ -555,51 +546,47 @@ int fsl_rio_pw_enable(struct rio_mport *mport, int enable)
  * or %-ENOMEM on failure.
  */
 
-int fsl_rio_port_write_init(struct rio_mport *mport)
+int fsl_rio_port_write_init(struct fsl_rio_pw *pw)
 {
-	struct rio_priv *priv = mport->priv;
-	struct fsl_rmu *rmu;
 	int rc = 0;
 
-	rmu = GET_RMM_HANDLE(mport);
-
 	/* Following configurations require a disabled port write controller */
-	out_be32(&rmu->msg_regs->pwmr,
-		 in_be32(&rmu->msg_regs->pwmr) & ~RIO_IPWMR_PWE);
+	out_be32(&pw->pw_regs->pwmr,
+		 in_be32(&pw->pw_regs->pwmr) & ~RIO_IPWMR_PWE);
 
 	/* Initialize port write */
-	priv->port_write_msg.virt = dma_alloc_coherent(priv->dev,
+	pw->port_write_msg.virt = dma_alloc_coherent(pw->dev,
 					RIO_PW_MSG_SIZE,
-					&priv->port_write_msg.phys, GFP_KERNEL);
-	if (!priv->port_write_msg.virt) {
+					&pw->port_write_msg.phys, GFP_KERNEL);
+	if (!pw->port_write_msg.virt) {
 		pr_err("RIO: unable allocate port write queue\n");
 		return -ENOMEM;
 	}
 
-	priv->port_write_msg.err_count = 0;
-	priv->port_write_msg.discard_count = 0;
+	pw->port_write_msg.err_count = 0;
+	pw->port_write_msg.discard_count = 0;
 
 	/* Point dequeue/enqueue pointers at first entry */
-	out_be32(&rmu->msg_regs->epwqbar, 0);
-	out_be32(&rmu->msg_regs->pwqbar, (u32) priv->port_write_msg.phys);
+	out_be32(&pw->pw_regs->epwqbar, 0);
+	out_be32(&pw->pw_regs->pwqbar, (u32) pw->port_write_msg.phys);
 
 	pr_debug("EIPWQBAR: 0x%08x IPWQBAR: 0x%08x\n",
-		 in_be32(&rmu->msg_regs->epwqbar),
-		 in_be32(&rmu->msg_regs->pwqbar));
+		 in_be32(&pw->pw_regs->epwqbar),
+		 in_be32(&pw->pw_regs->pwqbar));
 
 	/* Clear interrupt status IPWSR */
-	out_be32(&rmu->msg_regs->pwsr,
+	out_be32(&pw->pw_regs->pwsr,
 		 (RIO_IPWSR_TE | RIO_IPWSR_QFI | RIO_IPWSR_PWD));
 
 	/* Configure port write contoller for snooping enable all reporting,
 	   clear queue full */
-	out_be32(&rmu->msg_regs->pwmr,
+	out_be32(&pw->pw_regs->pwmr,
 		 RIO_IPWMR_SEN | RIO_IPWMR_QFIE | RIO_IPWMR_EIE | RIO_IPWMR_CQ);
 
 
 	/* Hook up port-write handler */
-	rc = request_irq(IRQ_RIO_PW(mport), fsl_rio_port_write_handler,
-			IRQF_SHARED, "port-write", (void *)mport);
+	rc = request_irq(IRQ_RIO_PW(pw), fsl_rio_port_write_handler,
+			IRQF_SHARED, "port-write", (void *)pw);
 	if (rc < 0) {
 		pr_err("MPC85xx RIO: unable to request inbound doorbell irq");
 		goto err_out;
@@ -607,26 +594,26 @@ int fsl_rio_port_write_init(struct rio_mport *mport)
 	/* Enable Error Interrupt */
 	out_be32((u32 *)(rio_regs_win + RIO_LTLEECSR), LTLEECSR_ENABLE_ALL);
 
-	INIT_WORK(&priv->pw_work, fsl_pw_dpc);
-	spin_lock_init(&priv->pw_fifo_lock);
-	if (kfifo_alloc(&priv->pw_fifo, RIO_PW_MSG_SIZE * 32, GFP_KERNEL)) {
+	INIT_WORK(&pw->pw_work, fsl_pw_dpc);
+	spin_lock_init(&pw->pw_fifo_lock);
+	if (kfifo_alloc(&pw->pw_fifo, RIO_PW_MSG_SIZE * 32, GFP_KERNEL)) {
 		pr_err("FIFO allocation failed\n");
 		rc = -ENOMEM;
 		goto err_out_irq;
 	}
 
 	pr_debug("IPWMR: 0x%08x IPWSR: 0x%08x\n",
-		 in_be32(&rmu->msg_regs->pwmr),
-		 in_be32(&rmu->msg_regs->pwsr));
+		 in_be32(&pw->pw_regs->pwmr),
+		 in_be32(&pw->pw_regs->pwsr));
 
 	return rc;
 
 err_out_irq:
-	free_irq(IRQ_RIO_PW(mport), (void *)mport);
+	free_irq(IRQ_RIO_PW(pw), (void *)pw);
 err_out:
-	dma_free_coherent(priv->dev, RIO_PW_MSG_SIZE,
-		priv->port_write_msg.virt,
-		priv->port_write_msg.phys);
+	dma_free_coherent(pw->dev, RIO_PW_MSG_SIZE,
+		pw->port_write_msg.virt,
+		pw->port_write_msg.phys);
 	return rc;
 }
 
@@ -640,27 +627,25 @@ err_out:
  * Sends a MPC85xx doorbell message. Returns %0 on success or
  * %-EINVAL on failure.
  */
-static int fsl_rio_doorbell_send(struct rio_mport *mport,
+int fsl_rio_doorbell_send(struct rio_mport *mport,
 				int index, u16 destid, u16 data)
 {
-	struct fsl_rmu *rmu = GET_RMM_HANDLE(mport);
-
 	pr_debug("fsl_doorbell_send: index %d destid %4.4x data %4.4x\n",
 		 index, destid, data);
 	switch (mport->phy_type) {
 	case RIO_PHY_PARALLEL:
-		out_be32(&rmu->dbell_atmu_regs->rowtar, destid << 22);
-		out_be16(rmu->dbell_win, data);
+		out_be32(&dbell->dbell_atmu_regs->rowtar, destid << 22);
+		out_be16(dbell->dbell_win, data);
 		break;
 	case RIO_PHY_SERIAL:
 		/* In the serial version silicons, such as MPC8548, MPC8641,
 		 * below operations is must be.
 		 */
-		out_be32(&rmu->msg_regs->odmr, 0x00000000);
-		out_be32(&rmu->msg_regs->odretcr, 0x00000004);
-		out_be32(&rmu->msg_regs->oddpr, destid << 16);
-		out_be32(&rmu->msg_regs->oddatr, data);
-		out_be32(&rmu->msg_regs->odmr, 0x00000001);
+		out_be32(&dbell->dbell_regs->odmr, 0x00000000);
+		out_be32(&dbell->dbell_regs->odretcr, 0x00000004);
+		out_be32(&dbell->dbell_regs->oddpr, destid << 16);
+		out_be32(&dbell->dbell_regs->oddatr, (index << 20) | data);
+		out_be32(&dbell->dbell_regs->odmr, 0x00000001);
 		break;
 	}
 
@@ -678,7 +663,7 @@ static int fsl_rio_doorbell_send(struct rio_mport *mport,
  * Adds the @buffer message to the MPC85xx outbound message queue. Returns
  * %0 on success or %-EINVAL on failure.
  */
-static int
+int
 fsl_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
 			void *buffer, size_t len)
 {
@@ -690,7 +675,6 @@ fsl_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
 
 	pr_debug("RIO: fsl_add_outb_message(): destid %4.4x mbox %d buffer " \
 		 "%8.8x len %8.8x\n", rdev->destid, mbox, (int)buffer, len);
-
 	if ((len < 8) || (len > RIO_MAX_MSG_SIZE)) {
 		ret = -EINVAL;
 		goto out;
@@ -716,7 +700,7 @@ fsl_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
 		desc->dport = (rdev->destid << 16) | (mbox & 0x3);
 
 		/* Enable EOMI interrupt and priority */
-		desc->dattr = 0x28000000;
+		desc->dattr = 0x28000000 | ((mport->index) << 20);
 		break;
 	}
 
@@ -750,7 +734,7 @@ out:
  * and enables the outbound message unit. Returns %0 on success and
  * %-EINVAL or %-ENOMEM on failure.
  */
-static int
+int
 fsl_open_outb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entries)
 {
 	int i, j, rc = 0;
@@ -855,7 +839,7 @@ out_dma:
  * Disables the outbound message unit, free all buffers, and
  * frees the outbound message interrupt.
  */
-static void fsl_close_outb_mbox(struct rio_mport *mport, int mbox)
+void fsl_close_outb_mbox(struct rio_mport *mport, int mbox)
 {
 	struct rio_priv *priv = mport->priv;
 	struct fsl_rmu *rmu = GET_RMM_HANDLE(mport);
@@ -883,7 +867,7 @@ static void fsl_close_outb_mbox(struct rio_mport *mport, int mbox)
  * and enables the inbound message unit. Returns %0 on success
  * and %-EINVAL or %-ENOMEM on failure.
  */
-static int
+int
 fsl_open_inb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entries)
 {
 	int i, rc = 0;
@@ -956,7 +940,7 @@ out:
  * Disables the inbound message unit, free all buffers, and
  * frees the inbound message interrupt.
  */
-static void fsl_close_inb_mbox(struct rio_mport *mport, int mbox)
+void fsl_close_inb_mbox(struct rio_mport *mport, int mbox)
 {
 	struct rio_priv *priv = mport->priv;
 	struct fsl_rmu *rmu = GET_RMM_HANDLE(mport);
@@ -966,7 +950,7 @@ static void fsl_close_inb_mbox(struct rio_mport *mport, int mbox)
 
 	/* Free ring */
 	dma_free_coherent(priv->dev, rmu->msg_rx_ring.size * RIO_MAX_MSG_SIZE,
-			  rmu->msg_rx_ring.virt, rmu->msg_rx_ring.phys);
+	rmu->msg_rx_ring.virt, rmu->msg_rx_ring.phys);
 
 	/* Free interrupt */
 	free_irq(IRQ_RIO_RX(mport), (void *)mport);
@@ -981,7 +965,7 @@ static void fsl_close_inb_mbox(struct rio_mport *mport, int mbox)
  * Adds the @buf buffer to the MPC85xx inbound message queue. Returns
  * %0 on success or %-EINVAL on failure.
  */
-static int fsl_add_inb_buffer(struct rio_mport *mport, int mbox, void *buf)
+int fsl_add_inb_buffer(struct rio_mport *mport, int mbox, void *buf)
 {
 	int rc = 0;
 	struct fsl_rmu *rmu = GET_RMM_HANDLE(mport);
@@ -1013,7 +997,7 @@ out:
  * Gets the next available inbound message from the inbound message queue.
  * A pointer to the message is returned on success or NULL on failure.
  */
-static void *fsl_get_inb_message(struct rio_mport *mport, int mbox)
+void *fsl_get_inb_message(struct rio_mport *mport, int mbox)
 {
 	struct fsl_rmu *rmu = GET_RMM_HANDLE(mport);
 	u32 phys_buf, virt_buf;
@@ -1058,16 +1042,14 @@ out2:
  * ring. Called from fsl_rio_setup(). Returns %0 on success
  * or %-ENOMEM on failure.
  */
-static int fsl_rio_doorbell_init(struct rio_mport *mport)
+int fsl_rio_doorbell_init(struct fsl_rio_dbell *dbell)
 {
-	struct rio_priv *priv = mport->priv;
-	struct fsl_rmu *rmu = GET_RMM_HANDLE(mport);
 	int rc = 0;
 
 	/* Map outbound doorbell window immediately after maintenance window */
-	rmu->dbell_win = ioremap(mport->iores.start + RIO_MAINT_WIN_SIZE,
+	dbell->dbell_win = ioremap(rio_law_start + RIO_MAINT_WIN_SIZE,
 		RIO_DBELL_WIN_SIZE);
-	if (!rmu->dbell_win) {
+	if (!dbell->dbell_win) {
 		printk(KERN_ERR
 			"RIO: unable to map outbound doorbell window\n");
 		rc = -ENOMEM;
@@ -1075,36 +1057,36 @@ static int fsl_rio_doorbell_init(struct rio_mport *mport)
 	}
 
 	/* Initialize inbound doorbells */
-	rmu->dbell_ring.virt = dma_alloc_coherent(priv->dev, 512 *
-		DOORBELL_MESSAGE_SIZE, &rmu->dbell_ring.phys, GFP_KERNEL);
-	if (!rmu->dbell_ring.virt) {
+	dbell->dbell_ring.virt = dma_alloc_coherent(dbell->dev, 512 *
+		DOORBELL_MESSAGE_SIZE, &dbell->dbell_ring.phys, GFP_KERNEL);
+	if (!dbell->dbell_ring.virt) {
 		printk(KERN_ERR "RIO: unable allocate inbound doorbell ring\n");
 		rc = -ENOMEM;
-		iounmap(rmu->dbell_win);
+		iounmap(dbell->dbell_win);
 		goto out;
 	}
 
 	/* Point dequeue/enqueue pointers at first entry in ring */
-	out_be32(&rmu->msg_regs->dqdpar, (u32) rmu->dbell_ring.phys);
-	out_be32(&rmu->msg_regs->dqepar, (u32) rmu->dbell_ring.phys);
+	out_be32(&dbell->dbell_regs->dqdpar, (u32) dbell->dbell_ring.phys);
+	out_be32(&dbell->dbell_regs->dqepar, (u32) dbell->dbell_ring.phys);
 
 	/* Clear interrupt status */
-	out_be32(&rmu->msg_regs->dsr, 0x00000091);
+	out_be32(&dbell->dbell_regs->dsr, 0x00000091);
 
 	/* Hook up doorbell handler */
-	rc = request_irq(IRQ_RIO_BELL(mport), fsl_rio_dbell_handler, 0,
-			 "dbell_rx", (void *)mport);
+	rc = request_irq(IRQ_RIO_BELL(dbell), fsl_rio_dbell_handler, 0,
+			 "dbell_rx", (void *)dbell);
 	if (rc < 0) {
-		iounmap(rmu->dbell_win);
-		dma_free_coherent(priv->dev, 512 * DOORBELL_MESSAGE_SIZE,
-			rmu->dbell_ring.virt, rmu->dbell_ring.phys);
+		iounmap(dbell->dbell_win);
+		dma_free_coherent(dbell->dev, 512 * DOORBELL_MESSAGE_SIZE,
+			 dbell->dbell_ring.virt, dbell->dbell_ring.phys);
 		printk(KERN_ERR
 			"MPC85xx RIO: unable to request inbound doorbell irq");
 		goto out;
 	}
 
 	/* Configure doorbells for snooping, 512 entries, and enable */
-	out_be32(&rmu->msg_regs->dmr, 0x00108161);
+	out_be32(&dbell->dbell_regs->dmr, 0x00108161);
 
 out:
 	return rc;
@@ -1114,50 +1096,50 @@ int fsl_rio_setup_rmu(struct rio_mport *mport, struct device_node *node)
 {
 	struct rio_priv *priv;
 	struct fsl_rmu *rmu;
-	struct rio_ops *ops;
+	u64 msg_start, msg_size;
+	const u32 *msg_addr;
+	int mlen;
+	int aw, sw;
 
-	if (!mport || !mport->priv || !node)
-		return -1;
+	if (!mport || !mport->priv)
+		return -EFAULT;
+
+	priv = mport->priv;
+
+	if (!node) {
+		dev_warn(priv->dev, "Can't get %s property 'fsl,rmu'\n",
+			priv->dev->of_node->full_name);
+		return -EFAULT;
+	}
 
 	rmu = kzalloc(sizeof(struct fsl_rmu), GFP_KERNEL);
 	if (!rmu)
 		return -ENOMEM;
 
-	priv = mport->priv;
+	aw = of_n_addr_cells(node);
+	sw = of_n_size_cells(node);
+	msg_addr = of_get_property(node, "reg", &mlen);
+	msg_start = of_read_number(msg_addr, aw);
+	msg_size = of_read_number(msg_addr + aw, sw);
+	if (!msg_addr) {
+		pr_err("%s: unable to find 'reg' property of message-unit\n",
+			node->full_name);
+		return -ENOMEM;
+	}
+
+	rmu->msg_regs = (struct rio_msg_regs *)
+			(rmu_regs_win + (u32)msg_start);
+
+	rmu->txirq = irq_of_parse_and_map(node, 0);
+	rmu->rxirq = irq_of_parse_and_map(node, 1);
+	printk(KERN_INFO "%s: txirq: %d, rxirq %d\n",
+		node->full_name, rmu->txirq, rmu->rxirq);
+
 	priv->rmm_handle = rmu;
-	rmu->dbell_atmu_regs = priv->atmu_regs + 2;
-	rmu->msg_regs = (struct rio_msg_regs *)(priv->regs_win +
-			 ((mport->phy_type == RIO_PHY_SERIAL) ?
-			 RIO_S_MSG_REGS_OFFSET : RIO_P_MSG_REGS_OFFSET));
-
-	rmu->bellirq = irq_of_parse_and_map(node, 2);
-	rmu->txirq = irq_of_parse_and_map(node, 3);
-	rmu->rxirq = irq_of_parse_and_map(node, 4);
-	dev_info(priv->dev, "bellirq: %d, txirq: %d, rxirq %d\n",
-			rmu->bellirq, rmu->txirq, rmu->rxirq);
-
-	ops = mport->ops;
-
-	ops->dsend = fsl_rio_doorbell_send;
-	ops->open_outb_mbox = fsl_open_outb_mbox;
-	ops->open_inb_mbox = fsl_open_inb_mbox;
-	ops->close_outb_mbox = fsl_close_outb_mbox;
-	ops->close_inb_mbox = fsl_close_inb_mbox;
-	ops->add_outb_message = fsl_add_outb_message;
-	ops->add_inb_buffer = fsl_add_inb_buffer;
-	ops->get_inb_message = fsl_get_inb_message;
 
 	rio_init_dbell_res(&mport->riores[RIO_DOORBELL_RESOURCE], 0, 0xffff);
 	rio_init_mbox_res(&mport->riores[RIO_INB_MBOX_RESOURCE], 0, 0);
 	rio_init_mbox_res(&mport->riores[RIO_OUTB_MBOX_RESOURCE], 0, 0);
 
-	/* Configure outbound doorbell window */
-	out_be32(&rmu->dbell_atmu_regs->rowbar,
-			(mport->iores.start + RIO_MAINT_WIN_SIZE) >> 12);
-	/* 4k window size */
-	out_be32(&rmu->dbell_atmu_regs->rowar, 0x8004200b);
-
-	fsl_rio_doorbell_init(mport);
-
 	return 0;
 }
-- 
1.7.3.1


