Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab1BDKmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 05:42:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54844 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab1BDKmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 05:42:10 -0500
Date: Fri, 4 Feb 2011 11:41:59 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andres Salomon <dilinger@queued.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, alsa-devel@alsa-project.org,
        Samuel Ortiz <sameo@linux.intel.com>, Takashi Iwai <tiwai@suse.de>,
        Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        linux-kernel@vger.kernel.org, Mark@alsa-project.org,
        Jaroslav@alsa-project.org, linux-input@vger.kernel.org,
        Timur Tabi <timur@freescale.com>, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 12/19] twl4030: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110204104159.GA18714@pengutronix.de>
References: <20110202195417.228e2656@queued.net>
 <20110202201522.72d37f1e@queued.net>
 <20110203060521.GA25739@core.coreip.homeip.net>
 <20110202223959.244b4a01@queued.net>
 <20110203065339.GA5592@core.coreip.homeip.net>
 <20110202230326.167fe873@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110202230326.167fe873@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andres,

On Wed, Feb 02, 2011 at 11:03:26PM -0800, Andres Salomon wrote:
> On Wed, 2 Feb 2011 22:53:39 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > On Wed, Feb 02, 2011 at 10:39:59PM -0800, Andres Salomon wrote:
> > > On Wed, 2 Feb 2011 22:05:21 -0800
> > > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > 
> > > > On Wed, Feb 02, 2011 at 08:15:22PM -0800, Andres Salomon wrote:
> > > > >  static int __devinit twl4030_vibra_probe(struct platform_device
> > > > > *pdev) {
> > > > > -	struct twl4030_codec_vibra_data *pdata =
> > > > > pdev->dev.platform_data;
> > > > > +	struct twl4030_codec_vibra_data *pdata =
> > > > > platform_get_drvdata(pdev);
> > > > 
> > > > No, device's drvdata belongs to _this_ driver, and it is supposed
> > > > to manage it and use as it sees fit.
> > > 
> > > Right, so it's used to pass data to the probe function; once the
> > > probe function has obtained the pdata pointer, it's free to do with
> > > it what it will.
> > > 
> > > 
> > > > 
> > > > Note platform_set_drvdata(pdev, info) later in this function along
> > > > with platform_set_drvdata(pdev, NULL) in twl4030_vibra_remove(),
> > > > which means that with your change you will be able to bind the
> > > > device only once.
> > > > 
> > > 
> > > Hm, good point; if the driver is reloaded, the pdev that was
> > > created by mfd-core will have lost the pointer to pdata.
> > > 
> > > I wonder if I should be using mfd's driver_data instead. I used
> > > platform_data because a bunch of drivers had already made use of it
> > > to pass cell information..
> > 
> > Then they are doing it incorrectly. One possible way is to have parent
> > device carry relevant data in its drvdata and have children get it
> > from there.
> > 
> 
> I believe some drivers are even using the parent device already.  See
> drivers/leds/leds-mc13783.c, for example, whose parent device drvdata
> is used to pass around a struct mc13783 to its children.  Sounds
> like a possibility, will need to look into it further.
IMHO this isn't optimal done.  The led driver somehow needs access to a
struct mc13xxx because that one defines how to change the led-related
registers.

If you ask me, the most clean solution would be that the functions like
mc13xxx_lock and mc13xxx_reg_rmw wouldn't take a struct mc13xxx * as
first parameter but a struct device *.  Because in fact it's not the led
driver's business what the mfd driver stores in his driver data.

(Note, I said clean, neither easy nor effective nor best.)

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
