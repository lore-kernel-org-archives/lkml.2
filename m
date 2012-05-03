Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab2ECPAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:00:46 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44892 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab2ECPAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:00:44 -0400
Date: Thu, 3 May 2012 17:00:40 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mfd: add LM3533 lighting-power core driver
Message-ID: <20120503150040.GC15752@localhost>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-2-git-send-email-jhovold@gmail.com>
 <20120503103848.GB3955@opensource.wolfsonmicro.com>
 <20120503112803.GA15752@localhost>
 <20120503113801.GE3955@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503113801.GE3955@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 12:38:02PM +0100, Mark Brown wrote:
> On Thu, May 03, 2012 at 01:28:03PM +0200, Johan Hovold wrote:
> > On Thu, May 03, 2012 at 11:38:48AM +0100, Mark Brown wrote:
> 
> > > I'd expect you can drop these log messages, if there's stuff like this
> > > missing we should add it to regmap.  At the minute the regmap logging is
> > > via trace points rather than debug logs as you can leave them enabled
> > > all the time.
> 
> > If such debugging is added to regmap we still need a way to enable them
> > per driver (or rather regmap) to not clutter the logs.
> 
> This is one of the reasons why we currently use tracepoints (they just
> don't have this issue as they're trivial to filter), though
> adding some sort of infrastructure for it ought not to be too difficult
> even if it's just at the regmap level.

So a /sys/kernel/debug/regmap/<device>/io_printk attribute (with a
better name) to enable debug printks in io paths
(regmap*{read,write,update} outside of mutex) in regmap.c would be
acceptable?

> > These three dev_dbg statements are extremely useful during debugging /
> > development especially in combination with the other dynamic printks in
> > these drivers.
> 
> > I'd actually prefer just keeping them for now.
> 
> OTOH the whole point in having stuff like this is to factor out repeated
> code like this so if the infrastructure isn't working we should fix
> that.

Ok, I'll drop them if you will consider a regmap patch to enable debug
printks to trace reg/val/mask.

> > > Might also be worth moving some of the sysfs stuff to live with the
> > > relevant drivers.
> 
> > Which attributes do you have in mind?
> 
> Pretty much all of those on the MFD.
> 
> > The boost_freq and boost_ovp affect both backlight devices (i.e. cannot
> > be set separately) and as such belong in the parent driver IMO.
> 
> > Same with the output_hvled{1..2}, output_lvled{1..5} attributes. The
> > chip has four logical LEDs ("control banks") but five low-voltage output
> > sinks. The five output_lvled attributes determine the mapping and as
> > such belong in the parent driver. The two logical backlight devices can
> > likewise be used to control either or both high-voltage outputs and
> > belong in the parent driver for the same reasons.
> 
> Actually, the other question I had but forgot to ask (or I think punted
> on for your response) was why these are in sysfs at all - things like
> which things are connected to the backlight are going to be a property
> of the board design so should be defined by the machine not tweaked from
> userspace.

I agree with you and the reason is the same as for the max_current
attribute (discussed in the other thread) -- it was an explicit request
from the end customer.

I could replace the boost attributes with a platform_data entry where it
really belongs.

Regarding the output configuration, the chip defaults are probably what
will be used in most cases (i.e. one-one map of logical backlights/leds
and hvled/lvled outputs except for the last led which controls two
outputs). The plan was to add this to the platform data later.

There is a use case (beyond testing/integration) for keeping the (lvled)
outputs configurable from userspace, in that it provides a way to
synchronise LED activity such as blinking. So I still want to keep those,
at least for the lvleds.

Thanks,
Johan
