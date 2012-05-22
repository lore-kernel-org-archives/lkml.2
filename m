Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab2EVOAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:00:16 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18892 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2EVOAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:00:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 22 May 2012 06:58:45 -0700
Date: Tue, 22 May 2012 16:58:13 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Saravana Kannan <skannan@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Paul Walmsley <paul@pwsan.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clk: Fix race conditions between clk_set_parent() and
 clk_enable()
Message-ID: <20120522135813.GL8730@tbergstrom-lnx.Nvidia.com>
References: <1336798797-8724-1-git-send-email-skannan@codeaurora.org>
 <4FB29E7C.7010606@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FB29E7C.7010606@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 08:20:44PM +0200, Saravana Kannan wrote:
> On 05/11/2012 09:59 PM, Saravana Kannan wrote:
> > Without this patch, the following race conditions are possible.
> >
> > Race condition 1:
> > * clk-A has two parents - clk-X and clk-Y.
> > * All three are disabled and clk-X is current parent.
> > * Thread A: clk_set_parent(clk-A, clk-Y).
> > * Thread A:<snip execution flow>
> > * Thread A: Grabs enable lock.
> > * Thread A: Sees enable count of clk-A is 0, so doesn't enable clk-Y.
> > * Thread A: Releases enable lock.
> > * Thread B: Calls clk_enable(clk-A), which in turn enables clk-X.
> > * Thread A: Switches clk-A's parent to clk-Y in hardware.
> >
> > clk-A is now enabled in software, but not clocking in hardware.
> >
> > Race condition 2:
> > * clk-A has two parents - clk-X and clk-Y.
> > * All three are disabled and clk-X is current parent.
> > * Thread A: clk_set_parent(clk-A, clk-Y).
> > * Thread A:<snip execution flow>
> > * Thread A: Switches parent in hardware to clk-Y.
> > * Thread A: Grabs enable lock.
> > * Thread A: Sees enable count of clk-A is 0, so doesn't disable clk-X.
> > * Thread A: Releases enable lock.
> > * Thread B: Calls clk_enable(clk-A)
> > * Thread B: Software state still says parent is clk-X.
> > * Thread B: So, enables clk-X and then itself.
> > * Thread A: Updates parent in software state to clk-Y.
> >

This looks correct to me. Is there any usecase where enabling/disabling a
clock would require sleeping but changing the parent would not?

Cheers,

Peter.
