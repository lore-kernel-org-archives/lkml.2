Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab0LYWcA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 17:32:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:34315 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab0LYWb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 17:31:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,229,1291622400"; 
   d="scan'208";a="640381125"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Florian Fainelli <florian@openwrt.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "sodaville@linutronix.de" <sodaville@linutronix.de>
Date: Sat, 25 Dec 2010 14:28:33 -0800
Subject: RE: [PATCH] coretemp: fix junction temperature for Intel CE4100
Thread-Topic: [PATCH] coretemp: fix junction temperature for Intel CE4100
Thread-Index: Acub1Etmxm5/dMsZQD6KcACPCmH5UgIrdw3w
Message-ID: <493994B35A117E4F832F97C4719C4C04D781EF3F@orsmsx505.amr.corp.intel.com>
References: <201012142217.07194.ffainelli@freebox.fr>
In-Reply-To: <201012142217.07194.ffainelli@freebox.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Florian Fainelli [mailto:f.fainelli@gmail.com] On Behalf Of
> Florian Fainelli
> Sent: Tuesday, December 14, 2010 1:17 PM
> To: linux-kernel@vger.kernel.org; Dirk Brandewie;
> sodaville@linutronix.de; Yu, Fenghua
> Subject: [PATCH] coretemp: fix junction temperature for Intel CE4100
> 
> From: Florian Fainelli <ffainelli@freebox.fr>
> 
> The Intel CE4100 System-on-a-Chip has a slightly higher junction
> temperature
> (110 degrees Celsius) than other Atom-based hardware.
> 
> Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
> Cc: sodaville@linutronix.de
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
> ---
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index 42de98d..e47b405 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -178,12 +178,23 @@ static int __devinit adjust_tjmax(struct
> cpuinfo_x86 *c, u32 id, struct device *
> 
>  		host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
> 
> -		if (host_bridge && host_bridge->vendor ==
> PCI_VENDOR_ID_INTEL
> -		    && (host_bridge->device == 0xa000	/* NM10 based
> nettop */
> -		    || host_bridge->device == 0xa010))	/* NM10 based
> netbook */
> -			tjmax = 100000;
> -		else
> -			tjmax = 90000;
> +		if (host_bridge && host_bridge->vendor ==
> PCI_VENDOR_ID_INTEL) {
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
When host_bridge && host_bridge->vendor == PCI_VENDOR_ID_INTEL is not true, tjmax is not assigned to 90000. This is different from original code.

Could you add public spec URL or public spec name for 110 degrees C in your comments? People may get lost to find this info.

Thanks.

-Fenghua
