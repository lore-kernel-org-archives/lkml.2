Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab1BVUIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:08:20 -0500
Received: from www.tglx.de ([62.245.132.106]:38494 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab1BVUIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:08:18 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, devicetree-discuss@lists.ozlabs.org,
        x86@kernel.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 03/11] x86/dtb: Add a device tree for CE4100
Date: Tue, 22 Feb 2011 21:07:38 +0100
Message-Id: <1298405266-1624-4-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298405266-1624-1-git-send-email-bigeasy@linutronix.de>
References: <1298405266-1624-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

History:
v1..v2:
- dropped device_type except for cpu & pci. I have the compatible string
  for pci so I can drop the device_type once it is possible
- I lowercased all compatible types. I will need to resend some patches
  which have upper case intel
- The cpu had the same compatible string as the soc node. So I added to
  the soc node -immr for internel memory mapped registers.
- I added generic names for all parts.
- I reworked the i2c bars matching the way you suggested. I added a
  compatible node for the PCI device which only the PCI ids in its
  compatible string. The bars (each represents a complete i2c
  controller) have a "intel,ce4100-i2c-controller" compatible node. It
  is not used by the driver.
  The driver is probed via PCI ids (by the pci subsystem not OF) and
  matches the bar address against the ressource in the child node. Once
  there is a hit the node is attached.
- The SPI driver is also probed via pci. However I also attached a
  compatible property based on PCI ids

v2..v3:
- intel,ce4100-immr become intel,ce4100-cp. cp stands for core
  peripherals. The Atom data sheet talks here about ACPI devices. Since
  we don't have ACPI this does not apply here.
- The interrupt map is gone. There are now plenty of device nodes.
- The "unit address string" got fixed, it uses not DD,V format.

v3..v4:
- added descriptions for compatible nodes introduced here:
  - intel,ce4100-ioapic
  - intel,ce4100-lapic
  - intel,ce4100-hpet
  - intel,ce4100
  - intel,ce4100-cp
  - intel,ce4100-pci
- added a description about I2C controller magic.
- Added gpio-controller and gpio-cells property to gpio devices. Those
  properties are not (yet) used.

Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 .../devicetree/bindings/i2c/ce4100-i2c.txt         |   93 +++++
 Documentation/devicetree/bindings/x86/ce4100.txt   |   38 ++
 .../devicetree/bindings/x86/interrupt.txt          |   29 ++
 Documentation/devicetree/bindings/x86/timer.txt    |    6 +
 arch/x86/platform/ce4100/falconfalls.dts           |  430 ++++++++++++++++++++
 5 files changed, 596 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/ce4100-i2c.txt
 create mode 100644 Documentation/devicetree/bindings/x86/ce4100.txt
 create mode 100644 Documentation/devicetree/bindings/x86/interrupt.txt
 create mode 100644 Documentation/devicetree/bindings/x86/timer.txt
 create mode 100644 arch/x86/platform/ce4100/falconfalls.dts

