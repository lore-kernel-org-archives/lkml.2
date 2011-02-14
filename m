Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab1BNWCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:02:10 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43498 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1BNWCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:02:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gr6NilzEyj0cbmKsWTNrYrjyJaKUtIAJWUT/EoGLVEE/nLn0uWLZGi7huHHu8Y1/0Y
         gNs2y++BADVPYK6jswAPOCxI2IZvbk+mFDkJQppwQ5/7XIVGcbZG1MJaWJ0XcOMm+qwl
         oVRiSieMqGLDdmKSac5/XMkKzpjIM+I9WtZvs=
MIME-Version: 1.0
In-Reply-To: <1297652493-7207-1-git-send-email-lars@metafoo.de>
References: <1297539554-13957-8-git-send-email-lars@metafoo.de>
	<1297652493-7207-1-git-send-email-lars@metafoo.de>
Date: Mon, 14 Feb 2011 23:58:31 +0200
Message-ID: <AANLkTimn2JYtUSUrJBQKzXrw+URD5n0Y2h7QMaFzKFdY@mail.gmail.com>
Subject: Re: [PATCH 07/14 v3] bq27x00: Cache battery registers
From: Grazvydas Ignotas <notasas@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Pali Rohar <pali.rohar@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 5:01 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
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
>  drivers/power/bq27x00_battery.c |  271 +++++++++++++++++++++-----------------
>  1 files changed, 150 insertions(+), 121 deletions(-)
>
> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index 44bc76b..dbe3fcb 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c

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
> +       if (di->chip == BQ27500)
> +           curr = bq27x00_read(di, BQ27x00_REG_AI, false);
> +       else
> +           curr = di->cache.current_now;
> +
> +       if (curr < 0)
> +               return curr;

This is wrong, as read function returns negative values for bq27500
when discharging. That's why read function used to pass value through
argument before your series (return value was for error code).

Sorry for not noticing this earlier, I only found this now during testing.

>
>        if (di->chip == BQ27500) {
>                /* bq27500 returns signed value */
> -               curr = (int)((s16)curr) * 1000;
> +               val->intval = (int)((s16)curr) * 1000;
