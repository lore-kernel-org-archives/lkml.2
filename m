Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0G0ODR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 10:03:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56032 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab0G0ODQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 10:03:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=O7BUAUtispxetAkCGIMiFWRoJYsW6xYKBbQnrEVEF+GPJEJuzTHQjLhOIFu3elK+cH
         R6FFhg8HGTFV0FIhKw9MGyty7tXPeswZi7nhQPHLt2GeavKqf/L4vdsA9XdZY5B41xzr
         r6q0lxKYRNeUPDfmHPkctifCH4hIDBabQQwok=
MIME-Version: 1.0
In-Reply-To: <20100727135115.GA31789@oksana.dev.rtsoft.ru>
References: <20100727135115.GA31789@oksana.dev.rtsoft.ru>
Date: Tue, 27 Jul 2010 16:03:14 +0200
X-Google-Sender-Auth: h5RwsHWRFKm05-K7g8k6MAf2oC8
Message-ID: <AANLkTim77oCDk9L8oYE5DCEKqZL_L_dm=mm-46=MZwX7@mail.gmail.com>
Subject: Re: [GIT PULL] battery-2.6.35.git
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 15:51, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
> index d762a0c..9b3b4b7 100644
> --- a/drivers/power/ds2782_battery.c
> +++ b/drivers/power/ds2782_battery.c
> @@ -43,10 +43,9 @@
>  struct ds278x_info;
>
>  struct ds278x_battery_ops {
> -       int     (*get_current)(struct ds278x_info *info, int *current_uA);
> -       int     (*get_voltage)(struct ds278x_info *info, int *voltage_uA);
> -       int     (*get_capacity)(struct ds278x_info *info, int *capacity_uA);
> -
> +       int (*get_battery_current)(struct ds278x_info *info, int *current_uA);
> +       int (*get_battery_voltage)(struct ds278x_info *info, int *voltage_uA);
> +       int (*get_battery_capacity)(struct ds278x_info *info, int *capacity_uA);

What's the meaning of these `uA' namings? At first I thought `micro Ampère', but
that can't be correct for voltage (`uV'?) and capacity (`uAh'?).

So I had a look at the sources, and noticed:

| static int ds2782_get_voltage(struct ds278x_info *info, int *voltage_uA)
| {
|       s16 raw;
|       int err;
|
|       /*
|        * Voltage is measured in units of 4.88mV. The voltage is stored as
                                           ^^^^
|        * a 10-bit number plus sign, in the upper bits of a 16-bit register
|        */
|       err = ds278x_read_reg16(info, DS278x_REG_VOLT_MSB, &raw);
|       if (err)
|               return err;
|       *voltage_uA = (raw / 32) * 4800;
                                   ^^^^
These don't match?

So the voltage_uA unit is 1 mV?

|       return 0;
| }
|
| static int ds2786_get_voltage(struct ds278x_info *info, int *voltage_uA)
| {
|       s16 raw;
|       int err;
|
|       /*
|        * Voltage is measured in units of 1.22mV. The voltage is stored as
|        * a 10-bit number plus sign, in the upper bits of a 16-bit register
|        */
|       err = ds278x_read_reg16(info, DS278x_REG_VOLT_MSB, &raw);
|       if (err)
|               return err;
|       *voltage_uA = (raw / 8) * 1220;
                             ^
32? Or the comments above are wrong.

|       return 0;
| }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
