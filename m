Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab1BBS7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:59:05 -0500
Received: from www.tglx.de ([62.245.132.106]:45732 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785Ab1BBS7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:59:03 -0500
Date: Thu, 3 Feb 2011 00:28:41 +0530
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: David Gibson <david@gibson.dropbear.id.au>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org
Subject: [PATCH TIP v2 03/14] x86/dtb: Add a device tree for CE4100
Message-ID: <20110202185841.GA28674@www.tglx.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de> <1295843342-1122-4-git-send-email-bigeasy@linutronix.de> <20110127050027.GB23443@yookeroo>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110127050027.GB23443@yookeroo>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
- intel,ce4100-immr become intel,ce4100-cp. cp stands for core
  peripherals. The Atom data sheet talks here about ACPI devices. Since
  we don't have ACPI this does not apply here.
- The interrupt map is gone. There are now plenty of device nodes.
- The "unit address string" got fixed, it uses not DD,V format.

 arch/x86/platform/ce4100/falconfalls.dts |  424 ++++++++++++++++++++++++++++++
 1 files changed, 424 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/platform/ce4100/falconfalls.dts

diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
new file mode 100644
index 0000000..e888657
--- /dev/null
+++ b/arch/x86/platform/ce4100/falconfalls.dts
@@ -0,0 +1,424 @@
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
+			compatible = "intel,ioapic-ce4100", "intel,ioapic";
+			interrupt-controller;
+			reg = <0xfec00000 0x1000>;
+		};
+
+		timer@fed00000 {
+			compatible = "intel,hpet-ce4100", "intel,hpet";
+			reg = <0xfed00000 0x200>;
+		};
+
+		lapic0: interrupt-controller@fee00000 {
+			compatible = "intel,lapic-ce4100", "intel,lapic";
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
+				compatible = "intel,ioapic-ce4100", "intel,ioapic";
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
+					reg = <0x15900 0x0 0x0 0x0 0x0>;
+					interrupts = <15 1>;
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
+							compatible = "ti,pcf8575";
+							reg = <0x26>;
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
+							compatible = "ti,pcf8575";
+							reg = <0x26>;
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
1.7.3.2

