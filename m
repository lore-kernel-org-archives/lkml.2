Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab2GUKkO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 06:40:14 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32804 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2GUKkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 06:40:12 -0400
MIME-Version: 1.0
In-Reply-To: <1342808038-7558-1-git-send-email-dianders@chromium.org>
References: <1342808038-7558-1-git-send-email-dianders@chromium.org>
Date: Sat, 21 Jul 2012 11:40:10 +0100
Message-ID: <CAFbHwiQh-Cwo4xo6-vCbvWsmz_cheZK1m3SnwkvSziunV1ShBA@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Disable low power mode if SDIO interrupts
 are used
From: Will Newton <will.newton@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        James Hogan <james.hogan@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 7:13 PM, Doug Anderson <dianders@chromium.org> wrote:
> The documentation for the dw_mmc part says that the low power
> mode should normally only be set for MMC and SD memory and should
> be turned off for SDIO cards that need interrupts detected.
>
> The best place I could find to do this is when the SDIO interrupt
> was first enabled.  I rely on the fact that dw_mci_setup_bus()
> will be called when it's time to reenable.
>
> Change-Id: Id0e33a4e3a0a77ce8a5053b6e73197d53a5d46bb
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc.c |   33 +++++++++++++++++++++++++++++++++
>  1 files changed, 33 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 72dc3cd..0cb2756 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -862,6 +862,31 @@ static int dw_mci_get_cd(struct mmc_host *mmc)
>         return present;
>  }
>
> +/*
> + * Disable lower power mode.
> + *
> + * Low power mode will stop the card clock when idle.  According to
> + * documentation we should disable low power mode for SDIO cards if we
> + * need interrupts to work.
> + *
> + * This function is fast if the power mode is already disabled.
> + */
> +static void dw_mci_disable_low_power(struct mmc_host *mmc)
> +{
> +       struct dw_mci_slot *slot = mmc_priv(mmc);
> +       struct dw_mci *host = slot->host;
> +       u32 clk_en_a;
> +       const u32 clken_low_pwr = SDMMC_CLKEN_LOW_PWR << slot->id;
> +
> +       clk_en_a = mci_readl(host, CLKENA);
> +
> +       if (clk_en_a & clken_low_pwr) {
> +               mci_writel(host, CLKENA, clk_en_a & ~clken_low_pwr);
> +               mci_send_cmd(slot, SDMMC_CMD_UPD_CLK |
> +                            SDMMC_CMD_PRV_DAT_WAIT, 0);
> +       }
> +}
> +
>  static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>  {
>         struct dw_mci_slot *slot = mmc_priv(mmc);
> @@ -871,6 +896,14 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>         /* Enable/disable Slot Specific SDIO interrupt */
>         int_mask = mci_readl(host, INTMASK);
>         if (enb) {
> +               /*
> +                * Turn off low power mode if it was enabled.  This is a bit of
> +                * a heavy operation and we disable / enable IRQs a lot, so
> +                * we'll leave them disabled; they will get re-enabled again in
> +                * dw_mci_setup_bus().
> +                */
> +               dw_mci_disable_low_power(mmc);
> +
>                 mci_writel(host, INTMASK,
>                            (int_mask | SDMMC_INT_SDIO(slot->id)));
>         } else {
> --
> 1.7.7.3

Is it safe to just disable low power here or could the setting be
overwritten in setup_bus?
