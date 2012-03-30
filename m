Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268Ab2C3L7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:59:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60367 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab2C3L7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:59:04 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: tony@atomide.com, linux@arm.linux.org.uk, rpurdie@rpsys.net,
        manuel.lauss@gmail.com, cjb@laptop.org, cbou@mail.ru,
        dwmw2@infradead.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org
Subject: [PATCH v5 00/18] Introduce a led trigger for CPU activity and consolidate LED driver in ARM
Date: Fri, 30 Mar 2012 19:58:15 +0800
Message-Id: <1333108713-12707-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Linus Walleij's ARM LED consolidation work, this patchset introduce a
new generic led trigger for CPU not only for ARM but also for others.

For enabling CPU idle event, CPU arch code should call ledtrig_cpu() stub to
trigger idle start or idle end event.

These patches convert old style LED driver in arch/arm to gpio_led or new led
driver interface. Against linux-next 20120330 and build successfully for all the machines.

Test ledtrig-cpu driver on OMAP4 Panda board.
--
root@omap4430-panda:~# dmesg | grep trig
[    1.891265] LED trigger cpu0 indicate activity on CPU 0
[    1.896728] LED trigger cpu1 indicate activity on CPU 1
root@omap4430-panda:~# cat /sys/class/leds/pandaboard\:\:status1/trigger
none nand-disk mmc0 mmc1 timer [heartbeat] cpu0 cpu1
root@omap4430-panda:~# cat /sys/class/leds/pandaboard\:\:status2/trigger
none nand-disk [mmc0] mmc1 timer heartbeat cpu0 cpu1
root@omap4430-panda:~# echo cpu0 > /sys/class/leds/pandaboard\:\:status1/trigger
root@omap4430-panda:~# cat /sys/class/leds/pandaboard\:\:status1/trigger
none nand-disk mmc0 mmc1 timer heartbeat [cpu0] cpu1
root@omap4430-panda:~# echo cpu1 > /sys/class/leds/pandaboard\:\:status2/trigger
root@omap4430-panda:~# cat /sys/class/leds/pandaboard\:\:status2/trigger
none nand-disk mmc0 mmc1 timer heartbeat cpu0 [cpu1]

Then try some heavy task like dd and use taskset to assign the task to a specific CPU,
LED will turn on or off as expect
--

Please find these patches here:
       git://kernel.ubuntu.com/roc/linux-2.6/.git leds

v4 --> v5:
 * rebase all the patches on top of latest linux-next
 * replace on_each_cpu() with for_each_possible_cpu()
 * add some description of ledtrig_cpu() API
 * remove old leds code from driver nwflash.c, which should use a new led trigger then
 * this trigger driver can be built as module now

v3 --> v4:
 * fix a typo pointed by Jochen Friedrich
 * fix some building errors
 * add Reviewed-by and Tested-by into patch log

v2 --> v3:
 * almost rewrote the whole ledtrig-cpu driver, which is more simple
 * every CPU will have a per-CPU trigger
 * cpu trigger can be assigned to any leds
 * fix a lockdep issue in led-trigger common code
 * other fix according to review

v1 --> v2:
 * remove select operations in Kconfig of every machines
 * add back supporting of led in core module of mach-integrator
 * solidate name scheme in ledtrig-cpu.c
 * add comments of CPU_LED_* cpu led events
 * fold patches of RealView and Versatile together
 * add machine_is_ check during assabet led driver init
 * add some Acked-by in patch logs
 * remove code for simpad machine in machine-sa11000, since Jochen Friedrich
 introduced gpiolib and gpio-led driver for simpad
 * on Assabet and Netwinder machine, LED operations is reversed like:
 setting bit means turn off leds
 clearing bit means turn on leds
 * add a new function to read CM_CTRL register for led driver

