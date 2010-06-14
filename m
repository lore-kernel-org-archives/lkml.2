Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab0FNUhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:37:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755295Ab0FNUhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:37:20 -0400
Date: Mon, 14 Jun 2010 13:36:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: minyard@acm.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipmi: Make sure drivers were registered before
 unregistering them
Message-Id: <20100614133608.b343cb84.akpm@linux-foundation.org>
In-Reply-To: <1276192406-3612-1-git-send-email-mjg@redhat.com>
References: <1276192406-3612-1-git-send-email-mjg@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010 13:53:26 -0400
Matthew Garrett <mjg@redhat.com> wrote:

> The ipmi code will never register a PCI or Open Firmware driver if
> a hardcoded device is provided by the user.

How does a user "provide a hardcoded device"?

> This can cause us to attempt
> to unregister a driver that was never registered, resulting in an oops.
> Keep track of registration in order to avoid this.
> 

I tried to work out from the above whether we want to backport this fix
into -stable and failed.  And I reckon that if I can't work this out
from a changelog, the changelog is inadequate.

> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -302,6 +302,12 @@ struct smi_info {
>  
>  static int force_kipmid[SI_MAX_PARMS];
>  static int num_force_kipmid;
> +#ifdef CONFIG_PCI
> +static int pci_registered;
> +#endif
> +#ifdef CONFIG_PPC_OF
> +static int of_registered;
> +#endif
>  
>  static unsigned int kipmid_max_busy_us[SI_MAX_PARMS];
>  static int num_max_busy_us;
> @@ -3314,6 +3320,8 @@ static __devinit int init_ipmi_si(void)
>  	rv = pci_register_driver(&ipmi_pci_driver);
>  	if (rv)
>  		printk(KERN_ERR PFX "Unable to register PCI driver: %d\n", rv);
> +	else
> +		pci_registered = 1;
>  #endif
>  
>  #ifdef CONFIG_ACPI
> @@ -3330,6 +3338,7 @@ static __devinit int init_ipmi_si(void)
>  
>  #ifdef CONFIG_PPC_OF
>  	of_register_platform_driver(&ipmi_of_platform_driver);
> +	of_registered = 1;

I assume the code will still oops if of_register_platform_driver() failed.

>  #endif
>  
>  	/* We prefer devices with interrupts, but in the case of a machine
> @@ -3383,11 +3392,13 @@ static __devinit int init_ipmi_si(void)
>  	if (unload_when_empty && list_empty(&smi_infos)) {
>  		mutex_unlock(&smi_infos_lock);
>  #ifdef CONFIG_PCI
> -		pci_unregister_driver(&ipmi_pci_driver);
> +		if (pci_registered)
> +			pci_unregister_driver(&ipmi_pci_driver);
>  #endif
>  
>  #ifdef CONFIG_PPC_OF
> -		of_unregister_platform_driver(&ipmi_of_platform_driver);
> +		if (of_registered)
> +			of_unregister_platform_driver(&ipmi_of_platform_driver);
>  #endif
>  		driver_unregister(&ipmi_driver.driver);
>  		printk(KERN_WARNING PFX
> @@ -3478,14 +3489,16 @@ static __exit void cleanup_ipmi_si(void)
>  		return;
>  
>  #ifdef CONFIG_PCI
> -	pci_unregister_driver(&ipmi_pci_driver);
> +	if (pci_registered)
> +		pci_unregister_driver(&ipmi_pci_driver);
>  #endif
>  #ifdef CONFIG_ACPI
>  	pnp_unregister_driver(&ipmi_pnp_driver);
>  #endif
>  
>  #ifdef CONFIG_PPC_OF
> -	of_unregister_platform_driver(&ipmi_of_platform_driver);
> +	if (of_registered)
> +		of_unregister_platform_driver(&ipmi_of_platform_driver);
>  #endif
>  
>  	mutex_lock(&smi_infos_lock);

