Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab1DVTku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 15:40:50 -0400
Received: from imr4.ericy.com ([198.24.6.8]:43156 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab1DVTkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 15:40:45 -0400
Subject: Re: [PATCH v2] misc: Driver for Silicon Labs Si570 and compatibles
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110421233415.GC2786@local>
References: <1303248968-5069-1-git-send-email-guenter.roeck@ericsson.com>
	 <201104201844.30919.arnd@arndb.de> <20110420181652.GA23298@ericsson.com>
	 <201104211311.25988.arnd@arndb.de>  <20110421233415.GC2786@local>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Fri, 22 Apr 2011 12:40:13 -0700
Message-ID: <1303501213.31666.27.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 19:34 -0400, Hans J. Koch wrote:
> On Thu, Apr 21, 2011 at 01:11:25PM +0200, Arnd Bergmann wrote:
> > On Wednesday 20 April 2011, Guenter Roeck wrote:
> > > On Wed, Apr 20, 2011 at 12:44:30PM -0400, Arnd Bergmann wrote:
> > > > On Tuesday 19 April 2011, Guenter Roeck wrote:
> > > > > This driver adds support for Si570, Si571, Si598, and Si599
> > > > > programmable XO/VCXO.
> > > > > 
> > > > > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > > > 
> > > > This needs some more explanation of what the hardware is there for,
> > > > and why it's unlike everything else that we support in Linux.
> > > > 
> > > This is a generic configurable clock device. I'll be happy to add
> > > some text such as "The device can be used for any application requiring
> > > a static or a dynamically configurable clock, such as serdes clocks".
> > > Not sure if that would add much value, though.
> > > 
> > > Regarding "unlike everything else", not sure if that is really correct.
> > > The DDS chips Jonathan mentioned do get pretty close, and there are
> > > other drivers providing support for clock chips, though typically more
> > > dedicated.  ics932s401 in misc is one example, and then there are all
> > > the tuner chips in media/common/tuners/.
> > 
> > Isn't that what you'd normally call a 'struct clk' then?
> > 
> > > > If that is true, it should probably not have a user-visible
> > > > interface, but only an interface that can be used by other
> > > > kernel drivers.
> > > > 
> > > Depends. In our case, turns out the devices consuming the clock
> > > have user mode drivers. Lots of history there, but the chip vendors 
> > > provide those user mode drivers, and the teams responsible for
> > > integrating the drivers decided to not rewrite it to kernel mode drivers.
> > > Also, for special purposes such as margining, it is necessary to control
> > > the clock from userspace. So, for our use case, I need the user-visible
> > > interface. I _don't_ need the kernel interface, at least not right now,
> > > which is why I did not add it.
> > > 
> > > Browsing through the web, it seems the chip is somewhat popular with
> > > Amateur Radio. No idea if it would ever be controlled for such a purpose
> > > from Linux, but if so, it would also require a user configurable frequency.
> > > 
> > > If there is a better place for such a driver than misc, please let me know.
> > 
> > When you say user mode driver, do you mean as in drivers/uio? (taking Hans
> > on Cc for these)
> 
> No UIO driver like that ever reached me.
> 
> > 
> > Those already have generic support for memory and interrupt resources,
> > maybe we can just add a common way to associate a uio device with a struct clk
> > and provide a sysfs or ioctl interface to set a clock for a given device.
> 
> I don't think the UIO framework is the right place for such a thing. If it's
> just this one driver that needs modification of a clock from userspace, then
> a sysfs attribute could be added to that driver. If there are several drivers
> that need this, then the clock framework should be extended.

Agreed. Also, the desire to control the clock frequency _through_ such a
driver (user mode or not) seems odd. Such an approach would be
inherently non-scalable (for my part I would have to support two drivers
already). Voltage regulators are not controlled through the drivers of
the chips they are providing power to either, but have an independent
existence.

Guenter


