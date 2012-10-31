Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894Ab2JaS72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:59:28 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:35472 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758368Ab2JaS71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:59:27 -0400
MIME-Version: 1.0
In-Reply-To: <50915DBC.2000802@antcom.de>
References: <1351457210-25222-1-git-send-email-stigge@antcom.de>
 <1351457210-25222-2-git-send-email-stigge@antcom.de> <CACxGe6vgryMPygc8SKFLKqP8Wq=pcGiJe_dPCiDC-evzf32UMA@mail.gmail.com>
 <50915DBC.2000802@antcom.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 31 Oct 2012 19:59:04 +0100
X-Google-Sender-Auth: 17vLGJRWWJ4dCIEBH1slzAdUGUg
Message-ID: <CACxGe6vEr5fd0_ZuzV=nOXVfwA7_FB5L6KJsEwMEHmVj0rDA=g@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/5 v6] gpio: Add a block GPIO API to gpiolib
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland

On Wed, Oct 31, 2012 at 6:19 PM, Roland Stigge <stigge@antcom.de> wrote:
> On 10/31/2012 04:00 PM, Grant Likely wrote:
>> For the API, I don't think it is a good idea at all to try and
>> abstract away gpios on multiple controllers. I understand that it
>> makes life a lot easier for userspace to abstract those details away,
>> but the problem is that it hides very important information about how
>> the system is actually constructed that is important to actually get
>> things to work. For example, say you have a gpio-connected device with
>> the constraint that GPIOA must change either before or at the same
>> time as GPIOB, but never after. If those GPIOs are on separate
>> controllers, then the order is completely undefined
>
> It is correct that it's not (yet) well documented and the API is also
> not very explicit about it, but the actual approach of the manipulation
> order is to let drivers handle gpios "as simultaneous as possible" and
> when not possible, do it in the _order of bits specified_ (either
> defined at the device tree level, or when created via
> block_gpio_create() directly).

The documentation is actually fine. I do understand that the intent is
"as simultaneous as possible", but I accept the point that the order
of specification affects the behaviour*. However, it still remains
that the method used by the ABI abstracts at the wrong level and that
blocking arbitrary GPIO pins into a single virtual GPIO register is a
bad idea.

*note that the current code doesn't implement that intended behaviour
either since the gpios are processed in the order of the controllers,
not the order of the bits.

> I'm not sure how far you tested the API in depth: You can already define
> a block that maps onto a subset of gpios on a controller and internally
> of course maps onto those set and clear operations. Whenever you need to
> manipulate a different subset (whether disjoint or overlapping), you can
> easily define _additional_ blocks. From my experience, this solves most
> of the real world problems when n-bit busses are bit banged over GPIOs.
> Doesn't this already solve this (in a different way, though)?

Blech! Requiring a new block for each possible combination of
write-at-once bits is a horrible ABI. That just strengthens my opinion
that the abstraction isn't right yet.

> Pin direction currently needs to be set up separately, analogous to
> requesting gpios. Need to document this better, right. The assumption is
> that I/O needs to be efficient primarily, before bloating the API with
> direction functions. Or should I add functions for this?

Since this is a userspace facing ABI, once it is merged it cannot be
changed in an incompatible way. I cannot merge it until there is at
least a plan for how to handle all of the reasonable use cases. That
means it must support set/clear or mask operations. Also, if it sticks
with the design of grouping pins from multiple controllers, then it
needs to handle explicitly constraining what order operations are
performed in at the time of the operation. At the time of setup
doesn't work since constraints between pins may not always be in the
same order.

I really think you should consider implementing a command stream type
of interface.

g.
