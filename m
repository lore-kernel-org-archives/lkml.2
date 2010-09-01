Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab0IATo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 15:44:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50537 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab0IATo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 15:44:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LETzsKRtxAL66NeUCnkW7jPOufnlHL4jYHfbWpOqsPMzHyJw4P7uKnUSY4CaNTkOf+
         3+xqkglhm+q2Fawze6D+O7uFvL9vk3BrAYUY9ucz156cP4q2TuS2Kbh3UwNbz4ZoyX6V
         fBwA8fVGIJ/qYEBJsJH8CPJwyR+p30FgJDGVE=
MIME-Version: 1.0
In-Reply-To: <4C7DB9CF.5000905@dsn.okisemi.com>
References: <4C7DB9CF.5000905@dsn.okisemi.com>
Date: Wed, 1 Sep 2010 21:44:53 +0200
Message-ID: <AANLkTik5qxaGAj2-jBYfJjeP43XNep61fxwVXbfVA3J4@mail.gmail.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_I2C driver to 2.6.35
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Crane Cai <crane.cai@amd.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Wang Yong Y\"" <yong.y.wang@intel.com>,
        "Wang Qi\"" <qi.wang@intel.com>,
        "Andrew\"" <andrew.chih.howe.khor@intel.com>, arjan@linux.intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/1 Masayuki Ohtak <masa-korg@dsn.okisemi.com>:

