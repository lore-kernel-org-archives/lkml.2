Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0KVKFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 05:05:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54545 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab0KVKFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 05:05:37 -0500
Date: Mon, 22 Nov 2010 11:05:32 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Richard Purdie <rpurdie@linux.intel.com>
Cc: akpm <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, stable@kernel.org
Subject: Re: [PATCH] backlight: grab ops_lock before testing bd->ops
Message-ID: <20101122100532.GA4693@pengutronix.de>
References: <1290418989-27653-1-git-send-email-u.kleine-koenig@pengutronix.de> <1290419947.1272.16677.camel@rex>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290419947.1272.16677.camel@rex>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Nov 22, 2010 at 09:59:07AM +0000, Richard Purdie wrote:
> On Mon, 2010-11-22 at 10:43 +0100, Uwe Kleine-König wrote:
> > According to the comment describing ops_lock in the definition of
> > struct backlight_device and when comparing with other functions in
> > backlight.c the mutex must be hold when checking ops to be non-NULL.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> Acked-by: Richard Purdie <rpurdie@linux.intel.com>
The problem was introduced by c835ee7f4154992e6cf0674d7ee136f5d36247a4
(that is in 2.6.29-rc1).  Is this relevant for stable?

Best regards
Uwe
 
> > ---
> >  drivers/video/backlight/backlight.c |   12 ++++++------
> >  1 files changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> > index e207810..0870329 100644
> > --- a/drivers/video/backlight/backlight.c
> > +++ b/drivers/video/backlight/backlight.c
> > @@ -197,12 +197,12 @@ static int backlight_suspend(struct device *dev, pm_message_t state)
> >  {
> >  	struct backlight_device *bd = to_backlight_device(dev);
> >  
> > -	if (bd->ops->options & BL_CORE_SUSPENDRESUME) {
> > -		mutex_lock(&bd->ops_lock);
> > +	mutex_lock(&bd->ops_lock);
> > +	if (bd->ops && bd->ops->options & BL_CORE_SUSPENDRESUME) {
> >  		bd->props.state |= BL_CORE_SUSPENDED;
> >  		backlight_update_status(bd);
> > -		mutex_unlock(&bd->ops_lock);
> >  	}
> > +	mutex_unlock(&bd->ops_lock);
> >  
> >  	return 0;
> >  }
> > @@ -211,12 +211,12 @@ static int backlight_resume(struct device *dev)
> >  {
> >  	struct backlight_device *bd = to_backlight_device(dev);
> >  
> > -	if (bd->ops->options & BL_CORE_SUSPENDRESUME) {
> > -		mutex_lock(&bd->ops_lock);
> > +	mutex_lock(&bd->ops_lock);
> > +	if (bd->ops && bd->ops->options & BL_CORE_SUSPENDRESUME) {
> >  		bd->props.state &= ~BL_CORE_SUSPENDED;
> >  		backlight_update_status(bd);
> > -		mutex_unlock(&bd->ops_lock);
> >  	}
> > +	mutex_unlock(&bd->ops_lock);
> >  
> >  	return 0;
> >  }
> 
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
