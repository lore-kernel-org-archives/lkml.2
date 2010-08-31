Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab0HaOff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 10:35:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64586 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414Ab0HaOfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 10:35:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lpqShn9mDKDDZOtZp6kNH9C88tI/v4LKFawbvYgLrqiVHCvFQNeTNAjeNxKdf1f/6z
         N3bIjUJHtJq41OvD96w/3kxarMpwC+bNKNk5Krnp8Sx4UFS5pOoYTQrqKG1yHDEIWaKQ
         0/7VZflV/2hUP/Uv8monePvYCrYYKwZ5rWJa0=
MIME-Version: 1.0
In-Reply-To: <4C7C1A2B.1010400@nokia.com>
References: <1283102159-25804-1-git-send-email-linus.walleij@stericsson.com>
	<4C7C1A2B.1010400@nokia.com>
Date: Tue, 31 Aug 2010 16:35:31 +0200
Message-ID: <AANLkTikQupSvmvcd92h6-pcuRM8keZRbU9g2bepq9NC-@mail.gmail.com>
Subject: Re: [PATCH] MMC: move regulator handling closer to core
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Mack <daniel@caiaq.de>, Pierre Ossman <pierre@ossman.eu>,
        Matt Fleming <matt@console-pimps.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Cliff Brake <cbrake@bec-systems.com>,
        "Lavinen Jarkko (Nokia-MS/Helsinki)" <jarkko.lavinen@nokia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Tony Lindgren <tony@atomide.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Bengt Jonsson <bengt.jonsson@stericsson.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/30 Adrian Hunter <adrian.hunter@nokia.com>:

> [Me]
>> diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
>> index 0a4e43f..47dae9b 100644
>> --- a/drivers/mmc/host/pxamci.c
>> +++ b/drivers/mmc/host/pxamci.c
>> @@ -99,14 +99,26 @@ static inline void pxamci_init_ocr(struct pxamci_host
>> *host)
>>        }
>>  }
>>  -static inline void pxamci_set_power(struct pxamci_host *host, unsigned
>> int vdd)
>> +static inline void pxamci_set_power(struct pxamci_host *host,
>> +                                   unsigned char power_mode,
>> +                                   unsigned int vdd)
>>  {
>>        int on;
>>  -#ifdef CONFIG_REGULATOR
>> -       if (host->vcc)
>> -               mmc_regulator_set_ocr(host->vcc, vdd);
>> -#endif
>> +       if (host->vcc) {
>> +               int ret;
>> +
>> +               if (power_mode == MMC_POWER_UP) {
>> +                       ret = mmc_regulator_set_ocr(host->mmc, host->vcc,
>> vdd);
>> +                       if (ret)
>> +                               dev_err(mmc_dev(host->mmc),
>> +                                       "could not set regulator OCR\n");
>> +               } else if (power_mode == MMC_POWER_OFF)
>> +                       ret = mmc_regulator_set_ocr(host->mmc, host->vcc,
>> 0);
>> +                       if (ret)
>> +                               dev_err(mmc_dev(host->mmc),
>> +                                       "could not disable regulator\n");
>> +       }
>
> mmc_power_off() does set ios->vdd to 0 so the original code was fine
> wrt to ignoring power_mode.

Yeah I know. This bit was to increase readability, explicitly showing
the power state like this makes it more clear what is happening I think.

The rest of the comments are fixed, new patch soon.

Yours,
Linus Walleij
