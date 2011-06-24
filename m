Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab1FXG3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 02:29:13 -0400
Received: from na3sys009aob119.obsmtp.com ([74.125.149.245]:36397 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751974Ab1FXG3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 02:29:11 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jun 2011 02:29:09 EDT
MIME-Version: 1.0
In-Reply-To: <1308862894-13802-1-git-send-email-jaswinder.singh@linaro.org>
References: <1308862894-13802-1-git-send-email-jaswinder.singh@linaro.org>
Date: Fri, 24 Jun 2011 11:52:25 +0530
Message-ID: <BANLkTikFFUREhKyPaZrhHZje0KeaA3ef8Q@mail.gmail.com>
Subject: Re: [PATCH] mfd: omap: Restore TLL initialization
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: linux-kernel@vger.kernel.org, ti@lists.linaro.org, parthab@india.ti.com,
        sameo@linux.intel.com, gadiyar@ti.com, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
        Jassi Brar <jaswinder.singh@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 2:31 AM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> The commit
>  7e6502d577106fb5b202bbaac64c5f1b065 'mfd: Add omap-usbhs runtime PM support'
> besides moving to RPM, removes necessary TLL initialization as well.
>
> Restore the TLL initialization, without which device detection fails.
>
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
> ---
>  drivers/mfd/omap-usb-host.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 42 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 8552195..12ca77b 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -640,6 +640,7 @@ static int usbhs_enable(struct device *dev)
>        struct usbhs_omap_platform_data *pdata = &omap->platdata;
>        unsigned long                   flags = 0;
>        int                             ret = 0;
> +       unsigned long                   timeout;
>        unsigned                        reg;
>
>        dev_dbg(dev, "starting TI HSUSB Controller\n");
> @@ -676,6 +677,47 @@ static int usbhs_enable(struct device *dev)
>        omap->usbhs_rev = usbhs_read(omap->uhh_base, OMAP_UHH_REVISION);
>        dev_dbg(dev, "OMAP UHH_REVISION 0x%x\n", omap->usbhs_rev);
>
> +       /* perform TLL soft reset, and wait until reset is complete */
> +       usbhs_write(omap->tll_base, OMAP_USBTLL_SYSCONFIG,
> +                       OMAP_USBTLL_SYSCONFIG_SOFTRESET);
> +
> +       /* Wait for TLL reset to complete */
> +       timeout = jiffies + msecs_to_jiffies(1000);
> +       while (!(usbhs_read(omap->tll_base, OMAP_USBTLL_SYSSTATUS)
> +                       & OMAP_USBTLL_SYSSTATUS_RESETDONE)) {
> +               cpu_relax();
> +
> +               if (time_after(jiffies, timeout)) {
> +                       dev_dbg(dev, "operation timed out\n");
> +                       ret = -EINVAL;
> +                       goto err_tll;
> +               }
> +       }
> +       dev_dbg(dev, "TLL RESET DONE\n");
> +
> +       /* (1<<3) = no idle mode only for initial debugging */
> +       usbhs_write(omap->tll_base, OMAP_USBTLL_SYSCONFIG,
> +                       OMAP_USBTLL_SYSCONFIG_ENAWAKEUP |
> +                       OMAP_USBTLL_SYSCONFIG_SIDLEMODE |
> +                       OMAP_USBTLL_SYSCONFIG_AUTOIDLE);
> +
> +       /* Put UHH in NoIdle/NoStandby mode */
> +       reg = usbhs_read(omap->uhh_base, OMAP_UHH_SYSCONFIG);
> +       if (is_omap_usbhs_rev1(omap)) {
> +               reg |= (OMAP_UHH_SYSCONFIG_ENAWAKEUP
> +                               | OMAP_UHH_SYSCONFIG_SIDLEMODE
> +                               | OMAP_UHH_SYSCONFIG_CACTIVITY
> +                               | OMAP_UHH_SYSCONFIG_MIDLEMODE);
> +               reg &= ~OMAP_UHH_SYSCONFIG_AUTOIDLE;
> +       } else if (is_omap_usbhs_rev2(omap)) {
> +               reg &= ~OMAP4_UHH_SYSCONFIG_IDLEMODE_CLEAR;
> +               reg |= OMAP4_UHH_SYSCONFIG_NOIDLE;
> +               reg &= ~OMAP4_UHH_SYSCONFIG_STDBYMODE_CLEAR;
> +               reg |= OMAP4_UHH_SYSCONFIG_NOSTDBY;
> +       }
> +
> +       usbhs_write(omap->uhh_base, OMAP_UHH_SYSCONFIG, reg);
> +
>        reg = usbhs_read(omap->uhh_base, OMAP_UHH_HOSTCONFIG);
>        /* setup ULPI bypass and burst configurations */
>        reg |= (OMAP_UHH_HOSTCONFIG_INCR4_BURST_EN
> --
> 1.7.4.1

if you move to RPM, you should'tn access these configuration/reset
registers in your driver.
moreover, the patch 'mfd: Add omap-usbhs runtime PM support' is
already reverted.

keshava
