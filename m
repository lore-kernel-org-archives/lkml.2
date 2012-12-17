Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2LQRhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:37:34 -0500
Received: from ngcobalt02.manitu.net ([217.11.48.102]:46256 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2LQRhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:37:33 -0500
X-manitu-Original-Sender-IP: 93.104.18.146
X-manitu-Original-Receiver-Name: ngcobalt02.manitu.net
Message-ID: <50CF584E.1040601@grandegger.com>
Date: Mon, 17 Dec 2012 18:37:18 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: rmallon@gmail.com, gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        broonie@opensource.wolfsonmicro.com, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        daniel-gl@gmx.net, sr@denx.de, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, highguy@gmail.com
Subject: Re: [PATCH RESEND 0/6 v10] gpio: Add block GPIO
References: <1355495185-24220-1-git-send-email-stigge@antcom.de> <50CB68AB.5070806@grandegger.com> <50CBBB25.20002@antcom.de> <50CF03FB.2030100@grandegger.com> <50CF0744.7040404@grandegger.com> <50CF1EF1.2070601@antcom.de> <50CF237E.5020409@antcom.de> <50CF4838.9000401@grandegger.com> <50CF5327.6070205@antcom.de>
In-Reply-To: <50CF5327.6070205@antcom.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 06:15 PM, Roland Stigge wrote:
> On 12/17/2012 05:28 PM, Wolfgang Grandegger wrote:
>> On 12/17/2012 02:51 PM, Roland Stigge wrote:
>>> Hi Wolfgang,
>>>> And I guess Russell is right: If possible, we should write outputs
>>>> simultaneously via ODSR (plus OWER/OWDR/OWSR) instead of separate set/clear.
>>>>
>>>> I wonder if we need to save/restore the state of OWSR at every write
>>>> operation or if we need/can cache it. Assuming that block GPIO are the
>>>> only code in the kernel that manipulates ODSR.
>>>
>>> Can you please test the following:
>>>
>>> +static void at91_gpiolib_set_block(struct gpio_chip *chip, unsigned long mask, unsigned long val)
>>> +{
>>> +       struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
>>> +       void __iomem *pio = at91_gpio->regbase;
>>> +
>>> +       __raw_writel(~mask, pio + PIO_OWDR);
>>
>> This would also disable normal GPIOs configured for output! From the
>> manual I understand that if the pin is configured for output, we could
>> either use PIO_SODR/PIO_CODR to set/clear the bits individually or
>> PIO_ODSR for synchronous data output. But than we need to care about the
>> non-block GPIO outputs as well... requiring a read-modify-write cycle :(.
> 
>>From the manual, I read about OWER: "Enables writing PIO_ODSR for the
> I/O line" (analogous for OWDR). Would interpret this as affecting ODSR
> (for block GPIO) but not SODR/CODR (as currently with single GPIOs).
> 
> Have you tried? ;-)

Grrr, I mixed OER with OWER, sorry for the noise. Back to your approach,
which works.

	/* Do synchronous data output with a single write access */
	__raw_writel(~mask, pio + PIO_OWDR);
	__raw_writel(mask, pio + PIO_OWER);
	__raw_writel(val, pio + PIO_ODSR);

For caching we would need a storage. Not sure if it's worth compared to
a context switch into the kernel.

Wolfgang.

