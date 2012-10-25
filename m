Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992452Ab2JYQOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:14:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48087 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946293Ab2JYQMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:12:33 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-keystone@list.ti.com>, Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3 00/11] common clk drivers migration for DaVinci SoCs
Date: Thu, 25 Oct 2012 12:11:46 -0400
Message-ID: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v3 of the patch series for implementing clock tree for DaVinci SoCs
using common clk framework.

supported platforms: DM644x

This code base can be accessed at

https://gitorious.org/~m-karicheri/linux-davinci/linux-davinci-clk/commits/common-clk-v3

The patch series is split in two parts:-
	 patches prefixed with "clk" are for clk drivers
	 patches prefixed with "ARM" are for davinci machine specific code.

revision history:
-----------------
updates in v3:
	- Major changes done based on review of v2 to move the clock data and
	  initialization code to drivers/clk/davinci. There is a soc specific
	  code (for example dm644x-clock.c) for doing clock initialization.
	- Files renamed based on the review comments.
	- Only DM644x is supported. Other devices will be added as the code
	  matures so that unnecessary rework can be avoided.
	- Incorporated comments from Nori Sekhar and Linus (comments coding
	  style)
	- Added clk-div clock to represent DaVinci pll divider clocks
	- Removed clk-keystone-pll.c (will be added later)

updates in v2:
	- updates to davinci_clk to use union for clk driver platform data
	- Fixed Linus Walleij' comment on code comment
	- added code clean up that takes out the ifdef used in previous patches

updates in v1:
	- Added DM365 and DM355
	- updates to davinci_clk struct to accomodate clk-fixed-factor data

initial version:-

Currently arch/arm/mach-davinci/clock.c and arch/arm/mach-davinci/psc.c
implements clock drivers for DaVinci. This patch makes these code obsolete
and migrate the SoC code to use the common clk based drivers. This adds
two clk drivers specific to DaVinci and Keystone (found in c6x arch such
as C6678) devices. Some of the existing clk drivers such as clk-fixed-rate,
clk-divider, and clk-mux are re-used in addition to the DaVinci specific
drivers to initialize the clock tree for the SoCs. Please refer chapter 6
of http://www.ti.com/lit/ug/sprue14c/sprue14c.pdf for details of the
PLL hardware in DM6446 and chapter 7 for defails of the PSC hardware.

There are two Main PLLs in DM644x. PLL1 and PLL2. Each of these generate
different clocks in the DM device through PLL dividers. Figure above shows this
for PLL1. Similar hardware exists for PLL2 and the related output clocks. The
hardware is similar in most of the DM SoCs. Some of the recent Keystone devices
(c6678 under c6x architecture) include a slight variant of the PLL that
implemented different registers for the multipliers and dividers. All of these
devices include PLL dividers (PLLDIVx) and Power Sleep controllers (PSC). The
SoCs defines various Power Domains and Clock domains and there are PSC modules
that controls power and clocks to various hardware IPs of the SoC. 

Following drivers are used for various clock hardware blocks:-

CLKIN and OSCIN - clk-fixed-rate (existing driver)
MUX - clk-mux (existing driver)
PLLDIVx - davinci/clk-div (new driver)
PLL mult/div - clk-pll (new driver)
PSC - clk-psc.c (new driver)

Please note that initially only platforms listed above are supported. The
idea is to review the initial patch set and get a feedback on the overall
structure of the code organization. The other SoCs will be added in subsequent
patch revisions.

The driver code implements the features needed to support the platforms
listed above. It is expected that these drivers get updated in subsequent
patch revisions to support additional SoCs. I have boot tested this on DM6446
EVM. Also verified reboot command works and the clock rates are set as before.
The patches depends on the following patches that I had sent for review earlier:

davinci spi driver preparation @
https://patchwork.kernel.org/patch/1389321/
davinci watchdog driver preparation @
https://lkml.org/lkml/2012/9/7/634
davinci nand driver preparation @
https://lkml.org/lkml/2012/9/7/635
davinci i2c driver preparation @
https://patchwork.kernel.org/patch/1388841/
davinci gpio driver preparation @
https://lkml.org/lkml/2012/8/31/341

[RFC - PATCH] base:pm: prepare driver for common clock framework

ISSUES to discuss
-----------------
Following are to be discussed as part of this patch review.

 1. arch/arm/pm.c. This is configuring PLL controller registers for suspend and
    resume. It appears that we need to move this code to clk-pll.c?? But
    I can't find APIs for suspend and resume in the common clk framework. How
    is this expected to work? Currently i have kept the code ASIS.   

 2. There are usecount=1 in the old clock implementation for dsp, vicp and timer2
    clocks. CLK_IGNORE_UNUSED flag is used currently to implement the same as
    disabling these unused clocks causes issues in boot up,

