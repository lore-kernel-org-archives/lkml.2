Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab2HUQMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:12:08 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51335 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab2HUQMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:12:05 -0400
MIME-Version: 1.0
In-Reply-To: <1345564813-11895-2-git-send-email-stigge@antcom.de>
References: <1345564813-11895-1-git-send-email-stigge@antcom.de>
	<1345564813-11895-2-git-send-email-stigge@antcom.de>
Date: Tue, 21 Aug 2012 13:12:04 -0300
Message-ID: <CAAAP30HEXcsNxDTeaeiiMh4ya3t0riPvmpycmCgArWF5ajz1+A@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] spi/pl022: Add chip select handling via GPIO
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: linus.walleij@linaro.org, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        gabriel.fernandez@stericsson.com, lee.jones@linaro.org,
        viresh.kumar@linaro.org, sachin.verma@st.co
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 1:00 PM, Roland Stigge <stigge@antcom.de> wrote:
> This patch adds the ability for the driver to control the chip select directly.
> This enables independence from cs_control callbacks.  Configurable via
> platform_data, to be extended as DT in the following patch.
>
> Based on the initial patch by Alexandre Pereira da Silva <aletes.xgr@gmail.com>
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-By: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

> ---
> Applies to v3.6-rc2
>
> Patch set changes since v4:
> * Rename DT property: "pl022,num-chipselects" -> "num-cs"
> * Removed reference to Linux code in DT binding documentation
> * Removed property "pl022,hierarchy" - only support SPI master for now
> * Documented DT property pl022,interface
> * Removed property "pl022,slave-tx-disable" - not relevant in master mode
> * Added kerneldoc for cur_cs and chipselect list
> * Reorganized struct pl022 (int *chipselect)
> * Introduced int *chipselects to struct pl022_ssp_controller
> * Let platform data override DT data
> * Split patches into CS handling vs. DT support
>
> Changes since v3:
> * Proper use of IS_ENABLED
>
> Changes since v2:
> * Use IS_ENABLED instead of #ifdef
> * Remove bogus const change
>
> Changes since v1:
> * return EPROBE_DEFFER if gpios are not initialized yet
>
> Thanks Thierry Reding, Rob Herring and Linus Walleij for reviewing!
>
>  drivers/spi/spi-pl022.c    |   47 +++++++++++++++++++++++++++++++--------------
>  include/linux/amba/pl022.h |    2 +
>  2 files changed, 35 insertions(+), 14 deletions(-)
>
> --- linux-2.6.orig/drivers/spi/spi-pl022.c
> +++ linux-2.6/drivers/spi/spi-pl022.c
> @@ -40,6 +40,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/scatterlist.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/gpio.h>
>
>  /*
>   * This macro is used to define some register default values.
> @@ -356,6 +357,8 @@ struct vendor_data {
>   * @sgt_rx: scattertable for the RX transfer
>   * @sgt_tx: scattertable for the TX transfer
>   * @dummypage: a dummy page used for driving data on the bus with DMA
> + * @cur_cs: current chip select (gpio)
> + * @chipselect: list of chipselects (gpios)
>   */
>  struct pl022 {
>         struct amba_device              *adev;
> @@ -389,6 +392,8 @@ struct pl022 {
>         char                            *dummypage;
>         bool                            dma_running;
>  #endif
> +       int cur_cs;
> +       int *chipselect;
>  };
>
>  /**
> @@ -433,6 +438,14 @@ static void null_cs_control(u32 command)
>         pr_debug("pl022: dummy chip select control, CS=0x%x\n", command);
>  }
>
> +static void pl022_cs_control(struct pl022 *pl022, u32 command)
> +{
> +       if (gpio_is_valid(pl022->cur_cs))
> +               gpio_set_value(pl022->cur_cs, command);
> +       else
> +               pl022->cur_chip->cs_control(command);
> +}
> +
>  /**
>   * giveback - current spi_message is over, schedule next message and call
>   * callback of this message. Assumes that caller already
> @@ -479,7 +492,7 @@ static void giveback(struct pl022 *pl022
>                 if (next_msg && next_msg->spi != pl022->cur_msg->spi)
>                         next_msg = NULL;
>                 if (!next_msg || pl022->cur_msg->state == STATE_ERROR)
> -                       pl022->cur_chip->cs_control(SSP_CHIP_DESELECT);
> +                       pl022_cs_control(pl022, SSP_CHIP_DESELECT);
>                 else
>                         pl022->next_msg_cs_active = true;
>
> @@ -818,8 +831,7 @@ static void dma_callback(void *data)
>         /* Update total bytes transferred */
>         msg->actual_length += pl022->cur_transfer->len;
>         if (pl022->cur_transfer->cs_change)
> -               pl022->cur_chip->
> -                       cs_control(SSP_CHIP_DESELECT);
> +               pl022_cs_control(pl022, SSP_CHIP_DESELECT);
>
>         /* Move to next transfer */
>         msg->state = next_transfer(pl022);
> @@ -1252,8 +1264,7 @@ static irqreturn_t pl022_interrupt_handl
>                 /* Update total bytes transferred */
>                 msg->actual_length += pl022->cur_transfer->len;
>                 if (pl022->cur_transfer->cs_change)
> -                       pl022->cur_chip->
> -                               cs_control(SSP_CHIP_DESELECT);
> +                       pl022_cs_control(pl022, SSP_CHIP_DESELECT);
>                 /* Move to next transfer */
>                 msg->state = next_transfer(pl022);
>                 tasklet_schedule(&pl022->pump_transfers);
> @@ -1338,7 +1349,7 @@ static void pump_transfers(unsigned long
>
>                 /* Reselect chip select only if cs_change was requested */
>                 if (previous->cs_change)
> -                       pl022->cur_chip->cs_control(SSP_CHIP_SELECT);
> +                       pl022_cs_control(pl022, SSP_CHIP_SELECT);
>         } else {
>                 /* STATE_START */
>                 message->state = STATE_RUNNING;
> @@ -1377,7 +1388,7 @@ static void do_interrupt_dma_transfer(st
>
>         /* Enable target chip, if not already active */
>         if (!pl022->next_msg_cs_active)
> -               pl022->cur_chip->cs_control(SSP_CHIP_SELECT);
> +               pl022_cs_control(pl022, SSP_CHIP_SELECT);
>
>         if (set_up_next_transfer(pl022, pl022->cur_transfer)) {
>                 /* Error path */
> @@ -1429,12 +1440,12 @@ static void do_polling_transfer(struct p
>                         if (previous->delay_usecs)
>                                 udelay(previous->delay_usecs);
>                         if (previous->cs_change)
> -                               pl022->cur_chip->cs_control(SSP_CHIP_SELECT);
> +                               pl022_cs_control(pl022, SSP_CHIP_SELECT);
>                 } else {
>                         /* STATE_START */
>                         message->state = STATE_RUNNING;
>                         if (!pl022->next_msg_cs_active)
> -                               pl022->cur_chip->cs_control(SSP_CHIP_SELECT);
> +                               pl022_cs_control(pl022, SSP_CHIP_SELECT);
>                 }
>
>                 /* Configuration Changing Per Transfer */
> @@ -1466,7 +1477,7 @@ static void do_polling_transfer(struct p
>                 /* Update total byte transferred */
>                 message->actual_length += pl022->cur_transfer->len;
>                 if (pl022->cur_transfer->cs_change)
> -                       pl022->cur_chip->cs_control(SSP_CHIP_DESELECT);
> +                       pl022_cs_control(pl022, SSP_CHIP_DESELECT);
>                 /* Move to next transfer */
>                 message->state = next_transfer(pl022);
>         }
> @@ -1495,6 +1506,7 @@ static int pl022_transfer_one_message(st
>
>         /* Setup the SPI using the per chip configuration */
>         pl022->cur_chip = spi_get_ctldata(msg->spi);
> +       pl022->cur_cs = pl022->chipselect[msg->spi->chip_select];
>
>         restore_state(pl022);
>         flush(pl022);
> @@ -1840,8 +1852,9 @@ static int pl022_setup(struct spi_device
>         chip->xfer_type = chip_info->com_mode;
>         if (!chip_info->cs_control) {
>                 chip->cs_control = null_cs_control;
> -               dev_warn(&spi->dev,
> -                        "chip select function is NULL for this chip\n");
> +               if (!gpio_is_valid(pl022->chipselect[spi->chip_select]))
> +                       dev_warn(&spi->dev,
> +                                "chip select function is NULL for this chip\n");
>         } else
>                 chip->cs_control = chip_info->cs_control;
>
> @@ -1993,7 +2006,7 @@ pl022_probe(struct amba_device *adev, co
>         struct pl022_ssp_controller *platform_info = adev->dev.platform_data;
>         struct spi_master *master;
>         struct pl022 *pl022 = NULL;     /*Data for this driver */
> -       int status = 0;
> +       int status = 0, i;
>
>         dev_info(&adev->dev,
>                  "ARM PL022 driver, device ID: 0x%08x\n", adev->periphid);
> @@ -2004,7 +2017,8 @@ pl022_probe(struct amba_device *adev, co
>         }
>
>         /* Allocate master with space for data */
> -       master = spi_alloc_master(dev, sizeof(struct pl022));
> +       master = spi_alloc_master(dev, sizeof(struct pl022) + sizeof(int) *
> +                                 platform_info->num_chipselect);
>         if (master == NULL) {
>                 dev_err(&adev->dev, "probe - cannot alloc SPI master\n");
>                 status = -ENOMEM;
> @@ -2016,6 +2030,7 @@ pl022_probe(struct amba_device *adev, co
>         pl022->master_info = platform_info;
>         pl022->adev = adev;
>         pl022->vendor = id->data;
> +       pl022->chipselect = (int *)&master[1];
>
>         /*
>          * Bus Number Which has been Assigned to this SSP controller
> @@ -2030,6 +2045,10 @@ pl022_probe(struct amba_device *adev, co
>         master->unprepare_transfer_hardware = pl022_unprepare_transfer_hardware;
>         master->rt = platform_info->rt;
>
> +       if (platform_info->num_chipselect && platform_info->chipselects)
> +               for (i = 0; i < platform_info->num_chipselect; i++)
> +                       pl022->chipselect[i] = platform_info->chipselects[i];
> +
>         /*
>          * Supports mode 0-3, loopback, and active low CS. Transfers are
>          * always MS bit first on the original pl022.
> --- linux-2.6.orig/include/linux/amba/pl022.h
> +++ linux-2.6/include/linux/amba/pl022.h
> @@ -244,6 +244,7 @@ struct dma_chan;
>   *     indicates no delay and the device will be suspended immediately.
>   * @rt: indicates the controller should run the message pump with realtime
>   *     priority to minimise the transfer latency on the bus.
> + * @chipselects: list of <num_chipselects> chip select gpios
>   */
>  struct pl022_ssp_controller {
>         u16 bus_id;
> @@ -254,6 +255,7 @@ struct pl022_ssp_controller {
>         void *dma_tx_param;
>         int autosuspend_delay;
>         bool rt;
> +       int *chipselects;
>  };
>
>  /**
