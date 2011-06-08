Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1FHL1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 07:27:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:6824 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab1FHL1C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 07:27:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,338,1304319600"; 
   d="scan'208";a="13461902"
From: "Clark, Joel" <joel.clark@intel.com>
To: "Cox, Alan" <alan.cox@intel.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
CC: "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Clark, Joel" <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>,
        "'Tomoya MORINAGA'" <tomoya-linux@dsn.okisemi.com>,
        "Liu, Bing Wei" <bing.wei.liu@intel.com>,
        "Skarpness, Mark" <mark.skarpness@intel.com>
Date: Wed, 8 Jun 2011 05:26:42 -0600
Subject: FW: [PATCH v5] 8250_pci: add -ENODEV code for Intel EG20T PCH
Thread-Topic: [PATCH v5] 8250_pci: add -ENODEV code for Intel EG20T PCH
Thread-Index: AcwgzJec/8tOF+inR2qkoCFAHbHIKQAApujgAT+bEWA=
Message-ID: <667A27282ACF7941B0F557DAD3491E16010A9E12CB@rrsmsx504.amr.corp.intel.com>
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

> On Wednesday, June 01, 2011 7:31 PM, Tomoya MORINAGA [mailto:tomoya-linux@dsn.okisemi.com] wrote:
>
> Intel EG20T PCH has UART device which is compatible with 8250.
> Currently, with general configuration, the PCH UART driver is not loaded but
> 8250 standard driver is loaded.
> Therefore, in case of using PCH UART driver, need to disable 8250 pci function.
> However, this procedure is not best solution.
> This patch, in 8250_pci, if the device is the PCH or the family IOH,
> '-ENODEV' is returned.
> As a result, disabling 8250-pci processing becomes unnecessary.
>
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
> V5: Rename own_init again.
>     return_ENODEV() to pci_eg20t_init()
>
> V4: Rename own_init to return_ENODEV
>     Add #if defined ~ #endif
>
> V3: add own init() and set the init() to quirk table.
>
> V2: Delete #ifdef CONFIG_SERIAL_PCH_UART ~ #endif
>     Use quirk table structure
> ---
>  drivers/tty/serial/8250_pci.c |   59 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 59 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
> index 738cec9..2b40fbf 100644
> --- a/drivers/tty/serial/8250_pci.c
> +++ b/drivers/tty/serial/8250_pci.c
> @@ -988,6 +988,15 @@ static int skip_tx_en_setup(struct serial_private *priv,
>  	return pci_default_setup(priv, board, port, idx);
>  }
>  
> +static int pci_eg20t_init(struct pci_dev *dev)
> +{
> +#if defined(CONFIG_SERIAL_PCH_UART) || defined(CONFIG_SERIAL_PCH_UART_MODULE)
> +	return -ENODEV;
> +#else
> +	return 0;
> +#endif
> +}
> +
>  /* This should be in linux/pci_ids.h */
>  #define PCI_VENDOR_ID_SBSMODULARIO	0x124B
>  #define PCI_SUBVENDOR_ID_SBSMODULARIO	0x124B
> @@ -1430,6 +1439,56 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
>  		.init		= pci_oxsemi_tornado_init,
>  		.setup		= pci_default_setup,
>  	},
> +	{
> +		.vendor         = PCI_VENDOR_ID_INTEL,
> +		.device         = 0x8811,
> +		.init		= pci_eg20t_init,
> +	},
> +	{
> +		.vendor         = PCI_VENDOR_ID_INTEL,
> +		.device         = 0x8812,
> +		.init		= pci_eg20t_init,
> +	},
> +	{
> +		.vendor         = PCI_VENDOR_ID_INTEL,
> +		.device         = 0x8813,
> +		.init		= pci_eg20t_init,
> +	},
> +	{
> +		.vendor         = PCI_VENDOR_ID_INTEL,
> +		.device         = 0x8814,
> +		.init		= pci_eg20t_init,
> +	},
> +	{
> +		.vendor         = 0x10DB,
> +		.device         = 0x8027,
> +		.init		= pci_eg20t_init,
> +	},
> +	{
> +		.vendor         = 0x10DB,
> +		.device         = 0x8028,
> +		.init		= pci_eg20t_init,
> +	},
> +	{
> +		.vendor         = 0x10DB,
> +		.device         = 0x8029,
> +		.init		= pci_eg20t_init,
> +	},
> +	{
> +		.vendor         = 0x10DB,
> +		.device         = 0x800C,
> +		.init		= pci_eg20t_init,
> +	},
> +	{
> +		.vendor         = 0x10DB,
> +		.device         = 0x800D,
> +		.init		= pci_eg20t_init,
> +	},
> +	{
> +		.vendor         = 0x10DB,
> +		.device         = 0x800D,
> +		.init		= pci_eg20t_init,
> +	},
>  	/*
>  	 * Default "match everything" terminator entry
>  	 */
>
> -- 
> 1.7.4


We would like to add this fix as soon as it is acceptable.  Will this version of this patch be accepted and applied?

regards
Joel Clark
MeeGo IVI 
