Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab1KGPEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:04:20 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55955 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab1KGPC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:02:58 -0500
From: jic23@cam.ac.uk
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: guenter.roeck@ericsson.com, khali@linux-fr.org, dmitry.torokhov@gmail.com,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        alan@lxorguk.ukuu.org.uk, arnd@arndb.de, linus.walleij@linaro.org,
        lars@metafoo.de, maxime.ripard@free-electrons.com,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 0/6 V2] IIO: Out of staging step 1: The core
Date: Mon,  7 Nov 2011 14:52:37 +0000
Message-Id: <1320677563-18378-1-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@kernel.org>

Dear All,

The cc list for this set is rather arbitary so please do forward to anyone
else who would be interested.

Curiously the vast majority of the changes in here are actually
from work done in the staging tree rather than in this much simpler
to review code.  Oh well, such is life.

Anyhow main changes are one from Lars-Peter and one from me.

Lars-Peter and Dan Carpenter both noted the rather strange use of a
bitmask in which only one bit was ever set and so suggested just using
the underlying enum rather than messing around with shifting it.  An
excellent simple clean up. Thanks guys.

Having done this I pointed out that the difference between shared and
separate channel info elements should only matter up to the point where
we have registered the relevant sysfs attributes.  Having fixed the
drivers where this was not the case, this observation allowed us to
define some magic macros allowing us to halve the length of the
chan_info enum.  Had the nice side effect of simplifying in kernel
interfaces to these elements as they no longer have to care if they
are getting a value shared across multiple channels or not.  This
concept was only ever meant as a convenience for userspace interfaces.
(we can not reasonably cover all interactions anyway so it doesn't
really give much information about the underlying interaction between
the different channels!)

Updated in kernel interface patches to follow.  They are all in of
git tree given below.

Anyhow, the original cover letter was (with links updated to reflect
the fact that our dev tree is back on kernel.org):

Dear All,

Firstly note that I have pushed ahead of this alongside the ongoing
discussions on how to handle in kernel interfaces for the devices
covered by IIO.  I propose to build those on top of this patch
set and will be working on that support whilst this set is
under review.

Secondly, this code has some namespace clashes with the staging
IIO code, so you will need a couple of patches that can be found
in https://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

This is our first attempt to propose moving 'some' of the
Industrial I/O subsystem out of staging.  This cover letter
attempts to explain what IIO is and why it is needed.
All comments welcome on this as well as the code!

So the big question is 'Why is there a need for a new subsystem?'

To answer this we need two things, a list or requirements and analysis
of why current subsystems (hwmon and input) do not meet them. Focused
subsystems targeting just one type of sensor have been rejected as
a concept (see ALS proposal).  Note that there is a certain amount of
overlap with Comedi.  At the moment we are proposing that any attempt
to provide compatible interfaces there occurs in a suitable user-space
library.

Requirements of IIO (note here we are covering just user-space usage.
In kernel interfaces will be dealt with separately once we have
pinned down how to do them cleanly).

1) Simple interface for simple use cases.
2) High performance data route.
3) Generic and consistent 'event' handling.
4) Wide device type coverage with consistent interface.
5) Complex triggering setups - multiple devices capture 'simultaneously'.
6) Support output devices.

Lets take these in turn:

1 - Simple interface for simple use cases:

The requirement boils down to an easy way to get a reading from a device or set
an output without much overhead in terms of user-space code complexity.

This is an area in which hwmon excels. Everything is available via sysfs
and that's exactly what we allow drivers to provide.  Some discussion has
taken place on allowing input devices to export some elements via sysfs
but at least with accelerometers it has floundered on the lack of a
consistent interface.

2 - High performance data route:

We want a path via which data can get to user-space without much overhead,
thus allowing high speed data capture. (Note I'm not arguing we have this
right yet - but the potential is there).

Input comes closest to this, but its approach of treating all data as events
and providing significant filtering options (obviously tailored to human input)
means that it isn't light weight.

The approach taken in IIO is to provide a 'buffered' interface.