diff --git a/Documentation/devicetree/bindings/i2c/ce4100-i2c.txt b/Documentation/devicetree/bindings/i2c/ce4100-i2c.txt
new file mode 100644
index 0000000..569b162
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/ce4100-i2c.txt
@@ -0,0 +1,93 @@
+CE4100 I2C
+----------
+
+CE4100 has one PCI device which is described as the I2C-Controller. This
+PCI device has three PCI-bars, each bar contains a complete I2C
+controller. So we have a total of three independent I2C-Controllers
+which share only an interrupt line.
+The driver is probed via the PCI-ID and is gathering the information of
+attached devices from the devices tree.
+Grant Likely recommended to use the ranges property to map the PCI-Bar
+number to its physical address and to use this to find the child nodes
+of the specific I2C controller. This were his exact words:
+
+       Here's where the magic happens.  Each entry in
+       ranges describes how the parent pci address space
+       (middle group of 3) is translated to the local
+       address space (first group of 2) and the size of
+       each range (last cell).  In this particular case,
+       the first cell of the local address is chosen to be
+       1:1 mapped to the BARs, and the second is the
+       offset from be base of the BAR (which would be
+       non-zero if you had 2 or more devices mapped off
+       the same BAR)
+
+       ranges allows the address mapping to be described
+       in a way that the OS can interpret without
+       requiring custom device driver code.
+
+This is an example which is used on FalconFalls:
+------------------------------------------------
+	i2c-controller@b,2 {
+		#address-cells = <2>;
+		#size-cells = <1>;
+		compatible = "pci8086,2e68.2",
+				"pci8086,2e68",
+				"pciclass,ff0000",
+				"pciclass,ff00";
+
+		reg = <0x15a00 0x0 0x0 0x0 0x0>;
+		interrupts = <16 1>;
+
+		/* as described by Grant, the first number in the group of
+		* three is the bar number followed by the 64bit bar address
+		* followed by size of the mapping. The bar address
+		* requires also a valid translation in parents ranges
+		* property.
+		*/
+		ranges = <0 0   0x02000000 0 0xdffe0500 0x100
+			  1 0   0x02000000 0 0xdffe0600 0x100
+			  2 0   0x02000000 0 0xdffe0700 0x100>;
+
+		i2c@0 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "intel,ce4100-i2c-controller";
+
+			/* The first number in the reg property is the
+			* number of the bar
+			*/
+			reg = <0 0 0x100>;
+
+			/* This I2C controller has no devices */
+		};
+
+		i2c@1 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "intel,ce4100-i2c-controller";
+			reg = <1 0 0x100>;
+
+			/* This I2C controller has one gpio controller */
+			gpio@26 {
+				#gpio-cells = <2>;
+				compatible = "ti,pcf8575";
+				reg = <0x26>;
+				gpio-controller;
+			};
+		};
+
+		i2c@2 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "intel,ce4100-i2c-controller";
+			reg = <2 0 0x100>;
+
+			gpio@26 {
+				#gpio-cells = <2>;
+				compatible = "ti,pcf8575";
+				reg = <0x26>;
+				gpio-controller;
+			};
+		};
+	};
diff --git a/Documentation/devicetree/bindings/x86/ce4100.txt b/Documentation/devicetree/bindings/x86/ce4100.txt
new file mode 100644
index 0000000..b49ae59
--- /dev/null
+++ b/Documentation/devicetree/bindings/x86/ce4100.txt
@@ -0,0 +1,38 @@
+CE4100 Device Tree Bindings
+---------------------------
+
+The CE4100 SoC uses for in core peripherals the following compatible
+format: <vendor>,<chip>-<device>.
+Many of the "generic" devices like HPET or IO APIC have the ce4100
+name in their compatible property because they first appeared in this
+SoC.
+
+The CPU node
+------------
+	cpu@0 {
+		device_type = "cpu";
+		compatible = "intel,ce4100";
+		reg = <0>;
+		lapic = <&lapic0>;
+	};
+
+The reg property describes the CPU number. The lapic property points to
+the local APIC timer.
+
+The SoC node
+------------
+
+This node describes the in-core peripherals. Required property:
+  compatible = "intel,ce4100-cp";
+
+The PCI node
+------------
+This node describes the PCI bus on the SoC. Its property should be
+  compatible = "intel,ce4100-pci", "pci";
+
+If the OS is using the IO-APIC for interrupt routing then the reported
+interrupt numbers for devices is no longer true. In order to obtain the
+correct interrupt number, the child node which represents the device has
+to contain the interrupt property. Besides the interrupt property it has
+to contain at least the reg property containing the PCI bus address and
+compatible property according to "PCI Bus Binding Revision 2.1".
diff --git a/Documentation/devicetree/bindings/x86/interrupt.txt b/Documentation/devicetree/bindings/x86/interrupt.txt
new file mode 100644
index 0000000..8b0efb0
--- /dev/null
+++ b/Documentation/devicetree/bindings/x86/interrupt.txt
@@ -0,0 +1,29 @@
+Interrupt chips
+---------------
+
+* Intel I/O Advanced Programmable Interrupt Controller (IO APIC)
+
+  Required properties:
+  --------------------
+     compatible = "intel,ce4100-ioapic";
+     #interrupt-cells = <2>;
+
+  Device's interrupt property:
+
+     interrupts = <P S>;
+
+  The first number (P) represents the interrupt pin which is wired to the
+  IO APIC. The second number (S) represents the sense of interrupt which
+  should be configured and can be one of:
+    0 - Edge Rising
+    1 - Level Low
+    2 - Level High
+    3 - Edge Falling
+
+* Local APIC
+  Required property:
+
+     compatible = "intel,ce4100-lapic";
+
+  This node is currently unused by Linux as the address of the local APIC
+  read from a MSR.
diff --git a/Documentation/devicetree/bindings/x86/timer.txt b/Documentation/devicetree/bindings/x86/timer.txt
new file mode 100644
index 0000000..c688af5
--- /dev/null
+++ b/Documentation/devicetree/bindings/x86/timer.txt
@@ -0,0 +1,6 @@
+Timers
+------
+
+* High Precision Event Timer (HPET)
+  Required property:
+     compatible = "intel,ce4100-hpet";
diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
new file mode 100644
index 0000000..e28de4c
--- /dev/null
+++ b/arch/x86/platform/ce4100/falconfalls.dts
@@ -0,0 +1,430 @@
+/*
+ * CE4100 on Falcon Falls
+ *
+ * (c) Copyright 2010 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License.
+ */
+/dts-v1/;
+/ {
+	model = "intel,falconfalls";
+	compatible = "intel,falconfalls";
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "intel,ce4100";
+			reg = <0>;
+			lapic = <&lapic0>;
+		};
+	};
+
+	soc@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "intel,ce4100-cp";
+		ranges;
+
+		ioapic1: interrupt-controller@fec00000 {
+			#interrupt-cells = <2>;
+			compatible = "intel,ce4100-ioapic";
+			interrupt-controller;
+			reg = <0xfec00000 0x1000>;
+		};
+
+		timer@fed00000 {
+			compatible = "intel,ce4100-hpet";
+			reg = <0xfed00000 0x200>;
+		};
+
+		lapic0: interrupt-controller@fee00000 {
+			compatible = "intel,ce4100-lapic";
+			reg = <0xfee00000 0x1000>;
+		};
+
+		pci@3fc {
+			#address-cells = <3>;
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			compatible = "intel,ce4100-pci", "pci";
+			device_type = "pci";
+			bus-range = <0 0>;
+			ranges = <0x2000000 0 0xbffff000 0xbffff000 0 0x1000
+				  0x2000000 0 0xdffe0000 0xdffe0000 0 0x1000
+				  0x0000000 0 0x0	 0x0	    0 0x100>;
+
+			/* Secondary IO-APIC */
+			ioapic2: interrupt-controller@0,1 {
+				#interrupt-cells = <2>;
+				compatible = "intel,ce4100-ioapic";
+				interrupt-controller;
+				reg = <0x100 0x0 0x0 0x0 0x0>;
+				assigned-addresses = <0x02000000 0x0 0xbffff000 0x0 0x1000>;
+			};
+
+			pci@1,0 {
+				#address-cells = <3>;
+				#interrupt-cells = <1>;
+				#size-cells = <2>;
+				compatible = "intel,ce4100-pci", "pci";
+				device_type = "pci";
+				bus-range = <1 1>;
+				ranges = <0x2000000 0 0xdffe0000 0x2000000 0 0xdffe0000 0 0x1000>;
+
+				interrupt-parent = <&ioapic2>;
+
+				display@2,0 {
+					compatible = "pci8086,2e5b.2",
+						   "pci8086,2e5b",
+						   "pciclass038000",
+						   "pciclass0380";
+
+					reg = <0x11000 0x0 0x0 0x0 0x0>;
+					interrupts = <0 1>;
+				};
+
+				multimedia@3,0 {
+					compatible = "pci8086,2e5c.2",
+						   "pci8086,2e5c",
+						   "pciclass048000",
+						   "pciclass0480";
+
+					reg = <0x11800 0x0 0x0 0x0 0x0>;
+					interrupts = <2 1>;
+				};
+
+				multimedia@4,0 {
+					compatible = "pci8086,2e5d.2",
+						   "pci8086,2e5d",
+						   "pciclass048000",
+						   "pciclass0480";
+
+					reg = <0x12000 0x0 0x0 0x0 0x0>;
+					interrupts = <4 1>;
+				};
+
+				multimedia@4,1 {
+					compatible = "pci8086,2e5e.2",
+						   "pci8086,2e5e",
+						   "pciclass048000",
+						   "pciclass0480";
+
+					reg = <0x12100 0x0 0x0 0x0 0x0>;
+					interrupts = <5 1>;
+				};
+
+				sound@6,0 {
+					compatible = "pci8086,2e5f.2",
+						   "pci8086,2e5f",
+						   "pciclass040100",
+						   "pciclass0401";
+
+					reg = <0x13000 0x0 0x0 0x0 0x0>;
+					interrupts = <6 1>;
+				};
+
+				sound@6,1 {
+					compatible = "pci8086,2e5f.2",
+						   "pci8086,2e5f",
+						   "pciclass040100",
+						   "pciclass0401";
+
+					reg = <0x13100 0x0 0x0 0x0 0x0>;
+					interrupts = <7 1>;
+				};
+
+				sound@6,2 {
+					compatible = "pci8086,2e60.2",
+						   "pci8086,2e60",
+						   "pciclass040100",
+						   "pciclass0401";
+
+					reg = <0x13200 0x0 0x0 0x0 0x0>;
+					interrupts = <8 1>;
+				};
+
+				display@8,0 {
+					compatible = "pci8086,2e61.2",
+						   "pci8086,2e61",
+						   "pciclass038000",
+						   "pciclass0380";
+
+					reg = <0x14000 0x0 0x0 0x0 0x0>;
+					interrupts = <9 1>;
+				};
+
+				display@8,1 {
+					compatible = "pci8086,2e62.2",
+						   "pci8086,2e62",
+						   "pciclass038000",
+						   "pciclass0380";
+
+					reg = <0x14100 0x0 0x0 0x0 0x0>;
+					interrupts = <10 1>;
+				};
+
+				multimedia@8,2 {
+					compatible = "pci8086,2e63.2",
+						   "pci8086,2e63",
+						   "pciclass048000",
+						   "pciclass0480";
+
+					reg = <0x14200 0x0 0x0 0x0 0x0>;
+					interrupts = <11 1>;
+				};
+
+				entertainment-encryption@9,0 {
+					compatible = "pci8086,2e64.2",
+						   "pci8086,2e64",
+						   "pciclass101000",
+						   "pciclass1010";
+
+					reg = <0x14800 0x0 0x0 0x0 0x0>;
+					interrupts = <12 1>;
+				};
+
+				localbus@a,0 {
+					compatible = "pci8086,2e65.2",
+						   "pci8086,2e65",
+						   "pciclassff0000",
+						   "pciclassff00";
+
+					reg = <0x15000 0x0 0x0 0x0 0x0>;
+				};
+
+				serial@b,0 {
+					compatible = "pci8086,2e66.2",
+						   "pci8086,2e66",
+						   "pciclass070003",
+						   "pciclass0700";
+
+					reg = <0x15800 0x0 0x0 0x0 0x0>;
+					interrupts = <14 1>;
+				};
+
+				gpio@b,1 {
+					compatible = "pci8086,2e67.2",
+						   "pci8086,2e67",
+						   "pciclassff0000",
+						   "pciclassff00";
+
+					#gpio-cells = <2>;
+					reg = <0x15900 0x0 0x0 0x0 0x0>;
+					interrupts = <15 1>;
+					gpio-controller;
+				};
+
+				i2c-controller@b,2 {
+					#address-cells = <2>;
+					#size-cells = <1>;
+					compatible = "pci8086,2e68.2",
+						   "pci8086,2e68",
+						   "pciclass,ff0000",
+						   "pciclass,ff00";
+
+					reg = <0x15a00 0x0 0x0 0x0 0x0>;
+					interrupts = <16 1>;
+					ranges = <0 0	0x02000000 0 0xdffe0500	0x100
+						  1 0	0x02000000 0 0xdffe0600	0x100
+						  2 0	0x02000000 0 0xdffe0700	0x100>;
+
+					i2c@0 {
+						#address-cells = <1>;
+						#size-cells = <0>;
+						compatible = "intel,ce4100-i2c-controller";
+						reg = <0 0 0x100>;
+					};
+
+					i2c@1 {
+						#address-cells = <1>;
+						#size-cells = <0>;
+						compatible = "intel,ce4100-i2c-controller";
+						reg = <1 0 0x100>;
+
+						gpio@26 {
+							#gpio-cells = <2>;
+							compatible = "ti,pcf8575";
+							reg = <0x26>;
+							gpio-controller;
+						};
+					};
+
+					i2c@2 {
+						#address-cells = <1>;
+						#size-cells = <0>;
+						compatible = "intel,ce4100-i2c-controller";
+						reg = <2 0 0x100>;
+
+						gpio@26 {
+							#gpio-cells = <2>;
+							compatible = "ti,pcf8575";
+							reg = <0x26>;
+							gpio-controller;
+						};
+					};
+				};
+
+				smard-card@b,3 {
+					compatible = "pci8086,2e69.2",
+						   "pci8086,2e69",
+						   "pciclass070500",
+						   "pciclass0705";
+
+					reg = <0x15b00 0x0 0x0 0x0 0x0>;
+					interrupts = <15 1>;
+				};
+
+				spi-controller@b,4 {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					compatible =
+						"pci8086,2e6a.2",
+						"pci8086,2e6a",
+						"pciclass,ff0000",
+						"pciclass,ff00";
+
+					reg = <0x15c00 0x0 0x0 0x0 0x0>;
+					interrupts = <15 1>;
+
+					dac@0 {
+						compatible = "ti,pcm1755";
+						reg = <0>;
+						spi-max-frequency = <115200>;
+					};
+
+					dac@1 {
+						compatible = "ti,pcm1609a";
+						reg = <1>;
+						spi-max-frequency = <115200>;
+					};
+
+					eeprom@2 {
+						compatible = "atmel,at93c46";
+						reg = <2>;
+						spi-max-frequency = <115200>;
+					};
+				};
+
+				multimedia@b,7 {
+					compatible = "pci8086,2e6d.2",
+						   "pci8086,2e6d",
+						   "pciclassff0000",
+						   "pciclassff00";
+
+					reg = <0x15f00 0x0 0x0 0x0 0x0>;
+				};
+
+				ethernet@c,0 {
+					compatible = "pci8086,2e6e.2",
+						   "pci8086,2e6e",
+						   "pciclass020000",
+						   "pciclass0200";
+
+					reg = <0x16000 0x0 0x0 0x0 0x0>;
+					interrupts = <21 1>;
+				};
+
+				clock@c,1 {
+					compatible = "pci8086,2e6f.2",
+						   "pci8086,2e6f",
+						   "pciclassff0000",
+						   "pciclassff00";
+
+					reg = <0x16100 0x0 0x0 0x0 0x0>;
+					interrupts = <3 1>;
+				};
+
+				usb@d,0 {
+					compatible = "pci8086,2e70.2",
+						   "pci8086,2e70",
+						   "pciclass0c0320",
+						   "pciclass0c03";
+
+					reg = <0x16800 0x0 0x0 0x0 0x0>;
+					interrupts = <22 3>;
+				};
+
+				usb@d,1 {
+					compatible = "pci8086,2e70.2",
+						   "pci8086,2e70",
+						   "pciclass0c0320",
+						   "pciclass0c03";
+
+					reg = <0x16900 0x0 0x0 0x0 0x0>;
+					interrupts = <22 3>;
+				};
+
+				sata@e,0 {
+					compatible = "pci8086,2e71.0",
+						   "pci8086,2e71",
+						   "pciclass010601",
+						   "pciclass0106";
+
+					reg = <0x17000 0x0 0x0 0x0 0x0>;
+					interrupts = <23 3>;
+				};
+
+				flash@f,0 {
+					compatible = "pci8086,701.1",
+						   "pci8086,701",
+						   "pciclass050100",
+						   "pciclass0501";
+
+					reg = <0x17800 0x0 0x0 0x0 0x0>;
+					interrupts = <13 1>;
+				};
+
+				entertainment-encryption@10,0 {
+					compatible = "pci8086,702.1",
+						   "pci8086,702",
+						   "pciclass101000",
+						   "pciclass1010";
+
+					reg = <0x18000 0x0 0x0 0x0 0x0>;
+				};
+
+				co-processor@11,0 {
+					compatible = "pci8086,703.1",
+						   "pci8086,703",
+						   "pciclass0b4000",
+						   "pciclass0b40";
+
+					reg = <0x18800 0x0 0x0 0x0 0x0>;
+					interrupts = <1 1>;
+				};
+
+				multimedia@12,0 {
+					compatible = "pci8086,704.0",
+						   "pci8086,704",
+						   "pciclass048000",
+						   "pciclass0480";
+
+					reg = <0x19000 0x0 0x0 0x0 0x0>;
+				};
+			};
+
+			isa@1f,0 {
+				#address-cells = <2>;
+				#size-cells = <1>;
+				compatible = "isa";
+				ranges = <1 0 0 0 0 0x100>;
+
+				rtc@70 {
+					compatible = "intel,ce4100-rtc", "motorola,mc146818";
+					interrupts = <8 3>;
+					interrupt-parent = <&ioapic1>;
+					ctrl-reg = <2>;
+					freq-reg = <0x26>;
+					reg = <1 0x70 2>;
+				};
+			};
+		};
+	};
+};
-- 
1.7.4

