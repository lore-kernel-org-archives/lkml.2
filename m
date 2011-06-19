Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1FSLpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 07:45:34 -0400
Received: from mail.southpole.se ([193.12.106.18]:37739 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab1FSLpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 07:45:08 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 02/19] OpenRISC: Device tree
Date: Sun, 19 Jun 2011 13:43:28 +0200
Message-Id: <1308483825-6023-3-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308483825-6023-1-git-send-email-jonas@southpole.se>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The OpenRISC architecture uses the device tree infrastructure for the
platform description.  This is currently limited to having a device tree
built into the kernel, but work is underway within the OpenRISC project
to define how this device tree blob should be passed into the kernel from
an external resource.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/boot/dts/aac.dts    |  290 +++++++++++++++++++++++++++++++++++++
 arch/openrisc/boot/dts/atlys.dts  |   94 ++++++++++++
 arch/openrisc/boot/dts/system.dts |   88 +++++++++++
 arch/openrisc/include/asm/prom.h  |   92 ++++++++++++
 arch/openrisc/kernel/prom.c       |  109 ++++++++++++++
 5 files changed, 673 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/boot/dts/aac.dts
 create mode 100644 arch/openrisc/boot/dts/atlys.dts
 create mode 100644 arch/openrisc/boot/dts/system.dts
 create mode 100644 arch/openrisc/include/asm/prom.h
 create mode 100644 arch/openrisc/kernel/prom.c

