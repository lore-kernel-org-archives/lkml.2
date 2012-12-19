Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab2LSBE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 20:04:29 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:32967 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab2LSBE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 20:04:26 -0500
MIME-Version: 1.0
In-Reply-To: <20121218234150.GA32374@pengutronix.de>
References: <20121218234150.GA32374@pengutronix.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Dec 2012 17:04:03 -0800
X-Google-Sender-Auth: NvT5VhbbqKhL3fHoyEKSOd8OX_k
Message-ID: <CA+55aFyV5ROO-Zy4UxhXx0Lu6biyBzmrre=NY1x0yx7tK+Lz8g@mail.gmail.com>
Subject: Re: [PULL REQUEST] i2c-embedded for 3.8
To: Wolfram Sang <w.sang@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh, guys. Please check this out.

On Tue, Dec 18, 2012 at 3:41 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
>
> please pull the i2c-embedded changes for 3.8 which include:
>
> * CBUS driver (an I2C variant)
> * continued rework of the omap driver
> * s3c2410 gets lots of fixes and gains pinctrl support
> * at91 gains DMA support
> * the GPIO muxer gains devicetree probing
> * typical fixes and additions all over
>
> All patches have been in linux-next before. Please pull.

I get a conflict because both sides have this:

   Revert "ARM: OMAP: convert I2C driver to PM QoS for MPU latency constraints"

which re-introduced the omap-specific ->set_mpu_wkup_lat() thing.

But in mainline the only *user* of that has gone away. And the call
location where it originally existed has moved.

It originally existed in

  arch/arm/plat-omap/i2c.c

but looking at the history, the omap i2c code first got split into
omap1 and omap2, and at that point the call-site got moved to

  arch/arm/mach-omap2/i2c.c

but then the code that the revert re-introduced got lost.

Now, in the merge I just did, I *reinstated* that
->set_mpu_wkup_lat() code that had gotten lost in mainline. But quite
frankly, the thing is ugly as heck, and I hope it could just be
deleted. Clearly nobody had noticed yet that it got lost in some merge
(possibly an earlier one of mine, but considering that I usually
notice things like this, I suspect it's one of the internal ARM ones).

I'm adding Arnd, Tony and Olof to the participants list, since they
are the main suspects.

And guys, if you decide to remove the  ->set_mpu_wkup_lat() from
arch/arm/mach-omap2/i2c.c again, please make sure that you remove the
whole infrastructure too:

  include/linux/i2c-omap.h
  drivers/i2c/busses/i2c-omap.c

Hmm? Somebody *really* needs to double-check my merge, it's possibly
quite broken, since I have in no way tested it, and I did this by
looking at some *very* messy history with code being moved across
different files etc etc.

               Linus
