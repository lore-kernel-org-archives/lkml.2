Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1DFQvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 12:51:00 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:7387 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab1DFQu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 12:50:59 -0400
Date: Wed, 6 Apr 2011 18:50:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Thomas Renninger <trenn@suse.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH v3] hwmon: Add driver for AMD family 15h processor power
  information
Message-ID: <20110406185044.16e5f92a@endymion.delvare>
In-Reply-To: <20110406135424.GC2177@alberich.amd.com>
References: <20110404160733.GA11818@alberich.amd.com>
	<20110405144536.GA5054@alberich.amd.com>
	<20110406135424.GC2177@alberich.amd.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Wed, 6 Apr 2011 15:54:24 +0200, Andreas Herrmann wrote:
> --- /dev/null
> +++ b/Documentation/hwmon/f15h_power
> @@ -0,0 +1,37 @@
> +Kernel driver f15h_power
> +========================
> +
> +Supported chips:
> +* AMD Family 15h Processors
> +
> +  Prefix: 'f15h_power'
> +  Addresses scanned: PCI space
> +  Datasheets:
> +  BIOS and Kernel Developer's Guide (BKDG) For AMD Family 15h Processors
> +    (not yet published)
> +
> +Author: Andreas Herrmann <andreas.herrmann3@amd.com>

BTW, please consider adding an entry in MAINTAINERS.

> +
> +Description
> +-----------
> +
> +This driver permits reading of registers providing power information
> +of AMD Family 15h processors.
> +
> +For AMD Family 15h processors the following power values can be
> +calculated using different processor northbridge function registers

A trailing ":" would be nice.

> +
> +* BasePwrWatts: Specifies in watts the maximum amount of power
> +  consumed by the processor for NB and logic external to the core.
> +* ProcessorPwrWatts: Specifies in watts the maximum amount of power
> +  the processor can support.
> +* CurrPwrWatts: Specifies in watts the current amount of power being
> +  consumed by the processor.
> +
> +This driver provides ProcessorPwrWatts and CurrPwrWatts:
> +* power1_max (ProcessorPwrWatts)

I see you changed this name once already, but... What is expected to
happen if the power consumed exceeds this limit? If you expect the CPU
to get damaged, then power1_crit would be more appropriate.

Another way to decide if _max or _crit is more appropriate is by
answering the question: if a second limit was added in the future,
would it more likely be below or above this one?

> +* power1_input (CurrPwrWatts)
> +
> +On multi-node processors the calculated value is for the entire
> +package and not for a single node. Thus the driver creates sysfs
> +attributes only for internal node0 of a multi-node processor.

> (...)
> +	return sprintf(buf, "%u\n", (u32) ptdp);

Maybe I'm just nitpicking, but I still don't think it's correct. %u
wants unsigned int, not u32. It might be the same but that's by luck.

> --- a/drivers/hwmon/k10temp.c
> +++ b/drivers/hwmon/k10temp.c
> @@ -205,7 +205,7 @@ static void __devexit k10temp_remove(struct pci_dev *pdev)
>  	dev_set_drvdata(&pdev->dev, NULL);
>  }
>  
> -static const struct pci_device_id k10temp_id_table[] = {
> +static DEFINE_PCI_DEVICE_TABLE(k10temp_id_table) = {
>  	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
>  	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
>  	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_CNB17H_F3) },

Such cleanups should go to separate patches, as they don't have
anything to do with your initial effort. And that way you can fix
k8temp i5k_amb too.

-- 
Jean Delvare
