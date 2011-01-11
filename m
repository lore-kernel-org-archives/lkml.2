Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab1AKJDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 04:03:32 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51880 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab1AKJDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 04:03:21 -0500
Date: Tue, 11 Jan 2011 10:03:11 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Subject: Re: Locking in the clk API
Message-ID: <20110111090311.GM12078@pengutronix.de>
References: <201101111016.42819.jeremy.kerr@canonical.com>
 <20110111031552.GJ3760@linux-sh.org>
 <201101111211.30172.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101111211.30172.jeremy.kerr@canonical.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:45:05 up 7 days, 17:52, 19 users,  load average: 0.04, 0.67,
 4.82
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 12:11:29PM +0800, Jeremy Kerr wrote:
> Hi Paul,
> 
> > This looks like a complete disaster, and is also completely inconsistent
> > with how the API is being used by the vast majority of users today.
> 
> I've been basing this on the mxc clock code, which acquires a mutex for all 
> clk_enable()s. This may not be representative of the majority of clock usage.

For i.MX we can generally turn this into a spinlock. There are some exceptions
though. Most clocks directly visible for drivers are simple clock gates
which can be made atomic. The root clocks are often enough plls which
can't be enabled atomically, but where we have to spin until the pll is
locked. So we we have exactly the case Russell described: Whether we can
enable a clocks atomically depends on the parent (pll) being enabled or
disabled. We can work around this by calling clk_enable to the pll
explicitely from the platform code.

> 
> From a quick search there are a few other cases of non-atomic clock usage:
> 
> tcc:		clk_enable() acquires a global clocks_mutex
> tegra:	has a clk_enable_cansleep()
> davinci: clk_set_parent() aquires a global clocks_mutex
> 
> Excluding the davinci code (we won't worry about set_parent for now...), if we 
> can port mxc and tcc to a sleepable clk_enable, perhaps we could just go with 
> purely atomic operations.
> 
> We'd still need some method of using sleeping clocks though. How about making 
> clk_enable() BUG if the clock is not atomic, and add clk_enable_cansleep() for 
> the cases where clk->ops.enable may sleep.

Quoting Russell:

> I hate the GPIO APIs for doing this _cansleep crap as the decision of
> whether to use the _cansleep or normal APIs normally can't be made at
> the time when the API is used, but sometime later.  Many people just use
> the non-_cansleep versions irrespective of the context they're in -
> which is unnecessarily restrictive - consider what happens if you then
> have that driver use a GPIO on an I2C peripheral...

Sounds like we should rather have s sleeping clk_enable and a
clk_enable_atomic. This way people can use standard clk_enable until
a 'scheduling while atomic' gives a hint in the right direction.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
