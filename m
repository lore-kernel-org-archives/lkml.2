Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab1L3LNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 06:13:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41890 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1L3LNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 06:13:30 -0500
MIME-Version: 1.0
In-Reply-To: <20111230005849.11559.78948.stgit@notabene.brown>
References: <20111230004947.11559.81184.stgit@notabene.brown>
	<20111230005849.11559.78948.stgit@notabene.brown>
Date: Fri, 30 Dec 2011 13:13:28 +0200
Message-ID: <CANOLnOM7QbF5aMb1iW0W2t6B1q1J+cROMU8SpD185DyC33w4kA@mail.gmail.com>
Subject: Re: [PATCH 5/5] bq27x00 - don't report power-supply change so often.
From: Grazvydas Ignotas <notasas@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing Lars who added this. I vaguely recall something about generating
events to make some battery monitors update but I forget the details
now, maybe it was about something else. Also CCing Anton (the
maintainer).

On Fri, Dec 30, 2011 at 2:58 AM, NeilBrown <neilb@suse.de> wrote:
> A power_supply_changed should only be reported on significant changes
> such as transition between charging and not.  Incremental changes
> such as charge increasing should not be reported - that can easily
> be polled for.
>
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>
>  drivers/power/bq27x00_battery.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index bb16f5b..7993a17 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -57,11 +57,15 @@
>  #define BQ27000_FLAG_CHGS              BIT(7)
>  #define BQ27000_FLAG_FC                        BIT(5)
>
> +#define BQ27000_FLAGS_IMPORTANT                (BQ27000_FLAG_FC|BQ27000_FLAG_CHGS|BIT(31))
> +
>  #define BQ27500_REG_SOC                        0x2C
>  #define BQ27500_REG_DCAP               0x3C /* Design capacity */
>  #define BQ27500_FLAG_DSC               BIT(0)
>  #define BQ27500_FLAG_FC                        BIT(9)
>
> +#define BQ27500_FLAGS_IMPORTANT                (BQ27500_FLAG_FC|BQ27500_FLAG_DSC|BIT(31))
> +
>  #define BQ27000_RS                     20 /* Resistor sense */
>
>  struct bq27x00_device_info;
> @@ -259,6 +263,7 @@ static void bq27x00_update(struct bq27x00_device_info *di)
>  {
>        struct bq27x00_reg_cache cache = {0, };
>        bool is_bq27500 = di->chip == BQ27500;
> +       int flags_changed;
>
>        cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, is_bq27500);
>        if (cache.flags >= 0) {
> @@ -280,10 +285,14 @@ static void bq27x00_update(struct bq27x00_device_info *di)
>
>        /* Ignore current_now which is a snapshot of the current battery state
>         * and is likely to be different even between two consecutive reads */
> -       if (memcmp(&di->cache, &cache, sizeof(cache) - sizeof(int)) != 0) {
> -               di->cache = cache;
> +       flags_changed = di->cache.flags ^ cache.flags;
> +       di->cache = cache;
> +       if (is_bq27500)
> +               flags_changed &= BQ27500_FLAGS_IMPORTANT;
> +       else
> +               flags_changed &= BQ27000_FLAGS_IMPORTANT;
> +       if (flags_changed)
>                power_supply_changed(&di->bat);
> -       }
>
>        di->last_update = jiffies;
>  }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Gražvydas
