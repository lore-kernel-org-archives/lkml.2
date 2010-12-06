Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab0LFEmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 23:42:18 -0500
Received: from dsl78-143-211-26.in-addr.fast.co.uk ([78.143.211.26]:33242 "EHLO
	ben-laptop" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752438Ab0LFEmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 23:42:17 -0500
Message-ID: <4CFC698D.2060703@fluff.org>
Date: Mon, 06 Dec 2010 04:41:49 +0000
From: Ben Dooks <ben-i2c@fluff.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, andrew.chih.howe.khor@intel.com,
        yong.y.wang@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH] EG20T: Update PCH_I2C driver to 2.6.36
References: <4CD8CD32.5000909@dsn.okisemi.com>
In-Reply-To: <4CD8CD32.5000909@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/10 04:25, Tomoya MORINAGA wrote:
> Hi Jean,
> 
> I have got Intel's signature.
> Please push it to kernel tree.

The description of the patch should go here, and I need a proper
subject line for the commit.

Comments like these go below the --- line.

> Thanks,
> Tomoya MORINAGA(OKI SEMICONDUCTOR CO., LTD.)
> ---
> I2C driver of EG20T PCH
> 
> EG20T PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> EG20T PCH are actually devices sitting on AMBA bus.
> EG20T PCH has I2C I/F. Using this I/F, it is able to access system
> devices connected to I2C.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> Reviewed-by: Linus Walleij <linus.walleij@stericsson.com>
> Signed-off-by: Qi Wang <qi.wang@intel.com>
> ---
>  drivers/i2c/busses/Kconfig     |    8 +
>  drivers/i2c/busses/Makefile    |    1 +
>  drivers/i2c/busses/i2c-eg20t.c |  900 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 909 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/i2c/busses/i2c-eg20t.c
> 

> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index c3ef492..e55e051 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -60,6 +60,7 @@ obj-$(CONFIG_I2C_STU300)	+= i2c-stu300.o
>  obj-$(CONFIG_I2C_VERSATILE)	+= i2c-versatile.o
>  obj-$(CONFIG_I2C_OCTEON)	+= i2c-octeon.o
>  obj-$(CONFIG_I2C_XILINX)	+= i2c-xiic.o
> +obj-$(CONFIG_I2C_EG20T)         += i2c-eg20t.o

Jean, do you want these alphabetically sorted?

>  # External I2C/SMBus adapter drivers
>  obj-$(CONFIG_I2C_PARPORT)	+= i2c-parport.o
> diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
> new file mode 100644
> index 0000000..f835635
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-eg20t.c
> @@ -0,0 +1,900 @@

[snip]

> +/**
> + * struct adapter_info - This structure holds the adapter information for the
> +			 PCH i2c controller
> + * @pch_data:		stores a list of i2c_algo_pch_data
> + * @pch_i2c_suspended:	specifies whether the system is suspended or not
> + *			perhaps with more lines and words.

you don't need the 'or not' and the extra line does not make sense?
> + *
> + * pch_data has as many elements as maximum I2C channels
> + */
> +struct adapter_info {
> +	struct i2c_algo_pch_data pch_data;
> +	bool pch_i2c_suspended;
> +};
> +
> +
> +static int pch_i2c_speed = 100; /* I2C bus speed in Kbps */
> +static int pch_clk = 50000;	/* specifies I2C clock speed in KHz */
> +static wait_queue_head_t pch_event;
> +static DEFINE_MUTEX(pch_mutex);
> +
> +static struct pci_device_id __devinitdata pch_pcidev_id[] = {
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_PCH_I2C)},
> +	{0,}

please put single space after the { and before the }.

> +static irqreturn_t pch_i2c_handler(int irq, void *pData);
> +
> +static inline void pch_setbit(void __iomem *addr, u32 offset, u32 bitmask)
> +{
> +	u32 val;
> +	val = ioread32(addr + offset);
> +	val |= bitmask;
> +	iowrite32(val, addr + offset);
> +}
> +
> +static inline void pch_clrbit(void __iomem *addr, u32 offset, u32 bitmask)
> +{
> +	u32 val;
> +	val = ioread32(addr + offset);
> +	val &= (~bitmask);

the () around bitmask is useless.

> +	iowrite32(val, addr + offset);
> +}