> I2C driver of Topcliff PCH
> (...)
> +++ b/drivers/i2c/busses/i2c-pch.c
> (...)
> +/**
> + * pch_wait_for_bus_idle() - check the status of bus.
> + * @adap:      Pointer to struct i2c_algo_pch_data.
> + * @timeout:   waiting time counter (us).
> + */
> +static s32 pch_wait_for_bus_idle(struct i2c_algo_pch_data *adap,
> +                                s32 timeout)
> +{
> +       void __iomem *p = adap->pch_base_address;
> +
> +       /* MAX timeout value is timeout*1000*1000nsec */
> +       ktime_t ns_val = ktime_add_ns(ktime_get(), timeout*1000*1000);
> +       do {
> +               if ((ioread32(p + PCH_I2CSR) & I2CMBB_BIT) == 0)
> +                       break;
> +               msleep(1);
> +       } while (ktime_lt(ktime_get(), ns_val));
> +
> +       dev_dbg(adap->pch_adapter.dev.parent,
> +                       "%s : I2CSR = %x\n", __func__, ioread32(p + PCH_I2CSR));
> +
> +       if (timeout == 0) {
> +               dev_err(adap->pch_adapter.dev.parent,
> +                                       "%s :return%d\n", __func__, -ETIME);

Why not just return -ETIME; here?

> +       } else {
> +               dev_dbg(adap->pch_adapter.dev.parent,
> +                                       "%s : return %d\n", __func__, 0);
> +       }

Delete this else clause, who is interested in return 0???

> +       return ((timeout <= 0) ? (-ETIME) : (0));

return 0;

> (...)
> +/**
> + * pch_wait_for_xfer_complete() - initiates a wait for the tx complete event
> + * @adap:      Pointer to struct i2c_algo_pch_data.
> + */
> +static s32 pch_wait_for_xfer_complete(struct i2c_algo_pch_data *adap)
> +{
> +       s32 ret;
> +       ret = wait_event_interruptible_timeout(pch_event,
> +                       (adap->pch_event_flag != 0), msecs_to_jiffies(50));
> +       if (ret < 0)
> +               goto out;

The goto construction is unnecessary, just

return ret;

> +
> +       if (ret == 0) {
> +               ret = -ETIMEDOUT;
> +               goto out;

return -ETIMEDOUT;

> +       }
> +
> +       if (adap->pch_event_flag & I2C_ERROR_MASK) {
> +               ret = -EIO;
> +               dev_err(adap->pch_adapter.dev.parent,
> +                               "error bits set: %x\n", adap->pch_event_flag);
> +               goto out;

Skip ret assignment
return -EIO;

> +       }
> +
> +       adap->pch_event_flag = 0;
> +       ret = 0;

Skip this

> +out:
> +       return ret;

return 0;

> +}
> (...)
> +/**
> + * pch_getack() - to confirm ACK/NACK
> + * @adap:      Pointer to struct i2c_algo_pch_data.
> + */
> +static s32 pch_getack(struct i2c_algo_pch_data *adap)
> +{
> +       u32 reg_val;
> +       void __iomem *p = adap->pch_base_address;
> +       reg_val = ioread32(p + PCH_I2CSR) & PCH_GETACK;
> +
> +       if (reg_val == 0)
> +               dev_dbg(adap->pch_adapter.dev.parent, "%s : return 0\n",
> +                                                               __func__);
> +       else
> +               dev_dbg(adap->pch_adapter.dev.parent, "%s : return%d\n",
> +                                                       __func__, -EPROTO);
> +
> +       return (((reg_val) == 0) ? (0) : (-EPROTO));

Refactor this like the other function, no weirdo debug prints
return 0;

> +}
> (...)
> +/**
> + * pch_writebytes() - write data to I2C bus in normal mode
> + * @i2c_adap:  Pointer to the struct i2c_adapter.
> + * @last:      specifies whether last message or not.
> + *             In the case of compound mode it will be 1 for last message,
> + *             otherwise 0.
> + * @first:     specifies whether first message or not.
> + *             1 for first message otherwise 0.
> + */
> +static s32 pch_writebytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
> +                         u32 last, u32 first)
> +{
> +       struct i2c_algo_pch_data *adap = i2c_adap->algo_data;
> +       u8 *buf;
> +       u32 length;
> +       u32 addr;
> +       u32 addr_2_msb;
> +       u32 addr_8_lsb;
> +       s32 wrcount;

You don't assign anything to wrcount...

> +       void __iomem *p = adap->pch_base_address;
> +       length = msgs->len;
> +       buf = msgs->buf;
> +       addr = msgs->addr;
> +       /* enable master tx */
> +       pch_setbit((adap->pch_base_address), PCH_I2CCTL, I2C_TX_MODE);
> +
> +       dev_dbg(adap->pch_adapter.dev.parent,
> +               "%s : I2CCTL = %x msgs->len = %d\n", __func__,
> +               ioread32(p + PCH_I2CCTL), length);
> +
> +       if (first) {
> +               if (pch_wait_for_bus_idle(adap, BUS_IDLE_TIMEOUT) == -ETIME)
> +                       return -ETIME;
> +       }
> +
> +       if (msgs->flags & I2C_M_TEN) {
> +               addr_2_msb = ((addr & I2C_MSB_2B_MSK) >> 7);
> +               iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK, p + PCH_I2CDR);
> +               if (first)
> +                       pch_start(adap);
> +               if ((pch_wait_for_xfer_complete(adap) == 0) &&
> +                   (pch_getack(adap) == 0)) {
> +                       addr_8_lsb = (addr & I2C_ADDR_MSK);
> +                       iowrite32(addr_8_lsb, p + PCH_I2CDR);
> +               } else {
> +                       pch_stop(adap);
> +                       return -ETIME;
> +               }
> +       } else {
> +               /* set 7 bit slave address and R/W bit as 0 */
> +               iowrite32(addr << 1, p + PCH_I2CDR);
> +               if (first)
> +                       pch_start(adap);
> +       }
> +
> +       if ((pch_wait_for_xfer_complete(adap) == 0) &&
> +                                               (pch_getack(adap) == 0)) {
> +               for (wrcount = 0; wrcount < length; ++wrcount) {

...but it is only conditionally used here...

> +                       /* write buffer value to I2C data register */
> +                       iowrite32(buf[wrcount], p + PCH_I2CDR);
> +                       dev_dbg(adap->pch_adapter.dev.parent,
> +                               "%s : writing %x to Data register\n",
> +                               __func__, buf[wrcount]);
> +
> +                       if (pch_wait_for_xfer_complete(adap) != 0) {
> +                               wrcount = -ETIME;
> +                               break;
> +                       }
> +
> +                       dev_dbg(adap->pch_adapter.dev.parent,
> +                                               "%s return %d", __func__, 0);
> +
> +                       if (pch_getack(adap)) {
> +                               wrcount = -ETIME;
> +                               break;
> +                       }
> +               }
> +
> +               /* check if this is the last message */
> +               if (last)
> +                       pch_stop(adap);
> +               else
> +                       pch_repstart(adap);
> +       } else {
> +               pch_stop(adap);
> +       }
> +
> +       dev_dbg(adap->pch_adapter.dev.parent,
> +                                       "%s return=%d\n", __func__, wrcount);
> +
> +       return wrcount;

