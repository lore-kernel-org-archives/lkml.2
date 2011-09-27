Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1I0Uc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:32:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387Ab1I0Ua1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:30:27 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v3 07/24] C6X: devicetree support
Date: Tue, 27 Sep 2011 16:29:48 -0400
Message-Id: <1317155405-26235-8-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-1-git-send-email-msalter@redhat.com>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the basic devicetree support for C6X. Currently, four boards are
supported. Each one uses a different SoC part. Two of the four supported
SoCs are multicore. One with 3 cores and the other with 6 cores. There is
no coherency between the core-level caches, so SMP is not an option. It is
possible to run separate kernel instances on the various cores. There is
currently no C6X bootloader support for device trees so we build in the
DTB for now.

There are some interesting twists to the hardware which are of note for device
tree support. Each core has its own interrupt controller which is controlled
by special purpose core registers. This core controller provides 12 general
purpose prioritized interrupt sources. Each core is contained within a
hardware "module" which provides L1 and L2 caches, power control, and another
interrupt controller which cascades into the core interrupt controller. These
core module functions are controlled by memory mapped registers. The addresses
for these registers are the same for each core. That is, when coreN accesses
a module-level MMIO register at a given address, it accesses the register for
coreN even though other cores would use the same address to access the register
in the module containing those cores. Other hardware modules (timers, enet, etc)
which are memory mapped can be accessed by all cores.

The timers need some further explanation for multicore SoCs. Even though all
timer control registers are visible to all cores, interrupt routing or other
considerations may make a given timer more suitable for use by a core than
some other timer. Because of this and the desire to have the same image run
on more than one core, the timer nodes have a "ti,core-mask" property which
is used by the driver to scan for a suitable timer to use.

Signed-off-by: Mark Salter <msalter@redhat.com>
Cc: devicetree-discuss@lists.ozlabs.org
---
 Documentation/devicetree/bindings/c6x/clocks.txt   |   40 +++
 Documentation/devicetree/bindings/c6x/dscr.txt     |  127 ++++++++
 Documentation/devicetree/bindings/c6x/emifa.txt    |   62 ++++
 .../devicetree/bindings/c6x/interrupt.txt          |  104 ++++++
 Documentation/devicetree/bindings/c6x/soc.txt      |   28 ++
 Documentation/devicetree/bindings/c6x/timer64.txt  |   26 ++
 arch/c6x/boot/dts/dsk6455.dts                      |   62 ++++
 arch/c6x/boot/dts/evmc6457.dts                     |   48 +++
 arch/c6x/boot/dts/evmc6472.dts                     |   73 +++++
 arch/c6x/boot/dts/evmc6474.dts                     |   58 ++++
 arch/c6x/boot/dts/tms320c6455.dtsi                 |   96 ++++++
 arch/c6x/boot/dts/tms320c6457.dtsi                 |   68 ++++
 arch/c6x/boot/dts/tms320c6472.dtsi                 |  134 ++++++++
 arch/c6x/boot/dts/tms320c6474.dtsi                 |   89 ++++++
 arch/c6x/boot/install-dtb.c                        |  333 ++++++++++++++++++++
 arch/c6x/kernel/devicetree.c                       |   53 +++
 arch/c6x/platforms/platform.c                      |   17 +
 17 files changed, 1418 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/c6x/clocks.txt
 create mode 100644 Documentation/devicetree/bindings/c6x/dscr.txt
 create mode 100644 Documentation/devicetree/bindings/c6x/emifa.txt
 create mode 100644 Documentation/devicetree/bindings/c6x/interrupt.txt
 create mode 100644 Documentation/devicetree/bindings/c6x/soc.txt
 create mode 100644 Documentation/devicetree/bindings/c6x/timer64.txt
 create mode 100644 arch/c6x/boot/dts/dsk6455.dts
 create mode 100644 arch/c6x/boot/dts/evmc6457.dts
 create mode 100644 arch/c6x/boot/dts/evmc6472.dts
 create mode 100644 arch/c6x/boot/dts/evmc6474.dts
 create mode 100644 arch/c6x/boot/dts/tms320c6455.dtsi
 create mode 100644 arch/c6x/boot/dts/tms320c6457.dtsi
 create mode 100644 arch/c6x/boot/dts/tms320c6472.dtsi
 create mode 100644 arch/c6x/boot/dts/tms320c6474.dtsi
 create mode 100644 arch/c6x/boot/install-dtb.c
 create mode 100644 arch/c6x/kernel/devicetree.c
 create mode 100644 arch/c6x/platforms/platform.c

