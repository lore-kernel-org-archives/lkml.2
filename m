Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab2KOKEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:04:24 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37045 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab2KOKEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:04:20 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, jonas.aberg@stericsson.com,
        linux@arm.linux.org.uk, will.deacon@arm.com
Subject: [PATCH 0/2] Boottime: measure bootloader and kernel bootup time
Date: Thu, 15 Nov 2012 10:04:05 +0000
Message-Id: <1352973847-21605-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset supplies a new tool which measures boottime inclusive
of bootloader involvement. It seems to be accurate and adds no
latency to the booting of the system.

In the first round of testing we booted the kernel 3 times each with
boottime enabled and disabled. Actually, when it was disabled, the
code was completely removed from the kernel source and the kernel was
rebuilt. The difference between present & enabled and completely
removed was very little indeed. In fact, averaging out the 3 runs of
each, when boottime was enabled the system booted 4ms _faster_, go
figure!

             Enabled    Disabled
  1st run    2.983093   2.985168
  2nd run    2.973266   2.971801
  3rd run    2.975402   2.987304
  Average    2.977254   2.981424   -0.004171 (-4ms)


For the next round of testing, we delayed the bootloader for varying
amounts of time, then started to remove key components from kernel
functionality to see if the boottime system would pick-up on them.

  /* Hang around in the bootloader for a while. */
  $ cat /sys/kernel/debug/boottime/summary 
    kernel: 42864 msecs
    total: 42864 msecs
    kernel: cpu0 system: 56% idle: 43% iowait: 0% irq: 0% 
            cpu1 system: 4% idle: 95% iowait: 0% irq: 0%

  /* Hang around in the bootloader for a smaller amount of time. */
    kernel: 12351 msecs
    total: 12351 msecs
    kernel: cpu0 system: 56% idle: 43% iowait: 0% irq: 0% 
            cpu1 system: 2% idle: 97% iowait: 0% irq: 0%
  
  /* Instant boot. (1st run) */
    kernel: 7833 msecs
    total: 7833 msecs
    kernel: cpu0 system: 55% idle: 44% iowait: 0% irq: 0% 
            cpu1 system: 3% idle: 96% iowait: 0% irq: 0%

  /* Instant boot. (2nd run) */
    kernel: 7817 msecs
    total: 7817 msecs
    kernel: cpu0 system: 53% idle: 46% iowait: 0% irq: 0% 
            cpu1 system: 8% idle: 91% iowait: 0% irq: 0%

  /* Instant boot. (3rd run) */
    kernel: 7747 msecs
    total: 7747 msecs
    kernel: cpu0 system: 56% idle: 42% iowait: 0% irq: 0% 
            cpu1 system: 2% idle: 97% iowait: 0% irq: 0%

  /* Instant boot. (4th run)
          -CONFIG_INPUT_TOUCHSCREEN=y
          +# CONFIG_INPUT_TOUCHSCREEN is not set
  */
    kernel: 7046 msecs
    total: 7046 msecs
    kernel: cpu0 system: 72% idle: 27% iowait: 0% irq: 0% 
            cpu1 system: 5% idle: 94% iowait: 0% irq: 0%

  /* Instant boot. (5th run)
          -CONFIG_MMC=y
          +# CONFIG_MMC is not set
  */
    kernel: 6778 msecs
    total: 6778 msecs
    kernel: cpu0 system: 81% idle: 18% iowait: 0% irq: 0% 
            cpu1 system: 1% idle: 98% iowait: 0% irq: 0%

 arch/arm/common/Makefile                  |    1 +
 arch/arm/common/boottime.c                |   46 +++
 arch/arm/include/uapi/asm/setup.h         |   22 ++
 drivers/clocksource/clksrc-dbx500-prcmu.c |   20 ++
 include/linux/boottime.h                  |   89 ++++++
 init/Kconfig                              |    9 +
 init/Makefile                             |    1 +
 init/boottime.c                           |  475 +++++++++++++++++++++++++++++
 init/main.c                               |    6 +
 9 files changed, 669 insertions(+)


