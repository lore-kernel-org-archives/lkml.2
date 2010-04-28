Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab0D1WRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:17:47 -0400
Received: from tex.lwn.net ([70.33.254.29]:48807 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383Ab0D1WRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:17:46 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [RFC] Second OLPC Viafb series, v2
Date: Wed, 28 Apr 2010 16:17:01 -0600
Message-Id: <1272493051-25380-1-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second posting of the second series of viafb patches.  What's
added here is a big refactoring of the driver to split its functions apart
and the addition of code for GPIO, interrupt, DMA, and camera management.

The following changes have been made since the first version:

 - A couple of small fixes have been made to the first series.  The
   OLPC-specific tests for i2c access have been removed since they broke
   the linux-next build, and we don't try to do i2c on ports which have not
   traditionally been used that way.  For that reason, I'm including that
   initial series here; the whole set applies to 2.6.34-rc3.

 - The build problems encountered by Florian (GPIOLIB and module stuff)
   have been fixed.  I have *not* made fb/i2c/gpio into separate modules at
   this point, though that is the clear destination of this work.  That's a
   bit messy and I didn't want to complicate these patches further; I will
   do it in the future.

 - I merged in all of Florian's cleanup patches from a couple of weeks
   ago.  I've not looked at the new suspend/resume patches yet.

Note that the camera driver (the last in the series) is not yet ready for
submission; I add it here for completeness.

The full series of patches can be pulled from:

	git://git.lwn.net/linux-2.6.git viafb-posted

Some of this stuff is disruptive, and I only have one machine to test it
all on, so I'd really appreciate it if folks with other types of hardware
could try them out.

Chris Ball (1):
      viafb: Add 1200x900 DCON/LCD panel modes for OLPC XO-1.5

Florian Tobias Schandinat (7):
      viafb: package often used basic io functions
      viafb: unify modesetting functions
      viafb: move some modesetting functions to a seperate file
      viafb: replace inb/outb
      viafb: improve misc register handling
      viafb: fix proc entry removal
      viafb: make procfs entries optional

Harald Welte (4):
      viafb: Fix various resource leaks during module_init()
      viafb: use proper pci config API
      viafb: Determine type of 2D engine and store it in chip_info
      viafb: rework the I2C support in the VIA framebuffer driver

Jonathan Corbet (17):
      viafb: Unmap the frame buffer on initialization error
      viafb: Retain GEMODE reserved bits
      viafb: Unify duplicated set_bpp() code
      viafb: complete support for VX800/VX855 accelerated framebuffer
      viafb: Only establish i2c busses on ports that always had them
      viafb: Move core stuff into via-core.c
      viafb: Separate global and fb-specific data
      viafb: add a driver for GPIO lines
      viafb: Convert GPIO and i2c to the new indexed port ops
      viafb: Turn GPIO and i2c into proper platform devices
      via: Do not attempt I/O on inactive I2C adapters
      viafb: Introduce viafb_find_i2c_adapter()
      via: Rationalize vt1636 detection
      viafb: Add a simple interrupt management infrastructure
      viafb: Add a simple VX855 DMA engine driver
      viafb: Reserve framebuffer memory for the upcoming camera driver
      viafb: Add a driver for the video capture engine

Paul Fox (1):
      suppress verbose debug messages: change printk() to DEBUG_MSG()

 drivers/video/Kconfig               |   27 
 drivers/video/via/Makefile          |    7 
 drivers/video/via/accel.c           |  137 ++-
 drivers/video/via/accel.h           |   40 +
 drivers/video/via/chip.h            |    8 
 drivers/video/via/dvi.c             |   37 
 drivers/video/via/global.c          |    2 
 drivers/video/via/global.h          |    1 
 drivers/video/via/hw.c              |  308 +------
 drivers/video/via/hw.h              |   21 
 drivers/video/via/ioctl.h           |    2 
 drivers/video/via/lcd.c             |   31 
 drivers/video/via/lcd.h             |    2 
 drivers/video/via/share.h           |    9 
 drivers/video/via/via-camera.c      | 1399 ++++++++++++++++++++++++++++++++++++
 drivers/video/via/via-camera.h      |   93 ++
 drivers/video/via/via-core.c        |  652 ++++++++++++++++
 drivers/video/via/via-core.h        |  173 ++++
 drivers/video/via/via-gpio.c        |  287 +++++++
 drivers/video/via/via-gpio.h        |   14 
 drivers/video/via/via_i2c.c         |  230 ++++-
 drivers/video/via/via_i2c.h         |   24 
 drivers/video/via/via_io.h          |   67 +
 drivers/video/via/via_modesetting.c |  126 +++
 drivers/video/via/via_modesetting.h |   38 
 drivers/video/via/viafbdev.c        |  179 ++--
 drivers/video/via/viafbdev.h        |   14 
 drivers/video/via/viamode.c         |   14 
 drivers/video/via/vt1636.c          |   34 
 drivers/video/via/vt1636.h          |    2 
 include/media/v4l2-chip-ident.h     |    4 
 31 files changed, 3416 insertions(+), 566 deletions(-)

Thanks,

jon


