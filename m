Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161078Ab2KWJxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:53:08 -0500
Received: from antcom.de ([188.40.178.216]:36211 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161024Ab2KWJxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:53:04 -0500
Message-ID: <50AF477E.5020008@antcom.de>
Date: Fri, 23 Nov 2012 10:53:02 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.9) Gecko/20121015 Icedove/10.0.9
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Alban Bedel <alban.bedel@avionic-design.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] pwm: lpc32xx - Fix the PWM polarity
References: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de> <1352894295-14339-2-git-send-email-alban.bedel@avionic-design.de> <CAAAP30GUM31pcHxXfWJnuUBN2jYHbWz0XFX7o6x=_2wNtbHroQ@mail.gmail.com>
In-Reply-To: <CAAAP30GUM31pcHxXfWJnuUBN2jYHbWz0XFX7o6x=_2wNtbHroQ@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 10:34 AM, Alexandre Pereira da Silva wrote:
> On Wed, Nov 14, 2012 at 9:58 AM, Alban Bedel
> <alban.bedel@avionic-design.de> wrote:
>> The duty cycles value goes from 1 (99% HIGH) to 256 (0% HIGH) but it
>> is stored modulo 256 in the register as it is only 8 bits wide.
>>
>> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> 
> Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

When the below doc typos are fixed,

Acked-by: Roland Stigge <stigge@antcom.de>

> 
>> ---
>>  drivers/pwm/pwm-lpc32xx.c |   17 ++++++++++++++++-
>>  1 files changed, 16 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
>> index adb87f0..03ec3ff 100644
>> --- a/drivers/pwm/pwm-lpc32xx.c
>> +++ b/drivers/pwm/pwm-lpc32xx.c
>> @@ -49,9 +49,24 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>>                 c = 0; /* 0 set division by 256 */
>>         period_cycles = c;
>>
>> +       /* The duty value is a follow:
>> +        *
>> +        *  DUTY     HIGH LEVEL
>> +        *   1         99.9%
>> +        *   25        90.0%
>> +        *   128       50.0%
>> +        *   220       10.0%
>> +        *   255        0.1%
>> +        *   0          0.0%
>> +        *
>> +        * In other word the in-register value is duty % 256 with duty
>> +        * in the range 1-256.
>> +        */
>>         c = 256 * duty_ns;
>>         do_div(c, period_ns);
>> -       duty_cycles = c;
>> +       if (c > 255)
>> +               c = 255;
>> +       duty_cycles = 256 - c;
>>
>>         writel(PWM_ENABLE | PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles),
>>                 lpc32xx->base + (pwm->hwpwm << 2));
>> --
>> 1.7.0.4
>>

