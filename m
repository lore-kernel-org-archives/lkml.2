Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab2ENFqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 01:46:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34832 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2ENFqi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 01:46:38 -0400
MIME-Version: 1.0
In-Reply-To: <1336772086-17248-3-git-send-email-ddaney.cavm@gmail.com>
References: <1336772086-17248-1-git-send-email-ddaney.cavm@gmail.com>
	<1336772086-17248-3-git-send-email-ddaney.cavm@gmail.com>
Date: Mon, 14 May 2012 11:16:37 +0530
Message-ID: <CAM=Q2csSQWbCOCQpubDok1=hmPvHU0MTEUg+-FGhp91=O5L6Hw@mail.gmail.com>
Subject: Re: [PATCH 2/2] spi: Add SPI master controller for OCTEON SOCs.
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net, linux-mips@linux-mips.org,
        David Daney <david.daney@cavium.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,
A few comments.

On Sat, May 12, 2012 at 3:04 AM, David Daney <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
>
> Add the driver, link it into the kbuild system and provide device tree
> binding documentation.
>
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  .../devicetree/bindings/spi/spi-octeon.txt         |   33 ++
>  drivers/spi/Kconfig                                |    7 +
>  drivers/spi/Makefile                               |    1 +
>  drivers/spi/spi-octeon.c                           |  369 ++++++++++++++++++++
>  4 files changed, 410 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/spi/spi-octeon.txt
>  create mode 100644 drivers/spi/spi-octeon.c
>
> diff --git a/Documentation/devicetree/bindings/spi/spi-octeon.txt b/Documentation/devicetree/bindings/spi/spi-octeon.txt
> new file mode 100644
> index 0000000..431add1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/spi/spi-octeon.txt
> @@ -0,0 +1,33 @@
> +Cavium, Inc. OCTEON SOC SPI master controller.
> +
> +Required properties:
> +- compatible : "cavium,octeon-3010-spi"
> +- reg : The register base for the controller.
> +- interrupts : One interrupt, used by the controller.
> +- #address-cells : <1>, as required by generic SPI binding.
> +- #size-cells : <0>, also as required by generic SPI binding.
> +
> +Child nodes as per the generic SPI binding.
> +
> +Example:
> +
> +       spi@1070000001000 {
> +               compatible = "cavium,octeon-3010-spi";
> +               reg = <0x10700 0x00001000 0x0 0x100>;
> +               interrupts = <0 58>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               eeprom@0 {
> +                       compatible = "st,m95256", "atmel,at25";
> +                       reg = <0>;
> +                       spi-max-frequency = <5000000>;
> +                       spi-cpha;
> +                       spi-cpol;
> +
> +                       pagesize = <64>;
> +                       size = <32768>;
> +                       address-width = <16>;
> +               };
> +       };
> +
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> index 00c0240..e1dd0d0 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -228,6 +228,13 @@ config SPI_OC_TINY
>        help
>          This is the driver for OpenCores tiny SPI master controller.
>
> +config SPI_OCTEON
> +       tristate "Cavium OCTEON SPI controller"
> +       depends on CPU_CAVIUM_OCTEON
> +       help
> +         SPI host driver for the hardware found on some Cavium OCTEON
> +         SOCs.
> +
>  config SPI_OMAP_UWIRE
>        tristate "OMAP1 MicroWire"
>        depends on ARCH_OMAP1
> diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
> index 9d75d21..c7f8b71 100644
> --- a/drivers/spi/Makefile
> +++ b/drivers/spi/Makefile
> @@ -37,6 +37,7 @@ obj-$(CONFIG_SPI_MPC52xx_PSC)         += spi-mpc52xx-psc.o
>  obj-$(CONFIG_SPI_MPC52xx)              += spi-mpc52xx.o
>  obj-$(CONFIG_SPI_NUC900)               += spi-nuc900.o
>  obj-$(CONFIG_SPI_OC_TINY)              += spi-oc-tiny.o
> +obj-$(CONFIG_SPI_OCTEON)               += spi-octeon.o
>  obj-$(CONFIG_SPI_OMAP_UWIRE)           += spi-omap-uwire.o
>  obj-$(CONFIG_SPI_OMAP_100K)            += spi-omap-100k.o
>  obj-$(CONFIG_SPI_OMAP24XX)             += spi-omap2-mcspi.o
> diff --git a/drivers/spi/spi-octeon.c b/drivers/spi/spi-octeon.c
> new file mode 100644
> index 0000000..7207aaf
> --- /dev/null
> +++ b/drivers/spi/spi-octeon.c
> @@ -0,0 +1,369 @@
> +/*
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + *
> + * Copyright (C) 2011, 2012 Cavium, Inc.
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <linux/spi/spi.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/of_spi.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +
> +#include <asm/octeon/octeon.h>
> +#include <asm/octeon/cvmx-mpi-defs.h>
> +
> +#define DRV_VERSION "2.0" /* Version 1 was the out-of-tree driver */
This could be given a miss. As it is less meaningful once accepted.

> +#define DRV_DESCRIPTION "Cavium, Inc. OCTEON SPI bus driver"
> +
> +
> +#define OCTEON_SPI_CFG 0
> +#define OCTEON_SPI_STS 0x08
> +#define OCTEON_SPI_TX 0x10
> +#define OCTEON_SPI_DAT0 0x80
> +
> +#define OCTEON_SPI_MAX_BYTES 9
> +
> +#define OCTEON_SPI_MAX_CLOCK_HZ 16000000
> +
> +struct octeon_spi {
> +       struct spi_master *my_master;
> +       u64 register_base;
> +       u64 last_cfg;
> +       u64 cs_enax;
> +};
> +
> +struct octeon_spi_setup {
> +       u32 max_speed_hz;
> +       u8 chip_select;
> +       u8 mode;
> +       u8 bits_per_word;
> +};
> +
> +static void octeon_spi_wait_ready(struct octeon_spi *p)
> +{
> +       union cvmx_mpi_sts mpi_sts;
> +       unsigned int loops = 0;
> +
> +       do {
> +               if (loops++)
> +                       __delay(500);
Could we allow  have a non-busy loop here?