...and then you return it, leading to a possibly unassigned state.

> +}
> (...)
> +/**
> + * pch_readbytes() - read data  from I2C bus in normal mode.
> + * @i2c_adap:  Pointer to the struct i2c_adapter.
> + * @msgs:      Pointer to i2c_msg structure.
> + * @last:      specifies whether last message or not.
> + * @first:     specifies whether first message or not.
> + */
> +s32 pch_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
> +                 u32 last, u32 first)
> +{
> +       struct i2c_algo_pch_data *adap = i2c_adap->algo_data;
> +
> +       u8 *buf;
> +       u32 count;

Same problem here. Initialize to 0.

> +       u32 length;
> +       u32 addr;
> +       u32 addr_2_msb;
> +       void __iomem *p = adap->pch_base_address;
> +       length = msgs->len;
> +       buf = msgs->buf;
> +       addr = msgs->addr;
> +
> +       /* enable master reception */
> +       pch_clrbit((adap->pch_base_address), PCH_I2CCTL, I2C_TX_MODE);
> +
> +       if (first) {
> +               if (pch_wait_for_bus_idle(adap, BUS_IDLE_TIMEOUT) == -ETIME)
> +                       return -ETIME;
> +       }
> +
> +       if (msgs->flags & I2C_M_TEN) {
> +               addr_2_msb = (((addr & I2C_MSB_2B_MSK) >> 7) | (I2C_RD));
> +               iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK, p + PCH_I2CDR);
> +
> +       } else {
> +               /* 7 address bits + R/W bit */
> +               addr = (((addr) << 1) | (I2C_RD));
> +               iowrite32(addr, p + PCH_I2CDR);
> +       }
> +
> +       /* check if it is the first message */
> +       if (first)
> +               pch_start(adap);
> +
> +       if ((pch_wait_for_xfer_complete(adap) == 0)
> +                                           && (pch_getack(adap) == 0)) {
> +               dev_dbg(adap->pch_adapter.dev.parent,
> +                                               "%s return %d", __func__, 0);
> +
> +               if (length == 0) {
> +                       pch_stop(adap);
> +                       ioread32(p + PCH_I2CDR); /* Dummy read needs */
> +
> +                       count = length;
> +               } else {
> +                       int read_index;
> +                       int loop;
> +                       pch_sendack(adap);
> +
> +                       /* Dummy read */
> +                       for (loop = 1, read_index = 0; loop < length; loop++) {
> +                               buf[read_index] = ioread32(p + PCH_I2CDR);
> +
> +                               if (loop != 1)
> +                                       read_index++;
> +
> +                               if (pch_wait_for_xfer_complete(adap) != 0) {
> +                                       pch_stop(adap);
> +                                       return -ETIME;
> +                               }
> +                       }       /* end for */
> +
> +                       pch_sendnack(adap);
> +
> +                       buf[read_index] = ioread32(p + PCH_I2CDR);
> +
> +                       if (length != 1)
> +                               read_index++;
> +
> +                       if (pch_wait_for_xfer_complete(adap) == 0) {
> +                               if (last)
> +                                       pch_stop(adap);
> +                               else
> +                                       pch_repstart(adap);
> +
> +                               buf[read_index++] = ioread32(p + PCH_I2CDR);
> +                               count = read_index;
> +                       } else {
> +                               count = -ETIME;
> +                       }
> +
> +               }
> +       } else {
> +               count = -ETIME;
> +               pch_stop(adap);
> +       }
> +
> +       return count;
> +}

