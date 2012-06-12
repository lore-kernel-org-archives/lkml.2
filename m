Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab2FLMsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:48:06 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:21613 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab2FLMsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:48:04 -0400
Date: Tue, 12 Jun 2012 14:47:46 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Armenia <andrew@asquaredlabs.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] i2c-piix4: support aux SMBus on AMD chipsets
Message-ID: <20120612144746.0419baeb@endymion.delvare>
In-Reply-To: <1338860964-10803-4-git-send-email-andrew@asquaredlabs.com>
References: <20120604091643.208956fe@endymion.delvare>
	<1338860964-10803-1-git-send-email-andrew@asquaredlabs.com>
	<1338860964-10803-4-git-send-email-andrew@asquaredlabs.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 Jun 2012 21:49:24 -0400, Andrew Armenia wrote:
> Some AMD chipsets, such as the SP5100, have an auxiliary SMBus with a second
> set of registers. This patch adds support for the SP5100 and should work on
> similar chipsets. Tested on ASUS KCMA-D8 motherboard.

The SP5100 isn't even documented as being supported. Can you please add
it to Documentation/i2c/busses/i2c-piix4, drivers/i2c/busses/Kconfig,
and the header comment? Or is it a different code name for an already
supported south bridge? I admit I stopped following AMD chipsets some
times ago.

> 
> Signed-off-by: Andrew Armenia <andrew@asquaredlabs.com>
> ---
>  drivers/i2c/busses/i2c-piix4.c |   83 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 76 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
> index 8a87b3f..972b604 100644
> --- a/drivers/i2c/busses/i2c-piix4.c
> +++ b/drivers/i2c/busses/i2c-piix4.c
> @@ -25,7 +25,8 @@
>  	AMD Hudson-2
>  	SMSC Victory66
>  
> -   Note: we assume there can only be one device, with one SMBus interface.
> +   Note: we assume there can only be one device, with one or two SMBus
> +   interfaces.
>  */
>  
>  #include <linux/module.h>
> @@ -66,6 +67,7 @@
>  #define SMBSHDW1	0x0D4
>  #define SMBSHDW2	0x0D5
>  #define SMBREV		0x0D6
> +#define SMBAUXBA	0x058

Keeping the list sorted by register offset would seem reasonable.

>  
>  /* Other settings */
>  #define MAX_TIMEOUT	500
> @@ -130,6 +132,8 @@ struct i2c_piix4_adapdata {
>  	unsigned short smba;
>  };
>  
> +static void piix4_adap_remove(struct i2c_adapter *adap);
> +

Please just reorder the functions (ideally at the time you introduce
them) so that you don't need this forward declaration.

