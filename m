Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab1BXDPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 22:15:45 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40771 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277Ab1BXDPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 22:15:42 -0500
Date: Wed, 23 Feb 2011 20:15:28 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ipmi: convert OF driver to platform driver
Message-ID: <20110224031528.GB12139@angua.secretlab.ca>
References: <1298497079-20546-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298497079-20546-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 03:37:59PM -0600, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> of_bus is deprecated in favor of the plain platform bus. This patch
> merges the ipmi OF driver with the existing platform driver.
> 
> CONFIG_PPC_OF occurrances are removed or replaced with CONFIG_OF.
> 
> Compile tested with and without CONFIG_OF. Tested OF probe and
> default probe cases.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Wow.  That driver does some weird things with the driver model that
really should be cleaned up.  That said, this change looks correct.
I'll add it to my tree and see how it goes.

I'm going to wait another day or so for comments, and then I'll push
my branch out to linux-next for testing.

g.

> 
> ---
>  drivers/char/ipmi/ipmi_si_intf.c |   70 ++++++++++++-------------------------
>  1 files changed, 23 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 7855f9f..dcfc39c 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -66,13 +66,10 @@
>  #include <linux/string.h>
>  #include <linux/ctype.h>
>  #include <linux/pnp.h>
> -
> -#ifdef CONFIG_PPC_OF
>  #include <linux/of_device.h>
>  #include <linux/of_platform.h>
>  #include <linux/of_address.h>
>  #include <linux/of_irq.h>
> -#endif
>  
>  #define PFX "ipmi_si: "
>  
> @@ -116,13 +113,7 @@ static char *ipmi_addr_src_to_str[] = { NULL, "hotmod", "hardcoded", "SPMI",
>  
>  #define DEVICE_NAME "ipmi_si"
>  
> -static struct platform_driver ipmi_driver = {
> -	.driver = {
> -		.name = DEVICE_NAME,
> -		.bus = &platform_bus_type
> -	}
> -};
> -
> +static struct platform_driver ipmi_driver;
>  
>  /*
>   * Indexes into stats[] in smi_info below.
> @@ -308,9 +299,6 @@ static int pci_registered;
>  #ifdef CONFIG_ACPI
>  static int pnp_registered;
>  #endif
> -#ifdef CONFIG_PPC_OF
> -static int of_registered;
> -#endif
>  
>  static unsigned int kipmid_max_busy_us[SI_MAX_PARMS];
>  static int num_max_busy_us;
> @@ -1860,8 +1848,9 @@ static int hotmod_handler(const char *val, struct kernel_param *kp)
>  	return rv;
>  }
>  
> -static void __devinit hardcode_find_bmc(void)
> +static int __devinit hardcode_find_bmc(void)
>  {
> +	int ret = -ENODEV;
>  	int             i;
>  	struct smi_info *info;
>  
> @@ -1871,7 +1860,7 @@ static void __devinit hardcode_find_bmc(void)
>  
>  		info = smi_info_alloc();
>  		if (!info)
> -			return;
> +			return -ENOMEM;
>  
>  		info->addr_source = SI_HARDCODED;
>  		printk(KERN_INFO PFX "probing via hardcoded address\n");
> @@ -1924,10 +1913,12 @@ static void __devinit hardcode_find_bmc(void)
>  		if (!add_smi(info)) {
>  			if (try_smi_init(info))
>  				cleanup_one_si(info);
> +			ret = 0;
>  		} else {
>  			kfree(info);
>  		}
>  	}
> +	return ret;
>  }
>  
>  #ifdef CONFIG_ACPI
> @@ -2555,11 +2546,9 @@ static struct pci_driver ipmi_pci_driver = {
>  };
>  #endif /* CONFIG_PCI */
>  
> -
> -#ifdef CONFIG_PPC_OF
> -static int __devinit ipmi_of_probe(struct platform_device *dev,
> -			 const struct of_device_id *match)
> +static int __devinit ipmi_probe(struct platform_device *dev)
>  {
> +#ifdef CONFIG_OF
>  	struct smi_info *info;
>  	struct resource resource;
>  	const __be32 *regsize, *regspacing, *regshift;
> @@ -2569,6 +2558,9 @@ static int __devinit ipmi_of_probe(struct platform_device *dev,
>  
>  	dev_info(&dev->dev, "probing via device tree\n");
>  
> +	if (!dev->dev.of_match)
> +		return -EINVAL;
> +
>  	ret = of_address_to_resource(np, 0, &resource);
>  	if (ret) {
>  		dev_warn(&dev->dev, PFX "invalid address from OF\n");
> @@ -2601,7 +2593,7 @@ static int __devinit ipmi_of_probe(struct platform_device *dev,
>  		return -ENOMEM;
>  	}
>  
> -	info->si_type		= (enum si_type) match->data;
> +	info->si_type		= (enum si_type) dev->dev.of_match->data;
>  	info->addr_source	= SI_DEVICETREE;
>  	info->irq_setup		= std_irq_setup;
>  
> @@ -2632,13 +2624,15 @@ static int __devinit ipmi_of_probe(struct platform_device *dev,
>  		kfree(info);
>  		return -EBUSY;
>  	}
> -
> +#endif
>  	return 0;
>  }
>  
> -static int __devexit ipmi_of_remove(struct platform_device *dev)
> +static int __devexit ipmi_remove(struct platform_device *dev)
>  {
> +#ifdef CONFIG_OF
>  	cleanup_one_si(dev_get_drvdata(&dev->dev));
> +#endif
>  	return 0;
>  }
>  
> @@ -2653,16 +2647,15 @@ static struct of_device_id ipmi_match[] =
>  	{},
>  };
>  
> -static struct of_platform_driver ipmi_of_platform_driver = {
> +static struct platform_driver ipmi_driver = {
>  	.driver = {
> -		.name = "ipmi",
> +		.name = DEVICE_NAME,
>  		.owner = THIS_MODULE,
>  		.of_match_table = ipmi_match,
>  	},
> -	.probe		= ipmi_of_probe,
> -	.remove		= __devexit_p(ipmi_of_remove),
> +	.probe		= ipmi_probe,
> +	.remove		= __devexit_p(ipmi_remove),
>  };
> -#endif /* CONFIG_PPC_OF */
>  
>  static int wait_for_msg_done(struct smi_info *smi_info)
>  {
> @@ -3340,8 +3333,7 @@ static int __devinit init_ipmi_si(void)
>  		return 0;
>  	initialized = 1;
>  
> -	/* Register the device drivers. */
> -	rv = driver_register(&ipmi_driver.driver);
> +	rv = platform_driver_register(&ipmi_driver);
>  	if (rv) {
>  		printk(KERN_ERR PFX "Unable to register driver: %d\n", rv);
>  		return rv;
> @@ -3365,15 +3357,9 @@ static int __devinit init_ipmi_si(void)
>  
>  	printk(KERN_INFO "IPMI System Interface driver.\n");
>  
> -	hardcode_find_bmc();
> -
>  	/* If the user gave us a device, they presumably want us to use it */
> -	mutex_lock(&smi_infos_lock);
> -	if (!list_empty(&smi_infos)) {
> -		mutex_unlock(&smi_infos_lock);
> +	if (!hardcode_find_bmc())
>  		return 0;
> -	}
> -	mutex_unlock(&smi_infos_lock);
>  
>  #ifdef CONFIG_PCI
>  	rv = pci_register_driver(&ipmi_pci_driver);
> @@ -3396,11 +3382,6 @@ static int __devinit init_ipmi_si(void)
>  	spmi_find_bmc();
>  #endif
>  
> -#ifdef CONFIG_PPC_OF
> -	of_register_platform_driver(&ipmi_of_platform_driver);
> -	of_registered = 1;
> -#endif
> -
>  	/* We prefer devices with interrupts, but in the case of a machine
>  	   with multiple BMCs we assume that there will be several instances
>  	   of a given type so if we succeed in registering a type then also
> @@ -3548,17 +3529,12 @@ static void __exit cleanup_ipmi_si(void)
>  		pnp_unregister_driver(&ipmi_pnp_driver);
>  #endif
>  
> -#ifdef CONFIG_PPC_OF
> -	if (of_registered)
> -		of_unregister_platform_driver(&ipmi_of_platform_driver);
> -#endif
> +	platform_driver_unregister(&ipmi_driver);
>  
>  	mutex_lock(&smi_infos_lock);
>  	list_for_each_entry_safe(e, tmp_e, &smi_infos, link)
>  		cleanup_one_si(e);
>  	mutex_unlock(&smi_infos_lock);
> -
> -	driver_unregister(&ipmi_driver.driver);
>  }
>  module_exit(cleanup_ipmi_si);
>  
> -- 
> 1.7.1
> 
