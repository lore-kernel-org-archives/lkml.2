Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab1ABMkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 07:40:40 -0500
Received: from mail-ew0-f66.google.com ([209.85.215.66]:47242 "EHLO
	mail-ew0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab1ABMkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 07:40:36 -0500
Message-ID: <4d207242.cc7e0e0a.6f59.3767@mx.google.com>
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Sun, 2 Jan 2011 14:04:00 +0200
Subject: [PATCH 5/9 v2] Initial commit to support NetUP Dual DVB-T/C CI RF card.
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The card based on cx23885 PCI-e brige. Altera FPGA for CI,
multistandard demods stv0367 from STM for QAM & OFDM,  Xcieve xc5000 tuners
and additional cx25840 for second analog input.

Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
---
 drivers/media/video/cx23885/Kconfig         |    3 +-
 drivers/media/video/cx23885/cx23885-cards.c |  103 ++++++++++++++++-
 drivers/media/video/cx23885/cx23885-core.c  |   22 ++--
 drivers/media/video/cx23885/cx23885-dvb.c   |  172 +++++++++++++++++++++++++-
 drivers/media/video/cx23885/cx23885.h       |    4 +-
 5 files changed, 284 insertions(+), 20 deletions(-)

diff --git a/drivers/media/video/cx23885/Kconfig b/drivers/media/video/cx23885/Kconfig
index 5e5faad..3b6e7f2 100644
--- a/drivers/media/video/cx23885/Kconfig
+++ b/drivers/media/video/cx23885/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_CX23885
 	tristate "Conexant cx23885 (2388x successor) support"
-	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT
+	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && SND
+	select SND_PCM
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEO_TUNER
diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index b298b73..1ef4f7b 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -24,10 +24,14 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <media/cx25840.h>
+#include <linux/firmware.h>
+#include <misc/altera.h>
 
 #include "cx23885.h"
 #include "tuner-xc2028.h"
 #include "netup-init.h"
+#include "altera-ci.h"
+#include "xc5000.h"
 #include "cx23888-ir.h"
 
 static unsigned int enable_885_ir;
@@ -187,7 +191,7 @@ struct cx23885_board cx23885_boards[] = {
 		.portb		= CX23885_MPEG_DVB,
 	},
 	[CX23885_BOARD_NETUP_DUAL_DVBS2_CI] = {
-		.cimax		= 1,
+		.ci_type	= 1,
 		.name		= "NetUP Dual DVB-S2 CI",
 		.portb		= CX23885_MPEG_DVB,
 		.portc		= CX23885_MPEG_DVB,
@@ -329,6 +333,19 @@ struct cx23885_board cx23885_boards[] = {
 				  CX25840_SVIDEO_CHROMA4,
 		} },
 	},
