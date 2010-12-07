Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0LGBjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 20:39:03 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:7594 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753617Ab0LGBjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 20:39:01 -0500
Message-ID: <0FC7BC8EFF7C487196CEC65E2D62DE44@hacdom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Ben Dooks" <ben-i2c@fluff.org>
Cc: "Jean Delvare \(PC drivers, core\)" <khali@linux-fr.org>,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Linus Walleij" <linus.walleij@stericsson.com>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "srinidhi kasagar" <srinidhi.kasagar@stericsson.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <qi.wang@intel.com>, <andrew.chih.howe.khor@intel.com>,
        <yong.y.wang@intel.com>, <kok.howg.ewe@intel.com>
References: <4CD8CD32.5000909@dsn.okisemi.com> <4CFC6622.1050006@fluff.org>
Subject: Re: [PATCH] EG20T: Update PCH_I2C driver to 2.6.36
Date: Tue, 7 Dec 2010 10:38:55 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 06, 2010 1:27 PM, Ben Dooks wrote:

>> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
>> index c3ef492..e55e051 100644
>> --- a/drivers/i2c/busses/Makefile
>> +++ b/drivers/i2c/busses/Makefile
>> @@ -60,6 +60,7 @@ obj-$(CONFIG_I2C_STU300) += i2c-stu300.o
>>  obj-$(CONFIG_I2C_VERSATILE) += i2c-versatile.o
>>  obj-$(CONFIG_I2C_OCTEON) += i2c-octeon.o
>>  obj-$(CONFIG_I2C_XILINX) += i2c-xiic.o
>> +obj-$(CONFIG_I2C_EG20T)         += i2c-eg20t.o
>
> Jean, do you want these alphabetically sorted?

I will modify.

>> + * struct adapter_info - This structure holds the adapter information 
>> for the
>> + PCH i2c controller
>> + * @pch_data: stores a list of i2c_algo_pch_data
>> + * @pch_i2c_suspended: specifies whether the system is suspended or not
>> + * perhaps with more lines and words.
>
> you don't need the 'or not' and the extra line does not make sense?

I will delete "or not" description.

>> +static int pch_i2c_speed = 100; /* I2C bus speed in Kbps */
>> +static int pch_clk = 50000; /* specifies I2C clock speed in KHz */
>> +static wait_queue_head_t pch_event;
>> +static DEFINE_MUTEX(pch_mutex);
>> +
>> +static struct pci_device_id __devinitdata pch_pcidev_id[] = {
>> + {PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_PCH_I2C)},
>> + {0,}
>
> please put single space after the { and before the }.

I will put single space.

