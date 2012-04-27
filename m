Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab2D0MYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:24:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44245 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757185Ab2D0MYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:24:46 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <greg@kroah.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v5 0/7] Add TI EMIF SDRAM controller driver
Date: Fri, 27 Apr 2012 17:54:02 +0530
Message-ID: <1335529449-28046-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the EMIF SDRAM controller used in Texas Instrument SoCs

EMIF is an SDRAM controller that supports, based on its revision,
one or more of LPDDR2/DDR2/DDR3 protocols.This driver adds support
for LPDDR2.

The driver supports the following features:
- Calculates the DDR AC timing parameters to be set in EMIF
  registers using data from the device data-sheets and based
  on the DDR frequency. If data from data-sheets is not available
  default timing values from the JEDEC spec are used. These
  will be safe, but not necessarily optimal
- API for changing timings during DVFS or at boot-up
- Temperature alert configuration and handling of temperature
  alerts, if any for LPDDR2 devices
  * temperature alert is based on periodic polling of MR4 mode
    register in DDR devices automatically performed by hardware
  * timings are de-rated and brought back to nominal when
    temperature raises and falls respectively
- Cache of calculated register values to avoid re-calculating
  them

The driver will need some minor updates when it is eventually
integrated with Dynamic Voltage and Frequency Scaling (DVFS).
This can not be done now as DVFS support is not available in
the mainline yet.

Discussions with Santosh Shilimkar <santosh.shilimkar@ti.com>
were immensely helpful in shaping up the interfaces. Vibhore Vardhan
<vvardhan@gmail.com> did the initial code snippet for thermal
handling.

Testing: 
- The driver is tested on OMAP4430 SDP.
- The driver in a slightly adapted form is also tested on OMAP5.
- Since mainline kernel doesn't have DVFS support yet,
  testing was done using a test module.
- Temperature alert handling was tested with simulated interrupts
  and faked temperature values as testing all cases in real-life
  scenarios is difficult.
- Tested the driver as a module

Cc: Greg KH <greg@kroah.com>

v5:
- Moved the EMIF driver to drivers/memory as per discussion thread [2]

v4:
- Converted instances of EXPORT_SYMBOL to EXPORT_SYMBOL_GPL
- Removed un-necessary "#ifndef __ASSEMBLY__'
- Minor formatting fix

v2:
- Fixed a bug found in the implementation of errata i728
  workaround
- Fixed the value of frequency printed in debugfs
- Dropped the hwmod patch as Paul has already posted a
  a hwmod series [1] that adds hwmod for EMIF
- Converted instances of __init to __init_or_module

Regards
Santosh

[1] http://thread.gmane.org/gmane.linux.ports.arm.omap/72855
[2] https://lkml.org/lkml/2012/4/12/173


Aneesh V (7):
  ddr: add LPDDR2 data from JESD209-2
  memory: emif: add register definitions for EMIF
  memory: emif: add basic infrastructure for EMIF driver
  memory: emif: handle frequency and voltage change events
  memory: emif: add interrupt and temperature handling
  memory: emif: add one-time settings
  memory: emif: add debugfs entries for emif

 Documentation/memory-devices/ti-emif.txt |   57 +
 drivers/Kconfig                          |    4 +
 drivers/Makefile                         |    3 +
 drivers/memory/Kconfig                   |   22 +
 drivers/memory/Makefile                  |    5 +
 drivers/memory/emif.c                    | 1670 ++++++++++++++++++++++++++++++
 drivers/memory/emif.h                    |  589 +++++++++++
 include/linux/platform_data/emif_plat.h  |  128 +++
 include/memory/jedec_ddr.h               |  175 ++++
 lib/Kconfig                              |    8 +
 lib/Makefile                             |    2 +
 lib/jedec_ddr_data.c                     |  135 +++
 12 files changed, 2798 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/memory-devices/ti-emif.txt
 create mode 100644 drivers/memory/Kconfig
 create mode 100644 drivers/memory/Makefile
 create mode 100644 drivers/memory/emif.c
 create mode 100644 drivers/memory/emif.h
 create mode 100644 include/linux/platform_data/emif_plat.h
 create mode 100644 include/memory/jedec_ddr.h
 create mode 100644 lib/jedec_ddr_data.c

-- 
1.7.5.4

