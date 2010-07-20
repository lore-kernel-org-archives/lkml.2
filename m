Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab0GTEzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 00:55:45 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:4152 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110Ab0GTEzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 00:55:43 -0400
Message-ID: <000401cb27c7$ce732960$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Jean Delvare \(PC drivers, core\)" <khali@linux-fr.org>,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        <linux-i2c@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
        <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        <joel.clark@intel.com>, <andrew.chih.howe.khor@intel.com>
References: <4C204B0D.2030201@dsn.okisemi.com> <4C3EBBEC.9020304@dsn.okisemi.com> <201007152135.00280.arnd@arndb.de>
Subject: Re: [PATCH] I2C driver of Topcliff PCH
Date: Tue, 20 Jul 2010 13:55:38 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd

> > + struct adapter_info *adap_info = (struct adapter_info *)pData;
> > + /* invoke the call back  */
> > +
> > + if (pch_cbr != NULL) {
> > + for (i = 0, ret = 0; i < PCH_MAX_CHN; i++)
> > + ret |= (pch_cbr) (&adap_info->pch_data[i]);
> > + } else {
> > + dev_err(adap_info->pch_data[0].pch_adapter.dev.parent,
> > + "%s Call back pointer null ...", __func__);
> > + return IRQ_NONE;
> > + }
>
> Here you are multiplexing the interrupt yourself. If you don't
> always use all the available channels, it may be better to
> register the pch_cbr handler separately for each of the channels
> that are actually used, so you don't have to invoke the callback
> for all of them all the time.
>
> > + for (i = 0; i < PCH_MAX_CHN; i++) {
> > + adap_info->pch_data[i].p_adapter_info = adap_info;
> > +
> > + adap_info->pch_data[i].pch_adapter.owner = THIS_MODULE;
> > + adap_info->pch_data[i].pch_adapter.class = I2C_CLASS_HWMON;
> > + strcpy(adap_info->pch_data[i].pch_adapter.name, "pch_i2c");
> > + adap_info->pch_data[i].pch_adapter.algo = &pch_algorithm;
> > + adap_info->pch_data[i].pch_adapter.algo_data =
> > + &adap_info->pch_data[i];
> > +
> > + /* (i * 0x80) + base_addr; */
> > + adap_info->pch_data[i].pch_base_address = base_addr;
> > +
> > + adap_info->pch_data[i].pch_adapter.dev.parent = &pdev->dev;
> > +
> > + ret = i2c_add_adapter(&(adap_info->pch_data[i].pch_adapter));
> > +
> > + if (ret) {
> > + dev_err(&pdev->dev, "i2c_add_adapter FAILED");
> > + goto err_i2c_add_adapter;
> > + }
> > +
> > + dev_dbg(&pdev->dev,
> > + "i2c_add_adapter returns %d for channel-%d\n", ret, i);
> > + pch_init(&adap_info->pch_data[i]);
> > + dev_dbg(&pdev->dev, "pch_init invoked successfully\n");
> > + }
> > +
> > + ret = request_irq(pdev->irq, &pch_handler, IRQF_SHARED,
> > +   MODULE_NAME, adap_info);
>
> Similarly, you would create a new channel data structure for each channel here
> and register it separately, and then request the interrupt with that
> data structure as the info.

With I2c multi-cahnnel IOH, IRQ number is in common.
Thus, I think our PCH I2C driver can't be implemented like above.

Thanks, Ohtake.

----- Original Message ----- 
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>; "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>;
<linux-i2c@vger.kernel.org>; "LKML" <linux-kernel@vger.kernel.org>; <qi.wang@intel.com>; "Wang, Yong Y"
<yong.y.wang@intel.com>; <joel.clark@intel.com>; <andrew.chih.howe.khor@intel.com>
Sent: Friday, July 16, 2010 4:35 AM
Subject: Re: [PATCH] I2C driver of Topcliff PCH


