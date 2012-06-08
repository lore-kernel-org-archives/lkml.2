Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2FHTN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 15:13:26 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:52239 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab2FHTNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 15:13:20 -0400
Message-ID: <1339182796.2297.12.camel@localhost.localdomain>
Subject: Re: [PATCH 2/2] hw_random: add support for the TPM chip as a
 hardware RNG source
From: David Safford <safford@linux.vnet.ibm.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        m.selhorst@sirrix.com, David Safford <safford@us.ibm.com>
Date: Fri, 08 Jun 2012 15:13:16 -0400
In-Reply-To: <1339094862.21398.6.camel@key-ThinkPad-W510>
References: <1339094567.21398.2.camel@key-ThinkPad-W510>
	 <1339094862.21398.6.camel@key-ThinkPad-W510>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.2 (3.4.2-1.fc17) 
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060819-7408-0000-0000-000005B29643
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 13:47 -0500, Kent Yoder wrote:
> This driver will make use of any available TPM chip on the system as a
> hwrng source.
> 
> Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>

Acked-by: David Safford <safford@linux.vnet.ibm.com>

> ---
>  drivers/char/hw_random/Kconfig   |   13 +++++++++
>  drivers/char/hw_random/Makefile  |    1 +
>  drivers/char/hw_random/tpm-rng.c |   55 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 69 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/char/hw_random/tpm-rng.c
> 
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index f45dad3..4e8c01a 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -263,3 +263,16 @@ config HW_RANDOM_PSERIES
>  	  module will be called pseries-rng.
>  
>  	  If unsure, say Y.
> +
> +config HW_RANDOM_TPM
> +	tristate "TPM HW Random Number Generator support"
> +	depends on HW_RANDOM && TCG_TPM
> +	default HW_RANDOM
> +	---help---
> +	  This driver provides kernel-side support for the Random Number
> +	  Generator in the Trusted Platform Module
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called tpm-rng.
> +
> +	  If unsure, say Y.
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index d901dfa..5dc10da 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -23,3 +23,4 @@ obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
>  obj-$(CONFIG_HW_RANDOM_PICOXCELL) += picoxcell-rng.o
>  obj-$(CONFIG_HW_RANDOM_PPC4XX) += ppc4xx-rng.o
>  obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
> +obj-$(CONFIG_HW_RANDOM_TPM) += tpm-rng.o
> diff --git a/drivers/char/hw_random/tpm-rng.c b/drivers/char/hw_random/tpm-rng.c
> new file mode 100644
> index 0000000..a869b42c
> --- /dev/null
> +++ b/drivers/char/hw_random/tpm-rng.c
> @@ -0,0 +1,55 @@
> +/*
> + * Copyright (C) 2012 Kent Yoder IBM Corporation
> + *
> + * HWRNG interfaces to pull RNG data from a TPM
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
> + */
> +
> +#include <linux/module.h>
> +#include <linux/hw_random.h>
> +#include <linux/tpm.h>
> +
> +#define MODULE_NAME "tpm-rng"
> +
> +static int tpm_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
> +{
> +	int err;
> +	size_t tpm_max = max;
> +
> +	err = tpm_get_random(TPM_ANY_NUM, data, &tpm_max);
> +
> +	return err ? 0 : tpm_max;
> +}
> +
> +static struct hwrng tpm_rng = {
> +	.name = MODULE_NAME,
> +	.read = tpm_rng_read,
> +};
> +
> +static int __init rng_init(void)
> +{
> +	return hwrng_register(&tpm_rng);
> +}
> +module_init(rng_init);
> +
> +static void __exit rng_exit(void)
> +{
> +	hwrng_unregister(&tpm_rng);
> +}
> +module_exit(rng_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Kent Yoder <key@linux.vnet.ibm.com>");
> +MODULE_DESCRIPTION("RNG driver for TPM devices");

