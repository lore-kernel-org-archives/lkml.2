Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab1LQLFE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 06:05:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59410 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1LQLE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 06:04:57 -0500
Date: Sat, 17 Dec 2011 11:04:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, paul@pwsan.com,
        broonie@opensource.wolfsonmicro.com, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, andrew@lunn.ch,
        Colin Cross <ccross@google.com>
Subject: Re: [PATCH v4 3/6] clk: introduce the common clock framework
Message-ID: <20111217110433.GC14547@n2100.arm.linux.org.uk>
References: <1323834838-2206-1-git-send-email-mturquette@linaro.org> <1323834838-2206-4-git-send-email-mturquette@linaro.org> <alpine.LFD.2.02.1112141007550.3020@ionos> <CAJOA=zO=gM2r4pCVo+orLqE9Q1SSw4h5nXsAHo-e_SHZAfvKDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJOA=zO=gM2r4pCVo+orLqE9Q1SSw4h5nXsAHo-e_SHZAfvKDA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 04:45:48PM -0800, Turquette, Mike wrote:
> On Wed, Dec 14, 2011 at 5:18 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Tue, 13 Dec 2011, Mike Turquette wrote:
> >> +void __clk_unprepare(struct clk *clk)
> >> +{
> >> +     if (!clk)
> >> +             return;
> >> +
> >> +     if (WARN_ON(clk->prepare_count == 0))
> >> +             return;
> >> +
> >> +     if (--clk->prepare_count > 0)
> >> +             return;
> >> +
> >> +     WARN_ON(clk->enable_count > 0);
> >
> > So this leaves the clock enable count set. I'm a bit wary about
> > that. Shouldn't it either return (including bumping the prepare_count
> > again) or call clk_disable() ?

No it should not.

> I've hit this in my port of OMAP.  It comes from this simple situation:
> 
> driver 1 (adapted for clk_prepare/clk_unprepare):
> clk_prepare(clk);
> clk_enable(clk);
> 
> ...
> 
> driver2 (not adapted for clk_prepare/clk_unprepare):
> clk_enable(clk);

So this is basically buggy.  Look, it's quite simple.  Convert _all_
your drivers to clk_prepare/clk_unprepare _before_ you start switching
your platform to use these new functions.  You can do that _today_
without exception.

We must refuse to merge _any_ user which does this the old way - and
we should have been doing this since my commit was merged into mainline
to allow drivers to be converted.

And stop trying to think of ways around this inside clk_prepare/
clk_unprepare/clk_enable/clk_disable.  You can't do it.  Just fix _all_
the drivers.  Now.  Before you start implementing clk_prepare/clk_unprepare.
