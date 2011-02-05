Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab1BEQFw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 11:05:52 -0500
Received: from trinity.fluff.org ([89.16.178.74]:48518 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab1BEQFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 11:05:50 -0500
Date: Sat, 5 Feb 2011 16:05:40 +0000
From: Ben Dooks <ben-i2c@fluff.org>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Seth Heasley <seth.heasley@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH] i2c-eg20t: support new devie ML7213 IOH
Message-ID: <20110205160540.GB15795@trinity.fluff.org>
References: <1296693467-4465-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296693467-4465-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 09:37:47AM +0900, Tomoya MORINAGA wrote:
> Support ML7213 device of OKI SEMICONDUCTOR.
> ML7213 is companion chip of Intel Atom E6xx series for IVI(In-Vehicle Infotainment).
> ML7213 is completely compatible for Intel EG20T PCH.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/i2c/busses/Kconfig     |   17 +++--
>  drivers/i2c/busses/i2c-eg20t.c |  158 +++++++++++++++++++++++++---------------
>  2 files changed, 109 insertions(+), 66 deletions(-)
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 113505a..8086d49 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -639,12 +639,17 @@ config I2C_XILINX
>  	  will be called xilinx_i2c.
>  
>  config I2C_EG20T
> -        tristate "PCH I2C of Intel EG20T"
> -        depends on PCI
> -        help
> -          This driver is for PCH(Platform controller Hub) I2C of EG20T which
> -          is an IOH(Input/Output Hub) for x86 embedded processor.
> -          This driver can access PCH I2C bus device.
> +	tristate "Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH"
> +	depends on PCI
> +	help
> +	  This driver is for PCH(Platform controller Hub) I2C of EG20T which
> +	  is an IOH(Input/Output Hub) for x86 embedded processor.
> +	  This driver can access PCH I2C bus device.
> +
> +	  This driver also can be used for OKI SEMICONDUCTOR's ML7213 IOH which
> +	  is for IVI(In-Vehicle Infotainment) use.
> +	  ML7213 IOH is companion chip for Intel Atom E6xx series.
> +	  ML7213 IOH is completely compatible for Intel EG20T PCH.

You could have this asL:

    	  This driver also supports the ML7213, a companion chip for the
	  Atom E6xx series and compatible with the Intel EG20T PCH.
  
> +/*
> +Set the number of I2C instance max
> +Intel EG20T PCH :		1ch
> +OKI SEMICONDUCTOR ML7213 IOH :	2ch
> +*/
> +#define PCH_I2C_MAX_DEV			2
> +
>  /**
>   * struct i2c_algo_pch_data - for I2C driver functionalities
>   * @pch_adapter:		stores the reference to i2c_adapter structure
> @@ -156,12 +163,14 @@ struct i2c_algo_pch_data {
>   * @pch_data:		stores a list of i2c_algo_pch_data
>   * @pch_i2c_suspended:	specifies whether the system is suspended or not
>   *			perhaps with more lines and words.
> + * @ch_num:		specifies the number of i2c instance
>   *
>   * pch_data has as many elements as maximum I2C channels
>   */
>  struct adapter_info {
> -	struct i2c_algo_pch_data pch_data;
> +	struct i2c_algo_pch_data pch_data[PCH_I2C_MAX_DEV];
>  	bool pch_i2c_suspended;
> +	int ch_num;
>  };
>  
>  
> @@ -170,8 +179,13 @@ static int pch_clk = 50000;	/* specifies I2C clock speed in KHz */
>  static wait_queue_head_t pch_event;
>  static DEFINE_MUTEX(pch_mutex);
>  
> +/* Definition for ML7213 by OKI SEMICONDUCTOR */
> +#define PCI_VENDOR_ID_ROHM		0x10DB
> +#define PCI_DEVICE_ID_ML7213_I2C	0x802D
> +
>  static struct pci_device_id __devinitdata pch_pcidev_id[] = {
> -	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_PCH_I2C)},
> +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_PCH_I2C),   1, },
> +	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_I2C), 2, },

will let the reformatting slide on this occasion

> @@ -212,8 +226,7 @@ static void pch_i2c_init(struct i2c_algo_pch_data *adap)
>  	/* Initialize I2C registers */
>  	iowrite32(0x21, p + PCH_I2CNF);
>  
> -	pch_setbit(adap->pch_base_address, PCH_I2CCTL,
> -			  PCH_I2CCTL_I2CMEN);
> +	pch_setbit(adap->pch_base_address, PCH_I2CCTL, PCH_I2CCTL_I2CMEN);

