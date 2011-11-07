Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab1KGJjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 04:39:18 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:60105 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1KGJjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 04:39:16 -0500
X-Greylist: delayed 661 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Nov 2011 04:39:15 EST
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Date: Mon, 7 Nov 2011 10:27:52 +0100 (CET)
From: Nikolaus Voss <n.voss@weinmann.de>
X-X-Sender: nn@gatekeeper.vosshq.de
To: 'linux-i2c@vger.kernel.org', 'linux-arm-kernel@lists.infradead.org',
        nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2] drivers/i2c/busses/i2c-at91.c: fix brokeness
Message-ID: <alpine.DEB.2.00.1111071019560.21431@gatekeeper.vosshq.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a05fa963f819dabf985ec0d76c769b2cf4894ccf Mon Sep 17 00:00:00 2001
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Thu, 27 Oct 2011 11:12:55 +0200
Subject: [PATCH 1/6] drivers/i2c/busses/i2c-at91.c: fix brokeness

This patch contains the following fixes:
1. Support for multiple interfaces (there are usually two of them).
2. Remove busy waiting in favour of interrupt driven io.
3. No repeated start (Sr) was possible. This implementation supports one
    repeated start condition which is enough for most real-world applications
    including all SMBus transfer types.

Tested on Atmel G45 with BQ20Z80 battery SMBus client.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
V2: No killed tabs, patch should apply now.

  drivers/i2c/busses/Kconfig    |   11 +-
  drivers/i2c/busses/i2c-at91.c |  415 +++++++++++++++++++++++++++--------------
  2 files changed, 278 insertions(+), 148 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 646068e..c4b6bdc 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -286,18 +286,15 @@ comment "I2C system bus drivers (mostly embedded / system-on-chip)"

  config I2C_AT91
  	tristate "Atmel AT91 I2C Two-Wire interface (TWI)"
-	depends on ARCH_AT91 && EXPERIMENTAL && BROKEN
+	depends on ARCH_AT91 && EXPERIMENTAL
  	help
  	  This supports the use of the I2C interface on Atmel AT91
  	  processors.

-	  This driver is BROKEN because the controller which it uses
-	  will easily trigger RX overrun and TX underrun errors.  Using
-	  low I2C clock rates may partially work around those issues
-	  on some systems.  Another serious problem is that there is no
-	  documented way to issue repeated START conditions, as needed
+	  A serious problem is that there is no documented way to issue
+	  repeated START conditions for more than two messages, as needed
  	  to support combined I2C messages.  Use the i2c-gpio driver
-	  unless your system can cope with those limitations.
+	  unless your system can cope with this limitation.

  config I2C_AU1550
  	tristate "Au1550/Au1200 SMBus interface"
diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 305c075..a2c38ff 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -1,6 +1,10 @@
-/*
+/* -*- linux-c -*-
+
      i2c Support for Atmel's AT91 Two-Wire Interface (TWI)

+    Copyright (C) 2011 Nikolaus Voss <n.voss@weinmann.de>
+
+    Evolved from original work by:
      Copyright (C) 2004 Rick Bronson
      Converted to 2.6 by Andrew Victor <andrew@sanpeople.com>

@@ -18,9 +22,9 @@
  #include <linux/err.h>
  #include <linux/slab.h>
  #include <linux/types.h>
-#include <linux/delay.h>
  #include <linux/i2c.h>
  #include <linux/init.h>
+#include <linux/interrupt.h>
  #include <linux/clk.h>
  #include <linux/platform_device.h>
  #include <linux/io.h>
@@ -29,29 +33,47 @@
  #include <mach/board.h>
  #include <mach/cpu.h>

-#define TWI_CLOCK		100000		/* Hz. max 400 Kbits/sec */
+#define TWI_CLOCK		30000		/* Hz. max 400 Kbits/sec */
+#define AT91_I2C_TIMEOUT	(1 * HZ)	/* transfer timeout */
+
+struct at91_i2c_dev {
+	struct device *dev;
+	void __iomem *base;
+	struct completion cmd_complete;
+	struct clk *clk;
+	u8 *buf;
+	size_t buf_len;
+	int irq;
+	unsigned transfer_status;
+	struct i2c_adapter adapter;
+};

+#define at91_twi_read(reg)		__raw_readl(dev->base + (reg))
+#define at91_twi_write(reg, val)	__raw_writel((val), dev->base + (reg))

-static struct clk *twi_clk;
-static void __iomem *twi_base;

