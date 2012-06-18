Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab2FRPLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:11:31 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36568 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab2FRPL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:11:28 -0400
Date: Mon, 18 Jun 2012 10:06:10 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Mathias Leblanc <matthias.leblanc@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        Mathias Leblanc <mathias.leblanc@st.com>
Subject: Re: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C/SPI & ST19 I2C
Message-ID: <20120618150610.GA14970@linux.vnet.ibm.com>
References: <1338573960-12425-1-git-send-email-mathias.leblanc@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338573960-12425-1-git-send-email-mathias.leblanc@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061815-7282-0000-0000-00000A05CAEE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Hi Mathias,

On Fri, Jun 01, 2012 at 08:06:00PM +0200, Mathias Leblanc wrote:
>  * STMicroelectronics version 1.2.0, Copyright (C) 2010
>  * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
>  * This is free software, and you are welcome to redistribute it
>  * under certain conditions.
> 
> This is the driver for TPM chip from ST Microelectronics.

  Please go through Documentation/SubmitChecklist and make use of
scripts/checkpatch.pl.  This patch is far from meeting those standards.

> If you have a TPM security chip from STMicroelectronics working with
> an I2C/SPI, in menuconfig or .config choose the tpm driver on
> device --> tpm and activate the protocol of your choice before compiling
> the kernel.
> The driver will be accessible from within Linux.
> 
> Tested on linux x86/x64 and beagleboard REV B & XM REV C
> 
> Signed-off-by: Mathias Leblanc <mathias.leblanc@st.com>
> ---
>  arch/arm/mach-omap2/board-omap3beagle.c |   58 ++
>  drivers/char/tpm/Kconfig                |   32 +-
>  drivers/char/tpm/Makefile               |    2 +
>  drivers/char/tpm/tpm_stm_st19_i2c.c     |  560 ++++++++++++++
>  drivers/char/tpm/tpm_stm_st19_i2c.h     |   52 ++
>  drivers/char/tpm/tpm_stm_st33_i2c.c     | 1200 +++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm_stm_st33_i2c.h     |   76 ++
>  drivers/char/tpm/tpm_stm_st33_spi.c     | 1285 +++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm_stm_st33_spi.h     |   80 ++
>  include/linux/i2c/tpm_stm_st19_i2c.h    |   42 +
>  include/linux/i2c/tpm_stm_st33_i2c.h    |   48 ++
>  include/linux/spi/tpm_stm_st33_spi.h    |   46 ++
>  12 files changed, 3473 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm_stm_st19_i2c.c
>  create mode 100644 drivers/char/tpm/tpm_stm_st19_i2c.h
>  create mode 100644 drivers/char/tpm/tpm_stm_st33_i2c.c
>  create mode 100644 drivers/char/tpm/tpm_stm_st33_i2c.h
>  create mode 100644 drivers/char/tpm/tpm_stm_st33_spi.c
>  create mode 100644 drivers/char/tpm/tpm_stm_st33_spi.h
>  create mode 100644 include/linux/i2c/tpm_stm_st19_i2c.h
>  create mode 100644 include/linux/i2c/tpm_stm_st33_i2c.h
>  create mode 100644 include/linux/spi/tpm_stm_st33_spi.h

  Please break up the patch into at least 4 patches, the spi driver, the
i2c driver the build stuff and then the additions to the beagle board
code.

[cut]
> 
> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> index a048199..7384c93 100644
> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -5,6 +5,7 @@
>  menuconfig TCG_TPM
>  	tristate "TPM Hardware Support"
>  	depends on HAS_IOMEM
> +	depends on EXPERIMENTAL

  This makes all TPM drivers experimental. Please move this into the
config options for your drivers specifically so that only they are
experimental.

>  	select SECURITYFS
>  	---help---
>  	  If you have a TPM security chip in your system, which
> @@ -16,17 +17,14 @@ menuconfig TCG_TPM
>  	  obtained at: <http://sourceforge.net/projects/trousers>.  To 
>  	  compile this driver as a module, choose M here; the module 
>  	  will be called tpm. If unsure, say N.
> -	  Notes:
> -	  1) For more TPM drivers enable CONFIG_PNP, CONFIG_ACPI
> +	  Note: For more TPM drivers enable CONFIG_PNP, CONFIG_ACPI
>  	  and CONFIG_PNPACPI.
> -	  2) Without ACPI enabled, the BIOS event log won't be accessible,
> -	  which is required to validate the PCR 0-7 values.
> 
>  if TCG_TPM
> 
>  config TCG_TIS
>  	tristate "TPM Interface Specification 1.2 Interface"
> -	depends on X86
> +	depends on PNP

  I don't think this is correct, PNP is optional for tis.

>  	---help---
>  	  If you have a TPM security chip that is compliant with the
>  	  TCG TIS 1.2 TPM specification say Yes and it will be accessible
> @@ -35,7 +33,6 @@ config TCG_TIS
> 
>  config TCG_NSC
>  	tristate "National Semiconductor TPM Interface"
> -	depends on X86

  This needs to stay.  Non-tis drivers are for 1.1 TPMs that have only
been tested on their arch AFAIK. Unless you can provide a Tested-by: for
this, I'll NACK it.

