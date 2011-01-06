Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab1AFIFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:05:47 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:57420 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab1AFIFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:05:45 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <01de01cbad77$3dbed0a0$b93c71e0$@mprc.pku.edu.cn>
In-Reply-To: <01de01cbad77$3dbed0a0$b93c71e0$@mprc.pku.edu.cn>
Subject: RE: [PATCHv1 0/8] unicore32 machine related files: summary
Date: Thu, 6 Jan 2011 16:05:45 +0800
Message-ID: <01ec01cbad78$857ccae0$907660a0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQD5q7uzdbzaRxzFKhxkjRMpQze/MJVnmX6A
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCHv1 7/8] unicore32 machine related files: i2c bus
From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

Patch 7 implements arch-specific i2c bus driver.

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 drivers/staging/puv3/puv3_i2c.c |  325 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 325 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/puv3/puv3_i2c.c b/drivers/staging/puv3/puv3_i2c.c
new file mode 100644
index 0000000..2a118e2
--- /dev/null
+++ b/drivers/staging/puv3/puv3_i2c.c
@@ -0,0 +1,325 @@
+/*
+ * linux/drivers/staging/puv3/puv3_i2c.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Based on: drivers/i2c/busses/i2c-at91.c
+ *
+ * Contributors & Additions/Fixes:
+ *	2009-11-05: change loop time for NOT-eeprom
+ *			by GUAN Xue-tao & WU Dong-xia
+ *	2009-07-17: add suspend/resume support by WU Dong-xia
+ *	2009-05-30: add support at24c02 by ZHONG Qi
+ *	2009-05-14: add support bq27200 by ZHONG Qi & WU Dong-xia
+ *	2009-05-06: First version by WU Dong-xia
+ *
+ * TODO:
+ *	1. the latnecy from udelay or msleep may be a bit long
+ *	   change the parameters according to the device
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <asm/mach/hardware.h>
+
+#define DEBUG
+
+static int i2c_reg = -1;
+
+static void __devinit puv3_i2c_hwinit(void)
+{
+	/* Do Noting */
+}
+
+/*
+ * Poll the i2c status register until the specified bit is set.
+ * Returns 0 if timed out (100 msec).
+ */
+static short poll_status(unsigned long bit)
+{
+	int loop_cntr = 1000;
+
+	if (bit & I2C_STATUS_TFNF) {
+		do {
+			udelay(10);
+		} while (!(I2C_STATUS & bit) && (--loop_cntr > 0));
+	} else {
+		/* RXRDY handler */
+		do {
+			if (I2C_TAR == I2C_TAR_EEPROM)
+				msleep(20);
+			else
+				udelay(10);
+		} while (!(I2C_RXFLR & 0xf) && (--loop_cntr > 0));
+	}
+
+	return (loop_cntr > 0);
+}
+
+static int xfer_read(struct i2c_adapter *adap, unsigned char *buf, int length)
+{
+	/* Read data */
+	while (length--) {
+		if (!poll_status(I2C_STATUS_TFNF)) {
+			dev_dbg(&adap->dev, "Tx FIFO Not Full timeout\n");
+			return -ETIMEDOUT;
+		}
+
+		/* send addr */
+		I2C_DATACMD = i2c_reg | I2C_DATACMD_WRITE;
+
+		/* get ready to next write */
+		i2c_reg++;
+
+		/* send read CMD */
+		I2C_DATACMD = I2C_DATACMD_READ;
+
+		/* wait until the Rx FIFO have available */
+		if (!poll_status(I2C_STATUS_RFNE)) {
+			dev_dbg(&adap->dev, "RXRDY timeout\n");
+			return -ETIMEDOUT;
+		}
+
+		/* read the data to buf */
+		*buf = (I2C_DATACMD & I2C_DATACMD_DAT_MASK);
+		buf++;
+	}
+
+	i2c_reg = -1;
+
+	return 0;
+}
+
+static int xfer_write(struct i2c_adapter *adap, unsigned char *buf, int length)
+{
+	/* Do nothing but storing the reg_num to a static variable */
+	i2c_reg = *buf;
+	if (i2c_reg == -1) {
+		printk(KERN_WARNING "Error i2c reg\n");
+		return -ETIMEDOUT;
+	}
+
+	if (length == 1)
+		return 0;
+
+	buf++;
+	length--;
+	while (length--) {
+		/* send addr */
+		I2C_DATACMD = i2c_reg | I2C_DATACMD_WRITE;
+
+		/* send write CMD */
+		I2C_DATACMD = *buf | I2C_DATACMD_WRITE;
+
+		/* wait until the Rx FIFO have available */
+		msleep(20);
+
+		/* read the data to buf */
+		i2c_reg++;
+		buf++;
+	}
+
+	i2c_reg = -1;
+
+	return 0;
+}
+
+/*
+ * Generic i2c master transfer entrypoint.
+ *
+ */
+static int puv3_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *pmsg,
+		int num)
+{
+	int i, ret;
+	unsigned char swap;
+
+	/* Disable i2c */
+	I2C_ENABLE = I2C_ENABLE_DISABLE;
+
+	/* Set the work mode and speed*/
+	I2C_CON = I2C_CON_MASTER | I2C_CON_SPEED_STD | I2C_CON_SLAVEDISABLE;
+
+	I2C_TAR = pmsg->addr;
+
+	/* Enable i2c */
+	I2C_ENABLE = I2C_ENABLE_ENABLE;
+
+	dev_dbg(&adap->dev, "puv3_i2c_xfer: processing %d messages:\n", num);
+
+	for (i = 0; i < num; i++) {
+		dev_dbg(&adap->dev, " #%d: %sing %d byte%s %s 0x%02x\n", i,
+			pmsg->flags & I2C_M_RD ? "read" : "writ",
+			pmsg->len, pmsg->len > 1 ? "s" : "",
+			pmsg->flags & I2C_M_RD ? "from" : "to",	pmsg->addr);
+
+		if (pmsg->len && pmsg->buf) {	/* sanity check */
+			if (pmsg->flags & I2C_M_RD)
+				ret = xfer_read(adap, pmsg->buf, pmsg->len);
+			else
+				ret = xfer_write(adap, pmsg->buf, pmsg->len);
+
+			if (ret)
+				return ret;
+
+		}
+		dev_dbg(&adap->dev, "transfer complete\n");
+		pmsg++;		/* next message */
+	}
+
+	/* XXX: fixup be16_to_cpu in bq27x00_battery.c */
+	if (pmsg->addr == I2C_TAR_PWIC) {
+		swap = pmsg->buf[0];
+		pmsg->buf[0] = pmsg->buf[1];
+		pmsg->buf[1] = swap;
+	}
+
+	return i;
+}
+
+/*
+ * Return list of supported functionality.
+ */
+static u32 puv3_i2c_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+static struct i2c_algorithm puv3_i2c_algorithm = {
+	.master_xfer	= puv3_i2c_xfer,
+	.functionality	= puv3_i2c_func,
+};
+
+/*
+ * Main initialization routine.
+ */
+static int __devinit puv3_i2c_probe(struct platform_device *pdev)
+{
+	struct i2c_adapter *adapter;
+	struct resource *res;
+	int rc;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENXIO;
+
+	if (!request_mem_region(res->start, resource_size(res), "puv3_i2c"))
+		return -EBUSY;
+
+	adapter = kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
+	if (adapter == NULL) {
+		dev_err(&pdev->dev, "can't allocate inteface!\n");
+		rc = -ENOMEM;
+		goto fail2;
+	}
+	snprintf(adapter->name, sizeof(adapter->name), "PUV3");
+	adapter->algo = &puv3_i2c_algorithm;
+	adapter->class = I2C_CLASS_HWMON;
+	adapter->dev.parent = &pdev->dev;
+
+	platform_set_drvdata(pdev, adapter);
+
+	puv3_i2c_hwinit();		/* initialize TWI controller */
+
+	rc = i2c_add_numbered_adapter(adapter);
+	if (rc) {
+		dev_err(&pdev->dev, "Adapter %s registration failed\n",
+				adapter->name);
+		goto fail3;
+	}
+
+	dev_info(&pdev->dev, "PKUnity v3 i2c bus driver.\n");
+	return 0;
+
+fail3:
+	platform_set_drvdata(pdev, NULL);
+	kfree(adapter);
+fail2:
+	release_mem_region(res->start, resource_size(res));
+
+	return rc;
+}
+
+static int puv3_i2c_remove(struct platform_device *pdev)
+{
+	struct i2c_adapter *adapter = platform_get_drvdata(pdev);
+	struct resource *res;
+	int rc;
+
+	rc = i2c_del_adapter(adapter);
+	platform_set_drvdata(pdev, NULL);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(res->start, resource_size(res));
+
+	return rc;
+}
+
+#ifdef CONFIG_PM
+static int puv3_i2c_suspend(struct platform_device *dev, pm_message_t state)
+{
+	int poll_count;
+	/* Disable the IIC */
+	I2C_ENABLE = I2C_ENABLE_DISABLE;
+	for (poll_count = 0; poll_count < 50; poll_count++) {
+		if (I2C_ENSTATUS & I2C_ENSTATUS_ENABLE)
+			udelay(25);
+	}
+
+	return 0;
+}
+
+static int puv3_i2c_resume(struct platform_device *dev)
+{
+	return 0 ;
+}
+#else
+#define puv3_i2c_suspend NULL
+#define puv3_i2c_resume NULL
+#endif
+
+MODULE_ALIAS("platform:puv3_i2c");
+
+static struct platform_driver puv3_i2c_driver = {
+	.probe		= puv3_i2c_probe,
+	.remove		= __devexit_p(puv3_i2c_remove),
+	.suspend	= puv3_i2c_suspend,
+	.resume		= puv3_i2c_resume,
+	.driver		= {
+		.name	= "PKUnity-v3-I2C",
+		.owner	= THIS_MODULE,
+	}
+};
+
+static int __init puv3_i2c_init(void)
+{
+	return platform_driver_register(&puv3_i2c_driver);
+}
+
+static void __exit puv3_i2c_exit(void)
+{
+	platform_driver_unregister(&puv3_i2c_driver);
+}
+
+module_init(puv3_i2c_init);
+module_exit(puv3_i2c_exit);
+
+MODULE_AUTHOR("WU Dong-xia");
+MODULE_DESCRIPTION("PKUnity v3 I2C driver");
+MODULE_LICENSE("GPL v2");