> +static inline bool ktime_lt(const ktime_t cmp1, const ktime_t cmp2)
> +{
> +	return cmp1.tv64 < cmp2.tv64;
> +}

hmm, surely this sort of thing should be in a header somewhere?


> +/**
> + * pch_i2c_getack() - to confirm ACK/NACK
> + * @adap:	Pointer to struct i2c_algo_pch_data.
> + */
> +static s32 pch_i2c_getack(struct i2c_algo_pch_data *adap)
> +{
> +	u32 reg_val;
> +	void __iomem *p = adap->pch_base_address;

would prefer a blank line here
also prefernece for longer items first in the list
neither of these is really important though.

> +	reg_val = ioread32(p + PCH_I2CSR) & PCH_GETACK;
> +
> +	if (reg_val != 0) {

would (reg_val & PCH_GETACK) do here?

> +		pch_err(adap, "return%d\n", -EPROTO);
> +		return -EPROTO;
> +	}
> +
> +	return 0;
> +}

> +
> +/**
> + * pch_i2c_writebytes() - write data to I2C bus in normal mode
> + * @i2c_adap:	Pointer to the struct i2c_adapter.
> + * @last:	specifies whether last message or not.
> + *		In the case of compound mode it will be 1 for last message,
> + *		otherwise 0.
> + * @first:	specifies whether first message or not.
> + *		1 for first message otherwise 0.
> + */
> +static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
> +			      struct i2c_msg *msgs, u32 last, u32 first)
> +{
> +	struct i2c_algo_pch_data *adap = i2c_adap->algo_data;
> +	u8 *buf;
> +	u32 length;
> +	u32 addr;
> +	u32 addr_2_msb;
> +	u32 addr_8_lsb;
> +	s32 wrcount;
> +	void __iomem *p = adap->pch_base_address;

> +	length = msgs->len;
> +	buf = msgs->buf;
> +	addr = msgs->addr;

minor, these could have been merged with the declaration.

> +	/* enable master tx */
> +	pch_setbit(adap->pch_base_address, PCH_I2CCTL, I2C_TX_MODE);
> +
> +	pch_dbg(adap, "I2CCTL = %x msgs->len = %d\n", ioread32(p + PCH_I2CCTL),
> +		length);
> +
> +	if (first) {
> +		if (pch_i2c_wait_for_bus_idle(adap, BUS_IDLE_TIMEOUT) == -ETIME)
> +			return -ETIME;
> +	}
> +
> +	if (msgs->flags & I2C_M_TEN) {
> +		addr_2_msb = ((addr & I2C_MSB_2B_MSK) >> 7);
> +		iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK, p + PCH_I2CDR);
> +		if (first)
> +			pch_i2c_start(adap);
> +		if (pch_i2c_wait_for_xfer_complete(adap) == 0 &&
> +		    pch_i2c_getack(adap) == 0) {
> +			addr_8_lsb = (addr & I2C_ADDR_MSK);
> +			iowrite32(addr_8_lsb, p + PCH_I2CDR);
> +		} else {
> +			pch_i2c_stop(adap);
> +			return -ETIME;

I'll have to check the error codes here, thought ETIMEDOUT would be
better, or -EBUSY.

> +		}
> +
> +	if ((pch_i2c_wait_for_xfer_complete(adap) == 0) &&
> +	    (pch_i2c_getack(adap) == 0)) {
> +		for (wrcount = 0; wrcount < length; ++wrcount) {
> +			/* write buffer value to I2C data register */
> +			iowrite32(buf[wrcount], p + PCH_I2CDR);
> +			pch_dbg(adap, "writing %x to Data register\n",
> +				buf[wrcount]);
> +
> +			if (pch_i2c_wait_for_xfer_complete(adap) != 0)
> +				return -ETIME;

see above.

> +			if (pch_i2c_getack(adap))
> +				return -EIO;
> +		}
> +
> +		/* check if this is the last message */
> +		if (last)
> +			pch_i2c_stop(adap);
> +		else
> +			pch_i2c_repstart(adap);
> +	} else {
> +		pch_i2c_stop(adap);
> +		return -EIO;
> +	}
> +
> +	pch_dbg(adap, "return=%d\n", wrcount);
> +
> +	return wrcount;
> +}

