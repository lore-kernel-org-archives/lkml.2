Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1AJQId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:08:33 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:48200 "HELO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752578Ab1AJQIb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:08:31 -0500
From: Philip Rakity <prakity@marvell.com>
To: Pierre Tardy <tardyp@gmail.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pierre Tardy <pierre.tardy@intel.com>
Date: Mon, 10 Jan 2011 08:04:57 -0800
Subject: Re: [PATCH 1/3] mmc: add per device quirk placeholder
Thread-Topic: [PATCH 1/3] mmc: add per device quirk placeholder
Thread-Index: Acuw4CFhkombDILEQkex2FIvpUhNrw==
Message-ID: <77BC89B5-DFC2-4908-8875-59BCD00DC10F@marvell.com>
References: <cover.1294588491.git.tardyp@gmail.com>
 <6191610532f25d7cda435781ce9b83bfdb677b5a.1294588491.git.tardyp@gmail.com>
In-Reply-To: <6191610532f25d7cda435781ce9b83bfdb677b5a.1294588491.git.tardyp@gmail.com>
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


On Jan 9, 2011, at 8:26 AM, Pierre Tardy wrote:

> From: Pierre Tardy <pierre.tardy@intel.com>
> 
> Some cards have quirks valid for every platforms
> using current platform quirk hooks leads to a lot
> of code and debug duplication.
> 
> So we inspire a bit from what exists in PCI subsystem
> and do our own per vendorid/deviceid quirk
> We still drop the complexity of the pci quirk system
> (with special section tables, and so on)
> That can be added later if needed.
> 
> Signed-off-by: Pierre Tardy <pierre.tardy@intel.com>
> ---
> drivers/mmc/core/Makefile |    3 +-
> drivers/mmc/core/core.h   |    2 +
> drivers/mmc/core/quirks.c |   54 +++++++++++++++++++++++++++++++++++++++++++++
> drivers/mmc/core/sdio.c   |    1 +
> include/linux/mmc/card.h  |    2 +
> 5 files changed, 61 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/core/Makefile b/drivers/mmc/core/Makefile
> index 86b4791..6395019 100644
> --- a/drivers/mmc/core/Makefile
> +++ b/drivers/mmc/core/Makefile
> @@ -6,6 +6,7 @@ obj-$(CONFIG_MMC)		+= mmc_core.o
> mmc_core-y			:= core.o bus.o host.o \
> 				   mmc.o mmc_ops.o sd.o sd_ops.o \
> 				   sdio.o sdio_ops.o sdio_bus.o \
> -				   sdio_cis.o sdio_io.o sdio_irq.o
> +				   sdio_cis.o sdio_io.o sdio_irq.o \
> +				   quirks.o
> 
> mmc_core-$(CONFIG_DEBUG_FS)	+= debugfs.o
> diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
> index ca1fdde..20b1c08 100644
> --- a/drivers/mmc/core/core.h
> +++ b/drivers/mmc/core/core.h
> @@ -61,6 +61,8 @@ int mmc_attach_mmc(struct mmc_host *host);
> int mmc_attach_sd(struct mmc_host *host);
> int mmc_attach_sdio(struct mmc_host *host);
> 
> +void mmc_fixup_device(struct mmc_card *card);
> +
> /* Module parameters */
> extern int use_spi_crc;
> 
> diff --git a/drivers/mmc/core/quirks.c b/drivers/mmc/core/quirks.c
> new file mode 100644
> index 0000000..d8a5fec
> --- /dev/null
> +++ b/drivers/mmc/core/quirks.c
> @@ -0,0 +1,54 @@
> +/*
> + *  This file contains work-arounds for many known sdio hardware
> + *  bugs.
> + *
> + *  Copyright (c) 2011 Pierre Tardy <tardyp@gmail.com>
> + *  Inspired from pci fixup code:
> + *  Copyright (c) 1999 Martin Mares <mj@ucw.cz>
> + *
> + */
> +
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/mmc/card.h>
> +#include <linux/mod_devicetable.h>
> +
> +/*
> + *  The world is not perfect and supplies us with broken mmc/sdio devices.
> + *  For at least a part of these bugs we need a work-around
> + */
> +
> +struct mmc_fixup {
> +	u16 vendor, device;	/* You can use SDIO_ANY_ID here of course */
> +	void (*hook)(struct mmc_card *card, int data);
> +	int data;
> +};
> +
> +/*
> + * This hook just adds a quirk unconditionnally
> + */
> +static void add_quirk(struct mmc_card *card, int data)
> +{
> +	card->quirks |= data;
> +}
> +
> +static const struct mmc_fixup mmc_fixup_methods[] = {
> +	{ 0 }
> +};
> +
> +void  (struct mmc_card *card)
> +{
> +	const struct mmc_fixup *f;
> +
> +	for (f = mmc_fixup_methods; f->hook; f++) {
> +		if ((f->vendor == card->cis.vendor
> +		     || f->vendor == (u16) SDIO_ANY_ID) &&
> +		    (f->device == card->cis.device
> +		     || f->device == (u16) SDIO_ANY_ID)) {
> +			dev_dbg(&card->dev, "calling %pF\n", f->hook);
> +			f->hook(card, f->data);


hook is not a very nice name ---  something more meaningful:  vendor_fixup  ?

> +		}
> +	}
> +}
> +EXPORT_SYMBOL(mmc_fixup_device);
> +
> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
> index 5c4a54d..617e9ad 100644
> --- a/drivers/mmc/core/sdio.c
> +++ b/drivers/mmc/core/sdio.c
> @@ -458,6 +458,7 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
> 
> 		card = oldcard;
> 	}
> +	mmc_fixup_device(card);
> 
> 	if (card->type == MMC_TYPE_SD_COMBO) {
> 		err = mmc_sd_setup_card(host, card, oldcard != NULL);
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index 8ce0827..a498d53 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -148,6 +148,8 @@ struct mmc_card {
> 	struct dentry		*debugfs_root;
> };
> 
> +void mmc_fixup_device(struct mmc_card *dev);
> +
> #define mmc_card_mmc(c)		((c)->type == MMC_TYPE_MMC)
> #define mmc_card_sd(c)		((c)->type == MMC_TYPE_SD)
> #define mmc_card_sdio(c)	((c)->type == MMC_TYPE_SDIO)
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

