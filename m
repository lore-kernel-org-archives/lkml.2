Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0K2Py4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:54:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab0K2Pyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:54:55 -0500
Date: Mon, 29 Nov 2010 16:54:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Matthew Garrett <mjg@redhat.com>
Cc: srajiv@linux.vnet.ibm.com, debora@linux.vnet.ibm.com,
        m.selhorst@sirrix.com, linux-kernel@vger.kernel.org, jmorris@namei.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] tpm: Autodetect itpm devices
In-Reply-To: <1287697360-31273-1-git-send-email-mjg@redhat.com>
Message-ID: <alpine.LRH.2.00.1011291651280.28682@twin.jikos.cz>
References: <1287697360-31273-1-git-send-email-mjg@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added James Morris and Rafael to CC ]

On Thu, 21 Oct 2010, Matthew Garrett wrote:

> Some Lenovos have TPMs that require a quirk to function correctly. This can
> be autodetected by checking whether the device has a _HID of INTC0102. This
> is an invalid PNPid, and as such is discarded by the pnp layer - however
> it's still present in the ACPI code, so we can pull it out that way. This
> means that the quirk won't be automatically applied on non-ACPI systems,
> but without ACPI we don't have any way to identify the chip anyway so I
> don't think that's a great concern.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

	Tested-by: Jiri Kosina <jkosina@suse.cz>

This definitely is .37 material still, as it fixes suspend regression on 
various machines, as reported here:

	http://lkml.org/lkml/2010/11/1/493
	http://lkml.org/lkml/2010/11/29/219

James, any word on this? It doesn't seem to be present either in Linus' 
tree, nor in linux-next.

Thanks.

> ---
>  drivers/char/tpm/tpm_tis.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 1030f84..c17a305 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -25,6 +25,7 @@
>  #include <linux/slab.h>
>  #include <linux/interrupt.h>
>  #include <linux/wait.h>
> +#include <linux/acpi.h>
>  #include "tpm.h"
>  
>  #define TPM_HEADER_SIZE 10
> @@ -78,6 +79,26 @@ enum tis_defaults {
>  static LIST_HEAD(tis_chips);
>  static DEFINE_SPINLOCK(tis_lock);
>  
> +#ifdef CONFIG_ACPI
> +static int is_itpm(struct pnp_dev *dev)
> +{
> +	struct acpi_device *acpi = pnp_acpi_device(dev);
> +	struct acpi_hardware_id *id;
> +
> +	list_for_each_entry(id, &acpi->pnp.ids, list) {
> +		if (!strcmp("INTC0102", id->id))
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +#else
> +static int is_itpm(struct pnp_dev *dev)
> +{
> +	return 0;
> +}
> +#endif
> +
>  static int check_locality(struct tpm_chip *chip, int l)
>  {
>  	if ((ioread8(chip->vendor.iobase + TPM_ACCESS(l)) &
> @@ -472,6 +493,9 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
>  		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
>  		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
>  
> +	if (is_itpm(to_pnp_dev(dev)))
> +		itpm = 1;
> +
>  	if (itpm)
>  		dev_info(dev, "Intel iTPM workaround enabled\n");
>  
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