-#define at91_twi_read(reg)		__raw_readl(twi_base + (reg))
-#define at91_twi_write(reg, val)	__raw_writel((val), twi_base + (reg))
+static inline void at91_disable_interrupts(struct at91_i2c_dev *dev)
+{
+	at91_twi_write(AT91_TWI_IDR,
+		       AT91_TWI_TXCOMP | AT91_TWI_RXRDY | AT91_TWI_TXRDY);
+}


-/*
- * Initialize the TWI hardware registers.
- */
-static void __devinit at91_twi_hwinit(void)
+static void at91_init_bus(struct at91_i2c_dev *dev)
  {
-	unsigned long cdiv, ckdiv;
-
-	at91_twi_write(AT91_TWI_IDR, 0xffffffff);	/* Disable all interrupts */
+	at91_disable_interrupts(dev);
  	at91_twi_write(AT91_TWI_CR, AT91_TWI_SWRST);	/* Reset peripheral */
  	at91_twi_write(AT91_TWI_CR, AT91_TWI_MSEN);	/* Set Master mode */
+	at91_twi_write(AT91_TWI_CR, AT91_TWI_SVDIS);	/* Disable Slave mode */
+}
+
+
+static void at91_set_clock(struct at91_i2c_dev *dev)
+{
+	unsigned long cdiv, ckdiv;

  	/* Calcuate clock dividers */
-	cdiv = (clk_get_rate(twi_clk) / (2 * TWI_CLOCK)) - 3;
+	cdiv = (clk_get_rate(dev->clk) / (2 * TWI_CLOCK)) - 3;
  	cdiv = cdiv + 1;	/* round up */
  	ckdiv = 0;
  	while (cdiv > 255) {
@@ -69,108 +91,178 @@ static void __devinit at91_twi_hwinit(void)
  	at91_twi_write(AT91_TWI_CWGR, (ckdiv << 16) | (cdiv << 8) | cdiv);
  }

+
  /*
- * Poll the i2c status register until the specified bit is set.
- * Returns 0 if timed out (100 msec).
+ * Initialize the TWI hardware registers.
   */
-static short at91_poll_status(unsigned long bit)
+static void __devinit at91_twi_hwinit(struct at91_i2c_dev *dev)
+{
+	at91_init_bus(dev);
+	at91_set_clock(dev);
+}
+
+
+static void at91_write_next_byte(struct at91_i2c_dev *dev)
+{
+	if (dev->buf_len > 0) {
+
+		const u8 c = *(dev->buf++);
+
+		at91_twi_write(AT91_TWI_THR, c);
+
+		/* send stop when last byte has been written */
+		if (--dev->buf_len == 0)
+			at91_twi_write(AT91_TWI_CR, AT91_TWI_STOP);
+
+		dev_dbg(dev->dev, "wrote 0x%x, to go %d\n", c, dev->buf_len);
+	}
+}
+
+
+static void at91_read_next_byte(struct at91_i2c_dev *dev)
  {
-	int loop_cntr = 10000;
+	const u8 c = at91_twi_read(AT91_TWI_RHR) & 0xff;

-	do {
-		udelay(10);
-	} while (!(at91_twi_read(AT91_TWI_SR) & bit) && (--loop_cntr > 0));
+	*(dev->buf)++ = c;

-	return (loop_cntr > 0);
+	/* send stop if second but last byte has been read */
+	if (--dev->buf_len == 1)
+		at91_twi_write(AT91_TWI_CR, AT91_TWI_STOP);
+
+	dev_dbg(dev->dev, "read 0x%x, to go %d\n", c, dev->buf_len);
  }

-static int xfer_read(struct i2c_adapter *adap, unsigned char *buf, int length)
+
+static irqreturn_t atmel_twi_interrupt(int irq, void *dev_id)
  {
-	/* Send Start */
-	at91_twi_write(AT91_TWI_CR, AT91_TWI_START);
+	struct at91_i2c_dev *dev = dev_id;
+	const unsigned status = at91_twi_read(AT91_TWI_SR);
+	const unsigned irqstatus = status & at91_twi_read(AT91_TWI_IMR);

-	/* Read data */
-	while (length--) {
-		if (!length)	/* need to send Stop before reading last byte */
-			at91_twi_write(AT91_TWI_CR, AT91_TWI_STOP);
-		if (!at91_poll_status(AT91_TWI_RXRDY)) {
-			dev_dbg(&adap->dev, "RXRDY timeout\n");
-			return -ETIMEDOUT;
-		}
-		*buf++ = (at91_twi_read(AT91_TWI_RHR) & 0xff);
+	if (irqstatus & AT91_TWI_TXCOMP) {
+		at91_disable_interrupts(dev);
+		dev->transfer_status = status;
+
+		complete(&dev->cmd_complete);
  	}

-	return 0;
+	else if (irqstatus & AT91_TWI_RXRDY)
+
+		at91_read_next_byte(dev);
+
+	else if (irqstatus & AT91_TWI_TXRDY)
+
+		at91_write_next_byte(dev);
+
+	else
+		return IRQ_NONE;
+
+	return IRQ_HANDLED;
  }

-static int xfer_write(struct i2c_adapter *adap, unsigned char *buf, int length)
+
+int at91_do_transfer(struct at91_i2c_dev *dev, bool is_read)
  {
-	/* Load first byte into transmitter */
-	at91_twi_write(AT91_TWI_THR, *buf++);
+	int ret = 0;

-	/* Send Start */
-	at91_twi_write(AT91_TWI_CR, AT91_TWI_START);
+	INIT_COMPLETION(dev->cmd_complete);

-	do {
-		if (!at91_poll_status(AT91_TWI_TXRDY)) {
-			dev_dbg(&adap->dev, "TXRDY timeout\n");
-			return -ETIMEDOUT;
-		}
+	if (is_read) {
+		if (!dev->buf_len)
+			at91_twi_write(AT91_TWI_CR,
+				       AT91_TWI_START | AT91_TWI_STOP);
+		else
+			at91_twi_write(AT91_TWI_CR, AT91_TWI_START);
+
+		at91_twi_write(AT91_TWI_IER, AT91_TWI_TXCOMP | AT91_TWI_RXRDY);

-		length--;	/* byte was transmitted */
+	} else {

-		if (length > 0)		/* more data to send? */
-			at91_twi_write(AT91_TWI_THR, *buf++);
-	} while (length);
+		at91_write_next_byte(dev);

-	/* Send Stop */
-	at91_twi_write(AT91_TWI_CR, AT91_TWI_STOP);
+		at91_twi_write(AT91_TWI_IER, AT91_TWI_TXCOMP | AT91_TWI_TXRDY);
+	}
+
+	ret = wait_for_completion_interruptible_timeout(&dev->cmd_complete,
+							dev->adapter.timeout);
+
+	if (ret == 0) {
+		dev_err(dev->dev, "controller timed out\n");
+		at91_init_bus(dev);
+		return -ETIMEDOUT;
+	}
+
+	if (dev->transfer_status & AT91_TWI_NACK) {
+		dev_dbg(dev->dev, "received nack\n");
+		return -ENODEV;
+	}
+
+	if (dev->transfer_status & AT91_TWI_OVRE) {
+		dev_err(dev->dev, "overrun while reading\n");
+		return -EIO;
+	}
+
+	dev_dbg(dev->dev, "transfer complete\n");

  	return 0;
  }

-/*
- * Generic i2c master transfer entrypoint.
- *
- * Note: We do not use Atmel's feature of storing the "internal device address".
- * Instead the "internal device address" has to be written using a separate
- * i2c message.
- * http://lists.arm.linux.org.uk/pipermail/linux-arm-kernel/2004-September/024411.html
- */
+
  static int at91_xfer(struct i2c_adapter *adap, struct i2c_msg *pmsg, int num)
  {
-	int i, ret;
+	struct at91_i2c_dev *dev = i2c_get_adapdata(adap);
+	int ret;
+	unsigned int_addr_flag = 0;
+	struct i2c_msg *m0 = pmsg;
+	struct i2c_msg *ma = m0;

  	dev_dbg(&adap->dev, "at91_xfer: processing %d messages:\n", num);

-	for (i = 0; i < num; i++) {
-		dev_dbg(&adap->dev, " #%d: %sing %d byte%s %s 0x%02x\n", i,
-			pmsg->flags & I2C_M_RD ? "read" : "writ",
-			pmsg->len, pmsg->len > 1 ? "s" : "",
-			pmsg->flags & I2C_M_RD ? "from" : "to",	pmsg->addr);
-
-		at91_twi_write(AT91_TWI_MMR, (pmsg->addr << 16)
-			| ((pmsg->flags & I2C_M_RD) ? AT91_TWI_MREAD : 0));
-
-		if (pmsg->len && pmsg->buf) {	/* sanity check */
-			if (pmsg->flags & I2C_M_RD)
-				ret = xfer_read(adap, pmsg->buf, pmsg->len);
-			else
-				ret = xfer_write(adap, pmsg->buf, pmsg->len);
-
-			if (ret)
-				return ret;
-
-			/* Wait until transfer is finished */
-			if (!at91_poll_status(AT91_TWI_TXCOMP)) {
-				dev_dbg(&adap->dev, "TXCOMP timeout\n");
-				return -ETIMEDOUT;
-			}
+	/* the hardware can handle at most two messages concatenated by a
+	   repeated start via it's internal address feature */
+
+	if (num > 2) {
+		dev_err(dev->dev,
+			"cannot handle more than two concatenated messages.\n");
+		return 0;
+
+	} else if (num == 2) {
+
+		int internal_address = 0;
+		int i;
+
+		ma = &pmsg[1];
+
+		if (m0->flags & I2C_M_RD) {
+			dev_err(dev->dev, "first transfer must be write.\n");
+			return 0;
  		}
-		dev_dbg(&adap->dev, "transfer complete\n");
-		pmsg++;		/* next message */
+
+		if (m0->len > 3) {
+			dev_err(dev->dev, "first message size must be <= 3.\n");
+			return 0;
+		}
+
+		for (i = 0; i < m0->len; ++i) {
+			internal_address |= ((unsigned)m0->buf[i]) << (8 * i);
+			int_addr_flag += AT91_TWI_IADRSZ_1;
+		}
+
+		at91_twi_write(AT91_TWI_IADR, internal_address);
  	}
-	return i;
+
+	at91_twi_write(AT91_TWI_MMR, (ma->addr << 16) | int_addr_flag
+		       | ((ma->flags & I2C_M_RD) ? AT91_TWI_MREAD : 0));
+
+	dev->buf_len = ma->len;
+	dev->buf = ma->buf;
+
+	ret = at91_do_transfer(dev, ma->flags & I2C_M_RD);
+
+	if (ret < 0)
+		return ret;
+
+	return num;
  }

  /*
@@ -191,86 +283,115 @@ static struct i2c_algorithm at91_algorithm = {
   */
  static int __devinit at91_i2c_probe(struct platform_device *pdev)
  {
-	struct i2c_adapter *adapter;
-	struct resource *res;
+	struct at91_i2c_dev *dev;
+	struct resource *mem, *irq, *ioarea;
  	int rc;

-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -ENODEV;
+
+	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!irq)
+		return -ENODEV;

-	if (!request_mem_region(res->start, resource_size(res), "at91_i2c"))
+	ioarea = request_mem_region(mem->start, resource_size(mem), pdev->name);
+	if (!ioarea)
  		return -EBUSY;

-	twi_base = ioremap(res->start, resource_size(res));
-	if (!twi_base) {
+	dev = kzalloc(sizeof(struct at91_i2c_dev), GFP_KERNEL);
+	if (!dev) {
  		rc = -ENOMEM;
-		goto fail0;
+		goto err_release_region;
  	}

-	twi_clk = clk_get(NULL, "twi_clk");
-	if (IS_ERR(twi_clk)) {
+	init_completion(&dev->cmd_complete);
+
+	dev->dev = get_device(&pdev->dev);
+	dev->irq = irq->start;
+	platform_set_drvdata(pdev, dev);
+
+	dev->clk = clk_get(&pdev->dev, "twi_clk");
+	if (IS_ERR(dev->clk)) {
  		dev_err(&pdev->dev, "no clock defined\n");
  		rc = -ENODEV;
-		goto fail1;
+		goto err_free_mem;
  	}
+	clk_enable(dev->clk);

-	adapter = kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
-	if (adapter == NULL) {
-		dev_err(&pdev->dev, "can't allocate inteface!\n");
-		rc = -ENOMEM;
-		goto fail2;
+	dev->base = ioremap(mem->start, resource_size(mem));
+	if (!dev->base) {
+		rc = -EBUSY;
+		goto err_mem_ioremap;
  	}
-	snprintf(adapter->name, sizeof(adapter->name), "AT91");
-	adapter->algo = &at91_algorithm;
-	adapter->class = I2C_CLASS_HWMON;
-	adapter->dev.parent = &pdev->dev;
-	/* adapter->id == 0 ... only one TWI controller for now */

-	platform_set_drvdata(pdev, adapter);
+	at91_twi_hwinit(dev);
+
+	rc = request_irq(dev->irq, atmel_twi_interrupt, 0,
+			 dev_name(&pdev->dev), dev);
+	if (rc) {
+		dev_err(&pdev->dev, "Cannot get irq %d: %d\n", dev->irq, rc);
+		goto err_unuse_clocks;
+	}

-	clk_enable(twi_clk);		/* enable peripheral clock */
-	at91_twi_hwinit();		/* initialize TWI controller */
+	snprintf(dev->adapter.name, sizeof(dev->adapter.name), "AT91");
+	i2c_set_adapdata(&dev->adapter, dev);
+	dev->adapter.owner = THIS_MODULE;
+	dev->adapter.class = I2C_CLASS_HWMON;
+	dev->adapter.algo = &at91_algorithm;
+	dev->adapter.dev.parent = &pdev->dev;
+	dev->adapter.nr = pdev->id;
+	dev->adapter.timeout = AT91_I2C_TIMEOUT;

-	rc = i2c_add_numbered_adapter(adapter);
+	rc = i2c_add_numbered_adapter(&dev->adapter);
  	if (rc) {
  		dev_err(&pdev->dev, "Adapter %s registration failed\n",
-				adapter->name);
-		goto fail3;
+			dev->adapter.name);
+		goto err_free_irq;
  	}

  	dev_info(&pdev->dev, "AT91 i2c bus driver.\n");
  	return 0;

-fail3:
+err_free_irq:
+	free_irq(dev->irq, dev);
+err_unuse_clocks:
+	iounmap(dev->base);
+err_mem_ioremap:
+	clk_disable(dev->clk);
+	clk_put(dev->clk);
+	dev->clk = NULL;
+err_free_mem:
  	platform_set_drvdata(pdev, NULL);
-	kfree(adapter);
-	clk_disable(twi_clk);
-fail2:
-	clk_put(twi_clk);
-fail1:
-	iounmap(twi_base);
-fail0:
-	release_mem_region(res->start, resource_size(res));
+	put_device(&pdev->dev);
+	kfree(dev);
+err_release_region:
+	release_mem_region(mem->start, resource_size(mem));

  	return rc;
  }

  static int __devexit at91_i2c_remove(struct platform_device *pdev)
  {
-	struct i2c_adapter *adapter = platform_get_drvdata(pdev);
-	struct resource *res;
+	struct at91_i2c_dev *dev = platform_get_drvdata(pdev);
+	struct resource *mem;
  	int rc;

-	rc = i2c_del_adapter(adapter);
  	platform_set_drvdata(pdev, NULL);
+	rc = i2c_del_adapter(&dev->adapter);
+	put_device(&pdev->dev);
+
+	clk_disable(dev->clk);
+	clk_put(dev->clk);
+	dev->clk = NULL;

-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	iounmap(twi_base);
-	release_mem_region(res->start, resource_size(res));
+	free_irq(dev->irq, dev);

-	clk_disable(twi_clk);		/* disable peripheral clock */
-	clk_put(twi_clk);
+	iounmap(dev->base);
+	kfree(dev);
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(mem->start, resource_size(mem));

  	return rc;
  }
@@ -279,33 +400,45 @@ static int __devexit at91_i2c_remove(struct platform_device *pdev)

  /* NOTE: could save a few mA by keeping clock off outside of at91_xfer... */

-static int at91_i2c_suspend(struct platform_device *pdev, pm_message_t mesg)
+static int at91_i2c_suspend(struct device *dev)
  {
-	clk_disable(twi_clk);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct at91_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
+
+	clk_disable(i2c_dev->clk);
+
  	return 0;
  }

-static int at91_i2c_resume(struct platform_device *pdev)
+static int at91_i2c_resume(struct device *dev)
  {
-	return clk_enable(twi_clk);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct at91_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
+
+	return clk_enable(i2c_dev->clk);
  }

+static const struct dev_pm_ops at91_i2c_pm = {
+	.suspend	= at91_i2c_suspend,
+	.resume		= at91_i2c_resume,
+};
+
+#define at91_i2c_pm_ops (&at91_i2c_pm)
  #else
-#define at91_i2c_suspend	NULL
-#define at91_i2c_resume		NULL
+#define at91_i2c_pm_ops NULL
  #endif

+
  /* work with "modprobe at91_i2c" from hotplugging or coldplugging */
  MODULE_ALIAS("platform:at91_i2c");

  static struct platform_driver at91_i2c_driver = {
  	.probe		= at91_i2c_probe,
  	.remove		= __devexit_p(at91_i2c_remove),
-	.suspend	= at91_i2c_suspend,
-	.resume		= at91_i2c_resume,
  	.driver		= {
  		.name	= "at91_i2c",
  		.owner	= THIS_MODULE,
+		.pm	= at91_i2c_pm_ops,
  	},
  };

@@ -322,6 +455,6 @@ static void __exit at91_i2c_exit(void)
  module_init(at91_i2c_init);
  module_exit(at91_i2c_exit);

-MODULE_AUTHOR("Rick Bronson");
+MODULE_AUTHOR("Nikolaus Voss");
  MODULE_DESCRIPTION("I2C (TWI) driver for Atmel AT91");
  MODULE_LICENSE("GPL");
-- 
1.7.5.4


-- 
Nikolaus Voss - Aastwiete 4 - 22880 Wedel

