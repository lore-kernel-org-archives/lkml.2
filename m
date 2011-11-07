Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab1KGPot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:44:49 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43042 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab1KGPoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:44:44 -0500
From: Jonathan Cameron <jic23@kernel.org>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: guenter.roeck@ericsson.com, khali@linux-fr.org, dmitry.torokhov@gmail.com,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        alan@lxorguk.ukuu.org.uk, arnd@arndb.de, linus.walleij@linaro.org,
        lars@metafoo.de, maxime.ripard@free-electrons.com,
        lm-sensors@lm-sensors.org, thomas.petazzoni@free-electrons.com,
        zdevai@gmail.com, Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 0/5 V4] IIO in kernel interfaces (pull)
Date: Mon,  7 Nov 2011 15:44:36 +0000
Message-Id: <1320680681-5635-1-git-send-email-jic23@kernel.org>
X-Mailer: git-send-email 1.7.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

Changes since V3 are all in processing of raw values to give sensible
hwmon outputs in response to Guenter's comments.

Also rebased on the new version of the IIO core.

Note this is just the association infrastructure and the pull interfaces.
Thus we can handle drivers polling for values.  Doing push interfaces
(interrupt triggered more or less) requires a lot more of the IIO
intrastructure to be in place and so will have to wait a little while.
This is available for the staging tree but will will require the second
large part of IIO to move out of staging (triggered and buffered capture)
plus needs a little more work and a lot more testing.  As the cover letter
for the push interface epxlains there are some complexities of the
interaction of push and pull interfaces on the same physical device.  These
are independent of the external interfaces so shouldn't block this support
merging.

The final patch is not intended for merging, but rather acts as an
example of the board configuration needed.


Since V2:

Fixes as per Guenter's comments on the iio_hwmon driver.
Only one that differred slightly from Guenters suggestion
is the value calculation where I reordered things to reduce
the chance of overflow as well as casting to longs.
Thanks Guenter!

Since V1:
Uses the bus's list of devices instead of having a local one.
     (thanks to Lars-Peter).

Added are interfaces for getting all channels mapped to a particular
device.

Hwmon driver is now vaguely complete - hence cc'd hwmon. If people
are happy I'd expect this to ultimately end up in drivers/hmwon.
Right now it is acting as a test driver for these interfaces.

Thanks and all comments welcome. I've added hwmon to the cc list 
this time round.

V1 message:

There are obviously some rough corners in here that will need cleaning up.
For now I've just put this out there to see if anyone radically disagrees
on the direction.  It sits on top the recent rfc to move first bit of IIO
out of staging with a few buglets fixed.  Best bet if anyone wants to
test is to pull from:

https://github.com/jic23/linux-iio/tree/outofstaging

which now also includes these patches.

Intereresting patches are 3 and 4.  5 gives a trivial example of
a driver using this (hwmon driver that only takes first matching channel
and sticks it out as in1_input - breaks all sorts elements of the hwmon
interface spec.)

For now I've gone with Mark Brown's suggestion of a datasheet_name for
finding the channels on the device.  Patch 2 hacks this name into the
max1363 driver.  I'll probably put a version matching on channel number and
type in at a later date.

Here we just have a pull interface.  Push is considerably harder to do
and needs quite a lot more of the IIO infrastructure to be in place
(triggers / buffers etc). Events obviously require IIO event handling
to be there. Hence all of that will have to wait until those elements
have in of themselves been posted for review.

It is pretty clear to me that hwmon interface for starters needs the
ability to say - 'give me all mappings that correspond to me'.

This is what I intend to add next followed by some utility functions
to make it easy to match the hwmon interface.

At that point I'll propose the hwmon driver goes into drivers/hwmon
(subject to the underlying iio stuff merging).

Fun fun fun.  Thanks to Linus an Mark for their input on this.
Hope this is roughly what you guys were looking for.

Also on my list to do is to check this very thoroughly for any
possible race conditions around the removal of the underlying
device.

Jonathan

Jonathan Cameron (5):
  IIO: core: add datasheet_name to chan_spec
  IIO:ADC:max1363 add datasheet_name entries.
  IIO:CORE add in kernel interface mapping and getting IIO channels.
  IIO:hwmon interface client driver.
  stargate2: example of map configuration for iio to hwmon example.

 arch/arm/mach-pxa/stargate2.c  |   23 ++++
 drivers/Makefile               |    2 +-
 drivers/iio/Kconfig            |    8 ++
 drivers/iio/Makefile           |    2 +
 drivers/iio/adc/max1363_core.c |    2 +
 drivers/iio/iio.c              |  264 +++++++++++++++++++++++++++++++++++++++-
 drivers/iio/iio_hwmon.c        |  227 ++++++++++++++++++++++++++++++++++
 drivers/iio/inkern.c           |   20 +++
 include/linux/iio/iio.h        |    7 +-
 include/linux/iio/inkern.h     |   95 ++++++++++++++
 10 files changed, 643 insertions(+), 7 deletions(-)
 create mode 100644 drivers/iio/iio_hwmon.c
 create mode 100644 drivers/iio/inkern.c
 create mode 100644 include/linux/iio/inkern.h

-- 
1.7.7.2