diff --git a/arch/openrisc/boot/dts/aac.dts b/arch/openrisc/boot/dts/aac.dts
new file mode 100644
index 0000000..d9e724f
--- /dev/null
+++ b/arch/openrisc/boot/dts/aac.dts
@@ -0,0 +1,290 @@
+/dts-v1/;
+/ {
+	compatible = "orsoc,development-board";
+	#size-cells = <1>;
+	#address-cells = <1>;
+
+	chosen {
+		bootargs = "console=uart,mmio,0x90000000,115200 lpj=200000 debug";
+/*		bootargs = "console=uart,mmio,0x90000000,115200 lpj=200000 root=/dev/nfs rw nfsroot=172.30.0.1:/home/jonas/local/opencores/linux-2.6/arch/or32/support/rootfs,rw,nolock ip=172.30.0.2::::::"; */
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x2000000>;
+	};
+
+	cpus {
+		cpu@0 {
+			compatible = "opencores,openrisc-1200";
+			clock-frequency = <20000000>;
+		};
+	};
+
+	soc {
+		/* Every node with children must specify address-cells and
+		   size-cells; they are not inherited */
+		#address-cells = <1>;
+		#size-cells = <1>;
+		device_type = "soc";
+
+		/* This is also a 1:1 mapping but limits size of mappable
+		   region to 0x40000000 */
+		ranges = <0x80000000 0x80000000 0x40000000>;
+                /* An alternative is to specify an empty ranges here to
+                   indicates 1:1 mapping of SOC addresses (device addresses)
+                   to CPU addresses */
+                /*ranges;*/
+
+		/* This SOC has only a single, implicit PIC, so define it
+		   early and put the interrupt-parent property in the 'soc'
+		   node so that it's inherited by all the children using
+		   interrupts.
+		*/
+		interrupt-parent = <&pic>;
+
+		/* Devices with interrupts need a 'parent', so we need to
+		   define a controller */
+		pic: pic@0 {
+			compatible = "opencores,or1k-pic";
+			#interrupt-cells = <1>;
+			interrupt-controller;
+		};
+
+		scet0: scet@8c000000 {
+			compatible = "opencores,scet";
+			reg = <0x8c000000 0x100>;
+		};
+
+		serial0: serial@90000000 {
+			/* FIXME: device_type is still needed here...
+			   should remove requirement from of_serial driver */
+			device_type = "serial";
+			compatible = "opencores,uart", "ns16550a";
+			reg = <0x90000000 0x100>;
+			interrupts = <2>;
+			clock-frequency = <20000000>;
+		};
+
+		serial1: serial@93000000 {
+			device_type = "serial";
+			compatible = "opencores,uart", "ns16550a";
+			reg = <0x93000000 0x7>;
+			interrupts = <3>;
+			clock-frequency = <20000000>;
+		};
+
+		serial2: serial@94000000 {
+			device_type = "serial";
+			compatible = "opencores,uart", "ns16550a";
+			reg = <0x94000000 0x7>;
+			interrupts = <5>;
+			clock-frequency = <20000000>;
+		};
+
+		enet0: ethoc@92000000 {
+			compatible = "opencores,ethoc", "ethoc";
+			reg = <0x92000000 0x53>;
+			interrupts = <4>;
+		};
+
+		ohs900: ocores@9c000000 {
+			compatible = "opencores,ohs900-ocores";
+			reg = <0x9c000000 0x100>;
+			interrupts = <20 21>;
+			can_wakeup = <1>;
+			potpg = <10>;
+			power = <250>;
+		};
+
+		i2c0: ocores@a0000000 {
+			compatible = "opencores,i2c-ocores";
+			reg = <0xa0000000 0x8>;
+			interrupts = <10>;
+
+			regstep = <1>;
+			clock-frequency = <20000000>;
+
+			/* Devices connected on this I2C bus get
+			 * defined here; address- and size-cells
+			 * apply to these child devices
+			 */
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			dummy@60 {
+				compatible = "dummy";
+				reg = <60>;
+			};
+		};
+
+		i2c1: ocores@a1000000 {
+			compatible = "opencores,i2c-ocores";
+			reg = <0xa1000000 0x8>;
+			interrupts = <11>;
+
+			regstep = <1>;
+			clock-frequency = <20000000>;
+
+			/* Devices connected on this I2C bus get
+			 * defined here; address- and size-cells
+			 * apply to these child devices
+			 */
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			test@60 {
+				compatible = "dummy";
+				reg = <60>;
+			};
+
+			test2@64 {
+				compatible = "dummy";
+				reg = <64>;
+			};
+		};
+
+		i2c2: ocores@a2000000 {
+			compatible = "opencores,i2c-ocores";
+			reg = <0xa2000000 0x8>;
+			interrupts = <12>;
+
+			regstep = <1>;
+			clock-frequency = <20000000>;
+
+			/* Devices connected on this I2C bus get
+			 * defined here; address- and size-cells
+			 * apply to these child devices
+			 */
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c3: ocores@a3000000 {
+			compatible = "opencores,i2c-ocores";
+			reg = <0xa3000000 0x8>;
+			interrupts = <13>;
+
+			regstep = <1>;
+			clock-frequecy = <20000000>;
+
+			/* Devices connected on this I2C bus get
+			 * defined here; address- and size-cells
+			 * apply to these child devices
+			 */
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		spi0: spi0@b0000000 {
+			compatible = "opencores,spi-simple";
+			reg = <0xb0000000 0x5>;
+
+			/* Devices connected on this SPI bus get
+			 * defined here; address- and size-cells
+			 * apply to these child devices.
+			 */
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			flash0: mtd@0 {
+				compatible = "st,m25p10";
+				reg = <0>;
+				spi-max-frequency = <100000000>;
+
+				#address-cells = <1>;
+				#size-cells = <1>;
+
+				partition@0 {
+					label = "bootloader";
+					reg = <0x00000000 0x00018000>;
+					read-only;
+				};
+				partition@18000 {
+					label = "dtb";
+					reg = <0x00018000 0x00008000>;
+				};
+			};
+		};
+
+		spi1: spi1@b1000000 {
+			compatible = "opencores,spi-simple";
+			reg = <0xb1000000 0x5>;
+
+			/* Devices connected on this SPI bus get
+			 * defined here; address- and size-cells
+			 * apply to these child devices.
+			 */
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* Example SD card slot at chipselect 0 */
+			/* mmc-spi-slot@0 {
+				compatible = "mmc-spi-slot";
+				reg = <0>;
+				spi-max-frequency = <10000000>;
+			}; */
+		};
+
+		gpio0: gpio@91000000 {
+                        compatible = "opencores,jbtrivial";
+                        reg = <0x91000000 0x6>;
+                        #gpio-cells = <2>;
+                        gpio-controller;
+			xlnx,data-offset = <3>;
+			xlnx,tri-offset = <3>;
+                };
+
+                gpio-leds {
+                        compatible = "gpio-leds";
+
+                        heartbeat {
+                                label = "Heartbeat";
+                                gpios = <&gpio0 0 0x0>;
+                                linux,default-trigger = "heartbeat";
+                        };
+
+                        led1 {
+                                label = "led1";
+                                gpios = <&gpio0 1 0x0>;
+                        };
+
+                        led2 {
+                                label = "led2";
+                                gpios = <&gpio0 2 0x0>;
+                        };
+
+                        led3 {
+                                label = "led3";
+                                gpios = <&gpio0 3 0x0>;
+                        };
+
+                        led4 {
+                                label = "led4";
+                                gpios = <&gpio0 4 0x0>;
+                        };
+
+                        led5 {
+                                label = "led5";
+                                gpios = <&gpio0 5 0x0>;
+                        };
+
+                        led6 {
+                                label = "led6";
+                                gpios = <&gpio0 6 0x0>;
+                        };
+
+                        led7 {
+                                label = "led7";
+                                gpios = <&gpio0 7 0x0>;
+                        };
+                };
+
+	};
+};
diff --git a/arch/openrisc/boot/dts/atlys.dts b/arch/openrisc/boot/dts/atlys.dts
new file mode 100644
index 0000000..66396c8
--- /dev/null
+++ b/arch/openrisc/boot/dts/atlys.dts
@@ -0,0 +1,94 @@
+/**
+Format:
+
+alias : name[@bus] {
+
+
+Note that size-cells and address-cells apply values of child nodes; furthermore,
+they are not inherited, so every container with children needs to specify these
+properties.
+
+}
+
+**/
+
+/dts-v1/;
+/ {
+	compatible = "orsoc,development-board";
+	#size-cells = <1>;
+	#address-cells = <1>;
+
+	chosen {
+		bootargs = "console=tty0 console=uart,mmio,0x90000000,115200 lpj=500000 debug video=ocfb:640x480-16@60";
+/*		bootargs = "console=uart,mmio,0x90000000,115200 lpj=200000 root=/dev/nfs rw nfsroot=172.30.0.1:/home/jonas/local/opencores/linux-2.6/arch/or32/support/rootfs,rw,nolock ip=172.30.0.2::::::"; */
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x8000000>;
+	};
+
+	cpus {
+		cpu@0 {
+			compatible = "opencores,openrisc-1200";
+			clock-frequency = <50000000>;
+		};
+	};
+
+	/* The "soc" node */
+
+	soc {
+		/* Every node with children must specify address-cells and
+		   size-cells; they are not inherited */
+		#address-cells = <1>;
+		#size-cells = <1>;
+		device_type = "soc";
+
+		/* This is also a 1:1 mapping but limits size of mappable
+		   region to 0x40000000 */
+		ranges = <0x80000000 0x80000000 0x40000000>;
+
+		/* An alternative is to specify an empty ranges here to
+		   indicates 1:1 mapping of SOC addresses (device addresses)
+		   to CPU addresses */
+		/*ranges;*/
+
+		/* This SOC has only a single, implicit PIC, so define it
+		   early and put the interrupt-parent property in the 'soc'
+		   node so that it's inherited by all the children using
+		   interrupts.
+		*/
+		interrupt-parent = <&pic>;
+
+		/* Devices with interrupts need a 'parent', so we need to
+		   define a controller */
+		pic: pic@0 {
+			compatible = "opencores,or1k-pic";
+			#interrupt-cells = <1>;
+			interrupt-controller;
+		};
+
+		serial0: serial@90000000 {
+			/* FIXME: device_type is still needed here...
+			   should remove requirement from of_serial driver */
+			device_type = "serial";
+			compatible = "opencores,uart", "ns16550a";
+			reg = <0x90000000 0x100>;
+			interrupts = <2>;
+			clock-frequency = <50000000>;
+		};
+
+		enet0: ethoc@92000000 {
+			compatible = "opencores,ethoc", "ethoc";
+			reg = <0x92000000 0x53>;
+			interrupts = <4>;
+			local-mac-address = [02 de ad be ef 02];
+		};
+
+		fb0: ocfb@97000000 {
+			compatible = "opencores,ocfb", "ocfb";
+			reg = <0x97000000 0x1000>;
+		};
+
+	};
+};
diff --git a/arch/openrisc/boot/dts/system.dts b/arch/openrisc/boot/dts/system.dts
new file mode 100644
index 0000000..9098c0e
--- /dev/null
+++ b/arch/openrisc/boot/dts/system.dts
@@ -0,0 +1,88 @@
+/**
+Format:
+
+alias : name[@bus] {
+
+
+Note that size-cells and address-cells apply values of child nodes; furthermore,
+they are not inherited, so every container with children needs to specify these
+properties.
+
+}
+
+**/
+
+/dts-v1/;
+/ {
+	compatible = "orsoc,development-board";
+	#size-cells = <1>;
+	#address-cells = <1>;
+
+	chosen {
+		bootargs = "console=uart,mmio,0x90000000,115200 lpj=200000 debug";
+/*		bootargs = "console=uart,mmio,0x90000000,115200 lpj=200000 root=/dev/nfs rw nfsroot=172.30.0.1:/home/jonas/local/opencores/linux-2.6/arch/or32/support/rootfs,rw,nolock ip=172.30.0.2::::::"; */
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x2000000>;
+	};
+
+	cpus {
+		cpu@0 {
+			compatible = "opencores,openrisc-1200";
+			clock-frequency = <20000000>;
+		};
+	};
+
+	/* The "soc" node */
+
+	soc {
+		/* Every node with children must specify address-cells and
+		   size-cells; they are not inherited */
+		#address-cells = <1>;
+		#size-cells = <1>;
+		device_type = "soc";
+
+		/* This is also a 1:1 mapping but limits size of mappable
+		   region to 0x40000000 */
+		ranges = <0x80000000 0x80000000 0x40000000>;
+
+		/* An alternative is to specify an empty ranges here to
+		   indicates 1:1 mapping of SOC addresses (device addresses)
+		   to CPU addresses */
+		/*ranges;*/
+
+		/* This SOC has only a single, implicit PIC, so define it
+		   early and put the interrupt-parent property in the 'soc'
+		   node so that it's inherited by all the children using
+		   interrupts.
+		*/
+		interrupt-parent = <&pic>;
+
+		/* Devices with interrupts need a 'parent', so we need to
+		   define a controller */
+		pic: pic@0 {
+			compatible = "opencores,or1k-pic";
+			#interrupt-cells = <1>;
+			interrupt-controller;
+		};
+
+		serial0: serial@90000000 {
+			/* FIXME: device_type is still needed here...
+			   should remove requirement from of_serial driver */
+			device_type = "serial";
+			compatible = "opencores,uart", "ns16550a";
+			reg = <0x90000000 0x100>;
+			interrupts = <2>;
+			clock-frequency = <20000000>;
+		};
+
+		enet0: ethoc@92000000 {
+			compatible = "opencores,ethoc", "ethoc";
+			reg = <0x92000000 0x53>;
+			interrupts = <4>;
+			local-mac-address = [02 de ad be ef 02];
+		};
+	};
+};
diff --git a/arch/openrisc/include/asm/prom.h b/arch/openrisc/include/asm/prom.h
new file mode 100644
index 0000000..3818902
--- /dev/null
+++ b/arch/openrisc/include/asm/prom.h
@@ -0,0 +1,92 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/of.h>	/* linux/of.h gets to determine #include ordering */
+
+#ifndef _ASM_OPENRISC_PROM_H
+#define _ASM_OPENRISC_PROM_H
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+#include <asm/irq.h>
+#include <asm/atomic.h>
+#include <linux/of_irq.h>
+#include <linux/of_fdt.h>
+#include <linux/of_address.h>
+#include <linux/proc_fs.h>
+#include <linux/platform_device.h>
+#define HAVE_ARCH_DEVTREE_FIXUPS
+
+/* Other Prototypes */
+extern int early_uartlite_console(void);
+
+#ifdef CONFIG_PCI
+/*
+ * PCI <-> OF matching functions
+ * (XXX should these be here?)
+ */
+struct pci_bus;
+struct pci_dev;
+extern int pci_device_from_OF_node(struct device_node *node,
+					u8 *bus, u8 *devfn);
+extern struct device_node *pci_busdev_to_OF_node(struct pci_bus *bus,
+							int devfn);
+extern struct device_node *pci_device_to_OF_node(struct pci_dev *dev);
+extern void pci_create_OF_bus_map(void);
+#endif
+
+/* Parse the ibm,dma-window property of an OF node into the busno, phys and
+ * size parameters.
+ */
+void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
+		unsigned long *busno, unsigned long *phys, unsigned long *size);
+
+extern void kdump_move_device_tree(void);
+
+/* CPU OF node matching */
+struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
+
+/* Get the MAC address */
+extern const void *of_get_mac_address(struct device_node *np);
+
+/**
+ * of_irq_map_pci - Resolve the interrupt for a PCI device
+ * @pdev:	the device whose interrupt is to be resolved
+ * @out_irq:	structure of_irq filled by this function
+ *
+ * This function resolves the PCI interrupt for a given PCI device. If a
+ * device-node exists for a given pci_dev, it will use normal OF tree
+ * walking. If not, it will implement standard swizzling and walk up the
+ * PCI tree until an device-node is found, at which point it will finish
+ * resolving using the OF tree walking.
+ */
+struct pci_dev;
+extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
+
+/* This routine is here to provide compatibility with how powerpc
+ * handles IRQ mapping for OF device nodes.  We precompute and permanently
+ * register them in the platform_device objects, whereas powerpc computes them
+ * on request.
+ */
+static inline void irq_dispose_mapping(unsigned int virq)
+{
+}
+
+#endif /* __ASSEMBLY__ */
+#endif /* __KERNEL__ */
+#endif /* _ASM_OPENRISC_PROM_H */
diff --git a/arch/openrisc/kernel/prom.c b/arch/openrisc/kernel/prom.c
new file mode 100644
index 0000000..1d2a0a9
--- /dev/null
+++ b/arch/openrisc/kernel/prom.c
@@ -0,0 +1,109 @@
+/*
+ * OpenRISC prom.c
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ * Architecture specific procedures for creating, accessing and
+ * interpreting the device tree.
+ *
+ */
+
+#include <stdarg.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/init.h>
+#include <linux/threads.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/stringify.h>
+#include <linux/delay.h>
+#include <linux/initrd.h>
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <linux/kexec.h>
+#include <linux/debugfs.h>
+#include <linux/irq.h>
+#include <linux/memblock.h>
+#include <linux/of_fdt.h>
+
+#include <asm/prom.h>
+#include <asm/page.h>
+#include <asm/processor.h>
+#include <asm/irq.h>
+#include <linux/io.h>
+#include <asm/system.h>
+#include <asm/mmu.h>
+#include <asm/pgtable.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+
+extern char cmd_line[COMMAND_LINE_SIZE];
+
+void __init early_init_dt_add_memory_arch(u64 base, u64 size)
+{
+	size &= PAGE_MASK;
+	memblock_add(base, size);
+}
+
+void* __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
+{
+	return __va(memblock_alloc(size, align));
+}
+
+void __init early_init_devtree(void *params)
+{
+	u8* alloc;
+
+	/* Setup flat device-tree pointer */
+	initial_boot_params = params;
+
+
+	/* Retrieve various informations from the /chosen node of the
+	 * device-tree, including the platform type, initrd location and
+	 * size, TCE reserve, and more ...
+	 */
+	of_scan_flat_dt(early_init_dt_scan_chosen, cmd_line);
+
+	/* Scan memory nodes and rebuild MEMBLOCKs */
+	memblock_init();
+	of_scan_flat_dt(early_init_dt_scan_root, NULL);
+	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
+
+	/* Save command line for /proc/cmdline and then parse parameters */
+	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
+//	parse_early_param();
+
+	memblock_analyze();
+
+	/* We must copy the flattend device tree from init memory to regular
+	 * memory because the device tree references the strings in it
+	 * directly.
+	 */
+
+	alloc = __va(memblock_alloc(initial_boot_params->totalsize, PAGE_SIZE));
+
+	memcpy(alloc, initial_boot_params, initial_boot_params->totalsize);
+
+	initial_boot_params = (void*) alloc;
+}
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
-- 
1.7.4.1

