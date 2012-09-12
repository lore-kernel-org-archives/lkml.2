Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab2ILBDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 21:03:13 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:27133 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755131Ab2ILBDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 21:03:11 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+V2W/SCcRO6ZrqlBt/yirD
Date: Tue, 11 Sep 2012 18:03:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Matt Porter <mporter@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, AnilKumar <anilkumar@ti.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/2] ARM: OMAP2+: Enable pinctrl dummy states
Message-ID: <20120912010307.GP23092@atomide.com>
References: <1347385599-27558-1-git-send-email-mporter@ti.com>
 <1347385599-27558-3-git-send-email-mporter@ti.com>
 <20120911180306.GI23092@atomide.com>
 <20120911181540.GO27758@beef>
 <20120911183522.GL23092@atomide.com>
 <20120911190602.GP27758@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911190602.GP27758@beef>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Porter <mporter@ti.com> [120911 12:05]:
> On Tue, Sep 11, 2012 at 11:35:22AM -0700, Tony Lindgren wrote:
> > Added Linus Walleij to Cc as well.

Now I think I really managed to add Linus W to Cc, sent too fast
earlier.
...

> > But do you get an error then if the desired pins are not found?
> > If you do get an error, then sounds like it's OK to do.
>
> Hrm, no. In that case, it will be completely silent (assuming we took
> care of the pinmuxing in the bootloader) as it uses the dummy state.
> Only with debug on will you see the information that mcspi has used
> the dummy state as is the case with !DT.
...
 
> > Well I think we should consider at least the following:
> > 
> > 1. Always see warnings when device tree is populated with board-generic.
> >    If somebody wants to use bootloader only muxing with DT, they can patch
> >    in pinctrl_provide_dummies() somewhere. But let's assume we always
> >    want to see the warnings with board-generic.c and DT.
> 
> Ok, this is clear.
> 
> > 2. For legacy booting without DT, we should not see any warnings
> >    from pinctrl-single.c as it's DT based.
> 
> Right, except anything legacy booting without DT will require that
> dummy states be present otherwise it will fail probe.

But I guess we should enable the dummy states only for other
board-*.c files, not board-generic.c? 

> > 3. There may be other non-pinctrl drivers too that are not DT
> >    based, and in those cases we should see the warnings as well
> >    for in the non-DT case.
> 
> I'm not sure what you mean here. "non-pinctrl drivers" means any driver
> that is not yet pinctrl or DT enabled? It's unclear to me how this
> case has a bearing on mcspi and pinctrl enablement across legacy
> board-foo.c !DT booting platforms.

Right, sorry I meant "non DT pinctrl drivers"..
 
> However, I think if the approach was modified by only calling
> pinctrl_provide_dummies() when we are booting with DT populated
> and using board-generic.c then it will satisfy all of your
> concerns. Thoughts?

Hmm but shouldn't it be call pinctrl_provide_dummies() only
for other boards except board-generic.c? And that is assuming
we don't have any other "non DT pinctrl drivers" around.
 
> i.e. the legacy !DT booting will have dummy states and continue
> along through mcspi the way it does today, relying on board-foo level
> pinmux calls (or bootloader pinmuxing). Meanwhile DT booting will now
> require that a mcspi instance also require pinctrl entry in this dts.

Yes agreed, except let's just produce a warning for the pinctrl
errors..
 
> The only worrisome thing is the pinctrl requirement on DT booting is
> now an implicit requirement.

..as otherwise not much will work at this point :)
 
> > > > For board-generic.c we always want to see the warnings. And some boards
> > > > insist on doing all the muxing only in the bootloader.
> > > 
> > > Which warnings are you saying we should see in the board-generic.c
> > > case?  Sure, there's plenty of cases where this will be unused due to
> > > somebody setting all the muxes in the bootloader and then not using
> > > pinctrl data. I'll have to doublecheck but I believe that case is also
> > > fine as the -single driver can't override the dummy state if the DT has
> > > no pinctrl data for the spi driver.

I suggest all pinctrl errors should show up as warnings with
board-generic.c, but we should not exit out of the driver probe
on errors.

Regards,

Tony