> (...)
> +/**
> + * pch_handler_ch0() - interrupt handler for the PCH I2C controller
> + * @irq:       irq number.
> + * @pData:     cookie passed back to the handler function.
> + */
> +static irqreturn_t pch_handler_ch0(int irq, void *pData)
> +{
> +       s32 reg_val;
> +
> +       struct i2c_algo_pch_data *adap_data = (struct i2c_algo_pch_data *)pData;
> +       void __iomem *p = adap_data->pch_base_address;
> +       u32 mode = ioread32(p + PCH_I2CMOD) & (BUFFER_MODE | EEPROM_SR_MODE);
> +
> +       if (mode == NORMAL_MODE) {

No.

if (mode != NORMAL_MODE) {
  dev_err(...)
  return IRQ_NONE;
}

Then de-indent the rest and remove the else clause.

> +               reg_val = ioread32(p + PCH_I2CSR);
> +               if (reg_val & (I2CMAL_BIT | I2CMCF_BIT | I2CMIF_BIT))
> +                       pch_cb_ch0(adap_data);
> +               else
> +                       goto err_out;
> +       } else {
> +               dev_err(adap_data->pch_adapter.dev.parent,
> +                       "%s I2C mode is not supported\n", __func__);
> +               goto err_out;
> +       }
> +       return IRQ_HANDLED;
> +
> +err_out:
> +       return IRQ_NONE;
> +}

> (...)
> +/**
> + * pch_xfer() - Reading adnd writing data through I2C bus
> + * @i2c_adap:  Pointer to the struct i2c_adapter.
> + * @msgs:      Pointer to i2c_msg structure.
> + * @num:       number of messages.
> + */
> +static s32 pch_xfer(struct i2c_adapter *i2c_adap,
> +                   struct i2c_msg *msgs, s32 num)
> +{
> +       struct i2c_msg *pmsg;
> +       u32 i;
> +       u32 status;
> +       u32 msglen;
> +       u32 subaddrlen;
> +       s32 ret;
> +
> +       struct i2c_algo_pch_data *adap = i2c_adap->algo_data;
> +
> +       ret = mutex_lock_interruptible(&pch_mutex);
> +       if (ret) {
> +               ret = -ERESTARTSYS;
> +               goto return_err_nomutex;
> +       }
> +       if (adap->p_adapter_info->pch_suspended == false) {

No.

if (adap->p_adapter_info->pch_suspended) {
   mutex_unlock(&pch_nomutex);
   return -EBUSY;
}

De-indent the rest and remove the else clause.

> +               dev_dbg(adap->pch_adapter.dev.parent,
> +                       "%s adap->p_adapter_info->pch_suspended is %d\n",
> +                       __func__, adap->p_adapter_info->pch_suspended);
> +               /* transfer not completed */
> +               adap->pch_xfer_in_progress = true;
> +
> +               ret = -EBUSY;
> +               for (i = 0; i < num; i++) {
> +                       pmsg = &msgs[i];
> +                       pmsg->flags |= adap->pch_buff_mode_en;
> +                       status = pmsg->flags;
> +                       dev_dbg(adap->pch_adapter.dev.parent,
> +                               "After invoking I2C_MODE_SEL :flag= 0x%x\n",
> +                               status);
> +                       /* calculate sub address length and message length */
> +                       /* these are applicable only for buffer mode */
> +                       subaddrlen = pmsg->buf[0];
> +                       /* calculate actual message length excluding
> +                        * the sub address fields */
> +                       msglen = (pmsg->len) - (subaddrlen + 1);
> +                       if (status & (I2C_M_RD)) {
> +                               dev_dbg(adap->pch_adapter.dev.parent,
> +                                       "%s invoking pch_readbytes\n",
> +                                       __func__);
> +                               ret = pch_readbytes(i2c_adap, pmsg,
> +                                                     (i + 1 == num),
> +                                                     (i == 0));
> +                       } else {
> +                               dev_dbg(adap->pch_adapter.dev.parent,
> +                                       "%s invoking pch_writebytes\n",
> +                                       __func__);
> +                               ret = pch_writebytes(i2c_adap, pmsg,
> +                                                      (i + 1 == num),
> +                                                      (i == 0));
> +                       }
> +
> +               }
> +
> +               adap->pch_xfer_in_progress = false;     /* transfer completed */
> +
> +               dev_dbg(adap->pch_adapter.dev.parent,
> +                                       "adap->pch_xfer_in_progress is %d\n",
> +                                       adap->pch_xfer_in_progress);
> +       } else {
> +               ret = -EBUSY;
> +       }
> +
> +       mutex_unlock(&pch_mutex);
> +return_err_nomutex:
> +       dev_dbg(adap->pch_adapter.dev.parent, "%s return:%d\n\n\n\n",
> +                                                               __func__, ret);
> +       return ret;
> +}

