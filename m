Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0KZNKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:10:19 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:24777 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754530Ab0KZNKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:10:17 -0500
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2010 08:10:17 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkIAFs+70xFpYat/2dsb2JhbACDUJ4/fHKwCTyGZC6IW4EhgzNzBIRchgWHaA
X-IronPort-AV: E=Sophos;i="4.59,261,1288584000"; 
   d="scan'208";a="83749421"
Message-ID: <4CEFAF8D.3010907@gmail.com>
Date: Fri, 26 Nov 2010 08:01:01 -0500
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101028 Iceape/2.0.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Jiri Slaby <jslaby@suse.cz>, corentincj@iksaif.net,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: eeepc: rfkill on 900A defunct
References: <4CED26EF.5000109@suse.cz> <20101124201834.GA7760@srcf.ucam.org>
In-Reply-To: <20101124201834.GA7760@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> Hm. As a shorter term fix, can you try this (entirely untested!)
> approach?
>
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index b2edfdc..8f817d6 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -574,8 +574,9 @@ static bool eeepc_wlan_rfkill_blocked(struct eeepc_laptop *eeepc)
>   	return true;
>   }
>
> -static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc)
> +static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc, acpi_handle handle)
>   {
> +	struct pci_dev *port;
>   	struct pci_dev *dev;
>   	struct pci_bus *bus;
>   	bool blocked = eeepc_wlan_rfkill_blocked(eeepc);
> @@ -588,9 +589,17 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc)
>   	mutex_lock(&eeepc->hotplug_lock);
>
>   	if (eeepc->hotplug_slot) {
> -		bus = pci_find_bus(0, 1);
> +		port = acpi_get_pci_dev(handle);
> +
> +		if (!port) {
> +			pr_warning("Unable to find port\n");
> +			goto out_unlock;
> +		}
> +
> +		bus = port->subordinate;
> +
>   		if (!bus) {
> -			pr_warning("Unable to find PCI bus 1?\n");
> +			pr_warning("Unable to find PCI bus?\n");
>   			goto out_unlock;
>   		}
>
> @@ -636,6 +645,17 @@ out_unlock:
>   	mutex_unlock(&eeepc->hotplug_lock);
>   }
>
> +static void eeepc_rfkill_hotplug_update(struct eeepc_laptop *eeepc, char *node)
> +{
> +	acpi_status status = AE_OK;
> +	acpi_handle handle;
> +
> +	status = acpi_get_handle(NULL, node,&handle);
> +
> +	if (ACPI_SUCCESS(status))
> +		eeepc_rfkill_hotplug(eeepc, handle);
> +}
> +
>   static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
>   {
>   	struct eeepc_laptop *eeepc = data;
> @@ -643,7 +663,7 @@ static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
>   	if (event != ACPI_NOTIFY_BUS_CHECK)
>   		return;
>
> -	eeepc_rfkill_hotplug(eeepc);
> +	eeepc_rfkill_hotplug(eeepc, handle);
>   }
>
>   static int eeepc_register_rfkill_notifier(struct eeepc_laptop *eeepc,
> @@ -661,6 +681,11 @@ static int eeepc_register_rfkill_notifier(struct eeepc_laptop *eeepc,
>   						     eeepc);
>   		if (ACPI_FAILURE(status))
>   			pr_warning("Failed to register notify on %s\n", node);
> +		/*
> +		 * Refresh pci hotplug in case the rfkill state was
> +		 * changed during setup.
> +		 */
> +		eeepc_rfkill_hotplug(eeepc, handle);
>   	} else
>   		return -ENODEV;
>
> @@ -682,6 +707,12 @@ static void eeepc_unregister_rfkill_notifier(struct eeepc_laptop *eeepc,
>   		if (ACPI_FAILURE(status))
>   			pr_err("Error removing rfkill notify handler %s\n",
>   				node);
> +			/*
> +			 * Refresh pci hotplug in case the rfkill
> +			 * state was changed after
> +			 * eeepc_unregister_rfkill_notifier()
> +			 */
> +		eeepc_rfkill_hotplug(eeepc, handle);
>   	}
>   }
>
> @@ -805,11 +836,7 @@ static void eeepc_rfkill_exit(struct eeepc_laptop *eeepc)
>   		rfkill_destroy(eeepc->wlan_rfkill);
>   		eeepc->wlan_rfkill = NULL;
>   	}
> -	/*
> -	 * Refresh pci hotplug in case the rfkill state was changed after
> -	 * eeepc_unregister_rfkill_notifier()
> -	 */
> -	eeepc_rfkill_hotplug(eeepc);
> +
>   	if (eeepc->hotplug_slot)
>   		pci_hp_deregister(eeepc->hotplug_slot);
>
> @@ -878,11 +905,6 @@ static int eeepc_rfkill_init(struct eeepc_laptop *eeepc)
>   	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P5");
>   	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P6");
>   	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P7");
> -	/*
> -	 * Refresh pci hotplug in case the rfkill state was changed during
> -	 * setup.
> -	 */
> -	eeepc_rfkill_hotplug(eeepc);
>
>   exit:
>   	if (result&&  result != -ENODEV)
> @@ -917,8 +939,11 @@ static int eeepc_hotk_restore(struct device *device)
>   	struct eeepc_laptop *eeepc = dev_get_drvdata(device);
>
>   	/* Refresh both wlan rfkill state and pci hotplug */
> -	if (eeepc->wlan_rfkill)
> -		eeepc_rfkill_hotplug(eeepc);
> +	if (eeepc->wlan_rfkill) {
> +		eeepc_rfkill_hotplug_update(eeepc, "\\_SB.PCI0.P0P5");
> +		eeepc_rfkill_hotplug_update(eeepc, "\\_SB.PCI0.P0P6");
> +		eeepc_rfkill_hotplug_update(eeepc, "\\_SB.PCI0.P0P7");
> +	}
>
>   	if (eeepc->bluetooth_rfkill)
>   		rfkill_set_sw_state(eeepc->bluetooth_rfkill,
>    
Did a quick test. The 900A seems printing the "Port not found" warning, 
but the ath5k comes down and then up OK.
Mind you, I think they are doing some magic in the BIOS as well, so more 
testing would be nice ;-)
If it works, it may be a good candidate for 2.6.36 as well...

Thanks, Woody