> +
> +/**
> + * pch_i2c_readbytes() - read data  from I2C bus in normal mode.
> + * @i2c_adap:	Pointer to the struct i2c_adapter.
> + * @msgs:	Pointer to i2c_msg structure.
> + * @last:	specifies whether last message or not.
> + * @first:	specifies whether first message or not.
> + */
> +s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
> +		  u32 last, u32 first)
> +{
> +	struct i2c_algo_pch_data *adap = i2c_adap->algo_data;
> +
> +	u8 *buf;
> +	u32 count;
> +	u32 length;
> +	u32 addr;
> +	u32 addr_2_msb;
> +	void __iomem *p = adap->pch_base_address;
> +
> +	length = msgs->len;
> +	buf = msgs->buf;
> +	addr = msgs->addr;
> +
> +	/* enable master reception */
> +	pch_clrbit(adap->pch_base_address, PCH_I2CCTL, I2C_TX_MODE);
> +
> +	if (first) {
> +		if (pch_i2c_wait_for_bus_idle(adap, BUS_IDLE_TIMEOUT) == -ETIME)
> +			return -ETIME;
> +	}
> +
> +	if (msgs->flags & I2C_M_TEN) {
> +		addr_2_msb = (((addr & I2C_MSB_2B_MSK) >> 7) | (I2C_RD));
> +		iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK, p + PCH_I2CDR);
> +
> +	} else {
> +		/* 7 address bits + R/W bit */
> +		addr = (((addr) << 1) | (I2C_RD));
> +		iowrite32(addr, p + PCH_I2CDR);
> +	}
> +
> +	/* check if it is the first message */
> +	if (first)
> +		pch_i2c_start(adap);
> +
> +	if ((pch_i2c_wait_for_xfer_complete(adap) == 0) &&
> +	    (pch_i2c_getack(adap) == 0)) {
> +		pch_dbg(adap, "return %d\n", 0);
> +
> +		if (length == 0) {
> +			pch_i2c_stop(adap);
> +			ioread32(p + PCH_I2CDR); /* Dummy read needs */
> +
> +			count = length;
> +		} else {
> +			int read_index;
> +			int loop;
> +			pch_i2c_sendack(adap);
> +
> +			/* Dummy read */
> +			for (loop = 1, read_index = 0; loop < length; loop++) {
> +				buf[read_index] = ioread32(p + PCH_I2CDR);
> +
> +				if (loop != 1)
> +					read_index++;
> +
> +				if (pch_i2c_wait_for_xfer_complete(adap) != 0) {
> +					pch_i2c_stop(adap);
> +					return -ETIME;

don't think this is the correct return code here either..

> +				}
> +			}	/* end for */
> +
> +			pch_i2c_sendnack(adap);
> +
> +			buf[read_index] = ioread32(p + PCH_I2CDR);
> +
> +			if (length != 1)
> +				read_index++;
> +
> +			if (pch_i2c_wait_for_xfer_complete(adap) == 0) {
> +				if (last)
> +					pch_i2c_stop(adap);
> +				else
> +					pch_i2c_repstart(adap);
> +
> +				buf[read_index++] = ioread32(p + PCH_I2CDR);
> +				count = read_index;
> +			} else {
> +				count = -ETIME;
> +			}
> +
> +		}
> +	} else {
> +		count = -ETIME;
> +		pch_i2c_stop(adap);
> +	}
> +
> +	return count;
> +}
> +

