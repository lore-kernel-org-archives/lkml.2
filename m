Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab1F3N6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 09:58:18 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:21050 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1F3N6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 09:58:13 -0400
Message-ID: <4E0C80B8.7030006@atmel.com>
Date: Thu, 30 Jun 2011 15:57:12 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
CC: lrg@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/5] ASoC: wm8731: rework power management
References: <1309370419-22810-1-git-send-email-nicolas.ferre@atmel.com> <ccd4b125244271af7978948689cf1dcef37bc06b.1309368631.git.nicolas.ferre@atmel.com> <20110629171148.GB10798@opensource.wolfsonmicro.com>
In-Reply-To: <20110629171148.GB10798@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 29/06/2011 19:11, Mark Brown :
> On Wed, Jun 29, 2011 at 08:00:15PM +0200, Nicolas Ferre wrote:
> 
> Don't mix multiple changes into a single patch!  There's no perceptible
> code overlap between these so I don't understand why you've merged them,
> it just makes review harder and the changelog less descriptive.

Ok.

>> - preserve crystal oscillator across suspend/resume sequence:
>>   enabled by default, it should be kept enabled on resume.
> 
> This isn't what your code does...
> 
>>  		snd_soc_write(codec, WM8731_ACTIVE, 0x0);
>> -		snd_soc_write(codec, WM8731_PWR, 0xffff);
>> +		/* standby: keep crystal oscillator enabled */
>> +		snd_soc_write(codec, WM8731_PWR, 0x00df);
> 
> This doesn't keep the crystal oscillator enabled, this forces it on in
> suspend (and without looking at the datasheet it also changes way more
> than the one register bit I'd expect to be changed).  If the system
> isn't using the oscillator then that's not good.
> 
> I'd expect to see a change to using snd_soc_update_bits() based on your
> description, or more likely something more involved.

First of all, I experienced issues while not having OSC enabled during suspend/resume cycle. Am I right supposing that, if using oscillator to clock the codec, I have to keep it running during a suspend/resume cycle?

Is something like this sounds like an acceptable option or we need something more sophisticated?

@@ -481,7 +481,10 @@ static int wm8731_set_bias_level(struct snd_soc_codec *codec,
                break;
        case SND_SOC_BIAS_OFF:
                snd_soc_write(codec, WM8731_ACTIVE, 0x0);
-               snd_soc_write(codec, WM8731_PWR, 0xffff);
+               reg = 0xdf;
+               if (wm8731->sysclk_type == WM8731_SYSCLK_XTAL)
+                               reg |= 1 << 0x5;
+               snd_soc_update_bits(codec, WM8731_PWR, 0x00ff, reg);
                regulator_bulk_disable(ARRAY_SIZE(wm8731->supplies),
                                       wm8731->supplies);
                break;

And, yes, there is only 8 bits dedicated to power down control in this register.

Best regards,
-- 
Nicolas Ferre