Bryan Wu (18):
  led-triggers: create a trigger for CPU activity
  ARM: at91: convert old leds drivers to gpio_led and led_trigger
    drivers
  ARM: mach-realview and mach-versatile: retire custom LED code
  ARM: mach-ks8695: remove leds driver, since nobody use it
  ARM: mach-shark: retire custom LED code
  ARM: mach-orion5x: convert custom LED code to gpio_led and LED CPU
    trigger
  ARM: mach-integrator: move CM_CTRL to header file for accessing by
    other functions
  ARM: mach-integrator: retire custom LED code
  ARM: mach-clps711x: retire custom LED code of P720T machine
  ARM: mach-ebsa110: retire custom LED code
  ARM: mach-footbridge: retire custom LED code
  char: nwflash: remove old led event code
  ARM: mach-pxa: retire custom LED code
  ARM: plat-samsung: remove including old leds event API header file
  ARM: mach-pnx4008: remove including old leds event API header file
  ARM: mach-omap1: retire custom LED code
  ARM: mach-sa1100: retire custom LED code
  ARM: use new LEDS CPU trigger stub to replace old one

 arch/arm/Kconfig                             |   53 -----
 arch/arm/include/asm/leds.h                  |   50 -----
 arch/arm/kernel/Makefile                     |    1 -
 arch/arm/kernel/leds.c                       |  121 -----------
 arch/arm/kernel/process.c                    |    6 +-
 arch/arm/kernel/time.c                       |   17 --
 arch/arm/mach-at91/board-csb337.c            |    3 -
 arch/arm/mach-at91/board-ecbat91.c           |   18 ++-
 arch/arm/mach-at91/board-eco920.c            |   23 ++-
 arch/arm/mach-at91/board-kafa.c              |   17 ++-
 arch/arm/mach-at91/board-kb9202.c            |   23 ++-
 arch/arm/mach-at91/board-rm9200dk.c          |    3 -
 arch/arm/mach-at91/board-rm9200ek.c          |    3 -
 arch/arm/mach-at91/board-sam9-l9260.c        |   23 ++-
 arch/arm/mach-at91/board-sam9261ek.c         |    3 -
 arch/arm/mach-at91/board-yl-9200.c           |    3 -
 arch/arm/mach-at91/include/mach/board.h      |    1 -
 arch/arm/mach-at91/leds.c                    |  105 ---------
 arch/arm/mach-clps711x/Makefile              |    2 -
 arch/arm/mach-clps711x/common.c              |    1 -
 arch/arm/mach-clps711x/include/mach/time.h   |    2 -
 arch/arm/mach-clps711x/p720t-leds.c          |   66 ------
 arch/arm/mach-clps711x/p720t.c               |   59 +++++
 arch/arm/mach-ebsa110/Makefile               |    4 +-
 arch/arm/mach-ebsa110/leds.c                 |   79 +++++---
 arch/arm/mach-footbridge/Makefile            |    4 -
 arch/arm/mach-footbridge/ebsa285-leds.c      |  138 ------------
 arch/arm/mach-footbridge/ebsa285.c           |   79 +++++++
 arch/arm/mach-footbridge/netwinder-hw.c      |  110 +++++++++--
 arch/arm/mach-footbridge/netwinder-leds.c    |  138 ------------
 arch/arm/mach-integrator/Makefile            |    3 +-
 arch/arm/mach-integrator/core.c              |    3 -
 arch/arm/mach-integrator/include/mach/cm.h   |    2 +
 arch/arm/mach-integrator/leds.c              |  158 +++++++++------
 arch/arm/mach-ks8695/Makefile                |    3 -
 arch/arm/mach-ks8695/devices.c               |   21 --
 arch/arm/mach-ks8695/include/mach/devices.h  |    5 -
 arch/arm/mach-ks8695/leds.c                  |   92 --------
 arch/arm/mach-omap1/Makefile                 |    8 -
 arch/arm/mach-omap1/board-h2.c               |   32 +++
 arch/arm/mach-omap1/board-h3.c               |   32 +++
 arch/arm/mach-omap1/board-osk.c              |   33 +++
 arch/arm/mach-omap1/leds-h2p2-debug.c        |  166 ---------------
 arch/arm/mach-omap1/leds-innovator.c         |   98 ---------
 arch/arm/mach-omap1/leds-osk.c               |  113 ----------
 arch/arm/mach-omap1/leds.c                   |   69 ------
 arch/arm/mach-omap1/leds.h                   |    3 -
 arch/arm/mach-omap1/time.c                   |    1 -
 arch/arm/mach-omap1/timer32k.c               |    1 -
 arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c |    1 -
 arch/arm/mach-orion5x/rd88f5181l-ge-setup.c  |    1 -
 arch/arm/mach-orion5x/rd88f5182-setup.c      |   72 ++-----
 arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c |    1 -
 arch/arm/mach-pnx4008/time.c                 |    1 -
 arch/arm/mach-pxa/Makefile                   |    8 -
 arch/arm/mach-pxa/idp.c                      |   79 +++++++
 arch/arm/mach-pxa/leds-idp.c                 |  115 ----------
 arch/arm/mach-pxa/leds-lubbock.c             |  124 -----------
 arch/arm/mach-pxa/leds-mainstone.c           |  119 -----------
 arch/arm/mach-pxa/leds.c                     |   32 ---
 arch/arm/mach-pxa/leds.h                     |   13 --
 arch/arm/mach-pxa/lubbock.c                  |   93 ++++++++
 arch/arm/mach-pxa/mainstone.c                |   92 ++++++++
 arch/arm/mach-realview/core.c                |   39 ----
 arch/arm/mach-realview/core.h                |    2 -
 arch/arm/mach-realview/realview_eb.c         |    5 -
 arch/arm/mach-realview/realview_pb1176.c     |    5 -
 arch/arm/mach-realview/realview_pb11mp.c     |    5 -
 arch/arm/mach-realview/realview_pba8.c       |    5 -
 arch/arm/mach-realview/realview_pbx.c        |    5 -
 arch/arm/mach-sa1100/Makefile                |    9 -
 arch/arm/mach-sa1100/assabet.c               |   83 ++++++++
 arch/arm/mach-sa1100/badge4.c                |   30 +++
 arch/arm/mach-sa1100/cerf.c                  |   42 ++++
 arch/arm/mach-sa1100/hackkit.c               |   32 +++
 arch/arm/mach-sa1100/lart.c                  |   26 +++
 arch/arm/mach-sa1100/leds-assabet.c          |  113 ----------
 arch/arm/mach-sa1100/leds-badge4.c           |  110 ----------
 arch/arm/mach-sa1100/leds-cerf.c             |  109 ----------
 arch/arm/mach-sa1100/leds-hackkit.c          |  111 ----------
 arch/arm/mach-sa1100/leds-lart.c             |  100 ---------
 arch/arm/mach-sa1100/leds.c                  |   50 -----
 arch/arm/mach-sa1100/leds.h                  |   13 --
 arch/arm/mach-shark/Makefile                 |    4 +-
 arch/arm/mach-shark/core.c                   |    1 -
 arch/arm/mach-shark/leds.c                   |  226 ++++++++------------
 arch/arm/mach-versatile/core.c               |    5 -
 arch/arm/plat-omap/Kconfig                   |    3 +-
 arch/arm/plat-omap/debug-leds.c              |  293 ++++++--------------------
 arch/arm/plat-samsung/time.c                 |    1 -
 arch/arm/plat-versatile/Kconfig              |    4 +-
 arch/arm/plat-versatile/leds.c               |   13 +-
 drivers/char/nwflash.c                       |   34 ---
 drivers/leds/Kconfig                         |   10 +
 drivers/leds/Makefile                        |    1 +
 drivers/leds/ledtrig-cpu.c                   |  138 ++++++++++++
 include/linux/leds.h                         |   23 ++
 97 files changed, 1410 insertions(+), 2989 deletions(-)
 delete mode 100644 arch/arm/include/asm/leds.h
 delete mode 100644 arch/arm/kernel/leds.c
 delete mode 100644 arch/arm/mach-clps711x/p720t-leds.c
 delete mode 100644 arch/arm/mach-footbridge/ebsa285-leds.c
 delete mode 100644 arch/arm/mach-footbridge/netwinder-leds.c
 delete mode 100644 arch/arm/mach-ks8695/leds.c
 delete mode 100644 arch/arm/mach-omap1/leds-h2p2-debug.c
 delete mode 100644 arch/arm/mach-omap1/leds-innovator.c
 delete mode 100644 arch/arm/mach-omap1/leds-osk.c
 delete mode 100644 arch/arm/mach-omap1/leds.c
 delete mode 100644 arch/arm/mach-omap1/leds.h
 delete mode 100644 arch/arm/mach-pxa/leds-idp.c
 delete mode 100644 arch/arm/mach-pxa/leds-lubbock.c
 delete mode 100644 arch/arm/mach-pxa/leds-mainstone.c
 delete mode 100644 arch/arm/mach-pxa/leds.c
 delete mode 100644 arch/arm/mach-pxa/leds.h
 delete mode 100644 arch/arm/mach-sa1100/leds-assabet.c
 delete mode 100644 arch/arm/mach-sa1100/leds-badge4.c
 delete mode 100644 arch/arm/mach-sa1100/leds-cerf.c
 delete mode 100644 arch/arm/mach-sa1100/leds-hackkit.c
 delete mode 100644 arch/arm/mach-sa1100/leds-lart.c
 delete mode 100644 arch/arm/mach-sa1100/leds.c
 delete mode 100644 arch/arm/mach-sa1100/leds.h
 create mode 100644 drivers/leds/ledtrig-cpu.c

-- 
1.7.9.1