The buffer may be in hardware or in software. The 'data' outputs of the
devices being considered can be mapped onto the concept of 'scans'.  In ADCs it
is common to have a single actual converter connected via a multiplexer to a
much larger set of inputs. The multiplexer will select the channels in turn in a
repeating sequence.  Each repeat is termed a scan.  The whole scan clearly
doesn't always occur simultaneously, but can be considered as a single set
of associated data none the less. Typically it is captured considerably faster
than it can be read out over the bus.  Thus we have repeating sequences of data.
This means that the meta data about what we are reading can be read
'out of band' from the data stream itself.

In IIO the buffers consist of a sequence of scans. The contents of each scan
data set (laid out however a driver wants to do it) is provided via a set of
sysfs attributes in the scan_elements directory.

The reason we can do it this way is that unlike input we pass our 'unusual'
events via a different path.
(see point 3).

We also allow for the minimum possible amount of processing of data to occur
in the kernel. Its often best to leave this to user-space and in a number
of important use cases doesn't need doing at all, either because it can be
done offline (logging) or because the reverse transform can be applied
to a much smaller set of data (e.g. software threshold comparison).  Note
that the raw value off the sensor is often considerably more compact to store
than a value in some set of consistent units.

3 - Generic and consistent 'event' handling.

Numerous sensing devices provide threshold type detectors designed to do
simple comparisons on the data without involving the host device.

In input, these are passed within the main event stream (we don't as that
would mean all data would need to carry identifying meta-data along).  Where
these events map to typical human input device elements (double click etc)
these are well handled. Hwmon supports a small set of such events via its alarm
attributes and recently has started using uevents.

For IIO we have decided to try and create an event code (literally one number)
to describe all types of events that these devices can detect and pass on to
the host device. This is coupled with appropriate sysfs controls to configure
the event.  The event code consists of:

1) What type of channel

2) Which channel (either axis / index or just index) Note this can be compound
if modified. (e.g. free fall is typically X&Y&Z all less than alpha). Also there
may be two channel numbers for differential signals.

3) What type of processed data it is applied to (raw value, abs value,
rate of change, average shifted value etc)

4) Which direction the threshold is crossed in.

This simple set of data has covered all events that we may term 'non-error'
events.  Discussions are underway about how to handle true error events
(input is disconnected, loss of tracking etc) but it won't be through this
path.

4 - Device coverage with a consistent interface

Hwmon and input have consistent interfaces that cover their chosen target well.
When considering a wider range of sensors they simply don't generalize well
enough. After all why should they?

Initially we matched hwmon where ever possible. In the end we broke away for a
number of reasons. The in / out naming for voltage is a nasty bit of legacy for
them which we don't want to carry. There is no general way of specifying whether
a channel is an input or an output.  Having said that there is an easy mapping
from IIO to hwmon.

Input is only interested in a narrow set of devices (those for human input).

5) Complex triggering setups

This is probably more of a niche requirement but the generalizations required
for it does simplify simple cases as well.

In a traditional data capturing environment (picture oscilloscopes / data
loggers), the concept of a trigger is vital.  That is, some event on which
data is captured.

In IIO this point is stretched somewhat.  For some devices it is indeed the
point of capture (those with explicit 'capture now' pins, or those that
capture when asked to by a bus transaction).  For other devices that run on
their own internal clocks this is actually a 'data has been captured now'
signal (data-ready).

What we want to allow (where possible) is for any device to be triggered by
any other and crucially for any number of devices to be triggered by a single
source.  As Thomas Gleixner observed, this is pretty much an irq cascade
(and hence that's how it is now implemented - a very tidy approach!).

Some of the types of trigger we have are:

a) Data ready signals
   These usually need to be used to trigger reading from the device producing
   them but can be used to get only 'slightly' late readings from other devices.
b) Software triggers
   These allow user-space to trigger simultaneous capture from a number of
   devices.
c) Standalone triggers.
   General interrupts from where-ever can be used to cause a capture to occur
   - typically a gpio.
d) Hardware timers
   (could probably do with a more consistent interface outside of IIO for
   these).

6) Support output devices.

