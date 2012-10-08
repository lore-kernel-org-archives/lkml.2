Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab2JHCin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 22:38:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54087 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2JHCil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 22:38:41 -0400
MIME-Version: 1.0
In-Reply-To: <1349195816-2225-6-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de> <1349195816-2225-6-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 8 Oct 2012 10:38:19 +0800
Message-ID: <CAMPhdO_HYzn1nJfDoiCYU5oxfk-BL0t=0VeLCPYESb1_jzV_yQ@mail.gmail.com>
Subject: Re: [PATCH 05/17] ARM: pxa: remove sharpsl_fatal_check function
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Stanislav Brabec <utx@penguin.cz>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 12:36 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> The sharpsl_fatal_check has not been used since Pavel Machek removed
> the caller in 99f329a2b "pxa/sharpsl_pm: zaurus c3000 aka spitz: fix
> resume". Nobody has complained since 2009, so it's safe to assume we
> can just remove the function.
>
> Without this patch, building corgi_defconfig results in:
>
> /home/arnd/linux-arm/arch/arm/mach-pxa/sharpsl_pm.c:693:12: warning: 'sharpsl_fatal_check' defined but not used [-Wunused-function]
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Stanislav Brabec <utx@penguin.cz>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

Let's get it cleaned up firstly. One can always reference the history for a
sample implementation later if this is needed in the future.

> ---
>  arch/arm/mach-pxa/sharpsl_pm.c |   48 ----------------------------------------
>  1 file changed, 48 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
> index bdf4cb8..6c9658f 100644
> --- a/arch/arm/mach-pxa/sharpsl_pm.c
> +++ b/arch/arm/mach-pxa/sharpsl_pm.c
> @@ -55,7 +55,6 @@
>  #ifdef CONFIG_PM
>  static int sharpsl_off_charge_battery(void);
>  static int sharpsl_check_battery_voltage(void);
> -static int sharpsl_fatal_check(void);
>  #endif
>  static int sharpsl_check_battery_temp(void);
>  static int sharpsl_ac_check(void);
> @@ -686,53 +685,6 @@ static int corgi_pxa_pm_enter(suspend_state_t state)
>         return 0;
>  }
>
> -/*
> - * Check for fatal battery errors
> - * Fatal returns -1
> - */
> -static int sharpsl_fatal_check(void)
> -{
> -       int buff[5], temp, i, acin;
> -
> -       dev_dbg(sharpsl_pm.dev, "sharpsl_fatal_check entered\n");
> -
> -       /* Check AC-Adapter */
> -       acin = sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN);
> -
> -       if (acin && (sharpsl_pm.charge_mode == CHRG_ON)) {
> -               sharpsl_pm.machinfo->charge(0);
> -               udelay(100);
> -               sharpsl_pm.machinfo->discharge(1);      /* enable discharge */
> -               mdelay(SHARPSL_WAIT_DISCHARGE_ON);
> -       }
> -
> -       if (sharpsl_pm.machinfo->discharge1)
> -               sharpsl_pm.machinfo->discharge1(1);
> -
> -       /* Check battery : check inserting battery ? */
> -       for (i = 0; i < 5; i++) {
> -               buff[i] = sharpsl_pm.machinfo->read_devdata(SHARPSL_BATT_VOLT);
> -               mdelay(SHARPSL_CHECK_BATTERY_WAIT_TIME_VOLT);
> -       }
> -
> -       if (sharpsl_pm.machinfo->discharge1)
> -               sharpsl_pm.machinfo->discharge1(0);
> -
> -       if (acin && (sharpsl_pm.charge_mode == CHRG_ON)) {
> -               udelay(100);
> -               sharpsl_pm.machinfo->charge(1);
> -               sharpsl_pm.machinfo->discharge(0);
> -       }
> -
> -       temp = get_select_val(buff);
> -       dev_dbg(sharpsl_pm.dev, "sharpsl_fatal_check: acin: %d, discharge voltage: %d, no discharge: %ld\n", acin, temp, sharpsl_pm.machinfo->read_devdata(SHARPSL_BATT_VOLT));
> -
> -       if ((acin && (temp < sharpsl_pm.machinfo->fatal_acin_volt)) ||
> -                       (!acin && (temp < sharpsl_pm.machinfo->fatal_noacin_volt)))
> -               return -1;
> -       return 0;
> -}
> -
>  static int sharpsl_off_charge_error(void)
>  {
>         dev_err(sharpsl_pm.dev, "Offline Charger: Error occurred.\n");
> --
> 1.7.10
>
