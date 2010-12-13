Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab0LMKTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:19:35 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:64337 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0LMKTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:19:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=C/fZ9xFohIDMDFryKXjsvWv5HGicsPyfqGoypFBnBwtx1bDuvFdD4T6iPd2JHhSUrJ
         7gihxJNayn4tVreQO4zbYF+y8VOUuVnSMaoSDCHN7YTnvdul1OezmKMCE+xhwOqoSqeu
         hSukDyO5gZmUETRRSj8Hq+x8QRzbGAUJ2MZJs=
Message-ID: <4D05F331.4040109@suse.cz>
Date: Mon, 13 Dec 2010 11:19:29 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: corentincj@iksaif.net, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: eeepc: rfkill on 900A defunct
References: <4CED26EF.5000109@suse.cz> <20101124201834.GA7760@srcf.ucam.org>
In-Reply-To: <20101124201834.GA7760@srcf.ucam.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 09:18 PM, Matthew Garrett wrote:
> Hm. As a shorter term fix, can you try this (entirely untested!) 
> approach?

Yes, this one works:
https://bugzilla.novell.com/show_bug.cgi?id=595586#c27

> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index b2edfdc..8f817d6 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -574,8 +574,9 @@ static bool eeepc_wlan_rfkill_blocked(struct eeepc_laptop *eeepc)
>  	return true;
>  }
>  
> -static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc)
> +static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc, acpi_handle handle)
>  {
> +	struct pci_dev *port;
>  	struct pci_dev *dev;
>  	struct pci_bus *bus;
>  	bool blocked = eeepc_wlan_rfkill_blocked(eeepc);
> @@ -588,9 +589,17 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc)
>  	mutex_lock(&eeepc->hotplug_lock);
>  
>  	if (eeepc->hotplug_slot) {
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
>  		if (!bus) {
> -			pr_warning("Unable to find PCI bus 1?\n");
> +			pr_warning("Unable to find PCI bus?\n");
>  			goto out_unlock;
>  		}
>  
> @@ -636,6 +645,17 @@ out_unlock:
>  	mutex_unlock(&eeepc->hotplug_lock);
>  }
>  
> +static void eeepc_rfkill_hotplug_update(struct eeepc_laptop *eeepc, char *node)
> +{
> +	acpi_status status = AE_OK;
> +	acpi_handle handle;
> +
> +	status = acpi_get_handle(NULL, node, &handle);
> +
> +	if (ACPI_SUCCESS(status))
> +		eeepc_rfkill_hotplug(eeepc, handle);
> +}
> +
>  static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
>  {
>  	struct eeepc_laptop *eeepc = data;
> @@ -643,7 +663,7 @@ static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
>  	if (event != ACPI_NOTIFY_BUS_CHECK)
>  		return;
>  
> -	eeepc_rfkill_hotplug(eeepc);
> +	eeepc_rfkill_hotplug(eeepc, handle);
>  }
>  
>  static int eeepc_register_rfkill_notifier(struct eeepc_laptop *eeepc,
> @@ -661,6 +681,11 @@ static int eeepc_register_rfkill_notifier(struct eeepc_laptop *eeepc,
>  						     eeepc);
>  		if (ACPI_FAILURE(status))
>  			pr_warning("Failed to register notify on %s\n", node);
> +		/*
> +		 * Refresh pci hotplug in case the rfkill state was
> +		 * changed during setup.
> +		 */
> +		eeepc_rfkill_hotplug(eeepc, handle);
>  	} else
>  		return -ENODEV;
>  
> @@ -682,6 +707,12 @@ static void eeepc_unregister_rfkill_notifier(struct eeepc_laptop *eeepc,
>  		if (ACPI_FAILURE(status))
>  			pr_err("Error removing rfkill notify handler %s\n",
>  				node);
> +			/*
> +			 * Refresh pci hotplug in case the rfkill
> +			 * state was changed after
> +			 * eeepc_unregister_rfkill_notifier()
> +			 */
> +		eeepc_rfkill_hotplug(eeepc, handle);
>  	}
>  }
>  
> @@ -805,11 +836,7 @@ static void eeepc_rfkill_exit(struct eeepc_laptop *eeepc)
>  		rfkill_destroy(eeepc->wlan_rfkill);
>  		eeepc->wlan_rfkill = NULL;
>  	}
> -	/*
> -	 * Refresh pci hotplug in case the rfkill state was changed after
> -	 * eeepc_unregister_rfkill_notifier()
> -	 */
> -	eeepc_rfkill_hotplug(eeepc);
> +
>  	if (eeepc->hotplug_slot)
>  		pci_hp_deregister(eeepc->hotplug_slot);
>  
> @@ -878,11 +905,6 @@ static int eeepc_rfkill_init(struct eeepc_laptop *eeepc)
>  	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P5");
>  	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P6");
>  	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P7");
> -	/*
> -	 * Refresh pci hotplug in case the rfkill state was changed during
> -	 * setup.
> -	 */
> -	eeepc_rfkill_hotplug(eeepc);
>  
>  exit:
>  	if (result && result != -ENODEV)
> @@ -917,8 +939,11 @@ static int eeepc_hotk_restore(struct device *device)
>  	struct eeepc_laptop *eeepc = dev_get_drvdata(device);
>  
>  	/* Refresh both wlan rfkill state and pci hotplug */
> -	if (eeepc->wlan_rfkill)
> -		eeepc_rfkill_hotplug(eeepc);
> +	if (eeepc->wlan_rfkill) {
> +		eeepc_rfkill_hotplug_update(eeepc, "\\_SB.PCI0.P0P5");
> +		eeepc_rfkill_hotplug_update(eeepc, "\\_SB.PCI0.P0P6");
> +		eeepc_rfkill_hotplug_update(eeepc, "\\_SB.PCI0.P0P7");
> +	}
>  
>  	if (eeepc->bluetooth_rfkill)
>  		rfkill_set_sw_state(eeepc->bluetooth_rfkill,


-- 
js
suse labs
