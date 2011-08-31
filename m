Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1HaV2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:28:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab1HaV2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:28:14 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ming.lei@canonical.com,
        stern@rowland.harvard.edu, Mark Salter <msalter@redhat.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 06/24] C6X: devicetree
Date: Wed, 31 Aug 2011 17:26:41 -0400
Message-Id: <1314826019-22330-7-git-send-email-msalter@redhat.com>
In-Reply-To: <1314826019-22330-1-git-send-email-msalter@redhat.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
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
 arch/c6x/boot/dts/dsk6455.dts  |  128 +++++++++++++++
 arch/c6x/boot/dts/evmc6457.dts |  106 +++++++++++++
 arch/c6x/boot/dts/evmc6472.dts |  176 +++++++++++++++++++++
 arch/c6x/boot/dts/evmc6474.dts |  133 ++++++++++++++++
 arch/c6x/boot/install-dtb.c    |  333 ++++++++++++++++++++++++++++++++++++++++
 arch/c6x/kernel/devicetree.c   |   53 +++++++
 arch/c6x/platforms/platform.c  |   23 +++
 7 files changed, 952 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/boot/dts/dsk6455.dts
 create mode 100644 arch/c6x/boot/dts/evmc6457.dts
 create mode 100644 arch/c6x/boot/dts/evmc6472.dts
 create mode 100644 arch/c6x/boot/dts/evmc6474.dts
 create mode 100644 arch/c6x/boot/install-dtb.c
 create mode 100644 arch/c6x/kernel/devicetree.c
 create mode 100644 arch/c6x/platforms/platform.c

