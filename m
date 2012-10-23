Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287Ab2JWSoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:44:32 -0400
Received: from 173-160-178-141-Washington.hfc.comcastbusiness.net ([173.160.178.141]:46264
	"EHLO relay" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932341Ab2JWSoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:44:30 -0400
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
To: andrey.smirnov@convergeddevices.net
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/6] Driver for Si476x series of chips
Date: Tue, 23 Oct 2012 11:44:26 -0700
Message-Id: <1351017872-32488-1-git-send-email-andrey.smirnov@convergeddevices.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a third version of the patchset originaly posted here:
https://lkml.org/lkml/2012/9/13/590

Second version of the patch was posted here:
https://lkml.org/lkml/2012/10/5/598

To save everyone's time I'll repost the original description of it:

This patchset contains a driver for a Silicon Laboratories 476x series
of radio tuners. The driver itself is implemented as an MFD devices
comprised of three parts: 
 1. Core device that provides all the other devices with basic
functionality and locking scheme.
 2. Radio device that translates between V4L2 subsystem requests into
Core device commands.
 3. Codec device that does similar to the earlier described task, but
for ALSA SoC subsystem.

v3 of this driver has following changes:
 - All custom ioctls were moved to be V4L2 controls or debugfs files
 - Chip properties handling was moved to regmap API, so this should
   allow for cleaner code, and hopefully more consistent behaviour of
   the driver during switch between AM/FM(wich involevs power-cycling
   of the chip)

I was hoping to not touch the code of the codec driver, since Mark has
already appplied the previous version, but because of the last item I
had to.

Unfotunately, since my ARM setup runs only 3.1 kernel, I was only able
to test this driver on a standalone USB-connected board that has a
dedicated Cortex M3 working as a transparent USB to I2C bridge which
was connected to a off-the-shelf x86-64 laptop running Ubuntu with
custom kernel compile form git.linuxtv.org/media_tree.git. Which means
that I was unable to test the change in the codec code, except for the
fact the it compiles.


Here is v4l2-compliance output for one of the tuners(as per Hans'
request):

sudo v4l2-compliance -r /dev/radio0
is radio
Driver Info:
	Driver name   : si476x-radio0
	Card type     : SI476x AM/FM Receiver
	Bus info      : platform:si476x-radio0
	Driver version: 3.6.0
	Capabilities  : 0x81050500
		RDS Capture
		Tuner
		Radio
		Read/Write
		Device Capabilities
	Device Caps   : 0x01050500
		RDS Capture
		Tuner
		Radio
		Read/Write

Compliance test for device /dev/radio0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second radio open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G_CHIP_IDENT: OK
	test VIDIOC_DBG_G/S_REGISTER: OK
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER: OK
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_S_HW_FREQ_SEEK: OK
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 0 Audio Inputs: 0 Tuners: 1

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Control ioctls:
	test VIDIOC_QUERYCTRL/MENU: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 2 Private Controls: 8

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)

Total: 38, Succeeded: 38, Failed: 0, Warnings: 0

Andrey Smirnov (6):
  Add header files and Kbuild plumbing for SI476x MFD core
  Add the main bulk of core driver for SI476x code
  Add commands abstraction layer for SI476X MFD
  Add chip properties handling code for SI476X MFD
  Add a V4L2 driver for SI476X MFD
  Add a codec driver for SI476X MFD

 drivers/media/radio/Kconfig        |   17 +
 drivers/media/radio/Makefile       |    1 +
 drivers/media/radio/radio-si476x.c | 1549 ++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                |   14 +
 drivers/mfd/Makefile               |    3 +
 drivers/mfd/si476x-cmd.c           | 1546 +++++++++++++++++++++++++++++++++++
 drivers/mfd/si476x-i2c.c           |  966 ++++++++++++++++++++++
 drivers/mfd/si476x-prop.c          |  257 ++++++
 include/linux/mfd/si476x-core.h    |  539 +++++++++++++
 include/media/si476x.h             |  427 ++++++++++
 sound/soc/codecs/Kconfig           |    4 +
 sound/soc/codecs/Makefile          |    2 +
 sound/soc/codecs/si476x.c          |  259 ++++++
 13 files changed, 5584 insertions(+)
 create mode 100644 drivers/media/radio/radio-si476x.c
 create mode 100644 drivers/mfd/si476x-cmd.c
 create mode 100644 drivers/mfd/si476x-i2c.c
 create mode 100644 drivers/mfd/si476x-prop.c
 create mode 100644 include/linux/mfd/si476x-core.h
 create mode 100644 include/media/si476x.h
 create mode 100644 sound/soc/codecs/si476x.c

-- 
1.7.10.4

