Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab1CKRtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:49:31 -0500
Received: from xes-mad.com ([216.165.139.218]:14286 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab1CKRta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:49:30 -0500
Subject: Re: [PATCH v5 2/4] gpiolib: Add ability to get GPIO direction
From: Peter Tyser <ptyser@xes-inc.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1299544729.6057.73.camel@petert>
References: <1299022100-14564-1-git-send-email-ptyser@xes-inc.com>
	 <1299022100-14564-2-git-send-email-ptyser@xes-inc.com>
	 <20110306073003.GA29325@angua.secretlab.ca>
	 <1299467241.11719.145.camel@ptyser-laptop>
	 <20110307070816.GC29999@angua.secretlab.ca>
	 <1299544729.6057.73.camel@petert>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Mar 2011 11:48:48 -0600
Message-ID: <1299865728.22456.1588.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 18:38 -0600, Peter Tyser wrote:
> On Mon, 2011-03-07 at 00:08 -0700, Grant Likely wrote:
> > On Sun, Mar 06, 2011 at 09:07:21PM -0600, Peter Tyser wrote:
> > > On Sun, 2011-03-06 at 00:30 -0700, Grant Likely wrote:
> > > > On Tue, Mar 01, 2011 at 05:28:18PM -0600, Peter Tyser wrote:
> > > > > Add a new get_direction() function to the gpio_chip structure.  This is
> > > > > useful so that the direction of a GPIO can be determined when its
> > > > > initially exported.  Previously, the direction defaulted to "unknown"
> > > > > regardless of the actual configuration of the GPIO.
> > > > > 
> > > > > If a GPIO driver implements get_direction(), it is called in
> > > > > gpio_request() to set the initial direction of the GPIO accurately.
> > > > 
> > > > I don't like this approach.  It effectively creates two methods for
> > > > determining the direction of a gpio; either ask the driver, or read
> > > > the flags value.  Currently, only gpio_request() actually uses the
> > > > first option, but it still leaves the ambiguity.
> > > > 
> > > > Instead, the driver should be able to preload the direction flag at or
> > > > shortly after gpiochip_add() time.  No need for a new callback hook
> > > > from what I can see.
> > > 
> > > The callback hook was used because the gpio_desc[] structure was local
> > > to gpiolib.c.  The code would have to be restructured a bit to allow
> > > drivers to set the flags themselves.  I can do that if you'd prefer, but
> > > don't think it'd be all that much cleaner.
> > 
> > Make it part of the gpiochip_add function, or add a function for
> > explicitly setting gpio directions.  Should not require any
> > reorganization at all.
> > 
> > > Also, I thought it made sense to read the direction of the GPIO in
> > > gpio_request() because that's the point that the GPIO comes under the
> > > GPIO subsystem's control.  Prior to that, there's a chance the direction
> > > could be changed by platform code, or another driver, etc, so reading
> > > the direction in gpiochip_add() may result in out-of-date directions.
> > 
> > That's the problem with gpiolib having sole responsibility of the
> > cache.  It doesn't give the driver any recourse for changing things if
> > it needs to.  The best solution might very well be to eliminate the
> > direction state flag entirely and force all gpiochip drivers to
> > populate a gpio_get_direction() callback, but that is a lot more work.
> > 
> > > The reading of the direction could also be put in chip drivers'
> > > request() function.  That would get rid of the callback and still ensure
> > > the direction is up-to-date.
> > 
> > I don't object to a callback hook.  My objection is how it is bodged
> > on to work around limitations to the direction being cached in the
> > flags variable.  I want to see a solution that either depends entirely
> > on the callback, or completely fixes the problems with the cached
> > value by allowing the driver to update it.
> 
> I agree it'd be nice to have each driver implement a get_direction()
> function and remove the FLAG_DIR_* flags altogether, but didn't want to
> do the work to 20 drivers which I don't use...  Would you accept a
> series that:
> - Added "unknown" direction support (eg patch 1)
> - Added ability to get GPIO direction (eg patch 2 in this series)
> - Sequence of patches to add get_direction() to all GPIO drivers (most
> of which I couldn't test).
> - Replace checking of FLAG_DIR_* in gpiolib.c with calls to new
> get_direction() function and remove FLAG_DIR_* flags all together.
> 
> 
> It should be relatively easy to add get_direction() to most drivers, and
> I'm willing to do it if all parties would agree it was the proper
> direction to take.  Or do you have any other suggestions about an easier
> migration path?

Ping.  Are you OK with this plan Grant?  Just want to make sure we're on
the same page before starting any more work.

Thanks,
Peter


