Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761115Ab2JaXM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 19:12:59 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:57345 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab2JaXMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 19:12:53 -0400
Message-Id: <cover.1351721190.git.josh.cartwright@ni.com>
From: Josh Cartwright <josh.cartwright@ni.com>
Date: Wed, 31 Oct 2012 16:06:30 -0600
Subject: [PATCH 0/8] zynq COMMON_CLK support
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 06:12:28 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 06:12:28 PM,
	Serialize complete at 10/31/2012 06:12:28 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-31_03:2012-10-31,2012-10-31,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements COMMON_CLK support for the zynq.  At this
point, only the basic fundamental clocks are modelled, and only
passively; for rate calculation.  of_clk bindings are implemented to
allow specifying clock/peripheral relationships in the device tree.

Patch 1 and 2 are a followup to my early patch: "ARM: zynq: move ttc
timer code to drivers/clocksource".  Patch 1 moves the definition
sys_timer definition out of the ttc code, and into the zynq common code.
Patch 2 is the actual rename, and makefile cleanup.

Patch 3 adds a description of the second uart to zynq-ep107.dts.  I did
this pre-split (patch 4), because I felt it might make reviewing easier.

Patch 4 uses zynq-ep107.dts as a reference to create zynq-7000.dtsi,
which is intended to be a common dtsi snippet for inclusion in
describing zynq-7000 based boards.  zynq-zc702.dts is created as an
example consumer.  The zynq-ep107.dts file is removed entirely (it
describes, presumably, a board not available to consumers).

Patch 5 is the real meat; it adds an implementation of the clk models
for the PLLs, the CPU clock network, and basic (simplified) clk models
for the essential peripherals (UART and the TTC).

Patch 6 removes CONFIG_OF conditional code from the xilinx uart driver.
The zynq kernel requires CONFIG_OF, and this hardware is not currently
used on any other non CONFIG_OF platform.

Patch 7 adds support to the xilinx_uartps driver to allow getting clock
rate information form the device tree.

Patch 8 implements DT support for the ttc, including pulling clock tree
info.

---
There are some specific concerns that I had that I would like some
guidance on:

Two identical timers on the board have historically been statically
allocated to act as the system clocksource, and the clockevent_device.
With patch 8, this distinction is done in the device tree by tweaking
with the compatible properties of which of the timers you want used for
what purpose.

I feel, however, that this is an abuse of the device tree, which should
only be used to describe hardware, not to layout a policy on how the
hardware is used.

So, if it's not in the device tree, then where?  Do I go back to the
static allocation routine, such that the first matching ttc node in the
tree becomes the clockevent_device, and the second one a clocksource?
That seems like a hack.

Is it somehow possible to have all of the timers registered as both a
clocksource and a clockevent_device, and have some higher level logic
make the policy decision as to which timer is used for what?

An additional question regarding of_clk bindings:

	my_clock {
		#clock-cells = <0>;
		clock-output-names = "my_out_clock";
	};
	node_a {
		clocks = <&clk>;
		clock-names = "my_clock";
		clock-ranges;

		node_b {
			/* ... */
		};
	};

In this scenario, should I be expecting of_clk_get(node_b, 0) to
retrieve a handle to parent's consumed clock (due to clock-ranges)?  I
could make this work using of_clk_get_by_name(node_b, "my_clock"), but I
was somewhat surprised the former didn't work.

Thanks (and sorry for the novel),
   Josh

---
Josh Cartwright (8):
  ARM: zynq: move arm-specific sys_timer out of ttc
  ARM: zynq: move ttc timer code to drivers/clocksource
  ARM: zynq: dts: add description of the second uart
  ARM: zynq: dts: split up device tree
  ARM: zynq: add COMMON_CLK support
  serial: xilinx_uartps: kill CONFIG_OF conditional
  serial: xilinx_uartps: get clock rate info from dts
  clocksource: xilinx_ttc: add OF_CLK support

 .../devicetree/bindings/clock/zynq-7000.txt        |  55 ++++
 arch/arm/Kconfig                                   |   1 +
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/zynq-7000.dtsi                   | 166 ++++++++++
 arch/arm/boot/dts/zynq-ep107.dts                   |  63 ----
 arch/arm/boot/dts/zynq-zc702.dts                   |  44 +++
 arch/arm/mach-zynq/Makefile                        |   2 +-
 arch/arm/mach-zynq/common.c                        |  29 +-
 arch/arm/mach-zynq/timer.c                         | 298 -----------------
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-zynq.c                             | 355 +++++++++++++++++++++
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/xilinx_ttc.c                   | 326 +++++++++++++++++++
 drivers/tty/serial/xilinx_uartps.c                 |  39 +--
 include/linux/clk/zynq.h                           |  24 ++
 .../common.h => include/linux/xilinx_ttc.h         |   8 +-
 16 files changed, 1022 insertions(+), 391 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/zynq-7000.txt
 create mode 100644 arch/arm/boot/dts/zynq-7000.dtsi
 delete mode 100644 arch/arm/boot/dts/zynq-ep107.dts
 create mode 100644 arch/arm/boot/dts/zynq-zc702.dts
 delete mode 100644 arch/arm/mach-zynq/timer.c
 create mode 100644 drivers/clk/clk-zynq.c
 create mode 100644 drivers/clocksource/xilinx_ttc.c
 create mode 100644 include/linux/clk/zynq.h
 rename arch/arm/mach-zynq/common.h => include/linux/xilinx_ttc.h (81%)

-- 
1.8.0

