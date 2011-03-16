Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab1CPL4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 07:56:44 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:37627 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab1CPL4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 07:56:38 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D80A5B5.2020805@cam.ac.uk>
Date: Wed, 16 Mar 2011 11:57:41 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: IIO comments
References: <201103152215.20059.arnd@arndb.de>
In-Reply-To: <201103152215.20059.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,
> I've started looking at the current code base in staging,
> this is basically a log of what I'm finding there that
> may get improved:
Thanks for taking a look!
> 
> * Your bus_type is not really a bus in the sense we normally
> use it, because it does not have any driver/device matching.
> You only register devices from the same files that drive
> the hardware. This is normally done using a class, not
> a bus.
That's what I originally thought and indeed how it was
initially done.  The responses from Greg KH and Kay Sievers
to one of our ABI discussions convinced me otherwise.

http://lkml.org/lkml/2010/1/20/233 + the previous email in
that thread.

> 
> * Since you specify the sysfs attributes globally in the
> documentation, it would be nice if drivers did not have
> to implement them as attribute show function, but as
> a function that simply returns a value that is then
> printed by common code. You can do this using a structure
> of function pointers that each driver fills with the
> relevant ones, like file_operations, replacing the
> attribute groups.
This may indeed work.  However it would be a fair bit
more fiddly than that a simple function pointer structure
as the sets of attributes supplied by different devices
vary considerably.  

So to confirm I understand you correctly we either have something like:
/* access ops */

int (*get_accel_x)(struct iio_dev *devinfo)
char *(*get_accel_offset)(struct iio_dev *devinfo); /* note these can't return a value as
they may well be floating point */
char *(*get_accel_gain)(struct iio_dev *devinfo)
int (*get_accel_y)(struct iio_dev *devinfo)

Sticky cases that will make this fiddly.

* Unknown maximum number of some types of attributes.
  - Could use a 
	int (*get_in)(struct iio_dev dev_info, int channel);
	int num_in;
* Whatever you pick also immediately becomes restrictive as the main
class has to be updated to handle any new elements.
* Note we'll have function points for all the scan element related stuff
as well.  Basically the set that would be needed is huge. 

At the end of the day I'm unconvinced this makes sense from the point
of view of simplifying the driver code.  The gain is that it enforces the abi
and may allow in kernel uses.
Ultimately we lifted this approach from hwmon where it works well
under similar circumstances.

Alternative is a small set such as:

/* access ops */
int (*get_channel_value)(struct iio_dev *info, enum CHANNEL);
char (*get_channel_offset)(struct iio_dev *info, enum CHANNEL);

and a list of which channels exist.  Then the driver side becomes a massive
switch statement rather than the attribute tables.  Again, I'm not convinced
that is actually cleaner or easier to understand. Also this approach pretty
much means you end up with large numbers of equal attributes as you can't
trivially group them.  e.g we have accel_scale to cover case where it's the
same for all accelerometer axes.
> 
> * iio_allocate_device() could get a size argument and
> allocate the dev_data together with the iio_dev in 
> a single allocation, like netdev_alloc does. In addition,
> you can pass a structure with all constant data, such
> as THIS_MODULE, and the operations and/or attribute groups,
> instead of having to set them individually for each dev.
Good idea.
> 
> * It's not clear to me why you need one additional device
> and one chardev for each interrupt line of a device, my
> feeling is that this could be simplified a lot if you find
> a way to represent an iio_dev with a single chardev to
> user space. This may have been an attempt to avoid ioctl()
> calls, but I think in this case an ioctl interface would
> be cleaner than a complex hierarchy of devices.
> Another alternative would be for the device driver to
> register multiple iio_devs in case it needs multiple
> interfaces.
In a sense this isn't quite as bad as it seems. The only cases we
have so far (and it's more or less all that's out there) are those where
the device has one interrupt line for 'events' - e.g threshold
interrupts of one type or another, and one for one for data ready
signals.  The data ready signals are handled as triggers and hence
don't have a chardev (directly).

The other uses of chrdevs are for accessing buffers.  Each buffer may have
two of them.  The first is a dirty read chrdev.  The second is
for out of band flow information to userspace.  Basically you
control what events will come out of the flow control chrdev.
Programs block on that and read from the data flow chrdev
according to what comes down the line.  The messy events stuff
is to handle event escalation.  Dealing with getting a 50% full
event and then a 75% full event with no inherent knowledge of
if you read anything in between is a pain.  We could specify
only one level event exists, which would simplify the code
somewhat.  Perhaps wise for an initial merge though I'm loath
to not support functionality that is fairly common in hardware
buffers.

Some buffer implementations don't provide flow control (kfifo_buf)
so for them you just have a read chrdev (actually this isn't true
right now - I need to fix this).  This chrdev is separate from
the 'event' chrdevs purely because for speed reasons. You don't
want to have what is coming down this line change except due
to software interaction (and to do that you normally have to stop
the buffer fill).
> 
> * Neither of your two file operations supports poll(), only
> read. Having poll() support is essential if you want to
> wait for multiple devices in user space. Maybe it's
> possible to convert the code to use eventfd instead of
> rolling your own event interface?
I'll look into this one. Curiously I don't think it has
ever been suggested before. (maybe I'm just forgetful)

We have had the suggestion of using inputs event interface and
I am still considering that option. The issue
there is that it is really far too heavyweight. So far we have
no use cases for multiple readers and we never want to aggregate
across devices.  Also input views events as carrying data. All
actual readings in our case are going through the faster buffer
route.

I agree entirely though that our event interface
needs a rethink.
> 
> * The name rip_lots doesn't really mean anything to me
> as a non-native speaker. Maybe think of a better word for
> this. 
Will do.
> Also, there is only one driver providing such a function,
> so this is probably a good candidate for deferring to a later
> stage, along with all the the entire ring file code that seems
> rather pointless otherwise.
Lots of drivers do it.  They are simply using one of the software
provided buffers.  ring_sw or kfifo_buf (and yes they do have
useless names as well so we'll clean that up for which ever
ones we keep!)
> 
> * The exported symbols should probably become EXPORT_SYMBOL_GPL
Fair enough. That's a nice easy change to make ;)
> 
> * iio-trig-sysfs should not be a platform driver
This one got discussed before merging it and I agree.  We let it
go then because there was a clear use case, a working driver and
no one had the time to do a better job. Michael eventually talked Greg
round to letting it in.

http://marc.info/?t=129665398600002&r=1&w=2
> 
> That's probably enough for today, to start some discussion
> about the core. Overall, I'm pleasantly surprised by the
> quality of the code, it's much better than I was expecting
> after having looked at drivers from hardware vendors a lot
> recently.
*laughs*
To be honest though most academic code is probably even worse.
Other than the Analog dump of drivers (which I'm still
not sure was a good idea) we have been fairly strictly reviewing
changes for a while now.

Thanks again for taking a look.  This sort of general review
from someone not intimately tied up in the code is extremely useful!

Jonathan
