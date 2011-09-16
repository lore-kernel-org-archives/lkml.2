Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab1IPMNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 08:13:46 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:51976 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037Ab1IPMNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 08:13:44 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/2] pin controller subsystem v7
Date: Fri, 16 Sep 2011 14:13:02 +0200
Message-ID: <1316175182-10700-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This is the sixth iteration of the controller subsystem, most
changes are described in the individual patches, mainly we are
now doing away with the patch to the AMBA bus to acquire
pinmuxes, instead this is done from the U300 machine core. This
way the impacts on the existing drivers and buses are kept to a
minimum for the time being.

Further I squashed the patch removing the old pinmux driver from
the U300 machine into the patch adding the new driver, because
it was not really possible to do a clean cut anyway.

ChangeLog v6->v7:

- Make it possible to have several map entries matching the
  same device, pin controller and function, but using
  a different group, and alter the semantics so that
  pinmux_get() will pick all matching map entries, and
  store the associated groups in a list. The list will
  then be iterated over at pinmux_enable()/pinmux_disable()
  and corresponding driver functions called for each
  defined group. Notice that you're only allowed to map
  multiple *groups* to the same
  { device, pin controller, function } triplet, attempts
  to map the same device to multiple pin controllers will
  for example fail. This is hopefully the crucial feature
  requested by Stephen Warren.

- Add a pinmux hogging field to the pinmux mapping entries,
  and enable the pinmux core to hog pinmux map entries.
  This currently only works for pinmuxes without assigned
  devices as it looks now, but with device trees we can
  look up the corresponding struct device * entries when
  we register the pinmux driver, and have it hog each
  pinmux map in turn, for a simple approach to
  non-dynamic pin muxing. This addresses an issue from
  Grant Likely that the machine should take care of as
  much of the pinmux setup as possible, not the devices.
  By supplying a list of hogs, it can now instruct the
  core to take care of any static mappings.

- Switch pinmux group retrieveal function to grab an
  array of strings representing the groups rather than an
  array of unsigned and rewrite accordingly.

- Alter debugfs to show the grouplist handled by each
  pinmux. Also add a list of hogs.

- Dynamically allocate a struct pinmux at pinmux_get() and
  free it at pinmux_put(), then add these to the global
  list of pinmuxes active as we go along.

- Go over the list of pinmux maps at pinmux_get() time
  and repeatedly apply matches.

- Retrieve applicable groups per function from the driver
  as a string array rather than a unsigned array, then
  lookup the enumerators.

- Make the device to pinmux map a singleton - only allow the
  mapping table to be registered once and even tag the
  registration function with __init so it surely won't be
  abused.

- Create a separate debugfs file to view the pinmux map at
  runtime.

- Introduce a spin lock to the pin descriptor struct, lock it
  when modifying pin status entries. Reported by Stijn Devriendt.

- Fix up the documentation after review from Stephen Warren.

- Let the GPIO ranges give names as const char * instead of some
  fixed-length string.

- add a function to unregister GPIO ranges to mirror the
  registration function.

- Privatized the struct pinctrl_device and removed it from the
  <linux/pinctrl/pinctrl.h> API, the drivers do not need to know
  the members of this struct. It is now in the local header
  "core.h".

- Rename the concept of "anonymous" mux maps to "system" muxes
  and add convenience macros and documentation.

U300 driver:

- Adjust the driver to return the group list as an array of
  strings instead of a unsigned * array.

- Add support for the EMIF0 and EMIF1 pin groups.

- Acquire all muxmaps using pinmux hogs from the core using
  a subsystem_initcall(). This way we need not change any
  drivers or buses. We have the correct struct device *
  pointers anyway so why not do it from there, and it
  illustrates pretty well what the pinmux core will be able
  to do once it can access the device tree.

- Use new convenience macros for system mappings.

- Unregister the GPIO range at removal.

Linus Walleij (2):
  drivers: create a pin control subsystem v7
  pinmux: add a driver for the U300 pinmux

 Documentation/ABI/testing/sysfs-class-pinmux |   11 +
 Documentation/pinctrl.txt                    |  951 +++++++++++++++++++++
 MAINTAINERS                                  |    5 +
 arch/arm/mach-u300/Kconfig                   |    2 +
 arch/arm/mach-u300/Makefile                  |    2 +-
 arch/arm/mach-u300/core.c                    |   84 ++-
 arch/arm/mach-u300/include/mach/syscon.h     |  136 ---
 arch/arm/mach-u300/mmc.c                     |   16 -
 arch/arm/mach-u300/padmux.c                  |  367 --------
 arch/arm/mach-u300/padmux.h                  |   39 -
 arch/arm/mach-u300/spi.c                     |   20 -
 drivers/Kconfig                              |    4 +
 drivers/Makefile                             |    2 +
 drivers/pinctrl/Kconfig                      |   36 +
 drivers/pinctrl/Makefile                     |    7 +
 drivers/pinctrl/core.c                       |  632 ++++++++++++++
 drivers/pinctrl/core.h                       |   73 ++
 drivers/pinctrl/pinmux-u300.c                | 1008 ++++++++++++++++++++++
 drivers/pinctrl/pinmux-u300.h                |  141 +++
 drivers/pinctrl/pinmux.c                     | 1178 ++++++++++++++++++++++++++
 drivers/pinctrl/pinmux.h                     |   47 +
 include/linux/pinctrl/machine.h              |  107 +++
 include/linux/pinctrl/pinctrl.h              |  133 +++
 include/linux/pinctrl/pinmux.h               |  124 +++
 24 files changed, 4544 insertions(+), 581 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-pinmux
 create mode 100644 Documentation/pinctrl.txt
 delete mode 100644 arch/arm/mach-u300/padmux.c
 delete mode 100644 arch/arm/mach-u300/padmux.h
 create mode 100644 drivers/pinctrl/Kconfig
 create mode 100644 drivers/pinctrl/Makefile
 create mode 100644 drivers/pinctrl/core.c
 create mode 100644 drivers/pinctrl/core.h
 create mode 100644 drivers/pinctrl/pinmux-u300.c
 create mode 100644 drivers/pinctrl/pinmux-u300.h
 create mode 100644 drivers/pinctrl/pinmux.c
 create mode 100644 drivers/pinctrl/pinmux.h
 create mode 100644 include/linux/pinctrl/machine.h
 create mode 100644 include/linux/pinctrl/pinctrl.h
 create mode 100644 include/linux/pinctrl/pinmux.h

-- 
1.7.3.2