+	[CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF] = {
+		.ci_type	= 2,
+		.name		= "NetUP Dual DVB-T/C-CI RF",
+		.porta		= CX23885_ANALOG_VIDEO,
+		.portb		= CX23885_MPEG_DVB,
+		.portc		= CX23885_MPEG_DVB,
+		.tuner_type	= TUNER_XC5000,
+		.tuner_addr	= 0x64,
+		.input          = { {
+				.type   = CX23885_VMUX_TELEVISION,
+				.vmux   = CX25840_COMPOSITE1,
+		} },
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -520,6 +537,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x5654,
 		.subdevice = 0x2390,
 		.card      = CX23885_BOARD_GOTVIEW_X5_3D_HYBRID,
+	}, {
+		.subvendor = 0x1b55,
+		.subdevice = 0xe2e4,
+		.card      = CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -740,6 +761,9 @@ int cx23885_tuner_callback(void *priv, int component, int command, int arg)
 		/* Tuner Reset Command */
 		bitmask = 0x02;
 		break;
+	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
+		altera_ci_tuner_reset(dev, port->nr);
+		break;
 	}
 
 	if (bitmask) {
@@ -998,6 +1022,33 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_GOTVIEW_X5_3D_HYBRID:
 		cx_set(GP0_IO, 0x00010001); /* Bring the part out of reset */
 		break;
+	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
+		/* GPIO-0 ~INT in
+		   GPIO-1 TMS out
+		   GPIO-2 ~reset chips out
+		   GPIO-3 to GPIO-10 data/addr for CA in/out
+		   GPIO-11 ~CS out
+		   GPIO-12 ADDR out
+		   GPIO-13 ~WR out
+		   GPIO-14 ~RD out
+		   GPIO-15 ~RDY in
+		   GPIO-16 TCK out
+		   GPIO-17 TDO in
+		   GPIO-18 TDI out
+		 */
+		cx_set(GP0_IO, 0x00060000); /* GPIO-1,2 as out */
+		/* GPIO-0 as INT, reset & TMS low */
+		cx_clear(GP0_IO, 0x00010006);
+		mdelay(100);/* reset delay */
+		cx_set(GP0_IO, 0x00000004); /* reset high */
+		cx_write(MC417_CTL, 0x00000037);/* enable GPIO-3..18 pins */
+		/* GPIO-17 is TDO in, GPIO-15 is ~RDY in, rest is out */
+		cx_write(MC417_OEN, 0x00005000);
+		/* ~RD, ~WR high; ADDR low; ~CS high */
+		cx_write(MC417_RWD, 0x00000d00);
+		/* enable irq */
+		cx_write(GPIO_ISM, 0x00000000);/* INTERRUPTS active low*/
+		break;
 	}
 }
 
@@ -1113,6 +1164,31 @@ void cx23885_ir_fini(struct cx23885_dev *dev)
 	}
 }
 
+int netup_jtag_io(void *device, int tms, int tdi, int read_tdo)
+{
+	int data;
+	int tdo = 0;
+	struct cx23885_dev *dev = (struct cx23885_dev *)device;
+	/*TMS*/
+	data = ((cx_read(GP0_IO)) & (~0x00000002));
+	data |= (tms ? 0x00020002 : 0x00020000);
+	cx_write(GP0_IO, data);
+
+	/*TDI*/
+	data = ((cx_read(MC417_RWD)) & (~0x0000a000));
+	data |= (tdi ? 0x00008000 : 0);
+	cx_write(MC417_RWD, data);
+	if (read_tdo)
+		tdo = (data & 0x00004000) ? 1 : 0; /*TDO*/
+
+	cx_write(MC417_RWD, data | 0x00002000);
+	udelay(1);
+	/*TCK*/
+	cx_write(MC417_RWD, data);
+
+	return (tdo);
+}
+
 void cx23885_ir_pci_int_enable(struct cx23885_dev *dev)
 {
 	switch (dev->board) {
@@ -1212,6 +1288,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
+	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
 		ts1->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
@@ -1271,6 +1348,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
+	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_MYGICA_X8506:
@@ -1293,6 +1371,29 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
 		netup_initialize(dev);
 		break;
+	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF: {
+		int ret;
+		const struct firmware *fw;
+		const char *filename = "dvb-netup-altera-01.fw";
+		char *action = "configure";
+		struct altera_config netup_config = {
+			.dev = dev,
+			.action = action,
+			.jtag_io = netup_jtag_io,
+		};
+
+		netup_initialize(dev);
+
+		ret = request_firmware(&fw, filename, &dev->pci->dev);
+		if (ret != 0)
+			printk("did not find the firmware file. (%s) "
+			"Please see linux/Documentation/dvb/ for more details "
+			"on firmware-problems.", filename);
+		else
+			altera_init(&netup_config, fw);
+
+		break;
+	}
 	}
 }
 
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index 3598824..9ad4c9c 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -29,9 +29,11 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <asm/div64.h>
+#include <linux/firmware.h>
 
 #include "cx23885.h"
 #include "cimax2.h"
+#include "altera-ci.h"
 #include "cx23888-ir.h"
 #include "cx23885-ir.h"
 #include "cx23885-av.h"
@@ -902,8 +904,6 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	dev->pci_bus  = dev->pci->bus->number;
 	dev->pci_slot = PCI_SLOT(dev->pci->devfn);
 	cx23885_irq_add(dev, 0x001f00);
