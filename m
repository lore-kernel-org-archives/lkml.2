Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab1CPPJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:09:48 -0400
Received: from imr3.ericy.com ([198.24.6.13]:58097 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab1CPPJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:09:43 -0400
Date: Wed, 16 Mar 2011 08:09:10 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Arnd Bergmann <arnd@arndb.de>, Kay Sievers <kay.sievers@vrfy.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Jean Delvare <khali@linux-fr.org>
Subject: Re: IIO comments
Message-ID: <20110316150910.GA28770@ericsson.com>
References: <201103152215.20059.arnd@arndb.de>
 <4D80A5B5.2020805@cam.ac.uk>
 <201103161433.31303.arnd@arndb.de>
 <4D80CE2E.9000407@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D80CE2E.9000407@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 10:50:22AM -0400, Jonathan Cameron wrote:
> On 03/16/11 13:33, Arnd Bergmann wrote:
> > On Wednesday 16 March 2011, Jonathan Cameron wrote:
> >> Hi Arnd,
> >>> I've started looking at the current code base in staging,
> >>> this is basically a log of what I'm finding there that
> >>> may get improved:
> >> Thanks for taking a look!
> >>>
> >>> * Your bus_type is not really a bus in the sense we normally
> >>> use it, because it does not have any driver/device matching.
> >>> You only register devices from the same files that drive
> >>> the hardware. This is normally done using a class, not
> >>> a bus.
> >> That's what I originally thought and indeed how it was
> >> initially done.  The responses from Greg KH and Kay Sievers
> >> to one of our ABI discussions convinced me otherwise.
> >>
> >> http://lkml.org/lkml/2010/1/20/233 + the previous email in
> >> that thread.
> >
> > (adding Kay to Cc here)
> >
> > I see. However, I'd still disagree with Kay here. Given that
> > the common use of existing subsystems is to have "bus" for
> > things that are physically connected, and "class" for things
> > that are logical abstractions, I think we should continue
> > that way for new subsystems, even if there is little difference
> > technically.
> >
> > There is little point discussing how things should have been
> > done in the past when we're stuck with them. The best we
> > can do now is make the code as consistent as possible.
> Leaving this for Kay.
> >
> >>> * Since you specify the sysfs attributes globally in the
> >>> documentation, it would be nice if drivers did not have
> >>> to implement them as attribute show function, but as
> >>> a function that simply returns a value that is then
> >>> printed by common code. You can do this using a structure
> >>> of function pointers that each driver fills with the
> >>> relevant ones, like file_operations, replacing the
> >>> attribute groups.
> >> This may indeed work.  However it would be a fair bit
> >> more fiddly than that a simple function pointer structure
> >> as the sets of attributes supplied by different devices
> >> vary considerably.
> I've cc'd Jean and Guenter as they may be able to offer so
> insight from what they see in hwmon (sorry for dropping you
> in half way through a discussion!)

My thinking is to have only two function pointers (read/write) and index
the actual attribute with a parameter. This would keep the API (much) smaller.

Guenter

> >
> > It's certainly more work for the subsystem, but the intention
> > is to simplify the individual drivers, to make things scale
> > better as many more drivers get added.
> I'm yet to be convinced this simplifies things. We basically move
> from one form of big table in the drivers to another and add complexity
> to the core.  I'd be fine with that complexity if it actually simplified
> the drivers, but I'm not sure it does.  Perhaps the only way to really
> answer that is to actually try doing it with a few drivers and see
> where we end up.
> >
> >> So to confirm I understand you correctly we either have something like:
> >> /* access ops */
> >>
> >> int (*get_accel_x)(struct iio_dev *devinfo)
> >> char *(*get_accel_offset)(struct iio_dev *devinfo); /* note these can't return a value as
> >> they may well be floating point */
> >> char *(*get_accel_gain)(struct iio_dev *devinfo)
> >> int (*get_accel_y)(struct iio_dev *devinfo)
> >>
> >> Sticky cases that will make this fiddly.
> >
> > You can't really return a char* because of the memory allocation,
> > but aside from that, the idea is right, yes.
> sure. It would need a bit of management code around that or
> some suitable encapsulation.
> >
> > Note that this forces all drivers to use the same unit
> > for data they return in the attributes, but I consider
> > this a good thing.
> True, though the other approach to enforcing this is what hwmon
> does.  Thorough review against the spec for all new drivers.
> >
> > For attributes that really want to return a floating point
> > number, I think we should either define a fixed-point
> > form with a constant exponent, or some other representation
> > that is allowed in the kernel.
> >
> >> * Unknown maximum number of some types of attributes.
> >>   - Could use a
> >>      int (*get_in)(struct iio_dev dev_info, int channel);
> >>      int num_in;
> >
> > Good point. So a driver may have multiple attributes
> > of the same type, which need to get enumerated, but should
> > all behave the same way, right?
> >
> > Your suggestion seems good, but I'd still recommend making
> > it so that the core chooses the attribute names, not the
> > device driver. One possible way to lay this out is something
> > like:
> >
> > /* global defines */
> > enum iio_channel_type {
> >       IIO_CHAN_TEMPERATURE,
> >       IIO_CHAN_ADC,
> >       IIO_CHAN_FOO,
> >       ...
> > };
> >
> > static const char *channel_names[] = {
> >       [IIO_CHAN_TEMPERATURE]  = "temperature%d",
> >       [IIO_CHAN_ADC]          = "adc%d",
> >       [IIO_CHAN_FOO]          = "foo%d",
> >       ...
> > };
> >
> > typedef unsigned long long iio_result_t;
> >
> > struct iio_channel_defs {
> >       iio_result_t (*get)(struct iio_dev *dev_info, int channel);
> >
> >       enum iio_channel_type channels[0];
> > };
> >
> > /* example driver */
> > enum {
> >       FOO_CHAN_TEMP0,
> >       FOO_CHAN_TEMP1,
> >       FOO_CHAN_ADC,
> > };
> >
> > struct iio_channel_defs foo_driver_channels = {
> >       .get = &foo_get_sensor,
> >
> >       .channels = {
> >               /* this device has two temperature and one adc input */
> >               [FOO_CHAN_TEMP0] = IIO_CHAN_TEMPERATURE,
> >               [FOO_CHAN_TEMP1] = IIO_CHAN_TEMPERATURE,
> >               [FOO_CHAN_ADC]   = IIO_CHAN_ADC,
> >       },
> > };
> >
> > iio_result_t foo_getsensor(struct iio_dev *dev_info, int channel)
> > {
> >       switch (channel) {
> >       case FOO_CHAN_TEMP0:
> >               return read_temp0(dev_info);
> >       case FOO_CHAN_TEMP1:
> >               return read_temp1(dev_info);
> >       case FOO_CHAN_ADC:
> >               return read_adc(dev_info);
> >       }
> >       return -EINVAL;
> > }
> >
> >> * Whatever you pick also immediately becomes restrictive as the main
> >> class has to be updated to handle any new elements.
> >
> > I believe that's a good thing, we want to limit the number
> > of different interfaces that people come up with. If two
> > drivers are similar enough, they should probably use the
> > same one.
> Limiting them is fine, but there are still an awful lot of
> them - so we still end up with big and ugly tables.  Again
> currently enforcement of interface is done by review.
> >
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
> >
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
> >
> >> * Note we'll have function points for all the scan element related stuff
> >> as well.  Basically the set that would be needed is huge.
> >>
> >> At the end of the day I'm unconvinced this makes sense from the point
> >> of view of simplifying the driver code.  The gain is that it enforces the abi
> >> and may allow in kernel uses.
> >> Ultimately we lifted this approach from hwmon where it works well
> >> under similar circumstances.
> >>
> >> Alternative is a small set such as:
> >>
> >> /* access ops */
> >> int (*get_channel_value)(struct iio_dev *info, enum CHANNEL);
> >> char (*get_channel_offset)(struct iio_dev *info, enum CHANNEL);
> >>
> >> and a list of which channels exist.  Then the driver side becomes a massive
> >> switch statement rather than the attribute tables.  Again, I'm not convinced
> >> that is actually cleaner or easier to understand. Also this approach pretty
> >> much means you end up with large numbers of equal attributes as you can't
> >> trivially group them.  e.g we have accel_scale to cover case where it's the
> >> same for all accelerometer axes.
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
> 
> >>> * It's not clear to me why you need one additional device
> >>> and one chardev for each interrupt line of a device, my
> >>> feeling is that this could be simplified a lot if you find
> >>> a way to represent an iio_dev with a single chardev to
> >>> user space. This may have been an attempt to avoid ioctl()
> >>> calls, but I think in this case an ioctl interface would
> >>> be cleaner than a complex hierarchy of devices.
> >>> Another alternative would be for the device driver to
> >>> register multiple iio_devs in case it needs multiple
> >>> interfaces.
> >> In a sense this isn't quite as bad as it seems. The only cases we
> >> have so far (and it's more or less all that's out there) are those where
> >> the device has one interrupt line for 'events' - e.g threshold
> >> interrupts of one type or another, and one for one for data ready
> >> signals.  The data ready signals are handled as triggers and hence
> >> don't have a chardev (directly).
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
> >
> >> The other uses of chrdevs are for accessing buffers.  Each buffer may have
> >> two of them.  The first is a dirty read chrdev.  The second is
> >> for out of band flow information to userspace.  Basically you
> >> control what events will come out of the flow control chrdev.
> >> Programs block on that and read from the data flow chrdev
> >> according to what comes down the line.  The messy events stuff
> >> is to handle event escalation.  Dealing with getting a 50% full
> >> event and then a 75% full event with no inherent knowledge of
> >> if you read anything in between is a pain.  We could specify
> >> only one level event exists, which would simplify the code
> >> somewhat.  Perhaps wise for an initial merge though I'm loath
> >> to not support functionality that is fairly common in hardware
> >> buffers.
> >>
> >> Some buffer implementations don't provide flow control (kfifo_buf)
> >> so for them you just have a read chrdev (actually this isn't true
> >> right now - I need to fix this).  This chrdev is separate from
> >> the 'event' chrdevs purely because for speed reasons. You don't
> >> want to have what is coming down this line change except due
> >> to software interaction (and to do that you normally have to stop
> >> the buffer fill).
> >
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
> >
> >>> * Neither of your two file operations supports poll(), only
> >>> read. Having poll() support is essential if you want to
> >>> wait for multiple devices in user space. Maybe it's
> >>> possible to convert the code to use eventfd instead of
> >>> rolling your own event interface?
> >> I'll look into this one. Curiously I don't think it has
> >> ever been suggested before. (maybe I'm just forgetful)
> >>
> >> We have had the suggestion of using inputs event interface and
> >> I am still considering that option. The issue
> >> there is that it is really far too heavyweight. So far we have
> >> no use cases for multiple readers and we never want to aggregate
> >> across devices.  Also input views events as carrying data. All
> >> actual readings in our case are going through the faster buffer
> >> route.
> >
> > I'm slightly confused, mainly because I have no idea how the
> > buffer and event interfaces are actually being used. I would
> > have expected an interface as simple as:
> >
> > * One iio device per sensor that can provide data, possibly
> >   many per hardware device
> One per device.
> > * One chardev for each iio device
> currently 1-3. (event line, buffer access, buffer event)
> > * Use epoll to wait for data and/or out-of-band messages
> > * Use chrdev read to get events from the buffer
> and data?
> > * Use sysfs to read from sensors that are not event based
> >
> > What you have is obviously more complex than this, and you
> > probably have good reasons that I still need to understand.
> >
> >>> Also, there is only one driver providing such a function,
> >>> so this is probably a good candidate for deferring to a later
> >>> stage, along with all the the entire ring file code that seems
> >>> rather pointless otherwise.
> >> Lots of drivers do it.  They are simply using one of the software
> >> provided buffers.  ring_sw or kfifo_buf (and yes they do have
> >> useless names as well so we'll clean that up for which ever
> >> ones we keep!)
> >
> > Ok, I see. I did not realize that iio_rip_sw_rb was getting assigned
> > to ->rip_lots.
> renamed to read_first_n which is a somewhat clearer I hope.
> >
> >>> * iio-trig-sysfs should not be a platform driver
> >> This one got discussed before merging it and I agree.  We let it
> >> go then because there was a clear use case, a working driver and
> >> no one had the time to do a better job. Michael eventually talked Greg
> >> round to letting it in.
> >>
> >> http://marc.info/?t=129665398600002&r=1&w=2
> >
> > Ok. I still think that it is a really bad idea because the driver
> > is essentially a software feature that could be use on any machine,
> > but using a platform device ties it directly to a specific machine
> > that registers the device. It would make much more sense to
> > remove all the driver registration from there and just create the
> > iio device at module load time, or to have some interface that
> > can be used to dynamically create these triggers if the module
> > is loaded.
> Yup, the dynamic route to creation is what I favour.  As you say
> this needs fixing up before going out of staging.  We definitely
> need these for a bridge to input to implement polled input devices.
> 
> I'll put a todo in place for that element in staging so we don't
> forget.
> >
> >       Arnd
> >
> 
