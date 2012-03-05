Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab2CEJjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 04:39:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59607 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab2CEJju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 04:39:50 -0500
Date: Mon, 5 Mar 2012 10:29:48 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: "Turquette, Mike" <mturquette@ti.com>,
        Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v5 4/4] clk: basic clock hardware types
Message-ID: <20120305092948.GV3852@pengutronix.de>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-5-git-send-email-mturquette@linaro.org>
 <20120304174229.GD11546@lunn.ch>
 <CAJOA=zNWN6L+-YEkNKoQnjnrrswNpCBmtnhKBm04HekWP46i5w@mail.gmail.com>
 <20120305084823.GD24858@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305084823.GD24858@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:21:22 up 113 days, 17:08, 50 users,  load average: 0.06, 0.57,
 0.93
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 09:48:23AM +0100, Andrew Lunn wrote:
> On Sun, Mar 04, 2012 at 04:30:08PM -0800, Turquette, Mike wrote:
> > On Sun, Mar 4, 2012 at 9:42 AM, Andrew Lunn <andrew@lunn.ch> wrote:
> > > On Sat, Mar 03, 2012 at 12:29:01AM -0800, Mike Turquette wrote:
> > >> Many platforms support simple gateable clocks, fixed-rate clocks,
> > >> adjustable divider clocks and multi-parent multiplexer clocks.
> > >>
> > >> This patch introduces basic clock types for the above-mentioned hardware
> > >> which share some common characteristics.
> > >
> > > Hi Mike
> > >
> > > These basic clocks don't allow the use of prepare/unprepare, from the
> > > side of the clock provider. I think i need this.
> > 
> > This is an interesting point and might help us nail down exactly what
> > we expect from clk_prepare/clk_unprepare.
> > 
> > >
> > > The Orion Kirkwood SoC has clock gating for most of its on chip
> > > peripherals, which the other older Orion devices don't have. The SATA
> > > and PCIe also allows the PHY to be shut down, again which older Orion
> > > devices don't have. The current code links the clock and the PHY
> > > together, shutting both down are the same time. So i would like to
> > > perform the PHY shutdown in the unprepare() function of the clk
> > > driver.
> > 
> > Do you feel it is The Right Thing to enable/disable the phy from
> > clk_prepare/clk_unprepare?  
> 
> Humm, not sure yet. I don't know all the different possibilities,
> which is why i tried to describe my use case, rather than just assume
> i need prepare/unprepare.
> 
> I also realized i did not explain my use case properly. 
> 
> At boot, uboot is turning on various clocks and SATA/PCIe PHYs etc, in
> order to get the device booted. Linux takes over, and the
> Orion/kirkwood board files, ask the kirkwood or generic Orion code to
> create platform_data structures for the different devices that the
> board uses. The kirkwood code keeps a bitmap of devices for which it
> creates platform data for which there is a gated clock. Then in a
> lateinit call, it turns on clocks which are needed, and also turns off
> clocks which are no longer needed, because the board did not ask for a
> driver binding for that device. If it turns off a SATA or PCIe clock,
> it also turns off the PHY associated with it.
> 
> So we are talking about turning off hardware for which there is no
> driver. This seems to exclude pm_runtime_get(_sync), which is about
> hardware with drivers.
> 
> We touched on this subject a couple of months ago, at least with
> respect to clocks. You said that is what the flag CLK_IGNORE_UNUSED
> will be used for. In a lateinit call, you plan to iterate over all
> clocks and turn off any which don't have CLK_IGNORE_UNUSED and have
> not been enabled. I assume you will call both disable() and
> unprepare(), and if i've can put code into the unprepare to turn the
> PHY off, all is good.
> 
> > > Is allowing to pass prepare/unprepare functions to basic clocks
> > > something you want to support? If i prepare a patch would you consider
> > > it?
> > 
> > My original instinct was "no".  The simple gate clock was always
> > supposed to be "simple" and if you need more than it provides then it
> > might be best for your platform to implement a specific clock type.
> > Especially since the purpose of clk_prepare is still up in the air.
> 
> I think i can wrap your simple gate clock, to make my "complex" gate
> clock. What would help is if you would EXPORT_SYMBOL_GPL
> clk_gate_enable() and clk_gate_disable(), since they do exactly what i
> want. I can then build my own clk_ops structure, with my own
> unprepare() function. I would probably use DEFINE_CLK_GATE as is, and
> then at run time, before calling __clk_init() overwrite the .ops with
> my own version.

Maybe I don't get your point, but clk_unprepare should be used when
you have to sleep to disable your clock. When clk_gate_disable() is
exactly why do you want to use clk_unprepare instead of clk_disable?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
