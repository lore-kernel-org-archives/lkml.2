Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2LRHrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:47:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47788 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2LRHrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:47:13 -0500
Date: Tue, 18 Dec 2012 08:47:11 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Chao Xie <xiechao.mail@gmail.com>
Cc: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, haojian.zhuang@gmail.com
Subject: Re: common clock framwork: clk_set_rate issue
Message-ID: <20121218074711.GU26326@pengutronix.de>
References: <CADApbej+f9P1sgLMR8_McoCCSLDjJt_qitWdNd8X1v6PwZqsnQ@mail.gmail.com>
 <20121217201945.GA19651@pengutronix.de>
 <CADApbej17udzpStNeY+tsSkeOy_Fv2+o+zKs4zBLV8+ST4DWTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADApbej17udzpStNeY+tsSkeOy_Fv2+o+zKs4zBLV8+ST4DWTg@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:38:07 up 177 days, 22:49, 27 users,  load average: 2.25, 3.11,
 2.87
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 10:19:21AM +0800, Chao Xie wrote:
> On Tue, Dec 18, 2012 at 4:19 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Thu, Dec 06, 2012 at 10:52:03AM +0800, Chao Xie wrote:
> >> hi
> >> When develop the clk drivers for SOCs based on common clock framework.
> >> I met a issue.
> >> For example there is a uart device, it's function clock comes from a
> >> divider, and the divider's parent is a mux. It means
> >>
> >> MUX --> DIV --> UART
> >>
> >> As we know that UART can work at low baudrate for a terminal, while it
> >> can also connect to GPS module which needs a high rate. So the MUX
> >> will provide two clock source, a low clock rate and high clock rate.
> >>
> >> The MUX clk driver clk-mux.c does not implement a ->round_rate callbacks.
> >> It means that when uart driver is used for a GPS and it want to change
> >> it clock, the driver will call clk_set_rate(); clk_set_rate will loop
> >> upward to DIV, and DIV will try to set its divider, and it need loop
> >> upward to MUX.
> >> In fact the current clk drivers have some issue.
> >> MUX clk driver should provide the round_rate callback, it then can
> >> provide a new_rate. It means that in clk_calc_subtree MUX can switch
> >> the clock source.
> >
> > It's not that simple. The input clocks to a mux may not only differ in
> > their rate but can also have other different properties, like for
> > example one input may be always present whereas another input only runs
> > when the CPU is in run mode.
> >
> > It may be a possibility to add a flag to the mux to explicitely
> > allow reparenting on a rate change.
> >
> There is already a flag to do it.
> CLK_SET_RATE_PARENT

That flag has another meaning. It means that a clock is allowed to
change the parents rate when a rate change is requested. What I meant
is a flag that allows a mux to change its parent when a rate change is
requested.
 
> if the mux does not want to changes the input for clk_set_rate called
> by its child, it can clear this flag.
> The question is whether we need add the round_rate/recalc_rate for MUX
> type of clock? Is there any special issue about it that why current
> MUX implementation does not have these callbacks?

They currently do not need these callbacks. When a clock does not have
round_rate propagates up to the parent if CLK_SET_RATE_PARENT is set or
it returns the parents rate if this flag is not set. The situation with
set_rate is similar.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
