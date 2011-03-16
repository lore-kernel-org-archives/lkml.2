Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab1CPPP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:15:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65041 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab1CPPPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:15:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: IIO comments
Date: Wed, 16 Mar 2011 16:15:30 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
References: <201103152215.20059.arnd@arndb.de> <201103161433.31303.arnd@arndb.de> <4D80CE2E.9000407@cam.ac.uk>
In-Reply-To: <4D80CE2E.9000407@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103161615.30799.arnd@arndb.de>
X-Provags-ID: V02:K0:WUxbonRe59ertWvda6+mi2sdFtgVWL0JqStKhJPxTpr
 xKp1IjkYnrNIIuUQweyzwEJntqJ5HVXwpSQRKhRX8INfszxKHM
 E5gILuaUCTttwgJhCDkPxIUX8nd6rxrwaJH/b0TB0FJdVMe/OP
 jfsGhxXp2t4hENO7se85xWq3G6MW5ceSicfV4G+M8bXaCfFFw4
 qrYI1fsvOUv0/z/CGyeDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 March 2011, Jonathan Cameron wrote:
> On 03/16/11 13:33, Arnd Bergmann wrote:
> > On Wednesday 16 March 2011, Jonathan Cameron wrote:
> >
> > It's certainly more work for the subsystem, but the intention
> > is to simplify the individual drivers, to make things scale
> > better as many more drivers get added.
>
> I'm yet to be convinced this simplifies things. We basically move
> from one form of big table in the drivers to another and add complexity
> to the core.  I'd be fine with that complexity if it actually simplified
> the drivers, but I'm not sure it does.  Perhaps the only way to really
> answer that is to actually try doing it with a few drivers and see
> where we end up.

Yes. I'm pretty sure it's possible to do better than the current
interface, but don't have a way to prove it.
 
> >> * Whatever you pick also immediately becomes restrictive as the main
> >> class has to be updated to handle any new elements.
> > 
> > I believe that's a good thing, we want to limit the number
> > of different interfaces that people come up with. If two
> > drivers are similar enough, they should probably use the
> > same one.
>
> Limiting them is fine, but there are still an awful lot of
> them - so we still end up with big and ugly tables.

So we should find a way to make it a nice and small table
instead ;-)

> Again currently enforcement of interface is done by review.

I believe enforcing the rules using the compiler is always
better than by review, if all other factors are the same.
 
> > It also makes it easier to verify that all attributes are
> > documented properly, because the documentation only has
> > to be matched with a single file, not with every single
> > driver.
> That would be a gain.  However, the real thing you need
> to check with use of an attribute is not it's naming
> (which is a trivial match against the docs), but that
> the units of whatever is returned are correct. Thus you
> end up looking closely at the docs alongside every driver
> anyway and trawling through datasheets.

Are you currently printing the unit as part of the
attribute output? If that gets handled by the core,
any driver that tries to use something else would
simply be considered a bug.

> > It also forces out-of-tree modules to use the same interfaces
> > that other drivers are using. If someone has hardware for
> > something new, it will only have an interface to talk to
> > after it has been discussed and documented in mainline.
> 
> The question this brings up is how to do we then handle the one
> of a kind interface elements?   However general our spec
> there are always things we don't really want in the core
> as they will only ever be used by one specific driver.
> 
> Right now we operate a policy which says all elements must
> be documented, but those that are not 'general' shouldn't go
> in the main doc files.  Things can move to general the moment
> we find a second device using them. (sometimes we are wrong
> in thinking something is so obscure no one else will ever
> want it).  Note these obscure elements don't get supported by
> any remotely standard userspace code.  Take the TOAS 258x driver
> from Jobn Brenner for example.  That has one nasty calibration
> attribute. Try as we might we really haven't managed to
> blugeon that one into a 'standard' form (it's the coefficients
> of a magic transfer function which takes into account the exact
> glass window over the sensor). Normally we'd argue this should
> be platform data, but Jon has real users where devices that are
> otherwise identical have different glass - hence it must be
> runtime controlled.
> 
> The moment we put a route in for registering additional attributes
> the out-of-tree argument is weakened.

Would it help to have multiple types of interfaces (I suppose
you already do), each with their own table?

This way you could enforce that all drivers of one type use
exactly the same specification, but also make it possible
to have new types, even those that have only one driver by
design.

In the case of the TOAS 258x driver (I can't find that in the
tree), I fear that would still have to become a standard attribute
of some sort.

> >  
> > The whole point would be to avoid duplication, so maybe something
> > a little smarter is needed, but the current code duplicates the
> > definition of attributes to every driver, and I'm sure we can
> > find a solution that requires less code.
> A little less perhaps, but it's still going to be a big table, just of
> subtly different things.
> > 
> > In many cases, you should be able to replace a long switch statement
> > by a table driven approach inside of the driver.
> > 
> I think the only way to answer this is to do a quick implementation of
> this and see how well it works.
> 
> I'll have a crack at this sometime soon with a representative set of
> drivers and see how it goes.

Ok, cool! Just send out the drivers as you get there, and maybe someone
has ideas to simplify them further if you're not happy with the
result.

> > 
> > If you only have the two, you might be able to handle them both
> > in the poll function, where the regular case means POLLIN
> > or POLLRDNORM, while the threshold interrupt gets turned
> > into POLLPRI or POLLRDBAND.
> > 
> > I'm not sure if that covers all cases you are interested in,
> > but it sounds like a useful simplification. It also makes
> > it possible for user programs to only wait for one type of
> > event.
> I will need to have a play and get back to you on this.
> 
> I don't suppose there is anything similar to this in kernel
> I could take a look at?  Its not an area I'm even remotely
> familiar with. Right now I don't see exactly how this helps us
> with the 'out of band' messages not colliding with the main data
> flow.

One way to deal with out of band data (if it's more than just
a flag) is to have an ioctl function that returns structured
data, while the regular read function returns the buffered
input stream.

> > Doesn't epoll handle the event escalation with its edge triggered
> > mode? Basically you can get notified every time that there is
> > more to be read.
> We also need to know how much more this is to be read.  So at the
> moment, if a 50% full turns up and isn't picked up by userspace
> before a 75% full event, the 50% is escalated to become a 75%
> event which userspace then receives.  To be honest I'm tempted,
> for now at least to drop this functionality.  It has few users
> and makes the events system considerably more complex.  We can
> think about how / whether to introduce it later.

Yes, good point. I also don't get the use case of this. Why would
user space not just always read all data that is available?

> Yup, the dynamic route to creation is what I favour.  As you say
> this needs fixing up before going out of staging.  We definitely
> need these for a bridge to input to implement polled input devices.
> 
> I'll put a todo in place for that element in staging so we don't
> forget.

ok

	Arnd