diff --git a/arch/c6x/boot/dts/dsk6455.dts b/arch/c6x/boot/dts/dsk6455.dts
new file mode 100644
index 0000000..ef703aa
--- /dev/null
+++ b/arch/c6x/boot/dts/dsk6455.dts
@@ -0,0 +1,128 @@
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
+/ {
+	model = "Spectrum Digital DSK6455";
+	compatible = "spectrum-digital,dsk6455";
+
+	#address-cells = <1>;
+	#size-cells = <1>;
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
+	/*
+	 * Core priority interrupt controller
+	 */
+	core_pic: interrupt-controller@0 {
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		compatible = "ti,c64x+core-pic";
+	};
+
+	soc@00000000 {
+		compatible = "ti,tms320c6455";
+		device_type = "soc";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		#interrupt-cells = <1>;
+		ranges;
+		reg = <0x02a80000 0xc>;
+
+		clock-frequency = <50000000>;
+
+		/*
+		 * Megamodule interrupt controller
+		 */
+		megamod_pic: interrupt-controller@1800000 {
+		       interrupt-controller;
+		       #interrupt-cells = <1>;
+		       reg = <0x1800000 0x1000>;
+		       interrupt-parent = <&core_pic>;
+		       interrupts = < 12 13 14 15 >;
+		       ti,priority-map = < 0xffff 0xffff 0xffff 0xffff
+					   0xffff 0xffff 0xffff 0xffff
+					   0xffff 0xffff 0xffff 0xffff
+					   0 1 2 3 >;
+		       compatible = "ti,c64x+megamod-pic";
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
+			ti,emifa-burst-priority = <255>;
+			ti,emifa-ce-config = <0x00240120
+					      0x00240120
+					      0x00240122
+					      0x00240122>;
+
+			flash@3,0 {
+				#address-cells = <1>;
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
+			compatible = "ti,c64x+timer64";
+			reg = <0x2980000 0x40>;
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 69 >;
+		};
+
+		device-state-controller@2ac0000 {
+			compatible = "ti,tms320c6455-dscr";
+			reg = <0x02ac0000 0x80>;
+		};
+	};
+};
diff --git a/arch/c6x/boot/dts/evmc6457.dts b/arch/c6x/boot/dts/evmc6457.dts
new file mode 100644
index 0000000..f17ff9e
--- /dev/null
+++ b/arch/c6x/boot/dts/evmc6457.dts
@@ -0,0 +1,106 @@
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
+/ {
+	model = "eInfochips EVMC6457";
+	compatible = "einfochips,evmc6457";
+
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	chosen {
+		bootargs = "root=/dev/nfs ip=dhcp rw";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0xE0000000 0x10000000>;
+	};
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
+	/*
+	 * Core priority interrupt controller
+	 */
+	core_pic: interrupt-controller@0 {
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		compatible = "ti,c64x+core-pic";
+	};
+
+	soc@00000000 {
+		compatible = "ti,tms320c6457";
+		device_type = "soc";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		#interrupt-cells = <1>;
+		ranges;
+
+		clock-frequency = <60000000>;
+
+		/*
+		 * Megamodule interrupt controller
+		 */
+		megamod_pic: interrupt-controller@1800000 {
+		       interrupt-controller;
+		       #interrupt-cells = <1>;
+		       reg = <0x1800000 0x1000>;
+		       interrupt-parent = <&core_pic>;
+		       interrupts = < 12 13 14 15 >;
+		       ti,priority-map = < 0xffff 0xffff 0xffff 0xffff
+					   0xffff 0xffff 0xffff 0xffff
+					   0xffff 0xffff 0xffff 0xffff
+					   0 1 2 3 >;
+		       compatible = "ti,c64x+megamod-pic";
+		};
+
+		cache-controller@1840000 {
+			compatible = "ti,c64x+cache";
+			reg = <0x01840000 0x8400>;
+		};
+
+		timer0: timer@2940000 {
+			compatible = "ti,c64x+timer64";
+			reg = <0x2940000 0x40>;
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 67 >;
+		};
+
+		device-state-controller@2880800 {
+			compatible = "ti,tms320c6457-dscr";
+			reg = <0x02880800 0x400>;
+		};
+
+		power-sleep-controller@2ac0000 {
+			compatible = "ti,c64x+psc";
+			reg = <0x02ac0000 0x1000>;
+			ti,number-psc-domains = <5>;
+			ti,number-psc-modules = <11>;
+			ti,module-domain-map = <0 0 0 0 0 0 0 1 2 3 4>;
+		};
+	};
+};
diff --git a/arch/c6x/boot/dts/evmc6472.dts b/arch/c6x/boot/dts/evmc6472.dts
new file mode 100644
index 0000000..9c5a3da
--- /dev/null
+++ b/arch/c6x/boot/dts/evmc6472.dts
@@ -0,0 +1,176 @@
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
+/ {
+	model = "eInfochips EVMC6472";
+	compatible = "einfochips,evmc6472";
+
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	chosen {
+		bootargs = "root=/dev/nfs ip=dhcp rw";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0xE0000000 0x10000000>;
+	};
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
+	/*
+	 * Core priority interrupt controller
+	 */
+	core_pic: interrupt-controller@0 {
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		compatible = "ti,c64x+core-pic";
+	};
+
+	soc@00000000 {
+		compatible = "ti,tms320c6472";
+		device_type = "soc";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		#interrupt-cells = <1>;
+		ranges;
+
+		clock-frequency = <25000000>;
+
+		/*
+		 * Megamodule interrupt controller
+		 */
+		megamod_pic: interrupt-controller@1800000 {
+		       interrupt-controller;
+		       #interrupt-cells = <1>;
+		       reg = <0x1800000 0x1000>;
+		       interrupt-parent = <&core_pic>;
+		       interrupts = < 12 13 14 15 >;
+		       ti,priority-map = < 0xffff 0xffff 0xffff 0xffff
+					   0xffff 0xffff 0xffff 0xffff
+					   0xffff 0xffff 0xffff 0xffff
+					   0 1 2 3 >;
+		       compatible = "ti,c64x+megamod-pic";
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
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 16 >;
+		};
+
+		timer1: timer@25f0000 {
+			compatible = "ti,c64x+timer64";
+			ti,core-mask = < 0x02 >;
+			reg = <0x25f0000 0x40>;
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 16 >;
+		};
+
+		timer2: timer@2600000 {
+			compatible = "ti,c64x+timer64";
+			ti,core-mask = < 0x04 >;
+			reg = <0x2600000 0x40>;
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 16 >;
+		};
+
+		timer3: timer@2610000 {
+			compatible = "ti,c64x+timer64";
+			ti,core-mask = < 0x08 >;
+			reg = <0x2610000 0x40>;
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 16 >;
+		};
+
+		timer4: timer@2620000 {
+			compatible = "ti,c64x+timer64";
+			ti,core-mask = < 0x10 >;
+			reg = <0x2620000 0x40>;
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 16 >;
+		};
+
+		timer5: timer@2630000 {
+			compatible = "ti,c64x+timer64";
+			ti,core-mask = < 0x20 >;
+			reg = <0x2630000 0x40>;
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 16 >;
+		};
+
+		device-state-controller@2a80000 {
+			compatible = "ti,tms320c6472-dscr";
+			reg = <0x02a80000 0x1000>;
+		};
+
+		boot-controller@2ab0000 {
+			compatible = "ti,tms320c6472-boot-controller";
+			reg = <0x02ab0000 0x8000>;
+		};
+
+		power-sleep-controller@2ae0000 {
+			compatible = "ti,c64x+psc";
+			reg = <0x02ae0000 0x1000>;
+			ti,number-psc-domains = <1>;
+			ti,number-psc-modules = <14>;
+		};
+	};
+};
diff --git a/arch/c6x/boot/dts/evmc6474.dts b/arch/c6x/boot/dts/evmc6474.dts
new file mode 100644
index 0000000..48f791b
--- /dev/null
+++ b/arch/c6x/boot/dts/evmc6474.dts
@@ -0,0 +1,133 @@
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
+/ {
+	model = "Spectrum Digital EVMC6474";
+	compatible = "spectrum-digital,evmc6474";
+
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	chosen {
+		bootargs = "root=/dev/nfs ip=dhcp rw";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x80000000 0x08000000>;
+	};
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
+	/*
+	 * Core priority interrupt controller
+	 */
+	core_pic: interrupt-controller@0 {
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		compatible = "ti,c64x+core-pic";
+	};
+
+	soc@00000000 {
+		compatible = "ti,tms320c6474";
+		device_type = "soc";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		#interrupt-cells = <1>;
+		ranges;
+
+		clock-frequency = <50000000>;
+
+		/*
+		 * Megamodule interrupt controller
+		 */
+		megamod_pic: interrupt-controller@1800000 {
+		       interrupt-controller;
+		       #interrupt-cells = <1>;
+		       reg = <0x1800000 0x1000>;
+		       interrupt-parent = <&core_pic>;
+		       interrupts = < 12 13 14 15 >;
+		       ti,priority-map = < 0xffff 0xffff 0xffff 0xffff
+					   0xffff 0xffff 0xffff 0xffff
+					   0xffff 0xffff 0xffff 0xffff
+					   0 1 2 3 >;
+		       compatible = "ti,c64x+megamod-pic";
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
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 39 >;
+		};
+
+		timer4: timer@2950000 {
+			compatible = "ti,c64x+timer64";
+			ti,core-mask = < 0x02 >;
+			reg = <0x2950000 0x40>;
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 41 >;
+		};
+
+		timer5: timer@2960000 {
+			compatible = "ti,c64x+timer64";
+			ti,core-mask = < 0x01 >;
+			reg = <0x2960000 0x40>;
+			interrupt-parent = <&megamod_pic>;
+			interrupts = < 43 >;
+		};
+
+		device-state-controller@2880800 {
+			compatible = "ti,tms320c6474-dscr";
+			reg = <0x02880800 0x400>;
+		};
+
+		power-sleep-controller@2ac0000 {
+			compatible = "ti,c64x+psc";
+			reg = <0x02ac0000 0x1000>;
+			ti,number-psc-domains = <8>;
+			ti,number-psc-modules = <11>;
+			ti,module-domain-map = <0 0 0 0 0 0 1 2 3 4 5>;
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
index 0000000..83fbedd
--- /dev/null
+++ b/arch/c6x/platforms/platform.c
@@ -0,0 +1,23 @@
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
+static struct of_device_id c6x_bus_ids[] __initdata = {
+	{ .type = "soc", },
+	{ .compatible = "simple-bus", },
+	{}
+};
+
+static int __init c6x_device_probe(void)
+{
+	of_platform_bus_probe(NULL, c6x_bus_ids, NULL);
+	return 0;
+}
+device_initcall(c6x_device_probe);
-- 
1.7.6

