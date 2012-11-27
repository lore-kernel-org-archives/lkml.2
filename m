Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab2K0Isy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:48:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57677 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933162Ab2K0Isv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:48:51 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v5 00/12] Support for AM33xx PWM Subsystem
Date: Tue, 27 Nov 2012 14:18:05 +0530
Message-ID: <1354006097-25895-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In AM33xx PWM sub modules like ECAP, EHRPWM & EQEP are  integrated to
PWM subsystem. All these submodules shares the resources (clock) & has
a clock gating register in PWM Subsystem. This patch series creates a
parent PWM Subsystem driver to handle access synchronization of shared
resources & clock gating from PWM Subsystem configuration space.
Also Device tree nodes populated to support parent child relation
between PWMSS, ECAP & EHRPWM submodules.
In addition EHRPWM module requires explicit clock gating from control
module & is handled by patch #6 & 7.

As suggested by  Thierry for handling clock gating for PWM submodules
should handle with a global function. This requires config space
handling done independent from driver and is done at parent driver.

So the parent<->child relation adopted to handle
1. pm runtime synchronization
2. PWM subsystem common config space clock gating for PWM submodules.

Patches supports
- Driver support for parent child relation handled patch #1
- HWMOD data correction in EPWMSS at patch #2
- Parent child in HWMOD relation handled at patch #3
- Optional EHRPWM tb clock in patch #6
- Support for TBCLK clock gating at patch #7.
- Device tree binding support handled in patch #4,8 
- Pinctrl support in patch #5 & 9.
- DT node populated in patch #10 ,11 & 12.

This patch series based on omap_dt/for_3.8/dts_part2 and tested
on am335x-evm & am335x-evmsk.

This patch series will come under 3 subsystem basically. But sent
it in single patch series to have a clearer picture of why the
OMAP subsystem changes required.

Patches come under PWM (1,4,5,7,8,9)
Patches come under OMAP (2,3,6)
Patches come under DT (10,11,12).

It depends on [1]
1. https://gitorious.org/linux-pwm/linux-pwm/commit/83af24027b3df1af5c5a9aa9adcdcfeb3429d3be
pwm: Device tree support for PWM polarity

Changes since v3:
	- Rebased on top of omap_dt/for_3.8/dts_part2
	- Add pwm backlight for am335xevm_sk
	- Moved tipwmss.h to pwm-tipwmss.h

Philip, Avinash (12):
  PWMSS: Add PWM Subsystem driver for parent<->child relationship
  ARM: OMAP: AM33xx hwmod: Corrects PWM subsystem HWMOD entries
  ARM: OMAP: AM33xx hwmod: Add parent-child relationship for PWM
    subsystem
  pwm: tiecap: Add device-tree binding
  pwm: pwm-tiecap: pinctrl support
  ARM: AM33XX: clk: Add clock node for EHRPWM TBCLK
  pwm: pwm-tiehrpwm: Adding TBCLK gating support.
  pwm: tiehrpwm: Add device-tree binding
  pwm: pwm-tiehrpwm: pinctrl support
  ARM: dts: AM33XX: Add PWMSS device tree nodes
  ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evm
  ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evmsk

 .../devicetree/bindings/pwm/pwm-tiecap.txt         |   23 ++
 .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       |   23 ++
 .../devicetree/bindings/pwm/pwm-tipwmss.txt        |   31 ++
 arch/arm/boot/dts/am335x-evm.dts                   |   23 ++
 arch/arm/boot/dts/am335x-evmsk.dts                 |   23 ++
 arch/arm/boot/dts/am33xx.dtsi                      |   84 +++++
 arch/arm/mach-omap2/clock33xx_data.c               |   37 ++
 arch/arm/mach-omap2/control.h                      |    8 +
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c         |  388 +++++++++++++-------
 drivers/pwm/Kconfig                                |   11 +
 drivers/pwm/Makefile                               |    1 +
 drivers/pwm/pwm-tiecap.c                           |   48 +++-
 drivers/pwm/pwm-tiehrpwm.c                         |   62 +++-
 drivers/pwm/pwm-tipwmss.c                          |  139 +++++++
 drivers/pwm/pwm-tipwmss.h                          |   39 ++
 15 files changed, 797 insertions(+), 144 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-tipwmss.txt
 create mode 100644 drivers/pwm/pwm-tipwmss.c
 create mode 100644 drivers/pwm/pwm-tipwmss.h

