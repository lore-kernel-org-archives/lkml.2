Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab2JFJFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 05:05:53 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:45429 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab2JFJFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 05:05:50 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q9695Agr000656, This message is released by code: ctaloc0852
Message-ID: <506FF446.2010300@realsil.com.cn>
Date: Sat, 6 Oct 2012 17:05:10 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "cjb@laptop.org" <cjb@laptop.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "oakad@yahoo.com" <oakad@yahoo.com>,
        "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v6 1/3] drivers/mfd: Add realtek pcie card reader driver
References: <cover.1347330871.git.wei_wang@realsil.com.cn> <b3b7a3d03d9591c1f393f4c4f488efbd15756c7c.1347330871.git.wei_wang@realsil.com.cn> <20120930224933.GB12231@sortiz-mobl>
In-Reply-To: <20120930224933.GB12231@sortiz-mobl>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年10月01日 06:49, Samuel Ortiz 写道:
> Hi Wei,
>
> On Tue, Sep 11, 2012 at 12:54:22PM +0800, wei_wang@realsil.com.cn wrote:
> Although  pretty big, the patch looks mostly good to me.
> I only have a few comments:
>
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index d1facef..4c07a34 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -63,6 +63,15 @@ config MFD_SM501_GPIO
>>  	 lines on the SM501. The platform data is used to supply the
>>  	 base number for the first GPIO line to register.
>>  
>> +config MFD_RTSX_PCI
>> +	tristate "Support for Realtek PCI-E driver-based card reader"
>> +	depends on PCI
>> +	help
>> +	  This supports for Realtek PCI-Express driver-based card reader including
>> +	  rts5209, rts5229, etc. Realtek driver-based card reader supports access
> driver-based ?

Sorry, this is our internal naming convention. We have two groups of
card reader, one group has embedded MCU and uses in-box driver, the
other hasn't MCU and uses vendor driver. So we call the first group as
"MCU-based reader", and the second group as "driver-based reader". This
naming convention may confuse others, I will modify the description.
>
>> +
>> +static u8 rts5209_get_ic_version(struct rtsx_pcr *pcr)
>> +{
>> +	u8 val;
>> +
>> +	val = rtsx_pci_readb(pcr, 0x1C);
>> +	return val & 0x0F;
> For your IO accesses, it would e worth looking at the regmap MMIO routines. It
> would also simplify your main probe routine.

regmap MMIO is great. But I haven't used it before, and it seems that we
haven't enough time to test it in this short merge window. I will take
your advice and use these routines in the near future.
>
>> +static int rts5209_turn_on_led(struct rtsx_pcr *pcr)
>> +{
>> +	return rtsx_pci_write_register(pcr, 0xFD58, 0x01, 0x00);
> You have many hardcoded register adresses around this code. Defining them in
> your header file wouldn't hurt.

I will modify it soon.

>
>> +static struct platform_device *rtsx_pci_create_subdev(struct rtsx_pcr *pcr,
>> +		const char *name, int slot_id)
>> +{
>> +	struct platform_device *p_dev;
>> +	int err;
>> +
>> +	p_dev = platform_device_alloc(name, pcr->id);
>> +	if (p_dev == NULL) {
>> +		dev_dbg(&(pcr->pci->dev), "alloc platform device fail!\n");
>> +		return NULL;
>> +	}
>> +
>> +	p_dev->dev.parent = &(pcr->pci->dev);
>> +	platform_set_drvdata(p_dev, pcr);
>> +	pcr->slots[slot_id].p_dev = p_dev;
>> +
>> +	err = platform_device_add(p_dev);
>> +	if (err) {
>> +		dev_dbg(&(pcr->pci->dev), "add platform device fail!\n");
>> +		pcr->slots[slot_id].p_dev = NULL;
>> +		platform_device_put(p_dev);
>> +		return NULL;
>> +	}
>> +
>> +	return p_dev;
>> +}
> Please use the MFD device addition API for that.
>

You suggest using mfd_cell ? I have considered it, but it seems not very
flexible in my situation. I will create two sub devices in the driver,
one for SD/MMC card, the other for Memstick. I need to create the sub
device when the card inserted, and destroy it when the card removed. The
timing to create and destroy is totally up to the user.
But mfd_cell will create and destroy all of the sub devices at the same
time, using API mfd_add_devices and mfd_remove_devices, which can not
meet my desire.

>> +static irqreturn_t rtsx_pci_isr(int irq, void *dev_id)
>> +{
>> +	struct rtsx_pcr *pcr = dev_id;
>> +	u32 int_reg;
>> +
>> +	if (!pcr)
>> +		return IRQ_NONE;
>> +
>> +	spin_lock(&pcr->lock);
>> +
>> +	int_reg = rtsx_pci_readl(pcr, RTSX_BIPR);
>> +	/* Clear interrupt flag */
>> +	rtsx_pci_writel(pcr, RTSX_BIPR, int_reg);
>> +	if ((int_reg & pcr->bier) == 0) {
>> +		spin_unlock(&pcr->lock);
>> +		return IRQ_NONE;
>> +	}
>> +	if (int_reg == 0xFFFFFFFF) {
>> +		spin_unlock(&pcr->lock);
>> +		return IRQ_HANDLED;
>> +	}
>> +
>> +	int_reg &= (pcr->bier | 0x7FFFFF);
>> +
>> +	if (int_reg & SD_INT) {
>> +		if (int_reg & SD_EXIST) {
>> +			pcr->need_reset |= SD_EXIST;
>> +		} else {
>> +			pcr->need_release |= SD_EXIST;
>> +			pcr->need_reset &= ~SD_EXIST;
>> +		}
>> +	}
>> +
>> +	if (int_reg & MS_INT) {
>> +		if (int_reg & MS_EXIST) {
>> +			pcr->need_reset |= MS_EXIST;
>> +		} else {
>> +			pcr->need_release |= MS_EXIST;
>> +			pcr->need_reset &= ~MS_EXIST;
>> +		}
>> +	}
>> +
>> +	if (pcr->need_reset || pcr->need_release)
>> +		queue_delayed_work(workqueue, &pcr->carddet_work,
>> +				msecs_to_jiffies(200));
> Why do we need a delayed work here ?

We need a period of time to debounce the CD glitch, so I use a delayed
work here. After 200 milliseconds, I will check the CD signal again to
make sure this is a valid signal.

>
>> +static void rtsx_pci_enter_idle(unsigned long __data)
>> +{
>> +	struct rtsx_pcr *pcr = (struct rtsx_pcr *)__data;
>> +
>> +	queue_work(workqueue, &pcr->idle_work);
>> +}
> OT: We need threaded timers...
>

Sorry, I can't understand this...

>> +static int __init rtsx_pci_drv_init(void)
>> +{
>> +	workqueue = create_freezable_workqueue("rtsx_pci_wq");
>> +	if (!workqueue)
>> +		return -ENOMEM;
> Are you sure you really need to create your won workqueue ? My guess is that
> you probably don't.
I will modify it and make a full test.

BR,
Wei WANG
