Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab1D2JQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 05:16:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40827 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab1D2JQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 05:16:24 -0400
Date: Fri, 29 Apr 2011 11:16:15 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        shiraz.hashim@st.com,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 5/5] driver core: let dev_set_drvdata return int
 instead of void as it can fail
Message-ID: <20110429091615.GR31131@pengutronix.de>
References: <20110420074248.GS31131@pengutronix.de>
 <1303285486-28598-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1303285486-28598-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110429081257.GW17290@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110429081257.GW17290@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 29, 2011 at 09:12:57AM +0100, Russell King - ARM Linux wrote:
> On Wed, Apr 20, 2011 at 09:44:46AM +0200, Uwe Kleine-König wrote:
> > Before commit
> > 
> > 	b402843 (Driver core: move dev_get/set_drvdata to drivers/base/dd.c)
> > 
> > calling dev_set_drvdata with dev=NULL was an unchecked error. After some
> > discussion about what to return in this case removing the check (and so
> > producing a null pointer exception) seems fine.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> >  drivers/base/dd.c      |    7 +++----
> >  include/linux/device.h |    2 +-
> >  2 files changed, 4 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> > index da57ee9..f9d69d7 100644
> > --- a/drivers/base/dd.c
> > +++ b/drivers/base/dd.c
> > @@ -408,17 +408,16 @@ void *dev_get_drvdata(const struct device *dev)
> >  }
> >  EXPORT_SYMBOL(dev_get_drvdata);
> >  
> > -void dev_set_drvdata(struct device *dev, void *data)
> > +int dev_set_drvdata(struct device *dev, void *data)
> >  {
> >  	int error;
> >  
> > -	if (!dev)
> > -		return;
> >  	if (!dev->p) {
> >  		error = device_private_init(dev);
> >  		if (error)
> > -			return;
> > +			return error;
> >  	}
> >  	dev->p->driver_data = data;
> > +	return 0;
> 
> Who is going to modify all the thousands of drivers we have in the kernel
> tree to check this return value?
> 
> If the answer is no one, its pointless returning an error value in the
> first place (which I think is what the original author already thought
> about.)
In the meantime I learned that dev->p is valid when the device is
registered. As calling dev_set_drvdata on an unregisted device is not
allowed maybe issuing a warning instead would be OK for me, too.

Thoughts?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