This is a relatively recent addition to IIO (despite us planning on it when
the name was picked!).  Right now the support is very rudimentary -
corresponding to the most basic sysfs only device interfaces.

It becomes more interesting when buffered outputs are considered, but that
has not yet been implemented.

There is rudimentary support for output in hwmon (as is appropriate for its
use domain) and indeed some of this could map to the regulator api, but
neither is adaptable or suitable for more complex data flows.  Recently
the question of the divide between pwm and dds devices was raised and
it is clearly something that will need pinning down at a later date.

To get an appreciation for the whole subsystem it is necessary to look at
what is still in staging as we aren't attempting to move the whole core
out in one go.  Naturally if anyone fancies diving deeper into that tree
and commenting on stuff in there it would also be welcomed.

Note however that being in staging some of the drivers are in 'interesting'
shape.

'Good' drivers include (and this is far from a complete list)

adc/
	ad7192
	ad7780
	ad7792
	ad799x
	max1363
accel/
	lis3l02dq
gyro/
	adis16260
imu/
	adis16400
light/
	tsl2563


Amit Kucheria (1):
  IIO:light:tsl2563 initial move out of staging.

Jonathan Cameron (3):
  IIO: Core sysfs only support.
  IIO:ADC: max1363 initial import.
  IIO: ABI documetation.

Manuel Stahl (1):
  IIO:imu:adis16400 partial move from staging.

Michael Hennerich (1):
  IIO:ADC:ad799x initial import.

 Documentation/ABI/testing/sysfs-bus-iio |  223 ++++++
 drivers/Kconfig                         |    2 +
 drivers/Makefile                        |    3 +
 drivers/iio/Kconfig                     |   18 +
 drivers/iio/Makefile                    |   10 +
 drivers/iio/adc/Kconfig                 |   30 +
 drivers/iio/adc/Makefile                |    9 +
 drivers/iio/adc/ad799x_core.c           |  761 ++++++++++++++++++++
 drivers/iio/adc/max1363.h               |  148 ++++
 drivers/iio/adc/max1363_core.c          |  997 +++++++++++++++++++++++++++
 drivers/iio/iio.c                       |  591 ++++++++++++++++
 drivers/iio/imu/Kconfig                 |   12 +
 drivers/iio/imu/Makefile                |    6 +
 drivers/iio/imu/adis16400.h             |  180 +++++
 drivers/iio/imu/adis16400_core.c        | 1142 +++++++++++++++++++++++++++++++
 drivers/iio/light/Kconfig               |   16 +
 drivers/iio/light/Makefile              |    6 +
 drivers/iio/light/tsl2563.c             |  654 ++++++++++++++++++
 include/linux/iio/ad799x.h              |   12 +
 include/linux/iio/iio.h                 |  244 +++++++
 include/linux/iio/sysfs.h               |   68 ++
 include/linux/iio/tsl2563.h             |    8 +
 include/linux/iio/types.h               |   52 ++
 23 files changed, 5192 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-iio
 create mode 100644 drivers/iio/Kconfig
 create mode 100644 drivers/iio/Makefile
 create mode 100644 drivers/iio/adc/Kconfig
 create mode 100644 drivers/iio/adc/Makefile
 create mode 100644 drivers/iio/adc/ad799x_core.c
 create mode 100644 drivers/iio/adc/max1363.h
 create mode 100644 drivers/iio/adc/max1363_core.c
 create mode 100644 drivers/iio/iio.c
 create mode 100644 drivers/iio/imu/Kconfig
 create mode 100644 drivers/iio/imu/Makefile
 create mode 100644 drivers/iio/imu/adis16400.h
 create mode 100644 drivers/iio/imu/adis16400_core.c
 create mode 100644 drivers/iio/light/Kconfig
 create mode 100644 drivers/iio/light/Makefile
 create mode 100644 drivers/iio/light/tsl2563.c
 create mode 100644 include/linux/iio/ad799x.h
 create mode 100644 include/linux/iio/iio.h
 create mode 100644 include/linux/iio/sysfs.h
 create mode 100644 include/linux/iio/tsl2563.h
 create mode 100644 include/linux/iio/types.h

-- 
1.7.7.2