HELP NEEDED!!:
--------------
I am doing this work as a background activity and hence the progress will be
slow. Please volunteer to help me in this effort by offering to test or migrating
other devices to this framework.

Murali Karicheri (11):
  clk: davinci - add main PLL clock driver
  clk: davinci - add PSC clock driver
  clk: davinci - common clk utilities to init clk driver
  clk: davinci - add pll divider clock driver
  clk: davinci - add dm644x clock initialization
  clk: davinci - add build infrastructure for DaVinci clock drivers
  ARM: davinci - restructure header files for common clock migration
  ARM: davinci - migrating to use common clock init code
  ARM: davinci - dm644x: update SoC code to remove the clock data
  ARM: davinci - migrate to common clock
  ARM: davinci - common clock migration: clean up the old code

 arch/arm/Kconfig                            |    1 +
 arch/arm/mach-davinci/Kconfig               |    2 +
 arch/arm/mach-davinci/Makefile              |   15 +-
 arch/arm/mach-davinci/clock.c               |  669 ---------------------------
 arch/arm/mach-davinci/clock.h               |  135 ------
 arch/arm/mach-davinci/common.c              |   10 -
 arch/arm/mach-davinci/cpufreq.c             |    2 -
 arch/arm/mach-davinci/davinci.h             |    3 +
 arch/arm/mach-davinci/devices.c             |    1 -
 arch/arm/mach-davinci/dm644x.c              |  302 +-----------
 arch/arm/mach-davinci/include/mach/clock.h  |   21 -
 arch/arm/mach-davinci/include/mach/common.h |   10 +-
 arch/arm/mach-davinci/include/mach/pll.h    |   46 ++
 arch/arm/mach-davinci/include/mach/psc.h    |  209 ---------
 arch/arm/mach-davinci/include/mach/time.h   |    2 +-
 arch/arm/mach-davinci/pm.c                  |    3 +-
 arch/arm/mach-davinci/psc.c                 |  112 -----
 arch/arm/mach-davinci/sleep.S               |    3 +-
 arch/arm/mach-davinci/time.c                |    6 +-
 drivers/clk/Kconfig                         |    2 +
 drivers/clk/Makefile                        |    1 +
 drivers/clk/davinci/Kconfig                 |   44 ++
 drivers/clk/davinci/Makefile                |    5 +
 drivers/clk/davinci/clk-div.c               |  124 +++++
 drivers/clk/davinci/clk-div.h               |   42 ++
 drivers/clk/davinci/clk-pll.c               |  146 ++++++
 drivers/clk/davinci/clk-pll.h               |   57 +++
 drivers/clk/davinci/clk-psc.c               |  207 +++++++++
 drivers/clk/davinci/clk-psc.h               |   46 ++
 drivers/clk/davinci/clock.c                 |  112 +++++
 drivers/clk/davinci/clock.h                 |   80 ++++
 drivers/clk/davinci/dm644x-clock.c          |  304 ++++++++++++
 drivers/clk/davinci/pll.h                   |   83 ++++
 drivers/clk/davinci/psc.h                   |  215 +++++++++
 34 files changed, 1530 insertions(+), 1490 deletions(-)
 delete mode 100644 arch/arm/mach-davinci/clock.c
 delete mode 100644 arch/arm/mach-davinci/clock.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/clock.h
 create mode 100644 arch/arm/mach-davinci/include/mach/pll.h
 delete mode 100644 arch/arm/mach-davinci/psc.c
 create mode 100644 drivers/clk/davinci/Kconfig
 create mode 100644 drivers/clk/davinci/Makefile
 create mode 100644 drivers/clk/davinci/clk-div.c
 create mode 100644 drivers/clk/davinci/clk-div.h
 create mode 100644 drivers/clk/davinci/clk-pll.c
 create mode 100644 drivers/clk/davinci/clk-pll.h
 create mode 100644 drivers/clk/davinci/clk-psc.c
 create mode 100644 drivers/clk/davinci/clk-psc.h
 create mode 100644 drivers/clk/davinci/clock.c
 create mode 100644 drivers/clk/davinci/clock.h
 create mode 100644 drivers/clk/davinci/dm644x-clock.c
 create mode 100644 drivers/clk/davinci/pll.h
 create mode 100644 drivers/clk/davinci/psc.h

-- 
1.7.9.5

