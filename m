Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1BNRNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:13:24 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48530 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab1BNRNW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:13:22 -0500
MIME-Version: 1.0
In-Reply-To: <1297699964-20527-1-git-send-email-jacmet@sunsite.dk>
References: <1297699964-20527-1-git-send-email-jacmet@sunsite.dk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 14 Feb 2011 10:13:01 -0700
X-Google-Sender-Auth: r_GwvzoIs4Nx-bRBUUm__HrLIuQ
Message-ID: <AANLkTi=pWV+tfD6YGpKbzTkvLVoLXtGA41QRaaF=VFeq@mail.gmail.com>
Subject: Re: [PATCH] mcp23s08: support mcp23s17 variant
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 9:12 AM, Peter Korsgaard <jacmet@sunsite.dk> wrote:
> mpc23s17 is very similar to the mcp23s08, except that registers are 16bit
> wide, so extend the interface to work with both variants.
>
> The s17 variant also has an additional address pin, so adjust platform
> data structure to support up to 8 devices per SPI chipselect.
>
> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
> ---
>  drivers/gpio/Kconfig         |    6 +-
>  drivers/gpio/mcp23s08.c      |  147 +++++++++++++++++++++++++++++-------------
>  include/linux/spi/mcp23s08.h |   15 +++--
>  3 files changed, 113 insertions(+), 55 deletions(-)
>
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 664660e..9573b33 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -368,11 +368,11 @@ config GPIO_MAX7301
>          GPIO driver for Maxim MAX7301 SPI-based GPIO expander.
>
>  config GPIO_MCP23S08
> -       tristate "Microchip MCP23S08 I/O expander"
> +       tristate "Microchip MCP23Sxx I/O expander"
>        depends on SPI_MASTER
>        help
> -         SPI driver for Microchip MCP23S08 I/O expander.  This provides
> -         a GPIO interface supporting inputs and outputs.
> +         SPI driver for Microchip MCP23S08/MPC23S17 I/O expanders.
> +         This provides a GPIO interface supporting inputs and outputs.
>
>  config GPIO_MC33880
>        tristate "Freescale MC33880 high-side/low-side switch"
> diff --git a/drivers/gpio/mcp23s08.c b/drivers/gpio/mcp23s08.c
> index 69f6f19..497e527 100644
> --- a/drivers/gpio/mcp23s08.c
> +++ b/drivers/gpio/mcp23s08.c
> @@ -10,7 +10,13 @@
>  #include <linux/spi/spi.h>
>  #include <linux/spi/mcp23s08.h>
>  #include <linux/slab.h>
> +#include <asm/byteorder.h>
>
> +/**
> + * MCP types supported by driver
> + */
> +#define MCP_TYPE_S08   0
> +#define MCP_TYPE_S17   1
>
>  /* Registers are all 8 bits wide.
>  *
> @@ -38,8 +44,9 @@
>  struct mcp23s08 {
>        struct spi_device       *spi;
>        u8                      addr;
> +       u8                      type;
>
> -       u8                      cache[11];
> +       u16                     cache[11];
>        /* lock protects the cached values */
>        struct mutex            lock;
>
> @@ -48,48 +55,83 @@ struct mcp23s08 {
>        struct work_struct      work;
>  };
>
> -/* A given spi_device can represent up to four mcp23s08 chips
> +/* A given spi_device can represent up to eight mcp23sxx chips
>  * sharing the same chipselect but using different addresses
>  * (e.g. chips #0 and #3 might be populated, but not #1 or $2).
>  * Driver data holds all the per-chip data.
>  */
>  struct mcp23s08_driver_data {
>        unsigned                ngpio;
> -       struct mcp23s08         *mcp[4];
> +       struct mcp23s08         *mcp[8];
>        struct mcp23s08         chip[];
>  };
>
>  static int mcp23s08_read(struct mcp23s08 *mcp, unsigned reg)
>  {
> -       u8      tx[2], rx[1];
> +       u8      tx[2], rx[2];
>        int     status;
>
>        tx[0] = mcp->addr | 0x01;
>        tx[1] = reg;
> -       status = spi_write_then_read(mcp->spi, tx, sizeof tx, rx, sizeof rx);
> -       return (status < 0) ? status : rx[0];
> +
> +       if (mcp->type == MCP_TYPE_S17) {
> +               tx[1] <<= 1;
> +
> +               status = spi_write_then_read(mcp->spi, tx, sizeof tx, rx, 2);
> +               return (status < 0) ? status : (rx[0] | (rx[1] << 8));
> +       } else {
> +               status = spi_write_then_read(mcp->spi, tx, sizeof tx, rx, 1);
> +               return (status < 0) ? status : rx[0];
> +       }

Rather than checking ->type for every transaction, would a set of
callbacks for each type be better?  It would probably have lower
overhead and be simpler to maintain.

[...]
> diff --git a/include/linux/spi/mcp23s08.h b/include/linux/spi/mcp23s08.h
> index 22ef107..c42cff8 100644
> --- a/include/linux/spi/mcp23s08.h
> +++ b/include/linux/spi/mcp23s08.h
> @@ -2,21 +2,24 @@
>  /* FIXME driver should be able to handle IRQs...  */
>
>  struct mcp23s08_chip_info {
> -       bool    is_present;             /* true iff populated */
> -       u8      pullups;                /* BIT(x) means enable pullup x */
> +       bool            is_present;     /* true if populated */
> +       unsigned        pullups;        /* BIT(x) means enable pullup x */
>  };

Unrelated whitespace changes.
