Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab2JaRUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:20:03 -0400
Received: from antcom.de ([188.40.178.216]:58006 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884Ab2JaRT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:19:59 -0400
Message-ID: <50915DBC.2000802@antcom.de>
Date: Wed, 31 Oct 2012 18:19:56 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.9) Gecko/20121015 Icedove/10.0.9
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Subject: Re: [PATCH RESEND 1/5 v6] gpio: Add a block GPIO API to gpiolib
References: <1351457210-25222-1-git-send-email-stigge@antcom.de> <1351457210-25222-2-git-send-email-stigge@antcom.de> <CACxGe6vgryMPygc8SKFLKqP8Wq=pcGiJe_dPCiDC-evzf32UMA@mail.gmail.com>
In-Reply-To: <CACxGe6vgryMPygc8SKFLKqP8Wq=pcGiJe_dPCiDC-evzf32UMA@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

thank you for your feedback!

Notes below.

On 10/31/2012 04:00 PM, Grant Likely wrote:
> Linus and I just sat down and talked about your changes. I think I
> understand what you need to do, but I've got concerns about the
> approach. I'm already not a big fan of the sysfs gpio interface
> design*, so you can understand that I'm not keen to extend the
> interface further. At the very least, I want to be really careful
> about the form that the extension takes.
> 
> First off, thank you for writing good documentation. That makes it a
> lot easier to understand how the series is intended to be used, and I
> really appreciate it.
> 
> For the API, I don't think it is a good idea at all to try and
> abstract away gpios on multiple controllers. I understand that it
> makes life a lot easier for userspace to abstract those details away,
> but the problem is that it hides very important information about how
> the system is actually constructed that is important to actually get
> things to work. For example, say you have a gpio-connected device with
> the constraint that GPIOA must change either before or at the same
> time as GPIOB, but never after. If those GPIOs are on separate
> controllers, then the order is completely undefined

It is correct that it's not (yet) well documented and the API is also
not very explicit about it, but the actual approach of the manipulation
order is to let drivers handle gpios "as simultaneous as possible" and
when not possible, do it in the _order of bits specified_ (either
defined at the device tree level, or when created via
block_gpio_create() directly).

I consider it a good thing to abstract things away if possible here, if
it is well documented what actually happens, which info should be
available from the definition and the possibilities of the drivers and
hardware actually used (the optional block gpio interface must be well
implemented in the respective driver, and when combining multiple gpio
controller chips, it should be clear that certain realtime timings on a
resulting virtual n-bit bus are not possible.)

> Second, the API appears a little naive in the way it approaches
> changing values. It makes the assumption that every gpio in the block
> will be written at the same time, which doesn't take into account that
> even within a block it is highly likely that only a subset of the
> gpios need to be manipulated. A lot of GPIO controllers implement
> separate 'set' and 'clear' registers for exactly this reason. The API
> needs to allow users to choose a subset for manipulation. The ABI
> needs to either have separate 'set' and 'clear' operations, or
> operations need to have both mask and value arguments. Similarly, how
> do users manipulate pin direction with this ABI?

I'm not sure how far you tested the API in depth: You can already define
a block that maps onto a subset of gpios on a controller and internally
of course maps onto those set and clear operations. Whenever you need to
manipulate a different subset (whether disjoint or overlapping), you can
easily define _additional_ blocks. From my experience, this solves most
of the real world problems when n-bit busses are bit banged over GPIOs.
Doesn't this already solve this (in a different way, though)?

Pin direction currently needs to be set up separately, analogous to
requesting gpios. Need to document this better, right. The assumption is
that I/O needs to be efficient primarily, before bloating the API with
direction functions. Or should I add functions for this?

As long as there is no consensus about mainlining this API, I will
maintain it further at

git://git.antcom.de/linux-2.6 blockgpio

because I need it in projects anyway. Will post updates that go in the
direction that you proposed.

Thanks!

Roland
