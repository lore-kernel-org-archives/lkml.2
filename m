Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab1FPKY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 06:24:57 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:47170 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab1FPKYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 06:24:55 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DF9DBDE.9060907@cam.ac.uk>
Date: Thu, 16 Jun 2011 11:33:02 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: RFC: IIO: Options for 'event' userspace interface.
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Cc list is a bit random, so please do send this on to anyone else
who might be interested!

One of the remaining large questions that needs to be answered
for the Industrial I/O (basically ADCs and DACs, including all
sorts of sensors), is that of how we pass events to user space.

IIO Events

In IIO events are not used for passing normal readings from the
sensing devices to userspace, but rather for out of band information.
(Normal data reaches userspace through a low overhead character
device - typically via either software or hardware buffer.
The stream format is pseudo fixed, so is described and controlled
via sysfs rather than adding headers to the data describing what
is in it).

Pretty much all IIO events correspond to thresholds
on some value derived from one or more raw readings from the
sensor.  They are provided by the underlying hardware.
Examples include:

1) Straight crossing a voltage threshold
2) Moving average crosses a threshold
3) Motion detectors (lots of ways of doing this).
4) Thresholds on sum squared or rms values.
5) Rate of change thresholds.
Lots more weird variants. 

Events need timestamps.
Currently no event carries any 'value'.  There are a few
corner cases where this might be useful, but are unusual.

Current interface:

1) Single user at a time - for vast majority of IIO users this
makes sense, but if it costs us little it would be nice to support
multiple readers.

2) Simple chrdev per device (aggregation across devices doesn't really
make sense for IIO as you tend to really care which sensor caused
the event rather than just that it happened.)

The format is:

struct iio_event_data {
	int	id;
	s64	timestamp;
};

Event codes are built as  below (I've tweaked this a touch from current as there are some
cases of overlapping fields that shouldn't be there).  I suspect we have assigned to
many bits to direction and type and not enough to the modifiers for example.
Fixing that up is probably the topic of another discussion...

/**
* IIO_EVENT_CODE() - event code creation macro
* @channel_class: What type of device channel is associated with the event
* 		(IIO_IN, IIO_ACCEL, IIO_GYRO etc - 256 possible values)
* @orient_bit:	Does this channel have an associated orientation?
* @number:	The channel number. (for differential channels this is non trivial)
*		128 values if no orientation, 8 if oriented
* @modifier:	Only set if orientation associated with channel. May be compound
*		orientation (X_OR_Y_OR_Z for example). (16 options - currently 10 used)
*		Note we can reuse values for different classes.  No accelerometer is going
*		to be specified as being in the infrared spectrum for example!
* @type: 	Threshold, magnitude (level interrupt equivalent) or Rate of Change currently.
* @direction:	Which direction the value must change in to trigger event either, rising, falling.
**/ 
#define IIO_EVENT_CODE(channelclass, orient_bit, number,		\
		       modifier, type, direction)			\
	(channelclass | (orient_bit << 8) | ((number) << 9) |		\
	 ((modifier) << 12) | ((type) << 16) | ((direction) << 24))

Possible reasons to change:

1) Currently have 2 chrdevs per IIO device (one for main data flow, one for events).
2) Lack of adaptablity.
3) Avoid reinventing the wheel.

Obvious options (or ones that have been suggested)

* Use out of band signalling on the main data chrdev.  Basically poll with the more
unusual types, POLLPRI perhaps.  Then use an IOCTL to read what actually happened.
(grep suggests it gets used for something similar in v4l2-subdev.c) (suggested by
Arnd Bergmann).

* Similar system to evdev in input.  This carries a few extra fields, but that probably
doesn't matter. We need to know when an event happened reasonably soon after, but not
asap.

* Separate evdev from input and share it across both subsystems.  This seemed like
a good idea, but evdev is pretty tightly tied to the input core. Note we would never
be sharing input's event codes.  They are too restrictive (with good reason seeing
as they are for 'input' devices!)  Basically I expect this could be done, but would
need to be done very carefully so as to not have any impact on input users.  Perhaps
it is the right answer, but its not trivial. (I've cc'd linux-input to get comments
on this option!)

* Some other event passing methods that I've either forgotten or never knew about
in the first place.

* Leave things be. Its small and simple. Perhaps it's best we don't try to be clever
at all.

So how do people thing we should do it?

Lots of examples of current users in staging/iio/

For reference, most work in IIO since merge window has been driving the new abi
elements introduced into the individual drivers.  Keeps highlighting minor things
we hadn't thought of before, but nothing critical as of yet!

Thanks,

Jonathan