Please don't format change, I would like to see this change reverted
unless there's a good reason for it.
  
>  	if (pch_i2c_speed != 400)
>  		pch_i2c_speed = 100;
> @@ -255,7 +268,7 @@ static inline bool ktime_lt(const ktime_t cmp1, const ktime_t cmp2)
>   * @timeout:	waiting time counter (us).
>   */
>  static s32 pch_i2c_wait_for_bus_idle(struct i2c_algo_pch_data *adap,
> -				 s32 timeout)
> +				     s32 timeout)
>  {
>  	void __iomem *p = adap->pch_base_address;

see above.
  
> @@ -475,8 +488,8 @@ static void pch_i2c_sendnack(struct i2c_algo_pch_data *adap)
>   * @last:	specifies whether last message or not.
>   * @first:	specifies whether first message or not.
>   */
> -s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
> -		  u32 last, u32 first)
> +static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
> +			     u32 last, u32 first)
>  {
>  	struct i2c_algo_pch_data *adap = i2c_adap->algo_data;


this looks like a format change again.
  
> @@ -569,10 +582,10 @@ s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
>  }
>  
>  /**
> - * pch_i2c_cb_ch0() - Interrupt handler Call back function
> + * pch_i2c_cb() - Interrupt handler Call back function
>   * @adap:	Pointer to struct i2c_algo_pch_data.
>   */
> -static void pch_i2c_cb_ch0(struct i2c_algo_pch_data *adap)
> +static void pch_i2c_cb(struct i2c_algo_pch_data *adap)
>  {
>  	u32 sts;
>  	void __iomem *p = adap->pch_base_address;
> @@ -600,24 +613,31 @@ static void pch_i2c_cb_ch0(struct i2c_algo_pch_data *adap)
>   */
>  static irqreturn_t pch_i2c_handler(int irq, void *pData)
>  {
> -	s32 reg_val;
> -
> -	struct i2c_algo_pch_data *adap_data = (struct i2c_algo_pch_data *)pData;
> -	void __iomem *p = adap_data->pch_base_address;
> -	u32 mode = ioread32(p + PCH_I2CMOD) & (BUFFER_MODE | EEPROM_SR_MODE);
> -
> -	if (mode != NORMAL_MODE) {
> -		pch_err(adap_data, "I2C mode is not supported\n");
> -		return IRQ_NONE;
> +	u32 reg_val;
> +	int flag;
> +	int i;
> +	struct adapter_info *adap_info = pData;
> +	void __iomem *p;
> +	u32 mode;
> +
> +	for (i = 0, flag = 0; i < adap_info->ch_num; i++) {
> +		p = adap_info->pch_data[i].pch_base_address;
> +		mode = ioread32(p + PCH_I2CMOD) &
> +						(BUFFER_MODE | EEPROM_SR_MODE);

could we split into mode = , then a new line with "mode &= " on please
as it doesn't really flow.

> +		if (mode != NORMAL_MODE) {
> +			pch_err(adap_info->pch_data,
> +				"I2C-%d mode(%d) is not supported\n", mode, i);
> +			continue;
> +		}
> +		reg_val = ioread32(p + PCH_I2CSR);
> +		if (reg_val & (I2CMAL_BIT | I2CMCF_BIT | I2CMIF_BIT)) {
> +			pch_i2c_cb(&adap_info->pch_data[i]);
> +			flag = 1;
> +		}
>  	}
>  
> -	reg_val = ioread32(p + PCH_I2CSR);
> -	if (reg_val & (I2CMAL_BIT | I2CMCF_BIT | I2CMIF_BIT))
> -		pch_i2c_cb_ch0(adap_data);
> -	else
> -		return IRQ_NONE;
> -
> -	return IRQ_HANDLED;
> +	return flag ? IRQ_HANDLED : IRQ_NONE;
>  }
>  
>  /**
> @@ -627,7 +647,7 @@ static irqreturn_t pch_i2c_handler(int irq, void *pData)
>   * @num:	number of messages.
>   */
>  static s32 pch_i2c_xfer(struct i2c_adapter *i2c_adap,
> -		    struct i2c_msg *msgs, s32 num)
> +			struct i2c_msg *msgs, s32 num)
>  {

formatting again.

  	struct i2c_msg *pmsg;
>  	u32 i = 0;
> @@ -710,10 +730,11 @@ static void pch_i2c_disbl_int(struct i2c_algo_pch_data *adap)
>  }
>  
>  static int __devinit pch_i2c_probe(struct pci_dev *pdev,
> -			       const struct pci_device_id *id)
> +				   const struct pci_device_id *id)
>  {
>  	void __iomem *base_addr;
> -	s32 ret;
> +	int ret;
> +	int i, j;
>  	struct adapter_info *adap_info;
>  
>  	pch_pci_dbg(pdev, "Entered.\n");
> @@ -744,32 +765,36 @@ static int __devinit pch_i2c_probe(struct pci_dev *pdev,
>  		goto err_pci_iomap;
>  	}
>  
> -	adap_info->pch_i2c_suspended = false;
> +	/* Set the number of I2C channel instance */
> +	adap_info->ch_num = id->driver_data;
>  
> -	adap_info->pch_data.p_adapter_info = adap_info;
> +	for (i = 0; i < adap_info->ch_num; i++) {
> +		adap_info->pch_i2c_suspended = false;
>  
> -	adap_info->pch_data.pch_adapter.owner = THIS_MODULE;
> -	adap_info->pch_data.pch_adapter.class = I2C_CLASS_HWMON;
> -	strcpy(adap_info->pch_data.pch_adapter.name, KBUILD_MODNAME);
> -	adap_info->pch_data.pch_adapter.algo = &pch_algorithm;
> -	adap_info->pch_data.pch_adapter.algo_data =
> -						&adap_info->pch_data;
> +		adap_info->pch_data[i].p_adapter_info = adap_info;
>  
> -	/* (i * 0x80) + base_addr; */
> -	adap_info->pch_data.pch_base_address = base_addr;
> +		adap_info->pch_data[i].pch_adapter.owner = THIS_MODULE;
> +		adap_info->pch_data[i].pch_adapter.class = I2C_CLASS_HWMON;
> +		strcpy(adap_info->pch_data[i].pch_adapter.name, KBUILD_MODNAME);
> +		adap_info->pch_data[i].pch_adapter.algo = &pch_algorithm;
> +		adap_info->pch_data[i].pch_adapter.algo_data =
> +							&adap_info->pch_data[i];

how about having a pointer to " adap_info->pch_data[i].pch_adapter" to
make the code lines shorte?

>  
> -	adap_info->pch_data.pch_adapter.dev.parent = &pdev->dev;
> +		/* base_addr + offset; */
> +		adap_info->pch_data[i].pch_base_address = base_addr + 0x100 * i;
>  
> -	ret = i2c_add_adapter(&(adap_info->pch_data.pch_adapter));
> +		adap_info->pch_data[i].pch_adapter.dev.parent = &pdev->dev;
>  
> -	if (ret) {
> -		pch_pci_err(pdev, "i2c_add_adapter FAILED\n");
> -		goto err_i2c_add_adapter;
> -	}
> +		ret = i2c_add_adapter(&(adap_info->pch_data[i].pch_adapter));


shouldn't need an () around the and?

> +		if (ret) {
> +			pch_pci_err(pdev, "i2c_add_adapter FAILED\n");
> +			goto err_i2c_add_adapter;
> +		}

would be useful to print the number of the adapter that failed.

> -	pch_i2c_init(&adap_info->pch_data);
> +		pch_i2c_init(&adap_info->pch_data[i]);
> +	}
>  	ret = request_irq(pdev->irq, pch_i2c_handler, IRQF_SHARED,
> -		  KBUILD_MODNAME, &adap_info->pch_data);
> +		  KBUILD_MODNAME, adap_info);
>  	if (ret) {
>  		pch_pci_err(pdev, "request_irq FAILED\n");
>  		goto err_request_irq;
> @@ -780,7 +805,8 @@ static int __devinit pch_i2c_probe(struct pci_dev *pdev,
>  	return 0;
>  
>  err_request_irq:
> -	i2c_del_adapter(&(adap_info->pch_data.pch_adapter));
> +	for (j = 0; j < i; j++)
> +		i2c_del_adapter(&(adap_info->pch_data[j].pch_adapter));

see the above comments.

>  err_i2c_add_adapter:
>  	pci_iounmap(pdev, base_addr);
>  err_pci_iomap:
> @@ -794,17 +820,22 @@ err_pci_enable:
>  
>  static void __devexit pch_i2c_remove(struct pci_dev *pdev)
>  {
> +	int i;
>  	struct adapter_info *adap_info = pci_get_drvdata(pdev);
>  
> -	pch_i2c_disbl_int(&adap_info->pch_data);
> -	free_irq(pdev->irq, &adap_info->pch_data);
> -	i2c_del_adapter(&(adap_info->pch_data.pch_adapter));
> +	free_irq(pdev->irq, adap_info);
>  
> -	if (adap_info->pch_data.pch_base_address) {
> -		pci_iounmap(pdev, adap_info->pch_data.pch_base_address);
> -		adap_info->pch_data.pch_base_address = 0;
> +	for (i = 0; i < adap_info->ch_num; i++) {
> +		pch_i2c_disbl_int(&adap_info->pch_data[i]);
> +		i2c_del_adapter(&(adap_info->pch_data[i].pch_adapter));
>  	}
>  
> +	if (adap_info->pch_data[0].pch_base_address)
> +		pci_iounmap(pdev, adap_info->pch_data[0].pch_base_address);
> +
> +	for (i = 0; i < adap_info->ch_num; i++)
> +		adap_info->pch_data[i].pch_base_address = 0;
> +
>  	pci_set_drvdata(pdev, NULL);
>  
>  	pci_release_regions(pdev);
> @@ -817,17 +848,22 @@ static void __devexit pch_i2c_remove(struct pci_dev *pdev)
>  static int pch_i2c_suspend(struct pci_dev *pdev, pm_message_t state)
>  {
>  	int ret;
> +	int i;
>  	struct adapter_info *adap_info = pci_get_drvdata(pdev);
> -	void __iomem *p = adap_info->pch_data.pch_base_address;
> +	void __iomem *p = adap_info->pch_data[0].pch_base_address;
>  
>  	adap_info->pch_i2c_suspended = true;
>  
> -	while ((adap_info->pch_data.pch_i2c_xfer_in_progress)) {
> -		/* Wait until all channel transfers are completed */
> -		msleep(20);
> +	for (i = 0; i < adap_info->ch_num; i++) {
> +		while ((adap_info->pch_data[i].pch_i2c_xfer_in_progress)) {
> +			/* Wait until all channel transfers are completed */
> +			msleep(20);
> +		}
>  	}
> +
>  	/* Disable the i2c interrupts */
> -	pch_i2c_disbl_int(&adap_info->pch_data);
> +	for (i = 0; i < adap_info->ch_num; i++)
> +		pch_i2c_disbl_int(&adap_info->pch_data[i]);
>  
>  	pch_pci_dbg(pdev, "I2CSR = %x I2CBUFSTA = %x I2CESRSTA = %x "
>  		"invoked function pch_i2c_disbl_int successfully\n",
> @@ -850,6 +886,7 @@ static int pch_i2c_suspend(struct pci_dev *pdev, pm_message_t state)
>  
>  static int pch_i2c_resume(struct pci_dev *pdev)
>  {
> +	int i;
>  	struct adapter_info *adap_info = pci_get_drvdata(pdev);
>  
>  	pci_set_power_state(pdev, PCI_D0);
> @@ -862,7 +899,8 @@ static int pch_i2c_resume(struct pci_dev *pdev)
>  
>  	pci_enable_wake(pdev, PCI_D3hot, 0);
>  
> -	pch_i2c_init(&adap_info->pch_data);
> +	for (i = 0; i < adap_info->ch_num; i++)
> +		pch_i2c_init(&adap_info->pch_data[i]);
>  
>  	adap_info->pch_i2c_suspended = false;
>  
> @@ -894,7 +932,7 @@ static void __exit pch_pci_exit(void)
>  }
>  module_exit(pch_pci_exit);
>  
> -MODULE_DESCRIPTION("PCH I2C PCI Driver");
> +MODULE_DESCRIPTION("Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH I2C Driver");
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Tomoya MORINAGA. <tomoya-linux@dsn.okisemi.com>");
>  module_param(pch_i2c_speed, int, (S_IRUSR | S_IWUSR));

Please fix the comments.

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

