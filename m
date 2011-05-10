Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1EJXPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 19:15:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46608 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab1EJXPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 19:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=e9U0RhpsVsWm9KnqHatUK8EFWri2t2xPPI5ANQe5FCcDg3xHCggdFAzPYhZ3APkecL
         CethEyfgcFJZ0BP4RpXfZ9BK9iyf0aE0CW9thuhPrcWipMRy3Pml6qp5vYcymXsNqu9/
         D/Zng+h8211WU3ZZSbBn/y2J2qbJ/8p4+pRas=
MIME-Version: 1.0
In-Reply-To: <20110510214518.GB5315@n2100.arm.linux.org.uk>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
	<20110502225708.GD28001@n2100.arm.linux.org.uk>
	<BANLkTikSwkYEvbQ8XVrB3LUetVqBBUjT2g@mail.gmail.com>
	<20110510214518.GB5315@n2100.arm.linux.org.uk>
Date: Wed, 11 May 2011 01:15:12 +0200
X-Google-Sender-Auth: pWTZh_uqq2hGPDu-v8JICFANSL8
Message-ID: <BANLkTinhDWsZuUdeNObSOmsS2_ES9G3Bww@mail.gmail.com>
Subject: Re: [PATCH 0/4] Pinmux subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/10 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Tue, May 10, 2011 at 11:25:44PM +0200, Linus Walleij wrote:
>> It can, basically:
>>
>> struct pinmux *pmx;
>>
>> pmx = pinmux_get(dev, "irda-uart");
>> pinmux_enable(pmx);
>> (... SIR UART operations ...)
>> pinmux_disable(pmx);
>> pinmux_put(pmx);
>> (... stuff to init FIR silicon ...)
>> pmx = pinmux_get(dev, "irda-fir");
>> pinmux_enable(pmx);
>> (... etc ...)
>
> You really don't want to do this.  It's not that SIR and FIR are that
> exclusive.  You only switch to FIR mode when you've negotiated in SIR
> mode, and then there's tight timings for doing that.  Essentially you
> agree in SIR mode to switch to FIR mode, switch to FIR mode and expect
> a response in FIR mode from the remote end.
>
> Calling out to lots of functions to perform the switch is asking for
> that response to be missed because you've not set things up for it.
>
> You'd want to have SIR and FIR mode 'got', and then switch as quickly
> as possible between them.

Sorry I might have got things backwards here, let me see if I got it:

Either the SIR and FIR modes use the exact same pins albeit pushing
in a differnt silicon block to control them without any side-effects.
In that case from the pinmux API point of view there is no conflict,
since there is no competition for using the same pins, the pinmux API
get/put is about resolving such conflicts.

So if we want to use the pinmux_enable()/disable() to quickly poke
some bit to switch between these two, I could think about things like
encoding the pins in the first setting and not encoding any pins at
all in the second one and then they can both be be get/put without
conflicting, and the only possible conflict would be if you tried
to enable both at the same time and this can be handled by the
specific pinmux driver.

Albeit not elegant, it works for this scenario.

A more elegant way is that I supply the same custom configuration
extension mechanism for pinmux as for GPIO, similar to ioctl()
like so:

pmx = pinmux_get(dev, "irda-sir-fir");
pmx_enable(pmx);
/* Unless the first enablement implies SIR mode */
pmx_config(pmx, PINMUX_CONFIG_CUSTOM_SIR, NULL);
(... negotiated ...)
pmx_config(pmx, PINMUX_CONFIG_CUSTOM_FIR, NULL);
(...)
pmx_disable(pmx);
pmx_put(pmx);

I planned to add this interface anyway (needed for pin biasing and
such fun stuff), so I'll poke it in.

The latter would be analog to suppling an enumerated "what" to
the pinmux_enable() function, if it turns out to be an everyday
thing we can think about a more generic extension like
pinmux_enable_selector(struct pinmux *pmx, unsigned selector);
in the API but I feel the above will cut it just as fine.

Yours,
Linus Walleij
