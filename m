Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573Ab2COSSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:18:18 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:47559 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756305Ab2COSSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:18:16 -0400
From: Aneesh V <aneesh@ti.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Aneesh V <aneesh@ti.com>, Greg KH <greg@kroah.com>
Subject: [PATCH v2 0/7] Add TI EMIF SDRAM controller driver
Date: Thu, 15 Mar 2012 23:47:30 +0530
Message-Id: <1331835457-5390-1-git-send-email-aneesh@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the EMIF SDRAM controller used in TI SoCs

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

v2:
- Fixed a bug found in the implementation of errata i728
  workaround
- Fixed the value of frequency printed in debugfs
- Dropped the hwmod patch as Paul has already posted a
  a hwmod series [1] that adds hwmod for EMIF
- Converted instances of __init to __init_or_module

[1] http://thread.gmane.org/gmane.linux.ports.arm.omap/72855

Aneesh V (7):
  misc: ddr: add LPDDR2 data from JESD209-2
  misc: emif: add register definitions for EMIF
  misc: emif: add basic infrastructure for EMIF driver
  misc: emif: handle frequency and voltage change events
  misc: emif: add interrupt and temperature handling
  misc: emif: add one-time settings
  misc: emif: add debugfs entries for emif

 Documentation/misc-devices/ti-emif.txt  |   58 ++
 drivers/misc/Kconfig                    |   12 +
 drivers/misc/Makefile                   |    1 +
 drivers/misc/emif.c                     | 1670 +++++++++++++++++++++++++++++++
 drivers/misc/emif.h                     |  589 +++++++++++
 include/linux/platform_data/emif_plat.h |  128 +++
 include/misc/jedec_ddr.h                |  177 ++++
 lib/Kconfig                             |    8 +
 lib/Makefile                            |    3 +
 lib/jedec_ddr_data.c                    |  135 +++
 10 files changed, 2781 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/misc-devices/ti-emif.txt
 create mode 100644 drivers/misc/emif.c
 create mode 100644 drivers/misc/emif.h
 create mode 100644 include/linux/platform_data/emif_plat.h
 create mode 100644 include/misc/jedec_ddr.h
 create mode 100644 lib/jedec_ddr_data.c

