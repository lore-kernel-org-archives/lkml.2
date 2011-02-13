Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab1BMPOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 10:14:38 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35471 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1BMPOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 10:14:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nF/+oMMc3vBQg+wGK/s6X2WxgbI6jOBrGJMuJfbYFYrEVD5rWjpqbdzZANF8HS3uZ6
         EH0eqgyDW1xOSnnJXnte48fyFFnKi8mbXvJu0+iP7dQPJw44/jt7vGoL0CBAm84V7XpV
         5C8gJk4wQjVIgXt7o9CTaHg4VO1OfPcsaO77Q=
MIME-Version: 1.0
In-Reply-To: <1297539554-13957-8-git-send-email-lars@metafoo.de>
References: <1297539554-13957-1-git-send-email-lars@metafoo.de>
	<1297539554-13957-8-git-send-email-lars@metafoo.de>
Date: Sun, 13 Feb 2011 17:14:32 +0200
Message-ID: <AANLkTiks6Dy8az8qxNJm4UPzJSRSmFU0b+M6ipjSey3f@mail.gmail.com>
Subject: Re: [PATCH 07/14] bq27x00: Cache battery registers
From: Grazvydas Ignotas <notasas@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 9:39 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> This patch adds a register cache to the bq27x00 battery driver.
> Usually multiple, if not all, power_supply properties are queried at once,
> for example when an uevent is generated. Since some registers are used by
> multiple properties caching the registers should reduce the number of
> reads.
>
> The cache is valid for 5 seconds this roughly matches the internal update
> interval of the current register for the bq27000/bq27200.
>
> Fast changing properties(*_NOW) which can be obtained by reading a single
> register are not cached.
>
> It will also be used in the follow up patch to check if the battery status
> has been changed since the last update to emit power_supply_changed events.
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/power/bq27x00_battery.c |  272 +++++++++++++++++++++-----------------
>  1 files changed, 150 insertions(+), 122 deletions(-)
>
> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index 44bc76b..0c94693 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -19,7 +19,6 @@

<snip>

> +static void bq27x00_update(struct bq27x00_device_info *di)
> +{
> +       struct bq27x00_reg_cache cache = {0, };
> +       bool is_bq27500 = di->chip == BQ27500;
> +
> +       cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, is_bq27500);
> +       if (cache.flags >= 0) {
> +               cache.capacity = bq27x00_battery_read_rsoc(di);
> +               cache.temperature = bq27x00_read(di, BQ27x00_REG_TEMP, false);
> +               cache.time_to_empty = bq27x00_battery_read_time(di, BQ27x00_REG_TTE);
> +               cache.time_to_empty_avg = bq27x00_battery_read_time(di, BQ27x00_REG_TTECP);
> +               cache.time_to_full = bq27x00_battery_read_time(di, BQ27x00_REG_TTF);
> +
> +               if (!is_bq27500)
> +                       cache.current_now = bq27x00_read(di, BQ27x00_REG_AI, false);
>        }
>

<snip>

> -static int bq27x00_battery_current(struct bq27x00_device_info *di)
> +static int bq27x00_battery_current(struct bq27x00_device_info *di,
> +       union power_supply_propval *val)
>  {
> -       int ret;
> -       int curr = 0;
> -       int flags = 0;
> +       int curr;
>
> -       ret = bq27x00_read(di, BQ27x00_REG_AI, &curr, false);
> -       if (ret) {
> -               dev_err(di->dev, "error reading current\n");
> -               return 0;
> -       }
> +       if (di->chip == BQ27000)
> +           curr = bq27x00_read(di, BQ27x00_REG_AI, false);
> +       else
> +           curr = di->cache.current_now;

You're updating current_now in cache if it's not bq27500, but
bypassing cache for bq27000?

Why do you still want to cache the current while you are no longer
caching voltage, because it needs 2 register reads I guess?
