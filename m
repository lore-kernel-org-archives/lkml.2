Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0DVNB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:01:26 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36092 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab0DVNBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:01:24 -0400
Date: Thu, 22 Apr 2010 16:01:01 +0300
From: Amit Kucheria <amit.kucheria@canonical.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>,
       Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: mxc: utilise usecount field in clock operations
Message-ID: <20100422130101.GA2701@matterhorn.lan>
Mail-Followup-To: Sascha Hauer <s.hauer@pengutronix.de>,
	Russell King <linux@arm.linux.org.uk>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <b9f250fee8e5300e859b2afc234868ba7632f619.1271864861.git.amit.kucheria@canonical.com>
 <20100422115623.GR7882@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100422115623.GR7882@pengutronix.de>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Apr 22, Sascha Hauer wrote:
> On Wed, Apr 21, 2010 at 09:37:31PM +0300, Amit Kucheria wrote:
> > clk->usecount can be used by platform code to check if a clock is active or
> > not.
> 
> The patch seems mostly fine but the commit log not. How about something like
> 'This patch fixes the clock refcounting when reparenting is used.'
> 
> A reference to
> 
> http://www.spinics.net/lists/arm-kernel/msg85879.html
> 
> might help aswell.

Interesting. I had no idea about this work. I was just resurrecting old
patches from January.

Will fix and resend.

/Amit

> > 
> > Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> > ---
> >  arch/arm/plat-mxc/clock.c |   37 ++++++++++++++++++++++++-------------
> >  1 files changed, 24 insertions(+), 13 deletions(-)
> > 
> > diff --git a/arch/arm/plat-mxc/clock.c b/arch/arm/plat-mxc/clock.c
> > index 323ff8c..c791f38 100644
> > --- a/arch/arm/plat-mxc/clock.c
> > +++ b/arch/arm/plat-mxc/clock.c
> > @@ -50,15 +50,15 @@ static DEFINE_MUTEX(clocks_mutex);
> >  
> >  static void __clk_disable(struct clk *clk)
> >  {
> > -	if (clk == NULL || IS_ERR(clk))
> > +	if (clk == NULL || IS_ERR(clk) || !clk->usecount)
> >  		return;
> >  
> > -	__clk_disable(clk->parent);
> > -	__clk_disable(clk->secondary);
> > -
> > -	WARN_ON(!clk->usecount);
> > -	if (!(--clk->usecount) && clk->disable)
> > -		clk->disable(clk);
> > +	if (!(--clk->usecount)) {
> > +		if (clk->disable)
> > +			clk->disable(clk);
> > +		__clk_disable(clk->parent);
> > +		__clk_disable(clk->secondary);
> > +	}
> >  }
> >  
> >  static int __clk_enable(struct clk *clk)
> > @@ -66,12 +66,13 @@ static int __clk_enable(struct clk *clk)
> >  	if (clk == NULL || IS_ERR(clk))
> >  		return -EINVAL;
> >  
> > -	__clk_enable(clk->parent);
> > -	__clk_enable(clk->secondary);
> > -
> > -	if (clk->usecount++ == 0 && clk->enable)
> > -		clk->enable(clk);
> > +	if (clk->usecount++ == 0) {
> > +		__clk_enable(clk->parent);
> > +		__clk_enable(clk->secondary);
> >  
> > +		if (clk->enable)
> > +			clk->enable(clk);
> > +	}
> >  	return 0;
> >  }
> >  
> > @@ -160,17 +161,27 @@ EXPORT_SYMBOL(clk_set_rate);
> >  int clk_set_parent(struct clk *clk, struct clk *parent)
> >  {
> >  	int ret = -EINVAL;
> > +	struct clk *prev_parent = clk->parent;
> >  
> >  	if (clk == NULL || IS_ERR(clk) || parent == NULL ||
> >  	    IS_ERR(parent) || clk->set_parent == NULL)
> >  		return ret;
> >  
> > +	if (clk->usecount != 0) {
> > +		clk_enable(parent);
> > +	}
> > +
> >  	mutex_lock(&clocks_mutex);
> >  	ret = clk->set_parent(clk, parent);
> > -	if (ret == 0)
> > +	if (ret == 0) {
> >  		clk->parent = parent;
> > +	}
> 
> Please remove this hunk. It does not change anything except violating
> the coding style. Also, please remove unnecessary braces.
> 
> >  	mutex_unlock(&clocks_mutex);
> >  
> > +	if (clk->usecount != 0) {
> > +		clk_disable(prev_parent);
> > +	}
> > +
> >  	return ret;
> >  }
> >  EXPORT_SYMBOL(clk_set_parent);
> > -- 
> > 1.7.0.4
> > 
> > 
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

-- 
----------------------------------------------------------------------
Amit Kucheria, Kernel Engineer || amit.kucheria@canonical.com
----------------------------------------------------------------------
