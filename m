Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1ARJVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 04:21:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38894 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab1ARJVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 04:21:33 -0500
Date: Tue, 18 Jan 2011 10:21:28 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/2] Add a common struct clk
Message-ID: <20110118092128.GO9041@pengutronix.de>
References: <1294199462.347935.472473715866.0.gpush@pororo>
 <1294199462.348449.192344022926.1.gpush@pororo>
 <20110111101636.GF26617@pengutronix.de>
 <201101111827.12291.jeremy.kerr@canonical.com>
 <20110111112240.GQ12078@pengutronix.de>
 <20110118084445.GL2122@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110118084445.GL2122@linux-sh.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:53:59 up 2 days, 19:00, 22 users,  load average: 0.61, 1.07,
 0.59
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 05:44:45PM +0900, Paul Mundt wrote:
> On Tue, Jan 11, 2011 at 12:22:40PM +0100, Sascha Hauer wrote:
> > On Tue, Jan 11, 2011 at 06:27:11PM +0800, Jeremy Kerr wrote:
> > > Hi Sascha,
> > >  
> > > > The i.MX clk implementation disables the old parent if clk is enabled
> > > > and enables the new parent if clk is enabled (modulo bugs). Shouldn't
> > > > we do this here aswell?
> > > 
> > > Sounds reasonable, yes.
> > > 
> > > > I thought about returning -EBUSY if clk_set_parent is called for an
> > > > enabled clk, but this way we could never reparent the cpu clock which I
> > > > think is done in the Freescale BSP for power saving.
> > > 
> > > I think that the possibility for changing the parent really depends on the 
> > > implementation; in some cases we may want to disallow it, in others it might 
> > > be fine.
> > > 
> > > Related: do we really need globally-accessible clk_{get,set}_parent in the clk 
> > > API? For cases where we need to set the parent, we probably need details about 
> > > the platform clock configuration (eg, which clocks are possible parents). In 
> > > this case, we could just call into the clock driver directly.
> > 
> > I agree that drivers have no business calling clk_{get,set}_parent, this
> > is purely platform specific.
> > 
> Do you guys even bother to grep the kernel for users of the API before
> coming up with arbitrary policy?

Actually I did bother to grep the kernel and I came up with these
results:

drivers/video/omap2/dss/dss.c:219:      dpll4_ck_rate = clk_get_rate(clk_get_parent(dss.dpll4_m4_ck));
drivers/video/omap2/dss/dss.c:312:      prate = clk_get_rate(clk_get_parent(dss.dpll4_m4_ck));
drivers/video/omap2/dss/dss.c:325:              prate = clk_get_rate(clk_get_parent(dss.dpll4_m4_ck));
drivers/video/omap2/dss/dss.c:344:              prate = clk_get_rate(clk_get_parent(dss.dpll4_m4_ck));
drivers/video/omap2/dss/dss.c:359:              return clk_get_rate(clk_get_parent(dss.dpll4_m4_ck));
drivers/video/sh_mobile_hdmi.c:716:     else if (clk_get_parent(hdmi->hdmi_clk))
drivers/video/sh_mobile_hdmi.c:717:             *parent_rate = clk_get_rate(clk_get_parent(hdmi->hdmi_clk));
drivers/video/sh_mobile_hdmi.c:1089:    if (parent_rate && clk_get_parent(hdmi->hdmi_clk)) {
drivers/video/sh_mobile_hdmi.c:1090:            ret = clk_set_rate(clk_get_parent(hdmi->hdmi_clk), parent_rate);
drivers/usb/host/ehci-omap.c:405:                       ret = clk_set_parent(omap->utmi_p1_fck,
drivers/usb/host/ehci-omap.c:435:                       ret = clk_set_parent(omap->utmi_p2_fck,

In case of the omap2 dss driver the parent rate seems to be used for
calculating valid clock frequencies based on the knowledge that between
the parent clock and the device clock is a divider with some fixed values.
It's arguable whether this is a valid use of the clock API.
In the sh mobile hdmi driver both the device clock and the parent clock
seem to be adjustable and the driver tries to get the best possible rate
by adjusting both clocks. I think this could better be abstracted in the
clock framework.
The omap ehci driver is the only one I found which uses clk_set_parent,
but it uses detailed platform knowledge to do so. Is it really necessary
to put this into a driver?

> 
> There are plenty of cases where clocks are allocated dynamically by
> driver code that in turn can be set up as a parent for other dynamically
> allocated clocks. This has not a damn thing to do with platform code and
> everything to do with the clock circuitry of the device or IP block in
> question.
> 
> If you actually want this API unification thing to not be completely
> stillborn, I recommend focusing on how people are actually using the API
> today (especially the parts that are used by the majority of users, not
> the one you happened to base your implementation off of), and then trying
> to push your interpretation or roadmap for the API at a later stage. This
> way the former has a chance of getting upstream without the latter
> completely derailing it.

The majority of users do not use clk_{get,set}_parent at all. And it's
really questionable whether drivers should know anything about the
layout of the clock tree. I'm pretty sure that these are the code pieces
where there will be a if_soc_rev(x) around it once the next incarnation
of a SoC comes out.

Saascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
