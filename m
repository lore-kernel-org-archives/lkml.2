Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2EBTMC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:12:02 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:54679 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756090Ab2EBTL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:11:57 -0400
Date: Wed, 2 May 2012 12:07:06 -0700
From: Mike Turquette <mturquette@ti.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH] clk: Use a separate struct for holding init data.
Message-ID: <20120502190706.GB15873@gmail.com>
References: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
 <20120502020418.GF17311@gmail.com>
 <4FA0BB3D.4040004@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA0BB3D.4040004@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120501-21:42, Saravana Kannan wrote:
> On 05/01/2012 07:04 PM, Mike Turquette wrote:
> >1) I'm surprised that you abandoned the approach of exposing the
> >less-private members of struct clk via struct clk_hw.  Your original
> >patch did just that, but did not account for static initialization.
> >This patch seems to have gone in the opposite direction and only
> >accounts for static initialization.
> 
> I think there might be some misunderstanding on what can/can't be
> done with my patch. Or may be I'm not understanding your question.
> 

I believe I am reading the code correctly.  I'll try reiterating below.

> I used to expose the "shared" info through clk_hw. I just put them
> in a struct and make clk_hw point to it. This would allow for easily
> marking this shared info as __init data.

So platforms must choose between marking clk->hw->init as __initdata, OR
they can keep it around and reference it later from clock code that
includes clk-provder.h.  Is this a fair statement?

> It would have a been a pain
> to do (or not even possible) if I had put the fields directly into
> clk_hw.
> 

Not true.  Combining Sascha's original static initializer idea with your
struct clk_hw patch would be easy.  A separate struct for static init
would be marked as __initdata.  When passed into a registration function
that data would be copied to fields in struct clk_hw.  You've done this
exact same thing, with the exception of copying the data to struct clk
instead.

It is not a big deal, and I'm fine with the direction this patch has
taken, but I wanted to point it out.  If you look at Russell's and
Sascha's replies in this thread you'll see that they regard
clk->hw->init as purely __initdata, going so far as to mark it NULL in
clk_register.  This sort of change at the framework level would
eliminate the ability for your clock code to reference these members
directly.

> I'm not sure why you say my patch only accounts for static
> initialization. The entire clk specific struct (say, struct
> fixed_clk), the clk_init_data can be dynamically allocated and
> registered using clk_register.
> 

This was a miscommunication on my part and can be disregarded.  Of
course your patch allows for dynamic registration.

My point was that of the two previous approaches on this list (Sascha's
static initializers and your own struct clk_hw modifications), this
patch only represents the functionality of the former.  I should have
been more clear.

> >2) I did make a modification to your patch where I kept the
> >DEFINE_CLK_* macros and continued to declare __clk_init in
> >clk-private.h.  I do want to get rid of both of these in the future but
> >currently my platform relies on static initialization before the
> >allocator is available.  Please let me know if this causes a problem for
> >you.
> 
> I definitely had your requirements in mind too when I made the changes.
> 
> You really shouldn't need __clk_init. That's why I added
> __clk_register.

I completely missed __clk_register.  I'm not sure I see the point of it
however.  struct clk is still exposed to folks that are using this new
function; compared to simply calling __clk_init it has added a few loads
& stores.  Regardless these interfaces will hopefully die off completely
once OMAP's clock code uses an initcall.

> >Platform folks should rebase on top of this if needed.  This should be
> >the last change to the driver/platform-facing API before 3.5.
> 
> I really wish we discussed your changes before it was made, pulled
> in and announced since clk_init isn't really needed. But since you
> just added more APIs and didn't remove the ones I added, I guess
> it's not very bad.
> 

I probably announced it too soon, but everything you added to the API is
still there, just with some extra stuff that should go away in the
future.

> Since people were already frustrated with the API change I made at
> this point, can we recommend people to not use __clk_init() when
> sending patches for your clk-next? And make it static after the next
> kernel release?

Yes, I completely agree.  It would be good to get rid of __clk_register
and __clk_init down the road.  Marking the interfaces as deprecated is
one solution; however I agree with your suggestion and just catching it
in review is probably the best route.

Thanks,
Mike
