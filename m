Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab0LWJ6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 04:58:25 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:45603 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab0LWJ6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 04:58:24 -0500
From: Florian Fainelli <ffainelli@freebox.fr>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coretemp: fix junction temperature for Intel CE4100
Date: Thu, 23 Dec 2010 10:57:11 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-server; KDE/4.5.1; x86_64; ; )
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, sodaville@linutronix.de,
        Fenghua Yu <fenghua.yu@intel.com>
References: <201012142217.07194.ffainelli@freebox.fr>
In-Reply-To: <201012142217.07194.ffainelli@freebox.fr>
Organization: Freebox
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012231057.11940.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 December 2010 22:17:07 Florian Fainelli wrote:
> From: Florian Fainelli <ffainelli@freebox.fr>
> 
> The Intel CE4100 System-on-a-Chip has a slightly higher junction
> temperature (110 degrees Celsius) than other Atom-based hardware.
> 
> Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
> Cc: sodaville@linutronix.de
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>

Fenghua, is there anything wrong with that patch? Thank you.

> ---
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index 42de98d..e47b405 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -178,12 +178,23 @@ static int __devinit adjust_tjmax(struct cpuinfo_x86
> *c, u32 id, struct device *
> 
>  		host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
> 
> -		if (host_bridge && host_bridge->vendor == PCI_VENDOR_ID_INTEL
> -		    && (host_bridge->device == 0xa000	/* NM10 based nettop */
> -		    || host_bridge->device == 0xa010))	/* NM10 based netbook */
> -			tjmax = 100000;
> -		else
> -			tjmax = 90000;
> +		if (host_bridge && host_bridge->vendor == PCI_VENDOR_ID_INTEL) {
> +			switch (host_bridge->device) {
> +			/* NM10 based nettop */
> +			case 0xa000:
> +			/* NM10 based netbook */
> +			case 0xa010:
> +				tjmax = 100000;
> +				break;
> +			/* IntelCE Sodaville (CE4100) */
> +			case 0x0708:
> +				tjmax = 110000;
> +				break;
> +			default:
> +				tjmax = 90000;
> +				break;
> +			}
> +		}
> 
>  		pci_dev_put(host_bridge);
>  	}
