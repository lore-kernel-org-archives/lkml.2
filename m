Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761988Ab2KAPWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:22:35 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:40748 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761860Ab2KAPWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:22:33 -0400
MIME-Version: 1.0
In-Reply-To: <20121031193033.GA4164@opensource.wolfsonmicro.com>
References: <1351457210-25222-1-git-send-email-stigge@antcom.de>
 <1351457210-25222-2-git-send-email-stigge@antcom.de> <CACxGe6vgryMPygc8SKFLKqP8Wq=pcGiJe_dPCiDC-evzf32UMA@mail.gmail.com>
 <20121031193033.GA4164@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 1 Nov 2012 16:14:16 +0100
X-Google-Sender-Auth: kPS5OlODA5cAIv6eU0136sJx_O8
Message-ID: <CACxGe6uFs=12fH2DH=+kXq3Q2DjQ_CmfbzbmAig2iHiEezngGQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/5 v6] gpio: Add a block GPIO API to gpiolib
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Roland Stigge <stigge@antcom.de>, gregkh@linuxfoundation.org,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 8:30 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Oct 31, 2012 at 04:00:17PM +0100, Grant Likely wrote:
>
>> For the API, I don't think it is a good idea at all to try and
>> abstract away gpios on multiple controllers. I understand that it
>> makes life a lot easier for userspace to abstract those details away,
>> but the problem is that it hides very important information about how
>> the system is actually constructed that is important to actually get
>> things to work. For example, say you have a gpio-connected device with
>> the constraint that GPIOA must change either before or at the same
>> time as GPIOB, but never after. If those GPIOs are on separate
>> controllers, then the order is completely undefined, and the user has
>> no way to control that other than to fall back to manipulating GPIOs
>> one at a time again (and losing all the performance benefits). Either
>> controller affinity needs to be explicit in the API, or the API needs
>> to be constraint oriented (ie. a stream of commands and individual
>> commands can be coalesced if they meet the constraints**). Also, the
>> API requires remapping the GPIO numbers which forces the code to be a
>> lot more complex than it needs to be.
>
> It feels like I'm missing something here but can we not simply say that
> if the user cares about the ordering of the signal changes within an
> update then they should be doing two separate updates?  Most of the
> cases I'm aware of do things as an update with a strobe or clock that
> latches the values.
>
> The big advantage of grouping things together is that it means that we
> centralise the fallback code.

The internal ABI is less of an issue because it is a whole lot easier
to change compared to a userspace ABI (though I think we can do a lot
better before deciding to merge it). Userspace also appears to be the
intended usage, so I've focused my review on that use case.

g.