>  static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
>  				const struct pci_device_id *id,
>  				unsigned short *smba)
> @@ -300,6 +304,45 @@ static int __devinit piix4_setup_sb800(struct pci_dev *PIIX4_dev,
>  	return 0;
>  }
>  
> +static int __devinit piix4_setup_aux(struct pci_dev *PIIX4_dev,
> +				const struct pci_device_id *id,
> +				unsigned short base_reg_addr,
> +				unsigned short *smba)
> +{
> +	/* Set up auxiliary SMBus controllers found on some AMD
> +	 * chipsets e.g. SP5100 */
> +	unsigned short piix4_smba;
> +
> +	/* Read address of auxiliary SMBus controller */
> +	pci_read_config_word(PIIX4_dev, base_reg_addr, &piix4_smba);
> +	piix4_smba &= 0xffe0;
> +
> +	if (piix4_smba == 0) {
> +		dev_err(&PIIX4_dev->dev, "Aux SMBus base address "
> +			"uninitialized - upgrade BIOS\n");

This case could be OK if the board vendor simply did not need a second
SMBus channel. So we shouldn't spit an error message in this case,
maybe a debug message if you want but that's about it.

> +		return -ENODEV;
> +	}
> +
> +	if (acpi_check_region(piix4_smba, SMBIOSIZE, piix4_driver.name))
> +		return -ENODEV;
> +
> +	if (!request_region(piix4_smba, SMBIOSIZE, piix4_driver.name)) {
> +		dev_err(&PIIX4_dev->dev, "Aux SMBus region 0x%x already"
> +			" in use!\n", piix4_smba);

White space at end of first half please, for consistency.

> +		return -EBUSY;
> +	}
> +
> +	dev_info(&PIIX4_dev->dev,
> +		"Auxiliary SMBus Host Controller at 0x%x\n",

You should probably write "Auxiliary" in the previous message messages
too, for consistency and readability.

> +		piix4_smba
> +	);
> +
> +	*smba = piix4_smba;
> +
> +	return 0;
> +}
> +
> +
>  static int piix4_transaction(unsigned short piix4_smba)
>  {
>  	int temp;
> @@ -505,6 +548,7 @@ static DEFINE_PCI_DEVICE_TABLE(piix4_ids) = {
>  MODULE_DEVICE_TABLE (pci, piix4_ids);
>  
>  static struct i2c_adapter *piix4_main_adapter;
> +static struct i2c_adapter *piix4_aux_adapter;
>  
>  /* register piix4 I2C adapter at the given base address */
>  static int piix4_add_adapter(struct pci_dev *dev, unsigned short smba,
> @@ -562,9 +606,33 @@ static int __devinit piix4_probe(struct pci_dev *dev,
>  		retval = piix4_setup(dev, id, &smba);
>  
>  	if (retval)
> -		return retval;
> +		goto error;
> +
> +	retval = piix4_add_adapter(dev, smba, &piix4_main_adapter);
> +	if (retval)
> +		goto error;
>  
> -	return piix4_add_adapter(dev, smba, &piix4_main_adapter);
> +	/* check for AMD SP5100 (maybe others) with aux SMBus port */
> +	if (dev->vendor == PCI_VENDOR_ID_ATI &&
> +	    dev->device == PCI_DEVICE_ID_ATI_SBX00_SMBUS &&
> +		dev->revision == 0x3d) {

Hmm, that would be an ATI SB600 or SB700, so not a recent chip? This
strict check on revision is likely to exclude some systems where this
code should run. Given that the SB800 started at revision 0x40 as far
as I know, shouldn't we test for < 0x40 here?

> +
> +		retval = piix4_setup_aux(dev, id, SMBAUXBA, &smba);
> +		if (retval)
> +			goto error;
> +
> +		retval = piix4_add_adapter(dev, smba, &piix4_aux_adapter);
> +		if (retval)
> +			goto error;

I don't get the logic here. If we fail to register the auxiliary SMBus,
it is certainly not a reason to give up the working main SMBus.
Especially with my comment above that the Auxiliary SMBus may have been
disabled by the vendor on purpose.

> +	}
> +
> +	return 0;
> +
> +error:
> +	/* clean up any adapters that were already added */
> +	piix4_adap_remove(piix4_main_adapter);
> +	piix4_adap_remove(piix4_aux_adapter);

You're not clearing the pointers, this could cause trouble on hot-plug.

> +	return retval;
>  }
>  
>  /* Remove the adapter and its associated IO region */
> @@ -572,6 +640,9 @@ static void piix4_adap_remove(struct i2c_adapter *adap)
>  {
>  	struct i2c_piix4_adapdata *adapdata;
>  
> +	if (adap == NULL)
> +		return;
> +

If you want to do that, it would be better done right in patch 2/3, to
avoid changing code back and forth.

>  	adapdata = (struct i2c_piix4_adapdata *)i2c_get_adapdata(adap);
>  	if (adapdata->smba) {
>  		i2c_del_adapter(adap);
> @@ -585,10 +656,8 @@ static void piix4_adap_remove(struct i2c_adapter *adap)
>  
>  static void __devexit piix4_remove(struct pci_dev *dev)
>  {
> -	if (piix4_main_adapter) {
> -		piix4_adap_remove(piix4_main_adapter);
> -		piix4_main_adapter = NULL;
> -	}
> +	piix4_adap_remove(piix4_main_adapter);
> +	piix4_adap_remove(piix4_aux_adapter);

Here again you're no longer clearing the pointers afterward, this could
cause trouble (unlikely, but better safe than sorry.)

>  }
>  
>  static struct pci_driver piix4_driver = {


-- 
Jean Delvare