> On Thursday 15 July 2010 09:42:36 Masayuki Ohtak wrote:
> > I2C driver of Topcliff PCH
> >
> > Topcliff PCH is the platform controller hub that is going to be used in
> > Intel's upcoming general embedded platform. All IO peripherals in
> > Topcliff PCH are actually devices sitting on AMBA bus.
> > Topcliff PCH has I2C I/F. Using this I/F, it is able to access system
> > devices connected to I2C.
>
> Looks ok in general. Some minor comments follow:
>
> > +/**
> > + * pch_wait_for_bus_idle() - check the status of bus.
> > + * @adap: Pointer to struct i2c_algo_pch_data.
> > + * @timeout: waiting time counter (us).
> > + */
> > +static s32 pch_wait_for_bus_idle(struct i2c_algo_pch_data *adap,
> > + s32 timeout)
> > +{
> > + u32 reg_value;
> > + void __iomem *p = adap->pch_base_address;
> > +
> > + /* get the status of bus busy */
> > + reg_value = (ioread32(p + PCH_I2CSR) & I2CMBB_BIT);
> > +
> > + while ((timeout != 0) && (reg_value != 0)) {
> > + msleep(1); /* wait for 100 ms */
> > + reg_value = ioread32(p + PCH_I2CSR) & I2CMBB_BIT;
> > +
> > + timeout--;
> > + }
>
>
> If you want to wait for a maximum amount of time, a loop with
> msleep(1) may end up waiting more than twice as long as you want,
> because each msleep typically returns one milisecond too late.
>
> Better use something like:
>
> time_t timeout = ktime_add_ns(ktime_get(), MAX_NANOSECONDS);
>
> do {
> if (ioread32(p + PCH_I2CSR) & I2CMBB_BIT) == 0)
> break;
> msleep(1);
> } while (ktime_lt(ktime_get(), timeout));
>
> > +/**
> > + * pch_wait_for_xfer_complete() - initiates a wait for the tx complete event
> > + * @adap: Pointer to struct i2c_algo_pch_data.
> > + */
> > +static s32 pch_wait_for_xfer_complete(struct i2c_algo_pch_data *adap)
> > +{
> > + u32 temp_flag;
> > + s32 ret;
> > + ret = wait_event_interruptible_timeout(pch_event,
> > + (adap->pch_event_flag != 0), msecs_to_jiffies(50));
> > +
> > + dev_dbg(adap->pch_adapter.dev.parent,
> > + "%s adap->pch_event_flag = %x", __func__, adap->pch_event_flag);
> > + temp_flag = adap->pch_event_flag;
> > + adap->pch_event_flag = 0;
> > +
> > + if (ret == 0) {
> > + dev_err(adap->pch_adapter.dev.parent,
> > + "%s : Timeout\n", __func__);
> > + } else if (ret < 0) {
> > + dev_err(adap->pch_adapter.dev.parent,
> > + "%s failed : Interrupted by other signal\n", __func__);
> > + ret = -ERESTARTSYS;
> > + } else if ((temp_flag & I2C_ERROR_MASK) == 0) {
> > + ret = 0;
> > + } else {
> > + dev_err(adap->pch_adapter.dev.parent,
> > + "%s failed : Error in transfer\n", __func__);
> > + }
> > +
> > + dev_err(adap->pch_adapter.dev.parent, "%s returns %d\n", __func__, ret);
> > +
> > + return ret;
> > +}
>
> The control flow is much more complex than it needs to be here.
> If you want to handle different kinds of error conditions, best
> use goto. Also, it's very unusual to return positive values
> on errors and to print dev_err messages on success.
>
> int ret;
> ret = wait_event_interruptible_timeout(...);
> if (ret < 0)
> goto out;
>
> if (ret == 0) {
> ret = -ETIMEOUT;
> goto out;
> }
>
> ret = 0;
> if (adap->pch_event_flag & I2C_ERROR_MASK) {
> ret = -EIO;
> dev_err(adap->pch_adapter.dev.parent, "error bits set: %lx\n", adap->pch_event_flag);
> }
>
> out:
> return ret;
>
> > +/**
> > + * pch_handler() - interrupt handler for the PCH I2C controller
> > + * @irq: irq number.
> > + * @pData: cookie passed back to the handler function.
> > + */
> > +static irqreturn_t pch_handler(int irq, void *pData)
> > +{
> > + s32 ret;
> > + u32 i;
> > +
> > + struct adapter_info *adap_info = (struct adapter_info *)pData;
> > + /* invoke the call back  */
> > +
> > + if (pch_cbr != NULL) {
> > + for (i = 0, ret = 0; i < PCH_MAX_CHN; i++)
> > + ret |= (pch_cbr) (&adap_info->pch_data[i]);
> > + } else {
> > + dev_err(adap_info->pch_data[0].pch_adapter.dev.parent,
> > + "%s Call back pointer null ...", __func__);
> > + return IRQ_NONE;
> > + }
>
> Here you are multiplexing the interrupt yourself. If you don't
> always use all the available channels, it may be better to
> register the pch_cbr handler separately for each of the channels
> that are actually used, so you don't have to invoke the callback
> for all of them all the time.
>
> > + for (i = 0; i < PCH_MAX_CHN; i++) {
> > + adap_info->pch_data[i].p_adapter_info = adap_info;
> > +
> > + adap_info->pch_data[i].pch_adapter.owner = THIS_MODULE;
> > + adap_info->pch_data[i].pch_adapter.class = I2C_CLASS_HWMON;
> > + strcpy(adap_info->pch_data[i].pch_adapter.name, "pch_i2c");
> > + adap_info->pch_data[i].pch_adapter.algo = &pch_algorithm;
> > + adap_info->pch_data[i].pch_adapter.algo_data =
> > + &adap_info->pch_data[i];
> > +
> > + /* (i * 0x80) + base_addr; */
> > + adap_info->pch_data[i].pch_base_address = base_addr;
> > +
> > + adap_info->pch_data[i].pch_adapter.dev.parent = &pdev->dev;
> > +
> > + ret = i2c_add_adapter(&(adap_info->pch_data[i].pch_adapter));
> > +
> > + if (ret) {
> > + dev_err(&pdev->dev, "i2c_add_adapter FAILED");
> > + goto err_i2c_add_adapter;
> > + }
> > +
> > + dev_dbg(&pdev->dev,
> > + "i2c_add_adapter returns %d for channel-%d\n", ret, i);
> > + pch_init(&adap_info->pch_data[i]);
> > + dev_dbg(&pdev->dev, "pch_init invoked successfully\n");
> > + }
> > +
> > + ret = request_irq(pdev->irq, &pch_handler, IRQF_SHARED,
> > +   MODULE_NAME, adap_info);
>
> Similarly, you would create a new channel data structure for each channel here
> and register it separately, and then request the interrupt with that
> data structure as the info.
>
> > @@ -147,6 +148,11 @@ static ssize_t i2cdev_read(struct file *file, char __user *buf, size_t count,
> >  if (tmp == NULL)
> >  return -ENOMEM;
> >
> > + if (copy_from_user(tmp, buf, count)) {
> > + kfree(tmp);
> > + return -EFAULT;
> > + }
> > +
> >  pr_debug("i2c-dev: i2c-%d reading %zu bytes.\n",
> >  iminor(file->f_path.dentry->d_inode), count);
>
>
> A read function should not do copy_from_user, only copy_to_user.
> If you are worried about returning invalid data from kernel space,
> better use kzalloc instead of kmalloc to get the buffer.
>
> Arnd
>


