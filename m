Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab0EBUwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 16:52:50 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54973 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637Ab0EBUwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 16:52:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bcVdSg0MNNca+Nj2KOus0+T4hRQE7fX6DVnNGV3tXLVtBR9jCHDz2IQNvWIz8Ift8x
         X4LP8nx0YutSFMkXGm/xVI7zKnJePcn8NTsjRtxbyJaZqEX75MylPhn9S012tbF8x48B
         EkLLnZ7XF3MSi3s4IviVmMh2SMcmUjz31JUi8=
MIME-Version: 1.0
In-Reply-To: <20100502201202.GA18647@oksana.dev.rtsoft.ru>
References: <1272374302-9506-1-git-send-email-dbaryshkov@gmail.com>
	 <20100427154835.27bdc233.akpm@linux-foundation.org>
	 <20100430181349.GA1015@oksana.dev.rtsoft.ru>
	 <g2qbc64b4641004301340h3c942f3cn40de735b419b8535@mail.gmail.com>
	 <20100502201202.GA18647@oksana.dev.rtsoft.ru>
Date: Mon, 3 May 2010 00:52:48 +0400
Message-ID: <r2pbc64b4641005021352ub65dd07et6c96dfba76dc5103@mail.gmail.com>
Subject: Re: [PATCH] Remove tosa_battery driver (was: Re: [PATCH] 
	tosa_battery: fix FTBFS bug due to driver_data access)
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Marek Vasut <marek.vasut@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 3, 2010 at 12:12 AM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> On Sat, May 01, 2010 at 12:40:54AM +0400, Dmitry Eremin-Solenikov wrote:
> [...]
>> >> Ah, it appears to be a build fix.
>> >
>> > It seems that the driver isn't buildable since 2.6.32
>> > (i.e. commit b4028437 "Driver core: move dev_get/set_drvdata to
>> > drivers/base/dd.c").
>> >
>> > Also, IIRC it was deprecated in favor of wm97xx_battery.c
>> > driver.
>> >
>> > So, I'm not picking this patch for 2.6.34, it's not a
>> > new regression, and the driver is probably needs to be
>> > removed.
>> >
>> > Any objections on the patch down below?
>>
>> Yes. wm97xx_battery handles only one battery, while tosa uses 3
>> different batterires.
>> So, wm97xx_battery needs to be adapted/enhanced.
>
> Eh. I see, thanks for making this clear. I added some changelog
> and applied the following patch to battery-2.6.git:

Thank you. Merging these two drivers is on my goal list, but it won't
come in the near future.

>
> - - -
> From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Date: Tue, 27 Apr 2010 17:18:22 +0400
> Subject: [PATCH] tosa_battery: Fix build error due to direct driver_data usage
>
> The driver isn't buildable since 2.6.32 (i.e. commit b4028437
> "Driver core: move dev_get/set_drvdata to drivers/base/dd.c"):
>
>  CC      tosa_battery.o
> tosa_battery.c: In function 'tosa_read_bat':
> tosa_battery.c:64: error: 'struct device' has no member named 'driver_data'
> tosa_battery.c: In function 'tosa_read_temp':
> tosa_battery.c:84: error: 'struct device' has no member named 'driver_data'
>
> Nowadays we must not access driver_data directly, use dev_get_drvdata()
> instead.
>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
> ---
>  drivers/power/tosa_battery.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/power/tosa_battery.c b/drivers/power/tosa_battery.c
> index 2eab35a..ee04936 100644
> --- a/drivers/power/tosa_battery.c
> +++ b/drivers/power/tosa_battery.c
> @@ -61,7 +61,7 @@ static unsigned long tosa_read_bat(struct tosa_bat *bat)
>        mutex_lock(&bat_lock);
>        gpio_set_value(bat->gpio_bat, 1);
>        msleep(5);
> -       value = wm97xx_read_aux_adc(bat->psy.dev->parent->driver_data,
> +       value = wm97xx_read_aux_adc(dev_get_drvdata(bat->psy.dev->parent),
>                        bat->adc_bat);
>        gpio_set_value(bat->gpio_bat, 0);
>        mutex_unlock(&bat_lock);
> @@ -81,7 +81,7 @@ static unsigned long tosa_read_temp(struct tosa_bat *bat)
>        mutex_lock(&bat_lock);
>        gpio_set_value(bat->gpio_temp, 1);
>        msleep(5);
> -       value = wm97xx_read_aux_adc(bat->psy.dev->parent->driver_data,
> +       value = wm97xx_read_aux_adc(dev_get_drvdata(bat->psy.dev->parent),
>                        bat->adc_temp);
>        gpio_set_value(bat->gpio_temp, 0);
>        mutex_unlock(&bat_lock);
> --
> 1.7.0.5
>
>



-- 
With best wishes
Dmitry