> (...)
> +static int __devinit pch_probe(struct pci_dev *pdev,
> +                              const struct pci_device_id *id)
> +{
> +       int i;
> +       void __iomem *base_addr;
> +       s32 ret;
> +       struct adapter_info *adap_info =
> +                       kzalloc((sizeof(struct adapter_info)), GFP_KERNEL);
> +
> +       dev_dbg(&pdev->dev, "Enterred in %s\n", __func__);
> +
> +       if (adap_info == NULL) {
> +               dev_err(&pdev->dev, "Memory allocation failed FAILED");
> +               ret = -ENOMEM;
> +               goto return_err;

Just
return -ENOMEM;

Goto construction unnecessary here.

> (...)
> +#ifdef CONFIG_PM
> +static int pch_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +       int i;
> +       int ret;
> +
> +       struct adapter_info *adap_info = pci_get_drvdata(pdev);
> +       void __iomem *p = adap_info->pch_data[0].pch_base_address;
> +
> +       adap_info->pch_suspended = true;
> +
> +       for (i = 0; i < PCH_MAX_CHN; i++) {
> +               while ((adap_info->pch_data[i].pch_xfer_in_progress)) {
> +                       /* It is assumed that any pending transfer will
> +                        * be completed after the delay
> +                        */
> +                       msleep(1);
> +               }

The comment seems to be a lie. It is not assumed that it will
be completed at all, because you're sleeping repeatedly until all
transfers are completed.

What you are doing is you are waiting for channel zero to
complete transfers, then channel 1 etc up to channel PCH_MAX_CHN.

> +               /* Disable the i2c interrupts */
> +               pch_disbl_int(&adap_info->pch_data[i]);
> +       }
> +
> +       dev_dbg(&pdev->dev,
> +               "I2CSR = %x I2CBUFSTA = %x I2CESRSTA = %x "
> +               "invoked function pch_disbl_int successfully\n",
> +               ioread32(p + 0x08),
> +               ioread32(p + 0x30),
> +               ioread32(p + 0x44));
> +
> +       ret = pci_save_state(pdev);
> +
> +       if (ret) {
> +               dev_err(&pdev->dev, "pci_save_state failed\n");
> +               return ret;
> +       }
> +
> +       pci_enable_wake(pdev, PCI_D3hot, 0);
> +       pci_disable_device(pdev);
> +       pci_set_power_state(pdev, pci_choose_state(pdev, state));
> +
> +       return 0;
> +}


Yours,
Linus Walleij