> -----Original Message-----
> From: linux-arch-owner@vger.kernel.org [mailto:linux-arch-owner@vger.kernel.org] On Behalf Of Guan Xuetao
> Sent: Thursday, January 06, 2011 3:57 PM
> To: linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCHv1 0/8] unicore32 machine related files: summary
> 
> From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> 
> The whole patch could be fetched from:
>   git://git.kernel.org/pub/scm/linux/kernel/git/epip/unicore32.git
>   with branch name: unicore32.
> And it is divided into  three patch sets: core architecture files,
>   additional architecture files, and machine related files.
> 
> This patch set adds the machine related files for UniCore32 ISA and PKUnity SoC.
> 
> Patch 1 adds machine related  core files, also including build infrastructure.
> 
> Patch 2 add all hardware registers definitions, which are not split and inserted into
>  different drivers.
> 
> Patch 3 implements arch-specific pci bus driver.
> 
> Patch 4 implements arch-specific ps2 dirver.
> 
> Patch 5 implements frame buffer driver.
> 
> Patch 6 implements ac97 driver.
> 
> Patch 7 implements arch-specific i2c bus driver.
> 
> Patch 8 implements network driver.
> 
> Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> ---
>  arch/unicore32/include/asm/mach/PKUnity.h     |  104 ++
>  arch/unicore32/include/asm/mach/bitfield.h    |   24 +
>  arch/unicore32/include/asm/mach/hardware.h    |   45 +
>  arch/unicore32/include/asm/mach/regs-ac97.h   |   32 +
>  arch/unicore32/include/asm/mach/regs-dmac.h   |   81 +
>  arch/unicore32/include/asm/mach/regs-gpio.h   |   70 +
>  arch/unicore32/include/asm/mach/regs-i2c.h    |   63 +
>  arch/unicore32/include/asm/mach/regs-intc.h   |   28 +
>  arch/unicore32/include/asm/mach/regs-nand.h   |   79 +
>  arch/unicore32/include/asm/mach/regs-ost.h    |   92 ++
>  arch/unicore32/include/asm/mach/regs-pci.h    |   94 ++
>  arch/unicore32/include/asm/mach/regs-pm.h     |  126 ++
>  arch/unicore32/include/asm/mach/regs-ps2.h    |   20 +
>  arch/unicore32/include/asm/mach/regs-resetc.h |   34 +
>  arch/unicore32/include/asm/mach/regs-rtc.h    |   37 +
>  arch/unicore32/include/asm/mach/regs-sdc.h    |  156 ++
>  arch/unicore32/include/asm/mach/regs-spi.h    |   98 ++
>  arch/unicore32/include/asm/mach/regs-uart.h   |    3 +
>  arch/unicore32/include/asm/mach/regs-umal.h   |  229 +++
>  arch/unicore32/include/asm/mach/regs-unigfx.h |  200 +++
>  arch/unicore32/include/asm/pci.h              |   46 +
>  arch/unicore32/kernel/pci.c                   |  404 +++++
>  arch/unicore32/kernel/puv3-core.c             |  266 ++++
>  arch/unicore32/kernel/puv3-nb0916.c           |  183 +++
>  arch/unicore32/kernel/puv3-smw0919.c          |  120 ++
>  drivers/input/keyboard/Kconfig                |   11 +
>  drivers/input/keyboard/atkbd.c                |    4 +
>  drivers/input/mouse/psmouse-base.c            |   41 +
>  drivers/input/serio/i8042.h                   |    2 +
>  drivers/pci/Makefile                          |    1 +
>  drivers/staging/puv3/Kconfig                  |  142 ++
>  drivers/staging/puv3/Makefile                 |   27 +
>  drivers/staging/puv3/TODO                     |    7 +
>  drivers/staging/puv3/i8042-ucio.h             |   96 ++
>  drivers/staging/puv3/nb0916-atkbd.h           |   43 +
>  drivers/staging/puv3/puv3_ac97.c              |  383 +++++
>  drivers/staging/puv3/puv3_i2c.c               |  325 ++++
>  drivers/staging/puv3/puv3_pcm.c               |  449 ++++++
>  drivers/staging/puv3/puv3_pcm.h               |   33 +
>  drivers/staging/puv3/puv3_umal.c              | 2082 +++++++++++++++++++++++++
>  drivers/staging/puv3/puv3_unifb.c             |  972 ++++++++++++
>  include/linux/fb.h                            |    2 +
>  42 files changed, 7254 insertions(+), 0 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

