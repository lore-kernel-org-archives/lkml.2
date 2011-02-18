Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab1BRAe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:34:28 -0500
Received: from xes-mad.com ([216.165.139.218]:60628 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758099Ab1BRAeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:34:24 -0500
Subject: Re: [PATCH v3 1/4] gpiolib: Add "unknown" direction support
From: Peter Tyser <ptyser@xes-inc.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <4D5DB833.4070902@bluewatersys.com>
References: <1297983799-4747-1-git-send-email-ptyser@xes-inc.com>
	 <4D5DB833.4070902@bluewatersys.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 18:33:44 -0600
Message-ID: <1297989224.965.18483.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 13:07 +1300, Ryan Mallon wrote:
> On 02/18/2011 12:03 PM, Peter Tyser wrote:
> > Previously, gpiolib would unconditionally flag all GPIO pins as inputs,
> > regardless of their true state.  This resulted in all GPIO output pins
> > initially being incorrectly identified as "input" in the GPIO sysfs.
> > 
> > Since the direction of GPIOs is not known prior to having their
> > direction set, instead set the default direction to "unknown" to prevent
> > user confusion.  A pin with an "unknown" direction can not be written or
> > read via sysfs; it must first be configured as an input or output before
> > it can be used.
> > 
> > While we're playing with the direction flag in/out defines, rename them to
> > a more descriptive FLAG_DIR_* format.
> > 
> > Cc: Alek Du <alek.du@intel.com>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Cc: David Brownell <dbrownell@users.sourceforge.net>
> > Cc: Eric Miao <eric.y.miao@gmail.com>
> > Cc: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
> > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Cc: Joe Perches <joe@perches.com>
> > Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> > ---
> > Change since V1:
> > - This patch is new and is based on feedback from Alan to support a new
> >   "unknown" direction.
> > - Rename FLAG_IS_OUT to FLAG_DIR_OUT, and add FLAG_DIR_IN
> > 
> > Change since V2:
> > - None
> > 
> >  drivers/gpio/gpiolib.c |   91 ++++++++++++++++++++++++++---------------------
> >  1 files changed, 50 insertions(+), 41 deletions(-)
> > 
> > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > index 649550e..eb74311 100644
> > --- a/drivers/gpio/gpiolib.c
> > +++ b/drivers/gpio/gpiolib.c
> > @@ -49,13 +49,14 @@ struct gpio_desc {
> >  	unsigned long		flags;
> >  /* flag symbols are bit numbers */
> >  #define FLAG_REQUESTED	0
> > -#define FLAG_IS_OUT	1
> > -#define FLAG_RESERVED	2
> > -#define FLAG_EXPORT	3	/* protected by sysfs_lock */
> > -#define FLAG_SYSFS	4	/* exported via /sys/class/gpio/control */
> > -#define FLAG_TRIG_FALL	5	/* trigger on falling edge */
> > -#define FLAG_TRIG_RISE	6	/* trigger on rising edge */
> > -#define FLAG_ACTIVE_LOW	7	/* sysfs value has active low */
> > +#define FLAG_DIR_OUT	1	/* pin is an output */
> > +#define FLAG_DIR_IN	2	/* pin is an input */
> > +#define FLAG_RESERVED	3
> > +#define FLAG_EXPORT	4	/* protected by sysfs_lock */
> > +#define FLAG_SYSFS	5	/* exported via /sys/class/gpio/control */
> > +#define FLAG_TRIG_FALL	6	/* trigger on falling edge */
> > +#define FLAG_TRIG_RISE	7	/* trigger on rising edge */
> > +#define FLAG_ACTIVE_LOW	8	/* sysfs value has active low */
> 
> This patch really shouldn't renumber all (and rename some) of the flags.
> Patches should ideally do one thing only, so if you want to rename
> FLAG_IS_OUT to FLAG_DIR_OUT that should be done in a separate patch.
> Same goes for the renumbering, it should be a separate patch to adding
> the support for "unknown" direction.

As far as the renaming of FLAG_IS_* to FLAG_DIR_*, I can see it either
way.  I had to touch nearly all the flags with the patch anyway, so
reasoned it was OK to tweak the name at the same time since they would
be reviewed as part of the larger change.  There's only once instance
(the chunk at line 297) where the change consisted only of a rename -
all other locations had functional changes as well.

For the renumbering, it seems pretty trivial and didn't think it was
worth a unique patch just for it.

Anyway, doesn't matter too much to me.  If the powers that be want this
to be split up (or changed to an enum?) let me know.

Best,
Peter