> +
> +/**
> + * pch_i2c_disbl_int() - Disable PCH I2C interrupts
> + * @adap:	Pointer to struct i2c_algo_pch_data.
> + */
> +static void pch_i2c_disbl_int(struct i2c_algo_pch_data *adap)
> +{
> +	void __iomem *p = adap->pch_base_address;
> +
> +	pch_clrbit(adap->pch_base_address, PCH_I2CCTL, NORMAL_INTR_ENBL);
> +
> +	iowrite32(EEPROM_RST_INTR_DISBL, p + PCH_I2CESRMSK);
> +

could avoid blank here.

> +	iowrite32(BUFFER_MODE_INTR_DISBL, p + PCH_I2CBUFMSK);
> +}
> +
> +static int __devinit pch_i2c_probe(struct pci_dev *pdev,
> +			       const struct pci_device_id *id)
> +{
> +	void __iomem *base_addr;
> +	s32 ret;
> +	struct adapter_info *adap_info;
> +
> +	pch_pci_dbg(pdev, "Entered.\n");
> +
> +	adap_info = kzalloc((sizeof(struct adapter_info)), GFP_KERNEL);

extra () in here

> +	if (adap_info == NULL) {
> +		pch_pci_err(pdev, "Memory allocation FAILED\n");
> +		return -ENOMEM;
> +	}

do not need to capitalise 'FAILED'

> +
> +	ret = pci_enable_device(pdev);
> +	if (ret) {
> +		pch_pci_err(pdev, "pci_enable_device FAILED\n");
> +		goto err_pci_enable;
> +	}

() after pci_device_enable... also see previous.

> +
> +	ret = pci_request_regions(pdev, KBUILD_MODNAME);

how about using dev_name() in case of multiple devices.

> +	if (ret) {
> +		pch_pci_err(pdev, "pci_request_regions FAILED\n");
> +		goto err_pci_req;
> +	}
> +
> +	base_addr = pci_iomap(pdev, 1, 0);
> +
> +	if (base_addr == NULL) {
> +		pch_pci_err(pdev, "pci_iomap FAILED\n");
> +		ret = -ENOMEM;
> +		goto err_pci_iomap;
> +	}
> +
> +	adap_info->pch_i2c_suspended = false;
> +
> +	adap_info->pch_data.p_adapter_info = adap_info;
> +
> +	adap_info->pch_data.pch_adapter.owner = THIS_MODULE;
> +	adap_info->pch_data.pch_adapter.class = I2C_CLASS_HWMON;
> +	strcpy(adap_info->pch_data.pch_adapter.name, KBUILD_MODNAME);

please use a string copy that limits transfer size....

> +	adap_info->pch_data.pch_adapter.algo = &pch_algorithm;
> +	adap_info->pch_data.pch_adapter.algo_data =
> +						&adap_info->pch_data;
> +
> +	/* (i * 0x80) + base_addr; */
> +	adap_info->pch_data.pch_base_address = base_addr;
> +
> +	adap_info->pch_data.pch_adapter.dev.parent = &pdev->dev;
> +
> +	ret = i2c_add_adapter(&(adap_info->pch_data.pch_adapter));
> +
> +	if (ret) {
> +		pch_pci_err(pdev, "i2c_add_adapter FAILED\n");
> +		goto err_i2c_add_adapter;
> +	}
> +
> +	pch_i2c_init(&adap_info->pch_data);
> +	ret = request_irq(pdev->irq, pch_i2c_handler, IRQF_SHARED,
> +		  KBUILD_MODNAME, &adap_info->pch_data);

see note on dev_name()

> +	if (ret) {
> +		pch_pci_err(pdev, "request_irq FAILED\n");
> +		goto err_request_irq;
> +	}
> +
> +	pci_set_drvdata(pdev, adap_info);
> +	pch_pci_dbg(pdev, "returns %d.\n", ret);
> +	return 0;
> +
> +err_request_irq:
> +	i2c_del_adapter(&(adap_info->pch_data.pch_adapter));
> +err_i2c_add_adapter:
> +	pci_iounmap(pdev, base_addr);
> +err_pci_iomap:
> +	pci_release_regions(pdev);
> +err_pci_req:
> +	pci_disable_device(pdev);
> +err_pci_enable:
> +	kfree(adap_info);
> +	return ret;
> +}
> +
> +static void __devexit pch_i2c_remove(struct pci_dev *pdev)
> +{
> +	struct adapter_info *adap_info = pci_get_drvdata(pdev);
> +
> +	pch_i2c_disbl_int(&adap_info->pch_data);
> +	free_irq(pdev->irq, &adap_info->pch_data);
> +	i2c_del_adapter(&(adap_info->pch_data.pch_adapter));
> +
> +	if (adap_info->pch_data.pch_base_address) {
> +		pci_iounmap(pdev, adap_info->pch_data.pch_base_address);
> +		adap_info->pch_data.pch_base_address = 0;

NULL, not 0

> +	}
> +
> +	pci_set_drvdata(pdev, NULL);
> +
> +	pci_release_regions(pdev);
> +
> +	pci_disable_device(pdev);
> +	kfree(adap_info);
> +}
> +
> +#ifdef CONFIG_PM
> +static int pch_i2c_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	int ret;
> +	struct adapter_info *adap_info = pci_get_drvdata(pdev);
> +	void __iomem *p = adap_info->pch_data.pch_base_address;
> +
> +	adap_info->pch_i2c_suspended = true;
> +
> +	while ((adap_info->pch_data.pch_i2c_xfer_in_progress)) {
> +		/* Wait until all channel transfers are completed */
> +		msleep(20);
> +	}
> +	/* Disable the i2c interrupts */
> +	pch_i2c_disbl_int(&adap_info->pch_data);
> +
> +	pch_pci_dbg(pdev, "I2CSR = %x I2CBUFSTA = %x I2CESRSTA = %x "
> +		"invoked function pch_i2c_disbl_int successfully\n",
> +		ioread32(p + PCH_I2CSR), ioread32(p + PCH_I2CBUFSTA),
> +		ioread32(p + PCH_I2CESRSTA));
> +
> +	ret = pci_save_state(pdev);
> +
> +	if (ret) {
> +		pch_pci_err(pdev, "pci_save_state\n");
> +		return ret;
> +	}
> +
> +	pci_enable_wake(pdev, PCI_D3hot, 0);
> +	pci_disable_device(pdev);
> +	pci_set_power_state(pdev, pci_choose_state(pdev, state));
> +
> +	return 0;
> +}
> +
> +static int pch_i2c_resume(struct pci_dev *pdev)
> +{
> +	struct adapter_info *adap_info = pci_get_drvdata(pdev);
> +
> +	pci_set_power_state(pdev, PCI_D0);
> +	pci_restore_state(pdev);
> +
> +	if (pci_enable_device(pdev) < 0) {
> +		pch_pci_err(pdev, "pch_i2c_resume:pci_enable_device FAILED\n");
> +		return -EIO;
> +	}
> +
> +	pci_enable_wake(pdev, PCI_D3hot, 0);
> +
> +	pch_i2c_init(&adap_info->pch_data);
> +
> +	adap_info->pch_i2c_suspended = false;
> +
> +	return 0;
> +}
> +#else
> +#define pch_i2c_suspend NULL
> +#define pch_i2c_resume NULL
> +#endif
> +
> +static struct pci_driver pch_pcidriver = {
> +	.name = KBUILD_MODNAME,
> +	.id_table = pch_pcidev_id,
> +	.probe = pch_i2c_probe,
> +	.remove = __devexit_p(pch_i2c_remove),
> +	.suspend = pch_i2c_suspend,
> +	.resume = pch_i2c_resume

runtime PM would be better.

> +
> +MODULE_DESCRIPTION("PCH I2C PCI Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Tomoya MORINAGA. <tomoya-linux@dsn.okisemi.com>");
> +module_param(pch_i2c_speed, int, (S_IRUSR | S_IWUSR));
> +module_param(pch_clk, int, (S_IRUSR | S_IWUSR));

Please sort out as much as possible of the review comments.

