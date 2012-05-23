Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab2EWJSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:18:24 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6454 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab2EWJST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:18:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 23 May 2012 02:16:50 -0700
Date: Wed, 23 May 2012 12:16:17 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: "Turquette, Mike" <mturquette@ti.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Saravana Kannan <skannan@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH] clk: Fix race conditions between clk_set_parent() and
 clk_enable()
Message-ID: <20120523091617.GZ8730@tbergstrom-lnx.Nvidia.com>
References: <1336798797-8724-1-git-send-email-skannan@codeaurora.org>
 <4FB29E7C.7010606@codeaurora.org>
 <20120522135813.GL8730@tbergstrom-lnx.Nvidia.com>
 <CAJOA=zOcEQc70gg+4U2jNaNRTB5YeyOwgsL12YWNoviQ5qFjaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAJOA=zOcEQc70gg+4U2jNaNRTB5YeyOwgsL12YWNoviQ5qFjaQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 08:06:45PM +0200, Turquette, Mike wrote:
> On Tue, May 22, 2012 at 6:58 AM, Peter De Schrijver
> <pdeschrijver@nvidia.com> wrote:
> > On Tue, May 15, 2012 at 08:20:44PM +0200, Saravana Kannan wrote:
> >> On 05/11/2012 09:59 PM, Saravana Kannan wrote:
> >> > Without this patch, the following race conditions are possible.
> >> >
> >> > Race condition 1:
> >> > * clk-A has two parents - clk-X and clk-Y.
> >> > * All three are disabled and clk-X is current parent.
> >> > * Thread A: clk_set_parent(clk-A, clk-Y).
> >> > * Thread A:<snip execution flow>
> >> > * Thread A: Grabs enable lock.
> >> > * Thread A: Sees enable count of clk-A is 0, so doesn't enable clk-Y.
> >> > * Thread A: Releases enable lock.
> >> > * Thread B: Calls clk_enable(clk-A), which in turn enables clk-X.
> >> > * Thread A: Switches clk-A's parent to clk-Y in hardware.
> >> >
> >> > clk-A is now enabled in software, but not clocking in hardware.
> >> >
> >> > Race condition 2:
> >> > * clk-A has two parents - clk-X and clk-Y.
> >> > * All three are disabled and clk-X is current parent.
> >> > * Thread A: clk_set_parent(clk-A, clk-Y).
> >> > * Thread A:<snip execution flow>
> >> > * Thread A: Switches parent in hardware to clk-Y.
> >> > * Thread A: Grabs enable lock.
> >> > * Thread A: Sees enable count of clk-A is 0, so doesn't disable clk-X.
> >> > * Thread A: Releases enable lock.
> >> > * Thread B: Calls clk_enable(clk-A)
> >> > * Thread B: Software state still says parent is clk-X.
> >> > * Thread B: So, enables clk-X and then itself.
> >> > * Thread A: Updates parent in software state to clk-Y.
> >> >
> >
> > This looks correct to me. Is there any usecase where enabling/disabling a
> > clock would require sleeping but changing the parent would not?
> >
> 
> clk_enable & clk_disable must never sleep.  clk_prepare and
> clk_unprepare may sleep.
> 

In that case the clock is actually enabled in clk_prepare and disabled in
clk_unprepare I guess (and clk_enable/clk_disable are dummy functions)?

What I'm trying to say is that I don't think there are clocks which can be
enabled/disabled using non blocking operations, but where a parent change
would require a blocking operation.

Cheers,

Peter.
