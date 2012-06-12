Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab2FLMKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:10:52 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:40601 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2FLMKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:10:51 -0400
Date: Tue, 12 Jun 2012 14:10:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Armenia <andrew@asquaredlabs.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] i2c-piix4: separate registration and probing code
Message-ID: <20120612141035.1a393a81@endymion.delvare>
In-Reply-To: <1338860964-10803-3-git-send-email-andrew@asquaredlabs.com>
References: <20120604091643.208956fe@endymion.delvare>
	<1338860964-10803-1-git-send-email-andrew@asquaredlabs.com>
	<1338860964-10803-3-git-send-email-andrew@asquaredlabs.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 Jun 2012 21:49:23 -0400, Andrew Armenia wrote:
> Some chipsets have multiple sets of SMBus registers each controlling a
> separate SMBus. Supporting these chipsets properly will require registering
> multiple I2C adapters for one piix4.
> 
> The code to initialize and register the i2c_adapter structure has been
> separated from piix4_probe and allows registration of a piix4 adapter
> given its base address. Note that the i2c_adapter and piix4_adapdata
> structures are now dynamically allocated.
> 
> Signed-off-by: Andrew Armenia <andrew@asquaredlabs.com>
> ---
>  drivers/i2c/busses/i2c-piix4.c |   79 ++++++++++++++++++++++++++--------------
>  1 file changed, 51 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
> index 7a5889c..8a87b3f 100644
> --- a/drivers/i2c/busses/i2c-piix4.c
> +++ b/drivers/i2c/busses/i2c-piix4.c
> @@ -480,16 +480,6 @@ static const struct i2c_algorithm smbus_algorithm = {
>  	.functionality	= piix4_func,
>  };
>  
> -static struct i2c_adapter piix4_adapter = {
> -	.owner		= THIS_MODULE,
> -	.class		= I2C_CLASS_HWMON | I2C_CLASS_SPD,
> -	.algo		= &smbus_algorithm,
> -};
> -
> -static struct i2c_piix4_adapdata piix4_adapter_data = {
> -	.smba		= 0,
> -};
> -
>  static DEFINE_PCI_DEVICE_TABLE(piix4_ids) = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371AB_3) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443MX_3) },
> @@ -514,6 +504,48 @@ static DEFINE_PCI_DEVICE_TABLE(piix4_ids) = {
>  
>  MODULE_DEVICE_TABLE (pci, piix4_ids);
>  
> +static struct i2c_adapter *piix4_main_adapter;
> +
> +/* register piix4 I2C adapter at the given base address */
> +static int piix4_add_adapter(struct pci_dev *dev, unsigned short smba,
> +				struct i2c_adapter **padap) {

Called from a __devinit function, could be made __devinit.

> +	struct i2c_adapter *piix4_adapter;
> +	struct i2c_piix4_adapdata *piix4_adapdata;

It would be pleasant to use the same names here and in
piix4_adap_remove(), for consistency.

> +	int retval;
> +
> +	piix4_adapter = kmalloc(sizeof(*piix4_adapter), GFP_KERNEL);
> +	memset(piix4_adapter, 0, sizeof(*piix4_adapter));

Please use kzalloc. Furthermore, k*alloc() can theoretically fail, so
you have to check for this unlikely case and handle it gracefully.

> +	piix4_adapter->owner = THIS_MODULE;
> +	piix4_adapter->class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
> +	piix4_adapter->algo = &smbus_algorithm;
> +
> +	piix4_adapdata = kmalloc(sizeof(*piix4_adapdata), GFP_KERNEL);
> +	memset(piix4_adapdata, 0, sizeof(*piix4_adapdata));

Same here.

> +	piix4_adapdata->smba = smba;
> +
> +	/* set up the sysfs linkage to our parent device */
> +	piix4_adapter->dev.parent = &dev->dev;
> +
> +	snprintf(piix4_adapter->name, sizeof(piix4_adapter->name),
> +		"SMBus PIIX4 adapter at %04x", smba);
> +
> +	piix4_adapdata->smba = smba;

You already did that a few lines above.

> +
> +	i2c_set_adapdata(piix4_adapter, piix4_adapdata);
> +
> +	retval = i2c_add_adapter(piix4_adapter);
> +	if (retval) {
> +		dev_err(&dev->dev, "Couldn't register adapter!\n");
> +		release_region(smba, SMBIOSIZE);
> +		kfree(piix4_adapdata);
> +		kfree(piix4_adapter);
> +	}
> +
> +	*padap = piix4_adapter;

It's pointless do to that in the error case.

> +
> +	return retval;
> +}
> +
>  static int __devinit piix4_probe(struct pci_dev *dev,
>  				const struct pci_device_id *id)
>  {
> @@ -532,25 +564,10 @@ static int __devinit piix4_probe(struct pci_dev *dev,
>  	if (retval)
>  		return retval;
>  
> -	/* set up the sysfs linkage to our parent device */
> -	piix4_adapter.dev.parent = &dev->dev;
> -
> -	snprintf(piix4_adapter.name, sizeof(piix4_adapter.name),
> -		"SMBus PIIX4 adapter at %04x", smba);
> -
> -	piix4_adapter_data.smba = smba;
> -
> -	i2c_set_adapdata(&piix4_adapter, &piix4_adapter_data);
> -
> -	if ((retval = i2c_add_adapter(&piix4_adapter))) {
> -		dev_err(&dev->dev, "Couldn't register adapter!\n");
> -		release_region(smba, SMBIOSIZE);
> -		piix4_adapter_data.smba = 0;
> -	}
> -
> -	return retval;
> +	return piix4_add_adapter(dev, smba, &piix4_main_adapter);
>  }
>  
> +/* Remove the adapter and its associated IO region */
>  static void piix4_adap_remove(struct i2c_adapter *adap)
>  {
>  	struct i2c_piix4_adapdata *adapdata;
> @@ -561,11 +578,17 @@ static void piix4_adap_remove(struct i2c_adapter *adap)
>  		release_region(adapdata->smba, SMBIOSIZE);
>  		adapdata->smba = 0;

This one can go away, no point in cleaning up a structure you're about
to free.

>  	}
> +
> +	kfree(adapdata);
> +	kfree(adap);
>  }
>  
>  static void __devexit piix4_remove(struct pci_dev *dev)
>  {
> -	piix4_adap_remove(&piix4_adapter);
> +	if (piix4_main_adapter) {
> +		piix4_adap_remove(piix4_main_adapter);
> +		piix4_main_adapter = NULL;
> +	}
>  }
>  
>  static struct pci_driver piix4_driver = {


-- 
Jean Delvare