>> +static inline void pch_clrbit(void __iomem *addr, u32 offset, u32 
>> bitmask)
>> +{
>> + u32 val;
>> + val = ioread32(addr + offset);
>> + val &= (~bitmask);
>
> the () around bitmask is useless.

I will delete.

>
>> +static inline bool ktime_lt(const ktime_t cmp1, const ktime_t cmp2)
>> +{
>> + return cmp1.tv64 < cmp2.tv64;
>> +}
>
> hmm, surely this sort of thing should be in a header somewhere?

I will move this function to head of file.

>> +static s32 pch_i2c_getack(struct i2c_algo_pch_data *adap)
>> +{
>> + u32 reg_val;
>> + void __iomem *p = adap->pch_base_address;
>
> would prefer a blank line here
> also prefernece for longer items first in the list
> neither of these is really important though.

I will add blank line.

>
>> + reg_val = ioread32(p + PCH_I2CSR) & PCH_GETACK;
>> +
>> + if (reg_val != 0) {
>
> would (reg_val & PCH_GETACK) do here?

I will do so.

>> +static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
>> +       struct i2c_msg *msgs, u32 last, u32 first)
>> +{
>> + struct i2c_algo_pch_data *adap = i2c_adap->algo_data;
>> + u8 *buf;
>> + u32 length;
>> + u32 addr;
>> + u32 addr_2_msb;
>> + u32 addr_8_lsb;
>> + s32 wrcount;
>> + void __iomem *p = adap->pch_base_address;
>
>> + length = msgs->len;
>> + buf = msgs->buf;
>> + addr = msgs->addr;
>
> minor, these could have been merged with the declaration.

I will merge.

>> + if (pch_i2c_wait_for_xfer_complete(adap) == 0 &&
>> +     pch_i2c_getack(adap) == 0) {
>> + addr_8_lsb = (addr & I2C_ADDR_MSK);
>> + iowrite32(addr_8_lsb, p + PCH_I2CDR);
>> + } else {
>> + pch_i2c_stop(adap);
>> + return -ETIME;
>
> I'll have to check the error codes here, thought ETIMEDOUT would be
> better, or -EBUSY.

I will replace to ETIMEDOUT.

>
>> + }
>> +
>> + if ((pch_i2c_wait_for_xfer_complete(adap) == 0) &&
>> +     (pch_i2c_getack(adap) == 0)) {
>> + for (wrcount = 0; wrcount < length; ++wrcount) {
>> + /* write buffer value to I2C data register */
>> + iowrite32(buf[wrcount], p + PCH_I2CDR);
>> + pch_dbg(adap, "writing %x to Data register\n",
>> + buf[wrcount]);
>> +
>> + if (pch_i2c_wait_for_xfer_complete(adap) != 0)
>> + return -ETIME;
>
> see above.

I will replace to ETIMEDOUT.

>> + /* Dummy read */
>> + for (loop = 1, read_index = 0; loop < length; loop++) {
>> + buf[read_index] = ioread32(p + PCH_I2CDR);
>> +
>> + if (loop != 1)
>> + read_index++;
>> +
>> + if (pch_i2c_wait_for_xfer_complete(adap) != 0) {
>> + pch_i2c_stop(adap);
>> + return -ETIME;
>
> don't think this is the correct return code here either..

I will replace to ETIMEDOUT.

>> +static void pch_i2c_disbl_int(struct i2c_algo_pch_data *adap)
>> +{
>> + void __iomem *p = adap->pch_base_address;
>> +
>> + pch_clrbit(adap->pch_base_address, PCH_I2CCTL, NORMAL_INTR_ENBL);
>> +
>> + iowrite32(EEPROM_RST_INTR_DISBL, p + PCH_I2CESRMSK);
>> +
>
> could avoid blank here.

I will delete the blank.

>
>> + iowrite32(BUFFER_MODE_INTR_DISBL, p + PCH_I2CBUFMSK);
>> +}
>> +
>> +static int __devinit pch_i2c_probe(struct pci_dev *pdev,
>> +        const struct pci_device_id *id)
>> +{
>> + void __iomem *base_addr;
>> + s32 ret;
>> + struct adapter_info *adap_info;
>> +
>> + pch_pci_dbg(pdev, "Entered.\n");
>> +
>> + adap_info = kzalloc((sizeof(struct adapter_info)), GFP_KERNEL);
>
> extra () in here

I will delete.

>
>> + if (adap_info == NULL) {
>> + pch_pci_err(pdev, "Memory allocation FAILED\n");
>> + return -ENOMEM;
>> + }
>
> do not need to capitalise 'FAILED'

I will replace "FAILED" to "failed"

>
>> +
>> + ret = pci_enable_device(pdev);
>> + if (ret) {
>> + pch_pci_err(pdev, "pci_enable_device FAILED\n");
>> + goto err_pci_enable;
>> + }
>
> () after pci_device_enable... also see previous.

Sorry, I couldn't understand your saying.
Let me know more in detail.


>
>> +
>> + ret = pci_request_regions(pdev, KBUILD_MODNAME);
>
> how about using dev_name() in case of multiple devices.

I will use dev_name instead of KBUILD_MODNAME.
BTW, this is my interested question,
why do you recommend use dev_name instead of KBUILD_MODNAME ?

>> +
>> + adap_info->pch_i2c_suspended = false;
>> +
>> + adap_info->pch_data.p_adapter_info = adap_info;
>> +
>> + adap_info->pch_data.pch_adapter.owner = THIS_MODULE;
>> + adap_info->pch_data.pch_adapter.class = I2C_CLASS_HWMON;
>> + strcpy(adap_info->pch_data.pch_adapter.name, KBUILD_MODNAME);
>
> please use a string copy that limits transfer size....

Do you mean we should use strncpy instead of strcpy ?

>> + ret = i2c_add_adapter(&(adap_info->pch_data.pch_adapter));
>> +
>> + if (ret) {
>> + pch_pci_err(pdev, "i2c_add_adapter FAILED\n");
>> + goto err_i2c_add_adapter;
>> + }
>> +
>> + pch_i2c_init(&adap_info->pch_data);
>> + ret = request_irq(pdev->irq, pch_i2c_handler, IRQF_SHARED,
>> +   KBUILD_MODNAME, &adap_info->pch_data);
>
> see note on dev_name()

I will replace to dev_name.

>> +static void __devexit pch_i2c_remove(struct pci_dev *pdev)
>> +{
>> + struct adapter_info *adap_info = pci_get_drvdata(pdev);
>> +
>> + pch_i2c_disbl_int(&adap_info->pch_data);
>> + free_irq(pdev->irq, &adap_info->pch_data);
>> + i2c_del_adapter(&(adap_info->pch_data.pch_adapter));
>> +
>> + if (adap_info->pch_data.pch_base_address) {
>> + pci_iounmap(pdev, adap_info->pch_data.pch_base_address);
>> + adap_info->pch_data.pch_base_address = 0;
>
> NULL, not 0

I will replace to "NULL".

>> +static struct pci_driver pch_pcidriver = {
>> + .name = KBUILD_MODNAME,
>> + .id_table = pch_pcidev_id,
>> + .probe = pch_i2c_probe,
>> + .remove = __devexit_p(pch_i2c_remove),
>> + .suspend = pch_i2c_suspend,
>> + .resume = pch_i2c_resume
>
> runtime PM would be better.

Sorry, I couldn't understand your saying.
Let me know more in detail.

Thanks,
/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_
Tomoya Morinaga
OKI SEMICONDUCTOR CO., LTD. 

