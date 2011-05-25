Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1EYTDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:03:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39869 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab1EYTDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:03:48 -0400
Date: Wed, 25 May 2011 21:03:47 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/4] clk: Implement clk_set_rate
Message-ID: <20110525190347.GH22096@pengutronix.de>
References: <1305876469.325655.313573683829.0.gpush@pororo>
 <1305876469.326620.351525457111.2.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305876469.326620.351525457111.2.gpush@pororo>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:48:50 up 5 days,  8:28, 25 users,  load average: 2.07, 1.49, 1.30
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

On Fri, May 20, 2011 at 03:27:49PM +0800, Jeremy Kerr wrote:
> Implemenent clk_set_rate by adding a set_rate callback to clk_hw_ops,
> and core code to handle propagation of rate changes up and down the
> clock tree.
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> +
> +propagate:
> +	ret = clk->ops->set_rate(clk->hw, new_rate, &parent_rate);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	/* ops->set_rate may require the parent's rate to change (to
> +	 * parent_rate), we need to propagate the set_rate call to the
> +	 * parent.
> +	 */
> +	if (ret == CLK_SET_RATE_PROPAGATE) {
> +		new_rate = parent_rate;
> +		clk = clk->parent;
> +		goto propagate;
> +	}

I'm unsure about this one. Every clock should have the ability to stop
or continue the rate propagation to the parent. This suggests to leave
the decision whether or not to propagate to the core and not to the
individual clocks.
Right now each mux/div/gate needs an individual propagate flag. By
adding the flag to the core the building block implementations could be
simpler and the knowledge about propagatability might become handy for
the core later.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
