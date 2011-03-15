Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab1COUAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:00:05 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:7664 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab1COUAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:00:00 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [RFC PATCH v??] MIPS: Octeon: Add device tree source files.
Date: Tue, 15 Mar 2011 12:59:30 -0700
Message-Id: <1300219170-1614-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 15 Mar 2011 19:59:36.0675 (UTC) FILETIME=[82CD8330:01CBE34B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
I have made some big changes to my device tree and wanted to try to
get some feedback on just the dts part before sending a revised 12
patch set.

I think I addressed all of Grant's comments from the last round.

Things that are new that could use some close supervision:

o gpio-controller, How is this supposed to work as a source of
  interrupts?  The current Linux kernel code will not let it be an
  interrupt-parent unless it is also made an 'interrupt-controller'.

o Some of my PHYs are now connected to the GPIO pin 5 for interrupts.

o serial, I added my three UARTS.  How is this supposed to be probed
  by the Linux kernel's 8250.c driver?

o bootbus, This is a bunch (8) programmable chip selects.  How should
  bus timing and width be configured for these things?

o nor flash, Connected to chip select 0.  In the Linux kernel how am I
  supposed to translate the addresses across the bootbus bridge based
  on chip select?

o USB, The EHCI and OHCI controllers are shown as children of the uctl
  device which has some configurable clocks.  Is this sane?

Thanks in advance for any feedback,
David Daney

 arch/mips/cavium-octeon/.gitignore      |    2 +
 arch/mips/cavium-octeon/Makefile        |   13 +
 arch/mips/cavium-octeon/octeon_3xxx.dts |  424 +++++++++++++++++++++++++++++++
 3 files changed, 439 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/cavium-octeon/.gitignore
 create mode 100644 arch/mips/cavium-octeon/octeon_3xxx.dts

diff --git a/arch/mips/cavium-octeon/.gitignore b/arch/mips/cavium-octeon/.gitignore
new file mode 100644
index 0000000..39c9686
--- /dev/null
+++ b/arch/mips/cavium-octeon/.gitignore
@@ -0,0 +1,2 @@
+*.dtb.S
+*.dtb
diff --git a/arch/mips/cavium-octeon/Makefile b/arch/mips/cavium-octeon/Makefile
index 19eb043..b8d4f63 100644
--- a/arch/mips/cavium-octeon/Makefile
+++ b/arch/mips/cavium-octeon/Makefile
@@ -15,3 +15,16 @@ obj-y += octeon-memcpy.o
 obj-y += executive/
 
 obj-$(CONFIG_SMP)                     += smp.o
+
+DTS_FILES = octeon_3xxx.dts
+DTB_FILES = $(patsubst %.dts, %.dtb, $(DTS_FILES))
+
+obj-y += $(patsubst %.dts, %.dtb.o, $(DTS_FILES))
+
+$(obj)/%.dtb: $(src)/%.dts
+	$(call cmd,dtc)
+
+# Let's keep the .dtb files around in case we want to look at them.
+.SECONDARY:  $(addprefix $(obj)/, $(DTB_FILES))
+
+clean-files += $(DTB_FILES) $(patsubst %.dtb, %.dtb.S, $(DTB_FILES))
diff --git a/arch/mips/cavium-octeon/octeon_3xxx.dts b/arch/mips/cavium-octeon/octeon_3xxx.dts
new file mode 100644
index 0000000..29f44e0
--- /dev/null
+++ b/arch/mips/cavium-octeon/octeon_3xxx.dts
@@ -0,0 +1,424 @@
+/dts-v1/;
+/*
+ * OCTEON 3XXX, 5XXX, 63XX device tree skeleton.
+ *
+ * This device tree is pruned and patched by early boot code before
+ * use.  Because of this, it contains a super-set of the available
+ * devices and properties.
+ */
+/ {
+	compatible = "cavium,octeon-3860";
+	#address-cells = <2>;
+	#size-cells = <2>;
+	interrupt-parent = <&ciu>;
+
+	soc@0 {
+		compatible = "simple-bus";
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges; /* Direct mapping */
+
+		ciu: interrupt-controller@1070000000000 {
+			compatible = "cavium,octeon-3860-ciu";
+			interrupt-controller;
+			#address-cells = <0>;
+			/* Interrupts are specified by two parts:
+			 * 1) Controller register (0 or 1)
+			 * 2) Bit within the register (0..63)
+			 */
+			#interrupt-cells = <2>;
+			reg = <0x10700 0x00000000 0x0 0x7000>;
+		};
+
+		gpio: gpio-controller@1070000000800 {
+			#gpio-cells = <2>;
+			compatible = "cavium,octeon-3860-gpio";
+			reg = <0x10700 0x00000800 0x0 0x100>;
+			gpio-controller;
+			/* Interrupts are specified by two parts:
+			 * 1) GPIO pin number (0..15)
+			 * 2) Triggering (0 - level active high
+			 *		  1 - level active low
+			 *		  2 - edge rising
+			 *		  3 - edge falling
+			 */
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			/* The GPIO pin connect to 16 consecutive CUI bits */
+			interrupts = <0 16>; /* <0 17> <0 18> <0 19>
+				     <0 20> <0 21> <0 22> <0 23>
+				     <0 24> <0 25> <0 26> <0 27>
+				     <0 28> <0 29> <0 30> <0 31>; */
+		};
+
+		smi0: mdio@1180000001800 {
+			compatible = "cavium,octeon-3860-mdio";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x11800 0x00001800 0x0 0x40>;
+
+			phy0: ethernet-phy@0 {
+				compatible = "broadcom,bcm5241";
+				reg = <0>;
+			};
+
+			phy1: ethernet-phy@1 {
+				compatible = "broadcom,bcm5241";
+				reg = <1>;
+			};
+
+			phy2: ethernet-phy@2 {
+				reg = <2>;
+				compatible = "marvell,88e1149r";
+				marvell,reg-init = <3 0x10 0 0x5777>,
+					<3 0x11 0 0x00aa>,
+					<3 0x12 0 0x4105>,
+					<3 0x13 0 0x0a60>;
+				interrupt-parent = <&gpio>;
+				interrupts = <5 1>; /* Pin 5, active low */
+			};
+			phy3: ethernet-phy@3 {
+				reg = <3>;
+				compatible = "marvell,88e1149r";
+				marvell,reg-init = <3 0x10 0 0x5777>,
+					<3 0x11 0 0x00aa>,
+					<3 0x12 0 0x4105>,
+					<3 0x13 0 0x0a60>;
+				interrupt-parent = <&gpio>;
+				interrupts = <5 1>; /* Pin 5, active low */
+			};
+			phy4: ethernet-phy@4 {
+				reg = <4>;
+				compatible = "marvell,88e1149r";
+				marvell,reg-init = <3 0x10 0 0x5777>,
+					<3 0x11 0 0x00aa>,
+					<3 0x12 0 0x4105>,
+					<3 0x13 0 0x0a60>;
+				interrupt-parent = <&gpio>;
+				interrupts = <5 1>; /* Pin 5, active low */
+			};
+			phy5: ethernet-phy@5 {
+				reg = <5>;
+				compatible = "marvell,88e1149r";
+				marvell,reg-init = <3 0x10 0 0x5777>,
+					<3 0x11 0 0x00aa>,
+					<3 0x12 0 0x4105>,
+					<3 0x13 0 0x0a60>;
+				interrupt-parent = <&gpio>;
+				interrupts = <5 1>; /* Pin 5, active low */
+			};
+
+			phy6: ethernet-phy@6 {
+				reg = <6>;
+				compatible = "marvell,88e1149r";
+				marvell,reg-init = <3 0x10 0 0x5777>,
+					<3 0x11 0 0x00aa>,
+					<3 0x12 0 0x4105>,
+					<3 0x13 0 0x0a60>;
+			};
+			phy7: ethernet-phy@7 {
+				reg = <7>;
+				compatible = "marvell,88e1149r";
+				marvell,reg-init = <3 0x10 0 0x5777>,
+					<3 0x11 0 0x00aa>,
+					<3 0x12 0 0x4105>,
+					<3 0x13 0 0x0a60>;
+			};
+			phy8: ethernet-phy@8 {
+				reg = <8>;
+				compatible = "marvell,88e1149r";
+				marvell,reg-init = <3 0x10 0 0x5777>,
+					<3 0x11 0 0x00aa>,
+					<3 0x12 0 0x4105>,
+					<3 0x13 0 0x0a60>;
+			};
+			phy9: ethernet-phy@9 {
+				reg = <9>;
+				compatible = "marvell,88e1149r";
+				marvell,reg-init = <3 0x10 0 0x5777>,
+					<3 0x11 0 0x00aa>,
+					<3 0x12 0 0x4105>,
+					<3 0x13 0 0x0a60>;
+			};
+		};
+
+		smi1: mdio@1180000001900 {
+			compatible = "cavium,octeon-3860-mdio";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x11800 0x00001900 0x0 0x40>;
+		};
+
+		mix0: ethernet@1070000100000 {
+			compatible = "cavium,octeon-5750-mix";
+			reg = <0x10700 0x00100000 0x0 0x100>, /* MIX */
+			      <0x11800 0xE0000000 0x0 0x300>, /* AGL */
+			      <0x11800 0xE0000400 0x0 0x400>, /* AGL_SHARED  */
+			      <0x11800 0xE0002000 0x0 0x8>;   /* AGL_PRT_CTL */
+			cell-index = <0>;
+			interrupts = <0 62>, <1 46>;
+			local-mac-address = [ 00 00 00 00 00 00 ];
+			phy-handle = <&phy0>;
+		};
+
+		mix1: ethernet@1070000100800 {
+			compatible = "cavium,octeon-5750-mix";
+			reg = <0x10700 0x00100800 0x0 0x100>, /* MIX */
+			      <0x11800 0xE0000800 0x0 0x300>, /* AGL */
+			      <0x11800 0xE0000400 0x0 0x400>, /* AGL_SHARED  */
+			      <0x11800 0xE0002008 0x0 0x8>;   /* AGL_PRT_CTL */
+			cell-index = <1>;
+			interrupts = <1 18>, < 1 46>;
+			local-mac-address = [ 00 00 00 00 00 00 ];
+			phy-handle = <&phy1>;
+		};
+
+		pip: pip@11800a0000000 {
+			compatible = "cavium,octeon-3860-pip";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x11800 0xa0000000 0x0 0x2000>;
+
+			interface@0 {
+				compatible = "cavium,octeon-3860-pip-interface";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0>; /* interface */
+
+				ethernet@0 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x0>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+					phy-handle = <&phy2>;
+				};
+				ethernet@1 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x1>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+					phy-handle = <&phy3>;
+				};
+				ethernet@2 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x2>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+					phy-handle = <&phy4>;
+				};
+				ethernet@3 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x3>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+					phy-handle = <&phy5>;
+				};
+			};
+
+			interface@1 {
+				compatible = "cavium,octeon-3860-pip-interface";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <1>; /* interface */
+
+				ethernet@0 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x0>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+					phy-handle = <&phy6>;
+				};
+				ethernet@1 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x1>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+					phy-handle = <&phy7>;
+				};
+				ethernet@2 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x2>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+					phy-handle = <&phy8>;
+				};
+				ethernet@3 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x3>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+					phy-handle = <&phy9>;
+				};
+			};
+
+			interface@2 { /* DPI interface. */
+				compatible = "cavium,octeon-3860-pip-interface";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <2>; /* interface */
+
+				ethernet@0 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x0>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@1 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x1>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@2 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x2>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@3 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x3>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+			};
+
+			interface@3 { /* Loop interface. */
+				compatible = "cavium,octeon-3860-pip-interface";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <3>; /* interface */
+
+				ethernet@0 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x0>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@1 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x1>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@2 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x2>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+				ethernet@3 {
+					compatible = "cavium,octeon-3860-pip-port";
+					reg = <0x3>; /* Port */
+					local-mac-address = [ 00 00 00 00 00 00 ];
+				};
+			};
+		};
+
+		twsi0: i2c@1180000001000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "cavium,octeon-3860-twsi";
+			reg = <0x11800 0x00001000 0x0 0x200>;
+			interrupts = <0 45>;
+			clock-rate = <100000>;
+
+			rtc@68 {
+				compatible = "dallas,ds1337";
+				reg = <0x68>;
+			};
+			tmp@4c {
+				compatible = "ti,tmp421";
+				reg = <0x4c>;
+			};
+		};
+
+		twsi1: i2c@1180000001200 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "cavium,octeon-3860-twsi";
+			reg = <0x11800 0x00001200 0x0 0x200>;
+			interrupts = <0 59>;
+			clock-rate = <100000>;
+		};
+
+		uart0: serial@1180000000800 {
+			compatible = "cavium,octeon-3860-uart","ns16550";
+			reg = <0x11800 0x00000800 0x0 0x400>;
+			clock-frequency = <0>;
+			current-speed = <115200>;
+			reg-shift = <3>;
+			interrupts = <0 34>;
+		};
+
+		uart1: serial@1180000000c00 {
+			compatible = "cavium,octeon-3860-uart","ns16550";
+			reg = <0x11800 0x00000c00 0x0 0x400>;
+			clock-frequency = <0>;
+			current-speed = <115200>;
+			reg-shift = <3>;
+			interrupts = <0 35>;
+		};
+
+		uart2: serial@1180000000400 {
+			compatible = "cavium,octeon-3860-uart","ns16550";
+			reg = <0x11800 0x00000400 0x0 0x400>;
+			clock-frequency = <0>;
+			current-speed = <115200>;
+			reg-shift = <3>;
+			interrupts = <1 16>;
+		};
+
+		bootbus: bootbus@1000000000000 {
+			compatible = "cavium,octeon-3860-bootbus";
+			reg = <0x10000 0x00000000 0x1 0x00000000>;
+			/* The chip select number */
+			#address-cells = <1>;
+			/* The size of the chip select region */
+			#size-cells = <1>;
+
+			flash0: nor@0 {
+				compatible = "cfi-flash";
+				reg = <0 0x800000>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+
+				partition@0 {
+					label = "firmware";
+					reg = <0x0 0x400000>;
+					read-only;
+				};
+
+				partition@400000 {
+					label = "data";
+					reg = <0x400000 0x400000>;
+					read-only;
+				};
+			};
+		};
+
+		uctl: uctl@118006f000000 {
+			compatible = "cavium,octeon-6335-uctl";
+			reg = <0x11800 0x6f000000 0x0 0x100>;
+			ranges; /* Direct mapping */
+			#address-cells = <2>;
+			#size-cells = <2>;
+			/* 12MHz, 24MHz and 48MHz allowed */
+			refclk-frequency = <24000000>;
+			/* Either "crystal" or "external" */
+			refclk-type = "crystal";
+
+			ehci@16f0000000000 {
+				compatible = "cavium,octeon-6335-ehci","usb-ehci";
+				reg = <0x16f00 0x00000000 0x0 0x100>;
+				interrupts = <0 56>;
+				big-endian-regs;
+			};
+			ohci@16f0000000400 {
+				compatible = "cavium,octeon-6335-ohci","usb-ohci";
+				reg = <0x16f00 0x00000400 0x0 0x100>;
+				interrupts = <0 56>;
+				big-endian-regs;
+			};
+		};
+	};
+
+	aliases {
+		mix0 = &mix0;
+		mix1 = &mix1;
+		pip = &pip;
+		smi0 = &smi0;
+		smi1 = &smi1;
+		twsi0 = &twsi0;
+		twsi1 = &twsi1;
+		uart0 = &uart0;
+		uart1 = &uart1;
+		uart2 = &uart2;
+		flash0 = &flash0;
+	};
+ };
-- 
1.7.2.3

