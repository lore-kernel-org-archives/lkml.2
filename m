Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2LSTtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 14:49:39 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:55842 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752589Ab2LSTta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 14:49:30 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19OFjPcZ3FaQRrycrTS/Beh
Date: Wed, 19 Dec 2012 11:49:21 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PULL REQUEST] i2c-embedded for 3.8
Message-ID: <20121219194920.GQ4989@atomide.com>
References: <20121218234150.GA32374@pengutronix.de>
 <CA+55aFyV5ROO-Zy4UxhXx0Lu6biyBzmrre=NY1x0yx7tK+Lz8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyV5ROO-Zy4UxhXx0Lu6biyBzmrre=NY1x0yx7tK+Lz8g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [121218 17:07]:
> Ugh, guys. Please check this out.
> 
> On Tue, Dec 18, 2012 at 3:41 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> >
> > please pull the i2c-embedded changes for 3.8 which include:
> >
> > * CBUS driver (an I2C variant)
> > * continued rework of the omap driver
> > * s3c2410 gets lots of fixes and gains pinctrl support
> > * at91 gains DMA support
> > * the GPIO muxer gains devicetree probing
> > * typical fixes and additions all over
> >
> > All patches have been in linux-next before. Please pull.
> 
> I get a conflict because both sides have this:
> 
>    Revert "ARM: OMAP: convert I2C driver to PM QoS for MPU latency constraints"
> 
> which re-introduced the omap-specific ->set_mpu_wkup_lat() thing.
> 
> But in mainline the only *user* of that has gone away. And the call
> location where it originally existed has moved.
> 
> It originally existed in
> 
>   arch/arm/plat-omap/i2c.c
> 
> but looking at the history, the omap i2c code first got split into
> omap1 and omap2, and at that point the call-site got moved to
> 
>   arch/arm/mach-omap2/i2c.c
> 
> but then the code that the revert re-introduced got lost.
> 
> Now, in the merge I just did, I *reinstated* that
> ->set_mpu_wkup_lat() code that had gotten lost in mainline. But quite
> frankly, the thing is ugly as heck, and I hope it could just be
> deleted. Clearly nobody had noticed yet that it got lost in some merge
> (possibly an earlier one of mine, but considering that I usually
> notice things like this, I suspect it's one of the internal ARM ones).

Your merge looks good and has zero diff to what I resolved earlier,
and what Arnd and Olof resolved earlier, and what Stephen resolved
earlier. It seems that the right thing to do here would have been
to pull that revert into arm-soc to avoid this.
 
> I'm adding Arnd, Tony and Olof to the participants list, since they
> are the main suspects.
> 
> And guys, if you decide to remove the  ->set_mpu_wkup_lat() from
> arch/arm/mach-omap2/i2c.c again, please make sure that you remove the
> whole infrastructure too:
> 
>   include/linux/i2c-omap.h
>   drivers/i2c/busses/i2c-omap.c

Looks like that's still needed until runtime PM can deal with
latencies, that's why the revert was needed :(
 
> Hmm? Somebody *really* needs to double-check my merge, it's possibly
> quite broken, since I have in no way tested it, and I did this by
> looking at some *very* messy history with code being moved across
> different files etc etc.

Yes thanks again. We've now pretty much cut all the remaining nasty
dependencies between arch/arm/*omap*/ code and drivers and can
enable multiplatform support for omap2+ for v3.9. So things should
be a lot easier with merge conflicts as far as omap is concerned.

Regards,

Tony