-	if (cx23885_boards[dev->board].cimax > 0)
-		cx23885_irq_add(dev, 0x01800000); /* for CiMaxes */
 
 	/* External Master 1 Bus */
 	dev->i2c_bus[0].nr = 0;
@@ -1822,14 +1822,13 @@ static irqreturn_t cx23885_irq(int irq, void *dev_id)
 				PCI_MSK_IR);
 	}
 
-	if (cx23885_boards[dev->board].cimax > 0 &&
-		((pci_status & PCI_MSK_GPIO0) ||
-			(pci_status & PCI_MSK_GPIO1))) {
+	if (cx23885_boards[dev->board].ci_type == 1 &&
+			(pci_status & (PCI_MSK_GPIO1 | PCI_MSK_GPIO0)))
+		handled += netup_ci_slot_status(dev, pci_status);
 
-		if (cx23885_boards[dev->board].cimax > 0)
-			handled += netup_ci_slot_status(dev, pci_status);
-
-	}
+	if (cx23885_boards[dev->board].ci_type == 2 &&
+			(pci_status & PCI_MSK_GPIO0))
+		handled += altera_ci_irq(dev);
 
 	if (ts1_status) {
 		if (cx23885_boards[dev->board].portb == CX23885_MPEG_DVB)
@@ -2064,7 +2063,10 @@ static int __devinit cx23885_initdev(struct pci_dev *pci_dev,
 
 	switch (dev->board) {
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
-		cx23885_irq_add_enable(dev, 0x01800000); /* for NetUP */
+		cx23885_irq_add_enable(dev, PCI_MSK_GPIO1 | PCI_MSK_GPIO0);
+		break;
+	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
+		cx23885_irq_add_enable(dev, PCI_MSK_GPIO0);
 		break;
 	}
 
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index 5958cb8..6c144f7 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -58,6 +58,8 @@
 #include "atbm8830.h"
 #include "ds3000.h"
 #include "cx23885-f300.h"
+#include "altera-ci.h"
+#include "stv0367.h"
 
 static unsigned int debug;
 
@@ -108,6 +110,22 @@ static void dvb_buf_release(struct videobuf_queue *q,
 	cx23885_free_buffer(q, (struct cx23885_buffer *)vb);
 }
 
+static void cx23885_dvb_gate_ctrl(struct cx23885_tsport  *port, int open)
+{
+	struct videobuf_dvb_frontends *f;
+	struct videobuf_dvb_frontend *fe;
+
+	f = &port->frontends;
+
+	if (f->gate <= 1) /* undefined or fe0 */
+		fe = videobuf_dvb_get_frontend(f, 1);
+	else
+		fe = videobuf_dvb_get_frontend(f, f->gate);
+
+	if (fe && fe->dvb.frontend && fe->dvb.frontend->ops.i2c_gate_ctrl)
+		fe->dvb.frontend->ops.i2c_gate_ctrl(fe->dvb.frontend, open);
+}
+
 static struct videobuf_queue_ops dvb_qops = {
 	.buf_setup    = dvb_buf_setup,
 	.buf_prepare  = dvb_buf_prepare,
@@ -570,12 +588,84 @@ static struct max2165_config mygic_x8558pro_max2165_cfg2 = {
 	.i2c_address = 0x60,
 	.osc_clk = 20
 };
+static struct stv0367_config netup_stv0367_config[] = {
+	{
+		.demod_address = 0x1c,
+		.xtal = 27000000,
+		.if_khz = 4500,
+		.if_iq_mode = 0,
+		.ts_mode = 1,
+		.clk_pol = 0,
+	}, {
+		.demod_address = 0x1d,
+		.xtal = 27000000,
+		.if_khz = 4500,
+		.if_iq_mode = 0,
+		.ts_mode = 1,
+		.clk_pol = 0,
+	},
+};
+
+static struct xc5000_config netup_xc5000_tunerconfig[] = {
+	{
+		.i2c_address = 0x61,
+		.if_khz = 4500,
+	}, {
+		.i2c_address = 0x64,
+		.if_khz = 4500,
+	},
+};
+
+int netup_altera_fpga_rw(void *device, int flag, int data, int read)
+{
+	struct cx23885_dev *dev = (struct cx23885_dev *)device;
+	unsigned long timeout = jiffies + msecs_to_jiffies(1);
+	int mem = 0;
+
+	cx_set(MC417_RWD, ALT_RD | ALT_WR | ALT_CS);
+	if (read)
+		cx_set(MC417_OEN, ALT_DATA);
+	else {
+		cx_clear(MC417_OEN, ALT_DATA);/* D0-D7 out */
+		mem = cx_read(MC417_RWD);
+		mem &= ~ALT_DATA;
+		mem |= (data & ALT_DATA);
+		cx_write(MC417_RWD, mem);
+	}
+
+	if (flag)
+		cx_set(MC417_RWD, ALT_AD_RG);/* ADDR */
+	else
+		cx_clear(MC417_RWD, ALT_AD_RG);/* VAL */
+
+	cx_clear(MC417_RWD, ALT_CS);/* ~CS */
+	if (read)
+		cx_clear(MC417_RWD, ALT_RD);
+	else
+		cx_clear(MC417_RWD, ALT_WR);
+
+	for (;;) {
+		mem = cx_read(MC417_RWD);
+		if ((mem & ALT_RDY) == 0)
+			break;
+		if (time_after(jiffies, timeout))
+			break;
+		udelay(1);
+	}
+
+	cx_set(MC417_RWD, ALT_RD | ALT_WR | ALT_CS);
+	if (read)
+		return (mem & ALT_DATA);
+
+	return 0;
+};
 
 static int dvb_register(struct cx23885_tsport *port)
 {
 	struct cx23885_dev *dev = port->dev;
 	struct cx23885_i2c *i2c_bus = NULL, *i2c_bus2 = NULL;
-	struct videobuf_dvb_frontend *fe0;
+	struct videobuf_dvb_frontend *fe0, *fe1 = NULL;
+	int mfe_shared = 0; /* bus not shared by default */
 	int ret;
 
 	/* Get the first frontend */
@@ -586,6 +676,12 @@ static int dvb_register(struct cx23885_tsport *port)
 	/* init struct videobuf_dvb */
 	fe0->dvb.name = dev->name;
 
+	/* multi-frontend gate control is undefined or defaults to fe0 */
+	port->frontends.gate = 0;
+
+	/* Sets the gate control callback to be used by i2c command calls */
+	port->gate_ctrl = cx23885_dvb_gate_ctrl;
+
 	/* init frontend */
 	switch (dev->board) {
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
@@ -966,20 +1062,61 @@ static int dvb_register(struct cx23885_tsport *port)
 			break;
 		}
 		break;
-
+	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
+		i2c_bus = &dev->i2c_bus[0];
+		mfe_shared = 1;/* MFE */
+		port->frontends.gate = 0;/* not clear for me yet */
+		/* ports B, C */
+		/* MFE frontend 1 DVB-T */
+		fe0->dvb.frontend = dvb_attach(stv0367ter_attach,
+					&netup_stv0367_config[port->nr -1],
+					&i2c_bus->i2c_adap);
+		if (fe0->dvb.frontend != NULL)
+			if (NULL == dvb_attach(xc5000_attach,
+					fe0->dvb.frontend,
+					&i2c_bus->i2c_adap,
+					&netup_xc5000_tunerconfig[port->nr - 1]))
+				goto frontend_detach;
+		/* MFE frontend 2 */
+		fe1 = videobuf_dvb_get_frontend(&port->frontends, 2);
+		if (fe1 == NULL)
+			goto frontend_detach;
+		/* DVB-C init */
+		fe1->dvb.frontend = dvb_attach(stv0367cab_attach,
+					&netup_stv0367_config[port->nr - 1],
+					&i2c_bus->i2c_adap);
+		if (fe1->dvb.frontend != NULL) {
+			fe1->dvb.frontend->id = 1;
+			if (NULL == dvb_attach(xc5000_attach,
+					fe1->dvb.frontend,
+					&i2c_bus->i2c_adap,
+					&netup_xc5000_tunerconfig[port->nr - 1]))
+				goto frontend_detach;
+		}
+		break;
 	default:
 		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
 			" isn't supported yet\n",
 		       dev->name);
 		break;
 	}
-	if (NULL == fe0->dvb.frontend) {
+
+	if ((NULL == fe0->dvb.frontend) || (fe1 && NULL == fe1->dvb.frontend)) {
 		printk(KERN_ERR "%s: frontend initialization failed\n",
-			dev->name);
-		return -1;
+		       dev->name);
+		goto frontend_detach;
 	}
+
 	/* define general-purpose callback pointer */
 	fe0->dvb.frontend->callback = cx23885_tuner_callback;
+	if (fe1)
+		fe1->dvb.frontend->callback = cx23885_tuner_callback;
+#if 0
+	/* Ensure all frontends negotiate bus access */
+	fe0->dvb.frontend->ops.ts_bus_ctrl = cx23885_dvb_bus_ctrl;
+	if (fe1)
+		fe1->dvb.frontend->ops.ts_bus_ctrl = cx23885_dvb_bus_ctrl;
+#endif
 
 	/* Put the analog decoder in standby to keep it quiet */
 	call_all(dev, core, s_power, 0);
@@ -989,10 +1126,10 @@ static int dvb_register(struct cx23885_tsport *port)
 
 	/* register everything */
 	ret = videobuf_dvb_register_bus(&port->frontends, THIS_MODULE, port,
-					&dev->pci->dev, adapter_nr, 0,
+					&dev->pci->dev, adapter_nr, mfe_shared,
 					cx23885_dvb_fe_ioctl_override);
 	if (ret)
-		return ret;
+		goto frontend_detach;
 
 	/* init CI & MAC */
 	switch (dev->board) {
@@ -1008,6 +1145,17 @@ static int dvb_register(struct cx23885_tsport *port)
 		netup_ci_init(port);
 		break;
 		}
+	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF: {
+		struct altera_ci_config netup_ci_cfg = {
+			.dev = dev,/* magic number to identify*/
+			.adapter = &port->frontends.adapter,/* for CI */
+			.demux = &fe0->dvb.demux,/* for hw pid filter */
+			.fpga_rw = netup_altera_fpga_rw,
+		};
+
+		altera_ci_init(&netup_ci_cfg, port->nr);
+		break;
+		}
 	case CX23885_BOARD_TEVII_S470: {
 		u8 eeprom[256]; /* 24C02 i2c eeprom */
 
@@ -1024,6 +1172,11 @@ static int dvb_register(struct cx23885_tsport *port)
 	}
 
 	return ret;
+
+frontend_detach:
+	port->gate_ctrl = NULL;
+	videobuf_dvb_dealloc_frontends(&port->frontends);
+	return -EINVAL;
 }
 
 int cx23885_dvb_register(struct cx23885_tsport *port)
@@ -1100,8 +1253,13 @@ int cx23885_dvb_unregister(struct cx23885_tsport *port)
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
 		netup_ci_exit(port);
 		break;
+	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
+		altera_ci_release(port->dev, port->nr);
+		break;
 	}
 
+	port->gate_ctrl = NULL;
+
 	return 0;
 }
 
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index 62e41ab..a427f7c 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -85,6 +85,7 @@
 #define CX23885_BOARD_MYGICA_X8558PRO          27
 #define CX23885_BOARD_LEADTEK_WINFAST_PXTV1200 28
 #define CX23885_BOARD_GOTVIEW_X5_3D_HYBRID     29
+#define CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF 30
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
@@ -220,7 +221,7 @@ struct cx23885_board {
 	 */
 	u32			clk_freq;
 	struct cx23885_input    input[MAX_CX23885_INPUT];
-	int			cimax; /* for NetUP */
+	int			ci_type; /* for NetUP */
 };
 
 struct cx23885_subid {
@@ -303,6 +304,7 @@ struct cx23885_tsport {
 
 	/* Allow a single tsport to have multiple frontends */
 	u32                        num_frontends;
+	void                       (*gate_ctrl)(struct cx23885_tsport *port, int open);
 	void                       *port_priv;
 };
 
-- 
1.7.1