>  	---help---
>  	  If you have a TPM security chip from National Semiconductor 
>  	  say Yes and it will be accessible from within Linux.  To 
> @@ -44,7 +41,6 @@ config TCG_NSC
> 
>  config TCG_ATMEL
>  	tristate "Atmel TPM Interface"
> -	depends on PPC64 || HAS_IOPORT

  same as above.

>  	---help---
>  	  If you have a TPM security chip from Atmel say Yes and it 
>  	  will be accessible from within Linux.  To compile this driver 
> @@ -60,6 +56,26 @@ config TCG_INFINEON
>  	  To compile this driver as a module, choose M here; the module
>  	  will be called tpm_infineon.
>  	  Further information on this driver and the supported hardware
> -	  can be found at http://www.trust.rub.de/projects/linux-device-driver-infineon-tpm/ 
> +	  can be found at http://www.prosec.rub.de/tpm
> +
> +config TCG_ST33_I2C
> +        tristate "STMicroelectronics ST33 I2C TPM with locality 0 & 4"

  Is "with locality 0 & 4" relevent here?

> +        depends on I2C
> +        depends on GPIOLIB
> +        ---help---
> +        If you have a TPM security chip from STMicroelectronics working with
> +        an I2C bus say Yes and it will be accessible from within Linux.
> +        To compile this driver as a module, choose M here; the module will be
> +        called tpm_stm_st33_i2c.
> +
> +config TCG_ST33_SPI
> +	tristate "STMicroelectronics ST33 SPI"
> +	depends on SPI
> +	depends on GPIOLIB
> +	---help---
> +	If you have a TPM security chip from STMicroelectronics working with
> +	an SPI bus say Yes and it will be accessible from within Linux.
> +	To compile this driver as a module, choose M here; the module will be
> +	called tpm_stm_st33_spi.
> 
>  endif # TCG_TPM
> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index ea3a1e0..8d3449f 100644
> --- a/drivers/char/tpm/Makefile
> +++ b/drivers/char/tpm/Makefile
> @@ -9,3 +9,5 @@ obj-$(CONFIG_TCG_TIS) += tpm_tis.o
>  obj-$(CONFIG_TCG_NSC) += tpm_nsc.o
>  obj-$(CONFIG_TCG_ATMEL) += tpm_atmel.o
>  obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
> +obj-$(CONFIG_TCG_ST33_I2C) += tpm_stm_st33_i2c.o
> +obj-$(CONFIG_TCG_ST33_SPI) += tpm_stm_st33_spi.o 

  EOL white space - please read Documentation/CodingStyle.

[cut]

> +
> +#include <linux/i2c/tpm_stm_st19_i2c.h>
> +
> +#include "tpm.h"
> +
> +#include "tpm_stm_st19_i2c.h"
> +
> +#ifdef DEBUG
> +#define FUNC_ENTER() pr_info("%s\n", __func__)
> +#else
> +#define FUNC_ENTER() do {} while (0)
> +#endif

 Please remove FUNC_ENTER or replace with direct calls to pr_debug().

[cut]
> +static int tpm_stm_i2c_send(struct tpm_chip *chip, unsigned char *buf,
> +			    size_t count)
> +{
> +	u32 ret = 0, i, size, ordinal;
> +	struct i2c_client *client;
> +
> +	FUNC_ENTER();
> +
> +	if (chip == NULL)
> +		return -EBUSY;
> +
> +	if (count < TPM_HEADER_SIZE)
> +		return -EBUSY;
> +	client = (struct i2c_client *)pin_infos->client;
> +
> +	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));

 ordinal looks to be set but unused.

[cut]
> +static const struct file_operations tpm_st19_i2c_fops = {
> +	.owner = THIS_MODULE,
> +	.llseek = no_llseek,
> +	.read = tpm_read,
> +	.unlocked_ioctl = tpm_stm_i2c_ioctl,
> +	.write = tpm_write,
> +	.open = tpm_open,
> +	.release = tpm_release,
> +};

  trousers doesn't need an ioctl path - do you have another user for it?
Otherwise please remove the ioctl stuff.

[cut]
> +//static DEFINE_SPINLOCK(tpm_stm_st33_lock);

  Please remove any commented-out code.

[cut]
> +#define wait_for_serirq_timeout(chip, condition, timeout) \
> +({ \
> +        unsigned long status = 2; \
> +        struct i2c_client *client; \
> +        struct st33zp24_platform_data* pin_infos; \
> +\
> +        client = (struct i2c_client *) chip->vendor.iobase; \
> +        pin_infos = client->dev.platform_data;  \
> +\
> +        status = _wait_for_interrupt_serirq_timeout(chip, timeout); \
> +        if (!status) \
> +        { \
> +                status = -EBUSY; \
> +                goto wait_end; \
> +        } \
> +        clear_interruption(client);     \
> +        if (condition) \
> +                status = 1; \
> +\
> +wait_end: \
> +        status;\
> +}) 

  Please use do { } while (0) per Documentation/CodingStyle.

  I'm gonna stop here for now. There's quite a bit of work TBD on these
drivers based on the kernel coding standards alone.

Kent

