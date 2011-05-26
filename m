Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab1EZGye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:54:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60368 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1EZGyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:54:32 -0400
Date: Thu, 26 May 2011 08:54:29 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/4] clk: Implement clk_set_rate
Message-ID: <20110526065429.GL20715@pengutronix.de>
References: <1305876469.325655.313573683829.0.gpush@pororo>
 <1305876469.326620.351525457111.2.gpush@pororo>
 <20110525190347.GH22096@pengutronix.de>
 <1306373867.2875.162.camel@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306373867.2875.162.camel@pororo>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:29:02 up 5 days, 20:08, 19 users,  load average: 0.24, 0.27, 0.37
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[put the lists back on cc]

On Thu, May 26, 2011 at 09:37:47AM +0800, Jeremy Kerr wrote:
> Hi Sascha,
> 
> > > +
> > > +propagate:
> > > +	ret = clk->ops->set_rate(clk->hw, new_rate, &parent_rate);
> > > +
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	/* ops->set_rate may require the parent's rate to change (to
> > > +	 * parent_rate), we need to propagate the set_rate call to the
> > > +	 * parent.
> > > +	 */
> > > +	if (ret == CLK_SET_RATE_PROPAGATE) {
> > > +		new_rate = parent_rate;
> > > +		clk = clk->parent;
> > > +		goto propagate;
> > > +	}
> > 
> > I'm unsure about this one. Every clock should have the ability to stop
> > or continue the rate propagation to the parent. This suggests to leave
> > the decision whether or not to propagate to the core and not to the
> > individual clocks.
> 
> Maybe I'm not understanding you correctly, but that's exactly what this
> code does. The decision to propagate is left up to the
> implementation-specific set_rate callback - if it returns
> CLK_SET_RATE_PROPAGATE (and populate the parent_rate argument with the
> requested parent rate), then we propagate the rate change to the parent.

I understood how the code is meant to work. It's just that IMO the place
where the propagation flag is stored is the wrong one, given that it's a
flag that all clocks (can) have.

> 
> > Right now each mux/div/gate needs an individual propagate flag. By
> > adding the flag to the core the building block implementations could be
> > simpler and the knowledge about propagatability might become handy for
> > the core later.
> 
> We could do this with a flag too, yes. But then there's no way of
> altering the rate (which we need to do with a divider) as we propagate
> it upwards. The current set_rate code lets us do that.

Hm, the core could pass a NULL pointer as the third argument to
set_rate to indicate that the parent rate is not allowed to change.
Then we could initialize &parent_rate to zero before calling set_rate.
If the set_rate function does not change it, we don't have to propagate,
otherwise yes. Or instead we could just use the CLK_SET_RATE_PROPAGATE
return value like we do in the current version.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