diff --git a/Documentation/devicetree/bindings/c6x/clocks.txt b/Documentation/devicetree/bindings/c6x/clocks.txt
new file mode 100644
index 0000000..a04f5fd
--- /dev/null
+++ b/Documentation/devicetree/bindings/c6x/clocks.txt
@@ -0,0 +1,40 @@
+C6X PLL Clock Controllers
+-------------------------
+
+This is a first-cut support for the SoC clock controllers. This is still
+under development and will probably change as the common device tree
+clock support is added to the kernel.
+
+Required properties:
+
+- compatible: "ti,c64x+pll"
+    May also have SoC-specific value to support SoC-specific initialization
+    in the driver. One of:
+        "ti,c6455-pll"
+        "ti,c6457-pll"
+        "ti,c6472-pll"
+        "ti,c6474-pll"
+
+- reg: base address and size of register area
+- clock-frequency: input clock frequency in hz
+
+
+Optional properties:
+
+- ti,c64x+pll-bypass-delay: CPU cycles to delay when entering bypass mode
+
+- ti,c64x+pll-reset-delay:  CPU cycles to delay after PLL reset
+
+- ti,c64x+pll-lock-delay:   CPU cycles to delay after PLL frequency change
+
+Example:
+
+	clock-controller@29a0000 {
+		compatible = "ti,c6472-pll", "ti,c64x+pll";
+		reg = <0x029a0000 0x200>;
+		clock-frequency = <25000000>;
+
+		ti,c64x+pll-bypass-delay = <200>;
+		ti,c64x+pll-reset-delay = <12000>;
+		ti,c64x+pll-lock-delay = <80000>;
+	};
diff --git a/Documentation/devicetree/bindings/c6x/dscr.txt b/Documentation/devicetree/bindings/c6x/dscr.txt
new file mode 100644
index 0000000..d847758
--- /dev/null
+++ b/Documentation/devicetree/bindings/c6x/dscr.txt
@@ -0,0 +1,127 @@
+Device State Configuration Registers
+------------------------------------
+
+TI C6X SoCs contain a region of miscellaneous registers which provide various
+function for SoC control or status. Details vary considerably among from SoC
+to SoC with no two being alike.
+
+In general, the Device State Configuraion Registers (DSCR) will provide one or
+more configuration registers often protected by a lock register where one or
+more key values must be written to a lock register in order to unlock the
+configuration register for writes. These configuration register may be used to
+enable (and disable in some cases) SoC pin drivers, select peripheral clock
+sources (internal or pin), etc. In some cases, a configuration register is
+write once or the individual bits are write once. In addition to device config,
+the DSCR block may provide registers which which are used to reset peripherals,
+provide device ID information, provide ethernet MAC addresses, as well as other
+miscellaneous functions.
+
+For device state control (enable/disable), each device control is assigned an
+id which is used by individual device drivers to control the state as needed.
+
+Required properties:
+
+- compatible: must be "ti,c64x+dscr"
+- reg: register area base and size
+
+Optional properties:
+
+  NOTE: These are optional in that not all SoCs will have all properties. For
+        SoCs which do support a given property, leaving the property out of the
+        device tree will result in reduced functionality or possibly driver
+        failure.
+
+- ti,dscr-devstat
+    offset of the devstat register
+
+- ti,dscr-silicon-rev
+    offset, start bit, and bitsize of silicon revision field
+
+- ti,dscr-rmii-resets
+    offset and bitmask of RMII reset field. May have multiple tuples if more
+    than one ethernet port is available.
+
+- ti,dscr-locked-regs
+    possibly multiple tuples describing registers which are write protected by
+    a lock register. Each tuple consists of the register offset, lock register
+    offsset, and the key value used to unlock the register.
+
+- ti,dscr-kick-regs
+    offset and key values of two "kick" registers used to write protect other
+    registers in DSCR. On SoCs using kick registers, the first key must be
+    written to the first kick register and the second key must be written to
+    the second register before other registers in the area are write-enabled.
+
+- ti,dscr-mac-fuse-regs
+    MAC addresses are contained in two registers. Each element of a MAC address
+    is contained in a single byte. This property has two tuples. Each tuple has
+    a register offset and four cells representing bytes in the register from
+    most significant to least. The value of these four cells is the MAC byte
+    index (1-6) of the byte within the register. A value of 0 means the byte
+    is unused in the MAC address.
+
+- ti,dscr-devstate-ctl-regs
+    This property describes the bitfields used to control the state of devices.
+    Each tuple describes a range of identical bitfields used to control one or
+    more devices (one bitfield per device). The layout of each tuple is:
+
+        start_id num_ids reg enable disable start_bit nbits
+
+    Where:
+        start_id is device id for the first device control in the range
+        num_ids is the number of device controls in the range
+        reg is the offset of the register holding the control bits
+        enable is the value to enable a device
+        disable is the value to disable a device (0xffffffff if cannot disable)
+        start_bit is the bit number of the first bit in the range
+        nbits is the number of bits per device control
+
+- ti,dscr-devstate-stat-regs
+    This property describes the bitfields used to provide device state status
+    for device states controlled by the DSCR. Each tuple describes a range of
+    identical bitfields used to provide status for one or more devices (one
+    bitfield per device). The layout of each tuple is:
+
+        start_id num_ids reg enable disable start_bit nbits
+
+    Where:
+        start_id is device id for the first device status in the range
+        num_ids is the number of devices covered by the range
+        reg is the offset of the register holding the status bits
+        enable is the value indicating device is enabled
+        disable is the value indicating device is disabled
+        start_bit is the bit number of the first bit in the range
+        nbits is the number of bits per device status
+
+- ti,dscr-privperm
+    Offset and default value for register used to set access privilege for
+    some SoC devices.
+
+
+Example:
+
+	device-state-config-regs@2a80000 {
+		compatible = "ti,c64x+dscr";
+		reg = <0x02a80000 0x41000>;
+
+		ti,dscr-devstat = <0>;
+		ti,dscr-silicon-rev = <8 28 0xf>;
+		ti,dscr-rmii-resets = <0x40020 0x00040000>;
+
+		ti,dscr-locked-regs = <0x40008 0x40004 0x0f0a0b00>;
+		ti,dscr-devstate-ctl-regs =
+			 <0 12 0x40008 1 0  0  2
+			  12 1 0x40008 3 0 30  2
+			  13 2 0x4002c 1 0xffffffff 0 1>;
+		ti,dscr-devstate-stat-regs =
+			<0 10 0x40014 1 0  0  3
+			 10 2 0x40018 1 0  0  3>;
+
+		ti,dscr-mac-fuse-regs = <0x700 1 2 3 4
+					 0x704 5 6 0 0>;
+
+		ti,dscr-privperm = <0x41c 0xaaaaaaaa>;
+
+		ti,dscr-kick-regs = <0x38 0x83E70B13
+				     0x3c 0x95A4F1E0>;
+	};
diff --git a/Documentation/devicetree/bindings/c6x/emifa.txt b/Documentation/devicetree/bindings/c6x/emifa.txt
new file mode 100644
index 0000000..0ff6e9b
--- /dev/null
+++ b/Documentation/devicetree/bindings/c6x/emifa.txt
@@ -0,0 +1,62 @@
+External Memory Interface
+-------------------------
+
+The emifa node describes a simple external bus controller found on some C6X
+SoCs. This interface provides external busses with a number of chip selects.
+
+Required properties:
+
+- compatible: must be "ti,c64x+emifa", "simple-bus"
+- reg: register area base and size
+- #address-cells: must be 2 (chip-select + offset)
+- #size-cells: must be 1
+- ranges: mapping from EMIFA space to parent space
+
+
+Optional properties:
+
+- ti,dscr-dev-enable: Device ID if EMIF is enabled/disabled from DSCR
+
+- ti,emifa-burst-priority:
+      Number of memory transfers after which the EMIF will elevate the priority
+      of the oldest command in the command FIFO. Setting this field to 255
+      disables this feature, thereby allowing old commands to stay in the FIFO
+      indefinitely.
+
+- ti,emifa-ce-config:
+      Configuration values for each of the supported chip selects.
+
+Example:
+
+	emifa@70000000 {
+		compatible = "ti,c64x+emifa", "simple-bus";
+		#address-cells = <2>;
+		#size-cells = <1>;
+		reg = <0x70000000 0x100>;
+		ranges = <0x2 0x0 0xa0000000 0x00000008
+		          0x3 0x0 0xb0000000 0x00400000
+			  0x4 0x0 0xc0000000 0x10000000
+			  0x5 0x0 0xD0000000 0x10000000>;
+
+		ti,dscr-dev-enable = <13>;
+		ti,emifa-burst-priority = <255>;
+		ti,emifa-ce-config = <0x00240120
+				      0x00240120
+				      0x00240122
+				      0x00240122>;
+
+		flash@3,0 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "cfi-flash";
+			reg = <0x3 0x0 0x400000>;
+			bank-width = <1>;
+			device-width = <1>;
+			partition@0 {
+				reg = <0x0 0x400000>;
+				label = "NOR";
+			};
+		};
+	};
+
+This shows a flash chip attached to chip select 3.
diff --git a/Documentation/devicetree/bindings/c6x/interrupt.txt b/Documentation/devicetree/bindings/c6x/interrupt.txt
new file mode 100644
index 0000000..42bb796
--- /dev/null
+++ b/Documentation/devicetree/bindings/c6x/interrupt.txt
@@ -0,0 +1,104 @@
+C6X Interrupt Chips
+-------------------
+
+* C64X+ Core Interrupt Controller
+
+  The core interrupt controller provides 16 prioritized interrupts to the
+  C64X+ core. Priority 0 and 1 are used for reset and NMI respectively.
+  Priority 2 and 3 are reserved. Priority 4-15 are used for interrupt
+  sources coming from outside the core.
+
+  Required properties:
+  --------------------
+  - compatible: Should be "ti,c64x+core-pic";
+  - #interrupt-cells: <1>
+
+  Interrupt Specifier Definition
+  ------------------------------
+  Single cell specifying the core interrupt priority level (4-15) where
+  4 is highest priority and 15 is lowest priority.
+
+  Example
+  -------
+  core_pic: interrupt-controller@0 {
+	interrupt-controller;
+	#interrupt-cells = <1>;
+	compatible = "ti,c64x+core-pic";
+  };
+
+
+
+* C64x+ Megamodule Interrupt Controller
+
+  The megamodule PIC consists of four interrupt mupliplexers each of which
+  combine up to 32 interrupt inputs into a single interrupt output which
+  may be cascaded into the core interrupt controller. The megamodule PIC
+  has a total of 12 outputs cascading into the core interrupt controller.
+  One for each core interrupt priority level. In addition to the combined
+  interrupt sources, individual megamodule interrupts may be cascaded to
+  the core interrupt controller. When an individual interrupt is cascaded,
+  it is no longer handled through a megamodule interrupt combiner and is
+  considered to have the core interrupt controller as the parent.
+
+  Required properties:
+  --------------------
+  - compatible: "ti,c64x+megamod-pic"
+  - interrupt-controller
+  - #interrupt-cells: <1>
+  - reg: base address and size of register area
+  - interrupt-parent: must be core interrupt controller
+  - interrupts: This should have four cells; one for each interrupt combiner.
+                The cells contain the core priority interrupt to which the
+                corresponding combiner output is wired.
+
+  Optional properties:
+  --------------------
+  - ti,c64x+megamod-pic-mux: Array of 12 cells correspnding to the 12 core
+                             priority interrupts. The first cell corresponds to
+                             core priority 4 and the last cell corresponds to
+                             core priority 15. The value of each cell is the
+                             megamodule interrupt source which is MUXed to
+                             the core interrupt corresponding to the cell
+                             position. Allowed values are 4 - 127. Mapping for
+                             interrupts 0 - 3 (combined interrupt sources) are
+                             ignored.
+
+  Interrupt Specifier Definition
+  ------------------------------
+  Single cell specifying the megamodule interrupt source (4-127). Note that
+  interrupts mapped directly to the core with "ti,c64x+megamod-pic-mux" will
+  use the core interrupt controller as their parent and the specifier will
+  be the core priority level, not the megamodule interrupt number.
+
+  Examples
+  --------
+  megamod_pic: interrupt-controller@1800000 {
+	compatible = "ti,c64x+megamod-pic";
+	interrupt-controller;
+	#interrupt-cells = <1>;
+	reg = <0x1800000 0x1000>;
+	interrupt-parent = <&core_pic>;
+	interrupts = < 12 13 14 15 >;
+  };
+
+  This is a minimal example where all individual interrupts go through a
+  combiner. Combiner-0 is mapped to core interrupt 12, combiner-1 is mapped
+  to interrupt 13, etc.
+
+
+  megamod_pic: interrupt-controller@1800000 {
+	compatible = "ti,c64x+megamod-pic";
+	interrupt-controller;
+	#interrupt-cells = <1>;
+	reg = <0x1800000 0x1000>;
+	interrupt-parent = <&core_pic>;
+	interrupts = < 12 13 14 15 >;
+	ti,c64x+megamod-pic-mux = <  0  0  0  0
+                                    32  0  0  0
+                                     0  0  0  0 >;
+  };
+
+  This the same as the first example except that megamodule interrupt 32 is
+  mapped directly to core priority interrupt 8. The node using this interrupt
+  must set the core controller as its interrupt parent and use 8 in the
+  interrupt specifier value.
diff --git a/Documentation/devicetree/bindings/c6x/soc.txt b/Documentation/devicetree/bindings/c6x/soc.txt
new file mode 100644
index 0000000..b1e4973
--- /dev/null
+++ b/Documentation/devicetree/bindings/c6x/soc.txt
@@ -0,0 +1,28 @@
+C6X System-on-Chip
+------------------
+
+Required properties:
+
+- compatible: "simple-bus"
+- #address-cells: must be 1
+- #size-cells: must be 1
+- ranges
+
+Optional properties:
+
+- model: specific SoC model
+
+- nodes for IP blocks within SoC
+
+
+Example:
+
+	soc {
+		compatible = "simple-bus";
+		model = "tms320c6455";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		...
+	};
diff --git a/Documentation/devicetree/bindings/c6x/timer64.txt b/Documentation/devicetree/bindings/c6x/timer64.txt
new file mode 100644
index 0000000..95911fe
--- /dev/null
+++ b/Documentation/devicetree/bindings/c6x/timer64.txt
@@ -0,0 +1,26 @@
+Timer64
+-------
+
+The timer64 node describes C6X event timers.
+
+Required properties:
+
+- compatible: must be "ti,c64x+timer64"
+- reg: base address and size of register region
+- interrupt-parent: interrupt controller
+- interrupts: interrupt id
+
+Optional properties:
+
+- ti,dscr-dev-enable: Device ID used to enable timer IP through DSCR interface.
+
+- ti,core-mask: on multi-core SoCs, bitmask of cores allowed to use this timer.
+
+Example:
+	timer0: timer@25e0000 {
+		compatible = "ti,c64x+timer64";
+		ti,core-mask = < 0x01 >;
+		reg = <0x25e0000 0x40>;
+		interrupt-parent = <&megamod_pic>;
+		interrupts = < 16 >;
+	};
diff --git a/arch/c6x/boot/dts/dsk6455.dts b/arch/c6x/boot/dts/dsk6455.dts
new file mode 100644
index 0000000..2b71f80
--- /dev/null
+++ b/arch/c6x/boot/dts/dsk6455.dts
@@ -0,0 +1,62 @@
+/*
+ * arch/c6x/boot/dts/dsk6455.dts
+ *
+ * DSK6455 Evaluation Platform For TMS320C6455
+ * Copyright (C) 2011 Texas Instruments Incorporated
+ *
+ * Author: Mark Salter <msalter@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ */
+
+/dts-v1/;
+
+/include/ "tms320c6455.dtsi"
+
+/ {
+	model = "Spectrum Digital DSK6455";
+	compatible = "spectrum-digital,dsk6455";
+
+	chosen {
+		bootargs = "root=/dev/nfs ip=dhcp rw";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0xE0000000 0x08000000>;
+	};
+
+	soc {
+		megamod_pic: interrupt-controller@1800000 {
+			interrupts = < 12 13 14 15 >;
+		};
+
+		emifa@70000000 {
+			flash@3,0 {
+				  #address-cells = <1>;
+				#size-cells = <1>;
+				compatible = "cfi-flash";
+				reg = <0x3 0x0 0x400000>;
+				bank-width = <1>;
+				device-width = <1>;
+				partition@0 {
+					reg = <0x0 0x400000>;
+					label = "NOR";
+				};
+			};
+		};
+
+		timer1: timer@2980000 {
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 69 >;
+		};
+
+		clock-controller@029a0000 {
+			clock-frequency = <50000000>;
+		};
+	};
+};
diff --git a/arch/c6x/boot/dts/evmc6457.dts b/arch/c6x/boot/dts/evmc6457.dts
new file mode 100644
index 0000000..0301eb9a
--- /dev/null
+++ b/arch/c6x/boot/dts/evmc6457.dts
@@ -0,0 +1,48 @@
+/*
+ * arch/c6x/boot/dts/evmc6457.dts
+ *
+ * EVMC6457 Evaluation Platform For TMS320C6457
+ *
+ * Copyright (C) 2011 Texas Instruments Incorporated
+ *
+ * Author: Mark Salter <msalter@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ */
+
+/dts-v1/;
+
+/include/ "tms320c6457.dtsi"
+
+/ {
+	model = "eInfochips EVMC6457";
+	compatible = "einfochips,evmc6457";
+
+	chosen {
+		bootargs = "console=hvc root=/dev/nfs ip=dhcp rw";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0xE0000000 0x10000000>;
+	};
+
+	soc {
+		megamod_pic: interrupt-controller@1800000 {
+		       interrupts = < 12 13 14 15 >;
+		};
+
+		timer0: timer@2940000 {
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 67 >;
+		};
+
+		clock-controller@29a0000 {
+			clock-frequency = <60000000>;
+		};
+	};
+};
diff --git a/arch/c6x/boot/dts/evmc6472.dts b/arch/c6x/boot/dts/evmc6472.dts
new file mode 100644
index 0000000..3e207b4
--- /dev/null
+++ b/arch/c6x/boot/dts/evmc6472.dts
@@ -0,0 +1,73 @@
+/*
+ * arch/c6x/boot/dts/evmc6472.dts
+ *
+ * EVMC6472 Evaluation Platform For TMS320C6472
+ *
+ * Copyright (C) 2011 Texas Instruments Incorporated
+ *
+ * Author: Mark Salter <msalter@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ */
+
+/dts-v1/;
+
+/include/ "tms320c6472.dtsi"
+
+/ {
+	model = "eInfochips EVMC6472";
+	compatible = "einfochips,evmc6472";
+
+	chosen {
+		bootargs = "console=hvc root=/dev/nfs ip=dhcp rw";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0xE0000000 0x10000000>;
+	};
+
+	soc {
+		megamod_pic: interrupt-controller@1800000 {
+		       interrupts = < 12 13 14 15 >;
+		};
+
+		timer0: timer@25e0000 {
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 16 >;
+		};
+
+		timer1: timer@25f0000 {
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 16 >;
+		};
+
+		timer2: timer@2600000 {
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 16 >;
+		};
+
+		timer3: timer@2610000 {
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 16 >;
+		};
+
+		timer4: timer@2620000 {
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 16 >;
+		};
+
+		timer5: timer@2630000 {
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 16 >;
+		};
+
+		clock-controller@29a0000 {
+			clock-frequency = <25000000>;
+		};
+	};
+};
diff --git a/arch/c6x/boot/dts/evmc6474.dts b/arch/c6x/boot/dts/evmc6474.dts
new file mode 100644
index 0000000..4dc2912
--- /dev/null
+++ b/arch/c6x/boot/dts/evmc6474.dts
@@ -0,0 +1,58 @@
+/*
+ * arch/c6x/boot/dts/evmc6474.dts
+ *
+ * EVMC6474 Evaluation Platform For TMS320C6474
+ *
+ * Copyright (C) 2011 Texas Instruments Incorporated
+ *
+ * Author: Mark Salter <msalter@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ */
+
+/dts-v1/;
+
+/include/ "tms320c6474.dtsi"
+
+/ {
+	model = "Spectrum Digital EVMC6474";
+	compatible = "spectrum-digital,evmc6474";
+
+	chosen {
+		bootargs = "console=hvc root=/dev/nfs ip=dhcp rw";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x80000000 0x08000000>;
+	};
+
+	soc {
+		megamod_pic: interrupt-controller@1800000 {
+		       interrupts = < 12 13 14 15 >;
+		};
+
+		timer3: timer@2940000 {
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 39 >;
+		};
+
+		timer4: timer@2950000 {
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 41 >;
+		};
+
+		timer5: timer@2960000 {
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 43 >;
+		};
+
+		clock-controller@29a0000 {
+			clock-frequency = <50000000>;
+		};
+	};
+};
diff --git a/arch/c6x/boot/dts/tms320c6455.dtsi b/arch/c6x/boot/dts/tms320c6455.dtsi
new file mode 100644
index 0000000..a804ec1
--- /dev/null
+++ b/arch/c6x/boot/dts/tms320c6455.dtsi
@@ -0,0 +1,96 @@
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			model = "ti,c64x+";
+			reg = <0>;
+		};
+	};
+
+	soc {
+		compatible = "simple-bus";
+		model = "tms320c6455";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		core_pic: interrupt-controller {
+			  interrupt-controller;
+			  #interrupt-cells = <1>;
+			  compatible = "ti,c64x+core-pic";
+		};
+
+		/*
+		 * Megamodule interrupt controller
+		 */
+		megamod_pic: interrupt-controller@1800000 {
+		       compatible = "ti,c64x+megamod-pic";
+		       interrupt-controller;
+		       #interrupt-cells = <1>;
+		       reg = <0x1800000 0x1000>;
+		       interrupt-parent = <&core_pic>;
+		};
+
+		cache-controller@1840000 {
+			compatible = "ti,c64x+cache";
+			reg = <0x01840000 0x8400>;
+		};
+
+		emifa@70000000 {
+			compatible = "ti,c64x+emifa", "simple-bus";
+			#address-cells = <2>;
+			#size-cells = <1>;
+			reg = <0x70000000 0x100>;
+			ranges = <0x2 0x0 0xa0000000 0x00000008
+			          0x3 0x0 0xb0000000 0x00400000
+				  0x4 0x0 0xc0000000 0x10000000
+				  0x5 0x0 0xD0000000 0x10000000>;
+
+			ti,dscr-dev-enable = <13>;
+			ti,emifa-burst-priority = <255>;
+			ti,emifa-ce-config = <0x00240120
+					      0x00240120
+					      0x00240122
+					      0x00240122>;
+		};
+
+		timer1: timer@2980000 {
+			compatible = "ti,c64x+timer64";
+			reg = <0x2980000 0x40>;
+			ti,dscr-dev-enable = <4>;
+		};
+
+		clock-controller@029a0000 {
+			compatible = "ti,c6455-pll", "ti,c64x+pll";
+			reg = <0x029a0000 0x200>;
+			ti,c64x+pll-bypass-delay = <1440>;
+			ti,c64x+pll-reset-delay = <15360>;
+			ti,c64x+pll-lock-delay = <24000>;
+		};
+
+		device-state-config-regs@2a80000 {
+			compatible = "ti,c64x+dscr";
+			reg = <0x02a80000 0x41000>;
+
+			ti,dscr-devstat = <0>;
+			ti,dscr-silicon-rev = <8 28 0xf>;
+			ti,dscr-rmii-resets = <0 0x40020 0x00040000>;
+
+			ti,dscr-locked-regs = <0x40008 0x40004 0x0f0a0b00>;
+			ti,dscr-devstate-ctl-regs =
+				 <0 12 0x40008 1 0  0  2
+				  12 1 0x40008 3 0 30  2
+				  13 2 0x4002c 1 0xffffffff 0 1>;
+			ti,dscr-devstate-stat-regs =
+				<0 10 0x40014 1 0  0  3
+				 10 2 0x40018 1 0  0  3>;
+		};
+	};
+};
diff --git a/arch/c6x/boot/dts/tms320c6457.dtsi b/arch/c6x/boot/dts/tms320c6457.dtsi
new file mode 100644
index 0000000..35f4070
--- /dev/null
+++ b/arch/c6x/boot/dts/tms320c6457.dtsi
@@ -0,0 +1,68 @@
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			model = "ti,c64x+";
+			reg = <0>;
+		};
+	};
+
+	soc {
+		compatible = "simple-bus";
+		model = "tms320c6457";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		core_pic: interrupt-controller {
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			compatible = "ti,c64x+core-pic";
+		};
+
+		megamod_pic: interrupt-controller@1800000 {
+			compatible = "ti,c64x+megamod-pic";
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			interrupt-parent = <&core_pic>;
+			reg = <0x1800000 0x1000>;
+		};
+
+		cache-controller@1840000 {
+			compatible = "ti,c64x+cache";
+			reg = <0x01840000 0x8400>;
+		};
+
+		device-state-controller@2880800 {
+			compatible = "ti,c64x+dscr";
+			reg = <0x02880800 0x400>;
+
+			ti,dscr-devstat = <0x20>;
+			ti,dscr-silicon-rev = <0x18 28 0xf>;
+			ti,dscr-mac-fuse-regs = <0x114 3 4 5 6
+						 0x118 0 0 1 2>;
+			ti,dscr-kick-regs = <0x38 0x83E70B13
+					     0x3c 0x95A4F1E0>;
+		};
+
+		timer0: timer@2940000 {
+			compatible = "ti,c64x+timer64";
+			reg = <0x2940000 0x40>;
+		};
+
+		clock-controller@29a0000 {
+			compatible = "ti,c6457-pll", "ti,c64x+pll";
+			reg = <0x029a0000 0x200>;
+			ti,c64x+pll-bypass-delay = <300>;
+			ti,c64x+pll-reset-delay = <24000>;
+			ti,c64x+pll-lock-delay = <50000>;
+		};
+	};
+};
diff --git a/arch/c6x/boot/dts/tms320c6472.dtsi b/arch/c6x/boot/dts/tms320c6472.dtsi
new file mode 100644
index 0000000..b488aae
--- /dev/null
+++ b/arch/c6x/boot/dts/tms320c6472.dtsi
@@ -0,0 +1,134 @@
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			reg = <0>;
+			model = "ti,c64x+";
+		};
+		cpu@1 {
+			device_type = "cpu";
+			reg = <1>;
+			model = "ti,c64x+";
+		};
+		cpu@2 {
+			device_type = "cpu";
+			reg = <2>;
+			model = "ti,c64x+";
+		};
+		cpu@3 {
+			device_type = "cpu";
+			reg = <3>;
+			model = "ti,c64x+";
+		};
+		cpu@4 {
+			device_type = "cpu";
+			reg = <4>;
+			model = "ti,c64x+";
+		};
+		cpu@5 {
+			device_type = "cpu";
+			reg = <5>;
+			model = "ti,c64x+";
+		};
+	};
+
+	soc {
+		compatible = "simple-bus";
+		model = "tms320c6472";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		core_pic: interrupt-controller {
+			compatible = "ti,c64x+core-pic";
+			interrupt-controller;
+			#interrupt-cells = <1>;
+		};
+
+		megamod_pic: interrupt-controller@1800000 {
+		       compatible = "ti,c64x+megamod-pic";
+		       interrupt-controller;
+		       #interrupt-cells = <1>;
+		       reg = <0x1800000 0x1000>;
+		       interrupt-parent = <&core_pic>;
+		};
+
+		cache-controller@1840000 {
+			compatible = "ti,c64x+cache";
+			reg = <0x01840000 0x8400>;
+		};
+
+		timer0: timer@25e0000 {
+			compatible = "ti,c64x+timer64";
+			ti,core-mask = < 0x01 >;
+			reg = <0x25e0000 0x40>;
+		};
+
+		timer1: timer@25f0000 {
+			compatible = "ti,c64x+timer64";
+			ti,core-mask = < 0x02 >;
+			reg = <0x25f0000 0x40>;
+		};
+
+		timer2: timer@2600000 {
+			compatible = "ti,c64x+timer64";
+			ti,core-mask = < 0x04 >;
+			reg = <0x2600000 0x40>;
+		};
+
+		timer3: timer@2610000 {
+			compatible = "ti,c64x+timer64";
+			ti,core-mask = < 0x08 >;
+			reg = <0x2610000 0x40>;
+		};
+
+		timer4: timer@2620000 {
+			compatible = "ti,c64x+timer64";
+			ti,core-mask = < 0x10 >;
+			reg = <0x2620000 0x40>;
+		};
+
+		timer5: timer@2630000 {
+			compatible = "ti,c64x+timer64";
+			ti,core-mask = < 0x20 >;
+			reg = <0x2630000 0x40>;
+		};
+
+		clock-controller@29a0000 {
+			compatible = "ti,c6472-pll", "ti,c64x+pll";
+			reg = <0x029a0000 0x200>;
+			ti,c64x+pll-bypass-delay = <200>;
+			ti,c64x+pll-reset-delay = <12000>;
+			ti,c64x+pll-lock-delay = <80000>;
+		};
+
+		device-state-controller@2a80000 {
+			compatible = "ti,c64x+dscr";
+			reg = <0x02a80000 0x1000>;
+
+			ti,dscr-devstat = <0>;
+			ti,dscr-silicon-rev = <0x70c 16 0xff>;
+
+			ti,dscr-mac-fuse-regs = <0x700 1 2 3 4
+						 0x704 5 6 0 0>;
+
+			ti,dscr-rmii-resets = <0x208 1
+					       0x20c 1>;
+
+			ti,dscr-locked-regs = <0x200 0x204 0x0a1e183a
+					       0x40c 0x420 0xbea7
+					       0x41c 0x420 0xbea7>;
+
+			ti,dscr-privperm = <0x41c 0xaaaaaaaa>;
+
+			ti,dscr-devstate-ctl-regs = <0 13 0x200 1 0 0 1>;
+		};
+	};
+};
diff --git a/arch/c6x/boot/dts/tms320c6474.dtsi b/arch/c6x/boot/dts/tms320c6474.dtsi
new file mode 100644
index 0000000..cc601bf
--- /dev/null
+++ b/arch/c6x/boot/dts/tms320c6474.dtsi
@@ -0,0 +1,89 @@
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			reg = <0>;
+			model = "ti,c64x+";
+		};
+		cpu@1 {
+			device_type = "cpu";
+			reg = <1>;
+			model = "ti,c64x+";
+		};
+		cpu@2 {
+			device_type = "cpu";
+			reg = <2>;
+			model = "ti,c64x+";
+		};
+	};
+
+	soc {
+		compatible = "simple-bus";
+		model = "tms320c6474";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		core_pic: interrupt-controller {
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			compatible = "ti,c64x+core-pic";
+		};
+
+		megamod_pic: interrupt-controller@1800000 {
+		       compatible = "ti,c64x+megamod-pic";
+		       interrupt-controller;
+		       #interrupt-cells = <1>;
+		       reg = <0x1800000 0x1000>;
+		       interrupt-parent = <&core_pic>;
+		};
+
+		cache-controller@1840000 {
+			compatible = "ti,c64x+cache";
+			reg = <0x01840000 0x8400>;
+		};
+
+		timer3: timer@2940000 {
+			compatible = "ti,c64x+timer64";
+			ti,core-mask = < 0x04 >;
+			reg = <0x2940000 0x40>;
+		};
+
+		timer4: timer@2950000 {
+			compatible = "ti,c64x+timer64";
+			ti,core-mask = < 0x02 >;
+			reg = <0x2950000 0x40>;
+		};
+
+		timer5: timer@2960000 {
+			compatible = "ti,c64x+timer64";
+			ti,core-mask = < 0x01 >;
+			reg = <0x2960000 0x40>;
+		};
+
+		device-state-controller@2880800 {
+			compatible = "ti,c64x+dscr";
+			reg = <0x02880800 0x400>;
+
+			ti,dscr-devstat = <0x004>;
+			ti,dscr-silicon-rev = <0x014 28 0xf>;
+			ti,dscr-mac-fuse-regs = <0x34 3 4 5 6
+						 0x38 0 0 1 2>;
+		};
+
+		clock-controller@29a0000 {
+			compatible = "ti,c6474-pll", "ti,c64x+pll";
+			reg = <0x029a0000 0x200>;
+			ti,c64x+pll-bypass-delay = <120>;
+			ti,c64x+pll-reset-delay = <30000>;
+			ti,c64x+pll-lock-delay = <60000>;
+		};
+	};
+};
diff --git a/arch/c6x/boot/install-dtb.c b/arch/c6x/boot/install-dtb.c
new file mode 100644
index 0000000..fa979ce
--- /dev/null
+++ b/arch/c6x/boot/install-dtb.c
@@ -0,0 +1,333 @@
+/*
+ * Program to hack in a DTB to an ELF file having a placeholder
+ * section named __fst_blob.
+ *
+ * This allows for building multiple images with builtin DTBs
+ * using a single vmlinux image. This is only necessary until
+ * bootloader support exists.
+ *
+ * Copyright 2011 Texas Instruments Incorporated
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * Usage: install-dtb <image.dtb> <kernel.elf>
+ */
+
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <ctype.h>
+#include <errno.h>
+#include <endian.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <fcntl.h>
+#include <getopt.h>
+#include <elf.h>
+
+#ifndef EM_TI_C6000
+#define EM_TI_C6000	140	/* TI C6X DSPs */
+#endif
+
+static void usage(void)
+{
+	fprintf(stderr, "\n");
+	fprintf(stderr, "Usage: update-dtb <dtb-file> <kernel-elf-file> [ <outputfile> ] \n");
+	fprintf(stderr, "\n");
+	exit(1);
+}
+
+static u_int32_t swab32(u_int32_t n)
+{
+	return (n >> 24) | ((n >> 8) & 0xff00) |
+		((n & 0xff00) << 8) | (n << 24);
+}
+
+static u_int16_t swab16(u_int16_t n)
+{
+	return (n >> 8) | (n << 8);
+}
+
+static int do_swab;
+
+#define ELFWORD(x) ({ do_swab ? swab32(x) : (x); })
+#define ELFHALF(x) ({ do_swab ? swab16(x) : (x); })
+
+static int elf_read(int fd, off_t offset, void *buf, ssize_t nbytes)
+{
+	ssize_t to_read, n;
+
+	if (lseek(fd, offset, SEEK_SET) < 0)
+		return errno;
+
+	to_read = nbytes;
+	while (to_read > 0) {
+		n = read(fd, buf, to_read);
+		if (n < 0)
+			return errno;
+		if (n == 0)
+			return -EINVAL;
+		buf += n;
+		to_read -= n;
+	}
+	return 0;
+}
+
+static int elf_write(int fd, off_t offset, void *buf, ssize_t nbytes)
+{
+	ssize_t to_write, n;
+
+	if (lseek(fd, offset, SEEK_SET) < 0)
+		return errno;
+
+	to_write = nbytes;
+	while (to_write > 0) {
+		n = write(fd, buf, to_write);
+		if (n < 0)
+			return errno;
+		if (n == 0)
+			return -EINVAL;
+		buf += n;
+		to_write -= n;
+	}
+	return 0;
+}
+
+Elf32_Ehdr ehdr;
+Elf32_Shdr *shdrs;
+char *shstrtab;
+Elf32_Sym *syms;
+char *strtab;
+
+static Elf32_Shdr *find_section_by_name(const char *name, int must_have)
+{
+	int i;
+	for (i = 1; i < ELFHALF(ehdr.e_shnum); i++) {
+		if (!strcmp(name, shstrtab + shdrs[i].sh_name))
+			return &shdrs[i];
+	}
+	if (must_have) {
+		fprintf(stderr, "Can't find %s section!\n", name);
+		exit(1);
+	}
+	return NULL;
+}
+
+/* read in a copy of a section */
+static void *copy_section(int fd, Elf32_Shdr *sh, const char *name)
+{
+	int err;
+	void *buf;
+
+	buf = malloc(sh->sh_size);
+	if (buf == NULL) {
+		fprintf(stderr, "Out of memory!\n");
+		exit(1);
+	}
+	err = elf_read(fd, sh->sh_offset, buf, sh->sh_size);
+	if (err) {
+		fprintf(stderr, "Can't read %s section: %s\n",
+			name, strerror(err));
+		exit(1);
+	}
+	return buf;
+}
+
+int main(int argc, char *argv[])
+{
+	int i, dtb_fd, out_fd = -1, kernel_fd, err;
+	off_t dtb_size, kern_size;
+	size_t n;
+	void *dtb_map, *kern_map, *buf;
+	Elf32_Shdr *sh;
+	char *outfilename = NULL;
+
+	if (argc == 4) {
+		outfilename = argv[3];
+		--argc;
+	}
+
+	if (argc != 3)
+		usage();
+
+	dtb_fd = open(argv[1], O_RDONLY);
+	if (dtb_fd < 0) {
+		fprintf(stderr, "Can't open %s: %s\n",
+			argv[1], strerror(errno));
+		exit(1);
+	}
+
+	if (outfilename) {
+		out_fd = creat(outfilename, 0775);
+		if (out_fd < 0) {
+			fprintf(stderr, "Can't create %s: %s\n",
+				outfilename, strerror(errno));
+			exit(1);
+		}
+		kernel_fd = open(argv[2], O_RDONLY);
+	} else
+		kernel_fd = open(argv[2], O_RDWR);
+	if (kernel_fd < 0) {
+		fprintf(stderr, "Can't open %s: %s\n",
+			argv[2], strerror(errno));
+		exit(1);
+	}
+
+	err = elf_read(kernel_fd, 0, &ehdr, sizeof(ehdr));
+	if (err) {
+		fprintf(stderr, "Can't read ELF header: %s\n", strerror(err));
+		exit(1);
+	}
+
+	if (strncmp((char *)ehdr.e_ident, "\177ELF", 4) != 0) {
+		fprintf(stderr, "Bad ELF ident!\n");
+		exit(1);
+	}
+
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+	if (ehdr.e_ident[EI_DATA] == ELFDATA2MSB)
+		do_swab = 1;
+#else
+	if (ehdr.e_ident[EI_DATA] == ELFDATA2LSB)
+		do_swab = 1;
+#endif
+
+	if (ELFHALF(ehdr.e_machine) != EM_TI_C6000) {
+		fprintf(stderr, "Bad ELF machine!\n");
+		exit(1);
+	}
+
+	if (ELFHALF(ehdr.e_shentsize) != sizeof(Elf32_Shdr)) {
+		fprintf(stderr, "Bad ELF header (e_shentsize = %d)!\n",
+			ELFHALF(ehdr.e_shentsize));
+		exit(1);
+	}
+
+	/* kernel should have _way_ fewer sections */
+	if (ELFHALF(ehdr.e_shnum) > 100) {
+		fprintf(stderr, "Bad ELF header (e_shnum = %d)!\n",
+			ELFHALF(ehdr.e_shnum));
+		exit(1);
+	}
+
+	/* get section headers */
+	n = ELFHALF(ehdr.e_shnum) * ELFHALF(ehdr.e_shentsize);
+	shdrs = malloc(n);
+	if (shdrs == NULL) {
+		fprintf(stderr, "Out of memory!\n");
+		exit(1);
+	}
+	err = elf_read(kernel_fd, ELFWORD(ehdr.e_shoff), shdrs, n);
+	if (err) {
+		fprintf(stderr, "Can't read section headers: %s\n",
+			strerror(err));
+		exit(1);
+	}
+	if (do_swab)
+		for (i = 1; i < ELFHALF(ehdr.e_shnum); i++) {
+			sh = &shdrs[i];
+			sh->sh_name = swab32(sh->sh_name);
+			sh->sh_type = swab32(sh->sh_type);
+			sh->sh_flags = swab32(sh->sh_flags);
+			sh->sh_addr = swab32(sh->sh_addr);
+			sh->sh_offset = swab32(sh->sh_offset);
+			sh->sh_size = swab32(sh->sh_size);
+			sh->sh_link = swab32(sh->sh_link);
+			sh->sh_info = swab32(sh->sh_info);
+			sh->sh_addralign = swab32(sh->sh_addralign);
+			sh->sh_entsize = swab32(sh->sh_entsize);
+		}
+	/* get shdr strings so we can search for section headers by name */
+	shstrtab = copy_section(kernel_fd, &shdrs[ELFHALF(ehdr.e_shstrndx)],
+				".shstrtab");
+
+	/* read in symtab and associated strings */
+	sh = find_section_by_name("__fdt_blob", 1);
+
+	dtb_size = lseek(dtb_fd, 0, SEEK_END);
+	if (dtb_size == -1 || lseek(dtb_fd, 0, SEEK_SET) == -1) {
+		fprintf(stderr, "Unable to seek %s: %s\n",
+			argv[1], strerror(err));
+		exit(1);
+	}
+
+	if (dtb_size > sh->sh_size) {
+		fprintf(stderr, "dtb too large (%d) to fit in section (%d).\n",
+			(int)dtb_size, sh->sh_size);
+		exit(1);
+	}
+
+	dtb_map = mmap(NULL, dtb_size, PROT_READ, MAP_PRIVATE, dtb_fd, 0);
+	if (dtb_map == MAP_FAILED) {
+		fprintf(stderr, "Failed to map %s: %s\n",
+			argv[1], strerror(err));
+		exit(1);
+	}
+
+	buf = malloc(sh->sh_size);
+	if (buf == NULL) {
+		fprintf(stderr, "Failed to malloc %d bytes!\n", sh->sh_size);
+		exit(1);
+	}
+	memset(buf, 0, sh->sh_size);
+	memcpy(buf, dtb_map, dtb_size);
+
+	if (!outfilename) {
+		/* write the dtb */
+		err = elf_write(kernel_fd, sh->sh_offset, buf, sh->sh_size);
+		if (err) {
+			fprintf(stderr, "Unable to write DTB: %s\n",
+				strerror(err));
+			exit(1);
+		}
+	} else {
+		kern_size = lseek(kernel_fd, 0, SEEK_END);
+		if (kern_size == -1 || lseek(dtb_fd, 0, SEEK_SET) == -1) {
+			fprintf(stderr, "Unable to seek %s: %s\n",
+				argv[2], strerror(err));
+			exit(1);
+		}
+
+		kern_map = mmap(NULL, kern_size, PROT_READ, MAP_PRIVATE, kernel_fd, 0);
+		if (kern_map == MAP_FAILED) {
+			fprintf(stderr, "Failed to map %s: %s\n",
+				argv[2], strerror(err));
+			exit(1);
+		}
+
+		/* write output file in three parts */
+
+		err = elf_write(out_fd, 0, kern_map, sh->sh_offset);
+		if (err) {
+			fprintf(stderr, "Error writing to %s: %s\n",
+				outfilename, strerror(err));
+			exit(1);
+		}
+
+		err = elf_write(out_fd, sh->sh_offset, buf, sh->sh_size);
+		if (err) {
+			fprintf(stderr, "Error writing to %s: %s\n",
+				outfilename, strerror(err));
+			exit(1);
+		}
+
+		err = elf_write(out_fd, sh->sh_offset + sh->sh_size,
+				kern_map + sh->sh_offset + sh->sh_size,
+				kern_size - (sh->sh_offset + sh->sh_size));
+		if (err) {
+			fprintf(stderr, "Error writing to %s: %s\n",
+				outfilename, strerror(err));
+			exit(1);
+		}
+
+		close(out_fd);
+	}
+	close(kernel_fd);
+	close(dtb_fd);
+	return 0;
+}
diff --git a/arch/c6x/kernel/devicetree.c b/arch/c6x/kernel/devicetree.c
new file mode 100644
index 0000000..bdb56f0
--- /dev/null
+++ b/arch/c6x/kernel/devicetree.c
@@ -0,0 +1,53 @@
+/*
+ *  Architecture specific OF callbacks.
+ *
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+#include <linux/init.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/initrd.h>
+#include <linux/memblock.h>
+
+void __init early_init_devtree(void *params)
+{
+	/* Setup flat device-tree pointer */
+	initial_boot_params = params;
+
+	/* Retrieve various informations from the /chosen node of the
+	 * device-tree, including the platform type, initrd location and
+	 * size and more ...
+	 */
+	of_scan_flat_dt(early_init_dt_scan_chosen, c6x_command_line);
+
+	/* Scan memory nodes and rebuild MEMBLOCKs */
+	of_scan_flat_dt(early_init_dt_scan_root, NULL);
+	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
+}
+
+
+#ifdef CONFIG_BLK_DEV_INITRD
+void __init early_init_dt_setup_initrd_arch(unsigned long start,
+		unsigned long end)
+{
+	initrd_start = (unsigned long)__va(start);
+	initrd_end = (unsigned long)__va(end);
+	initrd_below_start_ok = 1;
+}
+#endif
+
+void __init early_init_dt_add_memory_arch(u64 base, u64 size)
+{
+	c6x_add_memory(base, size);
+}
+
+void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
+{
+	return __va(memblock_alloc(size, align));
+}
diff --git a/arch/c6x/platforms/platform.c b/arch/c6x/platforms/platform.c
new file mode 100644
index 0000000..ad4651c
--- /dev/null
+++ b/arch/c6x/platforms/platform.c
@@ -0,0 +1,17 @@
+/*
+ * Copyright 2011 Texas Instruments Incorporated
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/of_platform.h>
+
+static int __init c6x_device_probe(void)
+{
+	of_platform_bus_probe(NULL, of_default_bus_match_table, NULL);
+	return 0;
+}
+device_initcall(c6x_device_probe);
-- 
1.7.6.2

