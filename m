Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270Ab0JFQBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:01:45 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:60141 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759234Ab0JFQAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:00:17 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <lars@metafoo.de>, <akpm@linux-foundation.org>, <kernel@pengutronix.de>,
        <philipp.zabel@gmail.com>, <robert.jarzmik@free.fr>,
        <marek.vasut@gmail.com>, <eric.y.miao@gmail.com>, <rpurdie@rpsys.net>,
        <sameo@linux.intel.com>, <kgene.kim@samsung.com>,
        <linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <STEricsson_nomadik_linux@list.st.com>,
        <arun.murthy@stericsson.com>, <bgat@billgatliff.com>,
        <khilman@deeprootsystems.com>
Subject: [PATCHv3 0/7] PWM core driver for pwm based led and backlight driver
Date: Wed, 6 Oct 2010 21:29:11 +0530
Message-ID: <1286380758-14063-1-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PWM core driver for pwm based led and backlight driver.
The intention of the pwm core driver is not to break the build if two or more
pwm drivers are enabled.
Align the existing pwm drivers to make use of the pwm core driver

Changes v2 - v3
	Replaced the use of linked list to monitor the registered pwm devices
	with class. By using this an interface to the user space through sysfs
	can be provided for debugging purpose.

Further to Kelvin Hilman comments on v2 patch set:
	Had a close look at the Bill patch set. Functionality wise my patch set
	lags the callback implementation and the synchronize. Either Bill can
	send a patch on top of this to implement the same or I can do that
	adding credits to Bill.
	Apart from the above said some more are the handling of duty cycle. It
	is a parameter in function pwm_config() in my patch set. Hence there
	is no need to have seperate function to set/get the same. Reason for
	having this as a parameter in pwm_config() is: the duty cycle, period
	maximum intensity are part of the platform data. Hence manipulation
	of these is done in the client driver(ref: pwm based led and backlight
	driver). I have provided a patch(backlight: add low threshold to pwm
	backlight) for handling this in the pwm backlight (one such client)
	which is now in Andrew's mm tree.

TODO: Align Atmel pwm driver with my pwm core driver patch set.

Arun Murthy (7):
  pwm: Add pwm core driver
  backlight:pwm: add an element 'name' to platform data
  leds: pwm: add a new element 'name' to platform data
  pwm: Align existing pwm drivers with pwm-core driver
  platform: Update the pwm based led and backlight platform data
  pwm: move existing pwm driver to drivers/pwm
  pwm: Modify backlight and led Kconfig aligning to pwm core

 arch/arm/mach-pxa/cm-x300.c               |    1 +
 arch/arm/mach-pxa/colibri-pxa270-income.c |    1 +
 arch/arm/mach-pxa/ezx.c                   |    1 +
 arch/arm/mach-pxa/hx4700.c                |    1 +
 arch/arm/mach-pxa/lpd270.c                |    1 +
 arch/arm/mach-pxa/magician.c              |    1 +
 arch/arm/mach-pxa/mainstone.c             |    1 +
 arch/arm/mach-pxa/mioa701.c               |    1 +
 arch/arm/mach-pxa/palm27x.c               |    1 +
 arch/arm/mach-pxa/palmtc.c                |    1 +
 arch/arm/mach-pxa/palmte2.c               |    1 +
 arch/arm/mach-pxa/pcm990-baseboard.c      |    1 +
 arch/arm/mach-pxa/raumfeld.c              |    1 +
 arch/arm/mach-pxa/tavorevb.c              |    2 +
 arch/arm/mach-pxa/viper.c                 |    1 +
 arch/arm/mach-pxa/z2.c                    |    2 +
 arch/arm/mach-pxa/zylonite.c              |    1 +
 arch/arm/mach-s3c2410/mach-h1940.c        |    1 +
 arch/arm/mach-s3c2440/mach-rx1950.c       |    1 +
 arch/arm/mach-s3c64xx/mach-hmt.c          |    1 +
 arch/arm/mach-s3c64xx/mach-smartq.c       |    1 +
 arch/arm/plat-mxc/pwm.c                   |  166 +++++++++------------
 arch/arm/plat-pxa/pwm.c                   |  210 ++++++++++++--------------
 arch/arm/plat-samsung/pwm.c               |  235 +++++++++++++----------------
 arch/mips/jz4740/pwm.c                    |    2 +-
 drivers/Kconfig                           |    2 +
 drivers/Makefile                          |    1 +
 drivers/leds/Kconfig                      |    2 +-
 drivers/leds/leds-pwm.c                   |    4 +-
 drivers/mfd/Kconfig                       |    9 -
 drivers/mfd/Makefile                      |    1 -
 drivers/mfd/twl-core.c                    |   13 ++
 drivers/mfd/twl6030-pwm.c                 |  163 --------------------
 drivers/misc/Kconfig                      |    9 -
 drivers/misc/Makefile                     |    1 -
 drivers/misc/ab8500-pwm.c                 |  168 --------------------
 drivers/pwm/Kconfig                       |   35 +++++
 drivers/pwm/Makefile                      |    4 +
 drivers/pwm/pwm-ab8500.c                  |  157 +++++++++++++++++++
 drivers/pwm/pwm-core.c                    |  130 ++++++++++++++++
 drivers/pwm/pwm-twl6040.c                 |  196 ++++++++++++++++++++++++
 drivers/video/backlight/Kconfig           |    2 +-
 drivers/video/backlight/pwm_bl.c          |    4 +-
 include/linux/leds_pwm.h                  |    3 +-
 include/linux/pwm.h                       |   31 ++++-
 include/linux/pwm_backlight.h             |    1 +
 46 files changed, 876 insertions(+), 696 deletions(-)
 delete mode 100644 drivers/mfd/twl6030-pwm.c
 delete mode 100644 drivers/misc/ab8500-pwm.c
 create mode 100644 drivers/pwm/Kconfig
 create mode 100644 drivers/pwm/Makefile
 create mode 100644 drivers/pwm/pwm-ab8500.c
 create mode 100644 drivers/pwm/pwm-core.c
 create mode 100644 drivers/pwm/pwm-twl6040.c

-- 
1.7.2.dirty

