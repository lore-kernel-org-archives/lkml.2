Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab0ICEis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 00:38:48 -0400
Received: from mail.perches.com ([173.55.12.10]:1256 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab0ICEiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 00:38:46 -0400
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_I2C driver to 2.6.35
From: Joe Perches <joe@perches.com>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Crane Cai <crane.cai@amd.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        yong.y.wang@intel.com, qi.wang@intel.com,
        andrew.chih.howe.khor@intel.com, arjan@linux.intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <4C80692E.80004@dsn.okisemi.com>
References: <4C80692E.80004@dsn.okisemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 21:38:43 -0700
Message-ID: <1283488723.1797.386.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I suggest these logging message changes and bug fixes:

Add pch_pci_dbg.
Rename 1st argument to pch_pci_dbg to pdev.
Add trailing "\n" to formats missing them.
Add "%s:" fmt, __func__, args to pch_<level> and pch_pci_<level>
logging macros.
Remove __func__ and inconsistent use of "%s : " and "%s:" prefix
from logging macro uses.
Fix misspelling of Enterred to Entered.
Use "FAILED" consistently.

There's an odd use that is still questionable:

pch_pci_dbg(pdev, "request_irq returns %d pch_probe returns\n", ret);

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/i2c/busses/i2c-pch.c |  103 ++++++++++++++++++++----------------------
 1 files changed, 49 insertions(+), 54 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pch.c b/drivers/i2c/busses/i2c-pch.c
index 0933e63..f5bb140 100644
--- a/drivers/i2c/busses/i2c-pch.c
+++ b/drivers/i2c/busses/i2c-pch.c
@@ -121,13 +121,15 @@
 #define I2CESRTO_EVENT		0x0100
 #define PCI_DEVICE_ID_PCH_I2C	0x8817
 
-#define pch_dbg(adap, fmt, arg...)  \
-			dev_dbg(adap->pch_adapter.dev.parent, fmt, ##arg)
+#define pch_dbg(adap, fmt, arg...)				\
+	dev_dbg(adap->pch_adapter.dev.parent, "%s: " fmt, __func__, ##arg)
+#define pch_err(adap, fmt, arg...)				\
+	dev_err(adap->pch_adapter.dev.parent, "%s: " fmt, __func__, ##arg)
 
-#define pch_err(adap, fmt, arg...)  \
-			dev_err(adap->pch_adapter.dev.parent, fmt, ##arg)
-
-#define pch_pci_err(adap, fmt, arg...)  dev_err(&adap->dev, fmt, ##arg)
+#define pch_pci_dbg(pdev, fmt, arg...)				\
+	dev_dbg(&pdev->dev, "%s: " fmt, __func__, ##arg)
+#define pch_pci_err(pdev, fmt, arg...)				\
+	dev_err(&pdev->dev, "%s: " fmt, __func__, ##arg)
 
 /**
  * struct i2c_algo_pch_data - for I2C driver functionalities
@@ -243,9 +245,8 @@ static void pch_init(struct i2c_algo_pch_data *adap)
 	reg_value |= NORMAL_INTR_ENBL;	/* Enable interrupts in normal mode */
 	iowrite32(reg_value, p + PCH_I2CCTL);
 
-	pch_dbg(adap,
-		"%s: I2CCTL=%x pch_i2cbc=%x pch_i2ctmr=%x Enable interrupts\n",
-		__func__, ioread32(p + PCH_I2CCTL), pch_i2cbc, pch_i2ctmr);
+	pch_dbg(adap, "I2CCTL=%x pch_i2cbc=%x pch_i2ctmr=%x Enable interrupts\n",
+		ioread32(p + PCH_I2CCTL), pch_i2cbc, pch_i2ctmr);
 
 	init_waitqueue_head(&pch_event);
 }
@@ -273,10 +274,10 @@ static s32 pch_wait_for_bus_idle(struct i2c_algo_pch_data *adap,
 		msleep(1);
 	} while (ktime_lt(ktime_get(), ns_val));
 
-	pch_dbg(adap, "%s : I2CSR = %x\n", __func__, ioread32(p + PCH_I2CSR));
+	pch_dbg(adap, "I2CSR = %x\n", ioread32(p + PCH_I2CSR));
 
 	if (timeout == 0) {
-		pch_err(adap, "%s :return%d\n", __func__, -ETIME);
+		pch_err(adap, "return: %d\n", -ETIME);
 		return -ETIME;
 	}
 
@@ -292,8 +293,7 @@ static s32 pch_wait_for_bus_idle(struct i2c_algo_pch_data *adap,
 static void pch_start(struct i2c_algo_pch_data *adap)
 {
 	void __iomem *p = adap->pch_base_address;
-	pch_dbg(adap, "In %s : I2CCTL = %x\n",
-		__func__, ioread32(p + PCH_I2CCTL));
+	pch_dbg(adap, "I2CCTL = %x\n", ioread32(p + PCH_I2CCTL));
 	pch_setbit((adap->pch_base_address), PCH_I2CCTL, PCH_START);
 }
 
@@ -307,20 +307,17 @@ static s32 pch_wait_for_xfer_complete(struct i2c_algo_pch_data *adap)
 	ret = wait_event_interruptible_timeout(pch_event,
 			(adap->pch_event_flag != 0), msecs_to_jiffies(50));
 	if (ret < 0) {
-		pch_err(adap, "%s :timeout: %x\n",
-						__func__, adap->pch_event_flag);
+		pch_err(adap, "timeout: %x\n", adap->pch_event_flag);
 		return ret;
 	}
 
 	if (ret == 0) {
-		pch_err(adap, "%s :timeout: %x\n",
-						__func__, adap->pch_event_flag);
+		pch_err(adap, "timeout: %x\n", adap->pch_event_flag);
 		return -ETIMEDOUT;
 	}
 
 	if (adap->pch_event_flag & I2C_ERROR_MASK) {
-		pch_err(adap, "%s :error bits set: %x\n",
-						__func__, adap->pch_event_flag);
+		pch_err(adap, "error bits set: %x\n", adap->pch_event_flag);
 		return -EIO;
 	}
 
@@ -341,7 +338,7 @@ static s32 pch_getack(struct i2c_algo_pch_data *adap)
 	reg_val = ioread32(p + PCH_I2CSR) & PCH_GETACK;
 
 	if (reg_val != 0) {
-		pch_err(adap, "%s : return%d\n", __func__, -EPROTO);
+		pch_err(adap, "return: %d\n", -EPROTO);
 		return -EPROTO;
 	}
 
@@ -355,7 +352,7 @@ static s32 pch_getack(struct i2c_algo_pch_data *adap)
 static void pch_stop(struct i2c_algo_pch_data *adap)
 {
 	void __iomem *p = adap->pch_base_address;
-	pch_dbg(adap, "%s : I2CCTL = %x\n", __func__, ioread32(p + PCH_I2CCTL));
+	pch_dbg(adap, "I2CCTL = %x\n", ioread32(p + PCH_I2CCTL));
 	/* clear the start bit */
 	pch_clrbit((adap->pch_base_address), PCH_I2CCTL, PCH_START);
 }
@@ -367,8 +364,7 @@ static void pch_stop(struct i2c_algo_pch_data *adap)
 static void pch_repstart(struct i2c_algo_pch_data *adap)
 {
 	void __iomem *p = adap->pch_base_address;
-	pch_dbg(adap, "In %s : I2CCTL = %x\n",
-		__func__, ioread32(p + PCH_I2CCTL));
+	pch_dbg(adap, "I2CCTL = %x\n", ioread32(p + PCH_I2CCTL));
 	pch_setbit((adap->pch_base_address), PCH_I2CCTL, PCH_REPSTART);
 }
 
@@ -398,7 +394,7 @@ static s32 pch_writebytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 	/* enable master tx */
 	pch_setbit((adap->pch_base_address), PCH_I2CCTL, I2C_TX_MODE);
 
-	pch_dbg(adap, "%s : I2CCTL = %x msgs->len = %d\n", __func__,
+	pch_dbg(adap, "I2CCTL = %x msgs->len = %d\n",
 		ioread32(p + PCH_I2CCTL), length);
 
 	if (first) {
@@ -431,13 +427,13 @@ static s32 pch_writebytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 		for (wrcount = 0; wrcount < length; ++wrcount) {
 			/* write buffer value to I2C data register */
 			iowrite32(buf[wrcount], p + PCH_I2CDR);
-			pch_dbg(adap, "%s : writing %x to Data register\n",
-				__func__, buf[wrcount]);
+			pch_dbg(adap, "writing %x to Data register\n",
+				buf[wrcount]);
 
 			if (pch_wait_for_xfer_complete(adap) != 0)
 				return -ETIME;
 
-			pch_dbg(adap, "%s return %d", __func__, 0);
+			pch_dbg(adap, "return %d", 0);
 
 			if (pch_getack(adap))
 				return -ETIME;
@@ -453,7 +449,7 @@ static s32 pch_writebytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 		return -EIO;
 	}
 
-	pch_dbg(adap, "%s return=%d\n", __func__, wrcount);
+	pch_dbg(adap, "return=%d\n", wrcount);
 
 	return wrcount;
 }
@@ -465,7 +461,7 @@ static s32 pch_writebytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 static void pch_sendack(struct i2c_algo_pch_data *adap)
 {
 	void __iomem *p = adap->pch_base_address;
-	pch_dbg(adap, "%s : I2CCTL = %x\n", __func__, ioread32(p + PCH_I2CCTL));
+	pch_dbg(adap, "I2CCTL = %x\n", ioread32(p + PCH_I2CCTL));
 	pch_clrbit((adap->pch_base_address), PCH_I2CCTL, PCH_ACK);
 }
 
@@ -476,7 +472,7 @@ static void pch_sendack(struct i2c_algo_pch_data *adap)
 static void pch_sendnack(struct i2c_algo_pch_data *adap)
 {
 	void __iomem *p = adap->pch_base_address;
-	pch_dbg(adap, "%s : I2CCTL = %x\n", __func__, ioread32(p + PCH_I2CCTL));
+	pch_dbg(adap, "I2CCTL = %x\n", ioread32(p + PCH_I2CCTL));
 	pch_setbit((adap->pch_base_address), PCH_I2CCTL, PCH_ACK);
 }
 
@@ -526,7 +522,7 @@ s32 pch_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 
 	if ((pch_wait_for_xfer_complete(adap) == 0)
 					    && (pch_getack(adap) == 0)) {
-		pch_dbg(adap, "%s return %d", __func__, 0);
+		pch_dbg(adap, "return %d", 0);
 
 		if (length == 0) {
 			pch_stop(adap);
@@ -599,8 +595,7 @@ static void pch_cb_ch0(struct i2c_algo_pch_data *adap)
 	/* clear the applicable bits */
 	pch_clrbit((adap->pch_base_address), PCH_I2CSR, sts);
 
-	pch_dbg(adap, "%s : PCH_I2CSR = %x\n",
-		__func__, ioread32(p + PCH_I2CSR));
+	pch_dbg(adap, "PCH_I2CSR = %x\n", ioread32(p + PCH_I2CSR));
 
 	wake_up_interruptible(&pch_event);
 }
@@ -619,7 +614,7 @@ static irqreturn_t pch_handler_ch0(int irq, void *pData)
 	u32 mode = ioread32(p + PCH_I2CMOD) & (BUFFER_MODE | EEPROM_SR_MODE);
 
 	if (mode != NORMAL_MODE) {
-		pch_err(adap_data, "%s I2C mode is not supported\n", __func__);
+		pch_err(adap_data, "I2C mode is not supported\n");
 		return IRQ_NONE;
 	}
 
@@ -639,7 +634,7 @@ static irqreturn_t pch_handler_ch0(int irq, void *pData)
 		else
 			goto err_out;
 	} else {
-		pch_err(adap_data, "%s I2C mode is not supported\n", __func__);
+		pch_err(adap_data, "I2C mode is not supported\n");
 		goto err_out;
 	}
 	return IRQ_HANDLED;
@@ -675,8 +670,8 @@ static s32 pch_xfer(struct i2c_adapter *i2c_adap,
 		return -EBUSY;
 	}
 
-	pch_dbg(adap, "%s adap->p_adapter_info->pch_suspended is %d\n",
-		__func__, adap->p_adapter_info->pch_suspended);
+	pch_dbg(adap, "adap->p_adapter_info->pch_suspended is %d\n",
+		adap->p_adapter_info->pch_suspended);
 	/* transfer not completed */
 	adap->pch_xfer_in_progress = true;
 
@@ -685,7 +680,7 @@ static s32 pch_xfer(struct i2c_adapter *i2c_adap,
 		pmsg->flags |= adap->pch_buff_mode_en;
 		status = pmsg->flags;
 		pch_dbg(adap,
-			"After invoking I2C_MODE_SEL :flag= 0x%x\n", status);
+			"After invoking I2C_MODE_SEL: flag=0x%x\n", status);
 		/* calculate sub address length and message length */
 		/* these are applicable only for buffer mode */
 		subaddrlen = pmsg->buf[0];
@@ -693,11 +688,11 @@ static s32 pch_xfer(struct i2c_adapter *i2c_adap,
 		 * the sub address fields */
 		msglen = (pmsg->len) - (subaddrlen + 1);
 		if (status & (I2C_M_RD)) {
-			pch_dbg(adap, "%s invoking pch_readbytes\n", __func__);
+			pch_dbg(adap, "invoking pch_readbytes\n");
 			ret = pch_readbytes(i2c_adap, pmsg, (i + 1 == num),
 					   (i == 0));
 		} else {
-			pch_dbg(adap, "%s invoking pch_writebytes\n", __func__);
+			pch_dbg(adap, "invoking pch_writebytes\n");
 			ret = pch_writebytes(i2c_adap, pmsg, (i + 1 == num),
 					    (i == 0));
 		}
@@ -752,29 +747,29 @@ static int __devinit pch_probe(struct pci_dev *pdev,
 	struct adapter_info *adap_info =
 			kzalloc((sizeof(struct adapter_info)), GFP_KERNEL);
 
-	dev_dbg(&pdev->dev, "Enterred in %s\n", __func__);
+	pch_pci_dbg(pdev, "Entered\n");
 
 	if (adap_info == NULL) {
-		pch_pci_err(pdev, "Memory allocation failed FAILED");
+		pch_pci_err(pdev, "Memory allocation failed FAILED\n");
 		return -ENOMEM;
 	}
 
 	ret = pci_enable_device(pdev);
 	if (ret) {
-		pch_pci_err(pdev, "%s : pci_enable_device FAILED", __func__);
+		pch_pci_err(pdev, "pci_enable_device FAILED\n");
 		goto err_pci_enable;
 	}
 
 	ret = pci_request_regions(pdev, KBUILD_MODNAME);
 	if (ret) {
-		pch_pci_err(pdev, "pci_request_regions FAILED");
+		pch_pci_err(pdev, "pci_request_regions FAILED\n");
 		goto err_pci_req;
 	}
 
 	base_addr = pci_iomap(pdev, 1, 0);
 
 	if (base_addr == 0) {
-		pch_pci_err(pdev, "pci_iomap FAILED");
+		pch_pci_err(pdev, "pci_iomap FAILED\n");
 		ret = -ENOMEM;
 		goto err_pci_iomap;
 	}
@@ -799,7 +794,7 @@ static int __devinit pch_probe(struct pci_dev *pdev,
 		ret = i2c_add_adapter(&(adap_info->pch_data[i].pch_adapter));
 
 		if (ret) {
-			pch_pci_err(pdev, "i2c_add_adapter FAILED");
+			pch_pci_err(pdev, "i2c_add_adapter FAILED\n");
 			goto err_i2c_add_adapter;
 		}
 
@@ -807,12 +802,12 @@ static int __devinit pch_probe(struct pci_dev *pdev,
 		ret = request_irq(pdev->irq, pch_handler_list[i], IRQF_SHARED,
 			  KBUILD_MODNAME, &adap_info->pch_data[i]);
 		if (ret) {
-			pch_pci_err(pdev, "request_irq Failed\n");
+			pch_pci_err(pdev, "request_irq FAILED\n");
 			goto err_request_irq;
 		}
 	}
 
-	dev_dbg(&pdev->dev, "request_irq returns %d pch_probe returns.\n", ret);
+	pch_pci_dbg(pdev, "request_irq returns %d pch_probe returns\n", ret);
 	pci_set_drvdata(pdev, adap_info);
 	return 0;
 
@@ -876,12 +871,12 @@ static int pch_suspend(struct pci_dev *pdev, pm_message_t state)
 		pch_disbl_int(&adap_info->pch_data[i]);
 	}
 
-	dev_dbg(&pdev->dev,
-		"I2CSR = %x I2CBUFSTA = %x I2CESRSTA = %x "
-		"invoked function pch_disbl_int successfully\n",
-		ioread32(p + 0x08),
-		ioread32(p + 0x30),
-		ioread32(p + 0x44));
+	pch_pci_dbg(pdev,
+		    "I2CSR = %x I2CBUFSTA = %x I2CESRSTA = %x "
+		    "invoked function pch_disbl_int successfully\n",
+		    ioread32(p + 0x08),
+		    ioread32(p + 0x30),
+		    ioread32(p + 0x44));
 
 	ret = pci_save_state(pdev);
 




