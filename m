Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab0K2CPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:15:41 -0500
Received: from imp03.mtu.ru ([62.5.255.20]:59470 "EHLO imp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab0K2CP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:15:28 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Nov 2010 21:15:25 EST
Message-ID: <4CF30B46.4000203@pavlinux.ru>
Date: Mon, 29 Nov 2010 05:09:10 +0300
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Repalce strncmp by memcmp
Content-Type: multipart/mixed;
 boundary="------------090909050803010705050900"
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090909050803010705050900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


    This patch replace all strncmp(a, b, c) by  memcmp(a, b, c).

I test on x86_64 (AMD Opteron 285).

#include <string.h>
char *A = "0000";
void test_memcmp(void) {
        memcmp(A, "TEST", 4);
}
void test_strn(void) {
        strncmp(A, "TEST", 4);
}
# gcc -c -O2 test.c
# objdump -d test.o
...

0000000000000020 <test_strncmp>:
  20:   f3 c3                   repz retq
  22:   66 66 66 66 66 2e 0f    data32 data32 data32 data32 nopw
%cs:0x0(%rax,%rax,1)
  29:   1f 84 00 00 00 00 00

0000000000000030 <test_memcmp>:
  30:   f3 c3                   repz retq

Wow, minus  one commad :)

-- 

                                                         Pavel.


--------------090909050803010705050900
Content-Type: text/x-patch;
 name="strncmp2memcmp-2.6.37-rc3-git5.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="strncmp2memcmp-2.6.37-rc3-git5.patch"

diff --git a/Documentation/hwmon/hpfall.c b/Documentation/hwmon/hpfall.c
index a4a8fc5..d6c504d 100644
--- a/Documentation/hwmon/hpfall.c
+++ b/Documentation/hwmon/hpfall.c
@@ -25,7 +25,7 @@ int set_unload_heads_path(char *device)
 {
 	char devname[64];
 
-	if (strlen(device) <= 5 || strncmp(device, "/dev/", 5) != 0)
+	if (strlen(device) <= 5 || memcmp(device, "/dev/", 5) != 0)
 		return -EINVAL;
 	strncpy(devname, device + 5, sizeof(devname));
 
diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index dc73bc5..c86e60c 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -1532,7 +1532,7 @@ static void setup_tun_net(char *arg)
 		err(1, "opening IP socket");
 
 	/* If the command line was --tunnet=bridge:<name> do bridging. */
-	if (!strncmp(BRIDGE_PFX, arg, strlen(BRIDGE_PFX))) {
+	if (!memcmp(BRIDGE_PFX, arg, strlen(BRIDGE_PFX))) {
 		arg += strlen(BRIDGE_PFX);
 		bridging = true;
 	}
diff --git a/Documentation/vm/page-types.c b/Documentation/vm/page-types.c
index cc96ee2..3da3ad0 100644
--- a/Documentation/vm/page-types.c
+++ b/Documentation/vm/page-types.c
@@ -844,13 +844,13 @@ static uint64_t parse_flag_name(const char *str, int len)
 	if (!*str || !len)
 		return 0;
 
-	if (len <= 8 && !strncmp(str, "compound", len))
+	if (len <= 8 && !memcmp(str, "compound", len))
 		return BITS_COMPOUND;
 
 	for (i = 0; i < ARRAY_SIZE(page_flag_names); i++) {
 		if (!page_flag_names[i])
 			continue;
-		if (!strncmp(str, page_flag_names[i] + 2, len))
+		if (!memcmp(str, page_flag_names[i] + 2, len))
 			return 1ULL << i;
 	}
 
diff --git a/Documentation/vm/slabinfo.c b/Documentation/vm/slabinfo.c
index 92e729f..4e96cba 100644
--- a/Documentation/vm/slabinfo.c
+++ b/Documentation/vm/slabinfo.c
@@ -311,7 +311,7 @@ static struct aliasinfo *find_one_alias(struct slabinfo *find)
 		if (a->slab == find &&
 			(!best || strlen(best->name) < strlen(a->name))) {
 				best = a;
-				if (strncmp(a->name,"kmall", 5) == 0)
+				if (memcmp(a->name,"kmall", 5) == 0)
 					return best;
 			}
 	}
diff --git a/arch/alpha/boot/tools/objstrip.c b/arch/alpha/boot/tools/objstrip.c
index 367d53d..a8fc69b 100644
--- a/arch/alpha/boot/tools/objstrip.c
+++ b/arch/alpha/boot/tools/objstrip.c
@@ -144,7 +144,7 @@ main (int argc, char *argv[])
 #ifdef __ELF__
     elf = (struct elfhdr *) buf;
 
-    if (elf->e_ident[0] == 0x7f && strncmp((char *)elf->e_ident + 1, "ELF", 3) == 0) {
+    if (elf->e_ident[0] == 0x7f && memcmp((char *)elf->e_ident + 1, "ELF", 3) == 0) {
 	if (elf->e_type != ET_EXEC) {
 	    fprintf(stderr, "%s: %s is not an ELF executable\n",
 		    prog_name, inname);
diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index d2634e4..b05391c 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -532,7 +532,7 @@ setup_arch(char **cmdline_p)
 #ifdef CONFIG_ALPHA_GENERIC
 	/* Assume that we've booted from SRM if we haven't booted from MILO.
 	   Detect the later by looking for "MILO" in the system serial nr.  */
-	alpha_using_srm = strncmp((const char *)hwrpb->ssn, "MILO", 4) != 0;
+	alpha_using_srm = memcmp((const char *)hwrpb->ssn, "MILO", 4) != 0;
 #endif
 
 	/* If we are using SRM, we want to allow callbacks
@@ -560,33 +560,33 @@ setup_arch(char **cmdline_p)
 	 */
 	while ((p = strsep(&args, " \t")) != NULL) {
 		if (!*p) continue;
-		if (strncmp(p, "alpha_mv=", 9) == 0) {
+		if (memcmp(p, "alpha_mv=", 9) == 0) {
 			vec = get_sysvec_byname(p+9);
 			continue;
 		}
-		if (strncmp(p, "cycle=", 6) == 0) {
+		if (memcmp(p, "cycle=", 6) == 0) {
 			est_cycle_freq = simple_strtol(p+6, NULL, 0);
 			continue;
 		}
-		if (strncmp(p, "mem=", 4) == 0) {
+		if (memcmp(p, "mem=", 4) == 0) {
 			mem_size_limit = get_mem_size_limit(p+4);
 			continue;
 		}
-		if (strncmp(p, "srmcons", 7) == 0) {
+		if (memcmp(p, "srmcons", 7) == 0) {
 			srmcons_output |= 1;
 			continue;
 		}
-		if (strncmp(p, "console=srm", 11) == 0) {
+		if (memcmp(p, "console=srm", 11) == 0) {
 			srmcons_output |= 2;
 			continue;
 		}
-		if (strncmp(p, "gartsize=", 9) == 0) {
+		if (memcmp(p, "gartsize=", 9) == 0) {
 			alpha_agpgart_size =
 				get_mem_size_limit(p+9) << PAGE_SHIFT;
 			continue;
 		}
 #ifdef CONFIG_VERBOSE_MCHECK
-		if (strncmp(p, "verbose_mcheck=", 15) == 0) {
+		if (memcmp(p, "verbose_mcheck=", 15) == 0) {
 			alpha_verbose_mcheck = simple_strtol(p+15, NULL, 0);
 			continue;
 		}
diff --git a/arch/arm/kernel/leds.c b/arch/arm/kernel/leds.c
index 31a316c..9326519 100644
--- a/arch/arm/kernel/leds.c
+++ b/arch/arm/kernel/leds.c
@@ -41,10 +41,10 @@ static ssize_t leds_store(struct sys_device *dev,
 	if (len > 0 && buf[len] == '\0')
 		len--;
 
-	if (strncmp(buf, "claim", len) == 0) {
+	if (memcmp(buf, "claim", len) == 0) {
 		leds_event(led_claim);
 		ret = size;
-	} else if (strncmp(buf, "release", len) == 0) {
+	} else if (memcmp(buf, "release", len) == 0) {
 		leds_event(led_release);
 		ret = size;
 	} else {
@@ -52,12 +52,12 @@ static ssize_t leds_store(struct sys_device *dev,
 
 		for (i = 0; i < ARRAY_SIZE(evt_names); i++) {
 			if (strlen(evt_names[i].name) != len ||
-			    strncmp(buf, evt_names[i].name, len) != 0)
+			    memcmp(buf, evt_names[i].name, len) != 0)
 				continue;
-			if (strncmp(buf+len, " on", 3) == 0) {
+			if (memcmp(buf+len, " on", 3) == 0) {
 				leds_event(evt_names[i].on);
 				ret = size;
-			} else if (strncmp(buf+len, " off", 4) == 0) {
+			} else if (memcmp(buf+len, " off", 4) == 0) {
 				leds_event(evt_names[i].off);
 				ret = size;
 			}
diff --git a/arch/arm/mach-iop13xx/include/mach/memory.h b/arch/arm/mach-iop13xx/include/mach/memory.h
index 7415e43..1025a73 100644
--- a/arch/arm/mach-iop13xx/include/mach/memory.h
+++ b/arch/arm/mach-iop13xx/include/mach/memory.h
@@ -34,7 +34,7 @@ static inline unsigned long __lbus_to_virt(dma_addr_t x)
 
 /* Device is an lbus device if it is on the platform bus of the IOP13XX */
 #define is_lbus_device(dev) 				\
-	(dev && strncmp(dev->bus->name, "platform", 8) == 0)
+	(dev && memcmp(dev->bus->name, "platform", 8) == 0)
 
 #define __arch_dma_to_virt(dev, addr)					\
 	({								\
diff --git a/arch/arm/mach-kirkwood/openrd-setup.c b/arch/arm/mach-kirkwood/openrd-setup.c
index c9d77fa..9aca320 100644
--- a/arch/arm/mach-kirkwood/openrd-setup.c
+++ b/arch/arm/mach-kirkwood/openrd-setup.c
@@ -93,9 +93,9 @@ static int __init sd_uart_selection(char *str)
 	if (!str)
 		return 0;
 
-	if (!strncmp(str, "232", 3)) {
+	if (!memcmp(str, "232", 3)) {
 		uart1 = 232;
-	} else if (!strncmp(str, "485", 3)) {
+	} else if (!memcmp(str, "485", 3)) {
 		/* OpenRD-Base doesn't have RS485. Treat is as an
 		 * unknown argument & just have default setting -
 		 * which is SD */
diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index 074536a..c4a5f65 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -145,7 +145,7 @@ int __init omap_mux_init_signal(const char *muxname, int val)
 		int i;
 
 		/* First check for full name in mode0.muxmode format */
-		if (mode0_len && strncmp(muxname, m0_entry, mode0_len))
+		if (mode0_len && memcmp(muxname, m0_entry, mode0_len))
 			continue;
 
 		/* Then check for muxmode only */
diff --git a/arch/arm/mach-omap2/pm-debug.c b/arch/arm/mach-omap2/pm-debug.c
index 5e81517..a5eb780 100644
--- a/arch/arm/mach-omap2/pm-debug.c
+++ b/arch/arm/mach-omap2/pm-debug.c
@@ -377,7 +377,7 @@ static int clkdm_dbg_show_counter(struct clockdomain *clkdm, void *user)
 
 	if (strcmp(clkdm->name, "emu_clkdm") == 0 ||
 		strcmp(clkdm->name, "wkup_clkdm") == 0 ||
-		strncmp(clkdm->name, "dpll", 4) == 0)
+		memcmp(clkdm->name, "dpll", 4) == 0)
 		return 0;
 
 	seq_printf(s, "%s->%s (%d)", clkdm->name,
@@ -395,7 +395,7 @@ static int pwrdm_dbg_show_counter(struct powerdomain *pwrdm, void *user)
 
 	if (strcmp(pwrdm->name, "emu_pwrdm") == 0 ||
 		strcmp(pwrdm->name, "wkup_pwrdm") == 0 ||
-		strncmp(pwrdm->name, "dpll", 4) == 0)
+		memcmp(pwrdm->name, "dpll", 4) == 0)
 		return 0;
 
 	if (pwrdm->state != pwrdm_read_pwrst(pwrdm))
@@ -425,7 +425,7 @@ static int pwrdm_dbg_show_timer(struct powerdomain *pwrdm, void *user)
 
 	if (strcmp(pwrdm->name, "emu_pwrdm") == 0 ||
 		strcmp(pwrdm->name, "wkup_pwrdm") == 0 ||
-		strncmp(pwrdm->name, "dpll", 4) == 0)
+		memcmp(pwrdm->name, "dpll", 4) == 0)
 		return 0;
 
 	pwrdm_state_switch(pwrdm);
@@ -551,7 +551,7 @@ static int __init pwrdms_setup(struct powerdomain *pwrdm, void *dir)
 
 	pwrdm->timer = t;
 
-	if (strncmp(pwrdm->name, "dpll", 4) == 0)
+	if (memcmp(pwrdm->name, "dpll", 4) == 0)
 		return 0;
 
 	d = debugfs_create_dir(pwrdm->name, (struct dentry *)dir);
diff --git a/arch/arm/mach-orion5x/ts78xx-setup.c b/arch/arm/mach-orion5x/ts78xx-setup.c
index c1c1cd0..883e3c1 100644
--- a/arch/arm/mach-orion5x/ts78xx-setup.c
+++ b/arch/arm/mach-orion5x/ts78xx-setup.c
@@ -458,9 +458,9 @@ static ssize_t ts78xx_fpga_store(struct kobject *kobj,
 		return -EBUSY;
 	}
 
-	if (strncmp(buf, "online", sizeof("online") - 1) == 0)
+	if (memcmp(buf, "online", sizeof("online") - 1) == 0)
 		value = 1;
-	else if (strncmp(buf, "offline", sizeof("offline") - 1) == 0)
+	else if (memcmp(buf, "offline", sizeof("offline") - 1) == 0)
 		value = 0;
 	else {
 		printk(KERN_ERR "ts78xx_fpga_store: Invalid value\n");
diff --git a/arch/arm/plat-omap/include/plat/memory.h b/arch/arm/plat-omap/include/plat/memory.h
index d5306be..808f6b4 100644
--- a/arch/arm/plat-omap/include/plat/memory.h
+++ b/arch/arm/plat-omap/include/plat/memory.h
@@ -48,7 +48,7 @@
  * OMAP bus type is lbus. We do the address translation based on the
  * device overriding the defaults used in the dma-mapping API.
  * Note that the is_lbus_device() test is not very efficient on 1510
- * because of the strncmp().
+ * because of the memcmp().
  */
 #ifdef CONFIG_ARCH_OMAP15XX
 
@@ -59,7 +59,7 @@
 
 #define virt_to_lbus(x)		((x) - PAGE_OFFSET + OMAP1510_LB_OFFSET)
 #define lbus_to_virt(x)		((x) - OMAP1510_LB_OFFSET + PAGE_OFFSET)
-#define is_lbus_device(dev)	(cpu_is_omap15xx() && dev && (strncmp(dev_name(dev), "ohci", 4) == 0))
+#define is_lbus_device(dev)	(cpu_is_omap15xx() && dev && (memcmp(dev_name(dev), "ohci", 4) == 0))
 
 #define __arch_page_to_dma(dev, page)	\
 	({ dma_addr_t __dma = page_to_phys(page); \
diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c b/arch/blackfin/kernel/bfin_dma_5xx.c
index 1e485df..e8dec3c 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -115,7 +115,7 @@ int request_dma(unsigned int channel, const char *device_id)
 	if (channel >= CH_UART2_RX && channel <= CH_UART3_TX) {
 		unsigned int per_map;
 		per_map = dma_ch[channel].regs->peripheral_map & 0xFFF;
-		if (strncmp(device_id, "BFIN_UART", 9) == 0)
+		if (memcmp(device_id, "BFIN_UART", 9) == 0)
 			dma_ch[channel].regs->peripheral_map = per_map |
 				((channel - CH_UART2_RX + 0xC)<<12);
 		else
diff --git a/arch/blackfin/kernel/early_printk.c b/arch/blackfin/kernel/early_printk.c
index 84ed837..09c19f8 100644
--- a/arch/blackfin/kernel/early_printk.c
+++ b/arch/blackfin/kernel/early_printk.c
@@ -126,7 +126,7 @@ int __init setup_early_printk(char *buf)
 
 #ifdef CONFIG_SERIAL_BFIN
 	/* Check for Blackfin Serial */
-	if (!strncmp(buf, "serial,uart", 11)) {
+	if (!memcmp(buf, "serial,uart", 11)) {
 		buf += 11;
 		early_console = earlyserial_init(buf);
 	}
@@ -134,7 +134,7 @@ int __init setup_early_printk(char *buf)
 
 #ifdef CONFIG_BFIN_JTAG_COMM
 	/* Check for Blackfin JTAG */
-	if (!strncmp(buf, "jtag", 4)) {
+	if (!memcmp(buf, "jtag", 4)) {
 		buf += 4;
 		early_console = bfin_jc_early_init();
 	}
diff --git a/arch/frv/mb93090-mb00/pci-vdk.c b/arch/frv/mb93090-mb00/pci-vdk.c
index f8dd37e..52696b2 100644
--- a/arch/frv/mb93090-mb00/pci-vdk.c
+++ b/arch/frv/mb93090-mb00/pci-vdk.c
@@ -437,7 +437,7 @@ char * __init pcibios_setup(char *str)
 	if (!strcmp(str, "off")) {
 		pci_probe = 0;
 		return NULL;
-	} else if (!strncmp(str, "lastbus=", 8)) {
+	} else if (!memcmp(str, "lastbus=", 8)) {
 		pcibios_last_bus = simple_strtol(str+8, NULL, 0);
 		return NULL;
 	}
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 4ce8d13..6651fc0 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -2060,7 +2060,7 @@ acpi_sba_ioc_add(struct acpi_device *device)
 	 * For HWP0001, only SBA appears in ACPI namespace.  It encloses the PCI
 	 * root bridges, and its CSR space includes the IOC function.
 	 */
-	if (strncmp("HWP0001", adi->hardware_id.string, 7) == 0) {
+	if (memcmp("HWP0001", adi->hardware_id.string, 7) == 0) {
 		hpa += ZX1_IOC_OFFSET;
 		/* zx1 based systems default to kernel page size iommu pages */
 		if (!iovp_shift)
diff --git a/arch/ia64/hp/sim/boot/bootloader.c b/arch/ia64/hp/sim/boot/bootloader.c
index c5e9baa..d1ffbc1 100644
--- a/arch/ia64/hp/sim/boot/bootloader.c
+++ b/arch/ia64/hp/sim/boot/bootloader.c
@@ -112,7 +112,7 @@ start_bootloader (void)
 	ssc((long) &stat, 0, 0, 0, SSC_WAIT_COMPLETION);
 
 	elf = (struct elfhdr *) mem;
-	if (elf->e_ident[0] == 0x7f && strncmp(elf->e_ident + 1, "ELF", 3) != 0) {
+	if (elf->e_ident[0] == 0x7f && memcmp(elf->e_ident + 1, "ELF", 3) != 0) {
 		cons_write("not an ELF file\n");
 		return;
 	}
diff --git a/arch/ia64/hp/sim/simeth.c b/arch/ia64/hp/sim/simeth.c
index 7e81966..5c6d3b4 100644
--- a/arch/ia64/hp/sim/simeth.c
+++ b/arch/ia64/hp/sim/simeth.c
@@ -265,7 +265,7 @@ simeth_open(struct net_device *dev)
 /* copied from lapbether.c */
 static __inline__ int dev_is_ethdev(struct net_device *dev)
 {
-       return ( dev->type == ARPHRD_ETHER && strncmp(dev->name, "dummy", 5));
+       return ( dev->type == ARPHRD_ETHER && memcmp(dev->name, "dummy", 5));
 }
 
 
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index c6c90f3..ca993ba 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -100,7 +100,7 @@ acpi_get_sysname(void)
 	}
 
 	rsdp = (struct acpi_table_rsdp *)__va(rsdp_phys);
-	if (strncmp(rsdp->signature, ACPI_SIG_RSDP, sizeof(ACPI_SIG_RSDP) - 1)) {
+	if (memcmp(rsdp->signature, ACPI_SIG_RSDP, sizeof(ACPI_SIG_RSDP) - 1)) {
 		printk(KERN_ERR
 		       "ACPI 2.0 RSDP signature incorrect, default to \"dig\"\n");
 		return "dig";
@@ -108,7 +108,7 @@ acpi_get_sysname(void)
 
 	xsdt = (struct acpi_table_xsdt *)__va(rsdp->xsdt_physical_address);
 	hdr = &xsdt->header;
-	if (strncmp(hdr->signature, ACPI_SIG_XSDT, sizeof(ACPI_SIG_XSDT) - 1)) {
+	if (memcmp(hdr->signature, ACPI_SIG_XSDT, sizeof(ACPI_SIG_XSDT) - 1)) {
 		printk(KERN_ERR
 		       "ACPI 2.0 XSDT signature incorrect, default to \"dig\"\n");
 		return "dig";
@@ -131,7 +131,7 @@ acpi_get_sysname(void)
 			 sizeof(xsdt->table_offset_entry[0]);
 	for (i = 0; i < nentries; i++) {
 		hdr = __va(xsdt->table_offset_entry[i]);
-		if (strncmp(hdr->signature, ACPI_SIG_DMAR,
+		if (memcmp(hdr->signature, ACPI_SIG_DMAR,
 			sizeof(ACPI_SIG_DMAR) - 1) == 0)
 			return "dig_vtd";
 	}
@@ -373,7 +373,7 @@ acpi_parse_nmi_src(struct acpi_subtable_header * header, const unsigned long end
 
 static void __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	if (!strncmp(oem_id, "IBM", 3) && (!strncmp(oem_table_id, "SERMOW", 6))) {
+	if (!memcmp(oem_id, "IBM", 3) && (!strncmp(oem_table_id, "SERMOW", 6))) {
 
 		/*
 		 * Unfortunately ITC_DRIFT is not yet part of the
diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index a0f0019..8c61d8c 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -426,7 +426,7 @@ static void __init handle_palo(unsigned long palo_phys)
 	struct palo_table *palo = __va(palo_phys);
 	u8  checksum;
 
-	if (strncmp(palo->signature, PALO_SIG, sizeof(PALO_SIG) - 1)) {
+	if (memcmp(palo->signature, PALO_SIG, sizeof(PALO_SIG) - 1)) {
 		printk(KERN_INFO "PALO signature incorrect.\n");
 		return;
 	}
diff --git a/arch/ia64/kernel/esi.c b/arch/ia64/kernel/esi.c
index b091111..cfbd726 100644
--- a/arch/ia64/kernel/esi.c
+++ b/arch/ia64/kernel/esi.c
@@ -69,7 +69,7 @@ static int __init esi_init (void)
 
 	systab = __va(esi);
 
-	if (strncmp(systab->signature, "ESIT", 4) != 0) {
+	if (memcmp(systab->signature, "ESIT", 4) != 0) {
 		printk(KERN_ERR "bad signature in ESI system table!");
 		return -ENODEV;
 	}
diff --git a/arch/ia64/kernel/sal.c b/arch/ia64/kernel/sal.c
index 0464173..7a11560 100644
--- a/arch/ia64/kernel/sal.c
+++ b/arch/ia64/kernel/sal.c
@@ -314,7 +314,7 @@ ia64_sal_init (struct ia64_sal_systab *systab)
 		return;
 	}
 
-	if (strncmp(systab->signature, "SST_", 4) != 0)
+	if (memcmp(systab->signature, "SST_", 4) != 0)
 		printk(KERN_ERR "bad signature in system table!");
 
 	check_versions(systab);
diff --git a/arch/m32r/kernel/process.c b/arch/m32r/kernel/process.c
index 422bea9..adcb6d8 100644
--- a/arch/m32r/kernel/process.c
+++ b/arch/m32r/kernel/process.c
@@ -121,10 +121,10 @@ void machine_power_off(void)
 
 static int __init idle_setup (char *str)
 {
-	if (!strncmp(str, "poll", 4)) {
+	if (!memcmp(str, "poll", 4)) {
 		printk("using poll in idle threads.\n");
 		pm_idle = poll_idle;
-	} else if (!strncmp(str, "sleep", 4)) {
+	} else if (!memcmp(str, "sleep", 4)) {
 		printk("using sleep in idle threads.\n");
 		pm_idle = default_idle;
 	}
diff --git a/arch/m68k/atari/config.c b/arch/m68k/atari/config.c
index ae2d96e..bb98b65 100644
--- a/arch/m68k/atari/config.c
+++ b/arch/m68k/atari/config.c
@@ -165,7 +165,7 @@ static int __init atari_switches_setup(char *str)
 		if (!*p)
 			continue;
 		ovsc_shift = 0;
-		if (strncmp(p, "ov_", 3) == 0) {
+		if (memcmp(p, "ov_", 3) == 0) {
 			p += 3;
 			ovsc_shift = ATARI_SWITCH_OVSC_SHIFT;
 		}
diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
index 11edf61..fbe921b 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -142,7 +142,7 @@ void __init config_mvme16x(void)
 
     /* Report board revision */
 
-    if (strncmp("BDID", p->bdid, 4))
+    if (memcmp("BDID", p->bdid, 4))
     {
 	printk ("\n\nBug call .BRD_ID returned garbage - giving up\n\n");
 	while (1)
diff --git a/arch/m68k/q40/config.c b/arch/m68k/q40/config.c
index ad10fec..eb88b4f 100644
--- a/arch/m68k/q40/config.c
+++ b/arch/m68k/q40/config.c
@@ -83,7 +83,7 @@ static void q40_mem_console_write(struct console *co, const char *s,
 static int __init q40_debug_setup(char *arg)
 {
 	/* useful for early debugging stages - writes kernel messages into SRAM */
-	if (MACH_IS_Q40 && !strncmp(arg, "mem", 3)) {
+	if (MACH_IS_Q40 && !memcmp(arg, "mem", 3)) {
 		/*printk("using NVRAM debug, q40_mem_cptr=%p\n",q40_mem_cptr);*/
 		_cpleft = 2000 - ((long)q40_mem_cptr-0xff020000) / 4;
 		register_console(&q40_console_driver);
diff --git a/arch/m68k/sun3/prom/console.c b/arch/m68k/sun3/prom/console.c
index 2bcb6e4..8134e21 100644
--- a/arch/m68k/sun3/prom/console.c
+++ b/arch/m68k/sun3/prom/console.c
@@ -92,7 +92,7 @@ prom_query_input_device()
 		if(prom_node_has_property(st_p, "keyboard"))
 			return PROMDEV_IKBD;
 		prom_getproperty(st_p, "device_type", propb, sizeof(propb));
-		if(strncmp(propb, "serial", sizeof("serial")))
+		if(memcmp(propb, "serial", sizeof("serial")))
 			return PROMDEV_I_UNK;
 		prom_getproperty(prom_root_node, "stdin-path", propb, sizeof(propb));
 		p = propb;
@@ -139,12 +139,12 @@ prom_query_output_device()
 		local_irq_restore(flags);
 		propl = prom_getproperty(st_p, "device_type", propb, sizeof(propb));
 		if (propl >= 0 && propl == sizeof("display") &&
-			strncmp("display", propb, sizeof("display")) == 0)
+			memcmp("display", propb, sizeof("display")) == 0)
 		{
 			return PROMDEV_OSCREEN;
 		}
 		if(prom_vers == PROM_V3) {
-			if(strncmp("serial", propb, sizeof("serial")))
+			if(memcmp("serial", propb, sizeof("serial")))
 				return PROMDEV_O_UNK;
 			prom_getproperty(prom_root_node, "stdout-path", propb, sizeof(propb));
 			p = propb;
diff --git a/arch/m68knommu/platform/532x/config.c b/arch/m68knommu/platform/532x/config.c
index ca51323..8cecc8a 100644
--- a/arch/m68knommu/platform/532x/config.c
+++ b/arch/m68knommu/platform/532x/config.c
@@ -255,7 +255,7 @@ void __init config_BSP(char *commandp, int size)
 #if !defined(CONFIG_BOOTPARAM)
 	/* Copy command line from FLASH to local buffer... */
 	memcpy(commandp, (char *) 0x4000, 4);
-	if(strncmp(commandp, "kcl ", 4) == 0){
+	if(memcmp(commandp, "kcl ", 4) == 0){
 		memcpy(commandp, (char *) 0x4004, size);
 		commandp[size-1] = 0;
 	} else {
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index a105301..9ba428c 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -64,16 +64,16 @@ static int __init early_init_dt_scan_serial(unsigned long node,
 	pr_debug("search \"chosen\", depth: %d, uname: %s\n", depth, uname);
 
 /* find all serial nodes */
-	if (strncmp(uname, "serial", 6) != 0)
+	if (memcmp(uname, "serial", 6) != 0)
 		return 0;
 
 	early_init_dt_check_for_initrd(node);
 
 /* find compatible node with uartlite */
 	p = of_get_flat_dt_prop(node, "compatible", &l);
-	if ((strncmp(p, "xlnx,xps-uartlite", 17) != 0) &&
-			(strncmp(p, "xlnx,opb-uartlite", 17) != 0) &&
-			(strncmp(p, "xlnx,axi-uartlite", 17) != 0))
+	if ((memcmp(p, "xlnx,xps-uartlite", 17) != 0) &&
+			(memcmp(p, "xlnx,opb-uartlite", 17) != 0) &&
+			(memcmp(p, "xlnx,axi-uartlite", 17) != 0))
 		return 0;
 
 	addr = of_get_flat_dt_prop(node, "reg", &l);
@@ -97,7 +97,7 @@ static int __init early_init_dt_scan_serial_full(unsigned long node,
 	pr_debug("search \"chosen\", depth: %d, uname: %s\n", depth, uname);
 
 /* find all serial nodes */
-	if (strncmp(uname, "serial", 6) != 0)
+	if (memcmp(uname, "serial", 6) != 0)
 		return 0;
 
 	early_init_dt_check_for_initrd(node);
@@ -105,8 +105,8 @@ static int __init early_init_dt_scan_serial_full(unsigned long node,
 /* find compatible node with uartlite */
 	p = of_get_flat_dt_prop(node, "compatible", &l);
 
-	if ((strncmp(p, "xlnx,xps-uart16550", 18) != 0) &&
-		(strncmp(p, "xlnx,axi-uart16550", 18) != 0))
+	if ((memcmp(p, "xlnx,xps-uart16550", 18) != 0) &&
+		(memcmp(p, "xlnx,axi-uart16550", 18) != 0))
 		return 0;
 
 	addr = *(u32 *)of_get_flat_dt_prop(node, "reg", &l);
diff --git a/arch/mips/alchemy/common/prom.c b/arch/mips/alchemy/common/prom.c
index 5340210..a2e9537 100644
--- a/arch/mips/alchemy/common/prom.c
+++ b/arch/mips/alchemy/common/prom.c
@@ -69,7 +69,7 @@ char *prom_getenv(char *envname)
 		if (yamon) {
 			if (strcmp(envname, *env++) == 0)
 				return *env;
-		} else if (strncmp(envname, *env, i) == 0 && (*env)[i] == '=')
+		} else if (memcmp(envname, *env, i) == 0 && (*env)[i] == '=')
 			return *env + i + 1;
 		env++;
 	}
diff --git a/arch/mips/bcm47xx/nvram.c b/arch/mips/bcm47xx/nvram.c
index e5b6615..f060337 100644
--- a/arch/mips/bcm47xx/nvram.c
+++ b/arch/mips/bcm47xx/nvram.c
@@ -84,7 +84,7 @@ int nvram_getenv(char *name, char *val, size_t val_len)
 			break;
 		value = eq + 1;
 		if ((eq - var) == strlen(name) &&
-			strncmp(var, name, (eq - var)) == 0) {
+			memcmp(var, name, (eq - var)) == 0) {
 			snprintf(val, val_len, "%s", value);
 			return 0;
 		}
diff --git a/arch/mips/bcm47xx/prom.c b/arch/mips/bcm47xx/prom.c
index f6e9063..b88e9d4 100644
--- a/arch/mips/bcm47xx/prom.c
+++ b/arch/mips/bcm47xx/prom.c
@@ -113,7 +113,7 @@ static __init void prom_init_cmdline(void)
 	if ((strstr(arcs_cmdline, "console=")) == NULL) {
 		/* Try to read the default serial port used by CFE */
 		if ((cfe_getenv("BOOT_CONSOLE", buf, COMMAND_LINE_SIZE) < 0)
-		    || (strncmp("uart", buf, 4)))
+		    || (memcmp("uart", buf, 4)))
 			/* Default to uart0 */
 			strcpy(buf, "uart0");
 
diff --git a/arch/mips/bcm63xx/boards/board_bcm963xx.c b/arch/mips/bcm63xx/boards/board_bcm963xx.c
index 8dba8cf..ba39966 100644
--- a/arch/mips/bcm63xx/boards/board_bcm963xx.c
+++ b/arch/mips/bcm63xx/boards/board_bcm963xx.c
@@ -737,7 +737,7 @@ void __init board_prom_init(void)
 
 	/* find board by name */
 	for (i = 0; i < ARRAY_SIZE(bcm963xx_boards); i++) {
-		if (strncmp(nvram.name, bcm963xx_boards[i]->name,
+		if (memcmp(nvram.name, bcm963xx_boards[i]->name,
 			    sizeof(nvram.name)))
 			continue;
 		/* copy, board desc array is marked initdata */
diff --git a/arch/mips/cavium-octeon/executive/cvmx-bootmem.c b/arch/mips/cavium-octeon/executive/cvmx-bootmem.c
index fdf5f19..3b31aa1 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-bootmem.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-bootmem.c
@@ -547,7 +547,7 @@ struct cvmx_bootmem_named_block_desc *
 		for (i = 0;
 		     i < cvmx_bootmem_desc->named_block_num_blocks; i++) {
 			if ((name && named_block_array_ptr[i].size
-			     && !strncmp(name, named_block_array_ptr[i].name,
+			     && !memcmp(name, named_block_array_ptr[i].name,
 					 cvmx_bootmem_desc->named_block_name_len
 					 - 1))
 			    || (!name && !named_block_array_ptr[i].size)) {
diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index b0c3686..6daf0f9 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -586,8 +586,8 @@ void __init prom_init(void)
 	for (i = 0; i < argc; i++) {
 		const char *arg =
 			cvmx_phys_to_ptr(octeon_boot_desc_ptr->argv[i]);
-		if ((strncmp(arg, "MEM=", 4) == 0) ||
-		    (strncmp(arg, "mem=", 4) == 0)) {
+		if ((memcmp(arg, "MEM=", 4) == 0) ||
+		    (memcmp(arg, "mem=", 4) == 0)) {
 			sscanf(arg + 4, "%llu", &MAX_MEMORY);
 			MAX_MEMORY <<= 20;
 			if (MAX_MEMORY == 0)
diff --git a/arch/mips/fw/arc/cmdline.c b/arch/mips/fw/arc/cmdline.c
index 5c8603c..7932318 100644
--- a/arch/mips/fw/arc/cmdline.c
+++ b/arch/mips/fw/arc/cmdline.c
@@ -42,7 +42,7 @@ static char * __init move_firmware_args(char* cp)
 		for(i = 0; i < ARRAY_SIZE(used_arc); i++) {
 			int len = strlen(used_arc[i][0]);
 
-			if (!strncmp(prom_argv(actr), used_arc[i][0], len)) {
+			if (!memcmp(prom_argv(actr), used_arc[i][0], len)) {
 			/* Ok, we want it. First append the replacement... */
 				strcat(cp, used_arc[i][1]);
 				cp += strlen(used_arc[i][1]);
@@ -81,7 +81,7 @@ void __init prom_init_cmdline(void)
 		for (i = 0; i < ARRAY_SIZE(ignored); i++) {
 			int len = strlen(ignored[i]);
 
-			if (!strncmp(prom_argv(actr), ignored[i], len))
+			if (!memcmp(prom_argv(actr), ignored[i], len))
 				goto pic_cont;
 		}
 		/* Ok, we want it. */
diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index 3eb3cde..8752032 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -324,7 +324,7 @@ static void layout_sections(struct module *mod, const Elf_Ehdr * hdr,
 		for (i = 0; i < hdr->e_shnum; ++i) {
 			Elf_Shdr *s = &sechdrs[i];
 
-			//  || strncmp(secstrings + s->sh_name, ".init", 5) == 0)
+			//  || memcmp(secstrings + s->sh_name, ".init", 5) == 0)
 			if ((s->sh_flags & masks[m][0]) != masks[m][0]
 			    || (s->sh_flags & masks[m][1])
 			    || s->sh_entsize != ~0UL)
@@ -621,7 +621,7 @@ static void simplify_symbols(Elf_Shdr * sechdrs,
 
 	/* find the .bss section for COMMON symbols */
 	for (i = 0; i < nsecs; i++) {
-		if (strncmp(secstrings + sechdrs[i].sh_name, ".bss", 4) == 0) {
+		if (memcmp(secstrings + sechdrs[i].sh_name, ".bss", 4) == 0) {
 			bssbase = sechdrs[i].sh_addr;
 			break;
 		}
@@ -658,7 +658,7 @@ static void simplify_symbols(Elf_Shdr * sechdrs,
 		default:
 			secbase = sechdrs[sym[i].st_shndx].sh_addr;
 
-			if (strncmp(strtab + sym[i].st_name, "_gp", 3) == 0) {
+			if (memcmp(strtab + sym[i].st_name, "_gp", 3) == 0) {
 				save_gp_address(secbase, sym[i].st_value);
 			}
 
diff --git a/arch/mips/loongson/common/env.c b/arch/mips/loongson/common/env.c
index ae4cff9..7c04644 100644
--- a/arch/mips/loongson/common/env.c
+++ b/arch/mips/loongson/common/env.c
@@ -29,7 +29,7 @@ unsigned long memsize, highmemsize;
 
 #define parse_even_earlier(res, option, p)				\
 do {									\
-	if (strncmp(option, (char *)p, strlen(option)) == 0)		\
+	if (memcmp(option, (char *)p, strlen(option)) == 0)		\
 			strict_strtol((char *)p + strlen(option"="),	\
 					10, &res);			\
 } while (0)
diff --git a/arch/mips/mti-malta/malta-init.c b/arch/mips/mti-malta/malta-init.c
index 414f0c9..fb584df 100644
--- a/arch/mips/mti-malta/malta-init.c
+++ b/arch/mips/mti-malta/malta-init.c
@@ -75,7 +75,7 @@ char *prom_getenv(char *envname)
 	i = strlen(envname);
 
 	while (prom_envp(index)) {
-		if(strncmp(envname, prom_envp(index), i) == 0) {
+		if(memcmp(envname, prom_envp(index), i) == 0) {
 			return(prom_envp(index+1));
 		}
 		index += 2;
diff --git a/arch/mips/pci/ops-tx4927.c b/arch/mips/pci/ops-tx4927.c
index a1e7e6d..4ae514f 100644
--- a/arch/mips/pci/ops-tx4927.c
+++ b/arch/mips/pci/ops-tx4927.c
@@ -201,17 +201,17 @@ char *__devinit tx4927_pcibios_setup(char *str)
 {
 	unsigned long val;
 
-	if (!strncmp(str, "trdyto=", 7)) {
+	if (!memcmp(str, "trdyto=", 7)) {
 		if (strict_strtoul(str + 7, 0, &val) == 0)
 			tx4927_pci_opts.trdyto = val;
 		return NULL;
 	}
-	if (!strncmp(str, "retryto=", 8)) {
+	if (!memcmp(str, "retryto=", 8)) {
 		if (strict_strtoul(str + 8, 0, &val) == 0)
 			tx4927_pci_opts.retryto = val;
 		return NULL;
 	}
-	if (!strncmp(str, "gbwc=", 5)) {
+	if (!memcmp(str, "gbwc=", 5)) {
 		if (strict_strtoul(str + 5, 0, &val) == 0)
 			tx4927_pci_opts.gbwc = val;
 		return NULL;
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_prom.c b/arch/mips/pmc-sierra/msp71xx/msp_prom.c
index db00deb..cbab2cd 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_prom.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_prom.c
@@ -294,7 +294,7 @@ char *prom_getenv(char *env_name)
 	int i = strlen(env_name);
 
 	while (*var) {
-		if (strncmp(env_name, *var, i) == 0) {
+		if (memcmp(env_name, *var, i) == 0) {
 			return (*var + strlen(env_name) + 1);
 		}
 		var++;
diff --git a/arch/mips/pmc-sierra/yosemite/prom.c b/arch/mips/pmc-sierra/yosemite/prom.c
index cf4c868..89f2ad3 100644
--- a/arch/mips/pmc-sierra/yosemite/prom.c
+++ b/arch/mips/pmc-sierra/yosemite/prom.c
@@ -116,12 +116,12 @@ void __init prom_init(void)
 #endif
 
 	while (*env) {
-		if (strncmp("ocd_base", *env, strlen("ocd_base")) == 0)
+		if (memcmp("ocd_base", *env, strlen("ocd_base")) == 0)
 			yosemite_base =
 			    simple_strtol(*env + strlen("ocd_base="), NULL,
 					  16);
 
-		if (strncmp("cpuclock", *env, strlen("cpuclock")) == 0)
+		if (memcmp("cpuclock", *env, strlen("cpuclock")) == 0)
 			cpu_clock_freq =
 			    simple_strtol(*env + strlen("cpuclock="), NULL,
 					  10);
diff --git a/arch/mips/pnx833x/common/prom.c b/arch/mips/pnx833x/common/prom.c
index 29969f9..8d44643 100644
--- a/arch/mips/pnx833x/common/prom.c
+++ b/arch/mips/pnx833x/common/prom.c
@@ -51,7 +51,7 @@ char __init *prom_getenv(char *envname)
 	i = strlen(envname);
 
 	while (*env) {
-		if (strncmp(envname, *env, i) == 0 && *(*env+i) == '=')
+		if (memcmp(envname, *env, i) == 0 && *(*env+i) == '=')
 			return *env + i + 1;
 		env++;
 	}
diff --git a/arch/mips/pnx8550/common/prom.c b/arch/mips/pnx8550/common/prom.c
index 32f7009..22c6457 100644
--- a/arch/mips/pnx8550/common/prom.c
+++ b/arch/mips/pnx8550/common/prom.c
@@ -59,7 +59,7 @@ char *prom_getenv(char *envname)
 	i = strlen(envname);
 
 	while(env->name) {
-		if(strncmp(envname, env->name, i) == 0) {
+		if(memcmp(envname, env->name, i) == 0) {
 			return(env->name + strlen(envname) + 1);
 		}
 		env++;
diff --git a/arch/mips/powertv/init.c b/arch/mips/powertv/init.c
index 8355228..ace3279 100644
--- a/arch/mips/powertv/init.c
+++ b/arch/mips/powertv/init.c
@@ -59,7 +59,7 @@ char *prom_getenv(char *envname)
 		i = strlen(envname);
 
 		while (prom_envp(index)) {
-			if (strncmp(envname, prom_envp(index), i) == 0) {
+			if (memcmp(envname, prom_envp(index), i) == 0) {
 				result = prom_envp(index + 1);
 				break;
 			}
diff --git a/arch/mips/rb532/prom.c b/arch/mips/rb532/prom.c
index d7c26d0..2f40741 100644
--- a/arch/mips/rb532/prom.c
+++ b/arch/mips/rb532/prom.c
@@ -56,7 +56,7 @@ void __init prom_free_prom_memory(void)
 
 static inline int match_tag(char *arg, const char *tag)
 {
-	return strncmp(arg, tag, strlen(tag)) == 0;
+	return memcmp(arg, tag, strlen(tag)) == 0;
 }
 
 static inline unsigned long tag2ul(char *arg, const char *tag)
diff --git a/arch/mips/sibyte/common/cfe.c b/arch/mips/sibyte/common/cfe.c
index 6343011..5512d24 100644
--- a/arch/mips/sibyte/common/cfe.c
+++ b/arch/mips/sibyte/common/cfe.c
@@ -305,7 +305,7 @@ void __init prom_init(void)
 			while (*ptr == ' ') {
 				ptr++;
 			}
-			if (!strncmp(ptr, "initrd=", 7)) {
+			if (!memcmp(ptr, "initrd=", 7)) {
 				initrd_setup(ptr+7);
 				break;
 			} else {
diff --git a/arch/mips/sni/setup.c b/arch/mips/sni/setup.c
index d16b462..179060a 100644
--- a/arch/mips/sni/setup.c
+++ b/arch/mips/sni/setup.c
@@ -63,7 +63,7 @@ static void __init sni_console_setup(void)
 	static char options[8] __initdata;
 
 	cdev = prom_getenv("console_dev");
-	if (strncmp(cdev, "tty", 3) == 0) {
+	if (memcmp(cdev, "tty", 3) == 0) {
 		ctype = prom_getenv("console");
 		switch (*ctype) {
 		default:
@@ -78,7 +78,7 @@ static void __init sni_console_setup(void)
 		}
 		if (baud)
 			strcpy(options, baud);
-		if (strncmp(cdev, "tty552", 6) == 0)
+		if (memcmp(cdev, "tty552", 6) == 0)
 			add_preferred_console("ttyS", port,
 					      baud ? options : NULL);
 		else
diff --git a/arch/mips/txx9/generic/pci.c b/arch/mips/txx9/generic/pci.c
index 9a0be81..e632e2a 100644
--- a/arch/mips/txx9/generic/pci.c
+++ b/arch/mips/txx9/generic/pci.c
@@ -417,7 +417,7 @@ char *__devinit txx9_pcibios_setup(char *str)
 		   RBHBK4100,RBHBK4200, Interface PCM-PCM05, etc.) */
 		txx9_pci_option &= ~TXX9_PCI_OPT_PICMG;
 		return NULL;
-	} else if (!strncmp(str, "clk=", 4)) {
+	} else if (!memcmp(str, "clk=", 4)) {
 		char *val = str + 4;
 		txx9_pci_option &= ~TXX9_PCI_OPT_CLK_MASK;
 		if (strcmp(val, "33") == 0)
@@ -427,7 +427,7 @@ char *__devinit txx9_pcibios_setup(char *str)
 		else /* "auto" */
 			txx9_pci_option |= TXX9_PCI_OPT_CLK_AUTO;
 		return NULL;
-	} else if (!strncmp(str, "err=", 4)) {
+	} else if (!memcmp(str, "err=", 4)) {
 		if (!strcmp(str + 4, "panic"))
 			txx9_pci_err_action = TXX9_PCI_ERR_PANIC;
 		else if (!strcmp(str + 4, "ignore"))
diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index 812816c..6f485b1 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -304,10 +304,10 @@ static void __init preprocess_cmdline(void)
 	arcs_cmdline[0] = '\0';
 	while (s && *s) {
 		char *str = strsep(&s, " ");
-		if (strncmp(str, "board=", 6) == 0) {
+		if (memcmp(str, "board=", 6) == 0) {
 			txx9_board_vec = find_board_byname(str + 6);
 			continue;
-		} else if (strncmp(str, "masterclk=", 10) == 0) {
+		} else if (memcmp(str, "masterclk=", 10) == 0) {
 			unsigned long val;
 			if (strict_strtoul(str + 10, 10, &val) == 0)
 				txx9_master_clock = val;
diff --git a/arch/mn10300/unit-asb2305/pci.c b/arch/mn10300/unit-asb2305/pci.c
index a4954fe..42b8365 100644
--- a/arch/mn10300/unit-asb2305/pci.c
+++ b/arch/mn10300/unit-asb2305/pci.c
@@ -439,7 +439,7 @@ char *__init pcibios_setup(char *str)
 		pci_probe = 0;
 		return NULL;
 
-	} else if (!strncmp(str, "lastbus=", 8)) {
+	} else if (!memcmp(str, "lastbus=", 8)) {
 		pcibios_last_bus = simple_strtol(str+8, NULL, 0);
 		return NULL;
 	}
diff --git a/arch/parisc/kernel/firmware.c b/arch/parisc/kernel/firmware.c
index df971fa..01b2657 100644
--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -793,7 +793,7 @@ int pdc_get_initiator(struct hardware_path *hwpath, struct pdc_initiator *initia
 
 /* BCJ-XXXX series boxes. E.G. "9000/785/C3000" */
 #define IS_SPROCKETS() (strlen(boot_cpu_data.pdc.sys_model_name) == 14 && \
-	strncmp(boot_cpu_data.pdc.sys_model_name, "9000/785", 8) == 0)
+	memcmp(boot_cpu_data.pdc.sys_model_name, "9000/785", 8) == 0)
 
 	retval = mem_pdc_call(PDC_INITIATOR, PDC_GET_INITIATOR, 
 			      __pa(pdc_result), __pa(hwpath));
diff --git a/arch/parisc/kernel/module.c b/arch/parisc/kernel/module.c
index 6e81bb5..3b5bb16 100644
--- a/arch/parisc/kernel/module.c
+++ b/arch/parisc/kernel/module.c
@@ -331,7 +331,7 @@ int module_frob_arch_sections(CONST Elf_Ehdr *hdr,
 		unsigned long nrels = sechdrs[i].sh_size / sizeof(*rels);
 		unsigned int count, s;
 
-		if (strncmp(secstrings + sechdrs[i].sh_name,
+		if (memcmp(secstrings + sechdrs[i].sh_name,
 			    ".PARISC.unwind", 14) == 0)
 			me->arch.unwind_section = i;
 
@@ -783,7 +783,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 				}
 			} else {
 				val = sym->st_value;
-				if (strncmp(strtab + sym->st_name, "$$", 2)
+				if (memcmp(strtab + sym->st_name, "$$", 2)
 				    == 0)
 					val = get_stub(me, val, addend, ELF_STUB_MILLI,
 						       loc0, targetsec);
@@ -928,7 +928,7 @@ int module_finalize(const Elf_Ehdr *hdr,
 
 	for (i = 1; i < nsyms; i++) {
 		oldptr++;	/* note, count starts at 1 so preincrement */
-		if(strncmp(strtab + oldptr->st_name,
+		if(memcmp(strtab + oldptr->st_name,
 			      ".L", 2) == 0)
 			continue;
 
diff --git a/arch/powerpc/boot/planetcore.c b/arch/powerpc/boot/planetcore.c
index 0d8558a..4b68411 100644
--- a/arch/powerpc/boot/planetcore.c
+++ b/arch/powerpc/boot/planetcore.c
@@ -43,7 +43,7 @@ const char *planetcore_get_key(const char *table, const char *key)
 	int keylen = strlen(key);
 
 	do {
-		if (!strncmp(table, key, keylen) && table[keylen] == '=')
+		if (!memcmp(table, key, keylen) && table[keylen] == '=')
 			return table + keylen + 1;
 
 		table += strlen(table) + 1;
diff --git a/arch/powerpc/include/asm/string.h b/arch/powerpc/include/asm/string.h
index e40010a..8f5222a 100644
--- a/arch/powerpc/include/asm/string.h
+++ b/arch/powerpc/include/asm/string.h
@@ -19,7 +19,7 @@ extern char * strcpy(char *,const char *);
 extern char * strncpy(char *,const char *, __kernel_size_t);
 extern __kernel_size_t strlen(const char *);
 extern int strcmp(const char *,const char *);
-extern int strncmp(const char *, const char *, __kernel_size_t);
+extern int memcmp(const char *, const char *, __kernel_size_t);
 extern char * strcat(char *, const char *);
 extern void * memset(void *,int,__kernel_size_t);
 extern void * memcpy(void *,const void *,__kernel_size_t);
diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 941ff4d..bf0e1be 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -603,9 +603,9 @@ static void __init early_cmdline_parse(void)
 		opt += 6;
 		while (*opt && *opt == ' ')
 			opt++;
-		if (!strncmp(opt, RELOC("off"), 3))
+		if (!memcmp(opt, RELOC("off"), 3))
 			RELOC(prom_iommu_off) = 1;
-		else if (!strncmp(opt, RELOC("force"), 5))
+		else if (!memcmp(opt, RELOC("force"), 5))
 			RELOC(prom_iommu_force_on) = 1;
 	}
 #endif
@@ -1582,7 +1582,7 @@ static void __init prom_find_mmu(void)
 	/* XXX might need to add other versions here */
 	if (strcmp(version, "Open Firmware, 1.0.5") == 0)
 		of_workarounds = OF_WA_CLAIM;
-	else if (strncmp(version, "FirmWorks,3.", 12) == 0) {
+	else if (memcmp(version, "FirmWorks,3.", 12) == 0) {
 		of_workarounds = OF_WA_CLAIM | OF_WA_LONGTRAIL;
 		call_prom("interpret", 1, 1, "dev /memory 0 to allow-reclaim");
 	} else
diff --git a/arch/powerpc/kernel/rtas_flash.c b/arch/powerpc/kernel/rtas_flash.c
index 2b442e6..41eaa12 100644
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -436,9 +436,9 @@ static ssize_t manage_flash_write(struct file *file, const char __user *buf,
 		if (copy_from_user (stkbuf, buf, count)) {
 			return -EFAULT;
 		}
-		if (strncmp(stkbuf, reject_str, strlen(reject_str)) == 0) 
+		if (memcmp(stkbuf, reject_str, strlen(reject_str)) == 0) 
 			op = RTAS_REJECT_TMP_IMG;
-		else if (strncmp(stkbuf, commit_str, strlen(commit_str)) == 0) 
+		else if (memcmp(stkbuf, commit_str, strlen(commit_str)) == 0) 
 			op = RTAS_COMMIT_TMP_IMG;
 	}
 	
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index 1d2fbc9..29d7f3e 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -149,7 +149,7 @@ notrace void __init machine_init(unsigned long dt_ptr)
 /* Checks wdt=x and wdt_period=xx command-line option */
 notrace int __init early_parse_wdt(char *p)
 {
-	if (p && strncmp(p, "0", 1) != 0)
+	if (p && memcmp(p, "0", 1) != 0)
 	       booke_wdt_enabled = 1;
 
 	return 0;
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 441d2a7..a46fd06 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1089,7 +1089,7 @@ static const struct vio_device_id *vio_match_device(
 		const struct vio_device_id *ids, const struct vio_dev *dev)
 {
 	while (ids->type[0] != '\0') {
-		if ((strncmp(dev->type, ids->type, strlen(ids->type)) == 0) &&
+		if ((memcmp(dev->type, ids->type, strlen(ids->type)) == 0) &&
 		    of_device_is_compatible(dev->dev.of_node,
 					 ids->compat))
 			return ids;
diff --git a/arch/powerpc/kvm/44x.c b/arch/powerpc/kvm/44x.c
index 74d0e74..2b12a92 100644
--- a/arch/powerpc/kvm/44x.c
+++ b/arch/powerpc/kvm/44x.c
@@ -43,7 +43,7 @@ int kvmppc_core_check_processor_compat(void)
 {
 	int r;
 
-	if (strncmp(cur_cpu_spec->platform, "ppc440", 6) == 0)
+	if (memcmp(cur_cpu_spec->platform, "ppc440", 6) == 0)
 		r = 0;
 	else
 		r = -ENOTSUPP;
diff --git a/arch/powerpc/platforms/chrp/pci.c b/arch/powerpc/platforms/chrp/pci.c
index 8f67a39..f4fbb5f 100644
--- a/arch/powerpc/platforms/chrp/pci.c
+++ b/arch/powerpc/platforms/chrp/pci.c
@@ -222,11 +222,11 @@ chrp_find_bridges(void)
 	 */
 	machine = of_get_property(root, "model", NULL);
 	if (machine != NULL) {
-		is_longtrail = strncmp(machine, "IBM,LongTrail", 13) == 0;
-		is_mot = strncmp(machine, "MOT", 3) == 0;
-		if (strncmp(machine, "Pegasos2", 8) == 0)
+		is_longtrail = memcmp(machine, "IBM,LongTrail", 13) == 0;
+		is_mot = memcmp(machine, "MOT", 3) == 0;
+		if (memcmp(machine, "Pegasos2", 8) == 0)
 			is_pegasos = 2;
-		else if (strncmp(machine, "Pegasos", 7) == 0)
+		else if (memcmp(machine, "Pegasos", 7) == 0)
 			is_pegasos = 1;
 	}
 	for (dev = root->child; dev != NULL; dev = dev->sibling) {
@@ -267,10 +267,10 @@ chrp_find_bridges(void)
 		model = of_get_property(dev, "model", NULL);
 		if (model == NULL)
 			model = "<none>";
-		if (strncmp(model, "IBM, Python", 11) == 0) {
+		if (memcmp(model, "IBM, Python", 11) == 0) {
 			setup_python(hose, dev);
 		} else if (is_mot
-			   || strncmp(model, "Motorola, Grackle", 17) == 0) {
+			   || memcmp(model, "Motorola, Grackle", 17) == 0) {
 			setup_grackle(hose);
 		} else if (is_longtrail) {
 			void __iomem *p = ioremap(GG2_PCI_CONFIG_BASE, 0x80000);
@@ -281,7 +281,7 @@ chrp_find_bridges(void)
 			setup_indirect_pci(hose, 0xfec00cf8, 0xfee00cfc, 0);
 		} else if (is_pegasos == 2) {
 			setup_peg2(hose, dev);
-		} else if (!strncmp(model, "IBM,CPC710", 10)) {
+		} else if (!memcmp(model, "IBM,CPC710", 10)) {
 			setup_indirect_pci(hose,
 					   r.start + 0x000f8000,
 					   r.start + 0x000f8010,
diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
index 8553cc4..73a3bdb 100644
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -106,7 +106,7 @@ void chrp_show_cpuinfo(struct seq_file *m)
 	seq_printf(m, "machine\t\t: CHRP %s\n", model);
 
 	/* longtrail (goldengate) stuff */
-	if (model && !strncmp(model, "IBM,LongTrail", 13)) {
+	if (model && !memcmp(model, "IBM,LongTrail", 13)) {
 		/* VLSI VAS96011/12 `Golden Gate 2' */
 		/* Memory banks */
 		sdramen = (in_le32(gg2_pci_config_base + GG2_PCI_DRAM_CTRL)
@@ -201,7 +201,7 @@ static void __init sio_init(void)
 		return;
 
 	model = of_get_property(root, "model", NULL);
-	if (model && !strncmp(model, "IBM,LongTrail", 13)) {
+	if (model && !memcmp(model, "IBM,LongTrail", 13)) {
 		/* logical device 0 (KBC/Keyboard) */
 		sio_fixup_irq("keyboard", 0, 1, 2);
 		/* select logical device 1 (KBC/Mouse) */
@@ -308,13 +308,13 @@ void __init chrp_setup_arch(void)
 
 	if (root)
 		machine = of_get_property(root, "model", NULL);
-	if (machine && strncmp(machine, "Pegasos", 7) == 0) {
+	if (machine && memcmp(machine, "Pegasos", 7) == 0) {
 		_chrp_type = _CHRP_Pegasos;
-	} else if (machine && strncmp(machine, "IBM", 3) == 0) {
+	} else if (machine && memcmp(machine, "IBM", 3) == 0) {
 		_chrp_type = _CHRP_IBM;
-	} else if (machine && strncmp(machine, "MOT", 3) == 0) {
+	} else if (machine && memcmp(machine, "MOT", 3) == 0) {
 		_chrp_type = _CHRP_Motorola;
-	} else if (machine && strncmp(machine, "TotalImpact,BRIQ-1", 18) == 0) {
+	} else if (machine && memcmp(machine, "TotalImpact,BRIQ-1", 18) == 0) {
 		_chrp_type = _CHRP_briq;
 		/* Map the SPOR register on briq and change the restart hook */
 		briq_SPOR = ioremap(0xff0000e8, 4);
diff --git a/arch/powerpc/platforms/powermac/backlight.c b/arch/powerpc/platforms/powermac/backlight.c
index d679964..ee957ed 100644
--- a/arch/powerpc/platforms/powermac/backlight.c
+++ b/arch/powerpc/platforms/powermac/backlight.c
@@ -61,7 +61,7 @@ int pmac_has_backlight_type(const char *type)
 	if (bk_node) {
 		const char *prop = of_get_property(bk_node,
 				"backlight-control", NULL);
-		if (prop && strncmp(prop, type, strlen(type)) == 0) {
+		if (prop && memcmp(prop, type, strlen(type)) == 0) {
 			of_node_put(bk_node);
 			return 1;
 		}
diff --git a/arch/powerpc/platforms/powermac/feature.c b/arch/powerpc/platforms/powermac/feature.c
index df42399..9ad5d20 100644
--- a/arch/powerpc/platforms/powermac/feature.c
+++ b/arch/powerpc/platforms/powermac/feature.c
@@ -1104,11 +1104,11 @@ core99_usb_enable(struct device_node *node, long param, long value)
 	prop = of_get_property(node, "AAPL,clock-id", NULL);
 	if (!prop)
 		return -ENODEV;
-	if (strncmp(prop, "usb0u048", 8) == 0)
+	if (memcmp(prop, "usb0u048", 8) == 0)
 		number = 0;
-	else if (strncmp(prop, "usb1u148", 8) == 0)
+	else if (memcmp(prop, "usb1u148", 8) == 0)
 		number = 2;
-	else if (strncmp(prop, "usb2u248", 8) == 0)
+	else if (memcmp(prop, "usb2u248", 8) == 0)
 		number = 4;
 	else
 		return -ENODEV;
@@ -1465,7 +1465,7 @@ static long g5_i2s_enable(struct device_node *node, long param, long value)
 
 	if (macio->type != macio_keylargo2 && macio->type != macio_shasta)
 		return -ENODEV;
-	if (strncmp(node->name, "i2s-", 4))
+	if (memcmp(node->name, "i2s-", 4))
 		return -ENODEV;
 	cell = node->name[4] - 'a';
 	switch(cell) {
@@ -2550,8 +2550,8 @@ found:
 #endif  /* CONFIG_POWER4 */
 
 	/* Check for "mobile" machine */
-	if (model && (strncmp(model, "PowerBook", 9) == 0
-		   || strncmp(model, "iBook", 5) == 0))
+	if (model && (memcmp(model, "PowerBook", 9) == 0
+		   || memcmp(model, "iBook", 5) == 0))
 		pmac_mb.board_flags |= PMAC_MB_MOBILE;
 
 
diff --git a/arch/powerpc/platforms/powermac/pfunc_core.c b/arch/powerpc/platforms/powermac/pfunc_core.c
index b0c3777..2c626f9 100644
--- a/arch/powerpc/platforms/powermac/pfunc_core.c
+++ b/arch/powerpc/platforms/powermac/pfunc_core.c
@@ -687,7 +687,7 @@ static int pmf_add_functions(struct pmf_device *dev, void *driverdata)
 
 	for (pp = dev->node->properties; pp != 0; pp = pp->next) {
 		char *name;
-		if (strncmp(pp->name, PP_PREFIX, plen) != 0)
+		if (memcmp(pp->name, PP_PREFIX, plen) != 0)
 			continue;
 		name = pp->name + plen;
 		if (strlen(name) && pp->length >= 12)
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index f129040..c223797 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -220,7 +220,7 @@ void __init find_udbg_vterm(void)
 	}
 
 	/* Check if it's a virtual terminal */
-	if (strncmp(name, "vty", 3) != 0)
+	if (memcmp(name, "vty", 3) != 0)
 		goto out;
 	termno = of_get_property(stdout_node, "reg", NULL);
 	if (termno == NULL)
diff --git a/arch/powerpc/platforms/pseries/phyp_dump.c b/arch/powerpc/platforms/pseries/phyp_dump.c
index 6e7742d..8d0ec01 100644
--- a/arch/powerpc/platforms/pseries/phyp_dump.c
+++ b/arch/powerpc/platforms/pseries/phyp_dump.c
@@ -493,9 +493,9 @@ static int __init early_phyp_dump_enabled(char *p)
         if (!p)
                 return 0;
 
-        if (strncmp(p, "1", 1) == 0)
+        if (memcmp(p, "1", 1) == 0)
 		phyp_dump_info->phyp_dump_at_boot = 1;
-        else if (strncmp(p, "0", 1) == 0)
+        else if (memcmp(p, "0", 1) == 0)
 		phyp_dump_info->phyp_dump_at_boot = 0;
 
         return 0;
diff --git a/arch/powerpc/platforms/pseries/scanlog.c b/arch/powerpc/platforms/pseries/scanlog.c
index 5544572..eefb26f 100644
--- a/arch/powerpc/platforms/pseries/scanlog.c
+++ b/arch/powerpc/platforms/pseries/scanlog.c
@@ -128,7 +128,7 @@ static ssize_t scanlog_write(struct file * file, const char __user * buf,
 	stkbuf[count] = 0;
 
 	if (buf) {
-		if (strncmp(stkbuf, "reset", 5) == 0) {
+		if (memcmp(stkbuf, "reset", 5) == 0) {
 			pr_debug("scanlog: reset scanlog\n");
 			status = rtas_call(ibm_scan_log_dump, 2, 1, NULL, 0, 0);
 			pr_debug("scanlog: rtas returns %d\n", status);
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index d17d04c..ffd2017 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -2909,15 +2909,15 @@ static int __initdata xmon_early, xmon_off;
 
 static int __init early_parse_xmon(char *p)
 {
-	if (!p || strncmp(p, "early", 5) == 0) {
+	if (!p || memcmp(p, "early", 5) == 0) {
 		/* just "xmon" is equivalent to "xmon=early" */
 		xmon_init(1);
 		xmon_early = 1;
-	} else if (strncmp(p, "on", 2) == 0)
+	} else if (memcmp(p, "on", 2) == 0)
 		xmon_init(1);
-	else if (strncmp(p, "off", 3) == 0)
+	else if (memcmp(p, "off", 3) == 0)
 		xmon_off = 1;
-	else if (strncmp(p, "nobt", 4) == 0)
+	else if (memcmp(p, "nobt", 4) == 0)
 		xmon_no_auto_backtrace = 1;
 	else
 		return 1;
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index a689070..6240ae0 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1004,11 +1004,11 @@ static ssize_t reipl_type_store(struct kobject *kobj,
 {
 	int rc = -EINVAL;
 
-	if (strncmp(buf, IPL_CCW_STR, strlen(IPL_CCW_STR)) == 0)
+	if (memcmp(buf, IPL_CCW_STR, strlen(IPL_CCW_STR)) == 0)
 		rc = reipl_set_type(IPL_TYPE_CCW);
-	else if (strncmp(buf, IPL_FCP_STR, strlen(IPL_FCP_STR)) == 0)
+	else if (memcmp(buf, IPL_FCP_STR, strlen(IPL_FCP_STR)) == 0)
 		rc = reipl_set_type(IPL_TYPE_FCP);
-	else if (strncmp(buf, IPL_NSS_STR, strlen(IPL_NSS_STR)) == 0)
+	else if (memcmp(buf, IPL_NSS_STR, strlen(IPL_NSS_STR)) == 0)
 		rc = reipl_set_type(IPL_TYPE_NSS);
 	return (rc != 0) ? rc : len;
 }
@@ -1368,11 +1368,11 @@ static ssize_t dump_type_store(struct kobject *kobj,
 {
 	int rc = -EINVAL;
 
-	if (strncmp(buf, DUMP_NONE_STR, strlen(DUMP_NONE_STR)) == 0)
+	if (memcmp(buf, DUMP_NONE_STR, strlen(DUMP_NONE_STR)) == 0)
 		rc = dump_set_type(DUMP_TYPE_NONE);
-	else if (strncmp(buf, DUMP_CCW_STR, strlen(DUMP_CCW_STR)) == 0)
+	else if (memcmp(buf, DUMP_CCW_STR, strlen(DUMP_CCW_STR)) == 0)
 		rc = dump_set_type(DUMP_TYPE_CCW);
-	else if (strncmp(buf, DUMP_FCP_STR, strlen(DUMP_FCP_STR)) == 0)
+	else if (memcmp(buf, DUMP_FCP_STR, strlen(DUMP_FCP_STR)) == 0)
 		rc = dump_set_type(DUMP_TYPE_FCP);
 	return (rc != 0) ? rc : len;
 }
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 6f63508..06009a3 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -143,15 +143,15 @@ static void __init set_preferred_console(void)
 static int __init conmode_setup(char *str)
 {
 #if defined(CONFIG_SCLP_CONSOLE) || defined(CONFIG_SCLP_VT220_CONSOLE)
-	if (strncmp(str, "hwc", 4) == 0 || strncmp(str, "sclp", 5) == 0)
+	if (memcmp(str, "hwc", 4) == 0 || strncmp(str, "sclp", 5) == 0)
                 SET_CONSOLE_SCLP;
 #endif
 #if defined(CONFIG_TN3215_CONSOLE)
-	if (strncmp(str, "3215", 5) == 0)
+	if (memcmp(str, "3215", 5) == 0)
 		SET_CONSOLE_3215;
 #endif
 #if defined(CONFIG_TN3270_CONSOLE)
-	if (strncmp(str, "3270", 5) == 0)
+	if (memcmp(str, "3270", 5) == 0)
 		SET_CONSOLE_3270;
 #endif
 	set_preferred_console();
@@ -186,7 +186,7 @@ static void __init conmode_default(void)
 #endif
 			return;
 		}
-		if (strncmp(ptr + 8, "3270", 4) == 0) {
+		if (memcmp(ptr + 8, "3270", 4) == 0) {
 #if defined(CONFIG_TN3270_CONSOLE)
 			SET_CONSOLE_3270;
 #elif defined(CONFIG_TN3215_CONSOLE)
@@ -194,7 +194,7 @@ static void __init conmode_default(void)
 #elif defined(CONFIG_SCLP_CONSOLE) || defined(CONFIG_SCLP_VT220_CONSOLE)
 			SET_CONSOLE_SCLP;
 #endif
-		} else if (strncmp(ptr + 8, "3215", 4) == 0) {
+		} else if (memcmp(ptr + 8, "3215", 4) == 0) {
 #if defined(CONFIG_TN3215_CONSOLE)
 			SET_CONSOLE_3215;
 #elif defined(CONFIG_TN3270_CONSOLE)
@@ -343,7 +343,7 @@ early_param("user_mode", early_parse_user_mode);
  */
 static int __init early_parse_noexec(char *p)
 {
-	if (!strncmp(p, "off", 3))
+	if (!memcmp(p, "off", 3))
 		return 0;
 	user_mode = SECONDARY_SPACE_MODE;
 	return 0;
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index f754a6d..aa7bdf6 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -403,13 +403,13 @@ static int etr_steai_available;
 
 static int __init early_parse_etr(char *p)
 {
-	if (strncmp(p, "off", 3) == 0)
+	if (memcmp(p, "off", 3) == 0)
 		etr_port0_online = etr_port1_online = 0;
-	else if (strncmp(p, "port0", 5) == 0)
+	else if (memcmp(p, "port0", 5) == 0)
 		etr_port0_online = 1;
-	else if (strncmp(p, "port1", 5) == 0)
+	else if (memcmp(p, "port1", 5) == 0)
 		etr_port1_online = 1;
-	else if (strncmp(p, "on", 2) == 0)
+	else if (memcmp(p, "on", 2) == 0)
 		etr_port0_online = etr_port1_online = 1;
 	return 0;
 }
@@ -1411,9 +1411,9 @@ static struct timer_list stp_timer;
 
 static int __init early_parse_stp(char *p)
 {
-	if (strncmp(p, "off", 3) == 0)
+	if (memcmp(p, "off", 3) == 0)
 		stp_online = 0;
-	else if (strncmp(p, "on", 2) == 0)
+	else if (memcmp(p, "on", 2) == 0)
 		stp_online = 1;
 	return 0;
 }
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index 94b06c3..12f8c0d 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -276,7 +276,7 @@ static void set_topology_timer(void)
 
 static int __init early_parse_topology(char *p)
 {
-	if (strncmp(p, "off", 3))
+	if (memcmp(p, "off", 3))
 		return 0;
 	topology_enabled = 0;
 	return 0;
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index e3150dd..06167cb 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -58,9 +58,9 @@ static int __init vdso_setup(char *s)
 	int rc;
 
 	rc = 0;
-	if (strncmp(s, "on", 3) == 0)
+	if (memcmp(s, "on", 3) == 0)
 		vdso_enabled = 1;
-	else if (strncmp(s, "off", 4) == 0)
+	else if (memcmp(s, "off", 4) == 0)
 		vdso_enabled = 0;
 	else {
 		rc = strict_strtoul(s, 0, &val);
diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index c66ffd8..7f86e87 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -368,21 +368,21 @@ static void cmm_smsg_target(const char *from, char *msg)
 		return;
 	if (!cmm_skip_blanks(msg + strlen(SMSG_PREFIX), &msg))
 		return;
-	if (strncmp(msg, "SHRINK", 6) == 0) {
+	if (memcmp(msg, "SHRINK", 6) == 0) {
 		if (!cmm_skip_blanks(msg + 6, &msg))
 			return;
 		nr = simple_strtoul(msg, &msg, 0);
 		cmm_skip_blanks(msg, &msg);
 		if (*msg == '\0')
 			cmm_set_pages(nr);
-	} else if (strncmp(msg, "RELEASE", 7) == 0) {
+	} else if (memcmp(msg, "RELEASE", 7) == 0) {
 		if (!cmm_skip_blanks(msg + 7, &msg))
 			return;
 		nr = simple_strtoul(msg, &msg, 0);
 		cmm_skip_blanks(msg, &msg);
 		if (*msg == '\0')
 			cmm_add_timed_pages(nr);
-	} else if (strncmp(msg, "REUSE", 5) == 0) {
+	} else if (memcmp(msg, "REUSE", 5) == 0) {
 		if (!cmm_skip_blanks(msg + 5, &msg))
 			return;
 		nr = simple_strtoul(msg, &msg, 0);
diff --git a/arch/sh/drivers/pci/pci-dreamcast.c b/arch/sh/drivers/pci/pci-dreamcast.c
index 6336941..bdce2ee 100644
--- a/arch/sh/drivers/pci/pci-dreamcast.c
+++ b/arch/sh/drivers/pci/pci-dreamcast.c
@@ -66,7 +66,7 @@ static int __init gapspci_init(void)
 	for (i=0; i<16; i++)
 		idbuf[i] = inb(GAPSPCI_REGS+i);
 
-	if (strncmp(idbuf, "GAPSPCI_BRIDGE_2", 16))
+	if (memcmp(idbuf, "GAPSPCI_BRIDGE_2", 16))
 		return -ENODEV;
 
 	outl(0x5a14a501, GAPSPCI_REGS+0x18);
diff --git a/arch/sh/kernel/sh_bios.c b/arch/sh/kernel/sh_bios.c
index 47475cc..c497082 100644
--- a/arch/sh/kernel/sh_bios.c
+++ b/arch/sh/kernel/sh_bios.c
@@ -156,7 +156,7 @@ static int __init setup_early_printk(char *buf)
 	if (strstr(buf, "keep"))
 		keep_early = 1;
 
-	if (!strncmp(buf, "bios", 4))
+	if (!memcmp(buf, "bios", 4))
 		early_console = &bios_console;
 
 	if (likely(early_console)) {
diff --git a/arch/sh/mm/consistent.c b/arch/sh/mm/consistent.c
index 40733a9..d32b8b3 100644
--- a/arch/sh/mm/consistent.c
+++ b/arch/sh/mm/consistent.c
@@ -113,7 +113,7 @@ static void __init memchunk_cmdline_override(char *name, unsigned long *sizep)
 
 	while ((p = strstr(p, "memchunk."))) {
 		p += 9; /* strlen("memchunk.") */
-		if (!strncmp(name, p, k) && p[k] == '=') {
+		if (!memcmp(name, p, k) && p[k] == '=') {
 			p += k + 1;
 			*sizep = memparse(p, NULL);
 			pr_info("%s: forcing memory chunk size to 0x%08lx\n",
diff --git a/arch/sparc/boot/btfixupprep.c b/arch/sparc/boot/btfixupprep.c
index da03115..cb23077 100644
--- a/arch/sparc/boot/btfixupprep.c
+++ b/arch/sparc/boot/btfixupprep.c
@@ -112,13 +112,13 @@ int main(int argc,char **argv)
 
 	symlen = strlen(symtab);
 	while (fgets (buffer, 1024, stdin) != NULL)
-		if (!strncmp (buffer, symtab, symlen))
+		if (!memcmp (buffer, symtab, symlen))
 			goto main0;
 	fatal();
 main0:
 	rellen = strlen(relrec);
 	while (fgets (buffer, 1024, stdin) != NULL)
-		if (!strncmp (buffer, relrec, rellen))
+		if (!memcmp (buffer, relrec, rellen))
 			goto main1;
 	fatal();
 main1:
@@ -132,7 +132,7 @@ main1:
 		fatal();
 	while (fgets (buffer, 1024, stdin) != NULL) {
 		int nbase;
-		if (!strncmp (buffer, relrec, rellen))
+		if (!memcmp (buffer, relrec, rellen))
 			goto main1;
 		if (mode == 0)
 			set_mode (buffer);
@@ -140,7 +140,7 @@ main1:
 		if (p) *p = 0;
 		if (strlen (buffer) < 22+mode)
 			continue;
-		if (strncmp (buffer + mode, " R_SPARC_", 9))
+		if (memcmp (buffer + mode, " R_SPARC_", 9))
 			continue;
 		nbase = 27 - 8 + mode;
 		if (buffer[nbase] != '_' || buffer[nbase+1] != '_' || buffer[nbase+2] != '_')
@@ -220,13 +220,13 @@ main1:
 				exit(1);
 			}
 			if (!strcmp (sect, "__ksymtab")) {
-				if (strncmp (buffer + mode+9, "32        ", 10)) {
+				if (memcmp (buffer + mode+9, "32        ", 10)) {
 					fprintf(stderr, "BTFIXUP_CALL in EXPORT_SYMBOL results in relocation other than R_SPARC_32\n\%s\n", buffer);
 					exit(1);
 				}
-			} else if (strncmp (buffer + mode+9, "WDISP30   ", 10) &&
-				   strncmp (buffer + mode+9, "HI22      ", 10) &&
-				   strncmp (buffer + mode+9, "LO10      ", 10)) {
+			} else if (memcmp (buffer + mode+9, "WDISP30   ", 10) &&
+				   memcmp (buffer + mode+9, "HI22      ", 10) &&
+				   memcmp (buffer + mode+9, "LO10      ", 10)) {
 				fprintf(stderr, "BTFIXUP_CALL results in relocation other than R_SPARC_WDISP30, R_SPARC_HI22 or R_SPARC_LO10\n%s\n", buffer);
 				exit(1);
 			}
@@ -236,7 +236,7 @@ main1:
 				fprintf(stderr, "Cannot use pre-initialized fixups for blackboxes\n%s\n", buffer);
 				exit(1);
 			}
-			if (strncmp (buffer + mode+9, "HI22      ", 10)) {
+			if (memcmp (buffer + mode+9, "HI22      ", 10)) {
 				fprintf(stderr, "BTFIXUP_BLACKBOX results in relocation other than R_SPARC_HI22\n%s\n", buffer);
 				exit(1);
 			}
@@ -246,7 +246,7 @@ main1:
 				fprintf(stderr, "Wrong initializer for SIMM13. Has to be from $fffff000 to $00000fff\n%s\n", buffer);
 				exit(1);
 			}
-			if (strncmp (buffer + mode+9, "13        ", 10)) {
+			if (memcmp (buffer + mode+9, "13        ", 10)) {
 				fprintf(stderr, "BTFIXUP_SIMM13 results in relocation other than R_SPARC_13\n%s\n", buffer);
 				exit(1);
 			}
@@ -256,7 +256,7 @@ main1:
 				fprintf(stderr, "Wrong initializer for HALF.\n%s\n", buffer);
 				exit(1);
 			}
-			if (strncmp (buffer + mode+9, "13        ", 10)) {
+			if (memcmp (buffer + mode+9, "13        ", 10)) {
 				fprintf(stderr, "BTFIXUP_HALF results in relocation other than R_SPARC_13\n%s\n", buffer);
 				exit(1);
 			}
@@ -266,7 +266,7 @@ main1:
 				fprintf(stderr, "Wrong initializer for SETHI. Cannot have set low 10 bits\n%s\n", buffer);
 				exit(1);
 			}
-			if (strncmp (buffer + mode+9, "HI22      ", 10)) {
+			if (memcmp (buffer + mode+9, "HI22      ", 10)) {
 				fprintf(stderr, "BTFIXUP_SETHI results in relocation other than R_SPARC_HI22\n%s\n", buffer);
 				exit(1);
 			}
@@ -276,7 +276,7 @@ main1:
 				fprintf(stderr, "Cannot use pre-initialized fixups for INT\n%s\n", buffer);
 				exit(1);
 			}
-			if (strncmp (buffer + mode+9, "HI22      ", 10) && strncmp (buffer + mode+9, "LO10      ", 10)) {
+			if (memcmp (buffer + mode+9, "HI22      ", 10) && strncmp (buffer + mode+9, "LO10      ", 10)) {
 				fprintf(stderr, "BTFIXUP_INT results in relocation other than R_SPARC_HI22 and R_SPARC_LO10\n%s\n", buffer);
 				exit(1);
 			}
@@ -300,7 +300,7 @@ main1:
 			exit(1);
 		}
 		offset = strtoul(buffer, &q, 16);
-		if (q != buffer + mode || (!offset && (mode == 8 ? strncmp (buffer, "00000000 ", 9) : strncmp (buffer, "0000000000000000 ", 17)))) {
+		if (q != buffer + mode || (!offset && (mode == 8 ? memcmp (buffer, "00000000 ", 9) : strncmp (buffer, "0000000000000000 ", 17)))) {
 			fprintf(stderr, "Malformed relocation address in\n%s\n", buffer);
 			exit(1);
 		}
diff --git a/arch/sparc/include/asm/floppy_64.h b/arch/sparc/include/asm/floppy_64.h
index 6597ce8..901e468 100644
--- a/arch/sparc/include/asm/floppy_64.h
+++ b/arch/sparc/include/asm/floppy_64.h
@@ -590,7 +590,7 @@ static unsigned long __init sun_floppy_init(void)
 			return 0;
 
 		state_prop = of_get_property(op->dev.of_node, "status", NULL);
-		if (state_prop && !strncmp(state_prop, "disabled", 8))
+		if (state_prop && !memcmp(state_prop, "disabled", 8))
 			return 0;
 
 		FLOPPY_IRQ = op->archdata.irqs[0];
@@ -717,7 +717,7 @@ static unsigned long __init sun_floppy_init(void)
 		return sun_floppy_types[0];
 	}
 	prop = of_get_property(op->dev.of_node, "status", NULL);
-	if (prop && !strncmp(state, "disabled", 8))
+	if (prop && !memcmp(state, "disabled", 8))
 		return 0;
 
 	/*
diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
index 56bbaad..6dc987d 100644
--- a/arch/sparc/include/asm/prom.h
+++ b/arch/sparc/include/asm/prom.h
@@ -26,7 +26,7 @@
 #define OF_ROOT_NODE_ADDR_CELLS_DEFAULT	2
 #define OF_ROOT_NODE_SIZE_CELLS_DEFAULT	1
 
-#define of_compat_cmp(s1, s2, l)	strncmp((s1), (s2), (l))
+#define of_compat_cmp(s1, s2, l)	memcmp((s1), (s2), (l))
 #define of_prop_cmp(s1, s2)		strcasecmp((s1), (s2))
 #define of_node_cmp(s1, s2)		strcmp((s1), (s2))
 
diff --git a/arch/sparc/kernel/apc.c b/arch/sparc/kernel/apc.c
index 52de4a9..f9878bf 100644
--- a/arch/sparc/kernel/apc.c
+++ b/arch/sparc/kernel/apc.c
@@ -43,7 +43,7 @@ static int apc_no_idle __devinitdata = 0;
  */
 static int __init apc_setup(char *str) 
 {
-	if(!strncmp(str, "noidle", strlen("noidle"))) {
+	if(!memcmp(str, "noidle", strlen("noidle"))) {
 		apc_no_idle = 1;
 		return 1;
 	}
diff --git a/arch/sparc/kernel/nmi.c b/arch/sparc/kernel/nmi.c
index a4bd7ba..d58d083 100644
--- a/arch/sparc/kernel/nmi.c
+++ b/arch/sparc/kernel/nmi.c
@@ -278,7 +278,7 @@ int __init nmi_init(void)
 
 static int __init setup_nmi_watchdog(char *str)
 {
-	if (!strncmp(str, "panic", 5))
+	if (!memcmp(str, "panic", 5))
 		panic_on_timeout = 1;
 
 	return 0;
diff --git a/arch/sparc/kernel/setup_32.c b/arch/sparc/kernel/setup_32.c
index b22ce61..9a237e4 100644
--- a/arch/sparc/kernel/setup_32.c
+++ b/arch/sparc/kernel/setup_32.c
@@ -158,7 +158,7 @@ static void __init boot_flags_init(char *commands)
 				process_switch(*commands++);
 			continue;
 		}
-		if (!strncmp(commands, "mem=", 4)) {
+		if (!memcmp(commands, "mem=", 4)) {
 			/*
 			 * "mem=XXX[kKmM] overrides the PROM-reported
 			 * memory size.
@@ -233,7 +233,7 @@ void __init setup_arch(char **cmdline_p)
 		sparc_cpu_model = sun4e;
 	if (!strcmp(&cputypval,"sun4u"))
 		sparc_cpu_model = sun4u;
-	if (!strncmp(&cputypval, "leon" , 4))
+	if (!memcmp(&cputypval, "leon" , 4))
 		sparc_cpu_model = sparc_leon;
 
 	printk("ARCH: ");
diff --git a/arch/sparc/kernel/setup_64.c b/arch/sparc/kernel/setup_64.c
index 29bafe0..cdd1874 100644
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -138,7 +138,7 @@ static void __init boot_flags_init(char *commands)
 				process_switch(*commands++);
 			continue;
 		}
-		if (!strncmp(commands, "mem=", 4)) {
+		if (!memcmp(commands, "mem=", 4)) {
 			/*
 			 * "mem=XXX[kKmM]" overrides the PROM-reported
 			 * memory size.
diff --git a/arch/sparc/kernel/tadpole.c b/arch/sparc/kernel/tadpole.c
index 9aba8bd..a1fc7f1 100644
--- a/arch/sparc/kernel/tadpole.c
+++ b/arch/sparc/kernel/tadpole.c
@@ -104,7 +104,7 @@ void __init clock_stop_probe(void)
 	char name[20];
     
 	prom_getstring(prom_root_node, "name", name, sizeof(name));
-	if (strncmp(name, "Tadpole", 7))
+	if (memcmp(name, "Tadpole", 7))
 		return;
 	node = prom_getchild(prom_root_node);
 	node = prom_searchsiblings(node, "obio");
diff --git a/arch/tile/kernel/early_printk.c b/arch/tile/kernel/early_printk.c
index 493a0e6..0bbd74e 100644
--- a/arch/tile/kernel/early_printk.c
+++ b/arch/tile/kernel/early_printk.c
@@ -71,7 +71,7 @@ static int __init setup_early_printk(char *str)
 	if (early_console_initialized)
 		return 1;
 
-	if (str != NULL && strncmp(str, "keep", 4) == 0)
+	if (str != NULL && memcmp(str, "keep", 4) == 0)
 		keep_early = 1;
 
 	early_console = &early_hv_console;
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 0b9ce69..e15514f 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -363,7 +363,7 @@ static int __init setup_ktext(char *str)
 		return -EINVAL;
 
 	/* If you have a leading "nocache", turn off ktext caching */
-	if (strncmp(str, "nocache", 7) == 0) {
+	if (memcmp(str, "nocache", 7) == 0) {
 		ktext_nocache = 1;
 		pr_info("ktext: disabling local caching of kernel text\n");
 		str += 7;
diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index 25e1965..d031c26 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -502,7 +502,7 @@ static struct chan *parse_chan(struct line *line, char *str, int device,
 	data = NULL;
 	for(i = 0; i < ARRAY_SIZE(chan_table); i++) {
 		entry = &chan_table[i];
-		if (!strncmp(str, entry->key, strlen(entry->key))) {
+		if (!memcmp(str, entry->key, strlen(entry->key))) {
 			ops = entry->ops;
 			str += strlen(entry->key);
 			break;
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 975613b..922c880 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -338,7 +338,7 @@ static struct mc_device *mconsole_find_dev(char *name)
 
 	list_for_each(ele, &mconsole_devices) {
 		dev = list_entry(ele, struct mc_device, list);
-		if (!strncmp(name, dev->name, strlen(dev->name)))
+		if (!memcmp(name, dev->name, strlen(dev->name)))
 			return dev;
 	}
 	return NULL;
@@ -880,7 +880,7 @@ __initcall(create_proc_mconsole);
 
 static int mconsole_setup(char *str)
 {
-	if (!strncmp(str, NOTIFY, strlen(NOTIFY))) {
+	if (!memcmp(str, NOTIFY, strlen(NOTIFY))) {
 		str += strlen(NOTIFY);
 		notify_socket = str;
 	}
diff --git a/arch/um/drivers/mconsole_user.c b/arch/um/drivers/mconsole_user.c
index f8cf4c8..b0f6f10 100644
--- a/arch/um/drivers/mconsole_user.c
+++ b/arch/um/drivers/mconsole_user.c
@@ -65,7 +65,7 @@ static struct mconsole_command *mconsole_parse(struct mc_request *req)
 
 	for (i = 0; i < ARRAY_SIZE(commands); i++) {
 		cmd = &commands[i];
-		if (!strncmp(req->request.data, cmd->command,
+		if (!memcmp(req->request.data, cmd->command,
 			    strlen(cmd->command))) {
 			return cmd;
 		}
diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 47d0c37..1a050a9 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -560,7 +560,7 @@ static int check_transport(struct transport *transport, char *eth, int n,
 	int len;
 
 	len = strlen(transport->name);
-	if (strncmp(eth, transport->name, len))
+	if (memcmp(eth, transport->name, len))
 		return 0;
 
 	eth += len;
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 8d84250..62d1baa 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -205,7 +205,7 @@ static void __init uml_checksetup(char *line, int *add)
 		size_t n;
 
 		n = strlen(p->str);
-		if (!strncmp(line, p->str, n) && p->setup_func(line + n, add))
+		if (!memcmp(line, p->str, n) && p->setup_func(line + n, add))
 			return;
 		p++;
 	}
diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
index e696144..7f3096c 100644
--- a/arch/um/os-Linux/mem.c
+++ b/arch/um/os-Linux/mem.c
@@ -129,7 +129,7 @@ static void which_tmpdir(void)
 		if (found != 1)
 			break;
 
-		if (!strncmp(buf, "/dev/shm", strlen("/dev/shm")))
+		if (!memcmp(buf, "/dev/shm", strlen("/dev/shm")))
 			goto found;
 
 		found = next(fd, buf, ARRAY_SIZE(buf), '\n');
@@ -153,7 +153,7 @@ found:
 	if (found != 1)
 		goto err;
 
-	if (strncmp(buf, "tmpfs", strlen("tmpfs"))) {
+	if (memcmp(buf, "tmpfs", strlen("tmpfs"))) {
 		printf("not tmpfs\n");
 		goto out;
 	}
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 5852519..8c2358b 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -502,7 +502,7 @@ long sys32_vm86_warning(void)
 	struct task_struct *me = current;
 	static char lastcomm[sizeof(me->comm)];
 
-	if (strncmp(lastcomm, me->comm, sizeof(lastcomm))) {
+	if (memcmp(lastcomm, me->comm, sizeof(lastcomm))) {
 		compat_printk(KERN_INFO
 			      "%s: vm86 mode not supported on 64 bit kernel\n",
 			      me->comm);
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 69fd72a..75dc003 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -153,24 +153,24 @@ void __init acpi_reserve_wakeup_memory(void)
 static int __init acpi_sleep_setup(char *str)
 {
 	while ((str != NULL) && (*str != '\0')) {
-		if (strncmp(str, "s3_bios", 7) == 0)
+		if (memcmp(str, "s3_bios", 7) == 0)
 			acpi_realmode_flags |= 1;
-		if (strncmp(str, "s3_mode", 7) == 0)
+		if (memcmp(str, "s3_mode", 7) == 0)
 			acpi_realmode_flags |= 2;
-		if (strncmp(str, "s3_beep", 7) == 0)
+		if (memcmp(str, "s3_beep", 7) == 0)
 			acpi_realmode_flags |= 4;
 #ifdef CONFIG_HIBERNATION
-		if (strncmp(str, "s4_nohwsig", 10) == 0)
+		if (memcmp(str, "s4_nohwsig", 10) == 0)
 			acpi_no_s4_hw_signature();
-		if (strncmp(str, "s4_nonvs", 8) == 0) {
+		if (memcmp(str, "s4_nonvs", 8) == 0) {
 			pr_warning("ACPI: acpi_sleep=s4_nonvs is deprecated, "
 					"please use acpi_sleep=nonvs instead");
 			acpi_nvs_nosave();
 		}
 #endif
-		if (strncmp(str, "nonvs", 5) == 0)
+		if (memcmp(str, "nonvs", 5) == 0)
 			acpi_nvs_nosave();
-		if (strncmp(str, "old_ordering", 12) == 0)
+		if (memcmp(str, "old_ordering", 12) == 0)
 			acpi_old_suspend_ordering();
 		str = strchr(str, ',');
 		if (str != NULL)
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 6e11c81..0989dba 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1536,9 +1536,9 @@ static int __init parse_amd_iommu_dump(char *str)
 static int __init parse_amd_iommu_options(char *str)
 {
 	for (; *str; ++str) {
-		if (strncmp(str, "fullflush", 9) == 0)
+		if (memcmp(str, "fullflush", 9) == 0)
 			amd_iommu_unmap_flush = true;
-		if (strncmp(str, "off", 3) == 0)
+		if (memcmp(str, "off", 3) == 0)
 			amd_iommu_disabled = true;
 	}
 
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index b3a16e8..3fb2c87 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -259,9 +259,9 @@ static int __init parse_gart_mem(char *p)
 	if (!p)
 		return -EINVAL;
 
-	if (!strncmp(p, "off", 3))
+	if (!memcmp(p, "off", 3))
 		gart_fix_e820 = 0;
-	else if (!strncmp(p, "on", 2))
+	else if (!memcmp(p, "on", 2))
 		gart_fix_e820 = 1;
 
 	return 0;
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 09d3b17..182badb 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -241,7 +241,7 @@ static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 		return 1;
 	}
 
-	if (!strncmp(oem_id, "IBM", 3) && !strncmp(oem_table_id, "EXA", 3)) {
+	if (!memcmp(oem_id, "IBM", 3) && !strncmp(oem_table_id, "EXA", 3)) {
 		printk(KERN_DEBUG "IBM Summit detected, will use apic physical");
 		return 1;
 	}
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 8593582..ed83451 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -282,7 +282,7 @@ static int es7000_check_dsdt(void)
 	struct acpi_table_header header;
 
 	if (ACPI_SUCCESS(acpi_get_table_header(ACPI_SIG_DSDT, 0, &header)) &&
-	    !strncmp(header.oem_id, "UNISYS", 6))
+	    !memcmp(header.oem_id, "UNISYS", 6))
 		return 1;
 	return 0;
 }
@@ -614,7 +614,7 @@ static int es7000_mps_oem_check(struct mpc_table *mpc, char *oem,
 		struct mpc_oemtable *oem_table =
 			(struct mpc_oemtable *)mpc->oemptr;
 
-		if (!strncmp(oem, "UNISYS", 6))
+		if (!memcmp(oem, "UNISYS", 6))
 			ret = parse_unisys_oem((char *)oem_table);
 	}
 
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index c90041c..e972632 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -192,7 +192,7 @@ static int __init setup_nmi_watchdog(char *str)
 {
 	unsigned int nmi;
 
-	if (!strncmp(str, "panic", 5)) {
+	if (!memcmp(str, "panic", 5)) {
 		panic_on_timeout = 1;
 		str = strchr(str, ',');
 		if (!str)
@@ -200,9 +200,9 @@ static int __init setup_nmi_watchdog(char *str)
 		++str;
 	}
 
-	if (!strncmp(str, "lapic", 5))
+	if (!memcmp(str, "lapic", 5))
 		nmi_watchdog = NMI_LOCAL_APIC;
-	else if (!strncmp(str, "ioapic", 6))
+	else if (!memcmp(str, "ioapic", 6))
 		nmi_watchdog = NMI_IO_APIC;
 	else {
 		get_option(&str, &nmi);
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 960f26a..ff98d23 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -439,7 +439,7 @@ static inline int numaq_phys_pkg_id(int cpuid_apic, int index_msb)
 static int
 numaq_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
-	if (strncmp(oem, "IBM NUMA", 8))
+	if (memcmp(oem, "IBM NUMA", 8))
 		printk(KERN_ERR "Warning! Not a NUMA-Q system!\n");
 	else
 		found_numaq = 1;
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 9b41926..c761142 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -80,10 +80,10 @@ static inline void setup_summit(void) {}
 static int summit_mps_oem_check(struct mpc_table *mpc, char *oem,
 		char *productid)
 {
-	if (!strncmp(oem, "IBM ENSW", 8) &&
-			(!strncmp(productid, "VIGIL SMP", 9)
-			 || !strncmp(productid, "EXA", 3)
-			 || !strncmp(productid, "RUTHLESS SMP", 12))){
+	if (!memcmp(oem, "IBM ENSW", 8) &&
+			(!memcmp(productid, "VIGIL SMP", 9)
+			 || !memcmp(productid, "EXA", 3)
+			 || !memcmp(productid, "RUTHLESS SMP", 12))){
 		mark_tsc_unstable("Summit based system");
 		use_cyclone = 1; /*enable cyclone-timer*/
 		setup_summit();
@@ -95,9 +95,9 @@ static int summit_mps_oem_check(struct mpc_table *mpc, char *oem,
 /* Hook from generic ACPI tables.c */
 static int summit_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	if (!strncmp(oem_id, "IBM", 3) &&
-	    (!strncmp(oem_table_id, "SERVIGIL", 8)
-	     || !strncmp(oem_table_id, "EXA", 3))){
+	if (!memcmp(oem_id, "IBM", 3) &&
+	    (!memcmp(oem_table_id, "SERVIGIL", 8)
+	     || !memcmp(oem_table_id, "EXA", 3))){
 		mark_tsc_unstable("Summit based system");
 		use_cyclone = 1; /*enable cyclone-timer*/
 		setup_summit();
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 0e4f24c..a783133 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -1874,40 +1874,40 @@ static int __init apm_setup(char *str)
 	int invert;
 
 	while ((str != NULL) && (*str != '\0')) {
-		if (strncmp(str, "off", 3) == 0)
+		if (memcmp(str, "off", 3) == 0)
 			apm_disabled = 1;
-		if (strncmp(str, "on", 2) == 0)
+		if (memcmp(str, "on", 2) == 0)
 			apm_disabled = 0;
-		if ((strncmp(str, "bounce-interval=", 16) == 0) ||
-		    (strncmp(str, "bounce_interval=", 16) == 0))
+		if ((memcmp(str, "bounce-interval=", 16) == 0) ||
+		    (memcmp(str, "bounce_interval=", 16) == 0))
 			bounce_interval = simple_strtol(str + 16, NULL, 0);
-		if ((strncmp(str, "idle-threshold=", 15) == 0) ||
-		    (strncmp(str, "idle_threshold=", 15) == 0))
+		if ((memcmp(str, "idle-threshold=", 15) == 0) ||
+		    (memcmp(str, "idle_threshold=", 15) == 0))
 			idle_threshold = simple_strtol(str + 15, NULL, 0);
-		if ((strncmp(str, "idle-period=", 12) == 0) ||
-		    (strncmp(str, "idle_period=", 12) == 0))
+		if ((memcmp(str, "idle-period=", 12) == 0) ||
+		    (memcmp(str, "idle_period=", 12) == 0))
 			idle_period = simple_strtol(str + 12, NULL, 0);
-		invert = (strncmp(str, "no-", 3) == 0) ||
-			(strncmp(str, "no_", 3) == 0);
+		invert = (memcmp(str, "no-", 3) == 0) ||
+			(memcmp(str, "no_", 3) == 0);
 		if (invert)
 			str += 3;
-		if (strncmp(str, "debug", 5) == 0)
+		if (memcmp(str, "debug", 5) == 0)
 			debug = !invert;
-		if ((strncmp(str, "power-off", 9) == 0) ||
-		    (strncmp(str, "power_off", 9) == 0))
+		if ((memcmp(str, "power-off", 9) == 0) ||
+		    (memcmp(str, "power_off", 9) == 0))
 			power_off = !invert;
-		if (strncmp(str, "smp", 3) == 0) {
+		if (memcmp(str, "smp", 3) == 0) {
 			smp = !invert;
 			idle_threshold = 100;
 		}
-		if ((strncmp(str, "allow-ints", 10) == 0) ||
-		    (strncmp(str, "allow_ints", 10) == 0))
+		if ((memcmp(str, "allow-ints", 10) == 0) ||
+		    (memcmp(str, "allow_ints", 10) == 0))
 			apm_info.allow_ints = !invert;
-		if ((strncmp(str, "broken-psr", 10) == 0) ||
-		    (strncmp(str, "broken_psr", 10) == 0))
+		if ((memcmp(str, "broken-psr", 10) == 0) ||
+		    (memcmp(str, "broken_psr", 10) == 0))
 			apm_info.get_power_status_broken = !invert;
-		if ((strncmp(str, "realmode-power-off", 18) == 0) ||
-		    (strncmp(str, "realmode_power_off", 18) == 0))
+		if ((memcmp(str, "realmode-power-off", 18) == 0) ||
+		    (memcmp(str, "realmode_power_off", 18) == 0))
 			apm_info.realmode_power_off = !invert;
 		str = strchr(str, ',');
 		if (str != NULL)
diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index 7928963..4373ccb 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -123,7 +123,7 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 	if (linelen && *ptr == '\n')
 		*ptr = '\0';
 
-	if (!strncmp(line, "disable=", 8)) {
+	if (!memcmp(line, "disable=", 8)) {
 		reg = simple_strtoul(line + 8, &ptr, 0);
 		err = mtrr_del_page(reg, 0, 0);
 		if (err < 0)
@@ -131,13 +131,13 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 		return len;
 	}
 
-	if (strncmp(line, "base=", 5))
+	if (memcmp(line, "base=", 5))
 		return -EINVAL;
 
 	base = simple_strtoull(line + 5, &ptr, 0);
 	ptr = skip_spaces(ptr);
 
-	if (strncmp(ptr, "size=", 5))
+	if (memcmp(ptr, "size=", 5))
 		return -EINVAL;
 
 	size = simple_strtoull(ptr + 5, &ptr, 0);
@@ -145,7 +145,7 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 		return -EINVAL;
 	ptr = skip_spaces(ptr);
 
-	if (strncmp(ptr, "type=", 5))
+	if (memcmp(ptr, "type=", 5))
 		return -EINVAL;
 	ptr = skip_spaces(ptr + 5);
 
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 0c2b7ef..5f0ce9d 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -869,7 +869,7 @@ static int __init parse_memmap_opt(char *p)
 	if (!p)
 		return -EINVAL;
 
-	if (!strncmp(p, "exactmap", 8)) {
+	if (!memcmp(p, "exactmap", 8)) {
 #ifdef CONFIG_CRASH_DUMP
 		/*
 		 * If we are doing a crash dump, we still need to know
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 4572f25..b321a13 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -126,12 +126,12 @@ static __init void early_serial_init(char *s)
 
 	if (*s) {
 		unsigned port;
-		if (!strncmp(s, "0x", 2)) {
+		if (!memcmp(s, "0x", 2)) {
 			early_serial_base = simple_strtoul(s, &e, 16);
 		} else {
 			static const int __initconst bases[] = { 0x3f8, 0x2f8 };
 
-			if (!strncmp(s, "ttyS", 4))
+			if (!memcmp(s, "ttyS", 4))
 				s += 4;
 			port = simple_strtoul(s, &e, 10);
 			if (port > 1 || s == e)
@@ -214,18 +214,18 @@ static int __init setup_early_printk(char *buf)
 	keep = (strstr(buf, "keep") != NULL);
 
 	while (*buf != '\0') {
-		if (!strncmp(buf, "serial", 6)) {
+		if (!memcmp(buf, "serial", 6)) {
 			buf += 6;
 			early_serial_init(buf);
 			early_console_register(&early_serial_console, keep);
-			if (!strncmp(buf, ",ttyS", 5))
+			if (!memcmp(buf, ",ttyS", 5))
 				buf += 5;
 		}
-		if (!strncmp(buf, "ttyS", 4)) {
+		if (!memcmp(buf, "ttyS", 4)) {
 			early_serial_init(buf + 4);
 			early_console_register(&early_serial_console, keep);
 		}
-		if (!strncmp(buf, "vga", 3) &&
+		if (!memcmp(buf, "vga", 3) &&
 		    boot_params.screen_info.orig_video_isVGA == 1) {
 			max_xpos = boot_params.screen_info.orig_video_cols;
 			max_ypos = boot_params.screen_info.orig_video_lines;
@@ -233,20 +233,20 @@ static int __init setup_early_printk(char *buf)
 			early_console_register(&early_vga_console, keep);
 		}
 #ifdef CONFIG_EARLY_PRINTK_DBGP
-		if (!strncmp(buf, "dbgp", 4) && !early_dbgp_init(buf + 4))
+		if (!memcmp(buf, "dbgp", 4) && !early_dbgp_init(buf + 4))
 			early_console_register(&early_dbgp_console, keep);
 #endif
 #ifdef CONFIG_HVC_XEN
-		if (!strncmp(buf, "xen", 3))
+		if (!memcmp(buf, "xen", 3))
 			early_console_register(&xenboot_console, keep);
 #endif
 #ifdef CONFIG_X86_MRST_EARLY_PRINTK
-		if (!strncmp(buf, "mrst", 4)) {
+		if (!memcmp(buf, "mrst", 4)) {
 			mrst_early_console_init();
 			early_console_register(&early_mrst_console, keep);
 		}
 
-		if (!strncmp(buf, "hsu", 3)) {
+		if (!memcmp(buf, "hsu", 3)) {
 			hsu_early_console_init();
 			early_console_register(&early_hsu_console, keep);
 		}
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ae03cab..98df834 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -88,11 +88,11 @@ static int hpet_verbose;
 static int __init hpet_setup(char *str)
 {
 	if (str) {
-		if (!strncmp("disable", str, 7))
+		if (!memcmp("disable", str, 7))
 			boot_hpet_disable = 1;
-		if (!strncmp("force", str, 5))
+		if (!memcmp("force", str, 5))
 			hpet_force_user = 1;
-		if (!strncmp("verbose", str, 7))
+		if (!memcmp("verbose", str, 7))
 			hpet_verbose = 1;
 	}
 	return 1;
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 9af64d9..df7208a 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -95,21 +95,21 @@ static void __init MP_bus_info(struct mpc_bus *m)
 	}
 #endif
 
-	if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
+	if (memcmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
 		set_bit(m->busid, mp_bus_not_pci);
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 		mp_bus_id_to_type[m->busid] = MP_BUS_ISA;
 #endif
-	} else if (strncmp(str, BUSTYPE_PCI, sizeof(BUSTYPE_PCI) - 1) == 0) {
+	} else if (memcmp(str, BUSTYPE_PCI, sizeof(BUSTYPE_PCI) - 1) == 0) {
 		if (x86_init.mpparse.mpc_oem_pci_bus)
 			x86_init.mpparse.mpc_oem_pci_bus(m);
 
 		clear_bit(m->busid, mp_bus_not_pci);
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 		mp_bus_id_to_type[m->busid] = MP_BUS_PCI;
-	} else if (strncmp(str, BUSTYPE_EISA, sizeof(BUSTYPE_EISA) - 1) == 0) {
+	} else if (memcmp(str, BUSTYPE_EISA, sizeof(BUSTYPE_EISA) - 1) == 0) {
 		mp_bus_id_to_type[m->busid] = MP_BUS_EISA;
-	} else if (strncmp(str, BUSTYPE_MCA, sizeof(BUSTYPE_MCA) - 1) == 0) {
+	} else if (memcmp(str, BUSTYPE_MCA, sizeof(BUSTYPE_MCA) - 1) == 0) {
 		mp_bus_id_to_type[m->busid] = MP_BUS_MCA;
 #endif
 	} else
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index f56a117..46a9d9e 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1484,29 +1484,29 @@ static int __init calgary_parse_options(char *p)
 	char* endp;
 
 	while (*p) {
-		if (!strncmp(p, "64k", 3))
+		if (!memcmp(p, "64k", 3))
 			specified_table_size = TCE_TABLE_SIZE_64K;
-		else if (!strncmp(p, "128k", 4))
+		else if (!memcmp(p, "128k", 4))
 			specified_table_size = TCE_TABLE_SIZE_128K;
-		else if (!strncmp(p, "256k", 4))
+		else if (!memcmp(p, "256k", 4))
 			specified_table_size = TCE_TABLE_SIZE_256K;
-		else if (!strncmp(p, "512k", 4))
+		else if (!memcmp(p, "512k", 4))
 			specified_table_size = TCE_TABLE_SIZE_512K;
-		else if (!strncmp(p, "1M", 2))
+		else if (!memcmp(p, "1M", 2))
 			specified_table_size = TCE_TABLE_SIZE_1M;
-		else if (!strncmp(p, "2M", 2))
+		else if (!memcmp(p, "2M", 2))
 			specified_table_size = TCE_TABLE_SIZE_2M;
-		else if (!strncmp(p, "4M", 2))
+		else if (!memcmp(p, "4M", 2))
 			specified_table_size = TCE_TABLE_SIZE_4M;
-		else if (!strncmp(p, "8M", 2))
+		else if (!memcmp(p, "8M", 2))
 			specified_table_size = TCE_TABLE_SIZE_8M;
 
 		len = strlen("translate_empty_slots");
-		if (!strncmp(p, "translate_empty_slots", len))
+		if (!memcmp(p, "translate_empty_slots", len))
 			translate_empty_slots = 1;
 
 		len = strlen("disable");
-		if (!strncmp(p, "disable", len)) {
+		if (!memcmp(p, "disable", len)) {
 			p += len;
 			if (*p == '=')
 				++p;
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 9ea999a..a5b07e1 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -192,51 +192,51 @@ static __init int iommu_setup(char *p)
 		return -EINVAL;
 
 	while (*p) {
-		if (!strncmp(p, "off", 3))
+		if (!memcmp(p, "off", 3))
 			no_iommu = 1;
 		/* gart_parse_options has more force support */
-		if (!strncmp(p, "force", 5))
+		if (!memcmp(p, "force", 5))
 			force_iommu = 1;
-		if (!strncmp(p, "noforce", 7)) {
+		if (!memcmp(p, "noforce", 7)) {
 			iommu_merge = 0;
 			force_iommu = 0;
 		}
 
-		if (!strncmp(p, "biomerge", 8)) {
+		if (!memcmp(p, "biomerge", 8)) {
 			iommu_merge = 1;
 			force_iommu = 1;
 		}
-		if (!strncmp(p, "panic", 5))
+		if (!memcmp(p, "panic", 5))
 			panic_on_overflow = 1;
-		if (!strncmp(p, "nopanic", 7))
+		if (!memcmp(p, "nopanic", 7))
 			panic_on_overflow = 0;
-		if (!strncmp(p, "merge", 5)) {
+		if (!memcmp(p, "merge", 5)) {
 			iommu_merge = 1;
 			force_iommu = 1;
 		}
-		if (!strncmp(p, "nomerge", 7))
+		if (!memcmp(p, "nomerge", 7))
 			iommu_merge = 0;
-		if (!strncmp(p, "forcesac", 8))
+		if (!memcmp(p, "forcesac", 8))
 			iommu_sac_force = 1;
-		if (!strncmp(p, "allowdac", 8))
+		if (!memcmp(p, "allowdac", 8))
 			forbid_dac = 0;
-		if (!strncmp(p, "nodac", 5))
+		if (!memcmp(p, "nodac", 5))
 			forbid_dac = 1;
-		if (!strncmp(p, "usedac", 6)) {
+		if (!memcmp(p, "usedac", 6)) {
 			forbid_dac = -1;
 			return 1;
 		}
 #ifdef CONFIG_SWIOTLB
-		if (!strncmp(p, "soft", 4))
+		if (!memcmp(p, "soft", 4))
 			swiotlb = 1;
 #endif
-		if (!strncmp(p, "pt", 2))
+		if (!memcmp(p, "pt", 2))
 			iommu_pass_through = 1;
 
 		gart_parse_options(p);
 
 #ifdef CONFIG_CALGARY_IOMMU
-		if (!strncmp(p, "calgary", 7))
+		if (!memcmp(p, "calgary", 7))
 			use_calgary = 1;
 #endif /* CONFIG_CALGARY_IOMMU */
 
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index ba0f0ca..def8ce1 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -872,7 +872,7 @@ void __init gart_parse_options(char *p)
 	int arg;
 
 #ifdef CONFIG_IOMMU_LEAK
-	if (!strncmp(p, "leak", 4)) {
+	if (!memcmp(p, "leak", 4)) {
 		leak_trace = 1;
 		p += 4;
 		if (*p == '=')
@@ -883,20 +883,20 @@ void __init gart_parse_options(char *p)
 #endif
 	if (isdigit(*p) && get_option(&p, &arg))
 		iommu_size = arg;
-	if (!strncmp(p, "fullflush", 9))
+	if (!memcmp(p, "fullflush", 9))
 		iommu_fullflush = 1;
-	if (!strncmp(p, "nofullflush", 11))
+	if (!memcmp(p, "nofullflush", 11))
 		iommu_fullflush = 0;
-	if (!strncmp(p, "noagp", 5))
+	if (!memcmp(p, "noagp", 5))
 		no_agp = 1;
-	if (!strncmp(p, "noaperture", 10))
+	if (!memcmp(p, "noaperture", 10))
 		fix_aperture = 0;
 	/* duplicated from pci-dma.c */
-	if (!strncmp(p, "force", 5))
+	if (!memcmp(p, "force", 5))
 		gart_iommu_aperture_allowed = 1;
-	if (!strncmp(p, "allowed", 7))
+	if (!memcmp(p, "allowed", 7))
 		gart_iommu_aperture_allowed = 1;
-	if (!strncmp(p, "memaper", 7)) {
+	if (!memcmp(p, "memaper", 7)) {
 		fallback_aper_force = 1;
 		p += 7;
 		if (*p == '=') {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 21c6746..b30bba3 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -755,7 +755,7 @@ void __init setup_arch(char **cmdline_p)
 	rd_doload = ((boot_params.hdr.ram_size & RAMDISK_LOAD_FLAG) != 0);
 #endif
 #ifdef CONFIG_EFI
-	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
+	if (!memcmp((char *)&boot_params.efi_info.efi_loader_signature,
 #ifdef CONFIG_X86_32
 		     "EL32",
 #else
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 0c40d8b..663f314 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -110,7 +110,7 @@ static int __init tsc_setup(char *str)
 {
 	if (!strcmp(str, "reliable"))
 		tsc_clocksource_reliable = 1;
-	if (!strncmp(str, "noirqtime", 9))
+	if (!memcmp(str, "noirqtime", 9))
 		no_sched_irq_time = 1;
 	return 1;
 }
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 7ffc9b7..baf1ee2 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -665,14 +665,14 @@ static __init int numa_setup(char *opt)
 {
 	if (!opt)
 		return -EINVAL;
-	if (!strncmp(opt, "off", 3))
+	if (!memcmp(opt, "off", 3))
 		numa_off = 1;
 #ifdef CONFIG_NUMA_EMU
-	if (!strncmp(opt, "fake=", 5))
+	if (!memcmp(opt, "fake=", 5))
 		cmdline = opt + 5;
 #endif
 #ifdef CONFIG_ACPI_NUMA
-	if (!strncmp(opt, "noacpi", 6))
+	if (!memcmp(opt, "noacpi", 6))
 		acpi_numa = -1;
 #endif
 	return 0;
diff --git a/arch/x86/mm/setup_nx.c b/arch/x86/mm/setup_nx.c
index a3250aa..174d099 100644
--- a/arch/x86/mm/setup_nx.c
+++ b/arch/x86/mm/setup_nx.c
@@ -19,9 +19,9 @@ static int __init noexec_setup(char *str)
 {
 	if (!str)
 		return -EINVAL;
-	if (!strncmp(str, "on", 2)) {
+	if (!memcmp(str, "on", 2)) {
 		disable_nx = 0;
-	} else if (!strncmp(str, "off", 3)) {
+	} else if (!memcmp(str, "off", 3)) {
 		disable_nx = 1;
 	}
 	x86_configure_nx();
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index f7c8a39..5b8c1eb 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -478,7 +478,7 @@ char * __devinit  pcibios_setup(char *str)
 	} else if (!strcmp(str, "biosirq")) {
 		pci_probe |= PCI_BIOS_IRQ_SCAN;
 		return NULL;
-	} else if (!strncmp(str, "pirqaddr=", 9)) {
+	} else if (!memcmp(str, "pirqaddr=", 9)) {
 		pirq_table_addr = simple_strtoul(str+9, NULL, 0);
 		return NULL;
 	}
@@ -515,10 +515,10 @@ char * __devinit  pcibios_setup(char *str)
 	else if (!strcmp(str, "usepirqmask")) {
 		pci_probe |= PCI_USE_PIRQ_MASK;
 		return NULL;
-	} else if (!strncmp(str, "irqmask=", 8)) {
+	} else if (!memcmp(str, "irqmask=", 8)) {
 		pcibios_irq_mask = simple_strtol(str+8, NULL, 0);
 		return NULL;
-	} else if (!strncmp(str, "lastbus=", 8)) {
+	} else if (!memcmp(str, "lastbus=", 8)) {
 		pcibios_last_bus = simple_strtol(str+8, NULL, 0);
 		return NULL;
 	}
diff --git a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
index edaf3fe..d4c648e 100644
--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -198,7 +198,7 @@ static bool __init check_ofw_architecture(void)
 		printk(KERN_ERR "ofw: getprop call failed!\n");
 		return false;
 	}
-	return propsize == 5 && strncmp("OLPC", olpc_arch, 5) == 0;
+	return propsize == 5 && memcmp("OLPC", olpc_arch, 5) == 0;
 }
 
 static u32 __init get_board_revision(void)
diff --git a/arch/x86/platform/uv/bios_uv.c b/arch/x86/platform/uv/bios_uv.c
index 8bc57ba..128d2da 100644
--- a/arch/x86/platform/uv/bios_uv.c
+++ b/arch/x86/platform/uv/bios_uv.c
@@ -197,7 +197,7 @@ void uv_bios_init(void)
 
 	tab = (struct uv_systab *)ioremap(efi.uv_systab,
 					sizeof(struct uv_systab));
-	if (strncmp(tab->signature, "UVST", 4) != 0)
+	if (memcmp(tab->signature, "UVST", 4) != 0)
 		printk(KERN_ERR "bad signature in UV system table!");
 
 	/*
diff --git a/arch/x86/xen/platform-pci-unplug.c b/arch/x86/xen/platform-pci-unplug.c
index 0f45638..08c9804 100644
--- a/arch/x86/xen/platform-pci-unplug.c
+++ b/arch/x86/xen/platform-pci-unplug.c
@@ -121,17 +121,17 @@ static int __init parse_xen_emul_unplug(char *arg)
 		} else {
 			l = strlen(p);
 		}
-		if (!strncmp(p, "all", l))
+		if (!memcmp(p, "all", l))
 			xen_emul_unplug |= XEN_UNPLUG_ALL;
-		else if (!strncmp(p, "ide-disks", l))
+		else if (!memcmp(p, "ide-disks", l))
 			xen_emul_unplug |= XEN_UNPLUG_ALL_IDE_DISKS;
-		else if (!strncmp(p, "aux-ide-disks", l))
+		else if (!memcmp(p, "aux-ide-disks", l))
 			xen_emul_unplug |= XEN_UNPLUG_AUX_IDE_DISKS;
-		else if (!strncmp(p, "nics", l))
+		else if (!memcmp(p, "nics", l))
 			xen_emul_unplug |= XEN_UNPLUG_ALL_NICS;
-		else if (!strncmp(p, "unnecessary", l))
+		else if (!memcmp(p, "unnecessary", l))
 			xen_emul_unplug |= XEN_UNPLUG_UNNECESSARY;
-		else if (!strncmp(p, "never", l))
+		else if (!memcmp(p, "never", l))
 			xen_emul_unplug |= XEN_UNPLUG_NEVER;
 		else
 			printk(KERN_WARNING "unrecognised option '%s' "
diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/iss/network.c
index f717e20..ae4fb29 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -313,7 +313,7 @@ static int tuntap_probe(struct iss_net_private *lp, int index, char *init)
 
 	/* Transport should be 'tuntap': ethX=tuntap,mac,dev_name */
 
-	if (strncmp(init, TRANSPORT_TUNTAP_NAME, len))
+	if (memcmp(init, TRANSPORT_TUNTAP_NAME, len))
 		return 0;
 
 	if (*(init += strlen(TRANSPORT_TUNTAP_NAME)) == ',') {
diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index af308d0..e4354c7 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -121,12 +121,12 @@ int __init acpi_blacklisted(void)
 			continue;
 		}
 
-		if (strncmp(acpi_blacklist[i].oem_id, table_header.oem_id, 6)) {
+		if (memcmp(acpi_blacklist[i].oem_id, table_header.oem_id, 6)) {
 			i++;
 			continue;
 		}
 
-		if (strncmp
+		if (memcmp
 		    (acpi_blacklist[i].oem_table_id, table_header.oem_table_id,
 		     8)) {
 			i++;
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 966fedd..4c817ac 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -481,7 +481,7 @@ acpi_os_table_override(struct acpi_table_header * existing_table,
 	*new_table = NULL;
 
 #ifdef CONFIG_ACPI_CUSTOM_DSDT
-	if (strncmp(existing_table->signature, "DSDT", 4) == 0)
+	if (memcmp(existing_table->signature, "DSDT", 4) == 0)
 		*new_table = (struct acpi_table_header *)AmlCode;
 #endif
 	if (*new_table != NULL) {
diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
index afad677..28c2197 100644
--- a/drivers/acpi/proc.c
+++ b/drivers/acpi/proc.c
@@ -360,7 +360,7 @@ acpi_system_write_wakeup_device(struct file *file,
 		if (!dev->wakeup.flags.valid)
 			continue;
 
-		if (!strncmp(dev->pnp.bus_id, str, 4)) {
+		if (!memcmp(dev->pnp.bus_id, str, 4)) {
 			dev->wakeup.state.enabled =
 			    dev->wakeup.state.enabled ? 0 : 1;
 			found_dev = dev;
diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index f8588f8..c58ff2a 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -173,7 +173,7 @@ static int param_set_trace_state(const char *val, struct kernel_param *kp)
 {
 	int result = 0;
 
-	if (!strncmp(val, "enable", strlen("enable") - 1)) {
+	if (!memcmp(val, "enable", strlen("enable") - 1)) {
 		result = acpi_debug_trace(trace_method_name, trace_debug_level,
 					  trace_debug_layer, 0);
 		if (result)
@@ -181,7 +181,7 @@ static int param_set_trace_state(const char *val, struct kernel_param *kp)
 		goto exit;
 	}
 
-	if (!strncmp(val, "disable", strlen("disable") - 1)) {
+	if (!memcmp(val, "disable", strlen("disable") - 1)) {
 		int name = 0;
 		result = acpi_debug_trace((char *)&name, trace_debug_level,
 					  trace_debug_layer, 0);
@@ -190,7 +190,7 @@ static int param_set_trace_state(const char *val, struct kernel_param *kp)
 		goto exit;
 	}
 
-	if (!strncmp(val, "1", 1)) {
+	if (!memcmp(val, "1", 1)) {
 		result = acpi_debug_trace(trace_method_name, trace_debug_level,
 					  trace_debug_layer, 1);
 		if (result)
@@ -259,7 +259,7 @@ static ssize_t acpi_table_show(struct file *filp, struct kobject *kobj,
 	acpi_status status;
 	char name[ACPI_NAME_SIZE];
 
-	if (strncmp(table_attr->name, "NULL", 4))
+	if (memcmp(table_attr->name, "NULL", 4))
 		memcpy(name, table_attr->name, ACPI_NAME_SIZE);
 	else
 		memcpy(name, "\0\0\0\0", 4);
diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index f336bca..387d86f 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -219,7 +219,7 @@ acpi_table_parse_entries(char *id,
 	if (!handler)
 		return -EINVAL;
 
-	if (strncmp(id, ACPI_SIG_MADT, 4) == 0)
+	if (memcmp(id, ACPI_SIG_MADT, 4) == 0)
 		acpi_get_table_with_size(id, acpi_apic_instance, &table_header, &tbl_size);
 	else
 		acpi_get_table_with_size(id, 0, &table_header, &tbl_size);
@@ -286,7 +286,7 @@ int __init acpi_table_parse(char *id, acpi_table_handler handler)
 	if (!handler)
 		return -EINVAL;
 
-	if (strncmp(id, ACPI_SIG_MADT, 4) == 0)
+	if (memcmp(id, ACPI_SIG_MADT, 4) == 0)
 		acpi_get_table_with_size(id, acpi_apic_instance, &table, &tbl_size);
 	else
 		acpi_get_table_with_size(id, 0, &table, &tbl_size);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 66aa4be..65a438b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -124,7 +124,7 @@ static ssize_t ata_scsi_lpm_store(struct device *dev,
 	     policy < ARRAY_SIZE(ata_lpm_policy_names); policy++) {
 		const char *name = ata_lpm_policy_names[policy];
 
-		if (strncmp(name, buf, strlen(name)) == 0)
+		if (memcmp(name, buf, strlen(name)) == 0)
 			break;
 	}
 	if (policy == ARRAY_SIZE(ata_lpm_policy_names))
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index 75b49d0..4d8643e 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -483,12 +483,12 @@ static int pata_macio_cable_detect(struct ata_port *ap)
 		struct device_node *root = of_find_node_by_path("/");
 		const char *model = of_get_property(root, "model", NULL);
 
-		if (cable && !strncmp(cable, "80-", 3)) {
+		if (cable && !memcmp(cable, "80-", 3)) {
 			/* Some drives fail to detect 80c cable in PowerBook
 			 * These machine use proprietary short IDE cable
 			 * anyway
 			 */
-			if (!strncmp(model, "PowerBook", 9))
+			if (!memcmp(model, "PowerBook", 9))
 				return ATA_CBL_PATA40_SHORT;
 			else
 				return ATA_CBL_PATA80;
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 7254e25..9d3d8ca 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1956,7 +1956,7 @@ static int nv_swncq_slave_config(struct scsi_device *sdev)
 
 	ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
 
-	if (strncmp(model_num, "Maxtor", 6) == 0) {
+	if (memcmp(model_num, "Maxtor", 6) == 0) {
 		ata_scsi_change_queue_depth(sdev, 1, SCSI_QDEPTH_DEFAULT);
 		ata_dev_printk(dev, KERN_NOTICE,
 			"Disabling SWNCQ mode (depth %x)\n", sdev->queue_depth);
diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index 2e08c99..b435838 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -292,9 +292,9 @@ static ssize_t solos_param_store(struct device *dev, struct device_attribute *at
 	if (skb->data[buflen - 1] == '\n')
 		buflen--;
 
-	if (buflen == 2 && !strncmp(skb->data, "OK", 2))
+	if (buflen == 2 && !memcmp(skb->data, "OK", 2))
 		ret = count;
-	else if (buflen == 5 && !strncmp(skb->data, "ERROR", 5))
+	else if (buflen == 5 && !memcmp(skb->data, "ERROR", 5))
 		ret = -EIO;
 	else {
 		/* We know we have enough space allocated for this; we allocated 
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index cafeaaf..1d4b772 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -271,9 +271,9 @@ store_mem_state(struct sys_device *dev,
 	if (!present_section_nr(phys_section_nr))
 		goto out;
 
-	if (!strncmp(buf, "online", min((int)count, 6)))
+	if (!memcmp(buf, "online", min((int)count, 6)))
 		ret = memory_block_change_state(mem, MEM_ONLINE, MEM_OFFLINE);
-	else if(!strncmp(buf, "offline", min((int)count, 7)))
+	else if(!memcmp(buf, "offline", min((int)count, 7)))
 		ret = memory_block_change_state(mem, MEM_OFFLINE, MEM_ONLINE);
 out:
 	if (ret)
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index f051cff..851cbcb 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1077,7 +1077,7 @@ int __init early_platform_driver_register(struct early_platform_driver *epdrv,
 	 * command line will be put first on the list.
 	 */
 	n = strlen(epdrv->pdrv->driver.name);
-	if (buf && !strncmp(buf, epdrv->pdrv->driver.name, n)) {
+	if (buf && !memcmp(buf, epdrv->pdrv->driver.name, n)) {
 		list_move(&epdrv->list, &early_platform_driver_list);
 
 		/* Allow passing parameters after device name */
diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
index 0b1e46b..53a3982 100644
--- a/drivers/base/power/sysfs.c
+++ b/drivers/base/power/sysfs.c
@@ -116,9 +116,9 @@ static ssize_t control_store(struct device * dev, struct device_attribute *attr,
 	cp = memchr(buf, '\n', n);
 	if (cp)
 		len = cp - buf;
-	if (len == sizeof ctrl_auto - 1 && strncmp(buf, ctrl_auto, len) == 0)
+	if (len == sizeof ctrl_auto - 1 && memcmp(buf, ctrl_auto, len) == 0)
 		pm_runtime_allow(dev);
-	else if (len == sizeof ctrl_on - 1 && strncmp(buf, ctrl_on, len) == 0)
+	else if (len == sizeof ctrl_on - 1 && memcmp(buf, ctrl_on, len) == 0)
 		pm_runtime_forbid(dev);
 	else
 		return -EINVAL;
@@ -236,10 +236,10 @@ wake_store(struct device * dev, struct device_attribute *attr,
 	if (cp)
 		len = cp - buf;
 	if (len == sizeof enabled - 1
-			&& strncmp(buf, enabled, sizeof enabled - 1) == 0)
+			&& memcmp(buf, enabled, sizeof enabled - 1) == 0)
 		device_set_wakeup_enable(dev, 1);
 	else if (len == sizeof disabled - 1
-			&& strncmp(buf, disabled, sizeof disabled - 1) == 0)
+			&& memcmp(buf, disabled, sizeof disabled - 1) == 0)
 		device_set_wakeup_enable(dev, 0);
 	else
 		return -EINVAL;
@@ -419,9 +419,9 @@ static ssize_t async_store(struct device *dev, struct device_attribute *attr,
 	cp = memchr(buf, '\n', n);
 	if (cp)
 		len = cp - buf;
-	if (len == sizeof enabled - 1 && strncmp(buf, enabled, len) == 0)
+	if (len == sizeof enabled - 1 && memcmp(buf, enabled, len) == 0)
 		device_enable_async_suspend(dev);
-	else if (len == sizeof disabled - 1 && strncmp(buf, disabled, len) == 0)
+	else if (len == sizeof disabled - 1 && memcmp(buf, disabled, len) == 0)
 		device_disable_async_suspend(dev);
 	else
 		return -EINVAL;
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 1f286ab..f41a925 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -5979,7 +5979,7 @@ static bool DAC960_V1_ExecuteUserCommand(DAC960_Controller_T *Controller,
       DAC960_ExecuteCommand(Command);
       DAC960_UserCritical("Cache Flush Completed\n", Controller);
     }
-  else if (strncmp(UserCommand, "kill", 4) == 0 &&
+  else if (memcmp(UserCommand, "kill", 4) == 0 &&
 	   DAC960_ParsePhysicalDevice(Controller, &UserCommand[4],
 				      &Channel, &TargetID))
     {
@@ -5993,7 +5993,7 @@ static bool DAC960_V1_ExecuteUserCommand(DAC960_Controller_T *Controller,
       else DAC960_UserCritical("Kill of Physical Device %d:%d Illegal\n",
 			       Controller, Channel, TargetID);
     }
-  else if (strncmp(UserCommand, "make-online", 11) == 0 &&
+  else if (memcmp(UserCommand, "make-online", 11) == 0 &&
 	   DAC960_ParsePhysicalDevice(Controller, &UserCommand[11],
 				      &Channel, &TargetID))
     {
@@ -6008,7 +6008,7 @@ static bool DAC960_V1_ExecuteUserCommand(DAC960_Controller_T *Controller,
 			       Controller, Channel, TargetID);
 
     }
-  else if (strncmp(UserCommand, "make-standby", 12) == 0 &&
+  else if (memcmp(UserCommand, "make-standby", 12) == 0 &&
 	   DAC960_ParsePhysicalDevice(Controller, &UserCommand[12],
 				      &Channel, &TargetID))
     {
@@ -6023,7 +6023,7 @@ static bool DAC960_V1_ExecuteUserCommand(DAC960_Controller_T *Controller,
 			       "Device %d:%d Illegal\n",
 			       Controller, Channel, TargetID);
     }
-  else if (strncmp(UserCommand, "rebuild", 7) == 0 &&
+  else if (memcmp(UserCommand, "rebuild", 7) == 0 &&
 	   DAC960_ParsePhysicalDevice(Controller, &UserCommand[7],
 				      &Channel, &TargetID))
     {
@@ -6065,7 +6065,7 @@ static bool DAC960_V1_ExecuteUserCommand(DAC960_Controller_T *Controller,
 	  break;
 	}
     }
-  else if (strncmp(UserCommand, "check-consistency", 17) == 0 &&
+  else if (memcmp(UserCommand, "check-consistency", 17) == 0 &&
 	   DAC960_ParseLogicalDrive(Controller, &UserCommand[17],
 				    &LogicalDriveNumber))
     {
@@ -6247,7 +6247,7 @@ static bool DAC960_V2_ExecuteUserCommand(DAC960_Controller_T *Controller,
       DAC960_ExecuteCommand(Command);
       DAC960_UserCritical("Cache Flush Completed\n", Controller);
     }
-  else if (strncmp(UserCommand, "kill", 4) == 0 &&
+  else if (memcmp(UserCommand, "kill", 4) == 0 &&
 	   DAC960_ParsePhysicalDevice(Controller, &UserCommand[4],
 				      &Channel, &TargetID) &&
 	   DAC960_V2_TranslatePhysicalDevice(Command, Channel, TargetID,
@@ -6266,7 +6266,7 @@ static bool DAC960_V2_ExecuteUserCommand(DAC960_Controller_T *Controller,
 			   == DAC960_V2_NormalCompletion
 			   ? "Succeeded" : "Failed"));
     }
-  else if (strncmp(UserCommand, "make-online", 11) == 0 &&
+  else if (memcmp(UserCommand, "make-online", 11) == 0 &&
 	   DAC960_ParsePhysicalDevice(Controller, &UserCommand[11],
 				      &Channel, &TargetID) &&
 	   DAC960_V2_TranslatePhysicalDevice(Command, Channel, TargetID,
@@ -6285,7 +6285,7 @@ static bool DAC960_V2_ExecuteUserCommand(DAC960_Controller_T *Controller,
 			   == DAC960_V2_NormalCompletion
 			   ? "Succeeded" : "Failed"));
     }
-  else if (strncmp(UserCommand, "make-standby", 12) == 0 &&
+  else if (memcmp(UserCommand, "make-standby", 12) == 0 &&
 	   DAC960_ParsePhysicalDevice(Controller, &UserCommand[12],
 				      &Channel, &TargetID) &&
 	   DAC960_V2_TranslatePhysicalDevice(Command, Channel, TargetID,
@@ -6304,7 +6304,7 @@ static bool DAC960_V2_ExecuteUserCommand(DAC960_Controller_T *Controller,
 			   == DAC960_V2_NormalCompletion
 			   ? "Succeeded" : "Failed"));
     }
-  else if (strncmp(UserCommand, "rebuild", 7) == 0 &&
+  else if (memcmp(UserCommand, "rebuild", 7) == 0 &&
 	   DAC960_ParsePhysicalDevice(Controller, &UserCommand[7],
 				      &Channel, &TargetID) &&
 	   DAC960_V2_TranslatePhysicalDevice(Command, Channel, TargetID,
@@ -6321,7 +6321,7 @@ static bool DAC960_V2_ExecuteUserCommand(DAC960_Controller_T *Controller,
 			   == DAC960_V2_NormalCompletion
 			   ? "Initiated" : "Not Initiated"));
     }
-  else if (strncmp(UserCommand, "cancel-rebuild", 14) == 0 &&
+  else if (memcmp(UserCommand, "cancel-rebuild", 14) == 0 &&
 	   DAC960_ParsePhysicalDevice(Controller, &UserCommand[14],
 				      &Channel, &TargetID) &&
 	   DAC960_V2_TranslatePhysicalDevice(Command, Channel, TargetID,
@@ -6338,7 +6338,7 @@ static bool DAC960_V2_ExecuteUserCommand(DAC960_Controller_T *Controller,
 			   == DAC960_V2_NormalCompletion
 			   ? "Cancelled" : "Not Cancelled"));
     }
-  else if (strncmp(UserCommand, "check-consistency", 17) == 0 &&
+  else if (memcmp(UserCommand, "check-consistency", 17) == 0 &&
 	   DAC960_ParseLogicalDrive(Controller, &UserCommand[17],
 				    &LogicalDriveNumber))
     {
@@ -6358,7 +6358,7 @@ static bool DAC960_V2_ExecuteUserCommand(DAC960_Controller_T *Controller,
 			   == DAC960_V2_NormalCompletion
 			   ? "Initiated" : "Not Initiated"));
     }
-  else if (strncmp(UserCommand, "cancel-consistency-check", 24) == 0 &&
+  else if (memcmp(UserCommand, "cancel-consistency-check", 24) == 0 &&
 	   DAC960_ParseLogicalDrive(Controller, &UserCommand[24],
 				    &LogicalDriveNumber))
     {
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 6b5110a..b2f5a43 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -133,7 +133,7 @@ aoedev_flush(const char __user *str, size_t cnt)
 			cnt = sizeof buf;
 		if (copy_from_user(buf, str, cnt))
 			return -EFAULT;
-		all = !strncmp(buf, "all", 3);
+		all = !memcmp(buf, "all", 3);
 	}
 
 	spin_lock_irqsave(&devlist_lock, flags);
diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index 4d3bc0d..6512bc5 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -61,7 +61,7 @@ is_aoe_netif(struct net_device *ifp)
 		else
 			len = strlen(p); /* last token in aoe_iflist */
 
-		if (strlen(ifp->name) == len && !strncmp(ifp->name, p, len))
+		if (strlen(ifp->name) == len && !memcmp(ifp->name, p, len))
 			return 1;
 		if (q == p)
 			break;
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index f291587..24763ce 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -510,7 +510,7 @@ cciss_proc_write(struct file *file, const char __user *buf,
 	buffer[length] = '\0';
 
 #ifdef CONFIG_CISS_SCSI_TAPE
-	if (strncmp(ENGAGE_SCSI, buffer, sizeof ENGAGE_SCSI - 1) == 0) {
+	if (memcmp(ENGAGE_SCSI, buffer, sizeof ENGAGE_SCSI - 1) == 0) {
 		struct seq_file *seq = file->private_data;
 		ctlr_info_t *h = seq->private;
 
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 727d022..b3bbe14 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1244,7 +1244,7 @@ cciss_update_non_disk_devices(ctlr_info_t *h, int hostno)
 
 				strncpy(obdr_sig, &inq_buff[43], 6);
 				obdr_sig[6] = '\0';
-				if (strncmp(obdr_sig, OBDR_TAPE_SIG, 6) != 0)
+				if (memcmp(obdr_sig, OBDR_TAPE_SIG, 6) != 0)
 					/* Not OBDR device, ignore it. */
 					break;
 			}
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 4f9e22f..2804b26 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -857,7 +857,7 @@ static int blkfront_probe(struct xenbus_device *dev,
 		type = xenbus_read(XBT_NIL, dev->nodename, "device-type", &len);
 		if (IS_ERR(type))
 			return -ENODEV;
-		if (strncmp(type, "cdrom", 5) == 0) {
+		if (memcmp(type, "cdrom", 5) == 0) {
 			kfree(type);
 			return -ENODEV;
 		}
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index be73a9b..88f519d 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -562,7 +562,7 @@ static int find_capability(const char *type)
 	struct capability_entry *entry;
 
 	for(entry = capability_table; entry->type; ++entry)
-		if(!strncmp(entry->type, type, 4))
+		if(!memcmp(entry->type, type, 4))
 			break;
 	return entry->capability;
 }
diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index 45b987c..fce4a41 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -712,9 +712,9 @@ MODULE_LICENSE("GPL");
 static int __init apm_setup(char *str)
 {
 	while ((str != NULL) && (*str != '\0')) {
-		if (strncmp(str, "off", 3) == 0)
+		if (memcmp(str, "off", 3) == 0)
 			apm_disabled = 1;
-		if (strncmp(str, "on", 2) == 0)
+		if (memcmp(str, "on", 2) == 0)
 			apm_disabled = 0;
 		str = strchr(str, ',');
 		if (str != NULL)
diff --git a/drivers/char/briq_panel.c b/drivers/char/briq_panel.c
index 095ab90..3b1a4dc 100644
--- a/drivers/char/briq_panel.c
+++ b/drivers/char/briq_panel.c
@@ -201,7 +201,7 @@ static int __init briq_panel_init(void)
 	int i;
 
 	machine = of_get_property(root, "model", NULL);
-	if (!machine || strncmp(machine, "TotalImpact,BRIQ-1", 18) != 0) {
+	if (!machine || memcmp(machine, "TotalImpact,BRIQ-1", 18) != 0) {
 		of_node_put(root);
 		return -ENODEV;
 	}
diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 4f152c2..d77292f 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -3496,7 +3496,7 @@ static int __devinit __cyz_load_fw(const struct firmware *fw,
 		return -EINVAL;
 	}
 
-	if (strncmp(name, h->name, sizeof(h->name))) {
+	if (memcmp(name, h->name, sizeof(h->name))) {
 		printk(BAD_FW "bad name '%s' (expected '%s')\n", h->name, name);
 		return -EINVAL;
 	}
diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index d9df46a..9475709 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -2524,9 +2524,9 @@ static void __init epca_setup(char *str, int *ints)
 		switch (index) {
 		case 1:
 			len = strlen(str);
-			if (strncmp("Disable", str, len) == 0)
+			if (memcmp("Disable", str, len) == 0)
 				board.status = 0;
-			else if (strncmp("Enable", str, len) == 0)
+			else if (memcmp("Enable", str, len) == 0)
 				board.status = 1;
 			else {
 				printk(KERN_ERR "epca_setup: Invalid status %s\n", str);
@@ -2558,9 +2558,9 @@ static void __init epca_setup(char *str, int *ints)
 
 		case 3:
 			len = strlen(str);
-			if (strncmp("Disable", str, len) == 0)
+			if (memcmp("Disable", str, len) == 0)
 				board.altpin = 0;
-			else if (strncmp("Enable", str, len) == 0)
+			else if (memcmp("Enable", str, len) == 0)
 				board.altpin = 1;
 			else {
 				printk(KERN_ERR "epca_setup: Invalid altpin %s\n", str);
diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index d72433f..173aceb 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -569,7 +569,7 @@ static int __init i8k_probe(void)
 		/*
 		 * Check if the two versions match.
 		 */
-		if (strncmp(buff, bios_version, sizeof(bios_version)) != 0)
+		if (memcmp(buff, bios_version, sizeof(bios_version)) != 0)
 			printk(KERN_WARNING "i8k: BIOS version mismatch: %s != %s\n",
 				buff, bios_version);
 	}
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index fcd02ba..dba18cb 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -559,7 +559,7 @@ static int __init ip2_loadmain(void)
 	}
 
 	/* Check module parameter with 'ip2=' has been passed or not */
-	if (!poll_only && (!strncmp(str, "ip2=", 4)))
+	if (!poll_only && (!memcmp(str, "ip2=", 4)))
 		ip2_setup(str);
 
 	ip2trace(ITRC_NO_PORT, ITRC_INIT, ITRC_ENTER, 0);
diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index 97c3edb..b62a76a 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -848,7 +848,7 @@ static int __init lp_setup (char *str)
 			printk(KERN_WARNING "warning: 'lp=0x%x' is deprecated, ignored\n", x);
 			return 0;
 		}
-	} else if (!strncmp(str, "parport", 7)) {
+	} else if (!memcmp(str, "parport", 7)) {
 		int n = simple_strtoul(str+7, NULL, 10);
 		if (parport_ptr < LP_NO)
 			parport_nr[parport_ptr++] = n;
@@ -1010,12 +1010,12 @@ static int __init lp_init_module (void)
 {
 	if (parport[0]) {
 		/* The user gave some parameters.  Let's see what they were.  */
-		if (!strncmp(parport[0], "auto", 4))
+		if (!memcmp(parport[0], "auto", 4))
 			parport_nr[0] = LP_PARPORT_AUTO;
 		else {
 			int n;
 			for (n = 0; n < LP_NO && parport[n]; n++) {
-				if (!strncmp(parport[n], "none", 4))
+				if (!memcmp(parport[n], "none", 4))
 					parport_nr[n] = LP_PARPORT_NONE;
 				else {
 					char *ep;
diff --git a/drivers/char/rio/rio_linux.c b/drivers/char/rio/rio_linux.c
index 5e33293..f60d612 100644
--- a/drivers/char/rio/rio_linux.c
+++ b/drivers/char/rio/rio_linux.c
@@ -1095,7 +1095,7 @@ static int __init rio_init(void)
 		vpdp = get_VPD_PROM(hp);
 		rio_dprintk(RIO_DEBUG_PROBE, "Got VPD ROM\n");
 		okboard = 0;
-		if ((strncmp(vpdp->identifier, RIO_ISA_IDENT, 16) == 0) || (strncmp(vpdp->identifier, RIO_ISA2_IDENT, 16) == 0) || (strncmp(vpdp->identifier, RIO_ISA3_IDENT, 16) == 0)) {
+		if ((memcmp(vpdp->identifier, RIO_ISA_IDENT, 16) == 0) || (strncmp(vpdp->identifier, RIO_ISA2_IDENT, 16) == 0) || (strncmp(vpdp->identifier, RIO_ISA3_IDENT, 16) == 0)) {
 			/* Board is present... */
 			if (RIOBoardTest(hp->PaddrP, hp->Caddr, RIO_AT, 0) == 0) {
 				/* ... and feeling fine!!!! */
diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index a786326..b238db1 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -2189,7 +2189,7 @@ static int __devinit probe_sx(struct sx_board *board)
 
 		sx_dprintk(SX_DEBUG_PROBE, "checking identifier...\n");
 
-		if (strncmp(vpdp.identifier, SX_VPD_IDENT_STRING, 16) != 0) {
+		if (memcmp(vpdp.identifier, SX_VPD_IDENT_STRING, 16) != 0) {
 			sx_dprintk(SX_DEBUG_PROBE, "Got non-SX identifier: "
 					"'%s'\n", vpdp.identifier);
 			return 0;
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index a84250a..9be1d7b 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -977,7 +977,7 @@ static void hifn_init_pll(struct hifn_device *dev)
 
 	pllcfg = HIFN_1_PLL | HIFN_PLL_RESERVED_1;
 
-	if (strncmp(hifn_pll_ref, "ext", 3) == 0)
+	if (memcmp(hifn_pll_ref, "ext", 3) == 0)
 		pllcfg |= HIFN_PLL_REF_CLK_PLL;
 	else
 		pllcfg |= HIFN_PLL_REF_CLK_HBI;
@@ -2749,8 +2749,8 @@ static int __init hifn_init(void)
 		return -EINVAL;
 	}
 
-	if (strncmp(hifn_pll_ref, "ext", 3) &&
-	    strncmp(hifn_pll_ref, "pci", 3)) {
+	if (memcmp(hifn_pll_ref, "ext", 3) &&
+	    memcmp(hifn_pll_ref, "pci", 3)) {
 		printk(KERN_ERR "hifn795x: invalid hifn_pll_ref clock, "
 				"must be pci or ext");
 		return -EINVAL;
diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index 96c25d9..3952a5b 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -147,20 +147,20 @@ edd_show_host_bus(struct edd_device *edev, char *buf)
 		}
 	}
 
-	if (!strncmp(info->params.host_bus_type, "ISA", 3)) {
+	if (!memcmp(info->params.host_bus_type, "ISA", 3)) {
 		p += scnprintf(p, left, "\tbase_address: %x\n",
 			     info->params.interface_path.isa.base_address);
-	} else if (!strncmp(info->params.host_bus_type, "PCIX", 4) ||
-		   !strncmp(info->params.host_bus_type, "PCI", 3)) {
+	} else if (!memcmp(info->params.host_bus_type, "PCIX", 4) ||
+		   !memcmp(info->params.host_bus_type, "PCI", 3)) {
 		p += scnprintf(p, left,
 			     "\t%02x:%02x.%d  channel: %u\n",
 			     info->params.interface_path.pci.bus,
 			     info->params.interface_path.pci.slot,
 			     info->params.interface_path.pci.function,
 			     info->params.interface_path.pci.channel);
-	} else if (!strncmp(info->params.host_bus_type, "IBND", 4) ||
-		   !strncmp(info->params.host_bus_type, "XPRS", 4) ||
-		   !strncmp(info->params.host_bus_type, "HTPT", 4)) {
+	} else if (!memcmp(info->params.host_bus_type, "IBND", 4) ||
+		   !memcmp(info->params.host_bus_type, "XPRS", 4) ||
+		   !memcmp(info->params.host_bus_type, "HTPT", 4)) {
 		p += scnprintf(p, left,
 			     "\tTBD: %llx\n",
 			     info->params.interface_path.ibnd.reserved);
@@ -192,34 +192,34 @@ edd_show_interface(struct edd_device *edev, char *buf)
 			p += scnprintf(p, left, " ");
 		}
 	}
-	if (!strncmp(info->params.interface_type, "ATAPI", 5)) {
+	if (!memcmp(info->params.interface_type, "ATAPI", 5)) {
 		p += scnprintf(p, left, "\tdevice: %u  lun: %u\n",
 			     info->params.device_path.atapi.device,
 			     info->params.device_path.atapi.lun);
-	} else if (!strncmp(info->params.interface_type, "ATA", 3)) {
+	} else if (!memcmp(info->params.interface_type, "ATA", 3)) {
 		p += scnprintf(p, left, "\tdevice: %u\n",
 			     info->params.device_path.ata.device);
-	} else if (!strncmp(info->params.interface_type, "SCSI", 4)) {
+	} else if (!memcmp(info->params.interface_type, "SCSI", 4)) {
 		p += scnprintf(p, left, "\tid: %u  lun: %llu\n",
 			     info->params.device_path.scsi.id,
 			     info->params.device_path.scsi.lun);
-	} else if (!strncmp(info->params.interface_type, "USB", 3)) {
+	} else if (!memcmp(info->params.interface_type, "USB", 3)) {
 		p += scnprintf(p, left, "\tserial_number: %llx\n",
 			     info->params.device_path.usb.serial_number);
-	} else if (!strncmp(info->params.interface_type, "1394", 4)) {
+	} else if (!memcmp(info->params.interface_type, "1394", 4)) {
 		p += scnprintf(p, left, "\teui: %llx\n",
 			     info->params.device_path.i1394.eui);
-	} else if (!strncmp(info->params.interface_type, "FIBRE", 5)) {
+	} else if (!memcmp(info->params.interface_type, "FIBRE", 5)) {
 		p += scnprintf(p, left, "\twwid: %llx lun: %llx\n",
 			     info->params.device_path.fibre.wwid,
 			     info->params.device_path.fibre.lun);
-	} else if (!strncmp(info->params.interface_type, "I2O", 3)) {
+	} else if (!memcmp(info->params.interface_type, "I2O", 3)) {
 		p += scnprintf(p, left, "\tidentity_tag: %llx\n",
 			     info->params.device_path.i2o.identity_tag);
-	} else if (!strncmp(info->params.interface_type, "RAID", 4)) {
+	} else if (!memcmp(info->params.interface_type, "RAID", 4)) {
 		p += scnprintf(p, left, "\tidentity_tag: %x\n",
 			     info->params.device_path.raid.array_number);
-	} else if (!strncmp(info->params.interface_type, "SATA", 4)) {
+	} else if (!memcmp(info->params.interface_type, "SATA", 4)) {
 		p += scnprintf(p, left, "\tdevice: %u\n",
 			     info->params.device_path.sata.device);
 	} else {
@@ -650,8 +650,8 @@ edd_dev_is_type(struct edd_device *edev, const char *type)
 	info = edd_dev_get_info(edev);
 
 	if (type && info) {
-		if (!strncmp(info->params.host_bus_type, type, strlen(type)) ||
-		    !strncmp(info->params.interface_type, type, strlen(type)))
+		if (!memcmp(info->params.host_bus_type, type, strlen(type)) ||
+		    !memcmp(info->params.interface_type, type, strlen(type)))
 			return 1;
 	}
 	return 0;
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index a245d17..3cfa597 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -372,7 +372,7 @@ static bool edid_vendor(struct edid *edid, char *vendor)
 			  ((edid->mfg_id[1] & 0xe0) >> 5)) + '@';
 	edid_vendor[2] = (edid->mfg_id[1] & 0x1f) + '@';
 
-	return !strncmp(edid_vendor, vendor, 3);
+	return !memcmp(edid_vendor, vendor, 3);
 }
 
 /**
diff --git a/drivers/gpu/drm/nouveau/nouveau_pm.c b/drivers/gpu/drm/nouveau/nouveau_pm.c
index 9f7b158..5f3128f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_pm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_pm.c
@@ -91,7 +91,7 @@ nouveau_pm_profile_set(struct drm_device *dev, const char *profile)
 	if (!pm->clock_set)
 		return -EINVAL;
 
-	if (!strncmp(profile, "boot", 4))
+	if (!memcmp(profile, "boot", 4))
 		perflvl = &pm->boot;
 	else {
 		int pl = simple_strtol(profile, NULL, 10);
diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index 8e421f6..1486d0f 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -1248,7 +1248,7 @@ struct atom_context *atom_parse(struct card_info *card, void *bios)
 		kfree(ctx);
 		return NULL;
 	}
-	if (strncmp
+	if (memcmp
 	    (CSTR(ATOM_ATI_MAGIC_PTR), ATOM_ATI_MAGIC,
 	     strlen(ATOM_ATI_MAGIC))) {
 		printk(KERN_INFO "Invalid ATI magic.\n");
@@ -1257,7 +1257,7 @@ struct atom_context *atom_parse(struct card_info *card, void *bios)
 	}
 
 	base = CU16(ATOM_ROM_TABLE_PTR);
-	if (strncmp
+	if (memcmp
 	    (CSTR(base + ATOM_ROM_MAGIC_PTR), ATOM_ROM_MAGIC,
 	     strlen(ATOM_ROM_MAGIC))) {
 		printk(KERN_INFO "Invalid ATOM magic.\n");
diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index 8c9b2ef..b7a12d8 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -354,15 +354,15 @@ static ssize_t radeon_set_pm_profile(struct device *dev,
 
 	mutex_lock(&rdev->pm.mutex);
 	if (rdev->pm.pm_method == PM_METHOD_PROFILE) {
-		if (strncmp("default", buf, strlen("default")) == 0)
+		if (memcmp("default", buf, strlen("default")) == 0)
 			rdev->pm.profile = PM_PROFILE_DEFAULT;
-		else if (strncmp("auto", buf, strlen("auto")) == 0)
+		else if (memcmp("auto", buf, strlen("auto")) == 0)
 			rdev->pm.profile = PM_PROFILE_AUTO;
-		else if (strncmp("low", buf, strlen("low")) == 0)
+		else if (memcmp("low", buf, strlen("low")) == 0)
 			rdev->pm.profile = PM_PROFILE_LOW;
-		else if (strncmp("mid", buf, strlen("mid")) == 0)
+		else if (memcmp("mid", buf, strlen("mid")) == 0)
 			rdev->pm.profile = PM_PROFILE_MID;
-		else if (strncmp("high", buf, strlen("high")) == 0)
+		else if (memcmp("high", buf, strlen("high")) == 0)
 			rdev->pm.profile = PM_PROFILE_HIGH;
 		else {
 			DRM_ERROR("invalid power profile!\n");
@@ -398,13 +398,13 @@ static ssize_t radeon_set_pm_method(struct device *dev,
 	struct radeon_device *rdev = ddev->dev_private;
 
 
-	if (strncmp("dynpm", buf, strlen("dynpm")) == 0) {
+	if (memcmp("dynpm", buf, strlen("dynpm")) == 0) {
 		mutex_lock(&rdev->pm.mutex);
 		rdev->pm.pm_method = PM_METHOD_DYNPM;
 		rdev->pm.dynpm_state = DYNPM_STATE_PAUSED;
 		rdev->pm.dynpm_planned_action = DYNPM_ACTION_DEFAULT;
 		mutex_unlock(&rdev->pm.mutex);
-	} else if (strncmp("profile", buf, strlen("profile")) == 0) {
+	} else if (memcmp("profile", buf, strlen("profile")) == 0) {
 		bool flush_wq = false;
 
 		mutex_lock(&rdev->pm.mutex);
diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index c8768f3..1b06242 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -282,7 +282,7 @@ vga_switcheroo_debugfs_write(struct file *filp, const char __user *ubuf,
 	}
 
 	/* pwr off the device not in use */
-	if (strncmp(usercmd, "OFF", 3) == 0) {
+	if (memcmp(usercmd, "OFF", 3) == 0) {
 		for (i = 0; i < VGA_SWITCHEROO_MAX_CLIENTS; i++) {
 			if (vgasr_priv.clients[i].active)
 				continue;
@@ -292,7 +292,7 @@ vga_switcheroo_debugfs_write(struct file *filp, const char __user *ubuf,
 		goto out;
 	}
 	/* pwr on the device not in use */
-	if (strncmp(usercmd, "ON", 2) == 0) {
+	if (memcmp(usercmd, "ON", 2) == 0) {
 		for (i = 0; i < VGA_SWITCHEROO_MAX_CLIENTS; i++) {
 			if (vgasr_priv.clients[i].active)
 				continue;
@@ -303,20 +303,20 @@ vga_switcheroo_debugfs_write(struct file *filp, const char __user *ubuf,
 	}
 
 	/* request a delayed switch - test can we switch now */
-	if (strncmp(usercmd, "DIGD", 4) == 0) {
+	if (memcmp(usercmd, "DIGD", 4) == 0) {
 		client_id = VGA_SWITCHEROO_IGD;
 		delay = true;
 	}
 
-	if (strncmp(usercmd, "DDIS", 4) == 0) {
+	if (memcmp(usercmd, "DDIS", 4) == 0) {
 		client_id = VGA_SWITCHEROO_DIS;
 		delay = true;
 	}
 
-	if (strncmp(usercmd, "IGD", 3) == 0)
+	if (memcmp(usercmd, "IGD", 3) == 0)
 		client_id = VGA_SWITCHEROO_IGD;
 
-	if (strncmp(usercmd, "DIS", 3) == 0)
+	if (memcmp(usercmd, "DIS", 3) == 0)
 		client_id = VGA_SWITCHEROO_DIS;
 
 	if (client_id == -1)
diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index c380c65..dbd0849 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -94,17 +94,17 @@ static int vga_str_to_iostate(char *buf, int str_size, int *io_state)
 {
 	/* we could in theory hand out locks on IO and mem
 	 * separately to userspace but it can cause deadlocks */
-	if (strncmp(buf, "none", 4) == 0) {
+	if (memcmp(buf, "none", 4) == 0) {
 		*io_state = VGA_RSRC_NONE;
 		return 1;
 	}
 
 	/* XXX We're not chekcing the str_size! */
-	if (strncmp(buf, "io+mem", 6) == 0)
+	if (memcmp(buf, "io+mem", 6) == 0)
 		goto both;
-	else if (strncmp(buf, "io", 2) == 0)
+	else if (memcmp(buf, "io", 2) == 0)
 		goto both;
-	else if (strncmp(buf, "mem", 3) == 0)
+	else if (memcmp(buf, "mem", 3) == 0)
 		goto both;
 	return 0;
 both:
@@ -848,7 +848,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 	curr_pos = kbuf;
 	kbuf[count] = '\0';	/* Just to make sure... */
 
-	if (strncmp(curr_pos, "lock ", 5) == 0) {
+	if (memcmp(curr_pos, "lock ", 5) == 0) {
 		curr_pos += 5;
 		remaining -= 5;
 
@@ -884,13 +884,13 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 
 		ret_val = count;
 		goto done;
-	} else if (strncmp(curr_pos, "unlock ", 7) == 0) {
+	} else if (memcmp(curr_pos, "unlock ", 7) == 0) {
 		curr_pos += 7;
 		remaining -= 7;
 
 		pr_debug("client 0x%p called 'unlock'\n", priv);
 
-		if (strncmp(curr_pos, "all", 3) == 0)
+		if (memcmp(curr_pos, "all", 3) == 0)
 			io_state = VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM;
 		else {
 			if (!vga_str_to_iostate
@@ -934,7 +934,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 
 		ret_val = count;
 		goto done;
-	} else if (strncmp(curr_pos, "trylock ", 8) == 0) {
+	} else if (memcmp(curr_pos, "trylock ", 8) == 0) {
 		curr_pos += 8;
 		remaining -= 8;
 
@@ -975,7 +975,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 			goto done;
 		}
 
-	} else if (strncmp(curr_pos, "target ", 7) == 0) {
+	} else if (memcmp(curr_pos, "target ", 7) == 0) {
 		struct pci_bus *pbus;
 		unsigned int domain, bus, devfn;
 		struct vga_device *vgadev;
@@ -984,7 +984,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		remaining -= 7;
 		pr_debug("client 0x%p called 'target'\n", priv);
 		/* if target is default */
-		if (!strncmp(curr_pos, "default", 7))
+		if (!memcmp(curr_pos, "default", 7))
 			pdev = pci_dev_get(vga_default_device());
 		else {
 			if (!vga_pci_str_to_vars(curr_pos, remaining,
@@ -1047,7 +1047,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		goto done;
 
 
-	} else if (strncmp(curr_pos, "decodes ", 8) == 0) {
+	} else if (memcmp(curr_pos, "decodes ", 8) == 0) {
 		curr_pos += 8;
 		remaining -= 8;
 		pr_debug("vgaarb: client 0x%p called 'decodes'\n", priv);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 515345b..27a270e 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1496,7 +1496,7 @@ static int hid_bus_match(struct device *dev, struct device_driver *drv)
 		return 0;
 
 	/* generic wants all non-blacklisted */
-	if (!strncmp(hdrv->name, "generic-", 8))
+	if (!memcmp(hdrv->name, "generic-", 8))
 		return !hid_match_id(hdev, hid_blacklist);
 
 	return 1;
diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index bc2e077..43e658f 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -1411,12 +1411,12 @@ static ssize_t picolcd_operation_mode_store(struct device *dev,
 	int timeout = data->opmode_delay;
 	unsigned long flags;
 
-	if (cnt >= 3 && strncmp("lcd", buf, 3) == 0) {
+	if (cnt >= 3 && memcmp("lcd", buf, 3) == 0) {
 		if (data->status & PICOLCD_BOOTLOADER)
 			report = picolcd_out_report(REPORT_EXIT_FLASHER, data->hdev);
 		buf += 3;
 		cnt -= 3;
-	} else if (cnt >= 10 && strncmp("bootloader", buf, 10) == 0) {
+	} else if (cnt >= 10 && memcmp("bootloader", buf, 10) == 0) {
 		if (!(data->status & PICOLCD_BOOTLOADER))
 			report = picolcd_out_report(REPORT_EXIT_KEYBOARD, data->hdev);
 		buf += 10;
diff --git a/drivers/i2c/busses/i2c-powermac.c b/drivers/i2c/busses/i2c-powermac.c
index b289ec9..fdac3aa 100644
--- a/drivers/i2c/busses/i2c-powermac.c
+++ b/drivers/i2c/busses/i2c-powermac.c
@@ -281,7 +281,7 @@ static int __devinit i2c_powermac_probe(struct platform_device *dev)
 
 	printk(KERN_INFO "PowerMac i2c bus %s registered\n", adapter->name);
 
-	if (!strncmp(basename, "uni-n", 5)) {
+	if (!memcmp(basename, "uni-n", 5)) {
 		struct device_node *np;
 		const u32 *prop;
 		struct i2c_board_info info;
diff --git a/drivers/i2c/busses/i2c-taos-evm.c b/drivers/i2c/busses/i2c-taos-evm.c
index dd39c1e..702a44d 100644
--- a/drivers/i2c/busses/i2c-taos-evm.c
+++ b/drivers/i2c/busses/i2c-taos-evm.c
@@ -58,7 +58,7 @@ static struct i2c_board_info tsl2550_info = {
 /* Instantiate i2c devices based on the adapter name */
 static struct i2c_client *taos_instantiate_device(struct i2c_adapter *adapter)
 {
-	if (!strncmp(adapter->name, "TAOS TSL2550 EVM", 16)) {
+	if (!memcmp(adapter->name, "TAOS TSL2550 EVM", 16)) {
 		dev_info(&adapter->dev, "Instantiating device %s at 0x%02x\n",
 			tsl2550_info.type, tsl2550_info.addr);
 		return i2c_new_device(adapter, &tsl2550_info);
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 5406b6e..f60e394 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -488,7 +488,7 @@ static void ide_floppy_setup(ide_drive_t *drive)
 	 * it. It should be fixed as of version 1.9, but to be on the safe side
 	 * we'll leave the limitation below for the 2.2.x tree.
 	 */
-	if (!strncmp((char *)&id[ATA_ID_PROD], "IOMEGA ZIP 100 ATAPI", 20)) {
+	if (!memcmp((char *)&id[ATA_ID_PROD], "IOMEGA ZIP 100 ATAPI", 20)) {
 		drive->atapi_flags |= IDE_AFLAG_ZIP_DRIVE;
 		/* This value will be visible in the /proc/ide/hdx/settings */
 		drive->pc_delay = IDEFLOPPY_PC_DELAY;
@@ -499,7 +499,7 @@ static void ide_floppy_setup(ide_drive_t *drive)
 	 * Guess what? The IOMEGA Clik! drive also needs the above fix. It makes
 	 * nasty clicking noises without it, so please don't remove this.
 	 */
-	if (strncmp((char *)&id[ATA_ID_PROD], "IOMEGA Clik!", 11) == 0) {
+	if (memcmp((char *)&id[ATA_ID_PROD], "IOMEGA Clik!", 11) == 0) {
 		blk_queue_max_hw_sectors(drive->queue, 64);
 		drive->atapi_flags |= IDE_AFLAG_CLIK_DRIVE;
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
diff --git a/drivers/ide/ide-pio-blacklist.c b/drivers/ide/ide-pio-blacklist.c
index a8c2c8f..285383a 100644
--- a/drivers/ide/ide-pio-blacklist.c
+++ b/drivers/ide/ide-pio-blacklist.c
@@ -87,7 +87,7 @@ int ide_scan_pio_blacklist(char *model)
 	struct ide_pio_info *p;
 
 	for (p = ide_pio_blacklist; p->name != NULL; p++) {
-		if (strncmp(p->name, model, strlen(p->name)) == 0)
+		if (memcmp(p->name, model, strlen(p->name)) == 0)
 			return p->pio;
 	}
 	return -1;
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 068cef0..33cadfb 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -659,7 +659,7 @@ void ide_undecoded_slave(ide_drive_t *dev1)
 		return;
 
 	/* Serial numbers do not match */
-	if (strncmp((char *)&dev0->id[ATA_ID_SERNO],
+	if (memcmp((char *)&dev0->id[ATA_ID_SERNO],
 		    (char *)&dev1->id[ATA_ID_SERNO], ATA_ID_SERNO_LEN))
 		return;
 
diff --git a/drivers/ide/ide-sysfs.c b/drivers/ide/ide-sysfs.c
index 883ffac..bf2b301 100644
--- a/drivers/ide/ide-sysfs.c
+++ b/drivers/ide/ide-sysfs.c
@@ -78,7 +78,7 @@ static ssize_t store_delete_devices(struct device *portdev,
 {
 	ide_hwif_t *hwif = dev_get_drvdata(portdev);
 
-	if (strncmp(buf, "1", n))
+	if (memcmp(buf, "1", n))
 		return -EINVAL;
 
 	ide_port_unregister_devices(hwif);
@@ -94,7 +94,7 @@ static ssize_t store_scan(struct device *portdev,
 {
 	ide_hwif_t *hwif = dev_get_drvdata(portdev);
 
-	if (strncmp(buf, "1", n))
+	if (memcmp(buf, "1", n))
 		return -EINVAL;
 
 	ide_port_unregister_devices(hwif);
diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.c
index ebcf8e4..651179f 100644
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -926,10 +926,10 @@ static u8 pmac_ide_cable_detect(ide_hwif_t *hwif)
 	const char *model = of_get_property(root, "model", NULL);
 
 	/* Get cable type from device-tree. */
-	if (cable && !strncmp(cable, "80-", 3)) {
+	if (cable && !memcmp(cable, "80-", 3)) {
 		/* Some drives fail to detect 80c cable in PowerBook */
 		/* These machine use proprietary short IDE cable anyway */
-		if (!strncmp(model, "PowerBook", 9))
+		if (!memcmp(model, "PowerBook", 9))
 			return ATA_CBL_PATA40_SHORT;
 		else
 			return ATA_CBL_PATA80;
diff --git a/drivers/ide/qd65xx.c b/drivers/ide/qd65xx.c
index 3f0244f..051a2a8 100644
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -162,7 +162,7 @@ static int qd_find_disk_type (ide_drive_t *drive,
 	ide_fixstring(model, ATA_ID_PROD_LEN, 1); /* byte-swap */
 
 	for (p = qd65xx_timing ; p->offset != -1 ; p++) {
-		if (!strncmp(p->model, model+p->offset, 4)) {
+		if (!memcmp(p->model, model+p->offset, 4)) {
 			printk(KERN_DEBUG "%s: listed !\n", drive->name);
 			*active_time = p->active;
 			*recovery_time = p->recovery;
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a19effa..0997813 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -109,7 +109,7 @@ static struct ib_device *__ib_device_get_by_name(const char *name)
 	struct ib_device *device;
 
 	list_for_each_entry(device, &device_list, core_list)
-		if (!strncmp(name, device->name, IB_DEVICE_NAME_MAX))
+		if (!memcmp(name, device->name, IB_DEVICE_NAME_MAX))
 			return device;
 
 	return NULL;
@@ -133,7 +133,7 @@ static int alloc_name(char *name)
 		if (i < 0 || i >= PAGE_SIZE * 8)
 			continue;
 		snprintf(buf, sizeof buf, name, i);
-		if (!strncmp(buf, device->name, IB_DEVICE_NAME_MAX))
+		if (!memcmp(buf, device->name, IB_DEVICE_NAME_MAX))
 			set_bit(i, inuse);
 	}
 
diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index a5e29db..0098f77 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -2507,7 +2507,7 @@ static void init_6120_cntrnames(struct qib_devdata *dd)
 	for (i = 0, s = (char *)cntr6120names; s && j <= dd->cfgctxts;
 	     i++) {
 		/* we always have at least one counter before the egrovfl */
-		if (!j && !strncmp("Ctxt0EgrOvfl", s + 1, 12))
+		if (!j && !memcmp("Ctxt0EgrOvfl", s + 1, 12))
 			j = 1;
 		s = strchr(s + 1, '\n');
 		if (s && j)
@@ -2920,11 +2920,11 @@ bail:
 static int qib_6120_set_loopback(struct qib_pportdata *ppd, const char *what)
 {
 	int ret = 0;
-	if (!strncmp(what, "ibc", 3)) {
+	if (!memcmp(what, "ibc", 3)) {
 		ppd->dd->cspec->ibcctrl |= SYM_MASK(IBCCtrl, Loopback);
 		qib_devinfo(ppd->dd->pcidev, "Enabling IB%u:%u IBC loopback\n",
 			 ppd->dd->unit, ppd->port);
-	} else if (!strncmp(what, "off", 3)) {
+	} else if (!memcmp(what, "off", 3)) {
 		ppd->dd->cspec->ibcctrl &= ~SYM_MASK(IBCCtrl, Loopback);
 		qib_devinfo(ppd->dd->pcidev, "Disabling IB%u:%u IBC loopback "
 			    "(normal)\n", ppd->dd->unit, ppd->port);
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index 6fd8d74..511afd7 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -2677,12 +2677,12 @@ static int qib_7220_set_loopback(struct qib_pportdata *ppd, const char *what)
 	int ret = 0;
 	u64 val, ddr;
 
-	if (!strncmp(what, "ibc", 3)) {
+	if (!memcmp(what, "ibc", 3)) {
 		ppd->cpspec->ibcctrl |= SYM_MASK(IBCCtrl, Loopback);
 		val = 0; /* disable heart beat, so link will come up */
 		qib_devinfo(ppd->dd->pcidev, "Enabling IB%u:%u IBC loopback\n",
 			 ppd->dd->unit, ppd->port);
-	} else if (!strncmp(what, "off", 3)) {
+	} else if (!memcmp(what, "off", 3)) {
 		ppd->cpspec->ibcctrl &= ~SYM_MASK(IBCCtrl, Loopback);
 		/* enable heart beat again */
 		val = IBA7220_IBC_HRTBT_MASK << IBA7220_IBC_HRTBT_SHIFT;
@@ -3136,7 +3136,7 @@ static void init_7220_cntrnames(struct qib_devdata *dd)
 	for (i = 0, s = (char *)cntr7220names; s && j <= dd->cfgctxts;
 	     i++) {
 		/* we always have at least one counter before the egrovfl */
-		if (!j && !strncmp("Ctxt0EgrOvfl", s + 1, 12))
+		if (!j && !memcmp("Ctxt0EgrOvfl", s + 1, 12))
 			j = 1;
 		s = strchr(s + 1, '\n');
 		if (s && j)
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 584d443..7eae339 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -3898,13 +3898,13 @@ static int qib_7322_set_loopback(struct qib_pportdata *ppd, const char *what)
 	u64 val, ctrlb;
 
 	/* only IBC loopback, may add serdes and xgxs loopbacks later */
-	if (!strncmp(what, "ibc", 3)) {
+	if (!memcmp(what, "ibc", 3)) {
 		ppd->cpspec->ibcctrl_a |= SYM_MASK(IBCCtrlA_0,
 						       Loopback);
 		val = 0; /* disable heart beat, so link will come up */
 		qib_devinfo(ppd->dd->pcidev, "Enabling IB%u:%u IBC loopback\n",
 			 ppd->dd->unit, ppd->port);
-	} else if (!strncmp(what, "off", 3)) {
+	} else if (!memcmp(what, "off", 3)) {
 		ppd->cpspec->ibcctrl_a &= ~SYM_MASK(IBCCtrlA_0,
 							Loopback);
 		/* enable heart beat again */
@@ -4561,7 +4561,7 @@ static void init_7322_cntrnames(struct qib_devdata *dd)
 	for (i = 0, s = (char *)cntr7322names; s && j <= dd->cfgctxts;
 	     i++) {
 		/* we always have at least one counter before the egrovfl */
-		if (!j && !strncmp("Ctxt0EgrOvfl", s + 1, 12))
+		if (!j && !memcmp("Ctxt0EgrOvfl", s + 1, 12))
 			j = 1;
 		s = strchr(s + 1, '\n');
 		if (s && j)
diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index 46239e4..f055411 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -453,11 +453,11 @@ static ssize_t gameport_rebind_driver(struct device *dev, struct device_attribut
 	if (error)
 		return error;
 
-	if (!strncmp(buf, "none", count)) {
+	if (!memcmp(buf, "none", count)) {
 		gameport_disconnect_port(gameport);
-	} else if (!strncmp(buf, "reconnect", count)) {
+	} else if (!memcmp(buf, "reconnect", count)) {
 		gameport_reconnect_port(gameport);
-	} else if (!strncmp(buf, "rescan", count)) {
+	} else if (!memcmp(buf, "rescan", count)) {
 		gameport_disconnect_port(gameport);
 		gameport_find_driver(gameport);
 	} else if ((drv = driver_find(buf, &gameport_bus)) != NULL) {
diff --git a/drivers/input/misc/yealink.c b/drivers/input/misc/yealink.c
index 41201c6..49f6c75 100644
--- a/drivers/input/misc/yealink.c
+++ b/drivers/input/misc/yealink.c
@@ -720,7 +720,7 @@ static ssize_t set_icon(struct device *dev, const char *buf, size_t count,
 	for (i = 0; i < ARRAY_SIZE(lcdMap); i++) {
 		if (lcdMap[i].type != '.')
 			continue;
-		if (strncmp(buf, lcdMap[i].u.p.name, count) == 0) {
+		if (memcmp(buf, lcdMap[i].u.p.name, count) == 0) {
 			setChar(yld, i, chr);
 			break;
 		}
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index cd9d0c9..042f952 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -905,8 +905,8 @@ static const struct psmouse_protocol *psmouse_protocol_by_name(const char *name,
 	for (i = 0; i < ARRAY_SIZE(psmouse_protocols); i++) {
 		p = &psmouse_protocols[i];
 
-		if ((strlen(p->name) == len && !strncmp(p->name, name, len)) ||
-		    (strlen(p->alias) == len && !strncmp(p->alias, name, len)))
+		if ((strlen(p->name) == len && !memcmp(p->name, name, len)) ||
+		    (strlen(p->alias) == len && !memcmp(p->alias, name, len)))
 			return &psmouse_protocols[i];
 	}
 
diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index 405bf21..21ae582 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -443,11 +443,11 @@ static ssize_t serio_rebind_driver(struct device *dev, struct device_attribute *
 	if (error)
 		return error;
 
-	if (!strncmp(buf, "none", count)) {
+	if (!memcmp(buf, "none", count)) {
 		serio_disconnect_port(serio);
-	} else if (!strncmp(buf, "reconnect", count)) {
+	} else if (!memcmp(buf, "reconnect", count)) {
 		serio_reconnect_subtree(serio);
-	} else if (!strncmp(buf, "rescan", count)) {
+	} else if (!memcmp(buf, "rescan", count)) {
 		serio_disconnect_port(serio);
 		serio_find_driver(serio);
 	} else if ((drv = driver_find(buf, &serio_bus)) != NULL) {
@@ -475,9 +475,9 @@ static ssize_t serio_set_bind_mode(struct device *dev, struct device_attribute *
 	int retval;
 
 	retval = count;
-	if (!strncmp(buf, "manual", count)) {
+	if (!memcmp(buf, "manual", count)) {
 		serio->manual_bind = true;
-	} else if (!strncmp(buf, "auto", count)) {
+	} else if (!memcmp(buf, "auto", count)) {
 		serio->manual_bind = false;
 	} else {
 		retval = -EINVAL;
@@ -762,9 +762,9 @@ static ssize_t serio_driver_set_bind_mode(struct device_driver *drv, const char
 	int retval;
 
 	retval = count;
-	if (!strncmp(buf, "manual", count)) {
+	if (!memcmp(buf, "manual", count)) {
 		serio_drv->manual_bind = true;
-	} else if (!strncmp(buf, "auto", count)) {
+	} else if (!memcmp(buf, "auto", count)) {
 		serio_drv->manual_bind = false;
 	} else {
 		retval = -EINVAL;
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 0a619c5..106a8ef 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -380,7 +380,7 @@ static int map_str_to_val(const struct aiptek_map *map, const char *str, size_t
 		count--;
 
 	for (p = map; p->string; p++)
-	        if (!strncmp(str, p->string, count))
+	        if (!memcmp(str, p->string, count))
 			return p->value;
 
 	return AIPTEK_INVALID_VALUE;
@@ -1204,7 +1204,7 @@ store_tabletXtilt(struct device *dev, struct device_attribute *attr, const char
 	if (strict_strtol(buf, 10, &x)) {
 		size_t len = buf[count - 1] == '\n' ? count - 1 : count;
 
-		if (strncmp(buf, "disable", len))
+		if (memcmp(buf, "disable", len))
 			return -EINVAL;
 
 		aiptek->newSetting.xTilt = AIPTEK_TILT_DISABLE;
@@ -1246,7 +1246,7 @@ store_tabletYtilt(struct device *dev, struct device_attribute *attr, const char
 	if (strict_strtol(buf, 10, &y)) {
 		size_t len = buf[count - 1] == '\n' ? count - 1 : count;
 
-		if (strncmp(buf, "disable", len))
+		if (memcmp(buf, "disable", len))
 			return -EINVAL;
 
 		aiptek->newSetting.yTilt = AIPTEK_TILT_DISABLE;
diff --git a/drivers/isdn/act2000/capi.c b/drivers/isdn/act2000/capi.c
index 1f0a949..76c50f2 100644
--- a/drivers/isdn/act2000/capi.c
+++ b/drivers/isdn/act2000/capi.c
@@ -915,8 +915,8 @@ actcapi_dispatch(struct work_struct *work)
 						printk(KERN_WARNING "act2000: %s\n", tmp);
 					else {
 						printk(KERN_DEBUG "act2000: %s\n", tmp);
-						if ((!strncmp(tmp, "INFO: Trace buffer con", 22)) ||
-						    (!strncmp(tmp, "INFO: Compile Date/Tim", 22))) {
+						if ((!memcmp(tmp, "INFO: Trace buffer con", 22)) ||
+						    (!memcmp(tmp, "INFO: Compile Date/Tim", 22))) {
 							card->flags |= ACT2000_FLAGS_RUNNING;
 							cmd.command = ISDN_STAT_RUN;
 							cmd.driver = card->myid;
diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index e54e79d..14577cf 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -1499,7 +1499,7 @@ static int decodeFVteln(char *teln, unsigned long *bmaskp, int *activep)
 	char *s;
 	int i;
 
-	if (strncmp(teln, "FV:", 3) != 0)
+	if (memcmp(teln, "FV:", 3) != 0)
 		return 1;
 	s = teln + 3;
 	while (*s && *s == ' ') s++;
diff --git a/drivers/isdn/hardware/eicon/maintidi.c b/drivers/isdn/hardware/eicon/maintidi.c
index 534978b..bc37728 100644
--- a/drivers/isdn/hardware/eicon/maintidi.c
+++ b/drivers/isdn/hardware/eicon/maintidi.c
@@ -858,7 +858,7 @@ static int process_idi_event (diva_strace_context_t* pLib,
 	char name[64];
 	int i;
 
-	if (!strncmp("State\\B Event", path, pVar->path_length)) {
+	if (!memcmp("State\\B Event", path, pVar->path_length)) {
     dword ch_id;
     if (!diva_trace_read_variable (pVar, &ch_id)) {
       if (!pLib->line_init_event && !pLib->pending_line_status) {
@@ -874,7 +874,7 @@ static int process_idi_event (diva_strace_context_t* pLib,
     return (-1);
   }
 
-	if (!strncmp("State\\FAX Event", path, pVar->path_length)) {
+	if (!memcmp("State\\FAX Event", path, pVar->path_length)) {
     dword ch_id;
     if (!diva_trace_read_variable (pVar, &ch_id)) {
       if (!pLib->pending_fax_status && !pLib->fax_init_event) {
@@ -890,7 +890,7 @@ static int process_idi_event (diva_strace_context_t* pLib,
     return (-1);
   }
 
-	if (!strncmp("State\\Modem Event", path, pVar->path_length)) {
+	if (!memcmp("State\\Modem Event", path, pVar->path_length)) {
     dword ch_id;
     if (!diva_trace_read_variable (pVar, &ch_id)) {
       if (!pLib->pending_modem_status && !pLib->modem_init_event) {
@@ -939,7 +939,7 @@ static int process_idi_event (diva_strace_context_t* pLib,
 	/*
 		Notification about loss of events
 		*/
-	if (!strncmp("Events Down", path, pVar->path_length)) {
+	if (!memcmp("Events Down", path, pVar->path_length)) {
 		if (pLib->trace_events_down == 1) {
 			pLib->trace_events_down = 2;
 		} else {
@@ -948,7 +948,7 @@ static int process_idi_event (diva_strace_context_t* pLib,
 		return (0);
 	}
 
-	if (!strncmp("State\\Layer1", path, pVar->path_length)) {
+	if (!memcmp("State\\Layer1", path, pVar->path_length)) {
 		diva_strace_read_asz  (pVar, &pLib->lines[0].pInterface->Layer1[0]);
 		if (pLib->l1_trace == 1) {
 			pLib->l1_trace = 2;
@@ -957,7 +957,7 @@ static int process_idi_event (diva_strace_context_t* pLib,
 		}
 		return (0);
 	}
-	if (!strncmp("State\\Layer2 No1", path, pVar->path_length)) {
+	if (!memcmp("State\\Layer2 No1", path, pVar->path_length)) {
 		char* tmp = &pLib->lines[0].pInterface->Layer2[0];
 		dword l2_state;
 		if (diva_strace_read_uint(pVar, &l2_state))
@@ -1017,13 +1017,13 @@ static int process_idi_event (diva_strace_context_t* pLib,
 		return (0);
 	}
 
-	if (!strncmp("Statistics\\Incoming Calls\\Calls", path, pVar->path_length) ||
-			!strncmp("Statistics\\Incoming Calls\\Connected", path, pVar->path_length)) {
+	if (!memcmp("Statistics\\Incoming Calls\\Calls", path, pVar->path_length) ||
+			!memcmp("Statistics\\Incoming Calls\\Connected", path, pVar->path_length)) {
 		return (SuperTraceGetIncomingCallStatistics (pLib));
 	}
 
-	if (!strncmp("Statistics\\Outgoing Calls\\Calls", path, pVar->path_length) ||
-			!strncmp("Statistics\\Outgoing Calls\\Connected", path, pVar->path_length)) {
+	if (!memcmp("Statistics\\Outgoing Calls\\Calls", path, pVar->path_length) ||
+			!memcmp("Statistics\\Outgoing Calls\\Connected", path, pVar->path_length)) {
 		return (SuperTraceGetOutgoingCallStatistics (pLib));
 	}
 
@@ -1061,7 +1061,7 @@ static int process_idi_info  (diva_strace_context_t* pLib,
 		*/
 	for (i = pLib->Channels; i > 0; i--) {
 		len = sprintf (name, "State\\B%d\\Modem", i);
-		if (!strncmp(name, path, len)) {
+		if (!memcmp(name, path, len)) {
 			return (diva_modem_info (pLib, i, pVar));
 		}
 	}
@@ -1071,7 +1071,7 @@ static int process_idi_info  (diva_strace_context_t* pLib,
 		*/
 	for (i = pLib->Channels; i > 0; i--) {
 		len = sprintf (name, "State\\B%d\\FAX", i);
-		if (!strncmp(name, path, len)) {
+		if (!memcmp(name, path, len)) {
 			return (diva_fax_info (pLib, i, pVar));
 		}
 	}
@@ -1081,7 +1081,7 @@ static int process_idi_info  (diva_strace_context_t* pLib,
 		*/
 	for (i = pLib->Channels; i > 0; i--) {
 		len = sprintf (name, "State\\B%d", i);
-		if (!strncmp(name, path, len)) {
+		if (!memcmp(name, path, len)) {
 			return (diva_line_info (pLib, i, pVar));
 		}
 	}
@@ -1239,7 +1239,7 @@ static diva_man_var_header_t* find_var (diva_man_var_header_t* pVar,
 	do {
 		path = (char*)&pVar->path_length+1;
 
-		if (!strncmp (name, path, pVar->path_length)) {
+		if (!memcmp (name, path, pVar->path_length)) {
 			break;
 		}
 	} while ((pVar = get_next_var (pVar)));
diff --git a/drivers/isdn/i4l/isdn_net.c b/drivers/isdn/i4l/isdn_net.c
index 26d44c3..8c641bf 100644
--- a/drivers/isdn/i4l/isdn_net.c
+++ b/drivers/isdn/i4l/isdn_net.c
@@ -640,7 +640,7 @@ isdn_net_dial(void)
 					isdn_net_hangup(p->dev);
 					break;
 				}
-				if (!strncmp(lp->dial->num, "LEASED", strlen("LEASED"))) {
+				if (!memcmp(lp->dial->num, "LEASED", strlen("LEASED"))) {
 					lp->dialstate = 4;
 					printk(KERN_INFO "%s: Open leased line ...\n", p->dev->name);
 				} else {
@@ -3021,7 +3021,7 @@ isdn_net_getpeer(isdn_net_ioctl_phone *phone, isdn_net_ioctl_phone __user *peer)
 	if (idx <0 )
 		return -ENODEV;
 	/* for pre-bound channels, we need this extra check */
-	if (strncmp(dev->num[idx], "???", 3) == 0)
+	if (memcmp(dev->num[idx], "???", 3) == 0)
 		return -ENOTCONN;
 	strncpy(phone->phone, dev->num[idx], ISDN_MSNLEN);
 	phone->outgoing = USG_OUTGOING(dev->usage[idx]);
diff --git a/drivers/isdn/i4l/isdn_ppp.c b/drivers/isdn/i4l/isdn_ppp.c
index fe824e0..e8f10ca 100644
--- a/drivers/isdn/i4l/isdn_ppp.c
+++ b/drivers/isdn/i4l/isdn_ppp.c
@@ -2058,7 +2058,7 @@ isdn_ppp_if_get_unit(char *name)
 
 	len = strlen(name);
 
-	if (strncmp("ippp", name, 4) || len > 8)
+	if (memcmp("ippp", name, 4) || len > 8)
 		return -1;
 
 	for (i = 0, deci = 1; i < len; i++, deci *= 10) {
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index c463162..c8a3f86 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -3141,7 +3141,7 @@ isdn_tty_cmd_PLUSF(char **p, modem_info * info)
 	atemu *m = &info->emu;
 	char rs[20];
 
-	if (!strncmp(p[0], "CLASS", 5)) {
+	if (!memcmp(p[0], "CLASS", 5)) {
 		p[0] += 5;
 		switch (*p[0]) {
 			case '?':
@@ -3246,7 +3246,7 @@ isdn_tty_cmd_PLUSV(char **p, modem_info * info)
 
 	i = 0;
 	while (vcmd[i]) {
-		if (!strncmp(vcmd[i], p[0], 2)) {
+		if (!memcmp(vcmd[i], p[0], 2)) {
 			p[0] += 2;
 			break;
 		}
@@ -3746,7 +3746,7 @@ isdn_tty_edit_at(const char *p, int count, modem_info * info)
 				eb[1] = 0;
 				isdn_tty_at_cout(eb, info);
 			}
-			if ((m->mdmcmdl >= 2) && (!(strncmp(m->mdmcmd, "AT", 2))))
+			if ((m->mdmcmdl >= 2) && (!(memcmp(m->mdmcmd, "AT", 2))))
 				isdn_tty_parse_at(info);
 			m->mdmcmdl = 0;
 			continue;
diff --git a/drivers/isdn/i4l/isdn_ttyfax.c b/drivers/isdn/i4l/isdn_ttyfax.c
index 4c41f19..44c8233 100644
--- a/drivers/isdn/i4l/isdn_ttyfax.c
+++ b/drivers/isdn/i4l/isdn_ttyfax.c
@@ -326,7 +326,7 @@ isdn_tty_cmd_FCLASS1(char **p, modem_info * info)
 	u_long flags;
 
 	for (c.parm.aux.cmd = 0; c.parm.aux.cmd < 7; c.parm.aux.cmd++)
-		if (!strncmp(p[0], cmd[c.parm.aux.cmd], 2))
+		if (!memcmp(p[0], cmd[c.parm.aux.cmd], 2))
 			break;
 
 #ifdef ISDN_TTY_FAX_CMD_DEBUG
@@ -421,7 +421,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 	{1, 5, 2, 2, 3, 2, 0, 7};
 
 	/* FAA still unchanged */
-	if (!strncmp(p[0], "AA", 2)) {	/* TODO */
+	if (!memcmp(p[0], "AA", 2)) {	/* TODO */
 		p[0] += 2;
 		switch (*p[0]) {
 			case '?':
@@ -441,7 +441,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* BADLIN=value - dummy 0=disable errorchk disabled, 1-255 nr. of lines for making page bad */
-	if (!strncmp(p[0], "BADLIN", 6)) {
+	if (!memcmp(p[0], "BADLIN", 6)) {
 		p[0] += 6;
 		switch (*p[0]) {
 			case '?':
@@ -471,7 +471,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* BADMUL=value - dummy 0=disable errorchk disabled (threshold multiplier) */
-	if (!strncmp(p[0], "BADMUL", 6)) {
+	if (!memcmp(p[0], "BADMUL", 6)) {
 		p[0] += 6;
 		switch (*p[0]) {
 			case '?':
@@ -501,7 +501,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* BOR=n - Phase C bit order, 0=direct, 1=reverse */
-	if (!strncmp(p[0], "BOR", 3)) {
+	if (!memcmp(p[0], "BOR", 3)) {
 		p[0] += 3;
 		switch (*p[0]) {
 			case '?':
@@ -531,7 +531,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* NBC=n - No Best Capabilities */
-	if (!strncmp(p[0], "NBC", 3)) {
+	if (!memcmp(p[0], "NBC", 3)) {
 		p[0] += 3;
 		switch (*p[0]) {
 			case '?':
@@ -561,7 +561,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* BUF? - Readonly buffersize readout  */
-	if (!strncmp(p[0], "BUF?", 4)) {
+	if (!memcmp(p[0], "BUF?", 4)) {
 		p[0] += 4;
 #ifdef ISDN_TTY_FAX_STAT_DEBUG
 		printk(KERN_DEBUG "isdn_tty: Fax FBUF? (%d) \n", (16 * m->mdmreg[REG_PSIZE]));
@@ -572,7 +572,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* CIG=string - local fax station id string for polling rx */
-	if (!strncmp(p[0], "CIG", 3)) {
+	if (!memcmp(p[0], "CIG", 3)) {
 		int i, r;
 		p[0] += 3;
 		switch (*p[0]) {
@@ -610,7 +610,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* CQ=n - copy qlty chk, 0= no chk, 1=only 1D chk, 2=1D+2D chk */
-	if (!strncmp(p[0], "CQ", 2)) {
+	if (!memcmp(p[0], "CQ", 2)) {
 		p[0] += 2;
 		switch (*p[0]) {
 			case '?':
@@ -640,7 +640,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* CR=n - can receive? 0= no data rx or poll remote dev, 1=do receive data or poll remote dev */
-	if (!strncmp(p[0], "CR", 2)) {
+	if (!memcmp(p[0], "CR", 2)) {
 		p[0] += 2;
 		switch (*p[0]) {
 			case '?':
@@ -670,7 +670,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* CTCRTY=value - ECM retry count */
-	if (!strncmp(p[0], "CTCRTY", 6)) {
+	if (!memcmp(p[0], "CTCRTY", 6)) {
 		p[0] += 6;
 		switch (*p[0]) {
 			case '?':
@@ -700,7 +700,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* DCC=vr,br,wd,ln,df,ec,bf,st - DCE capabilities parms */
-	if (!strncmp(p[0], "DCC", 3)) {
+	if (!memcmp(p[0], "DCC", 3)) {
 		char *rp = &f->resolution;
 		int i;
 
@@ -746,7 +746,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* DIS=vr,br,wd,ln,df,ec,bf,st - current session parms */
-	if (!strncmp(p[0], "DIS", 3)) {
+	if (!memcmp(p[0], "DIS", 3)) {
 		char *rp = &f->resolution;
 		int i;
 
@@ -792,7 +792,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* DR - Receive Phase C data command, initiates document reception */
-	if (!strncmp(p[0], "DR", 2)) {
+	if (!memcmp(p[0], "DR", 2)) {
 		p[0] += 2;
 		if ((info->faxonline & 16) &&	/* incoming connection */
 		    ((f->phase == ISDN_FAX_PHASE_B) || (f->phase == ISDN_FAX_PHASE_D))) {
@@ -828,7 +828,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 1;
 	}
 	/* DT=df,vr,wd,ln - TX phase C data command (release DCE to proceed with negotiation) */
-	if (!strncmp(p[0], "DT", 2)) {
+	if (!memcmp(p[0], "DT", 2)) {
 		int i, val[] =
 		{4, 0, 2, 3};
 		char *rp = &f->resolution;
@@ -869,7 +869,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 1;
 	}
 	/* ECM=n - Error mode control 0=disabled, 2=enabled, handled by DCE alone incl. buff of partial pages */
-	if (!strncmp(p[0], "ECM", 3)) {
+	if (!memcmp(p[0], "ECM", 3)) {
 		p[0] += 3;
 		switch (*p[0]) {
 			case '?':
@@ -899,7 +899,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* ET=n - End of page or document */
-	if (!strncmp(p[0], "ET=", 3)) {
+	if (!memcmp(p[0], "ET=", 3)) {
 		p[0] += 3;
 		if (*p[0] == '?') {
 			p[0]++;
@@ -926,7 +926,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* K - terminate */
-	if (!strncmp(p[0], "K", 1)) {
+	if (!memcmp(p[0], "K", 1)) {
 		p[0] += 1;
 		if ((f->phase == ISDN_FAX_PHASE_IDLE) || (f->phase == ISDN_FAX_PHASE_E))
 			PARSE_ERROR1;
@@ -934,7 +934,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 1;
 	}
 	/* LID=string - local fax ID */
-	if (!strncmp(p[0], "LID", 3)) {
+	if (!memcmp(p[0], "LID", 3)) {
 		int i, r;
 		p[0] += 3;
 		switch (*p[0]) {
@@ -973,7 +973,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 	}
 
 	/* MDL? - DCE Model       */
-	if (!strncmp(p[0], "MDL?", 4)) {
+	if (!memcmp(p[0], "MDL?", 4)) {
 		p[0] += 4;
 #ifdef ISDN_TTY_FAX_STAT_DEBUG
 		printk(KERN_DEBUG "isdn_tty: FMDL?\n");
@@ -982,7 +982,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* MFR? - DCE Manufacturer */
-	if (!strncmp(p[0], "MFR?", 4)) {
+	if (!memcmp(p[0], "MFR?", 4)) {
 		p[0] += 4;
 #ifdef ISDN_TTY_FAX_STAT_DEBUG
 		printk(KERN_DEBUG "isdn_tty: FMFR?\n");
@@ -991,7 +991,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* MINSP=n - Minimum Speed for Phase C */
-	if (!strncmp(p[0], "MINSP", 5)) {
+	if (!memcmp(p[0], "MINSP", 5)) {
 		p[0] += 5;
 		switch (*p[0]) {
 			case '?':
@@ -1021,7 +1021,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* PHCTO=value - DTE phase C timeout */
-	if (!strncmp(p[0], "PHCTO", 5)) {
+	if (!memcmp(p[0], "PHCTO", 5)) {
 		p[0] += 5;
 		switch (*p[0]) {
 			case '?':
@@ -1052,7 +1052,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 	}
 
 	/* REL=n - Phase C received EOL alignment */
-	if (!strncmp(p[0], "REL", 3)) {
+	if (!memcmp(p[0], "REL", 3)) {
 		p[0] += 3;
 		switch (*p[0]) {
 			case '?':
@@ -1082,7 +1082,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		return 0;
 	}
 	/* REV? - DCE Revision */
-	if (!strncmp(p[0], "REV?", 4)) {
+	if (!memcmp(p[0], "REV?", 4)) {
 		p[0] += 4;
 #ifdef ISDN_TTY_FAX_STAT_DEBUG
 		printk(KERN_DEBUG "isdn_tty: FREV?\n");
@@ -1094,7 +1094,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 	}
 
 	/* Phase C Transmit Data Block Size */
-	if (!strncmp(p[0], "TBC=", 4)) {	/* dummy, not used */
+	if (!memcmp(p[0], "TBC=", 4)) {	/* dummy, not used */
 		p[0] += 4;
 #ifdef ISDN_TTY_FAX_STAT_DEBUG
 		printk(KERN_DEBUG "isdn_tty: Fax FTBC=%c\n", *p[0]);
diff --git a/drivers/isdn/icn/icn.c b/drivers/isdn/icn/icn.c
index 2e847a9..103a864 100644
--- a/drivers/isdn/icn/icn.c
+++ b/drivers/isdn/icn/icn.c
@@ -453,7 +453,7 @@ icn_parse_status(u_char * status, int channel, icn_card * card)
 	isdn_ctrl cmd;
 
 	while (s->statstr) {
-		if (!strncmp(status, s->statstr, strlen(s->statstr))) {
+		if (!memcmp(status, s->statstr, strlen(s->statstr))) {
 			cmd.command = s->command;
 			action = s->action;
 			break;
@@ -630,18 +630,18 @@ icn_polldchan(unsigned long data)
 					icn_parse_status(p, ch, card);
 				} else {
 					p = card->imsg;
-					if (!strncmp(p, "DRV1.", 5)) {
+					if (!memcmp(p, "DRV1.", 5)) {
 						u_char vstr[10];
 						u_char *q = vstr;
 
 						printk(KERN_INFO "icn: (%s) %s\n", CID, p);
-						if (!strncmp(p + 7, "TC", 2)) {
+						if (!memcmp(p + 7, "TC", 2)) {
 							card->ptype = ISDN_PTYPE_1TR6;
 							card->interface.features |= ISDN_FEATURE_P_1TR6;
 							printk(KERN_INFO
 							       "icn: (%s) 1TR6-Protocol loaded and running\n", CID);
 						}
-						if (!strncmp(p + 7, "EC", 2)) {
+						if (!memcmp(p + 7, "EC", 2)) {
 							card->ptype = ISDN_PTYPE_EURO;
 							card->interface.features |= ISDN_FEATURE_P_EURO;
 							printk(KERN_INFO
diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index b8a1098..51189c0 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -190,7 +190,7 @@ isdnloop_parse_status(u_char * status, int channel, isdnloop_card * card)
 	isdn_ctrl cmd;
 
 	while (s->statstr) {
-		if (!strncmp(status, s->statstr, strlen(s->statstr))) {
+		if (!memcmp(status, s->statstr, strlen(s->statstr))) {
 			cmd.command = s->command;
 			action = s->action;
 			break;
@@ -341,15 +341,15 @@ isdnloop_polldchan(unsigned long data)
 				isdnloop_parse_status(p, ch, card);
 			} else {
 				p = card->imsg;
-				if (!strncmp(p, "DRV1.", 5)) {
+				if (!memcmp(p, "DRV1.", 5)) {
 					printk(KERN_INFO "isdnloop: (%s) %s\n", CID, p);
-					if (!strncmp(p + 7, "TC", 2)) {
+					if (!memcmp(p + 7, "TC", 2)) {
 						card->ptype = ISDN_PTYPE_1TR6;
 						card->interface.features |= ISDN_FEATURE_P_1TR6;
 						printk(KERN_INFO
 						       "isdnloop: (%s) 1TR6-Protocol loaded and running\n", CID);
 					}
-					if (!strncmp(p + 7, "EC", 2)) {
+					if (!memcmp(p + 7, "EC", 2)) {
 						card->ptype = ISDN_PTYPE_EURO;
 						card->interface.features |= ISDN_FEATURE_P_EURO;
 						printk(KERN_INFO
@@ -800,7 +800,7 @@ isdnloop_parse_cmd(isdnloop_card * card)
 	}
 	p += 3;
 	while (s->statstr) {
-		if (!strncmp(p, s->statstr, strlen(s->statstr))) {
+		if (!memcmp(p, s->statstr, strlen(s->statstr))) {
 			action = s->action;
 			if (s->command && (ch != 0)) {
 				isdnloop_fake_err(card);
diff --git a/drivers/isdn/sc/init.c b/drivers/isdn/sc/init.c
index ca710ab..307a0d8 100644
--- a/drivers/isdn/sc/init.c
+++ b/drivers/isdn/sc/init.c
@@ -540,9 +540,9 @@ static int identify_board(unsigned long rambase, unsigned int iobase)
 		 hwci.st_u_sense ? "S/T" : "U", hwci.ram_size,
 		 hwci.serial_no, hwci.part_no, hwci.rev_no);
 
-	if(!strncmp(PRI_PARTNO, hwci.part_no, 6))
+	if(!memcmp(PRI_PARTNO, hwci.part_no, 6))
 		return PRI_BOARD;
-	if(!strncmp(BRI_PARTNO, hwci.part_no, 6))
+	if(!memcmp(BRI_PARTNO, hwci.part_no, 6))
 		return BRI_BOARD;
 		
 	return -1;
diff --git a/drivers/leds/leds-88pm860x.c b/drivers/leds/leds-88pm860x.c
index e672b44..17d81b9 100644
--- a/drivers/leds/leds-88pm860x.c
+++ b/drivers/leds/leds-88pm860x.c
@@ -162,7 +162,7 @@ static int __check_device(struct pm860x_led_pdata *pdata, char *name)
 		if ((p->id != PM8606_ID_LED) || (p->flags < 0))
 			break;
 
-		if (!strncmp(name, pm860x_led_name[p->flags],
+		if (!memcmp(name, pm860x_led_name[p->flags],
 			MFD_NAME_SIZE)) {
 			ret = (int)p->flags;
 			break;
diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
index 19dc4b6..e12454c 100644
--- a/drivers/leds/leds-bd2802.c
+++ b/drivers/leds/leds-bd2802.c
@@ -469,9 +469,9 @@ static ssize_t bd2802_store_adv_conf(struct device *dev,
 		return -EINVAL;
 
 	down_write(&led->rwsem);
-	if (!led->adf_on && !strncmp(buf, "on", 2))
+	if (!led->adf_on && !memcmp(buf, "on", 2))
 		bd2802_enable_adv_conf(led);
-	else if (led->adf_on && !strncmp(buf, "off", 3))
+	else if (led->adf_on && !memcmp(buf, "off", 3))
 		bd2802_disable_adv_conf(led);
 	up_write(&led->rwsem);
 
diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 33facd0..b85eefd 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -459,11 +459,11 @@ static ssize_t store_engine_mode(struct device *dev,
 	struct lp5521_engine *engine = &chip->engines[nr - 1];
 	mutex_lock(&chip->lock);
 
-	if (!strncmp(buf, "run", 3))
+	if (!memcmp(buf, "run", 3))
 		lp5521_set_mode(engine, LP5521_CMD_RUN);
-	else if (!strncmp(buf, "load", 4))
+	else if (!memcmp(buf, "load", 4))
 		lp5521_set_mode(engine, LP5521_CMD_LOAD);
-	else if (!strncmp(buf, "disabled", 8))
+	else if (!memcmp(buf, "disabled", 8))
 		lp5521_set_mode(engine, LP5521_CMD_DISABLED);
 
 	mutex_unlock(&chip->lock);
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 0cc4ead..109b7f1 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -628,11 +628,11 @@ static ssize_t store_engine_mode(struct device *dev,
 	struct lp5523_engine *engine = &chip->engines[nr - 1];
 	mutex_lock(&chip->lock);
 
-	if (!strncmp(buf, "run", 3))
+	if (!memcmp(buf, "run", 3))
 		lp5523_set_mode(engine, LP5523_CMD_RUN);
-	else if (!strncmp(buf, "load", 4))
+	else if (!memcmp(buf, "load", 4))
 		lp5523_set_mode(engine, LP5523_CMD_LOAD);
-	else if (!strncmp(buf, "disabled", 8))
+	else if (!memcmp(buf, "disabled", 8))
 		lp5523_set_mode(engine, LP5523_CMD_DISABLED);
 
 	mutex_unlock(&chip->lock);
diff --git a/drivers/leds/leds-net5501.c b/drivers/leds/leds-net5501.c
index 1739557..91144fb 100644
--- a/drivers/leds/leds-net5501.c
+++ b/drivers/leds/leds-net5501.c
@@ -71,13 +71,13 @@ static int __init soekris_init(void)
 
 	bios = rombase + 0x20;	/* null terminated */
 
-	if (strncmp(bios, "comBIOS", 7))
+	if (memcmp(bios, "comBIOS", 7))
 		goto unmap;
 
 	for (i = 0; i < ARRAY_SIZE(boards); i++) {
 		unsigned char *model = rombase + boards[i].offset;
 
-		if (strncmp(model, boards[i].sig, boards[i].len) == 0) {
+		if (memcmp(model, boards[i].sig, boards[i].len) == 0) {
 			printk(KERN_INFO "Soekris %s: %s\n", model, bios);
 
 			if (boards[i].init)
diff --git a/drivers/macintosh/macio_asic.c b/drivers/macintosh/macio_asic.c
index b6e7ddc..49fe363 100644
--- a/drivers/macintosh/macio_asic.c
+++ b/drivers/macintosh/macio_asic.c
@@ -434,9 +434,9 @@ static struct macio_dev * macio_add_one_device(struct macio_chip *chip,
 
 static int macio_skip_device(struct device_node *np)
 {
-	if (strncmp(np->name, "battery", 7) == 0)
+	if (memcmp(np->name, "battery", 7) == 0)
 		return 1;
-	if (strncmp(np->name, "escc-legacy", 11) == 0)
+	if (memcmp(np->name, "escc-legacy", 11) == 0)
 		return 1;
 	return 0;
 }
@@ -485,9 +485,9 @@ static void macio_pci_add_devices(struct macio_chip *chip)
 					    root_res);
 		if (mdev == NULL)
 			of_node_put(np);
-		else if (strncmp(np->name, "media-bay", 9) == 0)
+		else if (memcmp(np->name, "media-bay", 9) == 0)
 			mbdev = mdev;
-		else if (strncmp(np->name, "escc", 4) == 0)
+		else if (memcmp(np->name, "escc", 4) == 0)
 			sdev = mdev;
 	}
 
diff --git a/drivers/macintosh/therm_adt746x.c b/drivers/macintosh/therm_adt746x.c
index 9e3e2c5..14cf0d2 100644
--- a/drivers/macintosh/therm_adt746x.c
+++ b/drivers/macintosh/therm_adt746x.c
@@ -136,7 +136,7 @@ attach_thermostat(struct i2c_adapter *adapter)
 	struct i2c_board_info info;
 	struct i2c_client *client;
 
-	if (strncmp(adapter->name, "uni-n", 5))
+	if (memcmp(adapter->name, "uni-n", 5))
 		return -ENODEV;
 	bus_no = simple_strtoul(adapter->name + 6, NULL, 10);
 	if (bus_no != therm_bus)
diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index c89f396..7270bd3 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -314,7 +314,7 @@ do_attach( struct i2c_adapter *adapter )
 		I2C_CLIENT_END
 	};
 
-	if( strncmp(adapter->name, "uni-n", 5) )
+	if( memcmp(adapter->name, "uni-n", 5) )
 		return 0;
 
 	if( !x.running ) {
diff --git a/drivers/macintosh/via-pmu-led.c b/drivers/macintosh/via-pmu-led.c
index 19c3718..dbbf852 100644
--- a/drivers/macintosh/via-pmu-led.c
+++ b/drivers/macintosh/via-pmu-led.c
@@ -96,8 +96,8 @@ static int __init via_pmu_led_init(void)
 		of_node_put(dt);
 		return -ENODEV;
 	}
-	if (strncmp(model, "PowerBook", strlen("PowerBook")) != 0 &&
-	    strncmp(model, "iBook", strlen("iBook")) != 0 &&
+	if (memcmp(model, "PowerBook", strlen("PowerBook")) != 0 &&
+	    memcmp(model, "iBook", strlen("iBook")) != 0 &&
 	    strcmp(model, "PowerMac7,2") != 0 &&
 	    strcmp(model, "PowerMac7,3") != 0) {
 		of_node_put(dt);
diff --git a/drivers/macintosh/windfarm_pm112.c b/drivers/macintosh/windfarm_pm112.c
index e0ee807..f3a46be 100644
--- a/drivers/macintosh/windfarm_pm112.c
+++ b/drivers/macintosh/windfarm_pm112.c
@@ -598,13 +598,13 @@ static void pm112_new_sensor(struct wf_sensor *sr)
 {
 	unsigned int i;
 
-	if (!strncmp(sr->name, "cpu-temp-", 9)) {
+	if (!memcmp(sr->name, "cpu-temp-", 9)) {
 		i = sr->name[9] - '0';
 		if (sr->name[10] == 0 && i < NR_CORES &&
 		    sens_cpu_temp[i] == NULL && wf_get_sensor(sr) == 0)
 			sens_cpu_temp[i] = sr;
 
-	} else if (!strncmp(sr->name, "cpu-power-", 10)) {
+	} else if (!memcmp(sr->name, "cpu-power-", 10)) {
 		i = sr->name[10] - '0';
 		if (sr->name[11] == 0 && i < NR_CORES &&
 		    sens_cpu_power[i] == NULL && wf_get_sensor(sr) == 0)
diff --git a/drivers/macintosh/windfarm_smu_sat.c b/drivers/macintosh/windfarm_smu_sat.c
index 65a8ff3..49c6428 100644
--- a/drivers/macintosh/windfarm_smu_sat.c
+++ b/drivers/macintosh/windfarm_smu_sat.c
@@ -267,7 +267,7 @@ static int wf_sat_probe(struct i2c_client *client,
 		index = *reg - 0x30;
 
 		/* expect location to be CPU [AB][01] ... */
-		if (strncmp(loc, "CPU ", 4) != 0)
+		if (memcmp(loc, "CPU ", 4) != 0)
 			continue;
 		chip = loc[4] - 'A';
 		core = loc[5] - '0';
diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 5a1ffe3..7b125f7 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1857,7 +1857,7 @@ location_store(mddev_t *mddev, const char *buf, size_t len)
 	if (mddev->bitmap || mddev->bitmap_info.file ||
 	    mddev->bitmap_info.offset) {
 		/* bitmap already configured.  Only option is to clear it */
-		if (strncmp(buf, "none", 4) != 0)
+		if (memcmp(buf, "none", 4) != 0)
 			return -EBUSY;
 		if (mddev->pers) {
 			mddev->pers->quiesce(mddev, 1);
@@ -1874,9 +1874,9 @@ location_store(mddev_t *mddev, const char *buf, size_t len)
 	} else {
 		/* No bitmap, OK to set a location */
 		long long offset;
-		if (strncmp(buf, "none", 4) == 0)
+		if (memcmp(buf, "none", 4) == 0)
 			/* nothing to be done */;
-		else if (strncmp(buf, "file:", 5) == 0) {
+		else if (memcmp(buf, "file:", 5) == 0) {
 			/* Not supported yet */
 			return -EINVAL;
 		} else {
@@ -2031,9 +2031,9 @@ static ssize_t metadata_store(mddev_t *mddev, const char *buf, size_t len)
 	    mddev->bitmap_info.file ||
 	    mddev->bitmap_info.offset)
 		return -EBUSY;
-	if (strncmp(buf, "external", 8) == 0)
+	if (memcmp(buf, "external", 8) == 0)
 		mddev->bitmap_info.external = 1;
-	else if (strncmp(buf, "internal", 8) == 0)
+	else if (memcmp(buf, "internal", 8) == 0)
 		mddev->bitmap_info.external = 0;
 	else
 		return -EINVAL;
@@ -2058,9 +2058,9 @@ static ssize_t can_clear_store(mddev_t *mddev, const char *buf, size_t len)
 {
 	if (mddev->bitmap == NULL)
 		return -ENOENT;
-	if (strncmp(buf, "false", 5) == 0)
+	if (memcmp(buf, "false", 5) == 0)
 		mddev->bitmap->need_sync = 1;
-	else if (strncmp(buf, "true", 4) == 0) {
+	else if (memcmp(buf, "true", 4) == 0) {
 		if (mddev->degraded)
 			return -EBUSY;
 		mddev->bitmap->need_sync = 0;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 84c46a1..d9234c3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2432,7 +2432,7 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 	int err;
 	char nm[20];
 	int slot = simple_strtoul(buf, &e, 10);
-	if (strncmp(buf, "none", 4)==0)
+	if (memcmp(buf, "none", 4)==0)
 		slot = -1;
 	else if (e==buf || (*e && *e!= '\n'))
 		return -EINVAL;
@@ -3677,7 +3677,7 @@ metadata_store(mddev_t *mddev, const char *buf, size_t len)
 	 * always permitted.  Otherwise there must be
 	 * no devices attached to the array.
 	 */
-	if (mddev->external && strncmp(buf, "external:", 9) == 0)
+	if (mddev->external && memcmp(buf, "external:", 9) == 0)
 		;
 	else if (!list_empty(&mddev->disks))
 		return -EBUSY;
@@ -3689,7 +3689,7 @@ metadata_store(mddev_t *mddev, const char *buf, size_t len)
 		mddev->minor_version = 90;
 		return len;
 	}
-	if (strncmp(buf, "external:", 9) == 0) {
+	if (memcmp(buf, "external:", 9) == 0) {
 		size_t namelen = len-9;
 		if (namelen >= sizeof(mddev->metadata_type))
 			namelen = sizeof(mddev->metadata_type)-1;
@@ -3818,7 +3818,7 @@ sync_min_store(mddev_t *mddev, const char *buf, size_t len)
 {
 	int min;
 	char *e;
-	if (strncmp(buf, "system", 6)==0) {
+	if (memcmp(buf, "system", 6)==0) {
 		mddev->sync_speed_min = 0;
 		return len;
 	}
@@ -3844,7 +3844,7 @@ sync_max_store(mddev_t *mddev, const char *buf, size_t len)
 {
 	int max;
 	char *e;
-	if (strncmp(buf, "system", 6)==0) {
+	if (memcmp(buf, "system", 6)==0) {
 		mddev->sync_speed_max = 0;
 		return len;
 	}
@@ -3972,7 +3972,7 @@ max_sync_show(mddev_t *mddev, char *page)
 static ssize_t
 max_sync_store(mddev_t *mddev, const char *buf, size_t len)
 {
-	if (strncmp(buf, "max", 3) == 0)
+	if (memcmp(buf, "max", 3) == 0)
 		mddev->resync_max = MaxSector;
 	else {
 		unsigned long long max;
@@ -4104,7 +4104,7 @@ array_size_store(mddev_t *mddev, const char *buf, size_t len)
 {
 	sector_t sectors;
 
-	if (strncmp(buf, "default", 7) == 0) {
+	if (memcmp(buf, "default", 7) == 0) {
 		if (mddev->pers)
 			sectors = mddev->pers->size(mddev, 0, 0);
 		else
@@ -4370,7 +4370,7 @@ static int add_named_array(const char *val, struct kernel_param *kp)
 	if (len >= DISK_NAME_LEN)
 		return -E2BIG;
 	strlcpy(buf, val, len+1);
-	if (strncmp(buf, "md_", 3) != 0)
+	if (memcmp(buf, "md_", 3) != 0)
 		return -EINVAL;
 	return md_alloc(0, buf);
 }
diff --git a/drivers/media/dvb/bt8xx/dst.c b/drivers/media/dvb/bt8xx/dst.c
index caa4e18..8239b40 100644
--- a/drivers/media/dvb/bt8xx/dst.c
+++ b/drivers/media/dvb/bt8xx/dst.c
@@ -486,11 +486,11 @@ static int dst_set_symbolrate(struct dst_state *state, u32 srate)
 		}
 	} else if (state->dst_type == DST_TYPE_IS_CABLE) {
 		dprintk(verbose, DST_DEBUG, 1, "%s", state->fw_name);
-		if (!strncmp(state->fw_name, "DCTNEW", 6)) {
+		if (!memcmp(state->fw_name, "DCTNEW", 6)) {
 			state->tx_tuna[5] = (u8) (srate >> 8);
 			state->tx_tuna[6] = (u8) srate;
 			state->tx_tuna[7] = 0x00;
-		} else if (!strncmp(state->fw_name, "DCT-CI", 6)) {
+		} else if (!memcmp(state->fw_name, "DCT-CI", 6)) {
 			state->tx_tuna[5] = 0x00;
 			state->tx_tuna[6] = (u8) (srate >> 8);
 			state->tx_tuna[7] = (u8) srate;
@@ -519,9 +519,9 @@ static int dst_set_modulation(struct dst_state *state, fe_modulation_t modulatio
 		state->tx_tuna[8] = 0x80;
 		break;
 	case QAM_256:
-		if (!strncmp(state->fw_name, "DCTNEW", 6))
+		if (!memcmp(state->fw_name, "DCTNEW", 6))
 			state->tx_tuna[8] = 0xff;
-		else if (!strncmp(state->fw_name, "DCT-CI", 6))
+		else if (!memcmp(state->fw_name, "DCT-CI", 6))
 			state->tx_tuna[8] = 0x00;
 		break;
 	case QPSK:
@@ -1070,7 +1070,7 @@ static int dst_get_tuner_info(struct dst_state *state)
 
 	return 0;
 force:
-	if (!strncmp(state->fw_name, "DCT-CI", 6)) {
+	if (!memcmp(state->fw_name, "DCT-CI", 6)) {
 		state->type_flags |= DST_TYPE_HAS_TS204;
 		dprintk(verbose, DST_ERROR, 1, "Forcing [%s] to TS188", state->fw_name);
 	}
@@ -1117,7 +1117,7 @@ static int dst_get_device_id(struct dst_state *state)
 	state->rxbuffer[7] = '\0';
 
 	for (i = 0, p_dst_type = dst_tlist; i < ARRAY_SIZE(dst_tlist); i++, p_dst_type++) {
-		if (!strncmp (&state->rxbuffer[p_dst_type->offset], p_dst_type->device_id, strlen (p_dst_type->device_id))) {
+		if (!memcmp (&state->rxbuffer[p_dst_type->offset], p_dst_type->device_id, strlen (p_dst_type->device_id))) {
 			use_type_flags = p_dst_type->type_flags;
 			use_dst_type = p_dst_type->dst_type;
 
@@ -1145,7 +1145,7 @@ static int dst_get_device_id(struct dst_state *state)
 				state->tuner_type = p_dst_type->tuner_type;
 			}
 			for (j = 0, p_tuner_list = tuner_list; j < ARRAY_SIZE(tuner_list); j++, p_tuner_list++) {
-				if (!(strncmp(p_dst_type->device_id, p_tuner_list->fw_name, 7)) &&
+				if (!(memcmp(p_dst_type->device_id, p_tuner_list->fw_name, 7)) &&
 					p_tuner_list->tuner_type == state->tuner_type) {
 					dprintk(verbose, DST_ERROR, 1, "[%s] has a [%s]",
 						p_dst_type->device_id, p_tuner_list->tuner_name);
diff --git a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
index 7ea517b..475012d 100644
--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
@@ -180,7 +180,7 @@ static char *findstr(char * haystack, int hlen, char * needle, int nlen)
 		return NULL;
 
 	for (i = 0; i <= hlen - nlen; i++) {
-		if (!strncmp(haystack + i, needle, nlen))
+		if (!memcmp(haystack + i, needle, nlen))
 			return haystack + i;
 	}
 
@@ -486,7 +486,7 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 		return -EINVAL;
 
 	/* is it a version we support? */
-	if (strncmp(dvb_str + 8, "1.00", 4)) {
+	if (memcmp(dvb_str + 8, "1.00", 4)) {
 		printk("dvb_ca adapter %d: Unsupported DVB CAM module version %c%c%c%c\n",
 		       ca->dvbdev->adapter->num, dvb_str[8], dvb_str[9], dvb_str[10], dvb_str[11]);
 		return -EINVAL;
diff --git a/drivers/media/dvb/firewire/firedtv-dvb.c b/drivers/media/dvb/firewire/firedtv-dvb.c
index 079e8c5..3f06a1f 100644
--- a/drivers/media/dvb/firewire/firedtv-dvb.c
+++ b/drivers/media/dvb/firewire/firedtv-dvb.c
@@ -282,7 +282,7 @@ struct firedtv *fdtv_alloc(struct device *dev,
 
 	for (i = ARRAY_SIZE(fdtv_model_names); --i; )
 		if (strlen(fdtv_model_names[i]) <= name_len &&
-		    strncmp(name, fdtv_model_names[i], name_len) == 0)
+		    memcmp(name, fdtv_model_names[i], name_len) == 0)
 			break;
 	fdtv->type = i;
 
diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 87d8b00..a618433 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -3007,9 +3007,9 @@ static void identify_by_eeprom(struct bttv *btv, unsigned char eeprom_data[256])
 {
 	int type = -1;
 
-	if (0 == strncmp(eeprom_data,"GET MM20xPCTV",13))
+	if (0 == memcmp(eeprom_data,"GET MM20xPCTV",13))
 		type = BTTV_BOARD_MODTEC_205;
-	else if (0 == strncmp(eeprom_data+20,"Picolo",7))
+	else if (0 == memcmp(eeprom_data+20,"Picolo",7))
 		type = BTTV_BOARD_EURESYS_PICOLO;
 	else if (eeprom_data[0] == 0x84 && eeprom_data[2]== 0)
 		type = BTTV_BOARD_HAUPPAUGE; /* old bt848 */
@@ -3679,15 +3679,15 @@ void __devinit bttv_init_tuner(struct bttv *btv)
 
 static void modtec_eeprom(struct bttv *btv)
 {
-	if( strncmp(&(eeprom_data[0x1e]),"Temic 4066 FY5",14) ==0) {
+	if( memcmp(&(eeprom_data[0x1e]),"Temic 4066 FY5",14) ==0) {
 		btv->tuner_type=TUNER_TEMIC_4066FY5_PAL_I;
 		printk("bttv%d: Modtec: Tuner autodetected by eeprom: %s\n",
 		       btv->c.nr,&eeprom_data[0x1e]);
-	} else if (strncmp(&(eeprom_data[0x1e]),"Alps TSBB5",10) ==0) {
+	} else if (memcmp(&(eeprom_data[0x1e]),"Alps TSBB5",10) ==0) {
 		btv->tuner_type=TUNER_ALPS_TSBB5_PAL_I;
 		printk("bttv%d: Modtec: Tuner autodetected by eeprom: %s\n",
 		       btv->c.nr,&eeprom_data[0x1e]);
-	} else if (strncmp(&(eeprom_data[0x1e]),"Philips FM1246",14) ==0) {
+	} else if (memcmp(&(eeprom_data[0x1e]),"Philips FM1246",14) ==0) {
 		btv->tuner_type=TUNER_PHILIPS_NTSC;
 		printk("bttv%d: Modtec: Tuner autodetected by eeprom: %s\n",
 		       btv->c.nr,&eeprom_data[0x1e]);
@@ -3836,7 +3836,7 @@ static void __devinit osprey_eeprom(struct bttv *btv, const u8 ee[256])
 	/* This code will nevery actually get called in this case.... */
 	if (btv->c.type == BTTV_BOARD_UNKNOWN) {
 		/* this might be an antique... check for MMAC label in eeprom */
-		if (!strncmp(ee, "MMAC", 4)) {
+		if (!memcmp(ee, "MMAC", 4)) {
 			u8 checksum = 0;
 			for (i = 0; i < 21; i++)
 				checksum += ee[i];
diff --git a/drivers/media/video/bt8xx/bttv-gpio.c b/drivers/media/video/bt8xx/bttv-gpio.c
index fd604d3..a74b284 100644
--- a/drivers/media/video/bt8xx/bttv-gpio.c
+++ b/drivers/media/video/bt8xx/bttv-gpio.c
@@ -43,7 +43,7 @@ static int bttv_sub_bus_match(struct device *dev, struct device_driver *drv)
 	struct bttv_sub_driver *sub = to_bttv_sub_drv(drv);
 	int len = strlen(sub->wanted);
 
-	if (0 == strncmp(dev_name(dev), sub->wanted, len))
+	if (0 == memcmp(dev_name(dev), sub->wanted, len))
 		return 1;
 	return 0;
 }
diff --git a/drivers/media/video/bw-qcam.c b/drivers/media/video/bw-qcam.c
index 935e0c9..b58915c 100644
--- a/drivers/media/video/bw-qcam.c
+++ b/drivers/media/video/bw-qcam.c
@@ -1021,7 +1021,7 @@ static int accept_bwqcam(struct parport *port)
 #ifdef MODULE
 	int n;
 
-	if (parport[0] && strncmp(parport[0], "auto", 4) != 0) {
+	if (parport[0] && memcmp(parport[0], "auto", 4) != 0) {
 		/* user gave parport parameters */
 		for (n = 0; n < MAX_CAMS && parport[n]; n++) {
 			char *ep;
diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index f3dc89d..e39367c 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -1021,7 +1021,7 @@ static ssize_t store_pan_tilt(struct device *class_dev,
 	int pan, tilt;
 	int ret = -EINVAL;
 
-	if (strncmp(buf, "reset", 5) == 0)
+	if (memcmp(buf, "reset", 5) == 0)
 		ret = pwc_mpt_reset(pdev, 0x3);
 
 	else if (sscanf(buf, "%d %d", &pan, &tilt) > 0)
diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index b5afe5f..c531e10 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -280,9 +280,9 @@ static ssize_t store_hflip(struct device *class,
 	struct video_device *vdev = to_video_device(class);
 	struct stk_camera *dev = vdev_to_camera(vdev);
 
-	if (strncmp(buf, "1", 1) == 0)
+	if (memcmp(buf, "1", 1) == 0)
 		dev->vsettings.hflip = 1;
-	else if (strncmp(buf, "0", 1) == 0)
+	else if (memcmp(buf, "0", 1) == 0)
 		dev->vsettings.hflip = 0;
 	else
 		return -EINVAL;
@@ -305,9 +305,9 @@ static ssize_t store_vflip(struct device *class,
 	struct video_device *vdev = to_video_device(class);
 	struct stk_camera *dev = vdev_to_camera(vdev);
 
-	if (strncmp(buf, "1", 1) == 0)
+	if (memcmp(buf, "1", 1) == 0)
 		dev->vsettings.vflip = 1;
-	else if (strncmp(buf, "0", 1) == 0)
+	else if (memcmp(buf, "0", 1) == 0)
 		dev->vsettings.vflip = 0;
 	else
 		return -EINVAL;
diff --git a/drivers/media/video/tlg2300/pd-dvb.c b/drivers/media/video/tlg2300/pd-dvb.c
index edd78f8..30014ec 100644
--- a/drivers/media/video/tlg2300/pd-dvb.c
+++ b/drivers/media/video/tlg2300/pd-dvb.c
@@ -390,7 +390,7 @@ static void dvb_urb_irq(struct urb *urb)
 		 * last packet contains 456 bytes tsp data
 		 */
 		for (offset = 456; offset < len; offset += 512) {
-			if (!strncmp(buf + offset, "DVHS", 4)) {
+			if (!memcmp(buf + offset, "DVHS", 4)) {
 				dvb_dmx_swfilter(demux, buf, offset);
 				if (len > offset + 52 + 4) {
 					/*16 bytes trailer + 36 bytes padding */
diff --git a/drivers/media/video/tlg2300/pd-video.c b/drivers/media/video/tlg2300/pd-video.c
index a1ffe18..7fb418c 100644
--- a/drivers/media/video/tlg2300/pd-video.c
+++ b/drivers/media/video/tlg2300/pd-video.c
@@ -281,7 +281,7 @@ static void check_trailer(struct video_data *video, char *src, int count)
 	buf = src + offset;
 
 	/* trailer : (VFHS) + U32 + U32 + field_num */
-	if (!strncmp(buf, "VFHS", 4)) {
+	if (!memcmp(buf, "VFHS", 4)) {
 		int field_num = *((u32 *)(buf + 12));
 
 		if ((field_num & 1) ^ video->field_count) {
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 9294282..23f4145 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -316,7 +316,7 @@ int v4l2_chip_match_i2c_client(struct i2c_client *c, const struct v4l2_dbg_match
 		/* legacy drivers have a ' suffix, don't try to match that */
 		if (len && c->driver->driver.name[len - 1] == '\'')
 			len--;
-		return len && !strncmp(c->driver->driver.name, match->name, len);
+		return len && !memcmp(c->driver->driver.name, match->name, len);
 	case V4L2_CHIP_MATCH_I2C_ADDR:
 		return c->addr == match->addr;
 	default:
diff --git a/drivers/media/video/v4l2-int-device.c b/drivers/media/video/v4l2-int-device.c
index a935bae..7ca1cd7 100644
--- a/drivers/media/video/v4l2-int-device.c
+++ b/drivers/media/video/v4l2-int-device.c
@@ -50,7 +50,7 @@ void v4l2_int_device_try_attach_all(void)
 
 			/* Slave wants to attach to master? */
 			if (s->u.slave->attach_to[0] != 0
-			    && strncmp(m->name, s->u.slave->attach_to,
+			    && memcmp(m->name, s->u.slave->attach_to,
 				       V4L2NAMESIZE))
 				continue;
 
diff --git a/drivers/media/video/zoran/zoran_procfs.c b/drivers/media/video/zoran/zoran_procfs.c
index f1423b7..ec7ea39 100644
--- a/drivers/media/video/zoran/zoran_procfs.c
+++ b/drivers/media/video/zoran/zoran_procfs.c
@@ -95,7 +95,7 @@ setparam (struct zoran *zr,
 	int i = 0, reg0, reg, val;
 
 	while (zr67[i].name != NULL) {
-		if (!strncmp(name, zr67[i].name, strlen(zr67[i].name))) {
+		if (!memcmp(name, zr67[i].name, strlen(zr67[i].name))) {
 			reg = reg0 = btread(zr67[i].reg);
 			reg &= ~(zr67[i].mask << zr67[i].bit);
 			if (!isdigit(sval[0]))
diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index 7cb9110..d90a715 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -460,7 +460,7 @@ static ssize_t sysfs_set_reg(struct device *dev,
 	int err;
 
 	if (reg & DPOT_ADDR_OTP_EN) {
-		if (!strncmp(buf, "enabled", sizeof("enabled")))
+		if (!memcmp(buf, "enabled", sizeof("enabled")))
 			set_bit(DPOT_RDAC_MASK & reg, data->otp_en_mask);
 		else
 			clear_bit(DPOT_RDAC_MASK & reg, data->otp_en_mask);
diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 00e5fca..9293aea 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -447,7 +447,7 @@ static ssize_t set_component_status(struct device *cdev,
 	int i;
 
 	for (i = 0; enclosure_status[i]; i++) {
-		if (strncmp(buf, enclosure_status[i],
+		if (memcmp(buf, enclosure_status[i],
 			    strlen(enclosure_status[i])) == 0 &&
 		    (buf[strlen(enclosure_status[i])] == '\n' ||
 		     buf[strlen(enclosure_status[i])] == '\0'))
diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 59c118c..d996e66 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -360,8 +360,8 @@ static void skip_back_repeat_test(char *arg)
 static int got_break(char *put_str, char *arg)
 {
 	test_complete = 1;
-	if (!strncmp(put_str+1, arg, 2)) {
-		if (!strncmp(arg, "T0", 2))
+	if (!memcmp(put_str+1, arg, 2)) {
+		if (!memcmp(arg, "T0", 2))
 			test_complete = 2;
 		return 0;
 	}
@@ -401,7 +401,7 @@ static void emul_sstep_get(char *arg)
 static int emul_sstep_put(char *put_str, char *arg)
 {
 	if (!arch_needs_sstep_emulation) {
-		if (!strncmp(put_str+1, arg, 2))
+		if (!memcmp(put_str+1, arg, 2))
 			return 0;
 		return 1;
 	}
@@ -418,19 +418,19 @@ static int emul_sstep_put(char *put_str, char *arg)
 			BREAK_INSTR_SIZE;
 		break;
 	case 2:
-		if (strncmp(put_str, "$OK", 3)) {
+		if (memcmp(put_str, "$OK", 3)) {
 			eprintk("kgdbts: failed sstep break set\n");
 			return 1;
 		}
 		break;
 	case 3:
-		if (strncmp(put_str, "$T0", 3)) {
+		if (memcmp(put_str, "$T0", 3)) {
 			eprintk("kgdbts: failed continue sstep\n");
 			return 1;
 		}
 		break;
 	case 4:
-		if (strncmp(put_str, "$OK", 3)) {
+		if (memcmp(put_str, "$OK", 3)) {
 			eprintk("kgdbts: failed sstep break unset\n");
 			return 1;
 		}
@@ -448,7 +448,7 @@ static int emul_sstep_put(char *put_str, char *arg)
 
 static int final_ack_set(char *put_str, char *arg)
 {
-	if (strncmp(put_str+1, arg, 2))
+	if (memcmp(put_str+1, arg, 2))
 		return 1;
 	final_ack = 1;
 	return 0;
diff --git a/drivers/mtd/ar7part.c b/drivers/mtd/ar7part.c
index 6697a1e..96a2e2f 100644
--- a/drivers/mtd/ar7part.c
+++ b/drivers/mtd/ar7part.c
@@ -74,7 +74,7 @@ static int create_mtd_partitions(struct mtd_info *master,
 		offset = pre_size;
 		master->read(master, offset,
 			     sizeof(header), &len, (uint8_t *)&header);
-		if (!strncmp((char *)&header, "TIENV0.8", 8))
+		if (!memcmp((char *)&header, "TIENV0.8", 8))
 			ar7_parts[1].offset = pre_size;
 		if (header.checksum == LOADER_MAGIC1)
 			break;
diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index e790f38..cecf88f 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -152,14 +152,14 @@ static struct mtd_partition * newpart(char *s,
 	extra_mem_size += name_len + 1;
 
         /* test for options */
-        if (strncmp(s, "ro", 2) == 0)
+        if (memcmp(s, "ro", 2) == 0)
 	{
 		mask_flags |= MTD_WRITEABLE;
 		s += 2;
         }
 
         /* if lk is found do NOT unlock the MTD partition*/
-        if (strncmp(s, "lk", 2) == 0)
+        if (memcmp(s, "lk", 2) == 0)
 	{
 		mask_flags |= MTD_POWERUP_LOCK;
 		s += 2;
diff --git a/drivers/mtd/maps/bcm963xx-flash.c b/drivers/mtd/maps/bcm963xx-flash.c
index d175c12..fdcb8ba 100644
--- a/drivers/mtd/maps/bcm963xx-flash.c
+++ b/drivers/mtd/maps/bcm963xx-flash.c
@@ -164,7 +164,7 @@ static int bcm963xx_detect_cfe(struct mtd_info *master)
 	buf[retlen] = 0;
 	printk(KERN_INFO PFX "Read Signature value of %s\n", buf);
 
-	return strncmp(idstring, buf, 8);
+	return memcmp(idstring, buf, 8);
 }
 
 static int bcm963xx_probe(struct platform_device *pdev)
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index c47620d..150bbaf 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -848,7 +848,7 @@ static int paranoid_check_volume(struct ubi_device *ubi, int vol_id)
 
 	if (alignment != vol->alignment || data_pad != vol->data_pad ||
 	    upd_marker != vol->upd_marker || vol_type != vol->vol_type ||
-	    name_len != vol->name_len || strncmp(name, vol->name, name_len)) {
+	    name_len != vol->name_len || memcmp(name, vol->name, name_len)) {
 		ubi_err("volume info is different");
 		goto fail;
 	}
diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index fcdb7f6..a0b429d 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -274,7 +274,7 @@ static int vtbl_check(const struct ubi_device *ubi,
 			int len2 = be16_to_cpu(vtbl[n].name_len);
 
 			if (len1 > 0 && len1 == len2 &&
-			    !strncmp(vtbl[i].name, vtbl[n].name, len1)) {
+			    !memcmp(vtbl[i].name, vtbl[n].name, len1)) {
 				ubi_err("volumes %d and %d have the same name"
 					" \"%s\"", i, n, vtbl[i].name);
 				ubi_dbg_dump_vtbl_record(&vtbl[i], i);
diff --git a/drivers/net/appletalk/ltpc.c b/drivers/net/appletalk/ltpc.c
index e69eead..541d2fc 100644
--- a/drivers/net/appletalk/ltpc.c
+++ b/drivers/net/appletalk/ltpc.c
@@ -1201,7 +1201,7 @@ static int __init ltpc_setup(char *str)
 	str = get_options(str, ARRAY_SIZE(ints), ints);
 
 	if (ints[0] == 0) {
-		if (str && !strncmp(str, "auto", 4)) {
+		if (str && !memcmp(str, "auto", 4)) {
 			/* do nothing :-) */
 		}
 		else {
diff --git a/drivers/net/bnx2x/bnx2x_main.c b/drivers/net/bnx2x/bnx2x_main.c
index 9709b85..60662e8 100644
--- a/drivers/net/bnx2x/bnx2x_main.c
+++ b/drivers/net/bnx2x/bnx2x_main.c
@@ -8321,8 +8321,8 @@ static void __devinit bnx2x_read_fwinfo(struct bnx2x *bp)
 	/* vendor specific info */
 	snprintf(str_id_reg, VENDOR_ID_LEN + 1, "%04x", PCI_VENDOR_ID_DELL);
 	snprintf(str_id_cap, VENDOR_ID_LEN + 1, "%04X", PCI_VENDOR_ID_DELL);
-	if (!strncmp(str_id_reg, &vpd_data[rodi], VENDOR_ID_LEN) ||
-	    !strncmp(str_id_cap, &vpd_data[rodi], VENDOR_ID_LEN)) {
+	if (!memcmp(str_id_reg, &vpd_data[rodi], VENDOR_ID_LEN) ||
+	    !memcmp(str_id_cap, &vpd_data[rodi], VENDOR_ID_LEN)) {
 
 		rodi = pci_vpd_find_info_keyword(vpd_data, i, block_end,
 						PCI_VPD_RO_KEYWORD_VENDOR0);
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 8fd0174..4caf449 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -85,7 +85,7 @@ static struct net_device *bond_get_by_name(struct net *net, const char *ifname)
 	struct bonding *bond;
 
 	list_for_each_entry(bond, &bn->dev_list, bond_list) {
-		if (strncmp(bond->dev->name, ifname, IFNAMSIZ) == 0)
+		if (memcmp(bond->dev->name, ifname, IFNAMSIZ) == 0)
 			return bond->dev;
 	}
 	return NULL;
diff --git a/drivers/net/caif/caif_spi.c b/drivers/net/caif/caif_spi.c
index 20da199..88a7380 100644
--- a/drivers/net/caif/caif_spi.c
+++ b/drivers/net/caif/caif_spi.c
@@ -649,7 +649,7 @@ int cfspi_spi_probe(struct platform_device *pdev)
 	cfspi->qd_high_mark = HIGH_WATER_MARK;
 
 	/* Set slave info. */
-	if (!strncmp(cfspi_spi_driver.driver.name, "cfspi_sspi", 10)) {
+	if (!memcmp(cfspi_spi_driver.driver.name, "cfspi_sspi", 10)) {
 		cfspi->slave = true;
 		cfspi->slave_talked = false;
 	} else {
diff --git a/drivers/net/enic/vnic_dev.c b/drivers/net/enic/vnic_dev.c
index fb35d8b..3ec3548 100644
--- a/drivers/net/enic/vnic_dev.c
+++ b/drivers/net/enic/vnic_dev.c
@@ -428,9 +428,9 @@ int vnic_dev_hw_version(struct vnic_dev *vdev, enum vnic_dev_hw_version *hw_ver)
 	if (err)
 		return err;
 
-	if (strncmp(fw_info->hw_version, "A1", sizeof("A1")) == 0)
+	if (memcmp(fw_info->hw_version, "A1", sizeof("A1")) == 0)
 		*hw_ver = VNIC_DEV_HW_VER_A1;
-	else if (strncmp(fw_info->hw_version, "A2", sizeof("A2")) == 0)
+	else if (memcmp(fw_info->hw_version, "A2", sizeof("A2")) == 0)
 		*hw_ver = VNIC_DEV_HW_VER_A2;
 	else
 		*hw_ver = VNIC_DEV_HW_VER_UNKNOWN;
diff --git a/drivers/net/eth16i.c b/drivers/net/eth16i.c
index fb717be..b28cec3 100644
--- a/drivers/net/eth16i.c
+++ b/drivers/net/eth16i.c
@@ -1382,13 +1382,13 @@ static ushort eth16i_parse_mediatype(const char* s)
 	if(!s)
 		return E_PORT_FROM_EPROM;
 
-        if (!strncmp(s, "bnc", 3))
+        if (!memcmp(s, "bnc", 3))
 		return E_PORT_BNC;
-        else if (!strncmp(s, "tp", 2))
+        else if (!memcmp(s, "tp", 2))
                 return E_PORT_TP;
-        else if (!strncmp(s, "dix", 3))
+        else if (!memcmp(s, "dix", 3))
                 return E_PORT_DIX;
-        else if (!strncmp(s, "auto", 4))
+        else if (!memcmp(s, "auto", 4))
 		return E_PORT_AUTO;
 	else
 		return E_PORT_FROM_EPROM;
diff --git a/drivers/net/ewrk3.c b/drivers/net/ewrk3.c
index 380d061..77d20bb 100644
--- a/drivers/net/ewrk3.c
+++ b/drivers/net/ewrk3.c
@@ -1361,7 +1361,7 @@ static void __init EthwrkSignature(char *name, char *eeprom_image)
 	char *signatures[] = EWRK3_SIGNATURE;
 
 	for (i=0; *signatures[i] != '\0'; i++)
-		if( !strncmp(eeprom_image+EEPROM_PNAME7, signatures[i], strlen(signatures[i])) )
+		if( !memcmp(eeprom_image+EEPROM_PNAME7, signatures[i], strlen(signatures[i])) )
 			break;
 
 	if (*signatures[i] != '\0') {
diff --git a/drivers/net/fsl_pq_mdio.c b/drivers/net/fsl_pq_mdio.c
index 8d3a2cc..896c29a 100644
--- a/drivers/net/fsl_pq_mdio.c
+++ b/drivers/net/fsl_pq_mdio.c
@@ -375,7 +375,7 @@ static int fsl_pq_mdio_probe(struct platform_device *ofdev,
 	}
 
 	for_each_child_of_node(np, tbi) {
-		if (!strncmp(tbi->type, "tbi-phy", 8))
+		if (!memcmp(tbi->type, "tbi-phy", 8))
 			break;
 	}
 
diff --git a/drivers/net/gianfar_sysfs.c b/drivers/net/gianfar_sysfs.c
index 64f4094..0fbcf62 100644
--- a/drivers/net/gianfar_sysfs.c
+++ b/drivers/net/gianfar_sysfs.c
@@ -59,10 +59,10 @@ static ssize_t gfar_set_bd_stash(struct device *dev,
 
 
 	/* Find out the new setting */
-	if (!strncmp("on", buf, count - 1) || !strncmp("1", buf, count - 1))
+	if (!memcmp("on", buf, count - 1) || !strncmp("1", buf, count - 1))
 		new_setting = 1;
-	else if (!strncmp("off", buf, count - 1) ||
-		 !strncmp("0", buf, count - 1))
+	else if (!memcmp("off", buf, count - 1) ||
+		 !memcmp("0", buf, count - 1))
 		new_setting = 0;
 	else
 		return count;
diff --git a/drivers/net/hamradio/baycom_par.c b/drivers/net/hamradio/baycom_par.c
index 5f5af9a..9739745 100644
--- a/drivers/net/hamradio/baycom_par.c
+++ b/drivers/net/hamradio/baycom_par.c
@@ -399,9 +399,9 @@ static struct hdlcdrv_ops par96_ops = {
 
 static int baycom_setmode(struct baycom_state *bc, const char *modestr)
 {
-	if (!strncmp(modestr, "picpar", 6))
+	if (!memcmp(modestr, "picpar", 6))
 		bc->options = 0;
-	else if (!strncmp(modestr, "par96", 5))
+	else if (!memcmp(modestr, "par96", 5))
 		bc->options = BAYCOM_OPTIONS_SOFTDCD;
 	else
 		bc->options = !!strchr(modestr, '*');
diff --git a/drivers/net/hamradio/baycom_ser_fdx.c b/drivers/net/hamradio/baycom_ser_fdx.c
index 3e25f10..b92ec33 100644
--- a/drivers/net/hamradio/baycom_ser_fdx.c
+++ b/drivers/net/hamradio/baycom_ser_fdx.c
@@ -519,7 +519,7 @@ static int baycom_setmode(struct baycom_state *bc, const char *modestr)
 {
 	unsigned int baud;
 
-	if (!strncmp(modestr, "ser", 3)) {
+	if (!memcmp(modestr, "ser", 3)) {
 		baud = simple_strtoul(modestr+3, NULL, 10);
 		if (baud >= 3 && baud <= 48)
 			bc->baud = baud*100;
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index ac1d323..7c83f73 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -168,7 +168,7 @@ static inline struct net_device *bpq_get_ax25_dev(struct net_device *dev)
 
 static inline int dev_is_ethdev(struct net_device *dev)
 {
-	return dev->type == ARPHRD_ETHER && strncmp(dev->name, "dummy", 5);
+	return dev->type == ARPHRD_ETHER && memcmp(dev->name, "dummy", 5);
 }
 
 /* ------------------------------------------------------------------------ */
diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index 2fd3963..fe557f9 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -680,10 +680,10 @@ static ssize_t natsemi_set_dspcfg_workaround(struct device *dev,
 	unsigned long flags;
 
         /* Find out the new setting */
-        if (!strncmp("on", buf, count - 1) || !strncmp("1", buf, count - 1))
+        if (!memcmp("on", buf, count - 1) || !strncmp("1", buf, count - 1))
                 new_setting = 1;
-        else if (!strncmp("off", buf, count - 1) ||
-                 !strncmp("0", buf, count - 1))
+        else if (!memcmp("off", buf, count - 1) ||
+                 !memcmp("0", buf, count - 1))
 		new_setting = 0;
 	else
                  return count;
diff --git a/drivers/net/netxen/netxen_nic_init.c b/drivers/net/netxen/netxen_nic_init.c
index 95fe552..81d8779 100644
--- a/drivers/net/netxen/netxen_nic_init.c
+++ b/drivers/net/netxen/netxen_nic_init.c
@@ -867,7 +867,7 @@ nx_get_fw_version(struct netxen_adapter *adapter)
 				cpu_to_le32(fw_data_desc->size) - 17;
 
 		for (i = 0; i < 12; i++) {
-			if (!strncmp(&ver_str[i], "REV=", 4)) {
+			if (!memcmp(&ver_str[i], "REV=", 4)) {
 				ret = sscanf(&ver_str[i+4], "%u.%u.%u ",
 							&major, &minor, &sub);
 				break;
diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index 781e368..b8982f4 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -8068,7 +8068,7 @@ static void __devinit niu_vpd_parse_version(struct niu *np)
 	int i;
 
 	for (i = 0; i < len - 5; i++) {
-		if (!strncmp(s + i, "FCode ", 6))
+		if (!memcmp(s + i, "FCode ", 6))
 			break;
 	}
 	if (i >= len - 5)
diff --git a/drivers/net/plip.c b/drivers/net/plip.c
index ca4df7f..5d4261a 100644
--- a/drivers/net/plip.c
+++ b/drivers/net/plip.c
@@ -1355,7 +1355,7 @@ static int __init plip_setup(char *str)
 	str = get_options(str, ARRAY_SIZE(ints), ints);
 
 	/* Ugh. */
-	if (!strncmp(str, "parport", 7)) {
+	if (!memcmp(str, "parport", 7)) {
 		int n = simple_strtoul(str+7, NULL, 10);
 		if (parport_ptr < PLIP_MAX)
 			parport[parport_ptr++] = n;
diff --git a/drivers/net/ps3_gelic_wireless.c b/drivers/net/ps3_gelic_wireless.c
index 4a624a2..2f27e01 100644
--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -1732,7 +1732,7 @@ struct gelic_wl_scan_info *gelic_wl_find_best_bss(struct gelic_wl_info *wl)
 		/* If ESSID is set, check it */
 		if (test_bit(GELIC_WL_STAT_ESSID_SET, &wl->stat)) {
 			if ((scan_info->essid_len == wl->essid_len) &&
-			    !strncmp(wl->essid,
+			    !memcmp(wl->essid,
 				     scan_info->hwinfo->essid,
 				     scan_info->essid_len))
 				update_best(&best_bss, scan_info,
diff --git a/drivers/net/qlcnic/qlcnic_init.c b/drivers/net/qlcnic/qlcnic_init.c
index 0d180c6..58b9c2d 100644
--- a/drivers/net/qlcnic/qlcnic_init.c
+++ b/drivers/net/qlcnic/qlcnic_init.c
@@ -955,7 +955,7 @@ qlcnic_get_fw_version(struct qlcnic_adapter *adapter)
 		cpu_to_le32(fw_data_desc->size) - 17;
 
 	for (i = 0; i < 12; i++) {
-		if (!strncmp(&ver_str[i], "REV=", 4)) {
+		if (!memcmp(&ver_str[i], "REV=", 4)) {
 			ret = sscanf(&ver_str[i+4], "%u.%u.%u ",
 					&major, &minor, &sub);
 			if (ret != 3)
diff --git a/drivers/net/qlge/qlge_main.c b/drivers/net/qlge/qlge_main.c
index 528eaef..0c59d0a 100644
--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -734,7 +734,7 @@ static int ql_validate_flash(struct ql_adapter *qdev, u32 size, const char *str)
 	u16 csum = 0;
 	__le16 *flash = (__le16 *)&qdev->flash;
 
-	status = strncmp((char *)&qdev->flash, str, 4);
+	status = memcmp((char *)&qdev->flash, str, 4);
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev, "Invalid flash signature.\n");
 		return	status;
diff --git a/drivers/net/stmmac/stmmac_main.c b/drivers/net/stmmac/stmmac_main.c
index 06bc603..b7ac7b2 100644
--- a/drivers/net/stmmac/stmmac_main.c
+++ b/drivers/net/stmmac/stmmac_main.c
@@ -1934,29 +1934,29 @@ static int __init stmmac_cmdline_opt(char *str)
 	if (!str || !*str)
 		return -EINVAL;
 	while ((opt = strsep(&str, ",")) != NULL) {
-		if (!strncmp(opt, "debug:", 6))
+		if (!memcmp(opt, "debug:", 6))
 			strict_strtoul(opt + 6, 0, (unsigned long *)&debug);
-		else if (!strncmp(opt, "phyaddr:", 8))
+		else if (!memcmp(opt, "phyaddr:", 8))
 			strict_strtoul(opt + 8, 0, (unsigned long *)&phyaddr);
-		else if (!strncmp(opt, "dma_txsize:", 11))
+		else if (!memcmp(opt, "dma_txsize:", 11))
 			strict_strtoul(opt + 11, 0,
 				       (unsigned long *)&dma_txsize);
-		else if (!strncmp(opt, "dma_rxsize:", 11))
+		else if (!memcmp(opt, "dma_rxsize:", 11))
 			strict_strtoul(opt + 11, 0,
 				       (unsigned long *)&dma_rxsize);
-		else if (!strncmp(opt, "buf_sz:", 7))
+		else if (!memcmp(opt, "buf_sz:", 7))
 			strict_strtoul(opt + 7, 0, (unsigned long *)&buf_sz);
-		else if (!strncmp(opt, "tc:", 3))
+		else if (!memcmp(opt, "tc:", 3))
 			strict_strtoul(opt + 3, 0, (unsigned long *)&tc);
-		else if (!strncmp(opt, "watchdog:", 9))
+		else if (!memcmp(opt, "watchdog:", 9))
 			strict_strtoul(opt + 9, 0, (unsigned long *)&watchdog);
-		else if (!strncmp(opt, "flow_ctrl:", 10))
+		else if (!memcmp(opt, "flow_ctrl:", 10))
 			strict_strtoul(opt + 10, 0,
 				       (unsigned long *)&flow_ctrl);
-		else if (!strncmp(opt, "pause:", 6))
+		else if (!memcmp(opt, "pause:", 6))
 			strict_strtoul(opt + 6, 0, (unsigned long *)&pause);
 #ifdef CONFIG_STMMAC_TIMER
-		else if (!strncmp(opt, "tmrate:", 7))
+		else if (!memcmp(opt, "tmrate:", 7))
 			strict_strtoul(opt + 7, 0, (unsigned long *)&tmrate);
 #endif
 	}
diff --git a/drivers/net/sunhme.c b/drivers/net/sunhme.c
index 5e28c41..552e164 100644
--- a/drivers/net/sunhme.c
+++ b/drivers/net/sunhme.c
@@ -3144,7 +3144,7 @@ static int __devinit happy_meal_pci_probe(struct pci_dev *pdev,
 		struct pci_dev *qpdev = qp->quattro_dev;
 
 		prom_name[0] = 0;
-		if (!strncmp(dev->name, "eth", 3)) {
+		if (!memcmp(dev->name, "eth", 3)) {
 			int i = simple_strtoul(dev->name + 3, NULL, 10);
 			sprintf(prom_name, "-%d", i + 3);
 		}
diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 10bafd5..5e1d560 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -485,9 +485,9 @@ static int cosa_probe(int base, int irq, int dma)
 	}
 
 	/* Test the validity of identification string */
-	if (!strncmp(cosa->id_string, "SRP", 3))
+	if (!memcmp(cosa->id_string, "SRP", 3))
 		cosa->type = "srp";
-	else if (!strncmp(cosa->id_string, "COSA", 4))
+	else if (!memcmp(cosa->id_string, "COSA", 4))
 		cosa->type = is_8bit(cosa)? "cosa8": "cosa16";
 	else {
 /* Print a warning only if we are not autoprobing */
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 7f5bb91..1b3ee41 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -78,7 +78,7 @@ static struct lapbethdev *lapbeth_get_x25_dev(struct net_device *dev)
 
 static __inline__ int dev_is_ethdev(struct net_device *dev)
 {
-	return dev->type == ARPHRD_ETHER && strncmp(dev->name, "dummy", 5);
+	return dev->type == ARPHRD_ETHER && memcmp(dev->name, "dummy", 5);
 }
 
 /* ------------------------------------------------------------------------ */
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index a36e787..ce28219 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -4834,7 +4834,7 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 	line = data->wbuffer;
 	while( line[0] ) {
 /*** Mode processing */
-		if ( !strncmp( line, "Mode: ", 6 ) ) {
+		if ( !memcmp( line, "Mode: ", 6 ) ) {
 			line += 6;
 			if (sniffing_mode(ai))
 				set_bit (FLAG_RESET, &ai->flags);
@@ -4861,16 +4861,16 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 		}
 
 /*** Radio status */
-		else if (!strncmp(line,"Radio: ", 7)) {
+		else if (!memcmp(line,"Radio: ", 7)) {
 			line += 7;
-			if (!strncmp(line,"off",3)) {
+			if (!memcmp(line,"off",3)) {
 				set_bit (FLAG_RADIO_OFF, &ai->flags);
 			} else {
 				clear_bit (FLAG_RADIO_OFF, &ai->flags);
 			}
 		}
 /*** NodeName processing */
-		else if ( !strncmp( line, "NodeName: ", 10 ) ) {
+		else if ( !memcmp( line, "NodeName: ", 10 ) ) {
 			int j;
 
 			line += 10;
@@ -4883,19 +4883,19 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 		}
 
 /*** PowerMode processing */
-		else if ( !strncmp( line, "PowerMode: ", 11 ) ) {
+		else if ( !memcmp( line, "PowerMode: ", 11 ) ) {
 			line += 11;
-			if ( !strncmp( line, "PSPCAM", 6 ) ) {
+			if ( !memcmp( line, "PSPCAM", 6 ) ) {
 				ai->config.powerSaveMode = POWERSAVE_PSPCAM;
 				set_bit (FLAG_COMMIT, &ai->flags);
-			} else if ( !strncmp( line, "PSP", 3 ) ) {
+			} else if ( !memcmp( line, "PSP", 3 ) ) {
 				ai->config.powerSaveMode = POWERSAVE_PSP;
 				set_bit (FLAG_COMMIT, &ai->flags);
 			} else {
 				ai->config.powerSaveMode = POWERSAVE_CAM;
 				set_bit (FLAG_COMMIT, &ai->flags);
 			}
-		} else if ( !strncmp( line, "DataRates: ", 11 ) ) {
+		} else if ( !memcmp( line, "DataRates: ", 11 ) ) {
 			int v, i = 0, k = 0; /* i is index into line,
 						k is index to rates */
 
@@ -4906,7 +4906,7 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 				i = 0;
 			}
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "Channel: ", 9 ) ) {
+		} else if ( !memcmp( line, "Channel: ", 9 ) ) {
 			int v, i = 0;
 			line += 9;
 			v = get_dec_u16(line, &i, i+3);
@@ -4914,7 +4914,7 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 				ai->config.channelSet = cpu_to_le16(v);
 				set_bit (FLAG_COMMIT, &ai->flags);
 			}
-		} else if ( !strncmp( line, "XmitPower: ", 11 ) ) {
+		} else if ( !memcmp( line, "XmitPower: ", 11 ) ) {
 			int v, i = 0;
 			line += 11;
 			v = get_dec_u16(line, &i, i+3);
@@ -4922,7 +4922,7 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 				ai->config.txPower = cpu_to_le16(v);
 				set_bit (FLAG_COMMIT, &ai->flags);
 			}
-		} else if ( !strncmp( line, "WEP: ", 5 ) ) {
+		} else if ( !memcmp( line, "WEP: ", 5 ) ) {
 			line += 5;
 			switch( line[0] ) {
 			case 's':
@@ -4936,7 +4936,7 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 				break;
 			}
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "LongRetryLimit: ", 16 ) ) {
+		} else if ( !memcmp( line, "LongRetryLimit: ", 16 ) ) {
 			int v, i = 0;
 
 			line += 16;
@@ -4944,7 +4944,7 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 			v = (v<0) ? 0 : ((v>255) ? 255 : v);
 			ai->config.longRetryLimit = cpu_to_le16(v);
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "ShortRetryLimit: ", 17 ) ) {
+		} else if ( !memcmp( line, "ShortRetryLimit: ", 17 ) ) {
 			int v, i = 0;
 
 			line += 17;
@@ -4952,7 +4952,7 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 			v = (v<0) ? 0 : ((v>255) ? 255 : v);
 			ai->config.shortRetryLimit = cpu_to_le16(v);
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "RTSThreshold: ", 14 ) ) {
+		} else if ( !memcmp( line, "RTSThreshold: ", 14 ) ) {
 			int v, i = 0;
 
 			line += 14;
@@ -4960,7 +4960,7 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 			v = (v<0) ? 0 : ((v>AIRO_DEF_MTU) ? AIRO_DEF_MTU : v);
 			ai->config.rtsThres = cpu_to_le16(v);
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "TXMSDULifetime: ", 16 ) ) {
+		} else if ( !memcmp( line, "TXMSDULifetime: ", 16 ) ) {
 			int v, i = 0;
 
 			line += 16;
@@ -4968,7 +4968,7 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 			v = (v<0) ? 0 : v;
 			ai->config.txLifetime = cpu_to_le16(v);
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "RXMSDULifetime: ", 16 ) ) {
+		} else if ( !memcmp( line, "RXMSDULifetime: ", 16 ) ) {
 			int v, i = 0;
 
 			line += 16;
@@ -4976,17 +4976,17 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 			v = (v<0) ? 0 : v;
 			ai->config.rxLifetime = cpu_to_le16(v);
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "TXDiversity: ", 13 ) ) {
+		} else if ( !memcmp( line, "TXDiversity: ", 13 ) ) {
 			ai->config.txDiversity =
 				(line[13]=='l') ? 1 :
 				((line[13]=='r')? 2: 3);
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "RXDiversity: ", 13 ) ) {
+		} else if ( !memcmp( line, "RXDiversity: ", 13 ) ) {
 			ai->config.rxDiversity =
 				(line[13]=='l') ? 1 :
 				((line[13]=='r')? 2: 3);
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "FragThreshold: ", 15 ) ) {
+		} else if ( !memcmp( line, "FragThreshold: ", 15 ) ) {
 			int v, i = 0;
 
 			line += 15;
@@ -4995,7 +4995,7 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 			v = v & 0xfffe; /* Make sure its even */
 			ai->config.fragThresh = cpu_to_le16(v);
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if (!strncmp(line, "Modulation: ", 12)) {
+		} else if (!memcmp(line, "Modulation: ", 12)) {
 			line += 12;
 			switch(*line) {
 			case 'd':  ai->config.modulation=MOD_DEFAULT; set_bit(FLAG_COMMIT, &ai->flags); break;
@@ -5003,7 +5003,7 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 			case 'm':  ai->config.modulation=MOD_MOK; set_bit(FLAG_COMMIT, &ai->flags); break;
 			default: airo_print_warn(ai->dev->name, "Unknown modulation");
 			}
-		} else if (!strncmp(line, "Preamble: ", 10)) {
+		} else if (!memcmp(line, "Preamble: ", 10)) {
 			line += 10;
 			switch(*line) {
 			case 'a': ai->config.preamble=PREAMBLE_AUTO; set_bit(FLAG_COMMIT, &ai->flags); break;
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index acda56e..0ac4d04 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -255,10 +255,10 @@ static ssize_t write_file_beacon(struct file *file,
 	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
 		return -EFAULT;
 
-	if (strncmp(buf, "disable", 7) == 0) {
+	if (memcmp(buf, "disable", 7) == 0) {
 		AR5K_REG_DISABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE);
 		printk(KERN_INFO "debugfs disable beacons\n");
-	} else if (strncmp(buf, "enable", 6) == 0) {
+	} else if (memcmp(buf, "enable", 6) == 0) {
 		AR5K_REG_ENABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE);
 		printk(KERN_INFO "debugfs enable beacons\n");
 	}
@@ -357,7 +357,7 @@ static ssize_t write_file_debug(struct file *file,
 		return -EFAULT;
 
 	for (i = 0; i < ARRAY_SIZE(dbg_info); i++) {
-		if (strncmp(buf, dbg_info[i].name,
+		if (memcmp(buf, dbg_info[i].name,
 					strlen(dbg_info[i].name)) == 0) {
 			sc->debug.level ^= dbg_info[i].level; /* toggle bit */
 			break;
@@ -459,16 +459,16 @@ static ssize_t write_file_antenna(struct file *file,
 	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
 		return -EFAULT;
 
-	if (strncmp(buf, "diversity", 9) == 0) {
+	if (memcmp(buf, "diversity", 9) == 0) {
 		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_DEFAULT);
 		printk(KERN_INFO "ath5k debug: enable diversity\n");
-	} else if (strncmp(buf, "fixed-a", 7) == 0) {
+	} else if (memcmp(buf, "fixed-a", 7) == 0) {
 		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_FIXED_A);
 		printk(KERN_INFO "ath5k debugfs: fixed antenna A\n");
-	} else if (strncmp(buf, "fixed-b", 7) == 0) {
+	} else if (memcmp(buf, "fixed-b", 7) == 0) {
 		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_FIXED_B);
 		printk(KERN_INFO "ath5k debug: fixed antenna B\n");
-	} else if (strncmp(buf, "clear", 5) == 0) {
+	} else if (memcmp(buf, "clear", 5) == 0) {
 		for (i = 0; i < ARRAY_SIZE(sc->stats.antenna_rx); i++) {
 			sc->stats.antenna_rx[i] = 0;
 			sc->stats.antenna_tx[i] = 0;
@@ -630,7 +630,7 @@ static ssize_t write_file_frameerrors(struct file *file,
 	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
 		return -EFAULT;
 
-	if (strncmp(buf, "clear", 5) == 0) {
+	if (memcmp(buf, "clear", 5) == 0) {
 		st->rxerr_crc = 0;
 		st->rxerr_phy = 0;
 		st->rxerr_fifo = 0;
@@ -773,35 +773,35 @@ static ssize_t write_file_ani(struct file *file,
 	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
 		return -EFAULT;
 
-	if (strncmp(buf, "sens-low", 8) == 0) {
+	if (memcmp(buf, "sens-low", 8) == 0) {
 		ath5k_ani_init(sc->ah, ATH5K_ANI_MODE_MANUAL_HIGH);
-	} else if (strncmp(buf, "sens-high", 9) == 0) {
+	} else if (memcmp(buf, "sens-high", 9) == 0) {
 		ath5k_ani_init(sc->ah, ATH5K_ANI_MODE_MANUAL_LOW);
-	} else if (strncmp(buf, "ani-off", 7) == 0) {
+	} else if (memcmp(buf, "ani-off", 7) == 0) {
 		ath5k_ani_init(sc->ah, ATH5K_ANI_MODE_OFF);
-	} else if (strncmp(buf, "ani-on", 6) == 0) {
+	} else if (memcmp(buf, "ani-on", 6) == 0) {
 		ath5k_ani_init(sc->ah, ATH5K_ANI_MODE_AUTO);
-	} else if (strncmp(buf, "noise-low", 9) == 0) {
+	} else if (memcmp(buf, "noise-low", 9) == 0) {
 		ath5k_ani_set_noise_immunity_level(sc->ah, 0);
-	} else if (strncmp(buf, "noise-high", 10) == 0) {
+	} else if (memcmp(buf, "noise-high", 10) == 0) {
 		ath5k_ani_set_noise_immunity_level(sc->ah,
 						   ATH5K_ANI_MAX_NOISE_IMM_LVL);
-	} else if (strncmp(buf, "spur-low", 8) == 0) {
+	} else if (memcmp(buf, "spur-low", 8) == 0) {
 		ath5k_ani_set_spur_immunity_level(sc->ah, 0);
-	} else if (strncmp(buf, "spur-high", 9) == 0) {
+	} else if (memcmp(buf, "spur-high", 9) == 0) {
 		ath5k_ani_set_spur_immunity_level(sc->ah,
 						  sc->ani_state.max_spur_level);
-	} else if (strncmp(buf, "fir-low", 7) == 0) {
+	} else if (memcmp(buf, "fir-low", 7) == 0) {
 		ath5k_ani_set_firstep_level(sc->ah, 0);
-	} else if (strncmp(buf, "fir-high", 8) == 0) {
+	} else if (memcmp(buf, "fir-high", 8) == 0) {
 		ath5k_ani_set_firstep_level(sc->ah, ATH5K_ANI_MAX_FIRSTEP_LVL);
-	} else if (strncmp(buf, "ofdm-off", 8) == 0) {
+	} else if (memcmp(buf, "ofdm-off", 8) == 0) {
 		ath5k_ani_set_ofdm_weak_signal_detection(sc->ah, false);
-	} else if (strncmp(buf, "ofdm-on", 7) == 0) {
+	} else if (memcmp(buf, "ofdm-on", 7) == 0) {
 		ath5k_ani_set_ofdm_weak_signal_detection(sc->ah, true);
-	} else if (strncmp(buf, "cck-off", 7) == 0) {
+	} else if (memcmp(buf, "cck-off", 7) == 0) {
 		ath5k_ani_set_cck_weak_signal_detection(sc->ah, false);
-	} else if (strncmp(buf, "cck-on", 6) == 0) {
+	} else if (memcmp(buf, "cck-on", 6) == 0) {
 		ath5k_ani_set_cck_weak_signal_detection(sc->ah, true);
 	}
 	return count;
@@ -869,9 +869,9 @@ static ssize_t write_file_queue(struct file *file,
 	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
 		return -EFAULT;
 
-	if (strncmp(buf, "start", 5) == 0)
+	if (memcmp(buf, "start", 5) == 0)
 		ieee80211_wake_queues(sc->hw);
-	else if (strncmp(buf, "stop", 4) == 0)
+	else if (memcmp(buf, "stop", 4) == 0)
 		ieee80211_stop_queues(sc->hw);
 
 	return count;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 43e71a9..9b08c31 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -543,27 +543,27 @@ static ssize_t write_file_wiphy(struct file *file, const char __user *user_buf,
 	if (len > 0 && buf[len - 1] == '\n')
 		buf[len - 1] = '\0';
 
-	if (strncmp(buf, "add", 3) == 0) {
+	if (memcmp(buf, "add", 3) == 0) {
 		int res = ath9k_wiphy_add(sc);
 		if (res < 0)
 			return res;
-	} else if (strncmp(buf, "del=", 4) == 0) {
+	} else if (memcmp(buf, "del=", 4) == 0) {
 		int res = del_wiphy(sc, buf + 4);
 		if (res < 0)
 			return res;
-	} else if (strncmp(buf, "pause=", 6) == 0) {
+	} else if (memcmp(buf, "pause=", 6) == 0) {
 		int res = pause_wiphy(sc, buf + 6);
 		if (res < 0)
 			return res;
-	} else if (strncmp(buf, "unpause=", 8) == 0) {
+	} else if (memcmp(buf, "unpause=", 8) == 0) {
 		int res = unpause_wiphy(sc, buf + 8);
 		if (res < 0)
 			return res;
-	} else if (strncmp(buf, "select=", 7) == 0) {
+	} else if (memcmp(buf, "select=", 7) == 0) {
 		int res = select_wiphy(sc, buf + 7);
 		if (res < 0)
 			return res;
-	} else if (strncmp(buf, "schedule=", 9) == 0) {
+	} else if (memcmp(buf, "schedule=", 9) == 0) {
 		int res = schedule_wiphy(sc, buf + 9);
 		if (res < 0)
 			return res;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 7c8a38d..a528b7c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -694,7 +694,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	ath9k_init_channels_rates(priv);
 	ath9k_init_misc(priv);
 
-	if (product && strncmp(product, ATH_HTC_BTCOEX_PRODUCT_ID, 5) == 0) {
+	if (product && memcmp(product, ATH_HTC_BTCOEX_PRODUCT_ID, 5) == 0) {
 		ah->btcoex_hw.scheme = ATH_BTCOEX_CFG_3WIRE;
 		ath9k_init_btcoex(priv);
 	}
diff --git a/drivers/net/znet.c b/drivers/net/znet.c
index c3a3292..6732ff8 100644
--- a/drivers/net/znet.c
+++ b/drivers/net/znet.c
@@ -378,7 +378,7 @@ static int __init znet_probe (void)
 
 	/* This code scans the region 0xf0000 to 0xfffff for a "NETIDBLK". */
 	for(p = (char *)phys_to_virt(0xf0000); p < (char *)phys_to_virt(0x100000); p++)
-		if (*p == 'N'  &&  strncmp(p, "NETIDBLK", 8) == 0)
+		if (*p == 'N'  &&  memcmp(p, "NETIDBLK", 8) == 0)
 			break;
 
 	if (p >= (char *)phys_to_virt(0x100000)) {
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 8d62fb7..def9849 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -3405,11 +3405,11 @@ static int __init parport_parse_param(const char *s, int *val,
 {
 	if (!s)
 		return 0;
-	if (!strncmp(s, "auto", 4))
+	if (!memcmp(s, "auto", 4))
 		*val = automatic;
-	else if (!strncmp(s, "none", 4))
+	else if (!memcmp(s, "none", 4))
 		*val = none;
-	else if (nofifo && !strncmp(s, "nofifo", 6))
+	else if (nofifo && !memcmp(s, "nofifo", 6))
 		*val = nofifo;
 	else {
 		char *ep;
@@ -3554,7 +3554,7 @@ static int __init parport_setup(char *str)
 		return 1;
 	}
 
-	if (!strncmp(str, "auto", 4)) {
+	if (!memcmp(str, "auto", 4)) {
 		irqval[0] = PARPORT_IRQ_AUTO;
 		dmaval[0] = PARPORT_DMA_AUTO;
 		return 1;
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 4789f8e..4fc297d 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -398,21 +398,21 @@ static int __init intel_iommu_setup(char *str)
 	if (!str)
 		return -EINVAL;
 	while (*str) {
-		if (!strncmp(str, "on", 2)) {
+		if (!memcmp(str, "on", 2)) {
 			dmar_disabled = 0;
 			printk(KERN_INFO "Intel-IOMMU: enabled\n");
-		} else if (!strncmp(str, "off", 3)) {
+		} else if (!memcmp(str, "off", 3)) {
 			dmar_disabled = 1;
 			printk(KERN_INFO "Intel-IOMMU: disabled\n");
-		} else if (!strncmp(str, "igfx_off", 8)) {
+		} else if (!memcmp(str, "igfx_off", 8)) {
 			dmar_map_gfx = 0;
 			printk(KERN_INFO
 				"Intel-IOMMU: disable GFX device mapping\n");
-		} else if (!strncmp(str, "forcedac", 8)) {
+		} else if (!memcmp(str, "forcedac", 8)) {
 			printk(KERN_INFO
 				"Intel-IOMMU: Forcing DAC for PCI devices\n");
 			dmar_forcedac = 1;
-		} else if (!strncmp(str, "strict", 6)) {
+		} else if (!memcmp(str, "strict", 6)) {
 			printk(KERN_INFO
 				"Intel-IOMMU: disable batched IOTLB flush\n");
 			intel_iommu_strict = 1;
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index ec87cd6..261da59 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -35,11 +35,11 @@ static __init int setup_intremap(char *str)
 	if (!str)
 		return -EINVAL;
 
-	if (!strncmp(str, "on", 2))
+	if (!memcmp(str, "on", 2))
 		disable_intremap = 0;
-	else if (!strncmp(str, "off", 3))
+	else if (!memcmp(str, "off", 3))
 		disable_intremap = 1;
-	else if (!strncmp(str, "nosid", 5))
+	else if (!memcmp(str, "nosid", 5))
 		disable_sourceid_checking = 1;
 
 	return 0;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 710c8a2..61f5bc8 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3086,18 +3086,18 @@ static int __init pci_setup(char *str)
 				pci_no_aer();
 			} else if (!strcmp(str, "nodomains")) {
 				pci_no_domains();
-			} else if (!strncmp(str, "cbiosize=", 9)) {
+			} else if (!memcmp(str, "cbiosize=", 9)) {
 				pci_cardbus_io_size = memparse(str + 9, &str);
-			} else if (!strncmp(str, "cbmemsize=", 10)) {
+			} else if (!memcmp(str, "cbmemsize=", 10)) {
 				pci_cardbus_mem_size = memparse(str + 10, &str);
-			} else if (!strncmp(str, "resource_alignment=", 19)) {
+			} else if (!memcmp(str, "resource_alignment=", 19)) {
 				pci_set_resource_alignment_param(str + 19,
 							strlen(str + 19));
-			} else if (!strncmp(str, "ecrc=", 5)) {
+			} else if (!memcmp(str, "ecrc=", 5)) {
 				pcie_ecrc_get_policy(str + 5);
-			} else if (!strncmp(str, "hpiosize=", 9)) {
+			} else if (!memcmp(str, "hpiosize=", 9)) {
 				pci_hotplug_io_size = memparse(str + 9, &str);
-			} else if (!strncmp(str, "hpmemsize=", 10)) {
+			} else if (!memcmp(str, "hpmemsize=", 10)) {
 				pci_hotplug_mem_size = memparse(str + 10, &str);
 			} else {
 				printk(KERN_ERR "PCI: Unknown option `%s'\n",
diff --git a/drivers/pci/pcie/aer/ecrc.c b/drivers/pci/pcie/aer/ecrc.c
index a2747a6..1121c27 100644
--- a/drivers/pci/pcie/aer/ecrc.c
+++ b/drivers/pci/pcie/aer/ecrc.c
@@ -121,7 +121,7 @@ void pcie_ecrc_get_policy(char *str)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(ecrc_policy_str); i++)
-		if (!strncmp(str, ecrc_policy_str[i],
+		if (!memcmp(str, ecrc_policy_str[i],
 			     strlen(ecrc_policy_str[i])))
 			break;
 	if (i >= ARRAY_SIZE(ecrc_policy_str))
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 7122281..7b729f9 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -741,7 +741,7 @@ static int pcie_aspm_set_policy(const char *val, struct kernel_param *kp)
 	struct pcie_link_state *link;
 
 	for (i = 0; i < ARRAY_SIZE(policy_str); i++)
-		if (!strncmp(val, policy_str[i], strlen(policy_str[i])))
+		if (!memcmp(val, policy_str[i], strlen(policy_str[i])))
 			break;
 	if (i >= ARRAY_SIZE(policy_str))
 		return -EINVAL;
diff --git a/drivers/pci/pcie/pme.c b/drivers/pci/pcie/pme.c
index 2f3c904..d909f45 100644
--- a/drivers/pci/pcie/pme.c
+++ b/drivers/pci/pcie/pme.c
@@ -39,7 +39,7 @@ bool pcie_pme_msi_disabled;
 
 static int __init pcie_pme_setup(char *str)
 {
-	if (!strncmp(str, "nomsi", 5))
+	if (!memcmp(str, "nomsi", 5))
 		pcie_pme_msi_disabled = true;
 
 	return 1;
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index f9033e1..30ff67b 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -41,12 +41,12 @@ bool pcie_ports_auto = true;
 
 static int __init pcie_port_setup(char *str)
 {
-	if (!strncmp(str, "compat", 6)) {
+	if (!memcmp(str, "compat", 6)) {
 		pcie_ports_disabled = true;
-	} else if (!strncmp(str, "native", 6)) {
+	} else if (!memcmp(str, "native", 6)) {
 		pcie_ports_disabled = false;
 		pcie_ports_auto = false;
-	} else if (!strncmp(str, "auto", 4)) {
+	} else if (!memcmp(str, "auto", 4)) {
 		pcie_ports_disabled = false;
 		pcie_ports_auto = true;
 	}
diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
index 884a984..e9a9cc8 100644
--- a/drivers/pcmcia/cistpl.c
+++ b/drivers/pcmcia/cistpl.c
@@ -502,7 +502,7 @@ static int follow_link(struct pcmcia_socket *s, tuple_t *tuple)
 		if (ret)
 			return -1;
 		if ((link[0] == CISTPL_LINKTARGET) && (link[1] >= 3) &&
-			(strncmp(link+2, "CIS", 3) == 0))
+			(memcmp(link+2, "CIS", 3) == 0))
 			return ofs;
 		remove_cis_cache(s, SPACE(tuple->Flags), ofs, 5);
 		/* Then, we try the wrong spot... */
@@ -512,7 +512,7 @@ static int follow_link(struct pcmcia_socket *s, tuple_t *tuple)
 	if (ret)
 		return -1;
 	if ((link[0] == CISTPL_LINKTARGET) && (link[1] >= 3) &&
-		(strncmp(link+2, "CIS", 3) == 0))
+		(memcmp(link+2, "CIS", 3) == 0))
 		return ofs;
 	remove_cis_cache(s, SPACE(tuple->Flags), ofs, 5);
 	return -1;
diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 100c441..79d4d04 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -1050,9 +1050,9 @@ static ssize_t pcmcia_store_pm_state(struct device *dev, struct device_attribute
 	if (!count)
 		return -EINVAL;
 
-	if ((!p_dev->suspended) && !strncmp(buf, "off", 3))
+	if ((!p_dev->suspended) && !memcmp(buf, "off", 3))
 		ret = runtime_suspend(dev);
-	else if (p_dev->suspended && !strncmp(buf, "on", 2))
+	else if (p_dev->suspended && !memcmp(buf, "on", 2))
 		ret = runtime_resume(dev);
 
 	return ret ? ret : count;
diff --git a/drivers/pcmcia/socket_sysfs.c b/drivers/pcmcia/socket_sysfs.c
index 71aeed9..05931ba 100644
--- a/drivers/pcmcia/socket_sysfs.c
+++ b/drivers/pcmcia/socket_sysfs.c
@@ -115,10 +115,10 @@ static ssize_t pccard_store_card_pm_state(struct device *dev,
 	if (!count)
 		return -EINVAL;
 
-	if (!strncmp(buf, "off", 3))
+	if (!memcmp(buf, "off", 3))
 		pcmcia_parse_uevents(s, PCMCIA_UEVENT_SUSPEND);
 	else {
-		if (!strncmp(buf, "on", 2))
+		if (!memcmp(buf, "on", 2))
 			pcmcia_parse_uevents(s, PCMCIA_UEVENT_RESUME);
 		else
 			ret = -EINVAL;
diff --git a/drivers/pcmcia/vrc4171_card.c b/drivers/pcmcia/vrc4171_card.c
index 86e4a1a..d597cba 100644
--- a/drivers/pcmcia/vrc4171_card.c
+++ b/drivers/pcmcia/vrc4171_card.c
@@ -636,7 +636,7 @@ static int __devinit vrc4171_card_setup(char *options)
 	if (options == NULL || *options == '\0')
 		return 1;
 
-	if (strncmp(options, "irq:", 4) == 0) {
+	if (memcmp(options, "irq:", 4) == 0) {
 		int irq;
 		options += 4;
 		irq = simple_strtoul(options, &options, 0);
@@ -648,16 +648,16 @@ static int __devinit vrc4171_card_setup(char *options)
 		options++;
 	}
 
-	if (strncmp(options, "slota:", 6) == 0) {
+	if (memcmp(options, "slota:", 6) == 0) {
 		options += 6;
 		if (*options != '\0') {
-			if (strncmp(options, "memnoprobe", 10) == 0) {
+			if (memcmp(options, "memnoprobe", 10) == 0) {
 				vrc4171_sockets[CARD_SLOTA].slot = SLOT_NOPROBE_MEM;
 				options += 10;
-			} else if (strncmp(options, "ionoprobe", 9) == 0) {
+			} else if (memcmp(options, "ionoprobe", 9) == 0) {
 				vrc4171_sockets[CARD_SLOTA].slot = SLOT_NOPROBE_IO;
 				options += 9;
-			} else if ( strncmp(options, "noprobe", 7) == 0) {
+			} else if ( memcmp(options, "noprobe", 7) == 0) {
 				vrc4171_sockets[CARD_SLOTA].slot = SLOT_NOPROBE_ALL;
 				options += 7;
 			}
@@ -670,19 +670,19 @@ static int __devinit vrc4171_card_setup(char *options)
 
 	}
 
-	if (strncmp(options, "slotb:", 6) == 0) {
+	if (memcmp(options, "slotb:", 6) == 0) {
 		options += 6;
 		if (*options != '\0') {
-			if (strncmp(options, "pccard", 6) == 0) {
+			if (memcmp(options, "pccard", 6) == 0) {
 				vrc4171_slotb = SLOTB_IS_PCCARD;
 				options += 6;
-			} else if (strncmp(options, "cf", 2) == 0) {
+			} else if (memcmp(options, "cf", 2) == 0) {
 				vrc4171_slotb = SLOTB_IS_CF;
 				options += 2;
-			} else if (strncmp(options, "flashrom", 8) == 0) {
+			} else if (memcmp(options, "flashrom", 8) == 0) {
 				vrc4171_slotb = SLOTB_IS_FLASHROM;
 				options += 8;
-			} else if (strncmp(options, "none", 4) == 0) {
+			} else if (memcmp(options, "none", 4) == 0) {
 				vrc4171_slotb = SLOTB_IS_NONE;
 				options += 4;
 			}
@@ -691,11 +691,11 @@ static int __devinit vrc4171_card_setup(char *options)
 				return 1;
 			options++;
 
-			if (strncmp(options, "memnoprobe", 10) == 0)
+			if (memcmp(options, "memnoprobe", 10) == 0)
 				vrc4171_sockets[CARD_SLOTB].slot = SLOT_NOPROBE_MEM;
-			if (strncmp(options, "ionoprobe", 9) == 0)
+			if (memcmp(options, "ionoprobe", 9) == 0)
 				vrc4171_sockets[CARD_SLOTB].slot = SLOT_NOPROBE_IO;
-			if (strncmp(options, "noprobe", 7) == 0)
+			if (memcmp(options, "noprobe", 7) == 0)
 				vrc4171_sockets[CARD_SLOTB].slot = SLOT_NOPROBE_ALL;
 		}
 	}
diff --git a/drivers/pcmcia/vrc4173_cardu.c b/drivers/pcmcia/vrc4173_cardu.c
index c6d36b3..156789a 100644
--- a/drivers/pcmcia/vrc4173_cardu.c
+++ b/drivers/pcmcia/vrc4173_cardu.c
@@ -538,10 +538,10 @@ static int __devinit vrc4173_cardu_setup(char *options)
 	if (options == NULL || *options == '\0')
 		return 1;
 
-	if (strncmp(options, "cardu1:", 7) == 0) {
+	if (memcmp(options, "cardu1:", 7) == 0) {
 		options += 7;
 		if (*options != '\0') {
-			if (strncmp(options, "noprobe", 7) == 0) {
+			if (memcmp(options, "noprobe", 7) == 0) {
 				cardu_sockets[CARDU1].noprobe = 1;
 				options += 7;
 			}
@@ -552,9 +552,9 @@ static int __devinit vrc4173_cardu_setup(char *options)
 			return 1;
 	}
 
-	if (strncmp(options, "cardu2:", 7) == 0) {
+	if (memcmp(options, "cardu2:", 7) == 0) {
 		options += 7;
-		if ((*options != '\0') && (strncmp(options, "noprobe", 7) == 0))
+		if ((*options != '\0') && (memcmp(options, "noprobe", 7) == 0))
 			cardu_sockets[CARDU2].noprobe = 1;
 	}
 
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 60f9cfc..e23a0fd 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -533,7 +533,7 @@ static int str_starts_with(const char *str, const char *start)
 	start_len = strlen(start);
 
 	if (str_len >= start_len &&
-			!strncmp(str, start, start_len))
+			!memcmp(str, start, start_len))
 		return 1;
 
 	return 0;
diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index ca05aef..80b25ac 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -1210,58 +1210,58 @@ static int asus_model_match(char *model)
 	if (model == NULL)
 		return END_MODEL;
 
-	if (strncmp(model, "L3D", 3) == 0)
+	if (memcmp(model, "L3D", 3) == 0)
 		return L3D;
-	else if (strncmp(model, "L2E", 3) == 0 ||
-		 strncmp(model, "L3H", 3) == 0 || strncmp(model, "L5D", 3) == 0)
+	else if (memcmp(model, "L2E", 3) == 0 ||
+		 memcmp(model, "L3H", 3) == 0 || strncmp(model, "L5D", 3) == 0)
 		return L3H;
-	else if (strncmp(model, "L3", 2) == 0 || strncmp(model, "L2B", 3) == 0)
+	else if (memcmp(model, "L3", 2) == 0 || strncmp(model, "L2B", 3) == 0)
 		return L3C;
-	else if (strncmp(model, "L8L", 3) == 0)
+	else if (memcmp(model, "L8L", 3) == 0)
 		return L8L;
-	else if (strncmp(model, "L4R", 3) == 0)
+	else if (memcmp(model, "L4R", 3) == 0)
 		return L4R;
-	else if (strncmp(model, "M6N", 3) == 0 || strncmp(model, "W3N", 3) == 0)
+	else if (memcmp(model, "M6N", 3) == 0 || strncmp(model, "W3N", 3) == 0)
 		return M6N;
-	else if (strncmp(model, "M6R", 3) == 0 || strncmp(model, "A3G", 3) == 0)
+	else if (memcmp(model, "M6R", 3) == 0 || strncmp(model, "A3G", 3) == 0)
 		return M6R;
-	else if (strncmp(model, "M2N", 3) == 0 ||
-		 strncmp(model, "M3N", 3) == 0 ||
-		 strncmp(model, "M5N", 3) == 0 ||
-		 strncmp(model, "S1N", 3) == 0 ||
-		 strncmp(model, "S5N", 3) == 0)
+	else if (memcmp(model, "M2N", 3) == 0 ||
+		 memcmp(model, "M3N", 3) == 0 ||
+		 memcmp(model, "M5N", 3) == 0 ||
+		 memcmp(model, "S1N", 3) == 0 ||
+		 memcmp(model, "S5N", 3) == 0)
 		return xxN;
-	else if (strncmp(model, "M1", 2) == 0)
+	else if (memcmp(model, "M1", 2) == 0)
 		return M1A;
-	else if (strncmp(model, "M2", 2) == 0 || strncmp(model, "L4E", 3) == 0)
+	else if (memcmp(model, "M2", 2) == 0 || strncmp(model, "L4E", 3) == 0)
 		return M2E;
-	else if (strncmp(model, "L2", 2) == 0)
+	else if (memcmp(model, "L2", 2) == 0)
 		return L2D;
-	else if (strncmp(model, "L8", 2) == 0)
+	else if (memcmp(model, "L8", 2) == 0)
 		return S1x;
-	else if (strncmp(model, "D1", 2) == 0)
+	else if (memcmp(model, "D1", 2) == 0)
 		return D1x;
-	else if (strncmp(model, "A1", 2) == 0)
+	else if (memcmp(model, "A1", 2) == 0)
 		return A1x;
-	else if (strncmp(model, "A2", 2) == 0)
+	else if (memcmp(model, "A2", 2) == 0)
 		return A2x;
-	else if (strncmp(model, "J1", 2) == 0)
+	else if (memcmp(model, "J1", 2) == 0)
 		return S2x;
-	else if (strncmp(model, "L5", 2) == 0)
+	else if (memcmp(model, "L5", 2) == 0)
 		return L5x;
-	else if (strncmp(model, "A4G", 3) == 0)
+	else if (memcmp(model, "A4G", 3) == 0)
 		return A4G;
-	else if (strncmp(model, "W1N", 3) == 0)
+	else if (memcmp(model, "W1N", 3) == 0)
 		return W1N;
-	else if (strncmp(model, "W3V", 3) == 0)
+	else if (memcmp(model, "W3V", 3) == 0)
 		return W3V;
-	else if (strncmp(model, "W5A", 3) == 0)
+	else if (memcmp(model, "W5A", 3) == 0)
 		return W5A;
-	else if (strncmp(model, "R1F", 3) == 0)
+	else if (memcmp(model, "R1F", 3) == 0)
 		return R1F;
-	else if (strncmp(model, "A4S", 3) == 0)
+	else if (memcmp(model, "A4S", 3) == 0)
 		return A4S;
-	else if (strncmp(model, "F3Sa", 4) == 0)
+	else if (memcmp(model, "F3Sa", 4) == 0)
 		return F3Sa;
 	else
 		return END_MODEL;
@@ -1328,7 +1328,7 @@ static int asus_hotk_get_info(void)
 	hotk->model = asus_model_match(string);
 	if (hotk->model == END_MODEL) {	/* match failed */
 		if (asus_info &&
-		    strncmp(asus_info->oem_table_id, "ODEM", 4) == 0) {
+		    memcmp(asus_info->oem_table_id, "ODEM", 4) == 0) {
 			hotk->model = P30;
 			printk(KERN_NOTICE
 			       "  Samsung P30 detected, supported\n");
@@ -1349,28 +1349,28 @@ static int asus_hotk_get_info(void)
 	printk(KERN_NOTICE "  %s model detected, supported\n", string);
 
 	/* Sort of per-model blacklist */
-	if (strncmp(string, "L2B", 3) == 0)
+	if (memcmp(string, "L2B", 3) == 0)
 		hotk->methods->lcd_status = NULL;
 	/* L2B is similar enough to L3C to use its settings, with this only
 	   exception */
-	else if (strncmp(string, "A3G", 3) == 0)
+	else if (memcmp(string, "A3G", 3) == 0)
 		hotk->methods->lcd_status = "\\BLFG";
 	/* A3G is like M6R */
-	else if (strncmp(string, "S5N", 3) == 0 ||
-		 strncmp(string, "M5N", 3) == 0 ||
-		 strncmp(string, "W3N", 3) == 0)
+	else if (memcmp(string, "S5N", 3) == 0 ||
+		 memcmp(string, "M5N", 3) == 0 ||
+		 memcmp(string, "W3N", 3) == 0)
 		hotk->methods->mt_mled = NULL;
 	/* S5N, M5N and W3N have no MLED */
-	else if (strncmp(string, "L5D", 3) == 0)
+	else if (memcmp(string, "L5D", 3) == 0)
 		hotk->methods->mt_wled = NULL;
 	/* L5D's WLED is not controlled by ACPI */
-	else if (strncmp(string, "M2N", 3) == 0 ||
-		 strncmp(string, "W3V", 3) == 0 ||
-		 strncmp(string, "S1N", 3) == 0)
+	else if (memcmp(string, "M2N", 3) == 0 ||
+		 memcmp(string, "W3V", 3) == 0 ||
+		 memcmp(string, "S1N", 3) == 0)
 		hotk->methods->mt_wled = "WLED";
 	/* M2N, S1N and W3V have a usable WLED */
 	else if (asus_info) {
-		if (strncmp(asus_info->oem_table_id, "L1", 2) == 0)
+		if (memcmp(asus_info->oem_table_id, "L1", 2) == 0)
 			hotk->methods->mled_status = NULL;
 		/* S1300A reports L84F, but L1400B too, account for that */
 	}
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 2d61186..64054bb 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -247,7 +247,7 @@ enum tpacpi_hkey_event_t {
 
 #define onoff(status, bit) ((status) & (1 << (bit)) ? "on" : "off")
 #define enabled(status, bit) ((status) & (1 << (bit)) ? "enabled" : "disabled")
-#define strlencmp(a, b) (strncmp((a), (b), strlen(b)))
+#define strlencmp(a, b) (memcmp((a), (b), strlen(b)))
 
 
 /****************************************************************************
diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 104b77c..aecd9a9 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -755,7 +755,7 @@ static bool guid_already_parsed(const char *guid_string)
 	struct wmi_block *wblock;
 
 	list_for_each_entry(wblock, &wmi_block_list, list)
-		if (strncmp(wblock->gblock.guid, guid_string, 16) == 0)
+		if (memcmp(wblock->gblock.guid, guid_string, 16) == 0)
 			return true;
 
 	return false;
diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index 2d73dfc..60d20fe 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -332,7 +332,7 @@ static int __init pnpacpi_setup(char *str)
 {
 	if (str == NULL)
 		return 1;
-	if (!strncmp(str, "off", 3))
+	if (!memcmp(str, "off", 3))
 		pnpacpi_disabled = 1;
 	return 1;
 }
diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index cfe8685..a9727bf 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -410,14 +410,14 @@ static int __init pnpbios_setup(char *str)
 	int invert;
 
 	while ((str != NULL) && (*str != '\0')) {
-		if (strncmp(str, "off", 3) == 0)
+		if (memcmp(str, "off", 3) == 0)
 			pnpbios_disabled = 1;
-		if (strncmp(str, "on", 2) == 0)
+		if (memcmp(str, "on", 2) == 0)
 			pnpbios_disabled = 0;
-		invert = (strncmp(str, "no-", 3) == 0);
+		invert = (memcmp(str, "no-", 3) == 0);
 		if (invert)
 			str += 3;
-		if (strncmp(str, "curr", 4) == 0)
+		if (memcmp(str, "curr", 4) == 0)
 			pnpbios_dont_use_current_config = invert;
 		str = strchr(str, ',');
 		if (str != NULL)
diff --git a/drivers/ps3/ps3av.c b/drivers/ps3/ps3av.c
index a409fa0..f7430da 100644
--- a/drivers/ps3/ps3av.c
+++ b/drivers/ps3/ps3av.c
@@ -749,7 +749,7 @@ static void ps3av_fixup_monitor_info(struct ps3av_info_monitor *info)
 
 	for (i = 0; i < ARRAY_SIZE(ps3av_monitor_quirks); i++) {
 		quirk = &ps3av_monitor_quirks[i];
-		if (!strncmp(info->monitor_name, quirk->monitor_name,
+		if (!memcmp(info->monitor_name, quirk->monitor_name,
 			     sizeof(info->monitor_name))) {
 			pr_info("%s: Applying quirk for %s\n", __func__,
 				quirk->monitor_name);
diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index 51725f7..bdbcb17 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -93,11 +93,11 @@ static ssize_t test_irq_store(struct device *dev,
 	struct rtc_device *rtc = platform_get_drvdata(plat_dev);
 
 	retval = count;
-	if (strncmp(buf, "tick", 4) == 0)
+	if (memcmp(buf, "tick", 4) == 0)
 		rtc_update_irq(rtc, 1, RTC_PF | RTC_IRQF);
-	else if (strncmp(buf, "alarm", 5) == 0)
+	else if (memcmp(buf, "alarm", 5) == 0)
 		rtc_update_irq(rtc, 1, RTC_AF | RTC_IRQF);
-	else if (strncmp(buf, "update", 6) == 0)
+	else if (memcmp(buf, "update", 6) == 0)
 		rtc_update_irq(rtc, 1, RTC_UF | RTC_IRQF);
 	else
 		retval = -EINVAL;
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index fb613d7..af50f54 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -820,7 +820,7 @@ static inline int dasd_check_cqr(struct dasd_ccw_req *cqr)
 	if (cqr == NULL)
 		return -EINVAL;
 	device = cqr->startdev;
-	if (strncmp((char *) &cqr->magic, device->discipline->ebcname, 4)) {
+	if (memcmp((char *) &cqr->magic, device->discipline->ebcname, 4)) {
 		DBF_DEV_EVENT(DBF_WARNING, device,
 			    " dasd_ccw_req 0x%08x magic doesn't match"
 			    " discipline 0x%08x",
@@ -1038,7 +1038,7 @@ static void dasd_handle_killed_request(struct ccw_device *cdev,
 
 	if (!cqr->startdev ||
 	    device != cqr->startdev ||
-	    strncmp(cqr->startdev->discipline->ebcname,
+	    memcmp(cqr->startdev->discipline->ebcname,
 		    (char *) &cqr->magic, 4)) {
 		DBF_EVENT_DEVID(DBF_DEBUG, cdev, "%s",
 				"invalid device in request");
@@ -1128,7 +1128,7 @@ void dasd_int_handler(struct ccw_device *cdev, unsigned long intparm,
 
 	device = (struct dasd_device *) cqr->startdev;
 	if (!device ||
-	    strncmp(device->discipline->ebcname, (char *) &cqr->magic, 4)) {
+	    memcmp(device->discipline->ebcname, (char *) &cqr->magic, 4)) {
 		DBF_EVENT_DEVID(DBF_DEBUG, cdev, "%s",
 				"invalid device in request");
 		return;
diff --git a/drivers/s390/block/dasd_alias.c b/drivers/s390/block/dasd_alias.c
index 4155805..48fada9 100644
--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -53,9 +53,9 @@ static struct alias_server *_find_server(struct dasd_uid *uid)
 {
 	struct alias_server *pos;
 	list_for_each_entry(pos, &aliastree.serverlist, server) {
-		if (!strncmp(pos->uid.vendor, uid->vendor,
+		if (!memcmp(pos->uid.vendor, uid->vendor,
 			     sizeof(uid->vendor))
-		    && !strncmp(pos->uid.serial, uid->serial,
+		    && !memcmp(pos->uid.serial, uid->serial,
 				sizeof(uid->serial)))
 			return pos;
 	};
@@ -95,7 +95,7 @@ static struct alias_pav_group *_find_group(struct alias_lcu *lcu,
 		search_unit_addr = uid->base_unit_addr;
 	list_for_each_entry(pos, &lcu->grouplist, group) {
 		if (pos->uid.base_unit_addr == search_unit_addr &&
-		    !strncmp(pos->uid.vduit, uid->vduit, sizeof(uid->vduit)))
+		    !memcmp(pos->uid.vduit, uid->vduit, sizeof(uid->vduit)))
 			return pos;
 	};
 	return NULL;
diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
index 8d41f3e..9e01d58 100644
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -135,7 +135,7 @@ dasd_busid(char **str, int *id0, int *id1, int *devno)
 	int val, old_style;
 
 	/* Interpret ipldev busid */
-	if (strncmp(DASD_IPLDEV, *str, strlen(DASD_IPLDEV)) == 0) {
+	if (memcmp(DASD_IPLDEV, *str, strlen(DASD_IPLDEV)) == 0) {
 		if (ipl_info.type != IPL_TYPE_CCW) {
 			pr_err("The IPL device is not a CCW device\n");
 			return -EINVAL;
@@ -204,13 +204,13 @@ dasd_feature_list(char *str, char **endp)
 	while (1) {
 		for (len = 0;
 		     str[len] && str[len] != ':' && str[len] != ')'; len++);
-		if (len == 2 && !strncmp(str, "ro", 2))
+		if (len == 2 && !memcmp(str, "ro", 2))
 			features |= DASD_FEATURE_READONLY;
-		else if (len == 4 && !strncmp(str, "diag", 4))
+		else if (len == 4 && !memcmp(str, "diag", 4))
 			features |= DASD_FEATURE_USEDIAG;
-		else if (len == 6 && !strncmp(str, "erplog", 6))
+		else if (len == 6 && !memcmp(str, "erplog", 6))
 			features |= DASD_FEATURE_ERPLOG;
-		else if (len == 8 && !strncmp(str, "failfast", 8))
+		else if (len == 8 && !memcmp(str, "failfast", 8))
 			features |= DASD_FEATURE_FAILFAST;
 		else {
 			pr_warning("%*s is not a supported device option\n",
@@ -254,17 +254,17 @@ dasd_parse_keyword( char *parsestring ) {
 		length = strlen(parsestring);
 		residual_str = parsestring + length;
         }
-	if (strncmp("autodetect", parsestring, length) == 0) {
+	if (memcmp("autodetect", parsestring, length) == 0) {
 		dasd_autodetect = 1;
 		pr_info("The autodetection mode has been activated\n");
                 return residual_str;
         }
-	if (strncmp("probeonly", parsestring, length) == 0) {
+	if (memcmp("probeonly", parsestring, length) == 0) {
 		dasd_probeonly = 1;
 		pr_info("The probeonly mode has been activated\n");
                 return residual_str;
         }
-	if (strncmp("nopav", parsestring, length) == 0) {
+	if (memcmp("nopav", parsestring, length) == 0) {
 		if (MACHINE_IS_VM)
 			pr_info("'nopav' is not supported on z/VM\n");
 		else {
@@ -273,13 +273,13 @@ dasd_parse_keyword( char *parsestring ) {
 		}
 		return residual_str;
 	}
-	if (strncmp("nofcx", parsestring, length) == 0) {
+	if (memcmp("nofcx", parsestring, length) == 0) {
 		dasd_nofcx = 1;
 		pr_info("High Performance FICON support has been "
 			"deactivated\n");
 		return residual_str;
 	}
-	if (strncmp("fixedbuffers", parsestring, length) == 0) {
+	if (memcmp("fixedbuffers", parsestring, length) == 0) {
 		if (dasd_page_cache)
 			return residual_str;
 		dasd_page_cache =
@@ -417,7 +417,7 @@ dasd_add_busid(const char *bus_id, int features)
 	devmap = NULL;
 	hash = dasd_hash_busid(bus_id);
 	list_for_each_entry(tmp, &dasd_hashlists[hash], list)
-		if (strncmp(tmp->bus_id, bus_id, DASD_BUS_ID_SIZE) == 0) {
+		if (memcmp(tmp->bus_id, bus_id, DASD_BUS_ID_SIZE) == 0) {
 			devmap = tmp;
 			break;
 		}
@@ -449,7 +449,7 @@ dasd_find_busid(const char *bus_id)
 	devmap = ERR_PTR(-ENODEV);
 	hash = dasd_hash_busid(bus_id);
 	list_for_each_entry(tmp, &dasd_hashlists[hash], list) {
-		if (strncmp(tmp->bus_id, bus_id, DASD_BUS_ID_SIZE) == 0) {
+		if (memcmp(tmp->bus_id, bus_id, DASD_BUS_ID_SIZE) == 0) {
 			devmap = tmp;
 			break;
 		}
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 266b34b..84201c2 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -255,7 +255,7 @@ static void dasd_ext_handler(unsigned int ext_int_code,
 	}
 	cqr = (struct dasd_ccw_req *) ip;
 	device = (struct dasd_device *) cqr->startdev;
-	if (strncmp(device->discipline->ebcname, (char *) &cqr->magic, 4)) {
+	if (memcmp(device->discipline->ebcname, (char *) &cqr->magic, 4)) {
 		DBF_DEV_EVENT(DBF_WARNING, device,
 			    " magic number of dasd_ccw_req 0x%08X doesn't"
 			    " match discipline 0x%08X",
diff --git a/drivers/s390/block/dasd_proc.c b/drivers/s390/block/dasd_proc.c
index c4a6a31..be3b87c 100644
--- a/drivers/s390/block/dasd_proc.c
+++ b/drivers/s390/block/dasd_proc.c
@@ -254,7 +254,7 @@ static ssize_t dasd_stats_proc_write(struct file *file,
 
 	/* check for valid verbs */
 	str = skip_spaces(buffer);
-	if (strncmp(str, "set", 3) == 0 && isspace(str[3])) {
+	if (memcmp(str, "set", 3) == 0 && isspace(str[3])) {
 		/* 'set xxx' was given */
 		str = skip_spaces(str + 4);
 		if (strcmp(str, "on") == 0) {
@@ -271,7 +271,7 @@ static ssize_t dasd_stats_proc_write(struct file *file,
 				"off\n");
 		} else
 			goto out_error;
-	} else if (strncmp(str, "reset", 5) == 0) {
+	} else if (memcmp(str, "reset", 5) == 0) {
 		/* reset the statistics */
 		memset(&dasd_global_profile, 0,
 		       sizeof (struct dasd_profile_info_t));
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 9b43ae9..4998c8c 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -920,7 +920,7 @@ dcssblk_check_params(void)
 			for (k = 0; (buf[k] != ':') && (buf[k] != '\0'); k++)
 				buf[k] = toupper(buf[k]);
 			buf[k] = '\0';
-			if (!strncmp(&dcssblk_segments[j], "(local)", 7)) {
+			if (!memcmp(&dcssblk_segments[j], "(local)", 7)) {
 				down_read(&dcssblk_devices_sem);
 				dev_info = dcssblk_get_device_by_name(buf);
 				up_read(&dcssblk_devices_sem);
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 59ec073..617cecc 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -411,8 +411,8 @@ static void raw3215_irq(struct ccw_device *cdev, unsigned long intparm,
 
 			case CTRLCHAR_NONE:
 				if (count < 2 ||
-				    (strncmp(raw->inbuf+count-2, "\252n", 2) &&
-				     strncmp(raw->inbuf+count-2, "^n", 2)) ) {
+				    (memcmp(raw->inbuf+count-2, "\252n", 2) &&
+				     memcmp(raw->inbuf+count-2, "^n", 2)) ) {
 					/* add the auto \n */
 					raw->inbuf[count] = '\n';
 					count++;
diff --git a/drivers/s390/char/sclp_tty.c b/drivers/s390/char/sclp_tty.c
index 8258d59..fd755cb 100644
--- a/drivers/s390/char/sclp_tty.c
+++ b/drivers/s390/char/sclp_tty.c
@@ -345,8 +345,8 @@ sclp_tty_input(unsigned char* buf, unsigned int count)
 	case CTRLCHAR_NONE:
 		/* send (normal) input to line discipline */
 		if (count < 2 ||
-		    (strncmp((const char *) buf + count - 2, "^n", 2) &&
-		     strncmp((const char *) buf + count - 2, "\252n", 2))) {
+		    (memcmp((const char *) buf + count - 2, "^n", 2) &&
+		     memcmp((const char *) buf + count - 2, "\252n", 2))) {
 			/* add the auto \n */
 			tty_insert_flip_string(sclp_tty, buf, count);
 			tty_insert_flip_char(sclp_tty, '\n', TTY_NORMAL);
diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index c837d74..d67013a 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -226,9 +226,9 @@ static int vmlogrdr_get_recording_class_AB(void)
 	if (!tail)
 		return 0;
 	tail++;
-	if (!strncmp("ANY",tail,3))
+	if (!memcmp("ANY",tail,3))
 		return 1;
-	if (!strncmp("NONE",tail,4))
+	if (!memcmp("NONE",tail,4))
 		return 0;
 	/*
 	 * expect comma separated list of classes here, if one of them
@@ -281,7 +281,7 @@ static int vmlogrdr_recording(struct vmlogrdr_priv_t * logptr,
 	 * on success, but when the specific service was never connected
 	 * before then there might be an additional informational message
 	 * 'HCPCRC8072I Recording entry not found' before the
-	 * 'Command complete'. So I use strstr rather then the strncmp.
+	 * 'Command complete'. So I use strstr rather then the memcmp.
 	 */
 	if (strstr(cp_response,"Command complete"))
 		rc = 0;
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index e8391b8..1dda771 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -549,7 +549,7 @@ static ssize_t online_store (struct device *dev, struct device_attribute *attr,
 		atomic_set(&cdev->private->onoff, 0);
 		return -EINVAL;
 	}
-	if (!strncmp(buf, "force\n", count)) {
+	if (!memcmp(buf, "force\n", count)) {
 		force = 1;
 		i = 1;
 		ret = 0;
diff --git a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
index 8e4153d..96a01ac 100644
--- a/drivers/s390/net/claw.c
+++ b/drivers/s390/net/claw.c
@@ -505,7 +505,7 @@ claw_open(struct net_device *dev)
 	}
         privptr->system_validate_comp=0;
         privptr->release_pend=0;
-	if(strncmp(privptr->p_env->api_type,WS_APPL_NAME_PACKED,6) == 0) {
+	if(memcmp(privptr->p_env->api_type,WS_APPL_NAME_PACKED,6) == 0) {
 		privptr->p_env->read_size=DEF_PACK_BUFSIZE;
 		privptr->p_env->write_size=DEF_PACK_BUFSIZE;
 		privptr->p_env->packing=PACKING_ASK;
@@ -2154,7 +2154,7 @@ claw_process_control( struct net_device *dev, struct ccwbk * p_ccw)
 			dev->name, p_sysval->read_frame_size,
 			p_sysval->write_frame_size);
 		privptr->system_validate_comp = 1;
-		if (strncmp(p_env->api_type, WS_APPL_NAME_PACKED, 6) == 0)
+		if (memcmp(p_env->api_type, WS_APPL_NAME_PACKED, 6) == 0)
 			p_env->packing = PACKING_ASK;
 		claw_strt_conn_req(dev);
 		break;
@@ -3233,7 +3233,7 @@ claw_apname_write(struct device *dev, struct device_attribute *attr,
 	strncpy(p_env->api_type,buf, count);
 	p_env->api_type[count-1] = 0x20;  /* we get a loose 0x0a */
 	p_env->api_type[MAX_NAME_LEN] = 0x00;
-	if(strncmp(p_env->api_type,WS_APPL_NAME_PACKED,6) == 0) {
+	if(memcmp(p_env->api_type,WS_APPL_NAME_PACKED,6) == 0) {
 		p_env->read_size=DEF_PACK_BUFSIZE;
 		p_env->write_size=DEF_PACK_BUFSIZE;
 		p_env->packing=PACKING_ASK;
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index 2c7d2d9..d00a227 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -255,7 +255,7 @@ static struct channel *channel_get(enum ctcm_channel_types type,
 {
 	struct channel *ch = channels;
 
-	while (ch && (strncmp(ch->id, id, CTCM_ID_SIZE) || (ch->type != type)))
+	while (ch && (memcmp(ch->id, id, CTCM_ID_SIZE) || (ch->type != type)))
 		ch = ch->next;
 	if (!ch) {
 		CTCM_DBF_TEXT_(ERROR, CTC_DBF_ERROR,
@@ -1468,7 +1468,7 @@ static int add_channel(struct ccw_device *cdev, enum ctcm_channel_types type,
 	while (*c && ctcm_less_than((*c)->id, ch->id))
 		c = &(*c)->next;
 
-	if (*c && (!strncmp((*c)->id, ch->id, CTCM_ID_SIZE))) {
+	if (*c && (!memcmp((*c)->id, ch->id, CTCM_ID_SIZE))) {
 		CTCM_DBF_TEXT_(SETUP, CTC_DBF_INFO,
 				"%s (%s) already in list, using old entry",
 				__func__, (*c)->id);
diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 65ebee0..4d3c72d 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -571,7 +571,7 @@ static int netiucv_callback_connreq(struct iucv_path *path,
 	rc = -EINVAL;
 	read_lock_bh(&iucv_connection_rwlock);
 	list_for_each_entry(conn, &iucv_connection_list, list) {
-		if (strncmp(ipvmid, conn->userid, 8))
+		if (memcmp(ipvmid, conn->userid, 8))
 			continue;
 		/* Found a matching connection for this path. */
 		conn->path = path;
@@ -1499,7 +1499,7 @@ static ssize_t user_write(struct device *dev, struct device_attribute *attr,
 	}
 	read_lock_bh(&iucv_connection_rwlock);
 	list_for_each_entry(cp, &iucv_connection_list, list) {
-		if (!strncmp(username, cp->userid, 9) && cp->netdev != ndev) {
+		if (!memcmp(username, cp->userid, 9) && cp->netdev != ndev) {
 			read_unlock_bh(&iucv_connection_rwlock);
 			IUCV_DBF_TEXT_(setup, 2, "user_write: Connection "
 				"to %s already exists\n", username);
@@ -2053,7 +2053,7 @@ static ssize_t conn_write(struct device_driver *drv,
 
 	read_lock_bh(&iucv_connection_rwlock);
 	list_for_each_entry(cp, &iucv_connection_list, list) {
-		if (!strncmp(username, cp->userid, 9)) {
+		if (!memcmp(username, cp->userid, 9)) {
 			read_unlock_bh(&iucv_connection_rwlock);
 			IUCV_DBF_TEXT_(setup, 2, "conn_write: Connection "
 				"to %s already exists\n", username);
@@ -2126,7 +2126,7 @@ static ssize_t remove_write (struct device_driver *drv,
 		ndev = cp->netdev;
 		priv = netdev_priv(ndev);
                 dev = priv->dev;
-		if (strncmp(name, ndev->name, count))
+		if (memcmp(name, ndev->name, count))
 			continue;
 		read_unlock_bh(&iucv_connection_rwlock);
                 if (ndev->flags & (IFF_UP | IFF_RUNNING)) {
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index e6b2df0..234e6f8 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1983,7 +1983,7 @@ static int qeth_ulp_setup_cb(struct qeth_card *card, struct qeth_reply *reply,
 	memcpy(&card->token.ulp_connection_r,
 	       QETH_ULP_SETUP_RESP_CONNECTION_TOKEN(iob->data),
 	       QETH_MPC_TOKEN_LENGTH);
-	if (!strncmp("00S", QETH_ULP_SETUP_RESP_CONNECTION_TOKEN(iob->data),
+	if (!memcmp("00S", QETH_ULP_SETUP_RESP_CONNECTION_TOKEN(iob->data),
 		     3)) {
 		QETH_DBF_TEXT(SETUP, 2, "olmlimit");
 		dev_err(&card->gdev->dev, "A connection could not be "
diff --git a/drivers/s390/net/smsgiucv.c b/drivers/s390/net/smsgiucv.c
index 65e1cf1..b2cf03a 100644
--- a/drivers/s390/net/smsgiucv.c
+++ b/drivers/s390/net/smsgiucv.c
@@ -60,7 +60,7 @@ static struct iucv_handler smsg_handler = {
 static int smsg_path_pending(struct iucv_path *path, u8 ipvmid[8],
 			     u8 ipuser[16])
 {
-	if (strncmp(ipvmid, "*MSG    ", sizeof(ipvmid)) != 0)
+	if (memcmp(ipvmid, "*MSG    ", sizeof(ipvmid)) != 0)
 		return -EINVAL;
 	/* Path pending from *MSG. */
 	return iucv_path_accept(path, &smsg_handler, "SMSGIUCV        ", NULL);
@@ -93,7 +93,7 @@ static void smsg_message_pending(struct iucv_path *path,
 		}
 		spin_lock(&smsg_list_lock);
 		list_for_each_entry(cb, &smsg_list, list)
-			if (strncmp(buffer + 8, cb->prefix, cb->len) == 0) {
+			if (memcmp(buffer + 8, cb->prefix, cb->len) == 0) {
 				cb->callback(sender, buffer + 8);
 				break;
 			}
diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 2cdd6b2..6922c11 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -95,7 +95,7 @@ static int zfcp_dbf_view_header(debug_info_t *id, struct debug_view *view,
 	struct timespec t;
 	char *p = out_buf;
 
-	if (strncmp(dump->tag, "dump", ZFCP_DBF_TAG_SIZE) != 0) {
+	if (memcmp(dump->tag, "dump", ZFCP_DBF_TAG_SIZE) != 0) {
 		stck_to_timespec(entry->id.stck, &t);
 		zfcp_dbf_out(&p, "timestamp", "%011lu:%06lu",
 			     t.tv_sec, t.tv_nsec);
@@ -412,23 +412,23 @@ static int zfcp_dbf_hba_view_format(debug_info_t *id, struct debug_view *view,
 	struct zfcp_dbf_hba_record *r = (struct zfcp_dbf_hba_record *)in_buf;
 	char *p = out_buf;
 
-	if (strncmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
+	if (memcmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
 		return 0;
 
 	zfcp_dbf_tag(&p, "tag", r->tag);
 	if (isalpha(r->tag2[0]))
 		zfcp_dbf_tag(&p, "tag2", r->tag2);
 
-	if (strncmp(r->tag, "resp", ZFCP_DBF_TAG_SIZE) == 0)
+	if (memcmp(r->tag, "resp", ZFCP_DBF_TAG_SIZE) == 0)
 		zfcp_dbf_hba_view_response(&p, &r->u.response);
-	else if (strncmp(r->tag, "stat", ZFCP_DBF_TAG_SIZE) == 0)
+	else if (memcmp(r->tag, "stat", ZFCP_DBF_TAG_SIZE) == 0)
 		zfcp_dbf_hba_view_status(&p, &r->u.status);
-	else if (strncmp(r->tag, "qdio", ZFCP_DBF_TAG_SIZE) == 0)
+	else if (memcmp(r->tag, "qdio", ZFCP_DBF_TAG_SIZE) == 0)
 		zfcp_dbf_hba_view_qdio(&p, &r->u.qdio);
-	else if (strncmp(r->tag, "berr", ZFCP_DBF_TAG_SIZE) == 0)
+	else if (memcmp(r->tag, "berr", ZFCP_DBF_TAG_SIZE) == 0)
 		zfcp_dbf_hba_view_berr(&p, &r->u.berr);
 
-	if (strncmp(r->tag, "resp", ZFCP_DBF_TAG_SIZE) != 0)
+	if (memcmp(r->tag, "resp", ZFCP_DBF_TAG_SIZE) != 0)
 		p += sprintf(p, "\n");
 	return p - out_buf;
 }
@@ -815,14 +815,14 @@ static int zfcp_dbf_san_view_format(debug_info_t *id, struct debug_view *view,
 	struct zfcp_dbf_san_record *r = (struct zfcp_dbf_san_record *)in_buf;
 	char *p = out_buf;
 
-	if (strncmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
+	if (memcmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
 		return 0;
 
 	zfcp_dbf_tag(&p, "tag", r->tag);
 	zfcp_dbf_out(&p, "fsf_reqid", "0x%0Lx", r->fsf_reqid);
 	zfcp_dbf_out(&p, "fsf_seqno", "0x%08x", r->fsf_seqno);
 
-	if (strncmp(r->tag, "octc", ZFCP_DBF_TAG_SIZE) == 0) {
+	if (memcmp(r->tag, "octc", ZFCP_DBF_TAG_SIZE) == 0) {
 		struct zfcp_dbf_san_record_ct_request *ct = &r->u.ct_req;
 		zfcp_dbf_out(&p, "d_id", "0x%06x", ct->d_id);
 		zfcp_dbf_out(&p, "cmd_req_code", "0x%04x", ct->cmd_req_code);
@@ -831,7 +831,7 @@ static int zfcp_dbf_san_view_format(debug_info_t *id, struct debug_view *view,
 		zfcp_dbf_out(&p, "gs_subtype", "0x%02x", ct->gs_subtype);
 		zfcp_dbf_out(&p, "options", "0x%02x", ct->options);
 		zfcp_dbf_out(&p, "max_res_size", "0x%04x", ct->max_res_size);
-	} else if (strncmp(r->tag, "rctc", ZFCP_DBF_TAG_SIZE) == 0) {
+	} else if (memcmp(r->tag, "rctc", ZFCP_DBF_TAG_SIZE) == 0) {
 		struct zfcp_dbf_san_record_ct_response *ct = &r->u.ct_resp;
 		zfcp_dbf_out(&p, "cmd_rsp_code", "0x%04x", ct->cmd_rsp_code);
 		zfcp_dbf_out(&p, "revision", "0x%02x", ct->revision);
@@ -839,9 +839,9 @@ static int zfcp_dbf_san_view_format(debug_info_t *id, struct debug_view *view,
 		zfcp_dbf_out(&p, "reason_code_expl", "0x%02x", ct->expl);
 		zfcp_dbf_out(&p, "vendor_unique", "0x%02x", ct->vendor_unique);
 		zfcp_dbf_out(&p, "max_res_size", "0x%04x", ct->max_res_size);
-	} else if (strncmp(r->tag, "oels", ZFCP_DBF_TAG_SIZE) == 0 ||
-		   strncmp(r->tag, "rels", ZFCP_DBF_TAG_SIZE) == 0 ||
-		   strncmp(r->tag, "iels", ZFCP_DBF_TAG_SIZE) == 0) {
+	} else if (memcmp(r->tag, "oels", ZFCP_DBF_TAG_SIZE) == 0 ||
+		   memcmp(r->tag, "rels", ZFCP_DBF_TAG_SIZE) == 0 ||
+		   memcmp(r->tag, "iels", ZFCP_DBF_TAG_SIZE) == 0) {
 		struct zfcp_dbf_san_record_els *els = &r->u.els;
 		zfcp_dbf_out(&p, "d_id", "0x%06x", els->d_id);
 	}
@@ -938,7 +938,7 @@ static int zfcp_dbf_scsi_view_format(debug_info_t *id, struct debug_view *view,
 	struct timespec t;
 	char *p = out_buf;
 
-	if (strncmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
+	if (memcmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
 		return 0;
 
 	zfcp_dbf_tag(&p, "tag", r->tag);
@@ -951,14 +951,14 @@ static int zfcp_dbf_scsi_view_format(debug_info_t *id, struct debug_view *view,
 		      0, ZFCP_DBF_SCSI_OPCODE);
 	zfcp_dbf_out(&p, "scsi_retries", "0x%02x", r->scsi_retries);
 	zfcp_dbf_out(&p, "scsi_allowed", "0x%02x", r->scsi_allowed);
-	if (strncmp(r->tag, "abrt", ZFCP_DBF_TAG_SIZE) == 0)
+	if (memcmp(r->tag, "abrt", ZFCP_DBF_TAG_SIZE) == 0)
 		zfcp_dbf_out(&p, "old_fsf_reqid", "0x%0Lx", r->old_fsf_reqid);
 	zfcp_dbf_out(&p, "fsf_reqid", "0x%0Lx", r->fsf_reqid);
 	zfcp_dbf_out(&p, "fsf_seqno", "0x%08x", r->fsf_seqno);
 	stck_to_timespec(r->fsf_issued, &t);
 	zfcp_dbf_out(&p, "fsf_issued", "%011lu:%06lu", t.tv_sec, t.tv_nsec);
 
-	if (strncmp(r->tag, "rslt", ZFCP_DBF_TAG_SIZE) == 0) {
+	if (memcmp(r->tag, "rslt", ZFCP_DBF_TAG_SIZE) == 0) {
 		zfcp_dbf_out(&p, "fcp_rsp_validity", "0x%02x", r->rsp_validity);
 		zfcp_dbf_out(&p, "fcp_rsp_scsi_status", "0x%02x",
 			     r->rsp_scsi_status);
diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
index 8647256..fa455b1 100644
--- a/drivers/scsi/NCR_D700.c
+++ b/drivers/scsi/NCR_D700.c
@@ -132,11 +132,11 @@ param_setup(char *string)
 	while(pos != NULL && (next = strchr(pos, ':')) != NULL) {
 		int val = (int)simple_strtoul(++next, NULL, 0);
 
-		if(!strncmp(pos, "slot:", 5))
+		if(!memcmp(pos, "slot:", 5))
 			slot = val;
-		else if(!strncmp(pos, "siop:", 5))
+		else if(!memcmp(pos, "siop:", 5))
 			siop = val;
-		else if(!strncmp(pos, "id:", 3)) {
+		else if(!memcmp(pos, "id:", 3)) {
 			if(slot == -1) {
 				printk(KERN_WARNING "NCR D700: Must specify slot for id parameter\n");
 			} else if(slot > MCA_MAX_SLOT_NR) {
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 081c6de..f2dd866 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -8163,7 +8163,7 @@ static void AscAsyncFix(ASC_DVC_VAR *asc_dvc, struct scsi_device *sdev)
 	if (asc_dvc->init_sdtr & tid_bits)
 		return;
 
-	if ((type == TYPE_ROM) && (strncmp(sdev->vendor, "HP ", 3) == 0))
+	if ((type == TYPE_ROM) && (memcmp(sdev->vendor, "HP ", 3) == 0))
 		asc_dvc->pci_fix_asyn_xfer_always |= tid_bits;
 
 	asc_dvc->pci_fix_asyn_xfer |= tid_bits;
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index c5169f0..b90eaf3 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3271,11 +3271,11 @@ static int get_ports(struct Scsi_Host *shpnt, char *pos)
 
 static int aha152x_set_info(char *buffer, int length, struct Scsi_Host *shpnt)
 {
-	if(!shpnt || !buffer || length<8 || strncmp("aha152x ", buffer, 8)!=0)
+	if(!shpnt || !buffer || length<8 || memcmp("aha152x ", buffer, 8)!=0)
 		return -EINVAL;
 
 #if defined(AHA152X_DEBUG)
-	if(length>14 && strncmp("debug ", buffer+8, 6)==0) {
+	if(length>14 && memcmp("debug ", buffer+8, 6)==0) {
 		int debug = HOSTDATA(shpnt)->debug;
 
 		HOSTDATA(shpnt)->debug = simple_strtoul(buffer+14, NULL, 0);
@@ -3284,7 +3284,7 @@ static int aha152x_set_info(char *buffer, int length, struct Scsi_Host *shpnt)
 	} else
 #endif
 #if defined(AHA152X_STAT)
-	if(length>13 && strncmp("reset", buffer+8, 5)==0) {
+	if(length>13 && memcmp("reset", buffer+8, 5)==0) {
 		int i;
 
 		HOSTDATA(shpnt)->total_commands=0;
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 25d0666..58e3dbd 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1181,32 +1181,32 @@ aic79xx_setup(char *s)
 		for (i = 0; i < ARRAY_SIZE(options); i++) {
 
 			n = strlen(options[i].name);
-			if (strncmp(options[i].name, p, n) == 0)
+			if (memcmp(options[i].name, p, n) == 0)
 				break;
 		}
 		if (i == ARRAY_SIZE(options))
 			continue;
 
-		if (strncmp(p, "global_tag_depth", n) == 0) {
+		if (memcmp(p, "global_tag_depth", n) == 0) {
 			ahd_linux_setup_tag_info_global(p + n);
-		} else if (strncmp(p, "tag_info", n) == 0) {
+		} else if (memcmp(p, "tag_info", n) == 0) {
 			s = ahd_parse_brace_option("tag_info", p + n, end,
 			    2, ahd_linux_setup_tag_info, 0);
-		} else if (strncmp(p, "slewrate", n) == 0) {
+		} else if (memcmp(p, "slewrate", n) == 0) {
 			s = ahd_parse_brace_option("slewrate",
 			    p + n, end, 1, ahd_linux_setup_iocell_info,
 			    AIC79XX_SLEWRATE_INDEX);
-		} else if (strncmp(p, "precomp", n) == 0) {
+		} else if (memcmp(p, "precomp", n) == 0) {
 			s = ahd_parse_brace_option("precomp",
 			    p + n, end, 1, ahd_linux_setup_iocell_info,
 			    AIC79XX_PRECOMP_INDEX);
-		} else if (strncmp(p, "amplitude", n) == 0) {
+		} else if (memcmp(p, "amplitude", n) == 0) {
 			s = ahd_parse_brace_option("amplitude",
 			    p + n, end, 1, ahd_linux_setup_iocell_info,
 			    AIC79XX_AMPLITUDE_INDEX);
 		} else if (p[n] == ':') {
 			*(options[i].flag) = simple_strtoul(p + n + 1, NULL, 0);
-		} else if (!strncmp(p, "verbose", n)) {
+		} else if (!memcmp(p, "verbose", n)) {
 			*(options[i].flag) = 1;
 		} else {
 			*(options[i].flag) ^= 0xFFFFFFFF;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 4a359bb..93fbd65 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1067,20 +1067,20 @@ aic7xxx_setup(char *s)
 		for (i = 0; i < ARRAY_SIZE(options); i++) {
 
 			n = strlen(options[i].name);
-			if (strncmp(options[i].name, p, n) == 0)
+			if (memcmp(options[i].name, p, n) == 0)
 				break;
 		}
 		if (i == ARRAY_SIZE(options))
 			continue;
 
-		if (strncmp(p, "global_tag_depth", n) == 0) {
+		if (memcmp(p, "global_tag_depth", n) == 0) {
 			ahc_linux_setup_tag_info_global(p + n);
-		} else if (strncmp(p, "tag_info", n) == 0) {
+		} else if (memcmp(p, "tag_info", n) == 0) {
 			s = ahc_parse_brace_option("tag_info", p + n, end,
 			    2, ahc_linux_setup_tag_info, 0);
 		} else if (p[n] == ':') {
 			*(options[i].flag) = simple_strtoul(p + n + 1, NULL, 0);
-		} else if (strncmp(p, "verbose", n) == 0) {
+		} else if (memcmp(p, "verbose", n) == 0) {
 			*(options[i].flag) = 1;
 		} else {
 			*(options[i].flag) ^= 0xFFFFFFFF;
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 4ff60a0..0121b9d 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -1372,9 +1372,9 @@ aic7xxx_setup(char *s)
     for (i = 0; i < ARRAY_SIZE(options); i++)
     {
       n = strlen(options[i].name);
-      if (!strncmp(options[i].name, p, n))
+      if (!memcmp(options[i].name, p, n))
       {
-        if (!strncmp(p, "tag_info", n))
+        if (!memcmp(p, "tag_info", n))
         {
           if (p[n] == ':')
           {
@@ -1455,19 +1455,19 @@ aic7xxx_setup(char *s)
         else if (p[n] == ':')
         {
           *(options[i].flag) = simple_strtoul(p + n + 1, NULL, 0);
-          if(!strncmp(p, "seltime", n))
+          if(!memcmp(p, "seltime", n))
           {
             *(options[i].flag) = (*(options[i].flag) % 4) << 3;
           }
         }
-        else if (!strncmp(p, "verbose", n))
+        else if (!memcmp(p, "verbose", n))
         {
           *(options[i].flag) = 0xff29;
         }
         else
         {
           *(options[i].flag) = ~(*(options[i].flag));
-          if(!strncmp(p, "seltime", n))
+          if(!memcmp(p, "seltime", n))
           {
             *(options[i].flag) = (*(options[i].flag) % 4) << 3;
           }
diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index edb43fd..885aace 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -236,8 +236,8 @@ static int asd_get_bios_chim(struct asd_ha_struct *asd_ha,
 		ASD_DPRINTK("couldn't read ocm segment\n");
 		goto out2;
 	}
-	if (strncmp(bc_struct->sig, "SOIB", 4)
-	    && strncmp(bc_struct->sig, "IPSA", 4)) {
+	if (memcmp(bc_struct->sig, "SOIB", 4)
+	    && memcmp(bc_struct->sig, "IPSA", 4)) {
 		ASD_DPRINTK("BIOS_CHIM entry has no valid sig(%c%c%c%c)\n",
 			    bc_struct->sig[0], bc_struct->sig[1],
 			    bc_struct->sig[2], bc_struct->sig[3]);
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index c9902b5..d2e3f09 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -318,11 +318,11 @@ cumanascsi_2_set_proc_info(struct Scsi_Host *host, char *buffer, int length)
 {
 	int ret = length;
 
-	if (length >= 11 && strncmp(buffer, "CUMANASCSI2", 11) == 0) {
+	if (length >= 11 && memcmp(buffer, "CUMANASCSI2", 11) == 0) {
 		buffer += 11;
 		length -= 11;
 
-		if (length >= 5 && strncmp(buffer, "term=", 5) == 0) {
+		if (length >= 5 && memcmp(buffer, "term=", 5) == 0) {
 			if (buffer[5] == '1')
 				cumanascsi_2_terminator_ctl(host, 1);
 			else if (buffer[5] == '0')
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index d843513..885738c 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -403,11 +403,11 @@ eesoxscsi_set_proc_info(struct Scsi_Host *host, char *buffer, int length)
 {
 	int ret = length;
 
-	if (length >= 9 && strncmp(buffer, "EESOXSCSI", 9) == 0) {
+	if (length >= 9 && memcmp(buffer, "EESOXSCSI", 9) == 0) {
 		buffer += 9;
 		length -= 9;
 
-		if (length >= 5 && strncmp(buffer, "term=", 5) == 0) {
+		if (length >= 5 && memcmp(buffer, "term=", 5) == 0) {
 			if (buffer[5] == '1')
 				eesoxscsi_terminator_ctl(host, 1);
 			else if (buffer[5] == '0')
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 2b2ce21..d26841c 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -111,9 +111,9 @@ static int __init fas216_log_setup(char *str)
 				level_mask |= -1;
 			break;
 		case 'b':
-			if (strncmp(s, "bus", 3) == 0)
+			if (memcmp(s, "bus", 3) == 0)
 				level_mask |= LOG_BUSSERVICE;
-			if (strncmp(s, "buf", 3) == 0)
+			if (memcmp(s, "buf", 3) == 0)
 				level_mask |= LOG_BUFFER;
 			break;
 		case 'c':
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index e2297b4..0640177 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -206,11 +206,11 @@ powertecscsi_set_proc_info(struct Scsi_Host *host, char *buffer, int length)
 {
 	int ret = length;
 
-	if (length >= 12 && strncmp(buffer, "POWERTECSCSI", 12) == 0) {
+	if (length >= 12 && memcmp(buffer, "POWERTECSCSI", 12) == 0) {
 		buffer += 12;
 		length -= 12;
 
-		if (length >= 5 && strncmp(buffer, "term=", 5) == 0) {
+		if (length >= 5 && memcmp(buffer, "term=", 5) == 0) {
 			if (buffer[5] == '1')
 				powertecscsi_terminator_ctl(host, 1);
 			else if (buffer[5] == '0')
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 377cbff..9c5f956 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -2616,7 +2616,7 @@ bfa_fcs_lport_ms_gmal_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 
 		gmal_entry = (struct fcgs_gmal_entry_s *)gmal_resp->ms_ma;
 		while (num_entries > 0) {
-			if (strncmp(gmal_entry->prefix,
+			if (memcmp(gmal_entry->prefix,
 				CT_GMAL_RESP_PREFIX_HTTP,
 				sizeof(gmal_entry->prefix)) == 0) {
 
diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 6fae3d2..ca57b5f 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -42,7 +42,7 @@ static struct scsi_device_handler *get_device_handler(const char *name)
 
 	spin_lock(&list_lock);
 	list_for_each_entry(tmp, &scsi_dh_list, list) {
-		if (!strncmp(tmp->name, name, strlen(tmp->name))) {
+		if (!memcmp(tmp->name, name, strlen(tmp->name))) {
 			found = tmp;
 			break;
 		}
@@ -60,8 +60,8 @@ scsi_dh_cache_lookup(struct scsi_device *sdev)
 
 	spin_lock(&list_lock);
 	list_for_each_entry(tmp, &scsi_dh_dev_list, node) {
-		if (!strncmp(sdev->vendor, tmp->vendor, strlen(tmp->vendor)) &&
-		    !strncmp(sdev->model, tmp->model, strlen(tmp->model))) {
+		if (!memcmp(sdev->vendor, tmp->vendor, strlen(tmp->vendor)) &&
+		    !memcmp(sdev->model, tmp->model, strlen(tmp->model))) {
 			found_dh = tmp->handler;
 			break;
 		}
@@ -77,9 +77,9 @@ static int scsi_dh_handler_lookup(struct scsi_device_handler *scsi_dh,
 	int i, found = 0;
 
 	for(i = 0; scsi_dh->devlist[i].vendor; i++) {
-		if (!strncmp(sdev->vendor, scsi_dh->devlist[i].vendor,
+		if (!memcmp(sdev->vendor, scsi_dh->devlist[i].vendor,
 			     strlen(scsi_dh->devlist[i].vendor)) &&
-		    !strncmp(sdev->model, scsi_dh->devlist[i].model,
+		    !memcmp(sdev->model, scsi_dh->devlist[i].model,
 			     strlen(scsi_dh->devlist[i].model))) {
 			found = 1;
 			break;
@@ -216,13 +216,13 @@ store_dh_state(struct device *dev, struct device_attribute *attr,
 		err = scsi_dh_handler_attach(sdev, scsi_dh);
 	} else {
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
-		if (!strncmp(buf, "detach", 6)) {
+		if (!memcmp(buf, "detach", 6)) {
 			/*
 			 * Detach from a device handler
 			 */
 			scsi_dh_handler_detach(sdev, scsi_dh);
 			err = 0;
-		} else if (!strncmp(buf, "activate", 8)) {
+		} else if (!memcmp(buf, "activate", 8)) {
 			/*
 			 * Activate a device handler
 			 */
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 6faf472..c15206a 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -224,7 +224,7 @@ static char * parse_sp_model(struct scsi_device *sdev, unsigned char *buffer)
 			    "%s: Invalid information section length %d\n",
 			    CLARIION_NAME, len);
 		/* Check for old FC arrays */
-		if (!strncmp(buffer + 8, "DGC", 3)) {
+		if (!memcmp(buffer + 8, "DGC", 3)) {
 			/* Old FC array, not supporting extended information */
 			sp_model = emc_default_str;
 		}
@@ -489,7 +489,7 @@ static int clariion_std_inquiry(struct scsi_device *sdev,
 	/*
 	 * FC Series arrays do not support long trespass
 	 */
-	if (!strlen(sp_model) || !strncmp(sp_model, "FC",2))
+	if (!strlen(sp_model) || !memcmp(sp_model, "FC",2))
 		csdev->flags |= CLARIION_SHORT_TRESPASS;
 
 	sdev_printk(KERN_INFO, sdev,
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 53925ac..dbedd6a 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1475,25 +1475,25 @@ static void internal_setup(char *str, int *ints)
 		else
 			val = (int)simple_strtoul(pc, NULL, 0);
 
-		if (!strncmp(cur, "lc:", 3))
+		if (!memcmp(cur, "lc:", 3))
 			linked_comm = val;
-		else if (!strncmp(cur, "tm:", 3))
+		else if (!memcmp(cur, "tm:", 3))
 			tag_mode = val;
-		else if (!strncmp(cur, "tc:", 3))
+		else if (!memcmp(cur, "tc:", 3))
 			tag_mode = val;
-		else if (!strncmp(cur, "mq:", 3))
+		else if (!memcmp(cur, "mq:", 3))
 			max_queue_depth = val;
-		else if (!strncmp(cur, "ls:", 3))
+		else if (!memcmp(cur, "ls:", 3))
 			link_statistics = val;
-		else if (!strncmp(cur, "et:", 3))
+		else if (!memcmp(cur, "et:", 3))
 			ext_tran = val;
-		else if (!strncmp(cur, "rs:", 3))
+		else if (!memcmp(cur, "rs:", 3))
 			rev_scan = val;
-		else if (!strncmp(cur, "ip:", 3))
+		else if (!memcmp(cur, "ip:", 3))
 			isa_probe = val;
-		else if (!strncmp(cur, "ep:", 3))
+		else if (!memcmp(cur, "ep:", 3))
 			eisa_probe = val;
-		else if (!strncmp(cur, "pp:", 3))
+		else if (!memcmp(cur, "pp:", 3))
 			pci_probe = val;
 
 		if ((cur = strchr(cur, ',')))
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 7636570..a802e0f 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3796,23 +3796,23 @@ static void __init internal_setup(char *str,int *ints)
         else
             val = (int)simple_strtoul(cur_str, NULL, 0);
 
-        if (!strncmp(argv, "disable:", 8))
+        if (!memcmp(argv, "disable:", 8))
             disable = val;
-        else if (!strncmp(argv, "reserve_mode:", 13))
+        else if (!memcmp(argv, "reserve_mode:", 13))
             reserve_mode = val;
-        else if (!strncmp(argv, "reverse_scan:", 13))
+        else if (!memcmp(argv, "reverse_scan:", 13))
             reverse_scan = val;
-        else if (!strncmp(argv, "hdr_channel:", 12))
+        else if (!memcmp(argv, "hdr_channel:", 12))
             hdr_channel = val;
-        else if (!strncmp(argv, "max_ids:", 8))
+        else if (!memcmp(argv, "max_ids:", 8))
             max_ids = val;
-        else if (!strncmp(argv, "rescan:", 7))
+        else if (!memcmp(argv, "rescan:", 7))
             rescan = val;
-        else if (!strncmp(argv, "shared_access:", 14))
+        else if (!memcmp(argv, "shared_access:", 14))
             shared_access = val;
-        else if (!strncmp(argv, "probe_eisa_isa:", 15))
+        else if (!memcmp(argv, "probe_eisa_isa:", 15))
             probe_eisa_isa = val;
-        else if (!strncmp(argv, "reserve_list:", 13)) {
+        else if (!memcmp(argv, "reserve_list:", 13)) {
             reserve_list[0] = val;
             for (i = 1; i < MAX_RES_ARGS; i++) {
                 cur_str = strchr(cur_str, ',');
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 0572b9b..e0df4ba 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -27,7 +27,7 @@ static int gdth_set_info(char *buffer,int length,struct Scsi_Host *host,
     TRACE2(("gdth_set_info() ha %d\n",ha->hanum,));
 
     if (length >= 4) {
-        if (strncmp(buffer,"gdth",4) == 0) {
+        if (memcmp(buffer,"gdth",4) == 0) {
             buffer += 5;
             length -= 5;
             ret_val = gdth_set_asc_info(host, buffer, length, ha);
@@ -56,7 +56,7 @@ static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
     wb_mode = 0;
     found = FALSE;
 
-    if (length >= 5 && strncmp(buffer,"flush",5)==0) {
+    if (length >= 5 && memcmp(buffer,"flush",5)==0) {
         buffer += 6;
         length -= 6;
         if (length && *buffer>='0' && *buffer<='9') {
@@ -95,17 +95,17 @@ static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
         return(orig_length);
     }
 
-    if (length >= 7 && strncmp(buffer,"wbp_off",7)==0) {
+    if (length >= 7 && memcmp(buffer,"wbp_off",7)==0) {
         buffer += 8;
         length -= 8;
         printk("GDT: Disabling write back permanently .. ");
         wb_mode = 1;
-    } else if (length >= 6 && strncmp(buffer,"wbp_on",6)==0) {
+    } else if (length >= 6 && memcmp(buffer,"wbp_on",6)==0) {
         buffer += 7;
         length -= 7;
         printk("GDT: Enabling write back permanently .. ");
         wb_mode = 2;
-    } else if (length >= 6 && strncmp(buffer,"wb_off",6)==0) {
+    } else if (length >= 6 && memcmp(buffer,"wb_off",6)==0) {
         buffer += 7;
         length -= 7;
         printk("GDT: Disabling write back commands .. ");
@@ -116,7 +116,7 @@ static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
             printk("Not supported !\n");
         }
         return(orig_length);
-    } else if (length >= 5 && strncmp(buffer,"wb_on",5)==0) {
+    } else if (length >= 5 && memcmp(buffer,"wb_on",5)==0) {
         buffer += 6;
         length -= 6;
         printk("GDT: Enabling write back commands .. ");
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b2fb2b2..cefddc4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1517,7 +1517,7 @@ static int is_msa2xxx(struct ctlr_info *h, struct hpsa_scsi_dev_t *device)
 	int i;
 
 	for (i = 0; msa2xxx_model[i]; i++)
-		if (strncmp(device->model, msa2xxx_model[i],
+		if (memcmp(device->model, msa2xxx_model[i],
 			strlen(msa2xxx_model[i])) == 0)
 			return 1;
 	return 0;
@@ -1822,7 +1822,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 #define OBDR_TAPE_SIG "$DR-10"
 				strncpy(obdr_sig, &inq_buff[43], 6);
 				obdr_sig[6] = '\0';
-				if (strncmp(obdr_sig, OBDR_TAPE_SIG, 6) != 0)
+				if (memcmp(obdr_sig, OBDR_TAPE_SIG, 6) != 0)
 					/* Not OBDR device, ignore it. */
 					break;
 			}
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 99aa0e5..1fac5ef 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -125,7 +125,7 @@ static inline int imm_proc_write(imm_struct *dev, char *buffer, int length)
 {
 	unsigned long x;
 
-	if ((length > 5) && (strncmp(buffer, "mode=", 5) == 0)) {
+	if ((length > 5) && (memcmp(buffer, "mode=", 5) == 0)) {
 		x = simple_strtoul(buffer + 5, NULL, 0);
 		dev->mode = x;
 		return length;
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 6568aab..82b6856 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -1855,7 +1855,7 @@ static int __init check_setup_args(char *key, int *val, char *buf)
 	for (x = 0; x < MAX_SETUP_ARGS; x++) {
 		if (setup_used[x])
 			continue;
-		if (!strncmp(setup_args[x], key, strlen(key)))
+		if (!memcmp(setup_args[x], key, strlen(key)))
 			break;
 	}
 	if (x == MAX_SETUP_ARGS)
@@ -2195,29 +2195,29 @@ static int in2000_proc_info(struct Scsi_Host *instance, char *buf, char **start,
 	if (in) {
 		buf[len] = '\0';
 		bp = buf;
-		if (!strncmp(bp, "debug:", 6)) {
+		if (!memcmp(bp, "debug:", 6)) {
 			bp += 6;
 			hd->args = simple_strtoul(bp, NULL, 0) & DB_MASK;
-		} else if (!strncmp(bp, "disconnect:", 11)) {
+		} else if (!memcmp(bp, "disconnect:", 11)) {
 			bp += 11;
 			x = simple_strtoul(bp, NULL, 0);
 			if (x < DIS_NEVER || x > DIS_ALWAYS)
 				x = DIS_ADAPTIVE;
 			hd->disconnect = x;
-		} else if (!strncmp(bp, "period:", 7)) {
+		} else if (!memcmp(bp, "period:", 7)) {
 			bp += 7;
 			x = simple_strtoul(bp, NULL, 0);
 			hd->default_sx_per = sx_table[round_period((unsigned int) x)].period_ns;
-		} else if (!strncmp(bp, "resync:", 7)) {
+		} else if (!memcmp(bp, "resync:", 7)) {
 			bp += 7;
 			x = simple_strtoul(bp, NULL, 0);
 			for (i = 0; i < 7; i++)
 				if (x & (1 << i))
 					hd->sync_stat[i] = SS_UNSET;
-		} else if (!strncmp(bp, "proc:", 5)) {
+		} else if (!memcmp(bp, "proc:", 5)) {
 			bp += 5;
 			hd->proc = simple_strtoul(bp, NULL, 0);
-		} else if (!strncmp(bp, "level2:", 7)) {
+		} else if (!memcmp(bp, "level2:", 7)) {
 			bp += 7;
 			hd->level2 = simple_strtoul(bp, NULL, 0);
 		}
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5bbaee5..ea5008e 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3366,7 +3366,7 @@ static ssize_t ipr_store_adapter_state(struct device *dev,
 		return -EACCES;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	if (ioa_cfg->ioa_is_dead && !strncmp(buf, "online", 6)) {
+	if (ioa_cfg->ioa_is_dead && !memcmp(buf, "online", 6)) {
 		ioa_cfg->ioa_is_dead = 0;
 		ioa_cfg->reset_retries = 0;
 		ioa_cfg->in_ioa_bringdown = 0;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index c1cbec0..7628800 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -505,10 +505,10 @@ lpfc_link_state_store(struct device *dev, struct device_attribute *attr,
 
 	int status = -EINVAL;
 
-	if ((strncmp(buf, "up", sizeof("up") - 1) == 0) &&
+	if ((memcmp(buf, "up", sizeof("up") - 1) == 0) &&
 			(phba->link_state == LPFC_LINK_DOWN))
 		status = phba->lpfc_hba_init_link(phba, MBX_NOWAIT);
-	else if ((strncmp(buf, "down", sizeof("down") - 1) == 0) &&
+	else if ((memcmp(buf, "down", sizeof("down") - 1) == 0) &&
 			(phba->link_state >= LPFC_LINK_UP))
 		status = phba->lpfc_hba_down_link(phba, MBX_NOWAIT);
 
@@ -737,7 +737,7 @@ lpfc_issue_reset(struct device *dev, struct device_attribute *attr,
 
 	int status = -EINVAL;
 
-	if (strncmp(buf, "selective", sizeof("selective") - 1) == 0)
+	if (memcmp(buf, "selective", sizeof("selective") - 1) == 0)
 		status = lpfc_selective_reset(phba);
 
 	if (status == 0)
@@ -821,18 +821,18 @@ lpfc_board_mode_store(struct device *dev, struct device_attribute *attr,
 		return -EACCES;
 	init_completion(&online_compl);
 
-	if(strncmp(buf, "online", sizeof("online") - 1) == 0) {
+	if(memcmp(buf, "online", sizeof("online") - 1) == 0) {
 		lpfc_workq_post_event(phba, &status, &online_compl,
 				      LPFC_EVT_ONLINE);
 		wait_for_completion(&online_compl);
-	} else if (strncmp(buf, "offline", sizeof("offline") - 1) == 0)
+	} else if (memcmp(buf, "offline", sizeof("offline") - 1) == 0)
 		status = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
-	else if (strncmp(buf, "warm", sizeof("warm") - 1) == 0)
+	else if (memcmp(buf, "warm", sizeof("warm") - 1) == 0)
 		if (phba->sli_rev == LPFC_SLI_REV4)
 			return -EINVAL;
 		else
 			status = lpfc_do_offline(phba, LPFC_EVT_WARM_START);
-	else if (strncmp(buf, "error", sizeof("error") - 1) == 0)
+	else if (memcmp(buf, "error", sizeof("error") - 1) == 0)
 		if (phba->sli_rev == LPFC_SLI_REV4)
 			return -EINVAL;
 		else
@@ -1764,7 +1764,7 @@ lpfc_soft_wwn_enable_store(struct device *dev, struct device_attribute *attr,
 		cnt--;
 
 	if ((cnt != strlen(lpfc_soft_wwn_key)) ||
-	    (strncmp(buf, lpfc_soft_wwn_key, strlen(lpfc_soft_wwn_key)) != 0))
+	    (memcmp(buf, lpfc_soft_wwn_key, strlen(lpfc_soft_wwn_key)) != 0))
 		return -EINVAL;
 
 	phba->soft_wwn_enable = 1;
@@ -2440,7 +2440,7 @@ lpfc_topology_store(struct device *dev, struct device_attribute *attr,
 	int err;
 	uint32_t prev_val;
 
-	if (!strncmp(buf, "nolip ", strlen("nolip "))) {
+	if (!memcmp(buf, "nolip ", strlen("nolip "))) {
 		nolip = 1;
 		val_buf = &buf[strlen("nolip ")];
 	}
@@ -2543,7 +2543,7 @@ lpfc_stat_data_ctrl_store(struct device *dev, struct device_attribute *attr,
 	char *bucket_type_str, *base_str, *step_str;
 	unsigned long base, step, bucket_type;
 
-	if (!strncmp(buf, "setbucket", strlen("setbucket"))) {
+	if (!memcmp(buf, "setbucket", strlen("setbucket"))) {
 		if (strlen(buf) > (LPFC_MAX_DATA_CTRL_LEN - 1))
 			return -EINVAL;
 
@@ -2558,9 +2558,9 @@ lpfc_stat_data_ctrl_store(struct device *dev, struct device_attribute *attr,
 		if (!bucket_type_str)
 			return -EINVAL;
 
-		if (!strncmp(bucket_type_str, "linear", strlen("linear")))
+		if (!memcmp(bucket_type_str, "linear", strlen("linear")))
 			bucket_type = LPFC_LINEAR_BUCKET;
-		else if (!strncmp(bucket_type_str, "power2", strlen("power2")))
+		else if (!memcmp(bucket_type_str, "power2", strlen("power2")))
 			bucket_type = LPFC_POWER2_BUCKET;
 		else
 			return -EINVAL;
@@ -2609,7 +2609,7 @@ lpfc_stat_data_ctrl_store(struct device *dev, struct device_attribute *attr,
 		return strlen(buf);
 	}
 
-	if (!strncmp(buf, "destroybucket", strlen("destroybucket"))) {
+	if (!memcmp(buf, "destroybucket", strlen("destroybucket"))) {
 		vports = lpfc_create_vport_work_array(phba);
 		if (vports == NULL)
 			return -ENOMEM;
@@ -2630,7 +2630,7 @@ lpfc_stat_data_ctrl_store(struct device *dev, struct device_attribute *attr,
 		return strlen(buf);
 	}
 
-	if (!strncmp(buf, "start", strlen("start"))) {
+	if (!memcmp(buf, "start", strlen("start"))) {
 		/* If no buckets configured return error */
 		if (phba->bucket_type == LPFC_NO_BUCKET)
 			return -EINVAL;
@@ -2645,7 +2645,7 @@ lpfc_stat_data_ctrl_store(struct device *dev, struct device_attribute *attr,
 		return strlen(buf);
 	}
 
-	if (!strncmp(buf, "stop", strlen("stop"))) {
+	if (!memcmp(buf, "stop", strlen("stop"))) {
 		spin_lock_irq(shost->host_lock);
 		if (vport->stat_data_enabled == 0) {
 			spin_unlock_irq(shost->host_lock);
@@ -2657,7 +2657,7 @@ lpfc_stat_data_ctrl_store(struct device *dev, struct device_attribute *attr,
 		return strlen(buf);
 	}
 
-	if (!strncmp(buf, "reset", strlen("reset"))) {
+	if (!memcmp(buf, "reset", strlen("reset"))) {
 		if ((phba->bucket_type == LPFC_NO_BUCKET)
 			|| !vport->stat_data_enabled)
 			return strlen(buf);
@@ -2875,7 +2875,7 @@ lpfc_link_speed_store(struct device *dev, struct device_attribute *attr,
 	int err;
 	uint32_t prev_val;
 
-	if (!strncmp(buf, "nolip ", strlen("nolip "))) {
+	if (!memcmp(buf, "nolip ", strlen("nolip "))) {
 		nolip = 1;
 		val_buf = &buf[strlen("nolip ")];
 	}
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 46cc382..70a893f 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -655,7 +655,7 @@ static int __init get_setup_token(char *p)
 	while (cur != NULL && (pc = strchr(cur, ':')) != NULL) {
 		++pc;
 		++i;
-		if (!strncmp(p, cur, pc - cur))
+		if (!memcmp(p, cur, pc - cur))
 			return i;
 		cur = pc;
 	}
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 54de1d1..1a53ab7 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -2419,8 +2419,8 @@ static int __osst_analyze_headers(struct osst_tape * STp, struct osst_request **
 #endif
 		return 0;
 	}
-	if (strncmp(header->ident_str, "ADR_SEQ", 7) != 0 &&
-	    strncmp(header->ident_str, "ADR-SEQ", 7) != 0) {
+	if (memcmp(header->ident_str, "ADR_SEQ", 7) != 0 &&
+	    memcmp(header->ident_str, "ADR-SEQ", 7) != 0) {
 		strlcpy(id_string, header->ident_str, 8);
 #if DEBUG
 		printk(OSST_DEB_MSG "%s:D: Invalid header identification string %s\n", name, id_string);
@@ -5593,7 +5593,7 @@ static int __init osst_setup (char *str)
 	while (stp != NULL) {
 		for (i = 0; i < ARRAY_SIZE(parms); i++) {
 			int len = strlen(parms[i].name);
-			if (!strncmp(stp, parms[i].name, len) &&
+			if (!memcmp(stp, parms[i].name, len) &&
 			    (*(stp + len) == ':' || *(stp + len) == '=')) {
 				*parms[i].val =
 					simple_strtoul(stp + len + 1, NULL, 0);
@@ -5651,9 +5651,9 @@ static	struct	osst_support_data support_list[] = {
 	 * 	 	 * emulation layer (ide-scsi, usb-storage, ...) */
 
 	for (rp=&(support_list[0]); rp->vendor != NULL; rp++)
-		if (!strncmp(rp->vendor, SDp->vendor, strlen(rp->vendor)) &&
-		    !strncmp(rp->model, SDp->model, strlen(rp->model)) &&
-		    !strncmp(rp->rev, SDp->rev, strlen(rp->rev))) 
+		if (!memcmp(rp->vendor, SDp->vendor, strlen(rp->vendor)) &&
+		    !memcmp(rp->model, SDp->model, strlen(rp->model)) &&
+		    !memcmp(rp->rev, SDp->rev, strlen(rp->rev))) 
 			return 1;
 	return 0;
 }
@@ -5927,8 +5927,8 @@ static int osst_probe(struct device *dev)
 	tpnt->os_fw_rev = osst_parse_firmware_rev (SDp->rev);
 	tpnt->omit_blklims = 1;
 
-	tpnt->poll = (strncmp(SDp->model, "DI-", 3) == 0) || 
-		     (strncmp(SDp->model, "FW-", 3) == 0) || OSST_FW_NEED_POLL(tpnt->os_fw_rev,SDp);
+	tpnt->poll = (memcmp(SDp->model, "DI-", 3) == 0) || 
+		     (memcmp(SDp->model, "FW-", 3) == 0) || OSST_FW_NEED_POLL(tpnt->os_fw_rev,SDp);
 	tpnt->frame_in_buffer = 0;
 	tpnt->header_ok = 0;
 	tpnt->linux_media = 0;
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index d164c96..5a6b3df 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -122,12 +122,12 @@ static inline int ppa_proc_write(ppa_struct *dev, char *buffer, int length)
 {
 	unsigned long x;
 
-	if ((length > 5) && (strncmp(buffer, "mode=", 5) == 0)) {
+	if ((length > 5) && (memcmp(buffer, "mode=", 5) == 0)) {
 		x = simple_strtoul(buffer + 5, NULL, 0);
 		dev->mode = x;
 		return length;
 	}
-	if ((length > 10) && (strncmp(buffer, "recon_tmo=", 10) == 0)) {
+	if ((length > 10) && (memcmp(buffer, "recon_tmo=", 10) == 0)) {
 		x = simple_strtoul(buffer + 10, NULL, 0);
 		dev->recon_tmo = x;
 		printk(KERN_INFO "ppa: recon_tmo set to %ld\n", x);
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 5dec684..67403af 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4200,7 +4200,7 @@ qla1280_get_token(char *str)
 
 	if (sep) {
 		for (i = 0; i < ARRAY_SIZE(setup_token); i++) {
-			if (!strncmp(setup_token[i].token, str, (sep - str))) {
+			if (!memcmp(setup_token[i].token, str, (sep - str))) {
 				ret =  setup_token[i].val;
 				break;
 			}
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 76de957..f6f88b4 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2815,7 +2815,7 @@ qla2xxx_get_vpd_field(scsi_qla_host_t *vha, char *key, char *str, size_t size)
 	while (pos < end && *pos != 0x78) {
 		len = (*pos == 0x82) ? pos[1] : pos[2];
 
-		if (!strncmp(pos, key, strlen(key)))
+		if (!memcmp(pos, key, strlen(key)))
 			break;
 
 		if (*pos != 0x90 && *pos != 0x91)
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index c99da92..124a086 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -344,7 +344,7 @@ static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 	 * Usage: echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi
 	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
 	 */
-	if (!strncmp("scsi add-single-device", buffer, 22)) {
+	if (!memcmp("scsi add-single-device", buffer, 22)) {
 		p = buffer + 23;
 
 		host = simple_strtoul(p, &p, 0);
@@ -358,7 +358,7 @@ static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 	 * Usage: echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi
 	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
 	 */
-	} else if (!strncmp("scsi remove-single-device", buffer, 25)) {
+	} else if (!memcmp("scsi remove-single-device", buffer, 25)) {
 		p = buffer + 26;
 
 		host = simple_strtoul(p, &p, 0);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 087821f..51e739a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1505,7 +1505,7 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 	struct device *parent = &shost->shost_gendev;
 	struct scsi_target *starget;
 
-	if (strncmp(scsi_scan_type, "none", 4) == 0)
+	if (memcmp(scsi_scan_type, "none", 4) == 0)
 		return ERR_PTR(-ENODEV);
 
 	starget = scsi_alloc_target(parent, channel, id);
@@ -1630,7 +1630,7 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 
-	if (strncmp(scsi_scan_type, "none", 4) == 0)
+	if (memcmp(scsi_scan_type, "none", 4) == 0)
 		return;
 
 	mutex_lock(&shost->scan_mutex);
@@ -1732,7 +1732,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 	struct async_scan_data *data;
 	unsigned long flags;
 
-	if (strncmp(scsi_scan_type, "sync", 4) == 0)
+	if (memcmp(scsi_scan_type, "sync", 4) == 0)
 		return NULL;
 
 	if (shost->async_scan) {
@@ -1855,7 +1855,7 @@ void scsi_scan_host(struct Scsi_Host *shost)
 	struct task_struct *p;
 	struct async_scan_data *data;
 
-	if (strncmp(scsi_scan_type, "none", 4) == 0)
+	if (memcmp(scsi_scan_type, "none", 4) == 0)
 		return;
 	if (scsi_autopm_get_host(shost) < 0)
 		return;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 76ee2e7..3bda14a 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -83,7 +83,7 @@ static int check_set(unsigned int *val, char *src)
 {
 	char *last;
 
-	if (strncmp(src, "-", 20) == 0) {
+	if (memcmp(src, "-", 20) == 0) {
 		*val = SCAN_WILD_CARD;
 	} else {
 		/*
@@ -170,7 +170,7 @@ store_shost_state(struct device *dev, struct device_attribute *attr,
 
 	for (i = 0; i < ARRAY_SIZE(shost_states); i++) {
 		const int len = strlen(shost_states[i].name);
-		if (strncmp(shost_states[i].name, buf, len) == 0 &&
+		if (memcmp(shost_states[i].name, buf, len) == 0 &&
 		   buf[len] == '\n') {
 			state = shost_states[i].value;
 			break;
@@ -568,7 +568,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 
 	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
 		const int len = strlen(sdev_states[i].name);
-		if (strncmp(sdev_states[i].name, buf, len) == 0 &&
+		if (memcmp(sdev_states[i].name, buf, len) == 0 &&
 		   buf[len] == '\n') {
 			state = sdev_states[i].value;
 			break;
@@ -783,11 +783,11 @@ sdev_store_queue_type_rw(struct device *dev, struct device_attribute *attr,
 	if (!sdev->tagged_supported || !sht->change_queue_type)
 		return -EINVAL;
 
-	if (strncmp(buf, "ordered", 7) == 0)
+	if (memcmp(buf, "ordered", 7) == 0)
 		tag_type = MSG_ORDERED_TAG;
-	else if (strncmp(buf, "simple", 6) == 0)
+	else if (memcmp(buf, "simple", 6) == 0)
 		tag_type = MSG_SIMPLE_TAG;
-	else if (strncmp(buf, "none", 4) != 0)
+	else if (memcmp(buf, "none", 4) != 0)
 		return -EINVAL;
 
 	if (tag_type == prev_tag_type)
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 998c01b..e1b7385 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -101,7 +101,7 @@ static int get_fc_##title##_match(const char *table_key,		\
 	int i;								\
 									\
 	for (i = 0; i < ARRAY_SIZE(table); i++) {			\
-		if (strncmp(table_key, table[i].name,			\
+		if (memcmp(table_key, table[i].name,			\
 				table[i].matchlen) == 0) {		\
 			*value = table[i].value;			\
 			return 0; /* success */				\
@@ -966,7 +966,7 @@ store_fc_rport_fast_io_fail_tmo(struct device *dev,
 	    (rport->port_state == FC_PORTSTATE_DELETED) ||
 	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))
 		return -EBUSY;
-	if (strncmp(buf, "off", 3) == 0)
+	if (memcmp(buf, "off", 3) == 0)
 		rport->fast_io_fail_tmo = -1;
 	else {
 		val = simple_strtoul(buf, &cp, 0);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 332387a..460be1c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1833,7 +1833,7 @@ store_priv_session_##field(struct device *dev,				\
 	if ((session->state == ISCSI_SESSION_FREE) ||			\
 	    (session->state == ISCSI_SESSION_FAILED))			\
 		return -EBUSY;						\
-	if (strncmp(buf, "off", 3) == 0)				\
+	if (memcmp(buf, "off", 3) == 0)				\
 		session->field = -1;					\
 	else {								\
 		val = simple_strtoul(buf, &cp, 0);			\
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 927e99c..a543995 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -90,7 +90,7 @@ set_sas_##title##_names(u32 *table_key, const char *buf)	\
 								\
 	for (i = 0; i < ARRAY_SIZE(table); i++) {		\
 		len = strlen(table[i].name);			\
-		if (strncmp(buf, table[i].name, len) == 0 &&	\
+		if (memcmp(buf, table[i].name, len) == 0 &&	\
 		    (buf[len] == '\n' || buf[len] == '\0')) {	\
 			*table_key = table[i].value;		\
 			return 0;				\
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 8a172d4..1a3cc45 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -171,7 +171,7 @@ static inline enum spi_signal_type spi_signal_to_value(const char *name)
 
 	for (i = 0; i < ARRAY_SIZE(signal_types); i++) {
 		len =  strlen(signal_types[i].name);
-		if (strncmp(name, signal_types[i].name, len) == 0 &&
+		if (memcmp(name, signal_types[i].name, len) == 0 &&
 		    (name[len] == '\n' || name[len] == '\0'))
 			return signal_types[i].value;
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9564961..7ec77b4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -147,7 +147,7 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 
 	for (i = 0; i < ARRAY_SIZE(sd_cache_types); i++) {
 		len = strlen(sd_cache_types[i]);
-		if (strncmp(sd_cache_types[i], buf, len) == 0 &&
+		if (memcmp(sd_cache_types[i], buf, len) == 0 &&
 		    buf[len] == '\n') {
 			ct = i;
 			break;
diff --git a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
index 8ac6ce7..23093bf 100644
--- a/drivers/scsi/sim710.c
+++ b/drivers/scsi/sim710.c
@@ -70,9 +70,9 @@ param_setup(char *str)
 	while(pos != NULL && (next = strchr(pos, ':')) != NULL) {
 		int val = (int)simple_strtoul(++next, NULL, 0);
 
-		if(!strncmp(pos, "slot:", 5))
+		if(!memcmp(pos, "slot:", 5))
 			slot = val;
-		else if(!strncmp(pos, "id:", 3)) {
+		else if(!memcmp(pos, "id:", 3)) {
 			if(slot == -1) {
 				printk(KERN_WARNING "sim710: Must specify slot for id parameter\n");
 			} else if(slot >= MAX_SLOTS) {
diff --git a/drivers/scsi/sr_vendor.c b/drivers/scsi/sr_vendor.c
index 92cc2ef..5be35c5 100644
--- a/drivers/scsi/sr_vendor.c
+++ b/drivers/scsi/sr_vendor.c
@@ -80,22 +80,22 @@ void sr_vendor_init(Scsi_CD *cd)
 	if (cd->device->type == TYPE_WORM) {
 		cd->vendor = VENDOR_WRITER;
 
-	} else if (!strncmp(vendor, "NEC", 3)) {
+	} else if (!memcmp(vendor, "NEC", 3)) {
 		cd->vendor = VENDOR_NEC;
-		if (!strncmp(model, "CD-ROM DRIVE:25", 15) ||
-		    !strncmp(model, "CD-ROM DRIVE:36", 15) ||
-		    !strncmp(model, "CD-ROM DRIVE:83", 15) ||
-		    !strncmp(model, "CD-ROM DRIVE:84 ", 16)
+		if (!memcmp(model, "CD-ROM DRIVE:25", 15) ||
+		    !memcmp(model, "CD-ROM DRIVE:36", 15) ||
+		    !memcmp(model, "CD-ROM DRIVE:83", 15) ||
+		    !memcmp(model, "CD-ROM DRIVE:84 ", 16)
 #if 0
 		/* my NEC 3x returns the read-raw data if a read-raw
 		   is followed by a read for the same sector - aeb */
-		    || !strncmp(model, "CD-ROM DRIVE:500", 16)
+		    || !memcmp(model, "CD-ROM DRIVE:500", 16)
 #endif
 		    )
 			/* these can't handle multisession, may hang */
 			cd->cdi.mask |= CDC_MULTI_SESSION;
 
-	} else if (!strncmp(vendor, "TOSHIBA", 7)) {
+	} else if (!memcmp(vendor, "TOSHIBA", 7)) {
 		cd->vendor = VENDOR_TOSHIBA;
 
 	}
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 5b7388f..b71c464 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -293,9 +293,9 @@ static char * st_incompatible(struct scsi_device* SDp)
 	struct st_reject_data *rp;
 
 	for (rp=&(reject_list[0]); rp->vendor != NULL; rp++)
-		if (!strncmp(rp->vendor, SDp->vendor, strlen(rp->vendor)) &&
-		    !strncmp(rp->model, SDp->model, strlen(rp->model)) &&
-		    !strncmp(rp->rev, SDp->rev, strlen(rp->rev))) {
+		if (!memcmp(rp->vendor, SDp->vendor, strlen(rp->vendor)) &&
+		    !memcmp(rp->model, SDp->model, strlen(rp->model)) &&
+		    !memcmp(rp->rev, SDp->rev, strlen(rp->rev))) {
 			if (rp->driver_hint)
 				return rp->driver_hint;
 			else
@@ -3924,7 +3924,7 @@ static int __init st_setup(char *str)
 		while (stp != NULL) {
 			for (i = 0; i < ARRAY_SIZE(parms); i++) {
 				len = strlen(parms[i].name);
-				if (!strncmp(stp, parms[i].name, len) &&
+				if (!memcmp(stp, parms[i].name, len) &&
 				    (*(stp + len) == ':' || *(stp + len) == '=')) {
 					if (parms[i].val)
 						*parms[i].val =
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index edfc5da..6310a05 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1052,13 +1052,13 @@ static void internal_setup(char *str, int *ints) {
       else if (c == 'y' || c == 'Y') val = TRUE;
       else val = (int) simple_strtoul(pc, NULL, 0);
 
-      if (!strncmp(cur, "lc:", 3)) linked_comm = val;
-      else if (!strncmp(cur, "of:", 3)) have_old_firmware = val;
-      else if (!strncmp(cur, "tm:", 3)) tag_mode = val;
-      else if (!strncmp(cur, "tc:", 3)) tag_mode = val;
-      else if (!strncmp(cur, "mq:", 3))  max_queue_depth = val;
-      else if (!strncmp(cur, "ls:", 3))  link_statistics = val;
-      else if (!strncmp(cur, "et:", 3))  ext_tran = val;
+      if (!memcmp(cur, "lc:", 3)) linked_comm = val;
+      else if (!memcmp(cur, "of:", 3)) have_old_firmware = val;
+      else if (!memcmp(cur, "tm:", 3)) tag_mode = val;
+      else if (!memcmp(cur, "tc:", 3)) tag_mode = val;
+      else if (!memcmp(cur, "mq:", 3))  max_queue_depth = val;
+      else if (!memcmp(cur, "ls:", 3))  link_statistics = val;
+      else if (!memcmp(cur, "et:", 3))  ext_tran = val;
 
       if ((cur = strchr(cur, ','))) ++cur;
       }
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index 5f697e0..99dcb0b 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -1818,9 +1818,9 @@ check_setup_args(char *key, int *flags, int *val, char *buf)
 	for (x = 0; x < MAX_SETUP_ARGS; x++) {
 		if (setup_used[x])
 			continue;
-		if (!strncmp(setup_args[x], key, strlen(key)))
+		if (!memcmp(setup_args[x], key, strlen(key)))
 			break;
-		if (!strncmp(setup_args[x], "next", strlen("next")))
+		if (!memcmp(setup_args[x], "next", strlen("next")))
 			return 0;
 	}
 	if (x == MAX_SETUP_ARGS)
@@ -2090,35 +2090,35 @@ wd33c93_proc_info(struct Scsi_Host *instance, char *buf, char **start, off_t off
 		for (bp = buf; *bp; ) {
 			while (',' == *bp || ' ' == *bp)
 				++bp;
-		if (!strncmp(bp, "debug:", 6)) {
+		if (!memcmp(bp, "debug:", 6)) {
 				hd->args = simple_strtoul(bp+6, &bp, 0) & DB_MASK;
-		} else if (!strncmp(bp, "disconnect:", 11)) {
+		} else if (!memcmp(bp, "disconnect:", 11)) {
 				x = simple_strtoul(bp+11, &bp, 0);
 			if (x < DIS_NEVER || x > DIS_ALWAYS)
 				x = DIS_ADAPTIVE;
 			hd->disconnect = x;
-		} else if (!strncmp(bp, "period:", 7)) {
+		} else if (!memcmp(bp, "period:", 7)) {
 			x = simple_strtoul(bp+7, &bp, 0);
 			hd->default_sx_per =
 				hd->sx_table[round_period((unsigned int) x,
 							  hd->sx_table)].period_ns;
-		} else if (!strncmp(bp, "resync:", 7)) {
+		} else if (!memcmp(bp, "resync:", 7)) {
 				set_resync(hd, (int)simple_strtoul(bp+7, &bp, 0));
-		} else if (!strncmp(bp, "proc:", 5)) {
+		} else if (!memcmp(bp, "proc:", 5)) {
 				hd->proc = simple_strtoul(bp+5, &bp, 0);
-		} else if (!strncmp(bp, "nodma:", 6)) {
+		} else if (!memcmp(bp, "nodma:", 6)) {
 				hd->no_dma = simple_strtoul(bp+6, &bp, 0);
-		} else if (!strncmp(bp, "level2:", 7)) {
+		} else if (!memcmp(bp, "level2:", 7)) {
 				hd->level2 = simple_strtoul(bp+7, &bp, 0);
-			} else if (!strncmp(bp, "burst:", 6)) {
+			} else if (!memcmp(bp, "burst:", 6)) {
 				hd->dma_mode =
 					simple_strtol(bp+6, &bp, 0) ? CTRL_BURST:CTRL_DMA;
-			} else if (!strncmp(bp, "fast:", 5)) {
+			} else if (!memcmp(bp, "fast:", 5)) {
 				x = !!simple_strtol(bp+5, &bp, 0);
 				if (x != hd->fast)
 					set_resync(hd, 0xff);
 				hd->fast = x;
-			} else if (!strncmp(bp, "nosync:", 7)) {
+			} else if (!memcmp(bp, "nosync:", 7)) {
 				x = simple_strtoul(bp+7, &bp, 0);
 				set_resync(hd, x ^ hd->no_sync);
 				hd->no_sync = x;
diff --git a/drivers/serial/8250_early.c b/drivers/serial/8250_early.c
index eaafb98..9e29915 100644
--- a/drivers/serial/8250_early.c
+++ b/drivers/serial/8250_early.c
@@ -159,8 +159,8 @@ static int __init parse_options(struct early_serial8250_device *device,
 
 	port->uartclk = BASE_BAUD * 16;
 
-	mmio = !strncmp(options, "mmio,", 5);
-	mmio32 = !strncmp(options, "mmio32,", 7);
+	mmio = !memcmp(options, "mmio,", 5);
+	mmio32 = !memcmp(options, "mmio32,", 7);
 	if (mmio || mmio32) {
 		port->iotype = (mmio ? UPIO_MEM : UPIO_MEM32);
 		port->mapbase = simple_strtoul(options + (mmio ? 5 : 7),
@@ -182,7 +182,7 @@ static int __init parse_options(struct early_serial8250_device *device,
 			return -ENOMEM;
 		}
 #endif
-	} else if (!strncmp(options, "io,", 3)) {
+	} else if (!memcmp(options, "io,", 3)) {
 		port->iotype = UPIO_PORT;
 		port->iobase = simple_strtoul(options + 3, &options, 0);
 		mmio = 0;
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index 3374618..71184ec 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -95,7 +95,7 @@ static void kgdboc_restore_input(void)
 
 static int kgdboc_register_kbd(char **cptr)
 {
-	if (strncmp(*cptr, "kbd", 3) == 0) {
+	if (memcmp(*cptr, "kbd", 3) == 0) {
 		if (kdb_poll_idx < KDB_POLL_FUNC_MAX) {
 			kdb_poll_funcs[kdb_poll_idx] = kdb_get_kbd_char;
 			kdb_poll_idx++;
@@ -165,7 +165,7 @@ static int configure_kgdboc(void)
 	kgdb_tty_driver = NULL;
 
 	kgdboc_use_kms = 0;
-	if (strncmp(cptr, "kms,", 4) == 0) {
+	if (memcmp(cptr, "kms,", 4) == 0) {
 		cptr += 4;
 		kgdboc_use_kms = 1;
 	}
diff --git a/drivers/serial/pmac_zilog.c b/drivers/serial/pmac_zilog.c
index 5b9cde7..dbb623c 100644
--- a/drivers/serial/pmac_zilog.c
+++ b/drivers/serial/pmac_zilog.c
@@ -1802,9 +1802,9 @@ static int __init pmz_probe(void)
 		 */
 		node_a = node_b = NULL;
 		for (np = NULL; (np = of_get_next_child(node_p, np)) != NULL;) {
-			if (strncmp(np->name, "ch-a", 4) == 0)
+			if (memcmp(np->name, "ch-a", 4) == 0)
 				node_a = of_node_get(np);
-			else if (strncmp(np->name, "ch-b", 4) == 0)
+			else if (memcmp(np->name, "ch-b", 4) == 0)
 				node_b = of_node_get(np);
 		}
 		if (!node_a && !node_b) {
diff --git a/drivers/sfi/sfi_core.c b/drivers/sfi/sfi_core.c
index ceba593..1379a25 100644
--- a/drivers/sfi/sfi_core.c
+++ b/drivers/sfi/sfi_core.c
@@ -200,10 +200,10 @@ static int sfi_table_check_key(struct sfi_table_header *th,
 				struct sfi_table_key *key)
 {
 
-	if (strncmp(th->sig, key->sig, SFI_SIGNATURE_SIZE)
-		|| (key->oem_id && strncmp(th->oem_id,
+	if (memcmp(th->sig, key->sig, SFI_SIGNATURE_SIZE)
+		|| (key->oem_id && memcmp(th->oem_id,
 				key->oem_id, SFI_OEM_ID_SIZE))
-		|| (key->oem_table_id && strncmp(th->oem_table_id,
+		|| (key->oem_table_id && memcmp(th->oem_table_id,
 				key->oem_table_id, SFI_OEM_TABLE_ID_SIZE)))
 		return -1;
 
@@ -351,7 +351,7 @@ static __init int sfi_find_syst(void)
 		struct sfi_table_header *syst_hdr;
 
 		syst_hdr = start + offset;
-		if (strncmp(syst_hdr->sig, SFI_SIG_SYST,
+		if (memcmp(syst_hdr->sig, SFI_SIG_SYST,
 				SFI_SIGNATURE_SIZE))
 			continue;
 
@@ -400,7 +400,7 @@ static ssize_t sfi_table_show(struct file *filp, struct kobject *kobj,
 	key.oem_id = NULL;
 	key.oem_table_id = NULL;
 
-	if (strncmp(SFI_SIG_SYST, tbl_attr->name, SFI_SIGNATURE_SIZE)) {
+	if (memcmp(SFI_SIG_SYST, tbl_attr->name, SFI_SIGNATURE_SIZE)) {
 		th = sfi_get_table(&key);
 		if (!th)
 			return 0;
diff --git a/drivers/sn/ioc3.c b/drivers/sn/ioc3.c
index b3b33fa..3239074 100644
--- a/drivers/sn/ioc3.c
+++ b/drivers/sn/ioc3.c
@@ -295,9 +295,9 @@ static void read_nic(struct ioc3_driver_data *idd, unsigned long addr)
 			part[j++] = data[i+32];
 	part[j] = 0;
 	/* skip Octane power supplies */
-	if(!strncmp(part, "060-0035-", 9))
+	if(!memcmp(part, "060-0035-", 9))
 		return;
-	if(!strncmp(part, "060-0038-", 9))
+	if(!memcmp(part, "060-0038-", 9))
 		return;
 	strcpy(idd->nic_part, part);
 	/* assemble the serial # */
@@ -583,13 +583,13 @@ static int __devinit ioc3_class(struct ioc3_driver_data *idd)
 {
 	int res = IOC3_CLASS_NONE;
 	/* NIC-based logic */
-	if(!strncmp(idd->nic_part, "030-0891-", 9))
+	if(!memcmp(idd->nic_part, "030-0891-", 9))
 		res = IOC3_CLASS_BASE_IP30;
-	if(!strncmp(idd->nic_part, "030-1155-", 9))
+	if(!memcmp(idd->nic_part, "030-1155-", 9))
 		res = IOC3_CLASS_CADDUO;
-	if(!strncmp(idd->nic_part, "030-1657-", 9))
+	if(!memcmp(idd->nic_part, "030-1657-", 9))
 		res = IOC3_CLASS_SERIAL;
-	if(!strncmp(idd->nic_part, "030-1664-", 9))
+	if(!memcmp(idd->nic_part, "030-1664-", 9))
 		res = IOC3_CLASS_SERIAL;
 	/* total random heuristics */
 #ifdef CONFIG_SGI_IP27
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
index 8dce054..671635f 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
@@ -376,13 +376,13 @@ A_STATUS AthParseFilesUnified(A_UCHAR *srcbuffer,A_UINT32 srclen, int FileFormat
             pCharLine+=2;
             SKIP_BLANKS(pCharLine);
 
-            if(!strncmp(pCharLine,"PA",2)||!strncmp(pCharLine,"Pa",2)||!strncmp(pCharLine,"pa",2))
+            if(!memcmp(pCharLine,"PA",2)||!strncmp(pCharLine,"Pa",2)||!strncmp(pCharLine,"pa",2))
                 ParseSection=RAM_PATCH_SECTION;
 
-            if(!strncmp(pCharLine,"DY",2)||!strncmp(pCharLine,"Dy",2)||!strncmp(pCharLine,"dy",2))
+            if(!memcmp(pCharLine,"DY",2)||!strncmp(pCharLine,"Dy",2)||!strncmp(pCharLine,"dy",2))
                 ParseSection=RAM_DYN_MEM_SECTION;
 
-            if(!strncmp(pCharLine,"PS",2)||!strncmp(pCharLine,"Ps",2)||!strncmp(pCharLine,"ps",2))
+            if(!memcmp(pCharLine,"PS",2)||!strncmp(pCharLine,"Ps",2)||!strncmp(pCharLine,"ps",2))
                 ParseSection=RAM_PS_SECTION;
 
             LineRead = 0;
diff --git a/drivers/staging/batman-adv/bat_sysfs.c b/drivers/staging/batman-adv/bat_sysfs.c
index bc17fb8..a760d2f 100644
--- a/drivers/staging/batman-adv/bat_sysfs.c
+++ b/drivers/staging/batman-adv/bat_sysfs.c
@@ -56,11 +56,11 @@ static ssize_t store_aggr_ogms(struct kobject *kobj, struct attribute *attr,
 	int aggr_tmp = -1;
 
 	if (((count == 2) && (buff[0] == '1')) ||
-	    (strncmp(buff, "enable", 6) == 0))
+	    (memcmp(buff, "enable", 6) == 0))
 		aggr_tmp = 1;
 
 	if (((count == 2) && (buff[0] == '0')) ||
-	    (strncmp(buff, "disable", 7) == 0))
+	    (memcmp(buff, "disable", 7) == 0))
 		aggr_tmp = 0;
 
 	if (aggr_tmp < 0) {
@@ -105,11 +105,11 @@ static ssize_t store_bond(struct kobject *kobj, struct attribute *attr,
 	int bonding_enabled_tmp = -1;
 
 	if (((count == 2) && (buff[0] == '1')) ||
-	    (strncmp(buff, "enable", 6) == 0))
+	    (memcmp(buff, "enable", 6) == 0))
 		bonding_enabled_tmp = 1;
 
 	if (((count == 2) && (buff[0] == '0')) ||
-	    (strncmp(buff, "disable", 7) == 0))
+	    (memcmp(buff, "disable", 7) == 0))
 		bonding_enabled_tmp = 0;
 
 	if (bonding_enabled_tmp < 0) {
@@ -154,11 +154,11 @@ static ssize_t store_frag(struct kobject *kobj, struct attribute *attr,
 	int frag_enabled_tmp = -1;
 
 	if (((count == 2) && (buff[0] == '1')) ||
-	    (strncmp(buff, "enable", 6) == 0))
+	    (memcmp(buff, "enable", 6) == 0))
 		frag_enabled_tmp = 1;
 
 	if (((count == 2) && (buff[0] == '0')) ||
-	    (strncmp(buff, "disable", 7) == 0))
+	    (memcmp(buff, "disable", 7) == 0))
 		frag_enabled_tmp = 0;
 
 	if (frag_enabled_tmp < 0) {
@@ -208,12 +208,12 @@ static ssize_t store_vis_mode(struct kobject *kobj, struct attribute *attr,
 	ret = strict_strtoul(buff, 10, &val);
 
 	if (((count == 2) && (!ret) && (val == VIS_TYPE_CLIENT_UPDATE)) ||
-	    (strncmp(buff, "client", 6) == 0) ||
-	    (strncmp(buff, "off", 3) == 0))
+	    (memcmp(buff, "client", 6) == 0) ||
+	    (memcmp(buff, "off", 3) == 0))
 		vis_mode_tmp = VIS_TYPE_CLIENT_UPDATE;
 
 	if (((count == 2) && (!ret) && (val == VIS_TYPE_SERVER_SYNC)) ||
-	    (strncmp(buff, "server", 6) == 0))
+	    (memcmp(buff, "server", 6) == 0))
 		vis_mode_tmp = VIS_TYPE_SERVER_SYNC;
 
 	if (vis_mode_tmp < 0) {
@@ -440,13 +440,13 @@ static ssize_t store_mesh_iface(struct kobject *kobj, struct attribute *attr,
 		return -EINVAL;
 	}
 
-	if (strncmp(buff, "none", 4) == 0)
+	if (memcmp(buff, "none", 4) == 0)
 		status_tmp = IF_NOT_IN_USE;
 	else
 		status_tmp = IF_I_WANT_YOU;
 
 	if ((batman_if->if_status == status_tmp) || ((batman_if->soft_iface) &&
-	    (strncmp(batman_if->soft_iface->name, buff, IFNAMSIZ) == 0))) {
+	    (memcmp(batman_if->soft_iface->name, buff, IFNAMSIZ) == 0))) {
 		hardif_put(batman_if);
 		return count;
 	}
diff --git a/drivers/staging/bcm/Bcmnet.c b/drivers/staging/bcm/Bcmnet.c
index bc29698..3466265 100644
--- a/drivers/staging/bcm/Bcmnet.c
+++ b/drivers/staging/bcm/Bcmnet.c
@@ -5,7 +5,7 @@ static INT bcm_notify_event(struct notifier_block *nb, ULONG event, PVOID dev)
 	struct net_device *ndev = (struct net_device*)dev;
     PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 	//PMINI_ADAPTER 	Adapter = (PMINI_ADAPTER)ndev->priv;
-	if(strncmp(ndev->name,gblpnetdev->name,5)==0)
+	if(memcmp(ndev->name,gblpnetdev->name,5)==0)
 	{
 		switch(event)
 		{
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 703188f..270fb90 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -964,7 +964,7 @@ void print_buf(void *pbuf, int len, int bytes_per_line)
 static int wl_pattern_atoh(char *src, char *dst)
 {
 	int i;
-	if (strncmp(src, "0x", 2) != 0 && strncmp(src, "0X", 2) != 0) {
+	if (memcmp(src, "0x", 2) != 0 && strncmp(src, "0X", 2) != 0) {
 		DHD_ERROR(("Mask invalid format. Needs to start with 0x\n"));
 		return -1;
 	}
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 9335f02..40082c8 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -659,7 +659,7 @@ int dhd_ifname2idx(dhd_info_t *dhd, char *name)
 
 	while (--i > 0)
 		if (dhd->iflist[i]
-		    && !strncmp(dhd->iflist[i]->name, name, IFNAMSIZ))
+		    && !memcmp(dhd->iflist[i]->name, name, IFNAMSIZ))
 			break;
 
 	DHD_TRACE(("%s: return idx %d for \"%s\"\n", __func__, i, name));
@@ -1719,9 +1719,9 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 	 */
 	is_set_key_cmd = ((ioc.cmd == WLC_SET_KEY) ||
 			  ((ioc.cmd == WLC_SET_VAR) &&
-			   !(strncmp("wsec_key", ioc.buf, 9))) ||
+			   !(memcmp("wsec_key", ioc.buf, 9))) ||
 			  ((ioc.cmd == WLC_SET_VAR) &&
-			   !(strncmp("bsscfg:wsec_key", ioc.buf, 15))));
+			   !(memcmp("bsscfg:wsec_key", ioc.buf, 15))));
 	if (is_set_key_cmd)
 		dhd_wait_pend8021x(net);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index ea08252..bea099a 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3619,7 +3619,7 @@ dongle_offload_out:
 static s32 wl_pattern_atoh(s8 *src, s8 *dst)
 {
 	int i;
-	if (strncmp(src, "0x", 2) != 0 && strncmp(src, "0X", 2) != 0) {
+	if (memcmp(src, "0x", 2) != 0 && strncmp(src, "0X", 2) != 0) {
 		WL_ERR(("Mask invalid format. Needs to start with 0x\n"));
 		return -1;
 	}
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/util/bcmsrom.c
index 1282ef7..08332ce 100644
--- a/drivers/staging/brcm80211/util/bcmsrom.c
+++ b/drivers/staging/brcm80211/util/bcmsrom.c
@@ -1599,7 +1599,7 @@ static int initvars_flash(si_t *sih, osl_t *osh, char **base, uint len)
 		l = strlen(s);
 
 		/* skip non-matching variable */
-		if (strncmp(s, devpath, dl))
+		if (memcmp(s, devpath, dl))
 			continue;
 
 		/* is there enough room to copy? */
diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index ebba9bb..c37944f 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -863,7 +863,7 @@ static int daqp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	strcpy(local->board_name, "DAQP");
 	dev->board_name = local->board_name;
 	if (local->link->prod_id[2]) {
-		if (strncmp(local->link->prod_id[2], "DAQP", 4) == 0) {
+		if (memcmp(local->link->prod_id[2], "DAQP", 4) == 0) {
 			strncpy(local->board_name, local->link->prod_id[2],
 				sizeof(local->board_name));
 		}
diff --git a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
index 0252b44..664667b 100644
--- a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
+++ b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
@@ -47,7 +47,7 @@ struct comedi_device *comedi_open(const char *filename)
 	struct comedi_device *dev;
 	unsigned int minor;
 
-	if (strncmp(filename, "/dev/comedi", 11) != 0)
+	if (memcmp(filename, "/dev/comedi", 11) != 0)
 		return NULL;
 
 	minor = simple_strtoul(filename + 11, NULL, 0);
diff --git a/drivers/staging/cpia/cpia.c b/drivers/staging/cpia/cpia.c
index 0e740b8..e555faa 100644
--- a/drivers/staging/cpia/cpia.c
+++ b/drivers/staging/cpia/cpia.c
@@ -521,7 +521,7 @@ static int match(char *checkstr, char **buffer, size_t *count,
 {
 	int ret, colon_found = 1;
 	int len = strlen(checkstr);
-	ret = (len <= *count && strncmp(*buffer, checkstr, len) == 0);
+	ret = (len <= *count && memcmp(*buffer, checkstr, len) == 0);
 	if (ret) {
 		*buffer += len;
 		*count -= len;
diff --git a/drivers/staging/cpia/cpia_pp.c b/drivers/staging/cpia/cpia_pp.c
index f5604c1..18f54f7 100644
--- a/drivers/staging/cpia/cpia_pp.c
+++ b/drivers/staging/cpia/cpia_pp.c
@@ -789,7 +789,7 @@ static void cpia_pp_attach (struct parport *port)
 	case PPCPIA_PARPORT_AUTO:
 		if (port->probe_info[0].class != PARPORT_CLASS_MEDIA ||
 		    port->probe_info[0].cmdset == NULL ||
-		    strncmp(port->probe_info[0].cmdset, "CPIA_1", 6) != 0)
+		    memcmp(port->probe_info[0].cmdset, "CPIA_1", 6) != 0)
 			return;
 
 		cpia_pp_register(port);
@@ -836,12 +836,12 @@ static int __init cpia_init(void)
 {
 	if (parport[0]) {
 		/* The user gave some parameters.  Let's see what they were. */
-		if (!strncmp(parport[0], "auto", 4)) {
+		if (!memcmp(parport[0], "auto", 4)) {
 			parport_nr[0] = PPCPIA_PARPORT_AUTO;
 		} else {
 			int n;
 			for (n = 0; n < PARPORT_MAX && parport[n]; n++) {
-				if (!strncmp(parport[n], "none", 4)) {
+				if (!memcmp(parport[n], "none", 4)) {
 					parport_nr[n] = PPCPIA_PARPORT_NONE;
 				} else {
 					char *ep;
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 28c6b8c..113938c 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -716,17 +716,17 @@ void chd_set_log_level(struct crystalhd_adp *adp, char *arg)
 {
 	if ((!arg) || (strlen(arg) < 3))
 		g_linklog_level = BCMLOG_ERROR | BCMLOG_DATA;
-	else if (!strncmp(arg, "sstep", 5))
+	else if (!memcmp(arg, "sstep", 5))
 		g_linklog_level = BCMLOG_INFO | BCMLOG_DATA | BCMLOG_DBG |
 				  BCMLOG_SSTEP | BCMLOG_ERROR;
-	else if (!strncmp(arg, "info", 4))
+	else if (!memcmp(arg, "info", 4))
 		g_linklog_level = BCMLOG_ERROR | BCMLOG_DATA | BCMLOG_INFO;
-	else if (!strncmp(arg, "debug", 5))
+	else if (!memcmp(arg, "debug", 5))
 		g_linklog_level = BCMLOG_ERROR | BCMLOG_DATA | BCMLOG_INFO |
 				  BCMLOG_DBG;
-	else if (!strncmp(arg, "pball", 5))
+	else if (!memcmp(arg, "pball", 5))
 		g_linklog_level = 0xFFFFFFFF & ~(BCMLOG_SPINLOCK);
-	else if (!strncmp(arg, "silent", 6))
+	else if (!memcmp(arg, "silent", 6))
 		g_linklog_level = 0;
 	else
 		g_linklog_level = 0;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 5b89ee2..136fed1 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -826,7 +826,7 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
     {
         DEBUG("init_ft1000_netdev: network device name is %s\n", netdev->name);
 
-	if ( strncmp(netdev->name,"eth", 3) == 0) {
+	if ( memcmp(netdev->name,"eth", 3) == 0) {
 		card_nr[0] = netdev->name[3];
 		card_nr[1] = '\0';
 		ret_val = strict_strtoul(card_nr, 10, &gCardIndex);
diff --git a/drivers/staging/iio/Documentation/iio_utils.h b/drivers/staging/iio/Documentation/iio_utils.h
index 0372424..6155b39 100644
--- a/drivers/staging/iio/Documentation/iio_utils.h
+++ b/drivers/staging/iio/Documentation/iio_utils.h
@@ -436,12 +436,12 @@ inline int find_type_by_name(const char *name, const char *type)
 		if (strcmp(ent->d_name, ".") != 0 &&
 			strcmp(ent->d_name, "..") != 0 &&
 			strlen(ent->d_name) > strlen(type) &&
-			strncmp(ent->d_name, type, strlen(type)) == 0) {
+			memcmp(ent->d_name, type, strlen(type)) == 0) {
 			numstrlen = sscanf(ent->d_name + strlen(type),
 					   "%d",
 					   &number);
 			/* verify the next character is not a colon */
-			if (strncmp(ent->d_name + strlen(type) + numstrlen,
+			if (memcmp(ent->d_name + strlen(type) + numstrlen,
 					":",
 					1) != 0) {
 				filename = malloc(strlen(iio_dir)
diff --git a/drivers/staging/iio/accel/kxsd9.c b/drivers/staging/iio/accel/kxsd9.c
index 79f5795..7781814 100644
--- a/drivers/staging/iio/accel/kxsd9.c
+++ b/drivers/staging/iio/accel/kxsd9.c
@@ -142,19 +142,19 @@ static ssize_t kxsd9_write_scale(struct device *dev,
 		},
 	};
 
-	if (!strncmp(buf, KXSD9_SCALE_8G,
+	if (!memcmp(buf, KXSD9_SCALE_8G,
 		     strlen(buf) < strlen(KXSD9_SCALE_8G)
 		     ? strlen(buf) : strlen(KXSD9_SCALE_8G)))
 		val = KXSD9_FS_8;
-	else if (!strncmp(buf, KXSD9_SCALE_6G,
+	else if (!memcmp(buf, KXSD9_SCALE_6G,
 			  strlen(buf) < strlen(KXSD9_SCALE_6G)
 			  ? strlen(buf) : strlen(KXSD9_SCALE_6G)))
 		val = KXSD9_FS_6;
-	else if (!strncmp(buf, KXSD9_SCALE_4G,
+	else if (!memcmp(buf, KXSD9_SCALE_4G,
 			  strlen(buf) < strlen(KXSD9_SCALE_4G)
 			  ? strlen(buf) : strlen(KXSD9_SCALE_4G)))
 		val = KXSD9_FS_4;
-	else if (!strncmp(buf, KXSD9_SCALE_2G,
+	else if (!memcmp(buf, KXSD9_SCALE_2G,
 			  strlen(buf) < strlen(KXSD9_SCALE_2G)
 			  ? strlen(buf) : strlen(KXSD9_SCALE_2G)))
 		val = KXSD9_FS_2;
diff --git a/drivers/staging/iio/accel/sca3000_ring.c b/drivers/staging/iio/accel/sca3000_ring.c
index c872fdd..bc4d4c1 100644
--- a/drivers/staging/iio/accel/sca3000_ring.c
+++ b/drivers/staging/iio/accel/sca3000_ring.c
@@ -180,11 +180,11 @@ static ssize_t sca3000_store_ring_bpse(struct device *dev,
 	ret = sca3000_read_data(st, SCA3000_REG_ADDR_MODE, &rx, 1);
 	if (ret)
 		goto error_ret;
-	if (strncmp(buf, "s8/8", 4) == 0) {
+	if (memcmp(buf, "s8/8", 4) == 0) {
 		ret = sca3000_write_reg(st, SCA3000_REG_ADDR_MODE,
 					rx[1] | SCA3000_RING_BUF_8BIT);
 		st->bpse = 8;
-	} else if (strncmp(buf, "s11/16", 5) == 0) {
+	} else if (memcmp(buf, "s11/16", 5) == 0) {
 		ret = sca3000_write_reg(st, SCA3000_REG_ADDR_MODE,
 					rx[1] & ~SCA3000_RING_BUF_8BIT);
 		st->bpse = 11;
diff --git a/drivers/staging/iio/industrialio-trigger.c b/drivers/staging/iio/industrialio-trigger.c
index 57dd923..6ba6a19 100644
--- a/drivers/staging/iio/industrialio-trigger.c
+++ b/drivers/staging/iio/industrialio-trigger.c
@@ -161,7 +161,7 @@ struct iio_trigger *iio_trigger_find_by_name(const char *name, size_t len)
 
 	mutex_lock(&iio_trigger_list_lock);
 	list_for_each_entry(trig, &iio_trigger_list, list) {
-		if (strncmp(trig->name, name, len) == 0) {
+		if (memcmp(trig->name, name, len) == 0) {
 			found = true;
 			break;
 		}
diff --git a/drivers/staging/iio/magnetometer/hmc5843.c b/drivers/staging/iio/magnetometer/hmc5843.c
index 5168917..0e12258 100644
--- a/drivers/staging/iio/magnetometer/hmc5843.c
+++ b/drivers/staging/iio/magnetometer/hmc5843.c
@@ -353,19 +353,19 @@ static ssize_t set_sampling_frequency(struct device *dev,
 	struct hmc5843_data *data = indio_dev->dev_data;
 	unsigned long rate = 0;
 
-	if (strncmp(buf, "0.5" , 3) == 0)
+	if (memcmp(buf, "0.5" , 3) == 0)
 		rate = RATE_5;
-	else if (strncmp(buf, "1" , 1) == 0)
+	else if (memcmp(buf, "1" , 1) == 0)
 		rate = RATE_10;
-	else if (strncmp(buf, "2", 1) == 0)
+	else if (memcmp(buf, "2", 1) == 0)
 		rate = RATE_20;
-	else if (strncmp(buf, "5", 1) == 0)
+	else if (memcmp(buf, "5", 1) == 0)
 		rate = RATE_50;
-	else if (strncmp(buf, "10", 2) == 0)
+	else if (memcmp(buf, "10", 2) == 0)
 		rate = RATE_100;
-	else if (strncmp(buf, "20" , 2) == 0)
+	else if (memcmp(buf, "20" , 2) == 0)
 		rate = RATE_200;
-	else if (strncmp(buf, "50" , 2) == 0)
+	else if (memcmp(buf, "50" , 2) == 0)
 		rate = RATE_500;
 	else
 		return -EINVAL;
@@ -511,7 +511,7 @@ static int hmc5843_detect(struct i2c_client *client,
 			!= HMC5843_ID_REG_LENGTH)
 		return -ENODEV;
 
-	if (0 != strncmp(id_str, HMC5843_ID_STRING, HMC5843_ID_REG_LENGTH))
+	if (0 != memcmp(id_str, HMC5843_ID_STRING, HMC5843_ID_REG_LENGTH))
 		return -ENODEV;
 
 	return 0;
diff --git a/drivers/staging/intel_sst/intel_sst_drv_interface.c b/drivers/staging/intel_sst/intel_sst_drv_interface.c
index 669e298..5c6a775 100644
--- a/drivers/staging/intel_sst/intel_sst_drv_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_drv_interface.c
@@ -449,7 +449,7 @@ int register_sst_card(struct intel_sst_card_ops *card)
 	}
 	if (sst_drv_ctx->pmic_state == SND_MAD_UN_INIT) {
 		/* register this driver */
-		if ((strncmp(SST_CARD_NAMES, card->module_name,
+		if ((memcmp(SST_CARD_NAMES, card->module_name,
 				strlen(SST_CARD_NAMES))) == 0) {
 			sst_drv_ctx->pmic_vendor = card->vendor_id;
 			sst_drv_ctx->scard_ops =  card->scard_ops;
diff --git a/drivers/staging/intel_sst/intel_sst_dsp.c b/drivers/staging/intel_sst/intel_sst_dsp.c
index d80a6ee..abceb83 100644
--- a/drivers/staging/intel_sst/intel_sst_dsp.c
+++ b/drivers/staging/intel_sst/intel_sst_dsp.c
@@ -181,7 +181,7 @@ static int sst_parse_fw_image(const struct firmware *sst_fw)
 	header = (struct fw_header *)sst_fw->data;
 
 	/* verify FW */
-	if ((strncmp(header->signature, SST_FW_SIGN, 4) != 0) ||
+	if ((memcmp(header->signature, SST_FW_SIGN, 4) != 0) ||
 			(sst_fw->size != header->file_size + sizeof(*header))) {
 		/* Invalid FW signature */
 		pr_err("sst: InvalidFW sign/filesize mismatch\n");
diff --git a/drivers/staging/msm/ebi2_lcd.c b/drivers/staging/msm/ebi2_lcd.c
index b41e123..6f57530 100644
--- a/drivers/staging/msm/ebi2_lcd.c
+++ b/drivers/staging/msm/ebi2_lcd.c
@@ -71,7 +71,7 @@ static int ebi2_lcd_probe(struct platform_device *pdev)
 
 	if (pdev->id == 0) {
 		for (i = 0; i < pdev->num_resources; i++) {
-			if (!strncmp(pdev->resource[i].name, "base", 4)) {
+			if (!memcmp(pdev->resource[i].name, "base", 4)) {
 				ebi2_base = ioremap(pdev->resource[i].start,
 						pdev->resource[i].end -
 						pdev->resource[i].start + 1);
@@ -82,7 +82,7 @@ static int ebi2_lcd_probe(struct platform_device *pdev)
 				}
 				ebi2_lcd_cfg0 = (void *)(ebi2_base + 0x20);
 				ebi2_lcd_cfg1 = (void *)(ebi2_base + 0x24);
-			} else if (!strncmp(pdev->resource[i].name,
+			} else if (!memcmp(pdev->resource[i].name,
 						"lcd01", 5)) {
 				lcd01_base = ioremap(pdev->resource[i].start,
 						pdev->resource[i].end -
@@ -92,7 +92,7 @@ static int ebi2_lcd_probe(struct platform_device *pdev)
 						"lcd01_base ioremap failed!\n");
 					return -ENOMEM;
 				}
-			} else if (!strncmp(pdev->resource[i].name,
+			} else if (!memcmp(pdev->resource[i].name,
 						"lcd02", 5)) {
 				lcd02_base = ioremap(pdev->resource[i].start,
 						pdev->resource[i].end -
diff --git a/drivers/staging/msm/staging-devices.c b/drivers/staging/msm/staging-devices.c
index d6cd919..06e3801 100644
--- a/drivers/staging/msm/staging-devices.c
+++ b/drivers/staging/msm/staging-devices.c
@@ -107,7 +107,7 @@ static int msm_fb_detect_panel(const char *name)
 	int ret = -EPERM;
 
 	if (machine_is_qsd8x50_ffa() || machine_is_qsd8x50a_ffa()) {
-		if (!strncmp(name, "mddi_toshiba_wvga_pt", 20))
+		if (!memcmp(name, "mddi_toshiba_wvga_pt", 20))
 			ret = 0;
 		else
 			ret = -ENODEV;
@@ -249,20 +249,20 @@ static void __init msm_register_device(struct platform_device *pdev, void *data)
 
 void __init msm_fb_register_device(char *name, void *data)
 {
-	if (!strncmp(name, "mdp", 3))
+	if (!memcmp(name, "mdp", 3))
 		msm_register_device(&msm_mdp_device, data);
 /*
-	else if (!strncmp(name, "pmdh", 4))
+	else if (!memcmp(name, "pmdh", 4))
 		msm_register_device(&msm_mddi_device, data);
-	else if (!strncmp(name, "emdh", 4))
+	else if (!memcmp(name, "emdh", 4))
 		msm_register_device(&msm_mddi_ext_device, data);
-	else if (!strncmp(name, "ebi2", 4))
+	else if (!memcmp(name, "ebi2", 4))
 		msm_register_device(&msm_ebi2_lcd_device, data);
-	else if (!strncmp(name, "tvenc", 5))
+	else if (!memcmp(name, "tvenc", 5))
 		msm_register_device(&msm_tvenc_device, data);
 	else */
 
-	if (!strncmp(name, "lcdc", 4))
+	if (!memcmp(name, "lcdc", 4))
 		msm_register_device(&msm_lcdc_device, data);
 	/*else
 		printk(KERN_ERR "%s: unknown device! %s\n", __func__, name);
diff --git a/drivers/staging/rt2860/common/rt_channel.c b/drivers/staging/rt2860/common/rt_channel.c
index 5387989..c004a81 100644
--- a/drivers/staging/rt2860/common/rt_channel.c
+++ b/drivers/staging/rt2860/common/rt_channel.c
@@ -1428,7 +1428,7 @@ static struct rt_ch_region *GetChRegion(u8 *CntryCode)
 	struct rt_ch_region *pChRegion = NULL;
 
 	while (strcmp((char *)ChRegion[loop].CountReg, "") != 0) {
-		if (strncmp
+		if (memcmp
 		    ((char *)ChRegion[loop].CountReg, (char *)CntryCode,
 		     2) == 0) {
 			pChRegion = &ChRegion[loop];
diff --git a/drivers/staging/rt2860/common/spectrum.c b/drivers/staging/rt2860/common/spectrum.c
index 2d5f847..aaf3b39 100644
--- a/drivers/staging/rt2860/common/spectrum.c
+++ b/drivers/staging/rt2860/common/spectrum.c
@@ -844,7 +844,7 @@ void InsertChannelRepIE(struct rt_rtmp_adapter *pAd,
 	u8 *pChListPtr = NULL;
 
 	Len = 1;
-	if (strncmp(pCountry, "US", 2) == 0) {
+	if (memcmp(pCountry, "US", 2) == 0) {
 		if (RegulatoryClass >= USA_REGULATORY_INFO_SIZE) {
 			DBGPRINT(RT_DEBUG_ERROR,
 				 ("%s: USA Unknow Requlatory class (%d)\n",
@@ -857,7 +857,7 @@ void InsertChannelRepIE(struct rt_rtmp_adapter *pAd,
 		    NumberOfChannels;
 		pChListPtr =
 		    USARegulatoryInfo[RegulatoryClass].ChannelSet.ChannelList;
-	} else if (strncmp(pCountry, "JP", 2) == 0) {
+	} else if (memcmp(pCountry, "JP", 2) == 0) {
 		if (RegulatoryClass >= JP_REGULATORY_INFO_SIZE) {
 			DBGPRINT(RT_DEBUG_ERROR,
 				 ("%s: JP Unknow Requlatory class (%d)\n",
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index 3a72449..75bf06f 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -1506,11 +1506,11 @@ inline void ieee80211_process_probe_response(
 		//YJ,add,080819,for hidden ap
 		if(is_beacon == 0)
 			network.flags = (~NETWORK_EMPTY_ESSID & network.flags)|(NETWORK_EMPTY_ESSID & target->flags);
-		//if(strncmp(network.ssid, "linksys-c",9) == 0)
+		//if(memcmp(network.ssid, "linksys-c",9) == 0)
 		//	printk("====>2 network.ssid=%s FLAG=%d target.ssid=%s FLAG=%d\n", network.ssid, network.flags, target->ssid, target->flags);
 		if(((network.flags & NETWORK_EMPTY_ESSID) == NETWORK_EMPTY_ESSID) \
-		    && (((network.ssid_len > 0) && (strncmp(target->ssid, network.ssid, network.ssid_len)))\
-		    ||((ieee->current_network.ssid_len == network.ssid_len)&&(strncmp(ieee->current_network.ssid, network.ssid, network.ssid_len) == 0)&&(ieee->state == IEEE80211_NOLINK))))
+		    && (((network.ssid_len > 0) && (memcmp(target->ssid, network.ssid, network.ssid_len)))\
+		    ||((ieee->current_network.ssid_len == network.ssid_len)&&(memcmp(ieee->current_network.ssid, network.ssid, network.ssid_len) == 0)&&(ieee->state == IEEE80211_NOLINK))))
 			renew = 1;
 		//YJ,add,080819,for hidden ap,end
 		update_network(target, &network);
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index 652d879..12d1f79 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -1340,7 +1340,7 @@ inline void ieee80211_softmac_new_net(struct ieee80211_device *ieee, struct ieee
 		if(ieee->current_network.ssid_len != net->ssid_len)
 			ssidmatch = 0;
 		else
-			ssidmatch = (0==strncmp(ieee->current_network.ssid, net->ssid, net->ssid_len));
+			ssidmatch = (0==memcmp(ieee->current_network.ssid, net->ssid, net->ssid_len));
 
 		//printk("cur: %s, %d, net:%s, %d\n", ieee->current_network.ssid, ieee->current_network.ssid_len, net->ssid, net->ssid_len);
 		//printk("apset=%d apmatch=%d ssidset=%d ssidbroad=%d ssidmatch=%d\n",apset,apmatch,ssidset,ssidbroad,ssidmatch);
@@ -1497,7 +1497,7 @@ static short probe_rq_parse(struct ieee80211_device *ieee, struct sk_buff *skb,
 	if (ssidlen == 0) return 1;
 
 	if (!ssid) return 1; /* ssid not found in tagged param */
-	return (!strncmp(ssid, ieee->current_network.ssid, ssidlen));
+	return (!memcmp(ssid, ieee->current_network.ssid, ssidlen));
 
 }
 
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
index 9318695..6e687c7 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
@@ -2806,11 +2806,11 @@ static inline void ieee80211_process_probe_response(
 		//YJ,add,080819,for hidden ap
 		if(is_beacon(beacon->header.frame_ctl) == 0)
 			network.flags = (~NETWORK_EMPTY_ESSID & network.flags)|(NETWORK_EMPTY_ESSID & target->flags);
-		//if(strncmp(network.ssid, "linksys-c",9) == 0)
+		//if(memcmp(network.ssid, "linksys-c",9) == 0)
 		//	printk("====>2 network.ssid=%s FLAG=%d target.ssid=%s FLAG=%d\n", network.ssid, network.flags, target->ssid, target->flags);
 		if(((network.flags & NETWORK_EMPTY_ESSID) == NETWORK_EMPTY_ESSID) \
-		    && (((network.ssid_len > 0) && (strncmp(target->ssid, network.ssid, network.ssid_len)))\
-		    ||((ieee->current_network.ssid_len == network.ssid_len)&&(strncmp(ieee->current_network.ssid, network.ssid, network.ssid_len) == 0)&&(ieee->state == IEEE80211_NOLINK))))
+		    && (((network.ssid_len > 0) && (memcmp(target->ssid, network.ssid, network.ssid_len)))\
+		    ||((ieee->current_network.ssid_len == network.ssid_len)&&(memcmp(ieee->current_network.ssid, network.ssid, network.ssid_len) == 0)&&(ieee->state == IEEE80211_NOLINK))))
 			renew = 1;
 		//YJ,add,080819,for hidden ap,end
 
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
index 54c9c24..ad37c28 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
@@ -1610,7 +1610,7 @@ inline void ieee80211_softmac_new_net(struct ieee80211_device *ieee, struct ieee
 		ssidbroad =  !(net->ssid_len == 0 || net->ssid[0]== '\0');
 		apmatch = (memcmp(ieee->current_network.bssid, net->bssid, ETH_ALEN)==0);
 		ssidmatch = (ieee->current_network.ssid_len == net->ssid_len)&&\
-				(!strncmp(ieee->current_network.ssid, net->ssid, net->ssid_len));
+				(!memcmp(ieee->current_network.ssid, net->ssid, net->ssid_len));
 
 
 		if (	/* if the user set the AP check if match.
@@ -1784,7 +1784,7 @@ static short probe_rq_parse(struct ieee80211_device *ieee, struct sk_buff *skb,
 	if (ssidlen == 0) return 1;
 
 	if (!ssid) return 1; /* ssid not found in tagged param */
-	return (!strncmp(ssid, ieee->current_network.ssid, ssidlen));
+	return (!memcmp(ssid, ieee->current_network.ssid, ssidlen));
 
 }
 
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index c8ca9d8..7d3b372 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -2617,11 +2617,11 @@ static inline void ieee80211_process_probe_response(
 		//YJ,add,080819,for hidden ap
 		if(is_beacon(beacon->header.frame_ctl) == 0)
 			network.flags = (~NETWORK_EMPTY_ESSID & network.flags)|(NETWORK_EMPTY_ESSID & target->flags);
-		//if(strncmp(network.ssid, "linksys-c",9) == 0)
+		//if(memcmp(network.ssid, "linksys-c",9) == 0)
 		//	printk("====>2 network.ssid=%s FLAG=%d target.ssid=%s FLAG=%d\n", network.ssid, network.flags, target->ssid, target->flags);
 		if(((network.flags & NETWORK_EMPTY_ESSID) == NETWORK_EMPTY_ESSID) \
-		    && (((network.ssid_len > 0) && (strncmp(target->ssid, network.ssid, network.ssid_len)))\
-		    ||((ieee->current_network.ssid_len == network.ssid_len)&&(strncmp(ieee->current_network.ssid, network.ssid, network.ssid_len) == 0)&&(ieee->state == IEEE80211_NOLINK))))
+		    && (((network.ssid_len > 0) && (memcmp(target->ssid, network.ssid, network.ssid_len)))\
+		    ||((ieee->current_network.ssid_len == network.ssid_len)&&(memcmp(ieee->current_network.ssid, network.ssid, network.ssid_len) == 0)&&(ieee->state == IEEE80211_NOLINK))))
 			renew = 1;
 		//YJ,add,080819,for hidden ap,end
 
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index bc8c425..3e4e4ec 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -1467,7 +1467,7 @@ inline void ieee80211_softmac_new_net(struct ieee80211_device *ieee, struct ieee
 		ssidbroad =  !(net->ssid_len == 0 || net->ssid[0]== '\0');
 		apmatch = (memcmp(ieee->current_network.bssid, net->bssid, ETH_ALEN)==0);
 		ssidmatch = (ieee->current_network.ssid_len == net->ssid_len)&&\
-				(!strncmp(ieee->current_network.ssid, net->ssid, net->ssid_len));
+				(!memcmp(ieee->current_network.ssid, net->ssid, net->ssid_len));
 
 
 		if (	/* if the user set the AP check if match.
@@ -1642,7 +1642,7 @@ static short probe_rq_parse(struct ieee80211_device *ieee, struct sk_buff *skb,
 	if (ssidlen == 0) return 1;
 
 	if (!ssid) return 1; /* ssid not found in tagged param */
-	return (!strncmp(ssid, ieee->current_network.ssid, ssidlen));
+	return (!memcmp(ssid, ieee->current_network.ssid, ssidlen));
 
 }
 
diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index 25d5c87..f595fdd 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -261,7 +261,7 @@ static int r8192_wx_get_ap_status(struct net_device *dev,
 	//search for the correspoding info which is received
 	list_for_each_entry(target, &ieee->network_list, list) {
 		if ( (target->ssid_len == name_len) &&
-		     (strncmp(target->ssid, (char*)wrqu->data.pointer, name_len)==0)){
+		     (memcmp(target->ssid, (char*)wrqu->data.pointer, name_len)==0)){
 			if(target->wpa_ie_len>0 || target->rsn_ie_len>0 )
 				//set flags=1 to indicate this ap is WPA
 				wrqu->data.flags = 1;
diff --git a/drivers/staging/stradis/stradis.c b/drivers/staging/stradis/stradis.c
index 807dd7e..30197b4 100644
--- a/drivers/staging/stradis/stradis.c
+++ b/drivers/staging/stradis/stradis.c
@@ -792,14 +792,14 @@ static int initialize_fpga(struct video_code *bitdata)
 		dmabuf = (u16 *) saa->dmadebi;
 		newdma = (u8 *) saa->dmadebi;
 		if (NewCard) {	/* SDM2xxx */
-			if (!strncmp(bitdata->loadwhat, "decoder2", 8))
+			if (!memcmp(bitdata->loadwhat, "decoder2", 8))
 				continue;	/* fpga not for this card */
-			if (!strncmp(&saa->boardcfg[42], bitdata->loadwhat, 8))
+			if (!memcmp(&saa->boardcfg[42], bitdata->loadwhat, 8))
 				loadfile = 1;
-			else if (loadtwo && !strncmp(&saa->boardcfg[19],
+			else if (loadtwo && !memcmp(&saa->boardcfg[19],
 				       bitdata->loadwhat, 8))
 				loadfile = 2;
-			else if (!saa->boardcfg[42] && !strncmp("decxl",
+			else if (!saa->boardcfg[42] && !memcmp("decxl",
 					bitdata->loadwhat, 8))
 				loadfile = 1;	/* special */
 			else
@@ -822,7 +822,7 @@ static int initialize_fpga(struct video_code *bitdata)
 			mdelay(10);
 			saawrite(0x00400000, SAA7146_GPIO_CTRL);
 		} else {	/* original card */
-			if (strncmp(bitdata->loadwhat, "decoder2", 8))
+			if (memcmp(bitdata->loadwhat, "decoder2", 8))
 				continue;	/* fpga not for this card */
 			/* Pull the Xilinx PROG signal WS3 low */
 			saawrite(0x02000200, SAA7146_MC1);
@@ -1049,7 +1049,7 @@ static int initialize_ibmmpeg2(struct video_code *microcode)
 			return -1;
 #endif
 		}
-		if (!strncmp(microcode->loadwhat, "decoder.vid", 11)) {
+		if (!memcmp(microcode->loadwhat, "decoder.vid", 11)) {
 			if (saa->boardcfg[0] > 27)
 				continue;	/* skip to next card */
 			/* load video control store */
@@ -1066,7 +1066,7 @@ static int initialize_ibmmpeg2(struct video_code *microcode)
 				ChipControl, 2);
 			saa->boardcfg[0] = 28;
 		}
-		if (!strncmp(microcode->loadwhat, "decoder.aud", 11)) {
+		if (!memcmp(microcode->loadwhat, "decoder.aud", 11)) {
 			if (saa->boardcfg[0] > 35)
 				continue;	/* skip to next card */
 			/* load audio control store */
@@ -1696,7 +1696,7 @@ static long saa_ioctl(struct file *file,
 			if (copy_from_user(&ucode, arg, sizeof(ucode)))
 				return -EFAULT;
 			if (ucode.datasize > 65536 || ucode.datasize < 1024 ||
-					strncmp(ucode.loadwhat, "dec", 3))
+					memcmp(ucode.loadwhat, "dec", 3))
 				return -EINVAL;
 			if ((udata = vmalloc(ucode.datasize)) == NULL)
 				return -ENOMEM;
@@ -1705,8 +1705,8 @@ static long saa_ioctl(struct file *file,
 				return -EFAULT;
 			}
 			ucode.data = udata;
-			if (!strncmp(ucode.loadwhat, "decoder.aud", 11) ||
-				!strncmp(ucode.loadwhat, "decoder.vid", 11))
+			if (!memcmp(ucode.loadwhat, "decoder.aud", 11) ||
+				!memcmp(ucode.loadwhat, "decoder.vid", 11))
 				i = initialize_ibmmpeg2(&ucode);
 			else
 				i = initialize_fpga(&ucode);
diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index 3581a55..52b742b 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -256,7 +256,7 @@ int dcd_enumerate_object(s32 index, enum dsp_dcdobjtype obj_type,
 			len = strlen(sz_reg_key);
 			spin_lock(&dbdcd_lock);
 			list_for_each_entry(dcd_key, &reg_key_list, link) {
-				if (!strncmp(dcd_key->name, sz_reg_key, len)
+				if (!memcmp(dcd_key->name, sz_reg_key, len)
 						&& !index--) {
 					strncpy(sz_value, &dcd_key->name[len],
 					       strlen(&dcd_key->name[len]) + 1);
@@ -449,7 +449,7 @@ int dcd_get_object_def(struct dcd_manager *hdcd_mgr,
 	if (!status) {
 		spin_lock(&dbdcd_lock);
 		list_for_each_entry(dcd_key, &reg_key_list, link) {
-			if (!strncmp(dcd_key->name, sz_reg_key,
+			if (!memcmp(dcd_key->name, sz_reg_key,
 						strlen(sz_reg_key) + 1))
 				break;
 		}
@@ -726,7 +726,7 @@ int dcd_get_library_name(struct dcd_manager *hdcd_mgr,
 		spin_lock(&dbdcd_lock);
 		list_for_each_entry(dcd_key, &reg_key_list, link) {
 			/*  See if the name matches. */
-			if (!strncmp(dcd_key->name, sz_reg_key,
+			if (!memcmp(dcd_key->name, sz_reg_key,
 						strlen(sz_reg_key) + 1))
 				break;
 		}
@@ -765,7 +765,7 @@ int dcd_get_library_name(struct dcd_manager *hdcd_mgr,
 		spin_lock(&dbdcd_lock);
 		list_for_each_entry(dcd_key, &reg_key_list, link) {
 			/*  See if the name matches. */
-			if (!strncmp(dcd_key->name, sz_reg_key,
+			if (!memcmp(dcd_key->name, sz_reg_key,
 						strlen(sz_reg_key) + 1))
 				break;
 		}
@@ -893,7 +893,7 @@ int dcd_register_object(struct dsp_uuid *uuid_obj,
 		spin_lock(&dbdcd_lock);
 		list_for_each_entry(dcd_key, &reg_key_list, link) {
 			/*  See if the name matches. */
-			if (!strncmp(dcd_key->name, sz_reg_key,
+			if (!memcmp(dcd_key->name, sz_reg_key,
 						strlen(sz_reg_key) + 1))
 				break;
 		}
@@ -929,7 +929,7 @@ int dcd_register_object(struct dsp_uuid *uuid_obj,
 			spin_unlock(&dbdcd_lock);
 		} else {
 			/*  Make sure the new data is the same. */
-			if (strncmp(dcd_key->path, psz_path_name,
+			if (memcmp(dcd_key->path, psz_path_name,
 							dw_path_size)) {
 				/*  The caller needs a different data size! */
 				kfree(dcd_key->path);
@@ -950,7 +950,7 @@ int dcd_register_object(struct dsp_uuid *uuid_obj,
 		/* Deregister an existing object */
 		spin_lock(&dbdcd_lock);
 		list_for_each_entry(dcd_key, &reg_key_list, link) {
-			if (!strncmp(dcd_key->name, sz_reg_key,
+			if (!memcmp(dcd_key->name, sz_reg_key,
 						strlen(sz_reg_key) + 1)) {
 				list_del(&dcd_key->link);
 				kfree(dcd_key->path);
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index a6ae007..6240e34 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -933,7 +933,7 @@ static int add_ovly_info(void *handle, struct dbll_sect_info *sect_info,
 	for (i = 0; i < nldr_obj->ovly_nodes; i++) {
 		node_name = nldr_obj->ovly_table[i].node_name;
 		DBC_REQUIRE(node_name);
-		if (strncmp(node_name, sect_name + 1, strlen(node_name)) == 0) {
+		if (memcmp(node_name, sect_name + 1, strlen(node_name)) == 0) {
 			/* Found the node */
 			break;
 		}
@@ -947,7 +947,7 @@ static int add_ovly_info(void *handle, struct dbll_sect_info *sect_info,
 
 	if (*pch) {
 		pch++;		/* Skip over the ':' */
-		if (strncmp(pch, PCREATE, strlen(PCREATE)) == 0) {
+		if (memcmp(pch, PCREATE, strlen(PCREATE)) == 0) {
 			status =
 			    add_ovly_sect(nldr_obj,
 					  &nldr_obj->
@@ -956,7 +956,7 @@ static int add_ovly_info(void *handle, struct dbll_sect_info *sect_info,
 			if (!status && !sect_exists)
 				nldr_obj->ovly_table[i].create_sects++;
 
-		} else if (strncmp(pch, PDELETE, strlen(PDELETE)) == 0) {
+		} else if (memcmp(pch, PDELETE, strlen(PDELETE)) == 0) {
 			status =
 			    add_ovly_sect(nldr_obj,
 					  &nldr_obj->
@@ -965,7 +965,7 @@ static int add_ovly_info(void *handle, struct dbll_sect_info *sect_info,
 			if (!status && !sect_exists)
 				nldr_obj->ovly_table[i].delete_sects++;
 
-		} else if (strncmp(pch, PEXECUTE, strlen(PEXECUTE)) == 0) {
+		} else if (memcmp(pch, PEXECUTE, strlen(PEXECUTE)) == 0) {
 			status =
 			    add_ovly_sect(nldr_obj,
 					  &nldr_obj->
diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index f3a4096..60ea8b2 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -53,7 +53,7 @@ int match_busid(const char *busid)
 
 	for (i = 0; i < MAX_BUSID; i++)
 		if (busid_table[i].name[0])
-			if (!strncmp(busid_table[i].name, busid, BUSID_SIZE)) {
+			if (!memcmp(busid_table[i].name, busid, BUSID_SIZE)) {
 				/* already registerd */
 				spin_unlock(&busid_table_lock);
 				return 0;
@@ -72,7 +72,7 @@ struct bus_id_priv *get_busid_priv(const char *busid)
 
 	for (i = 0; i < MAX_BUSID; i++)
 		if (busid_table[i].name[0])
-			if (!strncmp(busid_table[i].name, busid, BUSID_SIZE)) {
+			if (!memcmp(busid_table[i].name, busid, BUSID_SIZE)) {
 				/* already registerd */
 				spin_unlock(&busid_table_lock);
 				return &(busid_table[i]);
@@ -132,7 +132,7 @@ int del_match_busid(char *busid)
 	spin_lock(&busid_table_lock);
 
 	for (i = 0; i < MAX_BUSID; i++)
-		if (!strncmp(busid_table[i].name, busid, BUSID_SIZE)) {
+		if (!memcmp(busid_table[i].name, busid, BUSID_SIZE)) {
 			/* found */
 			if (busid_table[i].status == STUB_BUSID_OTHER)
 				memset(busid_table[i].name, 0, BUSID_SIZE);
@@ -182,14 +182,14 @@ static ssize_t store_match_busid(struct device_driver *dev, const char *buf,
 	strncpy(busid, buf + 4, BUSID_SIZE);
 
 
-	if (!strncmp(buf, "add ", 4)) {
+	if (!memcmp(buf, "add ", 4)) {
 		if (add_match_busid(busid) < 0)
 			return -ENOMEM;
 		else {
 			usbip_udbg("add busid %s\n", busid);
 			return count;
 		}
-	} else if (!strncmp(buf, "del ", 4)) {
+	} else if (!memcmp(buf, "del ", 4)) {
 		if (del_match_busid(busid) < 0)
 			return -ENODEV;
 		else {
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 4f73d09..5d73f7d 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -521,7 +521,7 @@ static void XGIfb_search_mode(const char *name)
 
 	while (XGIbios_mode[i].mode_no != 0) {
 		l = min(strlen(name), strlen(XGIbios_mode[i].name));
-		if (!strncmp(name, XGIbios_mode[i].name, l)) {
+		if (!memcmp(name, XGIbios_mode[i].name, l)) {
 			xgifb_mode_idx = i;
 			j = 1;
 			break;
@@ -2813,53 +2813,53 @@ XGIINITSTATIC int __init XGIfb_setup(char *options)
 		if (!*this_opt)
 			continue;
 
-		if (!strncmp(this_opt, "mode:", 5)) {
+		if (!memcmp(this_opt, "mode:", 5)) {
 			XGIfb_search_mode(this_opt + 5);
-		} else if (!strncmp(this_opt, "vesa:", 5)) {
+		} else if (!memcmp(this_opt, "vesa:", 5)) {
 			XGIfb_search_vesamode(simple_strtoul(this_opt + 5, NULL, 0));
-		} else if (!strncmp(this_opt, "mode:", 5)) {
+		} else if (!memcmp(this_opt, "mode:", 5)) {
 			XGIfb_search_mode(this_opt + 5);
-		} else if (!strncmp(this_opt, "vesa:", 5)) {
+		} else if (!memcmp(this_opt, "vesa:", 5)) {
 			XGIfb_search_vesamode(simple_strtoul(this_opt + 5, NULL, 0));
-		} else if (!strncmp(this_opt, "vrate:", 6)) {
+		} else if (!memcmp(this_opt, "vrate:", 6)) {
 			xgi_video_info.refresh_rate = simple_strtoul(this_opt + 6, NULL, 0);
-		} else if (!strncmp(this_opt, "rate:", 5)) {
+		} else if (!memcmp(this_opt, "rate:", 5)) {
 			xgi_video_info.refresh_rate = simple_strtoul(this_opt + 5, NULL, 0);
-		} else if (!strncmp(this_opt, "off", 3)) {
+		} else if (!memcmp(this_opt, "off", 3)) {
 			XGIfb_off = 1;
-		} else if (!strncmp(this_opt, "crt1off", 7)) {
+		} else if (!memcmp(this_opt, "crt1off", 7)) {
 			XGIfb_crt1off = 1;
-		} else if (!strncmp(this_opt, "filter:", 7)) {
+		} else if (!memcmp(this_opt, "filter:", 7)) {
 			filter = (int)simple_strtoul(this_opt + 7, NULL, 0);
-		} else if (!strncmp(this_opt, "forcecrt2type:", 14)) {
+		} else if (!memcmp(this_opt, "forcecrt2type:", 14)) {
 			XGIfb_search_crt2type(this_opt + 14);
-		} else if (!strncmp(this_opt, "forcecrt1:", 10)) {
+		} else if (!memcmp(this_opt, "forcecrt1:", 10)) {
 			XGIfb_forcecrt1 = (int)simple_strtoul(this_opt + 10, NULL, 0);
-		} else if (!strncmp(this_opt, "tvmode:", 7)) {
+		} else if (!memcmp(this_opt, "tvmode:", 7)) {
 			XGIfb_search_tvstd(this_opt + 7);
-		} else if (!strncmp(this_opt, "tvstandard:", 11)) {
+		} else if (!memcmp(this_opt, "tvstandard:", 11)) {
 			XGIfb_search_tvstd(this_opt + 7);
-		} else if (!strncmp(this_opt, "mem:", 4)) {
+		} else if (!memcmp(this_opt, "mem:", 4)) {
 			XGIfb_mem = simple_strtoul(this_opt + 4, NULL, 0);
-		} else if (!strncmp(this_opt, "dstn", 4)) {
+		} else if (!memcmp(this_opt, "dstn", 4)) {
 			enable_dstn = 1;
 			/* TW: DSTN overrules forcecrt2type */
 			XGIfb_crt2type = DISPTYPE_LCD;
-		} else if (!strncmp(this_opt, "queuemode:", 10)) {
+		} else if (!memcmp(this_opt, "queuemode:", 10)) {
 			XGIfb_search_queuemode(this_opt + 10);
-		} else if (!strncmp(this_opt, "pdc:", 4)) {
+		} else if (!memcmp(this_opt, "pdc:", 4)) {
 			XGIfb_pdc = simple_strtoul(this_opt + 4, NULL, 0);
 			if (XGIfb_pdc & ~0x3c) {
 				printk(KERN_INFO "XGIfb: Illegal pdc parameter\n");
 				XGIfb_pdc = 0;
 			}
-		} else if (!strncmp(this_opt, "noaccel", 7)) {
+		} else if (!memcmp(this_opt, "noaccel", 7)) {
 			XGIfb_accel = 0;
-		} else if (!strncmp(this_opt, "noypan", 6)) {
+		} else if (!memcmp(this_opt, "noypan", 6)) {
 			XGIfb_ypan = 0;
-		} else if (!strncmp(this_opt, "userom:", 7)) {
+		} else if (!memcmp(this_opt, "userom:", 7)) {
 			XGIfb_userom = (int)simple_strtoul(this_opt + 7, NULL, 0);
-			/* } else if (!strncmp(this_opt, "useoem:", 7)) { */
+			/* } else if (!memcmp(this_opt, "useoem:", 7)) { */
 			/* XGIfb_useoem = (int)simple_strtoul(this_opt + 7, NULL, 0); */
 		} else {
 			XGIfb_search_mode(this_opt);
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 13c72c6..4a9d7fa 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -148,9 +148,9 @@ mode_store(struct device *dev, struct device_attribute *attr,
 	if (!tz->ops->set_mode)
 		return -EPERM;
 
-	if (!strncmp(buf, "enabled", sizeof("enabled")))
+	if (!memcmp(buf, "enabled", sizeof("enabled")))
 		result = tz->ops->set_mode(tz, THERMAL_DEVICE_ENABLED);
-	else if (!strncmp(buf, "disabled", sizeof("disabled")))
+	else if (!memcmp(buf, "disabled", sizeof("disabled")))
 		result = tz->ops->set_mode(tz, THERMAL_DEVICE_DISABLED);
 	else
 		result = -EINVAL;
@@ -235,7 +235,7 @@ passive_store(struct device *dev, struct device_attribute *attr,
 	if (state && !tz->forced_passive) {
 		mutex_lock(&thermal_list_lock);
 		list_for_each_entry(cdev, &thermal_cdev_list, node) {
-			if (!strncmp("Processor", cdev->type,
+			if (!memcmp("Processor", cdev->type,
 				     sizeof("Processor")))
 				thermal_zone_bind_cooling_device(tz,
 								 THERMAL_TRIPS_NONE,
@@ -247,7 +247,7 @@ passive_store(struct device *dev, struct device_attribute *attr,
 	} else if (!state && tz->forced_passive) {
 		mutex_lock(&thermal_list_lock);
 		list_for_each_entry(cdev, &thermal_cdev_list, node) {
-			if (!strncmp("Processor", cdev->type,
+			if (!memcmp("Processor", cdev->type,
 				     sizeof("Processor")))
 				thermal_zone_unbind_cooling_device(tz,
 								   THERMAL_TRIPS_NONE,
@@ -803,7 +803,7 @@ static void thermal_release(struct device *dev)
 	struct thermal_zone_device *tz;
 	struct thermal_cooling_device *cdev;
 
-	if (!strncmp(dev_name(dev), "thermal_zone", sizeof "thermal_zone" - 1)) {
+	if (!memcmp(dev_name(dev), "thermal_zone", sizeof "thermal_zone" - 1)) {
 		tz = to_thermal_zone(dev);
 		kfree(tz);
 	} else {
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index c05c5af..c2561e5 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -353,7 +353,7 @@ struct tty_driver *tty_find_polling_driver(char *name, int *line)
 	mutex_lock(&tty_mutex);
 	/* Search through the tty devices to look for a match */
 	list_for_each_entry(p, &tty_drivers, tty_drivers) {
-		if (strncmp(name, p->name, len) != 0)
+		if (memcmp(name, p->name, len) != 0)
 			continue;
 		stp = str;
 		if (*stp == ',')
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 44447f5..309d392 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -1658,7 +1658,7 @@ static int request_cmvs(struct uea_softc *sc,
 
 	size = (*fw)->size;
 	data = (u8 *) (*fw)->data;
-	if (size < 4 || strncmp(data, "cmv2", 4) != 0) {
+	if (size < 4 || memcmp(data, "cmv2", 4) != 0) {
 		if (*ver == 1) {
 			uea_warn(INS_TO_USBDEV(sc), "firmware %s is corrupted,"
 				" try to get older cmvs\n", cmv_name);
diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index 448f5b4..3995454 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -422,11 +422,11 @@ set_level(struct device *dev, struct device_attribute *attr,
 	usb_lock_device(udev);
 
 	if (len == sizeof on_string - 1 &&
-			strncmp(buf, on_string, len) == 0)
+			memcmp(buf, on_string, len) == 0)
 		usb_disable_autosuspend(udev);
 
 	else if (len == sizeof auto_string - 1 &&
-			strncmp(buf, auto_string, len) == 0)
+			memcmp(buf, auto_string, len) == 0)
 		usb_enable_autosuspend(udev);
 
 	else
diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index c244895..51fbe44 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -1828,7 +1828,7 @@ static int s3c2410_udc_probe(struct platform_device *pdev)
 
 	dev_dbg(dev, "got and enabled clocks\n");
 
-	if (strncmp(pdev->name, "s3c2440", 7) == 0) {
+	if (memcmp(pdev->name, "s3c2440", 7) == 0) {
 		dev_info(dev, "S3C2440: increasing FIFO to 128 bytes\n");
 		memory.ep[1].fifo_size = S3C2440_EP_FIFO_SIZE;
 		memory.ep[2].fifo_size = S3C2440_EP_FIFO_SIZE;
diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
index 6e25996..1cc8aa0 100644
--- a/drivers/usb/host/ehci-dbg.c
+++ b/drivers/usb/host/ehci-dbg.c
@@ -999,7 +999,7 @@ static ssize_t debug_lpm_write(struct file *file, const char __user *user_buf,
 	if (len > 0 && buf[len - 1] == '\n')
 		buf[len - 1] = '\0';
 
-	if (strncmp(buf, "enable", 5) == 0) {
+	if (memcmp(buf, "enable", 5) == 0) {
 		if (strict_strtoul(buf + 7, 10, &port))
 			return -EINVAL;
 		params = ehci_readl(ehci, &ehci->caps->hcs_params);
@@ -1016,7 +1016,7 @@ static ssize_t debug_lpm_write(struct file *file, const char __user *user_buf,
 		temp |= PORT_LPM;
 		ehci_writel(ehci, temp, portsc);
 		printk(KERN_INFO "force enable LPM for port %lu\n", port);
-	} else if (strncmp(buf, "hird=", 5) == 0) {
+	} else if (memcmp(buf, "hird=", 5) == 0) {
 		unsigned long hird;
 		if (strict_strtoul(buf + 5, 16, &hird))
 			return -EINVAL;
@@ -1025,7 +1025,7 @@ static ssize_t debug_lpm_write(struct file *file, const char __user *user_buf,
 		temp &= ~CMD_HIRD;
 		temp |= hird << 24;
 		ehci_writel(ehci, temp, &ehci->regs->command);
-	} else if (strncmp(buf, "disable", 7) == 0) {
+	} else if (memcmp(buf, "disable", 7) == 0) {
 		if (strict_strtoul(buf + 8, 10, &port))
 			return -EINVAL;
 		params = ehci_readl(ehci, &ehci->caps->hcs_params);
diff --git a/drivers/usb/musb/musb_debugfs.c b/drivers/usb/musb/musb_debugfs.c
index 9e8639d..8d553c2 100644
--- a/drivers/usb/musb/musb_debugfs.c
+++ b/drivers/usb/musb/musb_debugfs.c
@@ -211,30 +211,30 @@ static ssize_t musb_test_mode_write(struct file *file,
 	if (copy_from_user(&buf, ubuf, min_t(size_t, sizeof(buf) - 1, count)))
 		return -EFAULT;
 
-	if (!strncmp(buf, "force host", 9))
+	if (!memcmp(buf, "force host", 9))
 		test = MUSB_TEST_FORCE_HOST;
 
-	if (!strncmp(buf, "fifo access", 11))
+	if (!memcmp(buf, "fifo access", 11))
 		test = MUSB_TEST_FIFO_ACCESS;
 
-	if (!strncmp(buf, "force full-speed", 15))
+	if (!memcmp(buf, "force full-speed", 15))
 		test = MUSB_TEST_FORCE_FS;
 
-	if (!strncmp(buf, "force high-speed", 15))
+	if (!memcmp(buf, "force high-speed", 15))
 		test = MUSB_TEST_FORCE_HS;
 
-	if (!strncmp(buf, "test packet", 10)) {
+	if (!memcmp(buf, "test packet", 10)) {
 		test = MUSB_TEST_PACKET;
 		musb_load_testpacket(musb);
 	}
 
-	if (!strncmp(buf, "test K", 6))
+	if (!memcmp(buf, "test K", 6))
 		test = MUSB_TEST_K;
 
-	if (!strncmp(buf, "test J", 6))
+	if (!memcmp(buf, "test J", 6))
 		test = MUSB_TEST_J;
 
-	if (!strncmp(buf, "test SE0 NAK", 12))
+	if (!memcmp(buf, "test SE0 NAK", 12))
 		test = MUSB_TEST_SE0_NAK;
 
 	musb_writeb(musb->mregs, MUSB_TESTMODE, test);
diff --git a/drivers/usb/storage/libusual.c b/drivers/usb/storage/libusual.c
index fe3ffe1..2025656 100644
--- a/drivers/usb/storage/libusual.c
+++ b/drivers/usb/storage/libusual.c
@@ -216,7 +216,7 @@ static int usu_set_bias(const char *bias_s, struct kernel_param *kp)
 		--len;
 
 	for (i = 1; i < 3; i++) {
-		if (strncmp(bias_s, bias_names[i], len) == 0) {
+		if (memcmp(bias_s, bias_names[i], len) == 0) {
 			bias_n = i;
 			break;
 		}
diff --git a/drivers/video/68328fb.c b/drivers/video/68328fb.c
index 75a39ea..9e50ab0 100644
--- a/drivers/video/68328fb.c
+++ b/drivers/video/68328fb.c
@@ -421,7 +421,7 @@ int __init mc68x328fb_setup(char *options)
 	while ((this_opt = strsep(&options, ",")) != NULL) {
 		if (!*this_opt)
 			continue;
-		if (!strncmp(this_opt, "disable", 7))
+		if (!memcmp(this_opt, "disable", 7))
 			mc68x328fb_enable = 0;
 	}
 #endif
diff --git a/drivers/video/acornfb.c b/drivers/video/acornfb.c
index 82acb8d..a59b567 100644
--- a/drivers/video/acornfb.c
+++ b/drivers/video/acornfb.c
@@ -1071,22 +1071,22 @@ acornfb_parse_montype(char *opt)
 {
 	current_par.montype = -2;
 
-	if (strncmp(opt, "tv", 2) == 0) {
+	if (memcmp(opt, "tv", 2) == 0) {
 		opt += 2;
 		current_par.montype = 0;
-	} else if (strncmp(opt, "multi", 5) == 0) {
+	} else if (memcmp(opt, "multi", 5) == 0) {
 		opt += 5;
 		current_par.montype = 1;
-	} else if (strncmp(opt, "hires", 5) == 0) {
+	} else if (memcmp(opt, "hires", 5) == 0) {
 		opt += 5;
 		current_par.montype = 2;
-	} else if (strncmp(opt, "vga", 3) == 0) {
+	} else if (memcmp(opt, "vga", 3) == 0) {
 		opt += 3;
 		current_par.montype = 3;
-	} else if (strncmp(opt, "svga", 4) == 0) {
+	} else if (memcmp(opt, "svga", 4) == 0) {
 		opt += 4;
 		current_par.montype = 4;
-	} else if (strncmp(opt, "auto", 4) == 0) {
+	} else if (memcmp(opt, "auto", 4) == 0) {
 		opt += 4;
 		current_par.montype = -1;
 	} else if (isdigit(*opt))
@@ -1161,7 +1161,7 @@ acornfb_setup(char *options)
 
 			optlen = strlen(optp->name);
 
-			if (strncmp(opt, optp->name, optlen) == 0 &&
+			if (memcmp(opt, optp->name, optlen) == 0 &&
 			    opt[optlen] == ':') {
 				optp->parse(opt + optlen + 1);
 				break;
diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index e5d6b56..171469c 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -1237,9 +1237,9 @@ int __init amifb_setup(char *options)
 			fb_invert_cmaps();
 		} else if (!strcmp(this_opt, "ilbm"))
 			amifb_ilbm = 1;
-		else if (!strncmp(this_opt, "monitorcap:", 11))
+		else if (!memcmp(this_opt, "monitorcap:", 11))
 			amifb_setup_mcap(this_opt+11);
-		else if (!strncmp(this_opt, "fstart:", 7))
+		else if (!memcmp(this_opt, "fstart:", 7))
 			min_fstrt = simple_strtoul(this_opt+7, NULL, 0);
 		else
 			mode_option = this_opt;
diff --git a/drivers/video/atafb.c b/drivers/video/atafb.c
index 5b2b5ef..0cf8b7d 100644
--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -3040,7 +3040,7 @@ int __init atafb_setup(char *options)
 			mode_option = this_opt;
 		} else if (!strcmp(this_opt, "inverse"))
 			inverse = 1;
-		else if (!strncmp(this_opt, "hwscroll_", 9)) {
+		else if (!memcmp(this_opt, "hwscroll_", 9)) {
 			hwscroll = simple_strtoul(this_opt + 9, NULL, 10);
 			if (hwscroll < 0)
 				hwscroll = 0;
@@ -3051,23 +3051,23 @@ int __init atafb_setup(char *options)
 		else if (!strcmp(this_opt, "mv300")) {
 			external_bitspercol = 8;
 			external_card_type = IS_MV300;
-		} else if (!strncmp(this_opt, "external:", 9))
+		} else if (!memcmp(this_opt, "external:", 9))
 			atafb_setup_ext(this_opt + 9);
 #endif
-		else if (!strncmp(this_opt, "internal:", 9))
+		else if (!memcmp(this_opt, "internal:", 9))
 			atafb_setup_int(this_opt + 9);
 #ifdef ATAFB_FALCON
-		else if (!strncmp(this_opt, "eclock:", 7)) {
+		else if (!memcmp(this_opt, "eclock:", 7)) {
 			fext.f = simple_strtoul(this_opt + 7, NULL, 10);
 			/* external pixelclock in kHz --> ps */
 			fext.t = 1000000000 / fext.f;
 			fext.f *= 1000;
-		} else if (!strncmp(this_opt, "monitorcap:", 11))
+		} else if (!memcmp(this_opt, "monitorcap:", 11))
 			atafb_setup_mcap(this_opt + 11);
 #endif
 		else if (!strcmp(this_opt, "keep"))
 			DontCalcRes = 1;
-		else if (!strncmp(this_opt, "R", 1))
+		else if (!memcmp(this_opt, "R", 1))
 			atafb_setup_user(this_opt + 1);
 	}
 	return 0;
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index 34a0851..6e0e2ca 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -1649,30 +1649,30 @@ static int __devinit aty128fb_setup(char *options)
 		return 0;
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
-		if (!strncmp(this_opt, "lcd:", 4)) {
+		if (!memcmp(this_opt, "lcd:", 4)) {
 			default_lcd_on = simple_strtoul(this_opt+4, NULL, 0);
 			continue;
-		} else if (!strncmp(this_opt, "crt:", 4)) {
+		} else if (!memcmp(this_opt, "crt:", 4)) {
 			default_crt_on = simple_strtoul(this_opt+4, NULL, 0);
 			continue;
-		} else if (!strncmp(this_opt, "backlight:", 10)) {
+		} else if (!memcmp(this_opt, "backlight:", 10)) {
 			backlight = simple_strtoul(this_opt+10, NULL, 0);
 			continue;
 		}
 #ifdef CONFIG_MTRR
-		if(!strncmp(this_opt, "nomtrr", 6)) {
+		if(!memcmp(this_opt, "nomtrr", 6)) {
 			mtrr = 0;
 			continue;
 		}
 #endif
 #ifdef CONFIG_PPC_PMAC
 		/* vmode and cmode deprecated */
-		if (!strncmp(this_opt, "vmode:", 6)) {
+		if (!memcmp(this_opt, "vmode:", 6)) {
 			unsigned int vmode = simple_strtoul(this_opt+6, NULL, 0);
 			if (vmode > 0 && vmode <= VMODE_MAX)
 				default_vmode = vmode;
 			continue;
-		} else if (!strncmp(this_opt, "cmode:", 6)) {
+		} else if (!memcmp(this_opt, "cmode:", 6)) {
 			unsigned int cmode = simple_strtoul(this_opt+6, NULL, 0);
 			switch (cmode) {
 			case 0:
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 5bf9123..6f58cad 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -3870,31 +3870,31 @@ static int __init atyfb_setup(char *options)
 		return 0;
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
-		if (!strncmp(this_opt, "noaccel", 7)) {
+		if (!memcmp(this_opt, "noaccel", 7)) {
 			noaccel = 1;
 #ifdef CONFIG_MTRR
-		} else if (!strncmp(this_opt, "nomtrr", 6)) {
+		} else if (!memcmp(this_opt, "nomtrr", 6)) {
 			nomtrr = 1;
 #endif
-		} else if (!strncmp(this_opt, "vram:", 5))
+		} else if (!memcmp(this_opt, "vram:", 5))
 			vram = simple_strtoul(this_opt + 5, NULL, 0);
-		else if (!strncmp(this_opt, "pll:", 4))
+		else if (!memcmp(this_opt, "pll:", 4))
 			pll = simple_strtoul(this_opt + 4, NULL, 0);
-		else if (!strncmp(this_opt, "mclk:", 5))
+		else if (!memcmp(this_opt, "mclk:", 5))
 			mclk = simple_strtoul(this_opt + 5, NULL, 0);
-		else if (!strncmp(this_opt, "xclk:", 5))
+		else if (!memcmp(this_opt, "xclk:", 5))
 			xclk = simple_strtoul(this_opt+5, NULL, 0);
-		else if (!strncmp(this_opt, "comp_sync:", 10))
+		else if (!memcmp(this_opt, "comp_sync:", 10))
 			comp_sync = simple_strtoul(this_opt+10, NULL, 0);
-		else if (!strncmp(this_opt, "backlight:", 10))
+		else if (!memcmp(this_opt, "backlight:", 10))
 			backlight = simple_strtoul(this_opt+10, NULL, 0);
 #ifdef CONFIG_PPC
-		else if (!strncmp(this_opt, "vmode:", 6)) {
+		else if (!memcmp(this_opt, "vmode:", 6)) {
 			unsigned int vmode =
 			    simple_strtoul(this_opt + 6, NULL, 0);
 			if (vmode > 0 && vmode <= VMODE_MAX)
 				default_vmode = vmode;
-		} else if (!strncmp(this_opt, "cmode:", 6)) {
+		} else if (!memcmp(this_opt, "cmode:", 6)) {
 			unsigned int cmode =
 			    simple_strtoul(this_opt + 6, NULL, 0);
 			switch (cmode) {
@@ -3919,7 +3919,7 @@ static int __init atyfb_setup(char *options)
 		 * We are already here because of mach64= so its redundant.
 		 */
 		else if (MACH_IS_ATARI
-			 && (!strncmp(this_opt, "Mach64:", 7))) {
+			 && (!memcmp(this_opt, "Mach64:", 7))) {
 			static unsigned char m64_num;
 			static char mach64_str[80];
 			strlcpy(mach64_str, this_opt + 7, sizeof(mach64_str));
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 3c1e13e..8103c6c 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -2484,30 +2484,30 @@ static int __init radeonfb_setup (char *options)
 		if (!*this_opt)
 			continue;
 
-		if (!strncmp(this_opt, "noaccel", 7)) {
+		if (!memcmp(this_opt, "noaccel", 7)) {
 			noaccel = 1;
-		} else if (!strncmp(this_opt, "mirror", 6)) {
+		} else if (!memcmp(this_opt, "mirror", 6)) {
 			mirror = 1;
-		} else if (!strncmp(this_opt, "force_dfp", 9)) {
+		} else if (!memcmp(this_opt, "force_dfp", 9)) {
 			force_dfp = 1;
-		} else if (!strncmp(this_opt, "panel_yres:", 11)) {
+		} else if (!memcmp(this_opt, "panel_yres:", 11)) {
 			panel_yres = simple_strtoul((this_opt+11), NULL, 0);
-		} else if (!strncmp(this_opt, "backlight:", 10)) {
+		} else if (!memcmp(this_opt, "backlight:", 10)) {
 			backlight = simple_strtoul(this_opt+10, NULL, 0);
 #ifdef CONFIG_MTRR
-		} else if (!strncmp(this_opt, "nomtrr", 6)) {
+		} else if (!memcmp(this_opt, "nomtrr", 6)) {
 			nomtrr = 1;
 #endif
-		} else if (!strncmp(this_opt, "nomodeset", 9)) {
+		} else if (!memcmp(this_opt, "nomodeset", 9)) {
 			nomodeset = 1;
-		} else if (!strncmp(this_opt, "force_measure_pll", 17)) {
+		} else if (!memcmp(this_opt, "force_measure_pll", 17)) {
 			force_measure_pll = 1;
-		} else if (!strncmp(this_opt, "ignore_edid", 11)) {
+		} else if (!memcmp(this_opt, "ignore_edid", 11)) {
 			ignore_edid = 1;
 #if defined(CONFIG_PM) && defined(CONFIG_X86)
-	 	} else if (!strncmp(this_opt, "force_sleep", 11)) {
+	 	} else if (!memcmp(this_opt, "force_sleep", 11)) {
 			force_sleep = 1;
-		} else if (!strncmp(this_opt, "ignore_devlist", 14)) {
+		} else if (!memcmp(this_opt, "ignore_devlist", 14)) {
 			ignore_devlist = 1;
 #endif
 		} else
diff --git a/drivers/video/au1100fb.c b/drivers/video/au1100fb.c
index 34b2fc4..9ca1319 100644
--- a/drivers/video/au1100fb.c
+++ b/drivers/video/au1100fb.c
@@ -694,11 +694,11 @@ int au1100fb_setup(char *options)
 	if (options) {
 		while ((this_opt = strsep(&options,",")) != NULL) {
 			/* Panel option */
-			if (!strncmp(this_opt, "panel:", 6)) {
+			if (!memcmp(this_opt, "panel:", 6)) {
 				int i;
 				this_opt += 6;
 				for (i = 0; i < num_panels; i++) {
-					if (!strncmp(this_opt,
+					if (!memcmp(this_opt,
 					      	     known_lcd_panels[i].name,
 							strlen(this_opt))) {
 						panel_idx = i;
@@ -709,7 +709,7 @@ int au1100fb_setup(char *options)
  					print_warn("Panel %s not supported!", this_opt);
 				}
 			}
-			if (!strncmp(this_opt, "nocursor", 8)) {
+			if (!memcmp(this_opt, "nocursor", 8)) {
 				this_opt += 8;
 				nocursor = 1;
 				print_info("Cursor disabled");
diff --git a/drivers/video/au1200fb.c b/drivers/video/au1200fb.c
index 4ea187d..e8772a3 100644
--- a/drivers/video/au1200fb.c
+++ b/drivers/video/au1200fb.c
@@ -1792,7 +1792,7 @@ static void au1200fb_setup(void)
 		while ((this_opt = strsep(&options,",")) != NULL) {
 			/* Panel option - can be panel name,
 			 * "bs" for board-switch, or number/index */
-			if (!strncmp(this_opt, "panel:", 6)) {
+			if (!memcmp(this_opt, "panel:", 6)) {
 				int i;
 				long int li;
 				char *endptr;
@@ -1823,7 +1823,7 @@ static void au1200fb_setup(void)
 					panel_index = panel_idx;
 			}
 
-			else if (strncmp(this_opt, "nohwcursor", 10) == 0) {
+			else if (memcmp(this_opt, "nohwcursor", 10) == 0) {
 				nohwcursor = 1;
 			}
 
diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index 38ffc3f..0df2f68 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -170,7 +170,7 @@ static int __check_device(struct pm860x_backlight_pdata *pdata, char *name)
 		if ((p->id != PM8606_ID_BACKLIGHT) || (p->flags < 0))
 			break;
 
-		if (!strncmp(name, pm860x_backlight_name[p->flags],
+		if (!memcmp(name, pm860x_backlight_name[p->flags],
 			MFD_NAME_SIZE)) {
 			ret = (int)p->flags;
 			break;
diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index 6df7c54..778152d 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -2362,7 +2362,7 @@ static int __init cirrusfb_setup(char *options)
 
 		if (!strcmp(this_opt, "noaccel"))
 			noaccel = 1;
-		else if (!strncmp(this_opt, "mode:", 5))
+		else if (!memcmp(this_opt, "mode:", 5))
 			mode_option = this_opt + 5;
 		else
 			mode_option = this_opt;
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 7ccc967..85f615d 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -444,10 +444,10 @@ static int __init fb_console_setup(char *this_opt)
 		return 1;
 
 	while ((options = strsep(&this_opt, ",")) != NULL) {
-		if (!strncmp(options, "font:", 5))
+		if (!memcmp(options, "font:", 5))
 			strcpy(fontname, options + 5);
 		
-		if (!strncmp(options, "scrollback:", 11)) {
+		if (!memcmp(options, "scrollback:", 11)) {
 			options += 11;
 			if (*options) {
 				fbcon_softback_size = simple_strtoul(options, &options, 0);
@@ -462,7 +462,7 @@ static int __init fb_console_setup(char *this_opt)
 				return 1;
 		}
 		
-		if (!strncmp(options, "map:", 4)) {
+		if (!memcmp(options, "map:", 4)) {
 			options += 4;
 			if (*options) {
 				for (i = 0, j = 0; i < MAX_NR_CONSOLES; i++) {
@@ -478,7 +478,7 @@ static int __init fb_console_setup(char *this_opt)
 			return 1;
 		}
 
-		if (!strncmp(options, "vc:", 3)) {
+		if (!memcmp(options, "vc:", 3)) {
 			options += 3;
 			if (*options)
 				first_fb_vc = simple_strtoul(options, &options, 10) - 1;
@@ -489,7 +489,7 @@ static int __init fb_console_setup(char *this_opt)
 			fbcon_is_default = 0; 
 		}	
 
-		if (!strncmp(options, "rotate:", 7)) {
+		if (!memcmp(options, "rotate:", 7)) {
 			options += 7;
 			if (*options)
 				initial_rotation = simple_strtoul(options, &options, 0);
diff --git a/drivers/video/controlfb.c b/drivers/video/controlfb.c
index c225dcc..c2794a4 100644
--- a/drivers/video/controlfb.c
+++ b/drivers/video/controlfb.c
@@ -560,12 +560,12 @@ static void __init control_setup(char *options)
 		return;
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
-		if (!strncmp(this_opt, "vmode:", 6)) {
+		if (!memcmp(this_opt, "vmode:", 6)) {
 			int vmode = simple_strtoul(this_opt+6, NULL, 0);
 			if (vmode > 0 && vmode <= VMODE_MAX &&
 			    control_mac_modes[vmode - 1].m[1] >= 0)
 				default_vmode = vmode;
-		} else if (!strncmp(this_opt, "cmode:", 6)) {
+		} else if (!memcmp(this_opt, "cmode:", 6)) {
 			int depth = simple_strtoul(this_opt+6, NULL, 0);
 			switch (depth) {
 			 case CMODE_8:
diff --git a/drivers/video/cyber2000fb.c b/drivers/video/cyber2000fb.c
index 0c1afd1..11bf395 100644
--- a/drivers/video/cyber2000fb.c
+++ b/drivers/video/cyber2000fb.c
@@ -1308,7 +1308,7 @@ static int cyber2000fb_setup(char *options)
 		if (!*opt)
 			continue;
 
-		if (strncmp(opt, "font:", 5) == 0) {
+		if (memcmp(opt, "font:", 5) == 0) {
 			static char default_font_storage[40];
 
 			strlcpy(default_font_storage, opt + 5,
diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 70477c2..e446616 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -280,13 +280,13 @@ static int __init efifb_setup(char *options)
 				screen_info.lfb_height = dmi_list[i].height;
 			}
 		}
-		if (!strncmp(this_opt, "base:", 5))
+		if (!memcmp(this_opt, "base:", 5))
 			screen_info.lfb_base = simple_strtoul(this_opt+5, NULL, 0);
-		else if (!strncmp(this_opt, "stride:", 7))
+		else if (!memcmp(this_opt, "stride:", 7))
 			screen_info.lfb_linelength = simple_strtoul(this_opt+7, NULL, 0) * 4;
-		else if (!strncmp(this_opt, "height:", 7))
+		else if (!memcmp(this_opt, "height:", 7))
 			screen_info.lfb_height = simple_strtoul(this_opt+7, NULL, 0);
-		else if (!strncmp(this_opt, "width:", 6))
+		else if (!memcmp(this_opt, "width:", 6))
 			screen_info.lfb_width = simple_strtoul(this_opt+6, NULL, 0);
 	}
 	return 0;
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 0e6aa3d..5d249b9 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1773,7 +1773,7 @@ int fb_get_options(char *name, char **option)
 	int retval = 0;
 	int name_len = strlen(name), i;
 
-	if (name_len && ofonly && strncmp(name, "offb", 4))
+	if (name_len && ofonly && memcmp(name, "offb", 4))
 		retval = 1;
 
 	if (name_len && !retval) {
@@ -1783,12 +1783,12 @@ int fb_get_options(char *name, char **option)
 			if (!video_options[i][0])
 				continue;
 			opt = video_options[i];
-			if (!strncmp(name, opt, name_len) &&
+			if (!memcmp(name, opt, name_len) &&
 			    opt[name_len] == ':')
 				options = opt + name_len + 1;
 		}
 	}
-	if (options && !strncmp(options, "off", 3))
+	if (options && !memcmp(options, "off", 3))
 		retval = 1;
 
 	if (option)
@@ -1818,7 +1818,7 @@ static int __init video_setup(char *options)
 	if (!options || !*options)
  		global = 1;
 
- 	if (!global && !strncmp(options, "ofonly", 6)) {
+ 	if (!global && !memcmp(options, "ofonly", 6)) {
  		ofonly = 1;
  		global = 1;
  	}
diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index 563a98b..c24dae2 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -159,7 +159,7 @@ static int check_edid(unsigned char *edid)
 	model = block[2] + (block[3] << 8);
 
 	for (i = 0; i < ARRAY_SIZE(brokendb); i++) {
-		if (!strncmp(manufacturer, brokendb[i].manufacturer, 4) &&
+		if (!memcmp(manufacturer, brokendb[i].manufacturer, 4) &&
 			brokendb[i].model == model) {
 			fix = brokendb[i].fix;
 			break;
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
index 0a08f13..a5c6e8a 100644
--- a/drivers/video/fbsysfs.c
+++ b/drivers/video/fbsysfs.c
@@ -140,7 +140,7 @@ static ssize_t store_mode(struct device *device, struct device_attribute *attr,
 		modelist = list_entry(pos, struct fb_modelist, list);
 		mode = &modelist->mode;
 		i = mode_string(mstr, 0, mode);
-		if (strncmp(mstr, buf, max(count, i)) == 0) {
+		if (memcmp(mstr, buf, max(count, i)) == 0) {
 
 			var = fb_info->var;
 			fb_videomode_to_var(&var, mode);
diff --git a/drivers/video/fm2fb.c b/drivers/video/fm2fb.c
index 1b0feb8..2bdb992 100644
--- a/drivers/video/fm2fb.c
+++ b/drivers/video/fm2fb.c
@@ -303,9 +303,9 @@ int __init fm2fb_setup(char *options)
 		return 0;
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
-		if (!strncmp(this_opt, "pal", 3))
+		if (!memcmp(this_opt, "pal", 3))
 			fm2fb_mode = FM2FB_MODE_PAL;
-		else if (!strncmp(this_opt, "ntsc", 4))
+		else if (!memcmp(this_opt, "ntsc", 4))
 			fm2fb_mode = FM2FB_MODE_NTSC;
 	}
 	return 0;
diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
index 8bbbf08..b72cce9 100644
--- a/drivers/video/fsl-diu-fb.c
+++ b/drivers/video/fsl-diu-fb.c
@@ -1708,10 +1708,10 @@ static int __init fsl_diu_setup(char *options)
 	while ((opt = strsep(&options, ",")) != NULL) {
 		if (!*opt)
 			continue;
-		if (!strncmp(opt, "monitor=", 8)) {
+		if (!memcmp(opt, "monitor=", 8)) {
 			if (!strict_strtoul(opt + 8, 10, &val) && (val <= 2))
 				monitor_port = val;
-		} else if (!strncmp(opt, "bpp=", 4)) {
+		} else if (!memcmp(opt, "bpp=", 4)) {
 			if (!strict_strtoul(opt + 4, 10, &val))
 				default_bpp = val;
 		} else
diff --git a/drivers/video/gbefb.c b/drivers/video/gbefb.c
index 933899d..e516342 100644
--- a/drivers/video/gbefb.c
+++ b/drivers/video/gbefb.c
@@ -1106,18 +1106,18 @@ static int __devinit gbefb_setup(char *options)
 		return 0;
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
-		if (!strncmp(this_opt, "monitor:", 8)) {
-			if (!strncmp(this_opt + 8, "crt", 3)) {
+		if (!memcmp(this_opt, "monitor:", 8)) {
+			if (!memcmp(this_opt + 8, "crt", 3)) {
 				flat_panel_enabled = 0;
 				default_var = &default_var_CRT;
 				default_mode = &default_mode_CRT;
-			} else if (!strncmp(this_opt + 8, "1600sw", 6) ||
-				   !strncmp(this_opt + 8, "lcd", 3)) {
+			} else if (!memcmp(this_opt + 8, "1600sw", 6) ||
+				   !memcmp(this_opt + 8, "lcd", 3)) {
 				flat_panel_enabled = 1;
 				default_var = &default_var_LCD;
 				default_mode = &default_mode_LCD;
 			}
-		} else if (!strncmp(this_opt, "mem:", 4)) {
+		} else if (!memcmp(this_opt, "mem:", 4)) {
 			gbe_mem_size = memparse(this_opt + 4, &this_opt);
 			if (gbe_mem_size > CONFIG_FB_GBE_MEM * 1024 * 1024)
 				gbe_mem_size = CONFIG_FB_GBE_MEM * 1024 * 1024;
diff --git a/drivers/video/geode/gx1fb_core.c b/drivers/video/geode/gx1fb_core.c
index c6b554f..1e883a1 100644
--- a/drivers/video/geode/gx1fb_core.c
+++ b/drivers/video/geode/gx1fb_core.c
@@ -416,11 +416,11 @@ static void __init gx1fb_setup(char *options)
 		if (!*this_opt)
 			continue;
 
-		if (!strncmp(this_opt, "mode:", 5))
+		if (!memcmp(this_opt, "mode:", 5))
 			strlcpy(mode_option, this_opt + 5, sizeof(mode_option));
-		else if (!strncmp(this_opt, "crt:", 4))
+		else if (!memcmp(this_opt, "crt:", 4))
 			crt_option = !!simple_strtoul(this_opt + 4, NULL, 0);
-		else if (!strncmp(this_opt, "panel:", 6))
+		else if (!memcmp(this_opt, "panel:", 6))
 			strlcpy(panel_option, this_opt + 6, sizeof(panel_option));
 		else
 			strlcpy(mode_option, this_opt, sizeof(mode_option));
diff --git a/drivers/video/i810/i810_main.c b/drivers/video/i810/i810_main.c
index 5743ea2..9fcd012 100644
--- a/drivers/video/i810/i810_main.c
+++ b/drivers/video/i810/i810_main.c
@@ -1964,41 +1964,41 @@ static int __devinit i810fb_setup(char *options)
 		return 0;
 	
 	while ((this_opt = strsep(&options, ",")) != NULL) {
-		if (!strncmp(this_opt, "mtrr", 4))
+		if (!memcmp(this_opt, "mtrr", 4))
 			mtrr = 1;
-		else if (!strncmp(this_opt, "accel", 5))
+		else if (!memcmp(this_opt, "accel", 5))
 			accel = 1;
-		else if (!strncmp(this_opt, "extvga", 6))
+		else if (!memcmp(this_opt, "extvga", 6))
 			extvga = 1;
-		else if (!strncmp(this_opt, "sync", 4))
+		else if (!memcmp(this_opt, "sync", 4))
 			sync = 1;
-		else if (!strncmp(this_opt, "vram:", 5))
+		else if (!memcmp(this_opt, "vram:", 5))
 			vram = (simple_strtoul(this_opt+5, NULL, 0));
-		else if (!strncmp(this_opt, "voffset:", 8))
+		else if (!memcmp(this_opt, "voffset:", 8))
 			voffset = (simple_strtoul(this_opt+8, NULL, 0));
-		else if (!strncmp(this_opt, "xres:", 5))
+		else if (!memcmp(this_opt, "xres:", 5))
 			xres = simple_strtoul(this_opt+5, NULL, 0);
-		else if (!strncmp(this_opt, "yres:", 5))
+		else if (!memcmp(this_opt, "yres:", 5))
 			yres = simple_strtoul(this_opt+5, NULL, 0);
-		else if (!strncmp(this_opt, "vyres:", 6))
+		else if (!memcmp(this_opt, "vyres:", 6))
 			vyres = simple_strtoul(this_opt+6, NULL, 0);
-		else if (!strncmp(this_opt, "bpp:", 4))
+		else if (!memcmp(this_opt, "bpp:", 4))
 			bpp = simple_strtoul(this_opt+4, NULL, 0);
-		else if (!strncmp(this_opt, "hsync1:", 7)) {
+		else if (!memcmp(this_opt, "hsync1:", 7)) {
 			hsync1 = simple_strtoul(this_opt+7, &suffix, 0);
-			if (strncmp(suffix, "H", 1)) 
+			if (memcmp(suffix, "H", 1)) 
 				hsync1 *= 1000;
-		} else if (!strncmp(this_opt, "hsync2:", 7)) {
+		} else if (!memcmp(this_opt, "hsync2:", 7)) {
 			hsync2 = simple_strtoul(this_opt+7, &suffix, 0);
-			if (strncmp(suffix, "H", 1)) 
+			if (memcmp(suffix, "H", 1)) 
 				hsync2 *= 1000;
-		} else if (!strncmp(this_opt, "vsync1:", 7)) 
+		} else if (!memcmp(this_opt, "vsync1:", 7)) 
 			vsync1 = simple_strtoul(this_opt+7, NULL, 0);
-		else if (!strncmp(this_opt, "vsync2:", 7))
+		else if (!memcmp(this_opt, "vsync2:", 7))
 			vsync2 = simple_strtoul(this_opt+7, NULL, 0);
-		else if (!strncmp(this_opt, "dcolor", 6))
+		else if (!memcmp(this_opt, "dcolor", 6))
 			dcolor = 1;
-		else if (!strncmp(this_opt, "ddc3", 4))
+		else if (!memcmp(this_opt, "ddc3", 4))
 			ddc3 = 3;
 		else
 			mode_option = this_opt;
diff --git a/drivers/video/imsttfb.c b/drivers/video/imsttfb.c
index efb2c10..cfb5b99 100644
--- a/drivers/video/imsttfb.c
+++ b/drivers/video/imsttfb.c
@@ -1559,7 +1559,7 @@ imsttfb_setup(char *options)
 		return 0;
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
-		if (!strncmp(this_opt, "font:", 5)) {
+		if (!memcmp(this_opt, "font:", 5)) {
 			char *p;
 			int i;
 
@@ -1569,16 +1569,16 @@ imsttfb_setup(char *options)
 					break;
 			memcpy(fontname, this_opt + 5, i);
 			fontname[i] = 0;
-		} else if (!strncmp(this_opt, "inverse", 7)) {
+		} else if (!memcmp(this_opt, "inverse", 7)) {
 			inverse = 1;
 			fb_invert_cmaps();
 		}
 #if defined(CONFIG_PPC)
-		else if (!strncmp(this_opt, "vmode:", 6)) {
+		else if (!memcmp(this_opt, "vmode:", 6)) {
 			int vmode = simple_strtoul(this_opt+6, NULL, 0);
 			if (vmode > 0 && vmode <= VMODE_MAX)
 				init_vmode = vmode;
-		} else if (!strncmp(this_opt, "cmode:", 6)) {
+		} else if (!memcmp(this_opt, "cmode:", 6)) {
 			int cmode = simple_strtoul(this_opt+6, NULL, 0);
 			switch (cmode) {
 				case CMODE_8:
diff --git a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/intelfb/intelfbdrv.c
index 5ba3999..328df04 100644
--- a/drivers/video/intelfb/intelfbdrv.c
+++ b/drivers/video/intelfb/intelfbdrv.c
@@ -270,7 +270,7 @@ MODULE_PARM_DESC(mode,
 		 "Initial video mode \"<xres>x<yres>[-<depth>][@<refresh>]\"");
 
 #ifndef MODULE
-#define OPT_EQUAL(opt, name) (!strncmp(opt, name, strlen(name)))
+#define OPT_EQUAL(opt, name) (!memcmp(opt, name, strlen(name)))
 #define OPT_INTVAL(opt, name) simple_strtoul(opt + strlen(name) + 1, NULL, 0)
 #define OPT_STRVAL(opt, name) (opt + strlen(name))
 
diff --git a/drivers/video/macmodes.c b/drivers/video/macmodes.c
index af86c08..29591c4 100644
--- a/drivers/video/macmodes.c
+++ b/drivers/video/macmodes.c
@@ -401,7 +401,7 @@ int mac_find_mode(struct fb_var_screeninfo *var, struct fb_info *info,
     const struct fb_videomode *db = NULL;
     unsigned int dbsize = 0;
 
-    if (mode_option && !strncmp(mode_option, "mac", 3)) {
+    if (mode_option && !memcmp(mode_option, "mac", 3)) {
 	mode_option += 3;
 	db = mac_modedb;
 	dbsize = ARRAY_SIZE(mac_modedb);
diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index 052dd9f..576cc4b 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -2314,9 +2314,9 @@ static int __init matroxfb_setup(char *options) {
 
 		dprintk("matroxfb_setup: option %s\n", this_opt);
 
-		if (!strncmp(this_opt, "dev:", 4))
+		if (!memcmp(this_opt, "dev:", 4))
 			dev = simple_strtoul(this_opt+4, NULL, 0);
-		else if (!strncmp(this_opt, "depth:", 6)) {
+		else if (!memcmp(this_opt, "depth:", 6)) {
 			switch (simple_strtoul(this_opt+6, NULL, 0)) {
 				case 0: depth = RSText; break;
 				case 4: depth = RS4bpp; break;
@@ -2328,50 +2328,50 @@ static int __init matroxfb_setup(char *options) {
 				default:
 					printk(KERN_ERR "matroxfb: unsupported color depth\n");
 			}
-		} else if (!strncmp(this_opt, "xres:", 5))
+		} else if (!memcmp(this_opt, "xres:", 5))
 			xres = simple_strtoul(this_opt+5, NULL, 0);
-		else if (!strncmp(this_opt, "yres:", 5))
+		else if (!memcmp(this_opt, "yres:", 5))
 			yres = simple_strtoul(this_opt+5, NULL, 0);
-		else if (!strncmp(this_opt, "vslen:", 6))
+		else if (!memcmp(this_opt, "vslen:", 6))
 			vslen = simple_strtoul(this_opt+6, NULL, 0);
-		else if (!strncmp(this_opt, "hslen:", 6))
+		else if (!memcmp(this_opt, "hslen:", 6))
 			hslen = simple_strtoul(this_opt+6, NULL, 0);
-		else if (!strncmp(this_opt, "left:", 5))
+		else if (!memcmp(this_opt, "left:", 5))
 			left = simple_strtoul(this_opt+5, NULL, 0);
-		else if (!strncmp(this_opt, "right:", 6))
+		else if (!memcmp(this_opt, "right:", 6))
 			right = simple_strtoul(this_opt+6, NULL, 0);
-		else if (!strncmp(this_opt, "upper:", 6))
+		else if (!memcmp(this_opt, "upper:", 6))
 			upper = simple_strtoul(this_opt+6, NULL, 0);
-		else if (!strncmp(this_opt, "lower:", 6))
+		else if (!memcmp(this_opt, "lower:", 6))
 			lower = simple_strtoul(this_opt+6, NULL, 0);
-		else if (!strncmp(this_opt, "pixclock:", 9))
+		else if (!memcmp(this_opt, "pixclock:", 9))
 			pixclock = simple_strtoul(this_opt+9, NULL, 0);
-		else if (!strncmp(this_opt, "sync:", 5))
+		else if (!memcmp(this_opt, "sync:", 5))
 			sync = simple_strtoul(this_opt+5, NULL, 0);
-		else if (!strncmp(this_opt, "vesa:", 5))
+		else if (!memcmp(this_opt, "vesa:", 5))
 			vesa = simple_strtoul(this_opt+5, NULL, 0);
-		else if (!strncmp(this_opt, "maxclk:", 7))
+		else if (!memcmp(this_opt, "maxclk:", 7))
 			maxclk = simple_strtoul(this_opt+7, NULL, 0);
-		else if (!strncmp(this_opt, "fh:", 3))
+		else if (!memcmp(this_opt, "fh:", 3))
 			fh = simple_strtoul(this_opt+3, NULL, 0);
-		else if (!strncmp(this_opt, "fv:", 3))
+		else if (!memcmp(this_opt, "fv:", 3))
 			fv = simple_strtoul(this_opt+3, NULL, 0);
-		else if (!strncmp(this_opt, "mem:", 4))
+		else if (!memcmp(this_opt, "mem:", 4))
 			mem = simple_strtoul(this_opt+4, NULL, 0);
-		else if (!strncmp(this_opt, "mode:", 5))
+		else if (!memcmp(this_opt, "mode:", 5))
 			strlcpy(videomode, this_opt+5, sizeof(videomode));
-		else if (!strncmp(this_opt, "outputs:", 8))
+		else if (!memcmp(this_opt, "outputs:", 8))
 			strlcpy(outputs, this_opt+8, sizeof(outputs));
-		else if (!strncmp(this_opt, "dfp:", 4)) {
+		else if (!memcmp(this_opt, "dfp:", 4)) {
 			dfp_type = simple_strtoul(this_opt+4, NULL, 0);
 			dfp = 1;
 		}
 #ifdef CONFIG_PPC_PMAC
-		else if (!strncmp(this_opt, "vmode:", 6)) {
+		else if (!memcmp(this_opt, "vmode:", 6)) {
 			unsigned int vmode = simple_strtoul(this_opt+6, NULL, 0);
 			if (vmode > 0 && vmode <= VMODE_MAX)
 				default_vmode = vmode;
-		} else if (!strncmp(this_opt, "cmode:", 6)) {
+		} else if (!memcmp(this_opt, "cmode:", 6)) {
 			unsigned int cmode = simple_strtoul(this_opt+6, NULL, 0);
 			switch (cmode) {
 				case 0:
@@ -2397,12 +2397,12 @@ static int __init matroxfb_setup(char *options) {
 			sgram = 1;
 		else if (!strcmp(this_opt, "sdram"))
 			sgram = 0;
-		else if (!strncmp(this_opt, "memtype:", 8))
+		else if (!memcmp(this_opt, "memtype:", 8))
 			memtype = simple_strtoul(this_opt+8, NULL, 0);
 		else {
 			int value = 1;
 
-			if (!strncmp(this_opt, "no", 2)) {
+			if (!memcmp(this_opt, "no", 2)) {
 				value = 0;
 				this_opt += 2;
 			}
diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
index 0a4dbdc..0d22eb3 100644
--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -19,7 +19,7 @@
 #undef DEBUG
 
 #define name_matches(v, s, l) \
-    ((v).name && !strncmp((s), (v).name, (l)) && strlen((v).name) == (l))
+    ((v).name && !memcmp((s), (v).name, (l)) && strlen((v).name) == (l))
 #define res_matches(v, x, y) \
     ((v).xres == (x) && (v).yres == (y))
 
diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index ca0f6be..fff0515 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -1561,7 +1561,7 @@ static int __init mx3fb_setup(void)
 	while ((opt = strsep(&options, ",")) != NULL) {
 		if (!*opt)
 			continue;
-		if (!strncmp(opt, "bpp=", 4))
+		if (!memcmp(opt, "bpp=", 4))
 			default_bpp = simple_strtoul(opt + 4, NULL, 0);
 		else
 			fb_mode = opt;
diff --git a/drivers/video/neofb.c b/drivers/video/neofb.c
index 588527a..af9c6c6 100644
--- a/drivers/video/neofb.c
+++ b/drivers/video/neofb.c
@@ -2214,15 +2214,15 @@ static int __init neofb_setup(char *options)
 		if (!*this_opt)
 			continue;
 
-		if (!strncmp(this_opt, "internal", 8))
+		if (!memcmp(this_opt, "internal", 8))
 			internal = 1;
-		else if (!strncmp(this_opt, "external", 8))
+		else if (!memcmp(this_opt, "external", 8))
 			external = 1;
-		else if (!strncmp(this_opt, "nostretch", 9))
+		else if (!memcmp(this_opt, "nostretch", 9))
 			nostretch = 1;
-		else if (!strncmp(this_opt, "nopciburst", 10))
+		else if (!memcmp(this_opt, "nopciburst", 10))
 			nopciburst = 1;
-		else if (!strncmp(this_opt, "libretto", 8))
+		else if (!memcmp(this_opt, "libretto", 8))
 			libretto = 1;
 		else
 			mode_option = this_opt;
diff --git a/drivers/video/nvidia/nvidia.c b/drivers/video/nvidia/nvidia.c
index efe10ff..60068b1 100644
--- a/drivers/video/nvidia/nvidia.c
+++ b/drivers/video/nvidia/nvidia.c
@@ -1482,7 +1482,7 @@ static int __devinit nvidiafb_setup(char *options)
 		return 0;
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
-		if (!strncmp(this_opt, "forceCRTC", 9)) {
+		if (!memcmp(this_opt, "forceCRTC", 9)) {
 			char *p;
 
 			p = this_opt + 9;
@@ -1491,29 +1491,29 @@ static int __devinit nvidiafb_setup(char *options)
 			forceCRTC = *p - '0';
 			if (forceCRTC < 0 || forceCRTC > 1)
 				forceCRTC = -1;
-		} else if (!strncmp(this_opt, "flatpanel", 9)) {
+		} else if (!memcmp(this_opt, "flatpanel", 9)) {
 			flatpanel = 1;
-		} else if (!strncmp(this_opt, "hwcur", 5)) {
+		} else if (!memcmp(this_opt, "hwcur", 5)) {
 			hwcur = 1;
-		} else if (!strncmp(this_opt, "noaccel", 6)) {
+		} else if (!memcmp(this_opt, "noaccel", 6)) {
 			noaccel = 1;
-		} else if (!strncmp(this_opt, "noscale", 7)) {
+		} else if (!memcmp(this_opt, "noscale", 7)) {
 			noscale = 1;
-		} else if (!strncmp(this_opt, "reverse_i2c", 11)) {
+		} else if (!memcmp(this_opt, "reverse_i2c", 11)) {
 			reverse_i2c = 1;
-		} else if (!strncmp(this_opt, "paneltweak:", 11)) {
+		} else if (!memcmp(this_opt, "paneltweak:", 11)) {
 			paneltweak = simple_strtoul(this_opt+11, NULL, 0);
-		} else if (!strncmp(this_opt, "vram:", 5)) {
+		} else if (!memcmp(this_opt, "vram:", 5)) {
 			vram = simple_strtoul(this_opt+5, NULL, 0);
-		} else if (!strncmp(this_opt, "backlight:", 10)) {
+		} else if (!memcmp(this_opt, "backlight:", 10)) {
 			backlight = simple_strtoul(this_opt+10, NULL, 0);
 #ifdef CONFIG_MTRR
-		} else if (!strncmp(this_opt, "nomtrr", 6)) {
+		} else if (!memcmp(this_opt, "nomtrr", 6)) {
 			nomtrr = 1;
 #endif
-		} else if (!strncmp(this_opt, "fpdither:", 9)) {
+		} else if (!memcmp(this_opt, "fpdither:", 9)) {
 			fpdither = simple_strtol(this_opt+9, NULL, 0);
-		} else if (!strncmp(this_opt, "bpp:", 4)) {
+		} else if (!memcmp(this_opt, "bpp:", 4)) {
 			bpp = simple_strtoul(this_opt+4, NULL, 0);
 		} else
 			mode_option = this_opt;
diff --git a/drivers/video/offb.c b/drivers/video/offb.c
index cb163a5..3277ad8 100644
--- a/drivers/video/offb.c
+++ b/drivers/video/offb.c
@@ -328,24 +328,24 @@ static void offb_init_palette_hacks(struct fb_info *info, struct device_node *dp
 {
 	struct offb_par *par = (struct offb_par *) info->par;
 
-	if (dp && !strncmp(name, "ATY,Rage128", 11)) {
+	if (dp && !memcmp(name, "ATY,Rage128", 11)) {
 		par->cmap_adr = offb_map_reg(dp, 2, 0, 0x1fff);
 		if (par->cmap_adr)
 			par->cmap_type = cmap_r128;
-	} else if (dp && (!strncmp(name, "ATY,RageM3pA", 12)
-			  || !strncmp(name, "ATY,RageM3p12A", 14))) {
+	} else if (dp && (!memcmp(name, "ATY,RageM3pA", 12)
+			  || !memcmp(name, "ATY,RageM3p12A", 14))) {
 		par->cmap_adr = offb_map_reg(dp, 2, 0, 0x1fff);
 		if (par->cmap_adr)
 			par->cmap_type = cmap_M3A;
-	} else if (dp && !strncmp(name, "ATY,RageM3pB", 12)) {
+	} else if (dp && !memcmp(name, "ATY,RageM3pB", 12)) {
 		par->cmap_adr = offb_map_reg(dp, 2, 0, 0x1fff);
 		if (par->cmap_adr)
 			par->cmap_type = cmap_M3B;
-	} else if (dp && !strncmp(name, "ATY,Rage6", 9)) {
+	} else if (dp && !memcmp(name, "ATY,Rage6", 9)) {
 		par->cmap_adr = offb_map_reg(dp, 1, 0, 0x1fff);
 		if (par->cmap_adr)
 			par->cmap_type = cmap_radeon;
-	} else if (!strncmp(name, "ATY,", 4)) {
+	} else if (!memcmp(name, "ATY,", 4)) {
 		unsigned long base = address & 0xff000000UL;
 		par->cmap_adr =
 			ioremap(base + 0x7ff000, 0x1000) + 0xcc0;
@@ -356,7 +356,7 @@ static void offb_init_palette_hacks(struct fb_info *info, struct device_node *dp
 		par->cmap_adr = offb_map_reg(dp, 0, 0x6000, 0x1000);
 		if (par->cmap_adr)
 			par->cmap_type = cmap_gxt2000;
-	} else if (dp && !strncmp(name, "vga,Display-", 12)) {
+	} else if (dp && !memcmp(name, "vga,Display-", 12)) {
 		/* Look for AVIVO initialized by SLOF */
 		struct device_node *pciparent = of_get_parent(dp);
 		const u32 *vid, *did;
diff --git a/drivers/video/omap/omapfb_main.c b/drivers/video/omap/omapfb_main.c
index e264efd..44056ef 100644
--- a/drivers/video/omap/omapfb_main.c
+++ b/drivers/video/omap/omapfb_main.c
@@ -1918,9 +1918,9 @@ static int __init omapfb_setup(char *options)
 		return 0;
 
 	while (!r && (this_opt = strsep(&options, ",")) != NULL) {
-		if (!strncmp(this_opt, "accel", 5))
+		if (!memcmp(this_opt, "accel", 5))
 			def_accel = 1;
-		else if (!strncmp(this_opt, "vram:", 5)) {
+		else if (!memcmp(this_opt, "vram:", 5)) {
 			char *suffix;
 			unsigned long vram;
 			vram = (simple_strtoul(this_opt + 5, &suffix, 0));
@@ -1942,15 +1942,15 @@ static int __init omapfb_setup(char *options)
 			}
 			def_vram[def_vram_cnt++] = vram;
 		}
-		else if (!strncmp(this_opt, "vxres:", 6))
+		else if (!memcmp(this_opt, "vxres:", 6))
 			def_vxres = simple_strtoul(this_opt + 6, NULL, 0);
-		else if (!strncmp(this_opt, "vyres:", 6))
+		else if (!memcmp(this_opt, "vyres:", 6))
 			def_vyres = simple_strtoul(this_opt + 6, NULL, 0);
-		else if (!strncmp(this_opt, "rotate:", 7))
+		else if (!memcmp(this_opt, "rotate:", 7))
 			def_rotate = (simple_strtoul(this_opt + 7, NULL, 0));
-		else if (!strncmp(this_opt, "mirror:", 7))
+		else if (!memcmp(this_opt, "mirror:", 7))
 			def_mirror = (simple_strtoul(this_opt + 7, NULL, 0));
-		else if (!strncmp(this_opt, "manual_update", 13))
+		else if (!memcmp(this_opt, "manual_update", 13))
 			manual_update = 1;
 		else {
 			pr_debug("omapfb: invalid option\n");
diff --git a/drivers/video/omap2/displays/panel-acx565akm.c b/drivers/video/omap2/displays/panel-acx565akm.c
index e773106..daa0cbd 100644
--- a/drivers/video/omap2/displays/panel-acx565akm.c
+++ b/drivers/video/omap2/displays/panel-acx565akm.c
@@ -417,7 +417,7 @@ static ssize_t store_cabc_mode(struct device *dev,
 		if (count != cmp_len)
 			continue;
 
-		if (strncmp(buf, mode_str, cmp_len) == 0)
+		if (memcmp(buf, mode_str, cmp_len) == 0)
 			break;
 	}
 
diff --git a/drivers/video/omap2/dss/display.c b/drivers/video/omap2/dss/display.c
index 22dd7a4..c3d7da4 100644
--- a/drivers/video/omap2/dss/display.c
+++ b/drivers/video/omap2/dss/display.c
@@ -161,10 +161,10 @@ static ssize_t display_timings_store(struct device *dev,
 
 	found = 0;
 #ifdef CONFIG_OMAP2_DSS_VENC
-	if (strncmp("pal", buf, 3) == 0) {
+	if (memcmp("pal", buf, 3) == 0) {
 		t = omap_dss_pal_timings;
 		found = 1;
-	} else if (strncmp("ntsc", buf, 4) == 0) {
+	} else if (memcmp("ntsc", buf, 4) == 0) {
 		t = omap_dss_ntsc_timings;
 		found = 1;
 	}
diff --git a/drivers/video/platinumfb.c b/drivers/video/platinumfb.c
index a50e197..1e57480 100644
--- a/drivers/video/platinumfb.c
+++ b/drivers/video/platinumfb.c
@@ -500,11 +500,11 @@ static int __init platinumfb_setup(char *options)
 		return 0;
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
-		if (!strncmp(this_opt, "vmode:", 6)) {
+		if (!memcmp(this_opt, "vmode:", 6)) {
 	    		int vmode = simple_strtoul(this_opt+6, NULL, 0);
 			if (vmode > 0 && vmode <= VMODE_MAX)
 				default_vmode = vmode;
-		} else if (!strncmp(this_opt, "cmode:", 6)) {
+		} else if (!memcmp(this_opt, "cmode:", 6)) {
 			int depth = simple_strtoul(this_opt+6, NULL, 0);
 			switch (depth) {
 			 case 0:
diff --git a/drivers/video/pm2fb.c b/drivers/video/pm2fb.c
index 27f93aa..d41e63d 100644
--- a/drivers/video/pm2fb.c
+++ b/drivers/video/pm2fb.c
@@ -1791,13 +1791,13 @@ static int __init pm2fb_setup(char *options)
 			lowhsync = 1;
 		else if (!strcmp(this_opt, "lowvsync"))
 			lowvsync = 1;
-		else if (!strncmp(this_opt, "hwcursor=", 9))
+		else if (!memcmp(this_opt, "hwcursor=", 9))
 			hwcursor = simple_strtoul(this_opt + 9, NULL, 0);
 #ifdef CONFIG_MTRR
-		else if (!strncmp(this_opt, "nomtrr", 6))
+		else if (!memcmp(this_opt, "nomtrr", 6))
 			nomtrr = 1;
 #endif
-		else if (!strncmp(this_opt, "noaccel", 7))
+		else if (!memcmp(this_opt, "noaccel", 7))
 			noaccel = 1;
 		else
 			mode_option = this_opt;
diff --git a/drivers/video/pm3fb.c b/drivers/video/pm3fb.c
index 6666f45..350b1e0 100644
--- a/drivers/video/pm3fb.c
+++ b/drivers/video/pm3fb.c
@@ -1532,12 +1532,12 @@ static int __init pm3fb_setup(char *options)
 	while ((this_opt = strsep(&options, ",")) != NULL) {
 		if (!*this_opt)
 			continue;
-		else if (!strncmp(this_opt, "noaccel", 7))
+		else if (!memcmp(this_opt, "noaccel", 7))
 			noaccel = 1;
-		else if (!strncmp(this_opt, "hwcursor=", 9))
+		else if (!memcmp(this_opt, "hwcursor=", 9))
 			hwcursor = simple_strtoul(this_opt + 9, NULL, 0);
 #ifdef CONFIG_MTRR
-		else if (!strncmp(this_opt, "nomtrr", 6))
+		else if (!memcmp(this_opt, "nomtrr", 6))
 			nomtrr = 1;
 #endif
 		else
diff --git a/drivers/video/ps3fb.c b/drivers/video/ps3fb.c
index 9c0144e..4710c14 100644
--- a/drivers/video/ps3fb.c
+++ b/drivers/video/ps3fb.c
@@ -1277,7 +1277,7 @@ static int __init ps3fb_setup(void)
 			break;
 		if (!*this_opt)
 			continue;
-		if (!strncmp(this_opt, "mode:", 5))
+		if (!memcmp(this_opt, "mode:", 5))
 			ps3fb_mode = simple_strtoul(this_opt + 5, NULL, 0);
 		else
 			mode_option = this_opt;
diff --git a/drivers/video/pvr2fb.c b/drivers/video/pvr2fb.c
index f997510..14cd883 100644
--- a/drivers/video/pvr2fb.c
+++ b/drivers/video/pvr2fb.c
@@ -1035,13 +1035,13 @@ static int __init pvr2fb_setup(char *options)
 			continue;
 		if (!strcmp(this_opt, "inverse")) {
 			fb_invert_cmaps();
-		} else if (!strncmp(this_opt, "cable:", 6)) {
+		} else if (!memcmp(this_opt, "cable:", 6)) {
 			strcpy(cable_arg, this_opt + 6);
-		} else if (!strncmp(this_opt, "output:", 7)) {
+		} else if (!memcmp(this_opt, "output:", 7)) {
 			strcpy(output_arg, this_opt + 7);
-		} else if (!strncmp(this_opt, "nopan", 5)) {
+		} else if (!memcmp(this_opt, "nopan", 5)) {
 			nopan = 1;
-		} else if (!strncmp(this_opt, "nowrap", 6)) {
+		} else if (!memcmp(this_opt, "nowrap", 6)) {
 			nowrap = 1;
 		} else {
 			mode_option = this_opt;
diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index 825b665..f7fc3db 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -1882,32 +1882,32 @@ static int __devinit parse_opt(struct device *dev, char *this_opt)
 
 	s[0] = '\0';
 
-	if (!strncmp(this_opt, "vmem:", 5)) {
+	if (!memcmp(this_opt, "vmem:", 5)) {
 		video_mem_size = memparse(this_opt + 5, NULL);
-	} else if (!strncmp(this_opt, "mode:", 5)) {
+	} else if (!memcmp(this_opt, "mode:", 5)) {
 		return parse_opt_mode(dev, this_opt);
-	} else if (!strncmp(this_opt, "pixclock:", 9)) {
+	} else if (!memcmp(this_opt, "pixclock:", 9)) {
 		mode->pixclock = simple_strtoul(this_opt+9, NULL, 0);
 		sprintf(s, "pixclock: %ld\n", mode->pixclock);
-	} else if (!strncmp(this_opt, "left:", 5)) {
+	} else if (!memcmp(this_opt, "left:", 5)) {
 		mode->left_margin = simple_strtoul(this_opt+5, NULL, 0);
 		sprintf(s, "left: %u\n", mode->left_margin);
-	} else if (!strncmp(this_opt, "right:", 6)) {
+	} else if (!memcmp(this_opt, "right:", 6)) {
 		mode->right_margin = simple_strtoul(this_opt+6, NULL, 0);
 		sprintf(s, "right: %u\n", mode->right_margin);
-	} else if (!strncmp(this_opt, "upper:", 6)) {
+	} else if (!memcmp(this_opt, "upper:", 6)) {
 		mode->upper_margin = simple_strtoul(this_opt+6, NULL, 0);
 		sprintf(s, "upper: %u\n", mode->upper_margin);
-	} else if (!strncmp(this_opt, "lower:", 6)) {
+	} else if (!memcmp(this_opt, "lower:", 6)) {
 		mode->lower_margin = simple_strtoul(this_opt+6, NULL, 0);
 		sprintf(s, "lower: %u\n", mode->lower_margin);
-	} else if (!strncmp(this_opt, "hsynclen:", 9)) {
+	} else if (!memcmp(this_opt, "hsynclen:", 9)) {
 		mode->hsync_len = simple_strtoul(this_opt+9, NULL, 0);
 		sprintf(s, "hsynclen: %u\n", mode->hsync_len);
-	} else if (!strncmp(this_opt, "vsynclen:", 9)) {
+	} else if (!memcmp(this_opt, "vsynclen:", 9)) {
 		mode->vsync_len = simple_strtoul(this_opt+9, NULL, 0);
 		sprintf(s, "vsynclen: %u\n", mode->vsync_len);
-	} else if (!strncmp(this_opt, "hsync:", 6)) {
+	} else if (!memcmp(this_opt, "hsync:", 6)) {
 		if (simple_strtoul(this_opt+6, NULL, 0) == 0) {
 			sprintf(s, "hsync: Active Low\n");
 			mode->sync &= ~FB_SYNC_HOR_HIGH_ACT;
@@ -1915,7 +1915,7 @@ static int __devinit parse_opt(struct device *dev, char *this_opt)
 			sprintf(s, "hsync: Active High\n");
 			mode->sync |= FB_SYNC_HOR_HIGH_ACT;
 		}
-	} else if (!strncmp(this_opt, "vsync:", 6)) {
+	} else if (!memcmp(this_opt, "vsync:", 6)) {
 		if (simple_strtoul(this_opt+6, NULL, 0) == 0) {
 			sprintf(s, "vsync: Active Low\n");
 			mode->sync &= ~FB_SYNC_VERT_HIGH_ACT;
@@ -1923,7 +1923,7 @@ static int __devinit parse_opt(struct device *dev, char *this_opt)
 			sprintf(s, "vsync: Active High\n");
 			mode->sync |= FB_SYNC_VERT_HIGH_ACT;
 		}
-	} else if (!strncmp(this_opt, "dpc:", 4)) {
+	} else if (!memcmp(this_opt, "dpc:", 4)) {
 		if (simple_strtoul(this_opt+4, NULL, 0) == 0) {
 			sprintf(s, "double pixel clock: false\n");
 			inf->lccr3 &= ~LCCR3_DPC;
@@ -1931,7 +1931,7 @@ static int __devinit parse_opt(struct device *dev, char *this_opt)
 			sprintf(s, "double pixel clock: true\n");
 			inf->lccr3 |= LCCR3_DPC;
 		}
-	} else if (!strncmp(this_opt, "outputen:", 9)) {
+	} else if (!memcmp(this_opt, "outputen:", 9)) {
 		if (simple_strtoul(this_opt+9, NULL, 0) == 0) {
 			sprintf(s, "output enable: active low\n");
 			inf->lccr3 = (inf->lccr3 & ~LCCR3_OEP) | LCCR3_OutEnL;
@@ -1939,7 +1939,7 @@ static int __devinit parse_opt(struct device *dev, char *this_opt)
 			sprintf(s, "output enable: active high\n");
 			inf->lccr3 = (inf->lccr3 & ~LCCR3_OEP) | LCCR3_OutEnH;
 		}
-	} else if (!strncmp(this_opt, "pixclockpol:", 12)) {
+	} else if (!memcmp(this_opt, "pixclockpol:", 12)) {
 		if (simple_strtoul(this_opt+12, NULL, 0) == 0) {
 			sprintf(s, "pixel clock polarity: falling edge\n");
 			inf->lccr3 = (inf->lccr3 & ~LCCR3_PCP) | LCCR3_PixFlEdg;
@@ -1947,21 +1947,21 @@ static int __devinit parse_opt(struct device *dev, char *this_opt)
 			sprintf(s, "pixel clock polarity: rising edge\n");
 			inf->lccr3 = (inf->lccr3 & ~LCCR3_PCP) | LCCR3_PixRsEdg;
 		}
-	} else if (!strncmp(this_opt, "color", 5)) {
+	} else if (!memcmp(this_opt, "color", 5)) {
 		inf->lccr0 = (inf->lccr0 & ~LCCR0_CMS) | LCCR0_Color;
-	} else if (!strncmp(this_opt, "mono", 4)) {
+	} else if (!memcmp(this_opt, "mono", 4)) {
 		inf->lccr0 = (inf->lccr0 & ~LCCR0_CMS) | LCCR0_Mono;
-	} else if (!strncmp(this_opt, "active", 6)) {
+	} else if (!memcmp(this_opt, "active", 6)) {
 		inf->lccr0 = (inf->lccr0 & ~LCCR0_PAS) | LCCR0_Act;
-	} else if (!strncmp(this_opt, "passive", 7)) {
+	} else if (!memcmp(this_opt, "passive", 7)) {
 		inf->lccr0 = (inf->lccr0 & ~LCCR0_PAS) | LCCR0_Pas;
-	} else if (!strncmp(this_opt, "single", 6)) {
+	} else if (!memcmp(this_opt, "single", 6)) {
 		inf->lccr0 = (inf->lccr0 & ~LCCR0_SDS) | LCCR0_Sngl;
-	} else if (!strncmp(this_opt, "dual", 4)) {
+	} else if (!memcmp(this_opt, "dual", 4)) {
 		inf->lccr0 = (inf->lccr0 & ~LCCR0_SDS) | LCCR0_Dual;
-	} else if (!strncmp(this_opt, "4pix", 4)) {
+	} else if (!memcmp(this_opt, "4pix", 4)) {
 		inf->lccr0 = (inf->lccr0 & ~LCCR0_DPD) | LCCR0_4PixMono;
-	} else if (!strncmp(this_opt, "8pix", 4)) {
+	} else if (!memcmp(this_opt, "8pix", 4)) {
 		inf->lccr0 = (inf->lccr0 & ~LCCR0_DPD) | LCCR0_8PixMono;
 	} else {
 		dev_err(dev, "unknown option: %s\n", this_opt);
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index 618f36b..6a68dd1 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -1762,7 +1762,7 @@ static int __devinit riva_get_EDID_OF(struct fb_info *info, struct pci_dev *pd)
 		disptype = of_get_property(dp, "display-type", NULL);
 		if (disptype == NULL)
 			continue;
-		if (strncmp(disptype, "LCD", 3) != 0)
+		if (memcmp(disptype, "LCD", 3) != 0)
 			continue;
 		for (i = 0; propnames[i] != NULL; ++i) {
 			pedid = of_get_property(dp, propnames[i], NULL);
@@ -2154,7 +2154,7 @@ static int __devinit rivafb_setup(char *options)
 		return 0;
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
-		if (!strncmp(this_opt, "forceCRTC", 9)) {
+		if (!memcmp(this_opt, "forceCRTC", 9)) {
 			char *p;
 			
 			p = this_opt + 9;
@@ -2162,17 +2162,17 @@ static int __devinit rivafb_setup(char *options)
 			forceCRTC = *p - '0';
 			if (forceCRTC < 0 || forceCRTC > 1) 
 				forceCRTC = -1;
-		} else if (!strncmp(this_opt, "flatpanel", 9)) {
+		} else if (!memcmp(this_opt, "flatpanel", 9)) {
 			flatpanel = 1;
-		} else if (!strncmp(this_opt, "backlight:", 10)) {
+		} else if (!memcmp(this_opt, "backlight:", 10)) {
 			backlight = simple_strtoul(this_opt+10, NULL, 0);
 #ifdef CONFIG_MTRR
-		} else if (!strncmp(this_opt, "nomtrr", 6)) {
+		} else if (!memcmp(this_opt, "nomtrr", 6)) {
 			nomtrr = 1;
 #endif
-		} else if (!strncmp(this_opt, "strictmode", 10)) {
+		} else if (!memcmp(this_opt, "strictmode", 10)) {
 			strictmode = 1;
-		} else if (!strncmp(this_opt, "noaccel", 7)) {
+		} else if (!memcmp(this_opt, "noaccel", 7)) {
 			noaccel = 1;
 		} else
 			mode_option = this_opt;
diff --git a/drivers/video/s3fb.c b/drivers/video/s3fb.c
index dce8c97..95dded1 100644
--- a/drivers/video/s3fb.c
+++ b/drivers/video/s3fb.c
@@ -1223,10 +1223,10 @@ static int  __init s3fb_setup(char *options)
 		if (!*opt)
 			continue;
 #ifdef CONFIG_MTRR
-		else if (!strncmp(opt, "mtrr:", 5))
+		else if (!memcmp(opt, "mtrr:", 5))
 			mtrr = simple_strtoul(opt + 5, NULL, 0);
 #endif
-		else if (!strncmp(opt, "fasttext:", 9))
+		else if (!memcmp(opt, "fasttext:", 9))
 			fasttext = simple_strtoul(opt + 9, NULL, 0);
 		else
 			mode_option = opt;
diff --git a/drivers/video/sa1100fb.c b/drivers/video/sa1100fb.c
index e8b76d6..5a6a754 100644
--- a/drivers/video/sa1100fb.c
+++ b/drivers/video/sa1100fb.c
@@ -1527,20 +1527,20 @@ int __init sa1100fb_setup(char *options)
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
 
-		if (!strncmp(this_opt, "bpp:", 4))
+		if (!memcmp(this_opt, "bpp:", 4))
 			current_par.max_bpp =
 			    simple_strtoul(this_opt + 4, NULL, 0);
 
-		if (!strncmp(this_opt, "lccr0:", 6))
+		if (!memcmp(this_opt, "lccr0:", 6))
 			lcd_shadow.lccr0 =
 			    simple_strtoul(this_opt + 6, NULL, 0);
-		if (!strncmp(this_opt, "lccr1:", 6)) {
+		if (!memcmp(this_opt, "lccr1:", 6)) {
 			lcd_shadow.lccr1 =
 			    simple_strtoul(this_opt + 6, NULL, 0);
 			current_par.max_xres =
 			    (lcd_shadow.lccr1 & 0x3ff) + 16;
 		}
-		if (!strncmp(this_opt, "lccr2:", 6)) {
+		if (!memcmp(this_opt, "lccr2:", 6)) {
 			lcd_shadow.lccr2 =
 			    simple_strtoul(this_opt + 6, NULL, 0);
 			current_par.max_yres =
@@ -1550,7 +1550,7 @@ int __init sa1100fb_setup(char *options)
 						   1) *
 			    2 : ((lcd_shadow.lccr2 & 0x3ff) + 1);
 		}
-		if (!strncmp(this_opt, "lccr3:", 6))
+		if (!memcmp(this_opt, "lccr3:", 6))
 			lcd_shadow.lccr3 =
 			    simple_strtoul(this_opt + 6, NULL, 0);
 	}
diff --git a/drivers/video/sgivwfb.c b/drivers/video/sgivwfb.c
index 53455f2..463ca75 100644
--- a/drivers/video/sgivwfb.c
+++ b/drivers/video/sgivwfb.c
@@ -732,10 +732,10 @@ int __init sgivwfb_setup(char *options)
 		return 0;
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
-		if (!strncmp(this_opt, "monitor:", 8)) {
-			if (!strncmp(this_opt + 8, "crt", 3))
+		if (!memcmp(this_opt, "monitor:", 8)) {
+			if (!memcmp(this_opt + 8, "crt", 3))
 				flatpanel_id = -1;
-			else if (!strncmp(this_opt + 8, "1600sw", 6))
+			else if (!memcmp(this_opt + 8, "1600sw", 6))
 				flatpanel_id = FLATPANEL_SGI_1600SW;
 		}
 	}
diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 7e3370f..31c1334 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -366,11 +366,11 @@ sisfb_detect_custom_timing(struct sis_video_info *ivideo)
 		if( (mycustomttable[i].chipID == ivideo->chip)			&&
 		    ((!strlen(mycustomttable[i].biosversion)) ||
 		     (ivideo->SiS_Pr.UseROM &&
-		      (!strncmp(mycustomttable[i].biosversion, biosver,
+		      (!memcmp(mycustomttable[i].biosversion, biosver,
 				strlen(mycustomttable[i].biosversion)))))	&&
 		    ((!strlen(mycustomttable[i].biosdate)) ||
 		     (ivideo->SiS_Pr.UseROM &&
-		      (!strncmp(mycustomttable[i].biosdate, biosdate,
+		      (!memcmp(mycustomttable[i].biosdate, biosdate,
 				strlen(mycustomttable[i].biosdate)))))		&&
 		    ((!mycustomttable[i].bioschksum) ||
 		     (ivideo->SiS_Pr.UseROM &&
diff --git a/drivers/video/sstfb.c b/drivers/video/sstfb.c
index dee64c3..a50703d 100644
--- a/drivers/video/sstfb.c
+++ b/drivers/video/sstfb.c
@@ -1295,9 +1295,9 @@ static int  __devinit sstfb_setup(char *options)
 		        slowpci = 0;
 		else if (!strcmp(this_opt, "slowpci"))
 		        slowpci = 1;
-		else if (!strncmp(this_opt, "mem:",4))
+		else if (!memcmp(this_opt, "mem:",4))
 			mem = simple_strtoul (this_opt+4, NULL, 0);
-		else if (!strncmp(this_opt, "gfxclk:",7))
+		else if (!memcmp(this_opt, "gfxclk:",7))
 			gfxclk = simple_strtoul (this_opt+7, NULL, 0);
 		else
 			mode_option = this_opt;
diff --git a/drivers/video/stifb.c b/drivers/video/stifb.c
index 876648e..77e6d5c 100644
--- a/drivers/video/stifb.c
+++ b/drivers/video/stifb.c
@@ -1393,12 +1393,12 @@ stifb_setup(char *options)
 	if (!options || !*options)
 		return 1;
 	
-	if (strncmp(options, "off", 3) == 0) {
+	if (memcmp(options, "off", 3) == 0) {
 		stifb_disabled = 1;
 		options += 3;
 	}
 
-	if (strncmp(options, "bpp", 3) == 0) {
+	if (memcmp(options, "bpp", 3) == 0) {
 		options += 3;
 		for (i = 0; i < MAX_STI_ROMS; i++) {
 			if (*options++ != ':')
diff --git a/drivers/video/tdfxfb.c b/drivers/video/tdfxfb.c
index 3ee5e63..4262889 100644
--- a/drivers/video/tdfxfb.c
+++ b/drivers/video/tdfxfb.c
@@ -1604,10 +1604,10 @@ static void __init tdfxfb_setup(char *options)
 			nopan = 1;
 		} else if (!strcmp(this_opt, "nowrap")) {
 			nowrap = 1;
-		} else if (!strncmp(this_opt, "hwcursor=", 9)) {
+		} else if (!memcmp(this_opt, "hwcursor=", 9)) {
 			hwcursor = simple_strtoul(this_opt + 9, NULL, 0);
 #ifdef CONFIG_MTRR
-		} else if (!strncmp(this_opt, "nomtrr", 6)) {
+		} else if (!memcmp(this_opt, "nomtrr", 6)) {
 			nomtrr = 1;
 #endif
 		} else {
diff --git a/drivers/video/tgafb.c b/drivers/video/tgafb.c
index aba7686..863ad3c 100644
--- a/drivers/video/tgafb.c
+++ b/drivers/video/tgafb.c
@@ -1738,7 +1738,7 @@ tgafb_setup(char *arg)
 		while ((this_opt = strsep(&arg, ","))) {
 			if (!*this_opt)
 				continue;
-			if (!strncmp(this_opt, "mode:", 5))
+			if (!memcmp(this_opt, "mode:", 5))
 				mode_option = this_opt+5;
 			else
 				printk(KERN_ERR
diff --git a/drivers/video/tridentfb.c b/drivers/video/tridentfb.c
index c6c7756..998defb 100644
--- a/drivers/video/tridentfb.c
+++ b/drivers/video/tridentfb.c
@@ -1608,23 +1608,23 @@ static int __init tridentfb_setup(char *options)
 	while ((opt = strsep(&options, ",")) != NULL) {
 		if (!*opt)
 			continue;
-		if (!strncmp(opt, "noaccel", 7))
+		if (!memcmp(opt, "noaccel", 7))
 			noaccel = 1;
-		else if (!strncmp(opt, "fp", 2))
+		else if (!memcmp(opt, "fp", 2))
 			fp = 1;
-		else if (!strncmp(opt, "crt", 3))
+		else if (!memcmp(opt, "crt", 3))
 			fp = 0;
-		else if (!strncmp(opt, "bpp=", 4))
+		else if (!memcmp(opt, "bpp=", 4))
 			bpp = simple_strtoul(opt + 4, NULL, 0);
-		else if (!strncmp(opt, "center", 6))
+		else if (!memcmp(opt, "center", 6))
 			center = 1;
-		else if (!strncmp(opt, "stretch", 7))
+		else if (!memcmp(opt, "stretch", 7))
 			stretch = 1;
-		else if (!strncmp(opt, "memsize=", 8))
+		else if (!memcmp(opt, "memsize=", 8))
 			memsize = simple_strtoul(opt + 8, NULL, 0);
-		else if (!strncmp(opt, "memdiff=", 8))
+		else if (!memcmp(opt, "memdiff=", 8))
 			memdiff = simple_strtoul(opt + 8, NULL, 0);
-		else if (!strncmp(opt, "nativex=", 8))
+		else if (!memcmp(opt, "nativex=", 8))
 			nativex = simple_strtoul(opt + 8, NULL, 0);
 		else
 			mode_option = opt;
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 52ec095..c62ee86 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -1864,7 +1864,7 @@ static int __devinit uvesafb_setup(char *options)
 			pmi_setpal = 0;
 		else if (!strcmp(this_opt, "pmipal"))
 			pmi_setpal = 1;
-		else if (!strncmp(this_opt, "mtrr:", 5))
+		else if (!memcmp(this_opt, "mtrr:", 5))
 			mtrr = simple_strtoul(this_opt+5, NULL, 0);
 		else if (!strcmp(this_opt, "nomtrr"))
 			mtrr = 0;
@@ -1874,17 +1874,17 @@ static int __devinit uvesafb_setup(char *options)
 			noedid = 1;
 		else if (!strcmp(this_opt, "noblank"))
 			blank = 0;
-		else if (!strncmp(this_opt, "vtotal:", 7))
+		else if (!memcmp(this_opt, "vtotal:", 7))
 			vram_total = simple_strtoul(this_opt + 7, NULL, 0);
-		else if (!strncmp(this_opt, "vremap:", 7))
+		else if (!memcmp(this_opt, "vremap:", 7))
 			vram_remap = simple_strtoul(this_opt + 7, NULL, 0);
-		else if (!strncmp(this_opt, "maxhf:", 6))
+		else if (!memcmp(this_opt, "maxhf:", 6))
 			maxhf = simple_strtoul(this_opt + 6, NULL, 0);
-		else if (!strncmp(this_opt, "maxvf:", 6))
+		else if (!memcmp(this_opt, "maxvf:", 6))
 			maxvf = simple_strtoul(this_opt + 6, NULL, 0);
-		else if (!strncmp(this_opt, "maxclk:", 7))
+		else if (!memcmp(this_opt, "maxclk:", 7))
 			maxclk = simple_strtoul(this_opt + 7, NULL, 0);
-		else if (!strncmp(this_opt, "vbemode:", 8))
+		else if (!memcmp(this_opt, "vbemode:", 8))
 			vbemode = simple_strtoul(this_opt + 8, NULL, 0);
 		else if (this_opt[0] >= '0' && this_opt[0] <= '9') {
 			mode_option = this_opt;
diff --git a/drivers/video/valkyriefb.c b/drivers/video/valkyriefb.c
index 6b52bf6..71f00e4 100644
--- a/drivers/video/valkyriefb.c
+++ b/drivers/video/valkyriefb.c
@@ -565,12 +565,12 @@ int __init valkyriefb_setup(char *options)
 		return 0;
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
-		if (!strncmp(this_opt, "vmode:", 6)) {
+		if (!memcmp(this_opt, "vmode:", 6)) {
 	    		int vmode = simple_strtoul(this_opt+6, NULL, 0);
 			if (vmode > 0 && vmode <= VMODE_MAX)
 				default_vmode = vmode;
 		}
-		else if (!strncmp(this_opt, "cmode:", 6)) {
+		else if (!memcmp(this_opt, "cmode:", 6)) {
 			int depth = simple_strtoul(this_opt+6, NULL, 0);
 			switch (depth) {
 			case 8:
diff --git a/drivers/video/vesafb.c b/drivers/video/vesafb.c
index 6a069d0..0f1a478 100644
--- a/drivers/video/vesafb.c
+++ b/drivers/video/vesafb.c
@@ -213,13 +213,13 @@ static int __init vesafb_setup(char *options)
 			pmi_setpal=0;
 		else if (! strcmp(this_opt, "pmipal"))
 			pmi_setpal=1;
-		else if (! strncmp(this_opt, "mtrr:", 5))
+		else if (! memcmp(this_opt, "mtrr:", 5))
 			mtrr = simple_strtoul(this_opt+5, NULL, 0);
 		else if (! strcmp(this_opt, "nomtrr"))
 			mtrr=0;
-		else if (! strncmp(this_opt, "vtotal:", 7))
+		else if (! memcmp(this_opt, "vtotal:", 7))
 			vram_total = simple_strtoul(this_opt+7, NULL, 0);
-		else if (! strncmp(this_opt, "vremap:", 7))
+		else if (! memcmp(this_opt, "vremap:", 7))
 			vram_remap = simple_strtoul(this_opt+7, NULL, 0);
 	}
 	return 0;
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 36d73f9..9e82f9b 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1180,7 +1180,7 @@ u32 via_parse_odev(char *input, char **end)
 		next = false;
 		for (i = 0; i < ARRAY_SIZE(device_mapping); i++) {
 			len = strlen(device_mapping[i].name);
-			if (!strncmp(ptr, device_mapping[i].name, len)) {
+			if (!memcmp(ptr, device_mapping[i].name, len)) {
 				odev |= device_mapping[i].device;
 				ptr += len;
 				if (*ptr == ',') {
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index d298cfc..9c790dc 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1060,15 +1060,15 @@ static int __init parse_active_dev(void)
 
 static int __devinit parse_port(char *opt_str, int *output_interface)
 {
-	if (!strncmp(opt_str, "DVP0", 4))
+	if (!memcmp(opt_str, "DVP0", 4))
 		*output_interface = INTERFACE_DVP0;
-	else if (!strncmp(opt_str, "DVP1", 4))
+	else if (!memcmp(opt_str, "DVP1", 4))
 		*output_interface = INTERFACE_DVP1;
-	else if (!strncmp(opt_str, "DFP_HIGHLOW", 11))
+	else if (!memcmp(opt_str, "DFP_HIGHLOW", 11))
 		*output_interface = INTERFACE_DFP;
-	else if (!strncmp(opt_str, "DFP_HIGH", 8))
+	else if (!memcmp(opt_str, "DFP_HIGH", 8))
 		*output_interface = INTERFACE_DFP_HIGH;
-	else if (!strncmp(opt_str, "DFP_LOW", 7))
+	else if (!memcmp(opt_str, "DFP_LOW", 7))
 		*output_interface = INTERFACE_DFP_LOW;
 	else
 		*output_interface = INTERFACE_NONE;
@@ -1943,60 +1943,60 @@ static int __init viafb_setup(char *options)
 		if (!*this_opt)
 			continue;
 
-		if (!strncmp(this_opt, "viafb_mode1=", 12))
+		if (!memcmp(this_opt, "viafb_mode1=", 12))
 			viafb_mode1 = kstrdup(this_opt + 12, GFP_KERNEL);
-		else if (!strncmp(this_opt, "viafb_mode=", 11))
+		else if (!memcmp(this_opt, "viafb_mode=", 11))
 			viafb_mode = kstrdup(this_opt + 11, GFP_KERNEL);
-		else if (!strncmp(this_opt, "viafb_bpp1=", 11))
+		else if (!memcmp(this_opt, "viafb_bpp1=", 11))
 			strict_strtoul(this_opt + 11, 0,
 				(unsigned long *)&viafb_bpp1);
-		else if (!strncmp(this_opt, "viafb_bpp=", 10))
+		else if (!memcmp(this_opt, "viafb_bpp=", 10))
 			strict_strtoul(this_opt + 10, 0,
 				(unsigned long *)&viafb_bpp);
-		else if (!strncmp(this_opt, "viafb_refresh1=", 15))
+		else if (!memcmp(this_opt, "viafb_refresh1=", 15))
 			strict_strtoul(this_opt + 15, 0,
 				(unsigned long *)&viafb_refresh1);
-		else if (!strncmp(this_opt, "viafb_refresh=", 14))
+		else if (!memcmp(this_opt, "viafb_refresh=", 14))
 			strict_strtoul(this_opt + 14, 0,
 				(unsigned long *)&viafb_refresh);
-		else if (!strncmp(this_opt, "viafb_lcd_dsp_method=", 21))
+		else if (!memcmp(this_opt, "viafb_lcd_dsp_method=", 21))
 			strict_strtoul(this_opt + 21, 0,
 				(unsigned long *)&viafb_lcd_dsp_method);
-		else if (!strncmp(this_opt, "viafb_lcd_panel_id=", 19))
+		else if (!memcmp(this_opt, "viafb_lcd_panel_id=", 19))
 			strict_strtoul(this_opt + 19, 0,
 				(unsigned long *)&viafb_lcd_panel_id);
-		else if (!strncmp(this_opt, "viafb_accel=", 12))
+		else if (!memcmp(this_opt, "viafb_accel=", 12))
 			strict_strtoul(this_opt + 12, 0,
 				(unsigned long *)&viafb_accel);
-		else if (!strncmp(this_opt, "viafb_SAMM_ON=", 14))
+		else if (!memcmp(this_opt, "viafb_SAMM_ON=", 14))
 			strict_strtoul(this_opt + 14, 0,
 				(unsigned long *)&viafb_SAMM_ON);
-		else if (!strncmp(this_opt, "viafb_active_dev=", 17))
+		else if (!memcmp(this_opt, "viafb_active_dev=", 17))
 			viafb_active_dev = kstrdup(this_opt + 17, GFP_KERNEL);
-		else if (!strncmp(this_opt,
+		else if (!memcmp(this_opt,
 			"viafb_display_hardware_layout=", 30))
 			strict_strtoul(this_opt + 30, 0,
 			(unsigned long *)&viafb_display_hardware_layout);
-		else if (!strncmp(this_opt, "viafb_second_size=", 18))
+		else if (!memcmp(this_opt, "viafb_second_size=", 18))
 			strict_strtoul(this_opt + 18, 0,
 				(unsigned long *)&viafb_second_size);
-		else if (!strncmp(this_opt,
+		else if (!memcmp(this_opt,
 			"viafb_platform_epia_dvi=", 24))
 			strict_strtoul(this_opt + 24, 0,
 				(unsigned long *)&viafb_platform_epia_dvi);
-		else if (!strncmp(this_opt,
+		else if (!memcmp(this_opt,
 			"viafb_device_lcd_dualedge=", 26))
 			strict_strtoul(this_opt + 26, 0,
 				(unsigned long *)&viafb_device_lcd_dualedge);
-		else if (!strncmp(this_opt, "viafb_bus_width=", 16))
+		else if (!memcmp(this_opt, "viafb_bus_width=", 16))
 			strict_strtoul(this_opt + 16, 0,
 				(unsigned long *)&viafb_bus_width);
-		else if (!strncmp(this_opt, "viafb_lcd_mode=", 15))
+		else if (!memcmp(this_opt, "viafb_lcd_mode=", 15))
 			strict_strtoul(this_opt + 15, 0,
 				(unsigned long *)&viafb_lcd_mode);
-		else if (!strncmp(this_opt, "viafb_lcd_port=", 15))
+		else if (!memcmp(this_opt, "viafb_lcd_port=", 15))
 			viafb_lcd_port = kstrdup(this_opt + 15, GFP_KERNEL);
-		else if (!strncmp(this_opt, "viafb_dvi_port=", 15))
+		else if (!memcmp(this_opt, "viafb_dvi_port=", 15))
 			viafb_dvi_port = kstrdup(this_opt + 15, GFP_KERNEL);
 	}
 	return 0;
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index deb9c4b..a7b79c0 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -216,7 +216,7 @@ static void otherend_changed(struct xenbus_watch *watch,
 	/* Protect us against watches firing on old details when the otherend
 	   details change, say immediately after a resume. */
 	if (!dev->otherend ||
-	    strncmp(dev->otherend, vec[XS_WATCH_PATH],
+	    memcmp(dev->otherend, vec[XS_WATCH_PATH],
 		    strlen(dev->otherend))) {
 		dev_dbg(&dev->dev, "Ignoring watch at %s\n",
 			vec[XS_WATCH_PATH]);
@@ -425,7 +425,7 @@ static int cleanup_dev(struct device *dev, void *data)
 	DPRINTK("%s", info->nodename);
 
 	/* Match the info->nodename path, or any subdirectory of that path. */
-	if (strncmp(xendev->nodename, info->nodename, len))
+	if (memcmp(xendev->nodename, info->nodename, len))
 		return 0;
 
 	/* If the node name is longer, ensure it really is a subdirectory. */
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 34bf71b..0e80d5e 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1383,7 +1383,7 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 			strncpy(ext, stat->extension, sizeof(ext));
 			/* HARDLINKCOUNT %u */
 			sscanf(ext, "%13s %u", tag_name, &i_nlink);
-			if (!strncmp(tag_name, "HARDLINKCOUNT", 13))
+			if (!memcmp(tag_name, "HARDLINKCOUNT", 13))
 				inode->i_nlink = i_nlink;
 		}
 	}
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index 914d1c0..5dace65 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -132,7 +132,7 @@ affs_intl_compare_dentry(struct dentry *dentry, struct qstr *a, struct qstr *b)
 }
 
 /*
- * NOTE! unlike strncmp, affs_match returns 1 for success, 0 for failure.
+ * NOTE! unlike memcmp, affs_match returns 1 for success, 0 for failure.
  */
 
 static inline int
diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index 0d5eead..779908d 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -278,7 +278,7 @@ struct afs_cell *afs_cell_lookup(const char *name, unsigned namesz,
 	if (name) {
 		/* if the cell was named, look for it in the cell record list */
 		list_for_each_entry(cell, &afs_cells, link) {
-			if (strncmp(cell->name, name, namesz) == 0) {
+			if (memcmp(cell->name, name, namesz) == 0) {
 				afs_get_cell(cell);
 				goto found;
 			}
diff --git a/fs/befs/btree.c b/fs/befs/btree.c
index 4202db7..098a2e0 100644
--- a/fs/befs/btree.c
+++ b/fs/befs/btree.c
@@ -716,7 +716,7 @@ befs_compare_strings(const void *key1, int keylen1,
 		     const void *key2, int keylen2)
 {
 	int len = min_t(int, keylen1, keylen2);
-	int result = strncmp(key1, key2, len);
+	int result = memcmp(key1, key2, len);
 	if (result == 0)
 		result = keylen1 - keylen2;
 	return result;
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 811384b..1b40b6e 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -453,7 +453,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 	flags     = ntohl(hdr->flags);
 	rev       = ntohl(hdr->rev);
 
-	if (strncmp(hdr->magic, "bFLT", 4)) {
+	if (memcmp(hdr->magic, "bFLT", 4)) {
 		/*
 		 * Previously, here was a printk to tell people
 		 *   "BINFMT_FLAT: bad header magic".
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fb827d0..d8a6249 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1814,7 +1814,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	sb->s_blocksize = sectorsize;
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
 
-	if (strncmp((char *)(&disk_super->magic), BTRFS_MAGIC,
+	if (memcmp((char *)(&disk_super->magic), BTRFS_MAGIC,
 		    sizeof(disk_super->magic))) {
 		printk(KERN_INFO "btrfs: valid FS not found on %s\n", sb->s_id);
 		goto fail_sb_buffer;
@@ -2105,7 +2105,7 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 
 		super = (struct btrfs_super_block *)bh->b_data;
 		if (btrfs_super_bytenr(super) != bytenr ||
-		    strncmp((char *)(&super->magic), BTRFS_MAGIC,
+		    memcmp((char *)(&super->magic), BTRFS_MAGIC,
 			    sizeof(super->magic))) {
 			brelse(bh);
 			continue;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 463d91b..7871658 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1351,7 +1351,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	namelen = strlen(vol_args->name);
 	if (strchr(vol_args->name, '/') ||
-	    strncmp(vol_args->name, "..", namelen) == 0) {
+	    memcmp(vol_args->name, "..", namelen) == 0) {
 		err = -EINVAL;
 		goto out;
 	}
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 698fdd2..7c32bee 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -290,11 +290,11 @@ const struct xattr_handler *btrfs_xattr_handlers[] = {
  */
 static bool btrfs_is_valid_xattr(const char *name)
 {
-	return !strncmp(name, XATTR_SECURITY_PREFIX,
+	return !memcmp(name, XATTR_SECURITY_PREFIX,
 			XATTR_SECURITY_PREFIX_LEN) ||
-	       !strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN) ||
-	       !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) ||
-	       !strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
+	       !memcmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN) ||
+	       !memcmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) ||
+	       !memcmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
 }
 
 ssize_t btrfs_getxattr(struct dentry *dentry, const char *name,
@@ -305,7 +305,7 @@ ssize_t btrfs_getxattr(struct dentry *dentry, const char *name,
 	 * namespace use the generic infrastructure to resolve a handler
 	 * for it via sb->s_xattr.
 	 */
-	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+	if (!memcmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
 		return generic_getxattr(dentry, name, buffer, size);
 
 	if (!btrfs_is_valid_xattr(name))
@@ -321,7 +321,7 @@ int btrfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 	 * namespace use the generic infrastructure to resolve a handler
 	 * for it via sb->s_xattr.
 	 */
-	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+	if (!memcmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
 		return generic_setxattr(dentry, name, value, size, flags);
 
 	if (!btrfs_is_valid_xattr(name))
@@ -341,7 +341,7 @@ int btrfs_removexattr(struct dentry *dentry, const char *name)
 	 * namespace use the generic infrastructure to resolve a handler
 	 * for it via sb->s_xattr.
 	 */
-	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+	if (!memcmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
 		return generic_removexattr(dentry, name);
 
 	if (!btrfs_is_valid_xattr(name))
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 7d447af..c270189 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -528,7 +528,7 @@ struct dentry *ceph_finish_lookup(struct ceph_mds_request *req,
 static int is_root_ceph_dentry(struct inode *inode, struct dentry *dentry)
 {
 	return ceph_ino(inode) == CEPH_INO_ROOT &&
-		strncmp(dentry->d_name.name, ".ceph", 5) == 0;
+		memcmp(dentry->d_name.name, ".ceph", 5) == 0;
 }
 
 /*
@@ -570,7 +570,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 
 		spin_lock(&dir->i_lock);
 		dout(" dir %p flags are %d\n", dir, ci->i_ceph_flags);
-		if (strncmp(dentry->d_name.name,
+		if (memcmp(dentry->d_name.name,
 			    fsc->mount_options->snapdir_name,
 			    dentry->d_name.len) &&
 		    !is_root_ceph_dentry(dir, dentry) &&
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index bf12865..c05b426 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -978,7 +978,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req,
 	 * will have trouble splicing in the virtual snapdir later
 	 */
 	if (rinfo->head->is_dentry && !req->r_aborted &&
-	    (rinfo->head->is_target || strncmp(req->r_dentry->d_name.name,
+	    (rinfo->head->is_target || memcmp(req->r_dentry->d_name.name,
 					       fsc->mount_options->snapdir_name,
 					       req->r_dentry->d_name.len))) {
 		/*
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 6e12a6b..c3d397d 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -10,11 +10,11 @@
 
 static bool ceph_is_valid_xattr(const char *name)
 {
-	return !strncmp(name, "ceph.", 5) ||
-	       !strncmp(name, XATTR_SECURITY_PREFIX,
+	return !memcmp(name, "ceph.", 5) ||
+	       !memcmp(name, XATTR_SECURITY_PREFIX,
 			XATTR_SECURITY_PREFIX_LEN) ||
-	       !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) ||
-	       !strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
+	       !memcmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) ||
+	       !memcmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
 }
 
 /*
@@ -152,7 +152,7 @@ static int __set_xattr(struct ceph_inode_info *ci,
 	while (*p) {
 		parent = *p;
 		xattr = rb_entry(parent, struct ceph_inode_xattr, node);
-		c = strncmp(name, xattr->name, min(name_len, xattr->name_len));
+		c = memcmp(name, xattr->name, min(name_len, xattr->name_len));
 		if (c < 0)
 			p = &(*p)->rb_left;
 		else if (c > 0)
@@ -225,7 +225,7 @@ static struct ceph_inode_xattr *__get_xattr(struct ceph_inode_info *ci,
 	while (*p) {
 		parent = *p;
 		xattr = rb_entry(parent, struct ceph_inode_xattr, node);
-		c = strncmp(name, xattr->name, xattr->name_len);
+		c = memcmp(name, xattr->name, xattr->name_len);
 		if (c < 0)
 			p = &(*p)->rb_left;
 		else if (c > 0)
diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index c68a056..0160b39 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -158,7 +158,7 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 
 	/* copy all options except of unc,ip,prefixpath */
 	off = 0;
-	if (strncmp(sb_mountdata, "sep=", 4) == 0) {
+	if (memcmp(sb_mountdata, "sep=", 4) == 0) {
 			sep = sb_mountdata[4];
 			strncpy(mountdata, sb_mountdata, 5);
 			off += 5;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 2f2632b..5a7a6f4 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5598,7 +5598,7 @@ QAllEAsRetry:
 		}
 
 		if (ea_name) {
-			if (strncmp(ea_name, temp_ptr, name_len) == 0) {
+			if (memcmp(ea_name, temp_ptr, name_len) == 0) {
 				temp_ptr += name_len + 1;
 				rc = value_len;
 				if (buf_size == 0)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 251a17c..6728255 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -843,7 +843,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 	if (!options)
 		return 1;
 
-	if (strncmp(options, "sep=", 4) == 0) {
+	if (memcmp(options, "sep=", 4) == 0) {
 		if (options[4] != 0) {
 			separator[0] = options[4];
 			options += 5;
@@ -1029,10 +1029,10 @@ cifs_parse_mount_options(char *options, const char *devname,
 				if (vol->UNC == NULL)
 					return 1;
 				strcpy(vol->UNC, value);
-				if (strncmp(vol->UNC, "//", 2) == 0) {
+				if (memcmp(vol->UNC, "//", 2) == 0) {
 					vol->UNC[0] = '\\';
 					vol->UNC[1] = '\\';
-				} else if (strncmp(vol->UNC, "\\\\", 2) != 0) {
+				} else if (memcmp(vol->UNC, "\\\\", 2) != 0) {
 					printk(KERN_WARNING
 					       "CIFS: UNC Path does not begin "
 					       "with // or \\\\ \n");
@@ -1372,10 +1372,10 @@ cifs_parse_mount_options(char *options, const char *devname,
 			if (vol->UNC == NULL)
 				return 1;
 			strcpy(vol->UNC, devname);
-			if (strncmp(vol->UNC, "//", 2) == 0) {
+			if (memcmp(vol->UNC, "//", 2) == 0) {
 				vol->UNC[0] = '\\';
 				vol->UNC[1] = '\\';
-			} else if (strncmp(vol->UNC, "\\\\", 2) != 0) {
+			} else if (memcmp(vol->UNC, "\\\\", 2) != 0) {
 				printk(KERN_WARNING "CIFS: UNC Path does not "
 						    "begin with // or \\\\ \n");
 				return 1;
@@ -1730,12 +1730,12 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 			break;
 		default:
 			/* anything else takes username/password */
-			if (strncmp(ses->userName, vol->username,
+			if (memcmp(ses->userName, vol->username,
 				    MAX_USERNAME_SIZE))
 				continue;
 			if (strlen(vol->username) != 0 &&
 			    ses->password != NULL &&
-			    strncmp(ses->password,
+			    memcmp(ses->password,
 				    vol->password ? vol->password : "",
 				    MAX_PASSWORD_SIZE))
 				continue;
@@ -1880,7 +1880,7 @@ cifs_find_tcon(struct cifsSesInfo *ses, const char *unc)
 		tcon = list_entry(tmp, struct cifsTconInfo, tcon_list);
 		if (tcon->tidStatus == CifsExiting)
 			continue;
-		if (strncmp(tcon->treeName, unc, MAX_TREE_SIZE))
+		if (memcmp(tcon->treeName, unc, MAX_TREE_SIZE))
 			continue;
 
 		++tcon->tc_count;
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 85cdbf8..53a7dc5 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -78,7 +78,7 @@ CIFSParseMFSymlink(const u8 *buf,
 		 CIFS_MF_SYMLINK_MD5_FORMAT,
 		 CIFS_MF_SYMLINK_MD5_ARGS(md5_hash));
 
-	if (strncmp(md5_str1, md5_str2, 17) != 0)
+	if (memcmp(md5_str1, md5_str2, 17) != 0)
 		return -EINVAL;
 
 	if (_link_str) {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 7b01d3f..e247e75 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -342,7 +342,7 @@ static int decode_ascii_ssetup(char **pbcc_area, int bleft,
 	ses->serverOS = kzalloc(len + 1, GFP_KERNEL);
 	if (ses->serverOS)
 		strncpy(ses->serverOS, bcc_ptr, len);
-	if (strncmp(ses->serverOS, "OS/2", 4) == 0) {
+	if (memcmp(ses->serverOS, "OS/2", 4) == 0) {
 			cFYI(1, "OS/2 server");
 			ses->flags |= CIFS_SES_OS2;
 	}
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index a264b74..f37c39d 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -75,8 +75,8 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
 	}
 	if (ea_name == NULL) {
 		cFYI(1, "Null xattr names not supported");
-	} else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5)
-		&& (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4))) {
+	} else if (memcmp(ea_name, CIFS_XATTR_USER_PREFIX, 5)
+		&& (memcmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4))) {
 		cFYI(1,
 		     "illegal xattr request %s (only user namespace supported)",
 		     ea_name);
@@ -147,17 +147,17 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 
 	if (ea_name == NULL) {
 		cFYI(1, "Null xattr names not supported");
-	} else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5) == 0) {
+	} else if (memcmp(ea_name, CIFS_XATTR_USER_PREFIX, 5) == 0) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto set_ea_exit;
-		if (strncmp(ea_name, CIFS_XATTR_DOS_ATTRIB, 14) == 0)
+		if (memcmp(ea_name, CIFS_XATTR_DOS_ATTRIB, 14) == 0)
 			cFYI(1, "attempt to set cifs inode metadata");
 
 		ea_name += 5; /* skip past user. prefix */
 		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
 			(__u16)value_size, cifs_sb->local_nls,
 			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
-	} else if (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4) == 0) {
+	} else if (memcmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4) == 0) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto set_ea_exit;
 
@@ -167,7 +167,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	} else {
 		int temp;
-		temp = strncmp(ea_name, POSIX_ACL_XATTR_ACCESS,
+		temp = memcmp(ea_name, POSIX_ACL_XATTR_ACCESS,
 			strlen(POSIX_ACL_XATTR_ACCESS));
 		if (temp == 0) {
 #ifdef CONFIG_CIFS_POSIX
@@ -181,7 +181,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 #else
 			cFYI(1, "set POSIX ACL not supported");
 #endif
-		} else if (strncmp(ea_name, POSIX_ACL_XATTR_DEFAULT,
+		} else if (memcmp(ea_name, POSIX_ACL_XATTR_DEFAULT,
 				   strlen(POSIX_ACL_XATTR_DEFAULT)) == 0) {
 #ifdef CONFIG_CIFS_POSIX
 			if (sb->s_flags & MS_POSIXACL)
@@ -248,11 +248,11 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 	/* return alt name if available as pseudo attr */
 	if (ea_name == NULL) {
 		cFYI(1, "Null xattr names not supported");
-	} else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5) == 0) {
+	} else if (memcmp(ea_name, CIFS_XATTR_USER_PREFIX, 5) == 0) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto get_ea_exit;
 
-		if (strncmp(ea_name, CIFS_XATTR_DOS_ATTRIB, 14) == 0) {
+		if (memcmp(ea_name, CIFS_XATTR_DOS_ATTRIB, 14) == 0) {
 			cFYI(1, "attempt to query cifs inode metadata");
 			/* revalidate/getattr then populate from inode */
 		} /* BB add else when above is implemented */
@@ -260,7 +260,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 		rc = CIFSSMBQAllEAs(xid, pTcon, full_path, ea_name, ea_value,
 			buf_size, cifs_sb->local_nls,
 			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
-	} else if (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4) == 0) {
+	} else if (memcmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4) == 0) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto get_ea_exit;
 
@@ -268,7 +268,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 		rc = CIFSSMBQAllEAs(xid, pTcon, full_path, ea_name, ea_value,
 			buf_size, cifs_sb->local_nls,
 			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
-	} else if (strncmp(ea_name, POSIX_ACL_XATTR_ACCESS,
+	} else if (memcmp(ea_name, POSIX_ACL_XATTR_ACCESS,
 			  strlen(POSIX_ACL_XATTR_ACCESS)) == 0) {
 #ifdef CONFIG_CIFS_POSIX
 		if (sb->s_flags & MS_POSIXACL)
@@ -301,7 +301,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 #else
 		cFYI(1, "query POSIX ACL not supported yet");
 #endif /* CONFIG_CIFS_POSIX */
-	} else if (strncmp(ea_name, POSIX_ACL_XATTR_DEFAULT,
+	} else if (memcmp(ea_name, POSIX_ACL_XATTR_DEFAULT,
 			  strlen(POSIX_ACL_XATTR_DEFAULT)) == 0) {
 #ifdef CONFIG_CIFS_POSIX
 		if (sb->s_flags & MS_POSIXACL)
@@ -313,10 +313,10 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 #else
 		cFYI(1, "query POSIX default ACL not supported yet");
 #endif
-	} else if (strncmp(ea_name,
+	} else if (memcmp(ea_name,
 		  CIFS_XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) == 0) {
 		cFYI(1, "Trusted xattr namespace not supported yet");
-	} else if (strncmp(ea_name,
+	} else if (memcmp(ea_name,
 		  CIFS_XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) == 0) {
 		cFYI(1, "Security xattr namespace not supported yet");
 	} else
diff --git a/fs/coda/coda_linux.c b/fs/coda/coda_linux.c
index bf4a3fd..110c81a 100644
--- a/fs/coda/coda_linux.c
+++ b/fs/coda/coda_linux.c
@@ -38,7 +38,7 @@ char * coda_f2s(struct CodaFid *f)
 int coda_iscontrol(const char *name, size_t length)
 {
 	return ((CODA_CONTROLLEN == length) && 
-                (strncmp(name, CODA_CONTROL, CODA_CONTROLLEN) == 0));
+                (memcmp(name, CODA_CONTROL, CODA_CONTROLLEN) == 0));
 }
 
 /* recognize /coda inode */
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index cbadc1b..acdefbd 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -2219,7 +2219,7 @@ int ecryptfs_decode_and_decrypt_filename(char **plaintext_name,
 	if ((mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES)
 	    && !(mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED)
 	    && (name_size > ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE)
-	    && (strncmp(name, ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX,
+	    && (memcmp(name, ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX,
 			ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE) == 0)) {
 		const char *orig_name = name;
 		size_t orig_name_size = name_size;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index d89e0b6..0bdc900 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -357,7 +357,7 @@ static unsigned long get_sb_block(void **data)
 	unsigned long 	sb_block;
 	char 		*options = (char *) *data;
 
-	if (!options || strncmp(options, "sb=", 3) != 0)
+	if (!options || memcmp(options, "sb=", 3) != 0)
 		return 1;	/* Default location */
 	options += 3;
 	sb_block = simple_strtoul(options, &options, 0);
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index bce9dce..3e0b430 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2379,7 +2379,7 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 	 */
 	if (le32_to_cpu(old_de->inode) != old_inode->i_ino ||
 	    old_de->name_len != old_dentry->d_name.len ||
-	    strncmp(old_de->name, old_dentry->d_name.name, old_de->name_len) ||
+	    memcmp(old_de->name, old_dentry->d_name.name, old_de->name_len) ||
 	    (retval = ext3_delete_entry(handle, old_dir,
 					old_de, old_bh)) == -ENOENT) {
 		/* old_de could have moved from under us during htree split, so
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index acf8695..1a50401 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -861,7 +861,7 @@ static ext3_fsblk_t get_sb_block(void **data, struct super_block *sb)
 	ext3_fsblk_t	sb_block;
 	char		*options = (char *) *data;
 
-	if (!options || strncmp(options, "sb=", 3) != 0)
+	if (!options || memcmp(options, "sb=", 3) != 0)
 		return 1;	/* Default location */
 	options += 3;
 	/*todo: use simple_strtoll with >32bit ext3 */
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 92203b8..e1437f1 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2424,7 +2424,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 */
 	if (le32_to_cpu(old_de->inode) != old_inode->i_ino ||
 	    old_de->name_len != old_dentry->d_name.len ||
-	    strncmp(old_de->name, old_dentry->d_name.name, old_de->name_len) ||
+	    memcmp(old_de->name, old_dentry->d_name.name, old_de->name_len) ||
 	    (retval = ext4_delete_entry(handle, old_dir,
 					old_de, old_bh)) == -ENOENT) {
 		/* old_de could have moved from under us during htree split, so
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e32195d..483aa2a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1326,7 +1326,7 @@ static ext4_fsblk_t get_sb_block(void **data)
 	ext4_fsblk_t	sb_block;
 	char		*options = (char *) *data;
 
-	if (!options || strncmp(options, "sb=", 3) != 0)
+	if (!options || memcmp(options, "sb=", 3) != 0)
 		return 1;	/* Default location */
 
 	options += 3;
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index ee42b9e..fa54b22 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -863,7 +863,7 @@ int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
 	offset = 0;
 	*bh = NULL;
 	while (fat_get_short_entry(dir, &offset, bh, de) >= 0) {
-		if (!strncmp((*de)->name, MSDOS_DOTDOT, MSDOS_NAME)) {
+		if (!memcmp((*de)->name, MSDOS_DOTDOT, MSDOS_NAME)) {
 			*i_pos = fat_make_i_pos(dir->i_sb, *bh, *de);
 			return 0;
 		}
@@ -884,8 +884,8 @@ int fat_dir_empty(struct inode *dir)
 	bh = NULL;
 	cpos = 0;
 	while (fat_get_short_entry(dir, &cpos, &bh, &de) >= 0) {
-		if (strncmp(de->name, MSDOS_DOT   , MSDOS_NAME) &&
-		    strncmp(de->name, MSDOS_DOTDOT, MSDOS_NAME)) {
+		if (memcmp(de->name, MSDOS_DOT   , MSDOS_NAME) &&
+		    memcmp(de->name, MSDOS_DOTDOT, MSDOS_NAME)) {
 			result = -ENOTEMPTY;
 			break;
 		}
@@ -930,7 +930,7 @@ int fat_scan(struct inode *dir, const unsigned char *name,
 	sinfo->bh = NULL;
 	while (fat_get_short_entry(dir, &sinfo->slot_off, &sinfo->bh,
 				   &sinfo->de) >= 0) {
-		if (!strncmp(sinfo->de->name, name, MSDOS_NAME)) {
+		if (!memcmp(sinfo->de->name, name, MSDOS_NAME)) {
 			sinfo->slot_off -= sizeof(*sinfo->de);
 			sinfo->nr_slots = 1;
 			sinfo->i_pos = fat_make_i_pos(sb, sinfo->bh, sinfo->de);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index ad6998a..c1a82b5 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -330,7 +330,7 @@ static int is_exec(unsigned char *extension)
 	unsigned char *exe_extensions = "EXECOMBAT", *walk;
 
 	for (walk = exe_extensions; *walk; walk += 3)
-		if (!strncmp(extension, walk, 3))
+		if (!memcmp(extension, walk, 3))
 			return 1;
 	return 0;
 }
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index b936703..2f0d4fc 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -159,7 +159,7 @@ static int vfat_cmp(struct dentry *dentry, struct qstr *a, struct qstr *b)
 	alen = vfat_striptail_len(a);
 	blen = vfat_striptail_len(b);
 	if (alen == blen) {
-		if (strncmp(a->name, b->name, alen) == 0)
+		if (memcmp(a->name, b->name, alen) == 0)
 			return 0;
 	}
 	return 1;
diff --git a/fs/filesystems.c b/fs/filesystems.c
index 68ba492..fda5632 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -48,7 +48,7 @@ static struct file_system_type **find_filesystem(const char *name, unsigned len)
 	struct file_system_type **p;
 	for (p=&file_systems; *p; p=&(*p)->next)
 		if (strlen((*p)->name) == len &&
-		    strncmp((*p)->name, name, len) == 0)
+		    memcmp((*p)->name, name, len) == 0)
 			break;
 	return p;
 }
diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index 0542b6e..9337d1c 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -61,7 +61,7 @@ int get_acorn_filename(struct iso_directory_record *de,
 	if ((*((unsigned char *) de) - std) != 32)
 		return retnamlen;
 	chr = ((unsigned char *) de) + std;
-	if (strncmp(chr, "ARCHIMEDES", 10))
+	if (memcmp(chr, "ARCHIMEDES", 10))
 		return retnamlen;
 	if ((*retname == '_') && ((chr[19] & 1) == 1))
 		*retname = '!';
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index bfdeb82..353e156 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -247,7 +247,7 @@ static int isofs_dentry_cmp_common(struct dentry *dentry, struct qstr *a,
 			blen--;
 	}
 	if (alen == blen) {
-		if (strncmp(a->name, b->name, alen) == 0)
+		if (memcmp(a->name, b->name, alen) == 0)
 			return 0;
 	}
 	return 1;
@@ -637,7 +637,7 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
 		 * ISO CDs can match hdp->id==HS_STANDARD_ID as well. To ensure
 		 * proper identification in this case, we first check for ISO.
 		 */
-		if (strncmp (vdp->id, ISO_STANDARD_ID, sizeof vdp->id) == 0) {
+		if (memcmp (vdp->id, ISO_STANDARD_ID, sizeof vdp->id) == 0) {
 			if (isonum_711(vdp->type) == ISO_VD_END)
 				break;
 			if (isonum_711(vdp->type) == ISO_VD_PRIMARY) {
@@ -672,7 +672,7 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
 			}
 #endif
 		} else {
-			if (strncmp (hdp->id, HS_STANDARD_ID, sizeof hdp->id) == 0) {
+			if (memcmp (hdp->id, HS_STANDARD_ID, sizeof hdp->id) == 0) {
 				if (isonum_711(hdp->type) != ISO_VD_PRIMARY)
 					goto out_freebh;
 
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 9297865..b8d923c 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -95,7 +95,7 @@ static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
 		if (fd_list->nhash == target->d_name.hash &&
 		    (!fd || fd_list->version > fd->version) &&
 		    strlen(fd_list->name) == target->d_name.len &&
-		    !strncmp(fd_list->name, target->d_name.name, target->d_name.len)) {
+		    !memcmp(fd_list->name, target->d_name.name, target->d_name.len)) {
 			fd = fd_list;
 		}
 	}
diff --git a/fs/jfs/jfs_mount.c b/fs/jfs/jfs_mount.c
index 9895595..dc195d3 100644
--- a/fs/jfs/jfs_mount.c
+++ b/fs/jfs/jfs_mount.c
@@ -318,7 +318,7 @@ static int chkSuper(struct super_block *sb)
 	 * validate superblock
 	 */
 	/* validate fs signature */
-	if (strncmp(j_sb->s_magic, JFS_MAGIC, 4) ||
+	if (memcmp(j_sb->s_magic, JFS_MAGIC, 4) ||
 	    le32_to_cpu(j_sb->s_version) > JFS_VERSION) {
 		rc = -EINVAL;
 		goto out;
diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index 2d7f165..8b77507 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -88,10 +88,10 @@ struct ea_buffer {
 
 static int is_known_namespace(const char *name)
 {
-	if (strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN) &&
-	    strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) &&
-	    strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) &&
-	    strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN))
+	if (memcmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN) &&
+	    memcmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) &&
+	    memcmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) &&
+	    memcmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN))
 		return false;
 
 	return true;
@@ -740,10 +740,10 @@ static int can_set_system_xattr(struct inode *inode, const char *name,
 static int can_set_xattr(struct inode *inode, const char *name,
 			 const void *value, size_t value_len)
 {
-	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+	if (!memcmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
 		return can_set_system_xattr(inode, name, value, value_len);
 
-	if (!strncmp(name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN)) {
+	if (!memcmp(name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN)) {
 		/*
 		 * This makes sure that we aren't trying to set an
 		 * attribute in a different namespace by prefixing it
@@ -757,9 +757,9 @@ static int can_set_xattr(struct inode *inode, const char *name,
 	/*
 	 * Don't allow setting an attribute in an unknown namespace.
 	 */
-	if (strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) &&
-	    strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) &&
-	    strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
+	if (memcmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) &&
+	    memcmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) &&
+	    memcmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
 		return -EOPNOTSUPP;
 
 	return 0;
@@ -780,7 +780,7 @@ int __jfs_setxattr(tid_t tid, struct inode *inode, const char *name,
 	int rc;
 	int length;
 
-	if (strncmp(name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN) == 0) {
+	if (memcmp(name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN) == 0) {
 		os2name = kmalloc(namelen - XATTR_OS2_PREFIX_LEN + 1,
 				  GFP_KERNEL);
 		if (!os2name)
@@ -988,7 +988,7 @@ ssize_t jfs_getxattr(struct dentry *dentry, const char *name, void *data,
 {
 	int err;
 
-	if (strncmp(name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN) == 0) {
+	if (memcmp(name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN) == 0) {
 		/*
 		 * skip past "os2." prefix
 		 */
@@ -1011,7 +1011,7 @@ ssize_t jfs_getxattr(struct dentry *dentry, const char *name, void *data,
  */
 static inline int can_list(struct jfs_ea *ea)
 {
-	return (strncmp(ea->name, XATTR_TRUSTED_PREFIX,
+	return (memcmp(ea->name, XATTR_TRUSTED_PREFIX,
 			    XATTR_TRUSTED_PREFIX_LEN) ||
 		capable(CAP_SYS_ADMIN));
 }
diff --git a/fs/logfs/super.c b/fs/logfs/super.c
index 33435e4..ca9a179 100644
--- a/fs/logfs/super.c
+++ b/fs/logfs/super.c
@@ -603,7 +603,7 @@ static struct dentry *logfs_mount(struct file_system_type *type, int flags,
 
 	if (!devname)
 		err = logfs_get_sb_bdev(super, type, devname);
-	else if (strncmp(devname, "mtd", 3))
+	else if (memcmp(devname, "mtd", 3))
 		err = logfs_get_sb_bdev(super, type, devname);
 	else {
 		char *garbage;
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index f22b12e..50836ff 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -151,7 +151,7 @@ ncp_compare_dentry(struct dentry *dentry, struct qstr *a, struct qstr *b)
 		return 1;
 
 	if (ncp_case_sensitive(dentry))
-		return strncmp(a->name, b->name, a->len);
+		return memcmp(a->name, b->name, a->len);
 
 	return ncp_strnicmp(NCP_IO_TABLE(dentry), a->name, b->name, a->len);
 }
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 8ea4a41..ef3714a 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -401,7 +401,7 @@ int nfs_same_file(struct dentry *dentry, struct nfs_entry *entry)
 	node = NFS_I(dentry->d_inode);
 	if (node->fh.size != entry->fh->size)
 		goto different;
-	if (strncmp(node->fh.data, entry->fh->data, node->fh.size) != 0)
+	if (memcmp(node->fh.data, entry->fh->data, node->fh.size) != 0)
 		goto different;
 	return 1;
 different:
diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
index 3c2a172..79204bc 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -88,7 +88,7 @@ static int nfs4_validate_fspath(const struct vfsmount *mnt_parent,
 	if (IS_ERR(fs_path))
 		return PTR_ERR(fs_path);
 
-	if (strncmp(path, fs_path, strlen(fs_path)) != 0) {
+	if (memcmp(path, fs_path, strlen(fs_path)) != 0) {
 		dprintk("%s: path %s does not begin with fsroot %s\n",
 			__func__, path, fs_path);
 		return -ENOENT;
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index f35a94a..cbe3331 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1614,7 +1614,7 @@ static char *nfsd4_path(struct svc_rqst *rqstp, struct svc_export *exp, __be32 *
 	path = exp->ex_pathname;
 
 	rootlen = strlen(rootpath);
-	if (strncmp(path, rootpath, rootlen)) {
+	if (memcmp(path, rootpath, rootlen)) {
 		dprintk("nfsd: fs_locations failed;"
 			"%s is not contained in %s\n", path, rootpath);
 		*stat = nfserr_notsupp;
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index c49f6de..71f5a2c 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -279,8 +279,8 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
 	 * XXX: Is this really necessary, if the index is never looked
 	 * at by readdir? Is a hash value of '0' a bad idea?
 	 */
-	if ((len == 1 && !strncmp(".", name, 1)) ||
-	    (len == 2 && !strncmp("..", name, 2))) {
+	if ((len == 1 && !memcmp(".", name, 1)) ||
+	    (len == 2 && !memcmp("..", name, 2))) {
 		buf[0] = buf[1] = 0;
 		goto out;
 	}
@@ -2151,12 +2151,12 @@ static int ocfs2_empty_dir_filldir(void *priv, const char *name, int name_len,
 	 * entries). This allows us to double check for existing
 	 * entries which might not have been found in the index.
 	 */
-	if (name_len == 1 && !strncmp(".", name, 1) && pos == 0) {
+	if (name_len == 1 && !memcmp(".", name, 1) && pos == 0) {
 		p->seen_dot = 1;
 		return 0;
 	}
 
-	if (name_len == 2 && !strncmp("..", name, 2) &&
+	if (name_len == 2 && !memcmp("..", name, 2) &&
 	    pos == OCFS2_DIR_REC_LEN(1)) {
 		p->seen_dot_dot = 1;
 
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index faa2303..24dd2b0 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1991,9 +1991,9 @@ static int ocfs2_orphan_filldir(void *priv, const char *name, int name_len,
 	struct ocfs2_orphan_filldir_priv *p = priv;
 	struct inode *iter;
 
-	if (name_len == 1 && !strncmp(".", name, 1))
+	if (name_len == 1 && !memcmp(".", name, 1))
 		return 0;
-	if (name_len == 2 && !strncmp("..", name, 2))
+	if (name_len == 2 && !memcmp("..", name, 2))
 		return 0;
 
 	/* Skip bad inodes so that recovery can continue */
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 252e7c8..792a351 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -186,7 +186,7 @@ static struct ocfs2_live_connection *ocfs2_connection_find(const char *name)
 
 	list_for_each_entry(c, &ocfs2_live_connection_list, oc_list) {
 		if ((c->oc_conn->cc_namelen == len) &&
-		    !strncmp(c->oc_conn->cc_name, name, len))
+		    !memcmp(c->oc_conn->cc_name, name, len))
 			return c;
 	}
 
@@ -269,7 +269,7 @@ static ssize_t ocfs2_control_validate_protocol(struct file *file,
 	if (ret)
 		return ret;
 
-	if (strncmp(kbuf, OCFS2_CONTROL_PROTO, OCFS2_CONTROL_PROTO_LEN))
+	if (memcmp(kbuf, OCFS2_CONTROL_PROTO, OCFS2_CONTROL_PROTO_LEN))
 		return -EINVAL;
 
 	ocfs2_control_set_handshake_state(file,
@@ -373,7 +373,7 @@ static int ocfs2_control_do_setnode_msg(struct file *file,
 	    OCFS2_CONTROL_HANDSHAKE_PROTOCOL)
 		return -EINVAL;
 
-	if (strncmp(msg->tag, OCFS2_CONTROL_MESSAGE_SETNODE_OP,
+	if (memcmp(msg->tag, OCFS2_CONTROL_MESSAGE_SETNODE_OP,
 		    OCFS2_CONTROL_MESSAGE_OP_LEN))
 		return -EINVAL;
 
@@ -406,7 +406,7 @@ static int ocfs2_control_do_setversion_msg(struct file *file,
 	    OCFS2_CONTROL_HANDSHAKE_PROTOCOL)
 		return -EINVAL;
 
-	if (strncmp(msg->tag, OCFS2_CONTROL_MESSAGE_SETVERSION_OP,
+	if (memcmp(msg->tag, OCFS2_CONTROL_MESSAGE_SETVERSION_OP,
 		    OCFS2_CONTROL_MESSAGE_OP_LEN))
 		return -EINVAL;
 
@@ -453,7 +453,7 @@ static int ocfs2_control_do_down_msg(struct file *file,
 	    OCFS2_CONTROL_HANDSHAKE_VALID)
 		return -EINVAL;
 
-	if (strncmp(msg->tag, OCFS2_CONTROL_MESSAGE_DOWN_OP,
+	if (memcmp(msg->tag, OCFS2_CONTROL_MESSAGE_DOWN_OP,
 		    OCFS2_CONTROL_MESSAGE_OP_LEN))
 		return -EINVAL;
 
@@ -492,15 +492,15 @@ static ssize_t ocfs2_control_message(struct file *file,
 		goto out;
 
 	if ((count == OCFS2_CONTROL_MESSAGE_SETNODE_TOTAL_LEN) &&
-	    !strncmp(msg.tag, OCFS2_CONTROL_MESSAGE_SETNODE_OP,
+	    !memcmp(msg.tag, OCFS2_CONTROL_MESSAGE_SETNODE_OP,
 		     OCFS2_CONTROL_MESSAGE_OP_LEN))
 		ret = ocfs2_control_do_setnode_msg(file, &msg.u_setn);
 	else if ((count == OCFS2_CONTROL_MESSAGE_SETVERSION_TOTAL_LEN) &&
-		 !strncmp(msg.tag, OCFS2_CONTROL_MESSAGE_SETVERSION_OP,
+		 !memcmp(msg.tag, OCFS2_CONTROL_MESSAGE_SETVERSION_OP,
 			  OCFS2_CONTROL_MESSAGE_OP_LEN))
 		ret = ocfs2_control_do_setversion_msg(file, &msg.u_setv);
 	else if ((count == OCFS2_CONTROL_MESSAGE_DOWN_TOTAL_LEN) &&
-		 !strncmp(msg.tag, OCFS2_CONTROL_MESSAGE_DOWN_OP,
+		 !memcmp(msg.tag, OCFS2_CONTROL_MESSAGE_DOWN_OP,
 			  OCFS2_CONTROL_MESSAGE_OP_LEN))
 		ret = ocfs2_control_do_down_msg(file, &msg.u_down);
 	else
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 39abf89..61dd94f 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -576,7 +576,7 @@ static ssize_t ocfs2_cluster_stack_store(struct kobject *kobj,
 
 	spin_lock(&ocfs2_stack_lock);
 	if (active_stack) {
-		if (!strncmp(buf, cluster_stack_name, len))
+		if (!memcmp(buf, cluster_stack_name, len))
 			ret = count;
 		else
 			ret = -EBUSY;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index cfeab7c..901aef0 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -877,7 +877,7 @@ static int ocfs2_verify_userspace_stack(struct ocfs2_super *osb,
 	}
 
 	if (ocfs2_userspace_stack(osb) &&
-	    strncmp(osb->osb_cluster_stack, mopt->cluster_stack,
+	    memcmp(osb->osb_cluster_stack, mopt->cluster_stack,
 		    OCFS2_STACK_LABEL_LEN)) {
 		mlog(ML_ERROR,
 		     "cluster stack passed to mount (\"%s\") does not "
diff --git a/fs/omfs/dir.c b/fs/omfs/dir.c
index 393f3f6..50fbc60 100644
--- a/fs/omfs/dir.c
+++ b/fs/omfs/dir.c
@@ -53,7 +53,7 @@ static struct buffer_head *omfs_scan_list(struct inode *dir, u64 block,
 			goto err;
 		}
 
-		if (strncmp(oi->i_name, name, namelen) == 0)
+		if (memcmp(oi->i_name, name, namelen) == 0)
 			return bh;
 
 		*prev_block = block;
diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index 911e61f..e355c59 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -202,7 +202,7 @@ static struct dentry *openpromfs_lookup(struct inode *dir, struct dentry *dentry
 		int n = strlen(child->path_component_name);
 
 		if (len == n &&
-		    !strncmp(child->path_component_name, name, len)) {
+		    !memcmp(child->path_component_name, name, len)) {
 			ent_type = op_inode_node;
 			ent_data.node = child;
 			ino = child->unique_id;
@@ -215,7 +215,7 @@ static struct dentry *openpromfs_lookup(struct inode *dir, struct dentry *dentry
 	while (prop) {
 		int n = strlen(prop->name);
 
-		if (len == n && !strncmp(prop->name, name, len)) {
+		if (len == n && !memcmp(prop->name, name, len)) {
 			ent_type = op_inode_prop;
 			ent_data.prop = prop;
 			ino = prop->unique_id;
@@ -246,7 +246,7 @@ found:
 		break;
 	case op_inode_prop:
 		if (!strcmp(dp->name, "options") && (len == 17) &&
-		    !strncmp (name, "security-password", 17))
+		    !memcmp (name, "security-password", 17))
 			inode->i_mode = S_IFREG | S_IRUSR | S_IWUSR;
 		else
 			inode->i_mode = S_IFREG | S_IRUGO;
diff --git a/fs/partitions/ibm.c b/fs/partitions/ibm.c
index d513a07..f185227 100644
--- a/fs/partitions/ibm.c
+++ b/fs/partitions/ibm.c
@@ -139,7 +139,7 @@ int ibm_partition(struct parsed_partitions *state)
 	 * unformated disks we do not have to care about
 	 */
 	if (info->format == DASD_FORMAT_LDL) {
-		if (strncmp(type, "CMS1", 4) == 0) {
+		if (memcmp(type, "CMS1", 4) == 0) {
 			/*
 			 * VM style CMS1 labeled disk
 			 */
@@ -161,7 +161,7 @@ int ibm_partition(struct parsed_partitions *state)
 			put_partition(state, 1, offset*(blocksize >> 9),
 				      size-offset*(blocksize >> 9));
 		} else {
-			if (strncmp(type, "LNX1", 4) == 0) {
+			if (memcmp(type, "LNX1", 4) == 0) {
 				snprintf(tmp, sizeof(tmp), "LNX1/%8s:", name);
 				strlcat(state->pp_buf, tmp, PAGE_SIZE);
 				if (label->lnx.ldl_version == 0xf2) {
@@ -200,7 +200,7 @@ int ibm_partition(struct parsed_partitions *state)
 		 * check if VOL1 label is available
 		 * if not, something is wrong, skipping partition detection
 		 */
-		if (strncmp(type, "VOL1",  4) == 0) {
+		if (memcmp(type, "VOL1",  4) == 0) {
 			snprintf(tmp, sizeof(tmp), "VOL1/%8s:", name);
 			strlcat(state->pp_buf, tmp, PAGE_SIZE);
 			/*
diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
index 789c625..208c4ed 100644
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -200,7 +200,7 @@ static bool ldm_parse_tocblock (const u8 *data, struct tocblock *toc)
 	toc->bitmap1_start = get_unaligned_be64(data + 0x2E);
 	toc->bitmap1_size  = get_unaligned_be64(data + 0x36);
 
-	if (strncmp (toc->bitmap1_name, TOC_BITMAP1,
+	if (memcmp (toc->bitmap1_name, TOC_BITMAP1,
 			sizeof (toc->bitmap1_name)) != 0) {
 		ldm_crit ("TOCBLOCK's first bitmap is '%s', should be '%s'.",
 				TOC_BITMAP1, toc->bitmap1_name);
@@ -210,7 +210,7 @@ static bool ldm_parse_tocblock (const u8 *data, struct tocblock *toc)
 	toc->bitmap2_name[sizeof (toc->bitmap2_name) - 1] = 0;
 	toc->bitmap2_start = get_unaligned_be64(data + 0x50);
 	toc->bitmap2_size  = get_unaligned_be64(data + 0x58);
-	if (strncmp (toc->bitmap2_name, TOC_BITMAP2,
+	if (memcmp (toc->bitmap2_name, TOC_BITMAP2,
 			sizeof (toc->bitmap2_name)) != 0) {
 		ldm_crit ("TOCBLOCK's second bitmap is '%s', should be '%s'.",
 				TOC_BITMAP2, toc->bitmap2_name);
@@ -301,9 +301,9 @@ static bool ldm_compare_tocblocks (const struct tocblock *toc1,
 		(toc1->bitmap1_size  == toc2->bitmap1_size)	&&
 		(toc1->bitmap2_start == toc2->bitmap2_start)	&&
 		(toc1->bitmap2_size  == toc2->bitmap2_size)	&&
-		!strncmp (toc1->bitmap1_name, toc2->bitmap1_name,
+		!memcmp (toc1->bitmap1_name, toc2->bitmap1_name,
 			sizeof (toc1->bitmap1_name))		&&
-		!strncmp (toc1->bitmap2_name, toc2->bitmap2_name,
+		!memcmp (toc1->bitmap2_name, toc2->bitmap2_name,
 			sizeof (toc1->bitmap2_name)));
 }
 
diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index d9396a4..d70ba1c 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -70,12 +70,12 @@ __proc_device_tree_add_prop(struct proc_dir_entry *de, struct property *pp,
 	 * at the beginning of the list.  So we rearrange them.
 	 */
 	ent = proc_create_data(name,
-			       strncmp(name, "security-", 9) ? S_IRUGO : S_IRUSR,
+			       memcmp(name, "security-", 9) ? S_IRUGO : S_IRUSR,
 			       de, &property_proc_fops, pp);
 	if (ent == NULL)
 		return NULL;
 
-	if (!strncmp(name, "security-", 9))
+	if (!memcmp(name, "security-", 9))
 		ent->size = 0; /* don't leak number of password chars */
 	else
 		ent->size = pp->length;
diff --git a/fs/qnx4/namei.c b/fs/qnx4/namei.c
index 275327b..f2249bd 100644
--- a/fs/qnx4/namei.c
+++ b/fs/qnx4/namei.c
@@ -49,7 +49,7 @@ static int qnx4_match(int len, const char *name,
 	if (len != thislen) {
 		return 0;
 	}
-	if (strncmp(name, de->di_fname, len) == 0) {
+	if (memcmp(name, de->di_fname, len) == 0) {
 		if ((de->di_status & (QNX4_FILE_USED|QNX4_FILE_LINK)) != 0) {
 			return 1;
 		}
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index b243117..73c42da 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -37,19 +37,19 @@ static const char reiserfs_jr_magic_string[] = REISER2FS_JR_SUPER_MAGIC_STRING;
 
 int is_reiserfs_3_5(struct reiserfs_super_block *rs)
 {
-	return !strncmp(rs->s_v1.s_magic, reiserfs_3_5_magic_string,
+	return !memcmp(rs->s_v1.s_magic, reiserfs_3_5_magic_string,
 			strlen(reiserfs_3_5_magic_string));
 }
 
 int is_reiserfs_3_6(struct reiserfs_super_block *rs)
 {
-	return !strncmp(rs->s_v1.s_magic, reiserfs_3_6_magic_string,
+	return !memcmp(rs->s_v1.s_magic, reiserfs_3_6_magic_string,
 			strlen(reiserfs_3_6_magic_string));
 }
 
 int is_reiserfs_jr(struct reiserfs_super_block *rs)
 {
-	return !strncmp(rs->s_v1.s_magic, reiserfs_jr_magic_string,
+	return !memcmp(rs->s_v1.s_magic, reiserfs_jr_magic_string,
 			strlen(reiserfs_jr_magic_string));
 }
 
@@ -759,7 +759,7 @@ static int reiserfs_getopt(struct super_block *s, char **cur, opt_desc_t * opts,
 		(*cur)++;
 	}
 
-	if (!strncmp(p, "alloc=", 6)) {
+	if (!memcmp(p, "alloc=", 6)) {
 		/* Ugly special case, probably we should redo options parser so that
 		   it can understand several arguments for some options, also so that
 		   it can fill several bitfields with option values. */
@@ -772,7 +772,7 @@ static int reiserfs_getopt(struct super_block *s, char **cur, opt_desc_t * opts,
 
 	/* for every option in the list */
 	for (opt = opts; opt->option_name; opt++) {
-		if (!strncmp(p, opt->option_name, strlen(opt->option_name))) {
+		if (!memcmp(p, opt->option_name, strlen(opt->option_name))) {
 			if (bit_flags) {
 				if (opt->clrmask ==
 				    (1 << REISERFS_UNSUPPORTED_OPT))
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 5d04a78..96cf91e 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -730,7 +730,7 @@ find_xattr_handler_prefix(const struct xattr_handler **handlers,
 		return NULL;
 
 	for_each_xattr_handler(handlers, xah) {
-		if (strncmp(xah->prefix, name, strlen(xah->prefix)) == 0)
+		if (memcmp(xah->prefix, name, strlen(xah->prefix)) == 0)
 			break;
 	}
 
diff --git a/fs/squashfs/namei.c b/fs/squashfs/namei.c
index 7a9464d..3c35b3b 100644
--- a/fs/squashfs/namei.c
+++ b/fs/squashfs/namei.c
@@ -197,7 +197,7 @@ static struct dentry *squashfs_lookup(struct inode *dir, struct dentry *dentry,
 			if (name[0] < dire->name[0])
 				goto exit_lookup;
 
-			if (len == size && !strncmp(name, dire->name, len)) {
+			if (len == size && !memcmp(name, dire->name, len)) {
 				unsigned int blk, off, ino_num;
 				long long ino;
 				blk = le32_to_cpu(dirh.start_block);
diff --git a/fs/squashfs/xattr.c b/fs/squashfs/xattr.c
index 3876c36..855754e 100644
--- a/fs/squashfs/xattr.c
+++ b/fs/squashfs/xattr.c
@@ -155,7 +155,7 @@ static int squashfs_xattr_get(struct inode *inode, int name_index,
 			goto failed;
 
 		if (prefix == name_index && name_size == name_len &&
-					strncmp(target, name, name_size) == 0) {
+					memcmp(target, name, name_size) == 0) {
 			/* found xattr */
 			if (type & SQUASHFS_XATTR_VALUE_OOL) {
 				__le64 xattr_val;
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index cffb1fd..86dbc5f 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -163,7 +163,7 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 	if (!sd)
 		return -EINVAL;
 
-	if (!strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN)) {
+	if (!memcmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN)) {
 		const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
 		error = security_inode_setsecurity(dentry->d_inode, suffix,
 						value, size, flags);
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index c74400f..d79c17d 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -257,17 +257,17 @@ static int check_namespace(const struct qstr *nm)
 	if (nm->len > UBIFS_MAX_NLEN)
 		return -ENAMETOOLONG;
 
-	if (!strncmp(nm->name, XATTR_TRUSTED_PREFIX,
+	if (!memcmp(nm->name, XATTR_TRUSTED_PREFIX,
 		     XATTR_TRUSTED_PREFIX_LEN)) {
 		if (nm->name[sizeof(XATTR_TRUSTED_PREFIX) - 1] == '\0')
 			return -EINVAL;
 		type = TRUSTED_XATTR;
-	} else if (!strncmp(nm->name, XATTR_USER_PREFIX,
+	} else if (!memcmp(nm->name, XATTR_USER_PREFIX,
 				      XATTR_USER_PREFIX_LEN)) {
 		if (nm->name[XATTR_USER_PREFIX_LEN] == '\0')
 			return -EINVAL;
 		type = USER_XATTR;
-	} else if (!strncmp(nm->name, XATTR_SECURITY_PREFIX,
+	} else if (!memcmp(nm->name, XATTR_SECURITY_PREFIX,
 				     XATTR_SECURITY_PREFIX_LEN)) {
 		if (nm->name[sizeof(XATTR_SECURITY_PREFIX) - 1] == '\0')
 			return -EINVAL;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 6d8dc02..c993d81 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -266,7 +266,7 @@ static struct dentry *udf_lookup(struct inode *dir, struct dentry *dentry,
 	lock_kernel();
 #ifdef UDF_RECOVERY
 	/* temporary shorthand for specifying files by inode number */
-	if (!strncmp(dentry->d_name.name, ".B=", 3)) {
+	if (!memcmp(dentry->d_name.name, ".B=", 3)) {
 		struct kernel_lb_addr lb = {
 			.logicalBlockNum = 0,
 			.partitionReferenceNum =
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 4a5c7c6..368efa9 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -631,7 +631,7 @@ static loff_t udf_check_vsd(struct super_block *sb)
 		if (vsd->stdIdent[0] == 0) {
 			brelse(bh);
 			break;
-		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_CD001,
+		} else if (!memcmp(vsd->stdIdent, VSD_STD_ID_CD001,
 				    VSD_STD_ID_LEN)) {
 			switch (vsd->structType) {
 			case 0:
@@ -658,17 +658,17 @@ static loff_t udf_check_vsd(struct super_block *sb)
 					  vsd->structType);
 				break;
 			}
-		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_BEA01,
+		} else if (!memcmp(vsd->stdIdent, VSD_STD_ID_BEA01,
 				    VSD_STD_ID_LEN))
 			; /* nothing */
-		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_TEA01,
+		else if (!memcmp(vsd->stdIdent, VSD_STD_ID_TEA01,
 				    VSD_STD_ID_LEN)) {
 			brelse(bh);
 			break;
-		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_NSR02,
+		} else if (!memcmp(vsd->stdIdent, VSD_STD_ID_NSR02,
 				    VSD_STD_ID_LEN))
 			nsr02 = sector;
-		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_NSR03,
+		else if (!memcmp(vsd->stdIdent, VSD_STD_ID_NSR03,
 				    VSD_STD_ID_LEN))
 			nsr03 = sector;
 		brelse(bh);
@@ -1279,7 +1279,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 		} else if (type == 2) {
 			struct udfPartitionMap2 *upm2 =
 						(struct udfPartitionMap2 *)gpm;
-			if (!strncmp(upm2->partIdent.ident, UDF_ID_VIRTUAL,
+			if (!memcmp(upm2->partIdent.ident, UDF_ID_VIRTUAL,
 						strlen(UDF_ID_VIRTUAL))) {
 				u16 suf =
 					le16_to_cpu(((__le16 *)upm2->partIdent.
@@ -1295,7 +1295,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 					map->s_partition_func =
 							udf_get_pblock_virt20;
 				}
-			} else if (!strncmp(upm2->partIdent.ident,
+			} else if (!memcmp(upm2->partIdent.ident,
 						UDF_ID_SPARABLE,
 						strlen(UDF_ID_SPARABLE))) {
 				uint32_t loc;
@@ -1320,7 +1320,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 						continue;
 
 					st = (struct sparingTable *)bh2->b_data;
-					if (ident != 0 || strncmp(
+					if (ident != 0 || memcmp(
 						st->sparingIdent.ident,
 						UDF_ID_SPARING,
 						strlen(UDF_ID_SPARING))) {
@@ -1330,7 +1330,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 					}
 				}
 				map->s_partition_func = udf_get_pblock_spar15;
-			} else if (!strncmp(upm2->partIdent.ident,
+			} else if (!memcmp(upm2->partIdent.ident,
 						UDF_ID_METADATA,
 						strlen(UDF_ID_METADATA))) {
 				struct udf_meta_data *mdata =
diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index dbc9099..35f32e7 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -26,7 +26,7 @@
 #include "util.h"
 
 /*
- * NOTE! unlike strncmp, ufs_match returns 1 for success, 0 for failure.
+ * NOTE! unlike memcmp, ufs_match returns 1 for success, 0 for failure.
  *
  * len <= UFS_MAXNAMLEN and de != NULL are guaranteed by caller.
  */
diff --git a/fs/xattr.c b/fs/xattr.c
index 01bb813..a22581f 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -41,21 +41,21 @@ xattr_permission(struct inode *inode, const char *name, int mask)
 	 * No restriction for security.* and system.* from the VFS.  Decision
 	 * on these is left to the underlying filesystem / security module.
 	 */
-	if (!strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) ||
-	    !strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+	if (!memcmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) ||
+	    !memcmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
 		return 0;
 
 	/*
 	 * The trusted.* namespace can only be accessed by a privileged user.
 	 */
-	if (!strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN))
+	if (!memcmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN))
 		return (capable(CAP_SYS_ADMIN) ? 0 : -EPERM);
 
 	/* In user.* namespace, only regular files and directories can have
 	 * extended attributes. For sticky directories, only the owner and
 	 * privileged user can write attributes.
 	 */
-	if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
+	if (!memcmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
 		if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
 			return -EPERM;
 		if (S_ISDIR(inode->i_mode) && (inode->i_mode & S_ISVTX) &&
@@ -95,7 +95,7 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
 			security_inode_post_setxattr(dentry, name, value,
 						     size, flags);
 		}
-	} else if (!strncmp(name, XATTR_SECURITY_PREFIX,
+	} else if (!memcmp(name, XATTR_SECURITY_PREFIX,
 				XATTR_SECURITY_PREFIX_LEN)) {
 		const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
 		error = security_inode_setsecurity(inode, suffix, value,
@@ -173,7 +173,7 @@ vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
 	if (error)
 		return error;
 
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+	if (!memcmp(name, XATTR_SECURITY_PREFIX,
 				XATTR_SECURITY_PREFIX_LEN)) {
 		const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
 		int ret = xattr_getsecurity(inode, suffix, value, size);
diff --git a/include/linux/string.h b/include/linux/string.h
index a716ee2..4da0786 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -140,7 +140,7 @@ extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
  */
 static inline bool strstarts(const char *str, const char *prefix)
 {
-	return strncmp(str, prefix, strlen(prefix)) == 0;
+	return memcmp(str, prefix, strlen(prefix)) == 0;
 }
 #endif
 #endif /* _LINUX_STRING_H_ */
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 830aaec..c69a895 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -141,7 +141,7 @@ dev_t name_to_dev_t(char *name)
 	int part;
 
 #ifdef CONFIG_BLOCK
-	if (strncmp(name, "PARTUUID=", 9) == 0) {
+	if (memcmp(name, "PARTUUID=", 9) == 0) {
 		name += 9;
 		if (strlen(name) != 36)
 			goto fail;
@@ -152,7 +152,7 @@ dev_t name_to_dev_t(char *name)
 	}
 #endif
 
-	if (strncmp(name, "/dev/", 5) != 0) {
+	if (memcmp(name, "/dev/", 5) != 0) {
 		unsigned maj, min;
 
 		if (sscanf(name, "%u:%u", &maj, &min) == 2) {
@@ -456,13 +456,13 @@ void __init prepare_namespace(void)
 
 	if (saved_root_name[0]) {
 		root_device_name = saved_root_name;
-		if (!strncmp(root_device_name, "mtd", 3) ||
-		    !strncmp(root_device_name, "ubi", 3)) {
+		if (!memcmp(root_device_name, "mtd", 3) ||
+		    !memcmp(root_device_name, "ubi", 3)) {
 			mount_block_root(root_device_name, root_mountflags);
 			goto out;
 		}
 		ROOT_DEV = name_to_dev_t(root_device_name);
-		if (strncmp(root_device_name, "/dev/", 5) == 0)
+		if (memcmp(root_device_name, "/dev/", 5) == 0)
 			root_device_name += 5;
 	}
 
diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index 32c4799..00a2fac 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -146,7 +146,7 @@ static void __init md_setup_drive(void)
 				*p++ = 0;
 
 			dev = name_to_dev_t(devname);
-			if (strncmp(devname, "/dev/", 5) == 0)
+			if (memcmp(devname, "/dev/", 5) == 0)
 				devname += 5;
 			snprintf(comp_name, 63, "/dev/%s", devname);
 			rdev = bstat(comp_name);
@@ -254,13 +254,13 @@ static int __init raid_setup(char *str)
 			wlen = (comma-str)-pos;
 		else	wlen = (len-1)-pos;
 
-		if (!strncmp(str, "noautodetect", wlen))
+		if (!memcmp(str, "noautodetect", wlen))
 			raid_noautodetect = 1;
-		if (!strncmp(str, "autodetect", wlen))
+		if (!memcmp(str, "autodetect", wlen))
 			raid_noautodetect = 0;
-		if (strncmp(str, "partitionable", wlen)==0)
+		if (memcmp(str, "partitionable", wlen)==0)
 			raid_autopart = 1;
-		if (strncmp(str, "part", wlen)==0)
+		if (memcmp(str, "part", wlen)==0)
 			raid_autopart = 1;
 		pos += wlen+1;
 	}
diff --git a/init/main.c b/init/main.c
index 8646401..28c97aa 100644
--- a/init/main.c
+++ b/init/main.c
@@ -210,7 +210,7 @@ static int __init obsolete_checksetup(char *line)
 	p = __setup_start;
 	do {
 		int n = strlen(p->str);
-		if (!strncmp(line, p->str, n)) {
+		if (!memcmp(line, p->str, n)) {
 			if (p->early) {
 				/* Already done in parse_early_param?
 				 * (Needs exact match on param part).
@@ -300,7 +300,7 @@ static int __init unknown_bootoption(char *param, char *val)
 				panic_later = "Too many boot env vars at `%s'";
 				panic_param = param;
 			}
-			if (!strncmp(param, envp_init[i], val - param))
+			if (!memcmp(param, envp_init[i], val - param))
 				break;
 		}
 		envp_init[i] = param;
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index add2819..096f6a0 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1226,7 +1226,7 @@ int audit_compare_dname_path(const char *dname, const char *path,
 	/* return length of path's directory component */
 	if (dirlen)
 		*dirlen = p - path;
-	return strncmp(p, dname, dlen);
+	return memcmp(p, dname, dlen);
 }
 
 static int audit_filter_user_rules(struct netlink_skb_parms *cb,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 66a416b..edf55d8 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1111,7 +1111,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 			opts->clone_children = true;
 			continue;
 		}
-		if (!strncmp(token, "release_agent=", 14)) {
+		if (!memcmp(token, "release_agent=", 14)) {
 			/* Specifying two release agents is forbidden */
 			if (opts->release_agent)
 				return -EINVAL;
@@ -1121,7 +1121,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 				return -ENOMEM;
 			continue;
 		}
-		if (!strncmp(token, "name=", 5)) {
+		if (!memcmp(token, "name=", 5)) {
 			const char *name = token + 5;
 			/* Can't specify an empty name */
 			if (!strlen(name))
diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index 481a7bd..15933f4 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -761,7 +761,7 @@ static void gdb_cmd_query(struct kgdb_state *ks)
 		break;
 #ifdef CONFIG_KGDB_KDB
 	case 'R':
-		if (strncmp(remcom_in_buffer, "qRcmd,", 6) == 0) {
+		if (memcmp(remcom_in_buffer, "qRcmd,", 6) == 0) {
 			int len = strlen(remcom_in_buffer + 6);
 
 			if ((len % 2) != 0) {
diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 96fdaac..453a2c3 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -34,9 +34,9 @@ int kdb_trap_printk;
 static void kgdb_transition_check(char *buffer)
 {
 	int slen = strlen(buffer);
-	if (strncmp(buffer, "$?#3f", slen) != 0 &&
-	    strncmp(buffer, "$qSupported#37", slen) != 0 &&
-	    strncmp(buffer, "+$qSupported#37", slen) != 0) {
+	if (memcmp(buffer, "$?#3f", slen) != 0 &&
+	    memcmp(buffer, "$qSupported#37", slen) != 0 &&
+	    memcmp(buffer, "+$qSupported#37", slen) != 0) {
 		KDB_STATE_SET(KGDB_TRANS);
 		kdb_printf("%s", buffer);
 	}
@@ -517,16 +517,16 @@ static int kdb_search_string(char *searched, char *searchfor)
 	if (kdb_grep_leading && kdb_grep_trailing && len1 != len2)
 		return 0;
 	if (kdb_grep_leading) {
-		if (!strncmp(searched, searchfor, len2))
+		if (!memcmp(searched, searchfor, len2))
 			return 1;
 	} else if (kdb_grep_trailing) {
-		if (!strncmp(searched+len1-len2, searchfor, len2))
+		if (!memcmp(searched+len1-len2, searchfor, len2))
 			return 1;
 	} else {
 		firstchar = *searchfor;
 		cp = searched;
 		while ((cp = strchr(cp, firstchar))) {
-			if (!strncmp(cp, searchfor, len2))
+			if (!memcmp(cp, searchfor, len2))
 				return 1;
 			cp++;
 		}
@@ -614,7 +614,7 @@ int vkdb_printf(const char *fmt, va_list ap)
 				 */
 				cp2 = kdb_buffer;
 				len = strlen(kdb_prompt_str);
-				if (!strncmp(cp2, kdb_prompt_str, len)) {
+				if (!memcmp(cp2, kdb_prompt_str, len)) {
 					/*
 					 * We're about to start a new
 					 * command, so we can go back
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index a6e7297..cd42cfe 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -207,7 +207,7 @@ char *kdbgetenv(const char *match)
 		if (!e)
 			continue;
 
-		if ((strncmp(match, e, matchlen) == 0)
+		if ((memcmp(match, e, matchlen) == 0)
 		 && ((e[matchlen] == '\0')
 		   || (e[matchlen] == '='))) {
 			char *cp = strchr(e, '=');
@@ -404,7 +404,7 @@ int kdb_set(int argc, const char **argv)
 
 	for (i = 0; i < __nenv; i++) {
 		if (__env[i]
-		 && ((strncmp(__env[i], argv[1], varlen) == 0)
+		 && ((memcmp(__env[i], argv[1], varlen) == 0)
 		   && ((__env[i][varlen] == '\0')
 		    || (__env[i][varlen] == '=')))) {
 			__env[i] = ep;
@@ -769,7 +769,7 @@ static void parse_grep(const char *str)
 	cp++;
 	while (isspace(*cp))
 		cp++;
-	if (strncmp(cp, "grep ", 5)) {
+	if (memcmp(cp, "grep ", 5)) {
 		kdb_printf("invalid 'pipe', see grephelp\n");
 		return;
 	}
@@ -955,7 +955,7 @@ int kdb_parse(const char *cmdstr)
 
 			if (tp->cmd_minlen
 			 && (strlen(argv[0]) <= tp->cmd_minlen)) {
-				if (strncmp(argv[0],
+				if (memcmp(argv[0],
 					    tp->cmd_name,
 					    tp->cmd_minlen) == 0) {
 					break;
@@ -975,7 +975,7 @@ int kdb_parse(const char *cmdstr)
 	if (i == kdb_max_commands) {
 		for_each_kdbcmd(tp, i) {
 			if (tp->cmd_name) {
-				if (strncmp(argv[0],
+				if (memcmp(argv[0],
 					    tp->cmd_name,
 					    strlen(tp->cmd_name)) == 0) {
 					break;
diff --git a/kernel/debug/kdb/kdb_support.c b/kernel/debug/kdb/kdb_support.c
index 6b2485d..7fa68c9 100644
--- a/kernel/debug/kdb/kdb_support.c
+++ b/kernel/debug/kdb/kdb_support.c
@@ -191,7 +191,7 @@ int kallsyms_symbol_complete(char *prefix_name, int max_len)
 	const char *name;
 
 	while ((name = kdb_walk_kallsyms(&pos))) {
-		if (strncmp(name, prefix_name, prefix_len) == 0) {
+		if (memcmp(name, prefix_name, prefix_len) == 0) {
 			strcpy(ks_namebuf, name);
 			/* Work out the longest name that matches the prefix */
 			if (++number == 1) {
@@ -235,7 +235,7 @@ int kallsyms_symbol_next(char *prefix_name, int flag)
 		pos = 0;
 
 	while ((name = kdb_walk_kallsyms(&pos))) {
-		if (strncmp(name, prefix_name, prefix_len) == 0) {
+		if (memcmp(name, prefix_name, prefix_len) == 0) {
 			strncpy(prefix_name, name, strlen(name)+1);
 			return 1;
 		}
diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
index 9bd0934..bf11351 100644
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
@@ -332,7 +332,7 @@ static char *get_link_target(const char *filename, const struct gcov_link *ext)
 	const char *rel;
 	char *result;
 
-	if (strncmp(filename, objtree, strlen(objtree)) == 0) {
+	if (memcmp(filename, objtree, strlen(objtree)) == 0) {
 		rel = filename + strlen(objtree) + 1;
 		if (ext->dir == SRC_TREE)
 			result = link_target(srctree, rel, ext->ext);
@@ -354,7 +354,7 @@ static char *get_link_target(const char *filename, const struct gcov_link *ext)
  */
 static const char *deskew(const char *basename)
 {
-	if (strncmp(basename, SKEW_PREFIX, sizeof(SKEW_PREFIX) - 1) == 0)
+	if (memcmp(basename, SKEW_PREFIX, sizeof(SKEW_PREFIX) - 1) == 0)
 		return basename + sizeof(SKEW_PREFIX) - 1;
 	return basename;
 }
diff --git a/kernel/module.c b/kernel/module.c
index d190664..8df3d38 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1841,7 +1841,7 @@ static char *get_modinfo(struct load_info *info, const char *tag)
 	unsigned long size = infosec->sh_size;
 
 	for (p = (char *)infosec->sh_addr; p; p = next_string(p, &size)) {
-		if (strncmp(p, tag, taglen) == 0 && p[taglen] == '=')
+		if (memcmp(p, tag, taglen) == 0 && p[taglen] == '=')
 			return p + taglen + 1;
 	}
 	return NULL;
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 657272e..7c01827 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -878,7 +878,7 @@ static ssize_t disk_store(struct kobject *kobj, struct kobj_attribute *attr,
 	mutex_lock(&pm_mutex);
 	for (i = HIBERNATION_FIRST; i <= HIBERNATION_MAX; i++) {
 		if (len == strlen(hibernation_modes[i])
-		    && !strncmp(buf, hibernation_modes[i], len)) {
+		    && !memcmp(buf, hibernation_modes[i], len)) {
 			mode = i;
 			break;
 		}
@@ -1009,9 +1009,9 @@ static int __init resume_offset_setup(char *str)
 
 static int __init hibernate_setup(char *str)
 {
-	if (!strncmp(str, "noresume", 8))
+	if (!memcmp(str, "noresume", 8))
 		noresume = 1;
-	else if (!strncmp(str, "nocompress", 10))
+	else if (!memcmp(str, "nocompress", 10))
 		nocompress = 1;
 	return 1;
 }
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 7b5db6a..188f62f 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -119,7 +119,7 @@ static ssize_t pm_test_store(struct kobject *kobj, struct kobj_attribute *attr,
 
 	level = TEST_FIRST;
 	for (s = &pm_tests[level]; level <= TEST_MAX; s++, level++)
-		if (*s && len == strlen(*s) && !strncmp(buf, *s, len)) {
+		if (*s && len == strlen(*s) && !memcmp(buf, *s, len)) {
 			pm_test_level = level;
 			error = 0;
 			break;
@@ -184,14 +184,14 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 	len = p ? p - buf : n;
 
 	/* First, check if we are requested to hibernate */
-	if (len == 4 && !strncmp(buf, "disk", len)) {
+	if (len == 4 && !memcmp(buf, "disk", len)) {
 		error = hibernate();
   goto Exit;
 	}
 
 #ifdef CONFIG_SUSPEND
 	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++) {
-		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
+		if (*s && len == strlen(*s) && !memcmp(buf, *s, len))
 			break;
 	}
 	if (state < PM_SUSPEND_MAX && *s)
diff --git a/kernel/profile.c b/kernel/profile.c
index 66f841b..dfabee5 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -59,7 +59,7 @@ int profile_setup(char *str)
 	static char kvmstr[] = "kvm";
 	int par;
 
-	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
+	if (!memcmp(str, sleepstr, strlen(sleepstr))) {
 #ifdef CONFIG_SCHEDSTATS
 		prof_on = SLEEP_PROFILING;
 		if (str[strlen(sleepstr)] == ',')
@@ -73,7 +73,7 @@ int profile_setup(char *str)
 		printk(KERN_WARNING
 			"kernel sleep profiling requires CONFIG_SCHEDSTATS\n");
 #endif /* CONFIG_SCHEDSTATS */
-	} else if (!strncmp(str, schedstr, strlen(schedstr))) {
+	} else if (!memcmp(str, schedstr, strlen(schedstr))) {
 		prof_on = SCHED_PROFILING;
 		if (str[strlen(schedstr)] == ',')
 			str += strlen(schedstr) + 1;
@@ -82,7 +82,7 @@ int profile_setup(char *str)
 		printk(KERN_INFO
 			"kernel schedule profiling enabled (shift: %ld)\n",
 			prof_shift);
-	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
+	} else if (!memcmp(str, kvmstr, strlen(kvmstr))) {
 		prof_on = KVM_PROFILING;
 		if (str[strlen(kvmstr)] == ',')
 			str += strlen(kvmstr) + 1;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f3dadae..9547f14 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1744,7 +1744,7 @@ static int ftrace_match(char *str, char *regex, int len, int type)
 			matched = 1;
 		break;
 	case MATCH_FRONT_ONLY:
-		if (strncmp(str, regex, len) == 0)
+		if (memcmp(str, regex, len) == 0)
 			matched = 1;
 		break;
 	case MATCH_MIDDLE_ONLY:
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c380612..4fdfcdb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -806,7 +806,7 @@ __acquires(kernel_lock)
 	if (ret || !default_bootup_tracer)
 		goto out_unlock;
 
-	if (strncmp(default_bootup_tracer, type->name, MAX_TRACER_SIZE))
+	if (memcmp(default_bootup_tracer, type->name, MAX_TRACER_SIZE))
 		goto out_unlock;
 
 	printk(KERN_INFO "Starting tracer '%s'\n", type->name);
@@ -2544,7 +2544,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 	buf[cnt] = 0;
 	cmp = strstrip(buf);
 
-	if (strncmp(cmp, "no", 2) == 0) {
+	if (memcmp(cmp, "no", 2) == 0) {
 		neg = 1;
 		cmp += 2;
 	}
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0725eea..fa1e9c4 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -696,7 +696,7 @@ static int f_show(struct seq_file *m, void *v)
 	 */
 	array_descriptor = strchr(field->type, '[');
 
-	if (!strncmp(field->type, "__data_loc", 10))
+	if (!memcmp(field->type, "__data_loc", 10))
 		array_descriptor = NULL;
 
 	if (!array_descriptor)
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 36d4010..52d5add 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -267,14 +267,14 @@ static int filter_pred_none(struct filter_pred *pred, void *event,
 
 static int regex_match_full(char *str, struct regex *r, int len)
 {
-	if (strncmp(str, r->pattern, len) == 0)
+	if (memcmp(str, r->pattern, len) == 0)
 		return 1;
 	return 0;
 }
 
 static int regex_match_front(char *str, struct regex *r, int len)
 {
-	if (strncmp(str, r->pattern, r->len) == 0)
+	if (memcmp(str, r->pattern, r->len) == 0)
 		return 1;
 	return 0;
 }
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 2dec9bc..ff8d829 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -708,7 +708,7 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 			f->fn = t->fetch[FETCH_MTD_retval];
 		else
 			ret = -EINVAL;
-	} else if (strncmp(arg, "stack", 5) == 0) {
+	} else if (memcmp(arg, "stack", 5) == 0) {
 		if (arg[5] == '\0') {
 			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR) == 0)
 				f->fn = fetch_stack_address;
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 02272ba..4cdd939 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -374,7 +374,7 @@ static inline const char *kretprobed(const char *name)
 	static const char tramp_name[] = "kretprobe_trampoline";
 	int size = sizeof(tramp_name);
 
-	if (strncmp(tramp_name, name, size) == 0)
+	if (memcmp(tramp_name, name, size) == 0)
 		return "[unknown/kretprobe'd]";
 	return name;
 }
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 6e3c41a..feea9bd 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -55,7 +55,7 @@ static int hardlockup_panic;
 
 static int __init hardlockup_panic_setup(char *str)
 {
-	if (!strncmp(str, "panic", 5))
+	if (!memcmp(str, "panic", 5))
 		hardlockup_panic = 1;
 	return 1;
 }
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 4bfb047..6855d46 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -176,7 +176,7 @@ static bool driver_filter(struct device *dev)
 
 	ret = false;
 	if (drv->name &&
-	    strncmp(current_driver_name, drv->name, NAME_MAX_LEN - 1) == 0) {
+	    memcmp(current_driver_name, drv->name, NAME_MAX_LEN - 1) == 0) {
 		current_driver = drv;
 		ret = true;
 	}
@@ -755,7 +755,7 @@ static __init int dma_debug_cmdline(char *str)
 	if (!str)
 		return -EINVAL;
 
-	if (strncmp(str, "off", 3) == 0) {
+	if (memcmp(str, "off", 3) == 0) {
 		pr_info("DMA-API: debugging disabled on kernel command line\n");
 		global_disable = true;
 	}
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 70af0a7..db33b9c 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -71,7 +71,7 @@ int kobject_action_type(const char *buf, size_t count,
 		goto out;
 
 	for (action = 0; action < ARRAY_SIZE(kobject_actions); action++) {
-		if (strncmp(kobject_actions[action], buf, count) != 0)
+		if (memcmp(kobject_actions[action], buf, count) != 0)
 			continue;
 		if (kobject_actions[action][count] != '\0')
 			continue;
diff --git a/lib/parser.c b/lib/parser.c
index 6e89eca..ce48516 100644
--- a/lib/parser.c
+++ b/lib/parser.c
@@ -36,7 +36,7 @@ static int match_one(char *s, const char *p, substring_t args[])
 		if (!meta)
 			return strcmp(p, s) == 0;
 
-		if (strncmp(p, s, meta-p))
+		if (memcmp(p, s, meta-p))
 			return 0;
 
 		s += meta - p;
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index bd9bc21..0dab2cb 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1546,17 +1546,17 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
 	if (ret < 0)
 		return ret;
 
-	if (strncmp(buf, "off", 3) == 0)
+	if (memcmp(buf, "off", 3) == 0)
 		kmemleak_disable();
-	else if (strncmp(buf, "stack=on", 8) == 0)
+	else if (memcmp(buf, "stack=on", 8) == 0)
 		kmemleak_stack_scan = 1;
-	else if (strncmp(buf, "stack=off", 9) == 0)
+	else if (memcmp(buf, "stack=off", 9) == 0)
 		kmemleak_stack_scan = 0;
-	else if (strncmp(buf, "scan=on", 7) == 0)
+	else if (memcmp(buf, "scan=on", 7) == 0)
 		start_scan_thread();
-	else if (strncmp(buf, "scan=off", 8) == 0)
+	else if (memcmp(buf, "scan=off", 8) == 0)
 		stop_scan_thread();
-	else if (strncmp(buf, "scan=", 5) == 0) {
+	else if (memcmp(buf, "scan=", 5) == 0) {
 		unsigned long secs;
 
 		ret = strict_strtoul(buf + 5, 0, &secs);
@@ -1567,11 +1567,11 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
 			jiffies_scan_wait = msecs_to_jiffies(secs * 1000);
 			start_scan_thread();
 		}
-	} else if (strncmp(buf, "scan", 4) == 0)
+	} else if (memcmp(buf, "scan", 4) == 0)
 		kmemleak_scan();
-	else if (strncmp(buf, "clear", 5) == 0)
+	else if (memcmp(buf, "clear", 5) == 0)
 		kmemleak_clear();
-	else if (strncmp(buf, "dump=", 5) == 0)
+	else if (memcmp(buf, "dump=", 5) == 0)
 		ret = dump_str_object_info(buf + 5);
 	else
 		ret = -EINVAL;
diff --git a/mm/slub.c b/mm/slub.c
index 981fb73..6d13025 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1052,7 +1052,7 @@ static unsigned long kmem_cache_flags(unsigned long objsize,
 	 * Enable debugging if selected on the kernel commandline.
 	 */
 	if (slub_debug && (!slub_debug_slabs ||
-		!strncmp(slub_debug_slabs, name, strlen(slub_debug_slabs))))
+		!memcmp(slub_debug_slabs, name, strlen(slub_debug_slabs))))
 		flags |= slub_debug;
 
 	return flags;
diff --git a/net/9p/client.c b/net/9p/client.c
index a848bca..9a6fdea 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -76,13 +76,13 @@ static int get_protocol_version(const substring_t *name)
 {
 	int version = -EINVAL;
 
-	if (!strncmp("9p2000", name->from, name->to-name->from)) {
+	if (!memcmp("9p2000", name->from, name->to-name->from)) {
 		version = p9_proto_legacy;
 		P9_DPRINTK(P9_DEBUG_9P, "Protocol version: Legacy\n");
-	} else if (!strncmp("9p2000.u", name->from, name->to-name->from)) {
+	} else if (!memcmp("9p2000.u", name->from, name->to-name->from)) {
 		version = p9_proto_2000u;
 		P9_DPRINTK(P9_DEBUG_9P, "Protocol version: 9P2000.u\n");
-	} else if (!strncmp("9p2000.L", name->from, name->to-name->from)) {
+	} else if (!memcmp("9p2000.L", name->from, name->to-name->from)) {
 		version = p9_proto_2000L;
 		P9_DPRINTK(P9_DEBUG_9P, "Protocol version: 9P2000.L\n");
 	} else {
@@ -724,11 +724,11 @@ static int p9_client_version(struct p9_client *c)
 	}
 
 	P9_DPRINTK(P9_DEBUG_9P, "<<< RVERSION msize %d %s\n", msize, version);
-	if (!strncmp(version, "9P2000.L", 8))
+	if (!memcmp(version, "9P2000.L", 8))
 		c->proto_version = p9_proto_2000L;
-	else if (!strncmp(version, "9P2000.u", 8))
+	else if (!memcmp(version, "9P2000.u", 8))
 		c->proto_version = p9_proto_2000u;
-	else if (!strncmp(version, "9P2000", 6))
+	else if (!memcmp(version, "9P2000", 6))
 		c->proto_version = p9_proto_legacy;
 	else {
 		err = -EREMOTEIO;
diff --git a/net/9p/mod.c b/net/9p/mod.c
index cf8a412..988411d 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -87,7 +87,7 @@ struct p9_trans_module *v9fs_get_trans_by_name(const substring_t *name)
 	spin_lock(&v9fs_trans_lock);
 
 	list_for_each_entry(t, &v9fs_trans_list, list)
-		if (strncmp(t->name, name->from, name->to-name->from) == 0 &&
+		if (memcmp(t->name, name->from, name->to-name->from) == 0 &&
 		    try_module_get(t->owner)) {
 			found = t;
 			break;
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index c8f3f72..fa97569 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -374,7 +374,7 @@ p9_virtio_create(struct p9_client *client, const char *devname, char *args)
 
 	mutex_lock(&virtio_9p_lock);
 	list_for_each_entry(chan, &virtio_chan_list, chan_list) {
-		if (!strncmp(devname, chan->tag, chan->tag_len) &&
+		if (!memcmp(devname, chan->tag, chan->tag_len) &&
 		    strlen(devname) == chan->tag_len) {
 			if (!chan->inuse) {
 				chan->inuse = true;
diff --git a/net/atm/br2684.c b/net/atm/br2684.c
index ad2b232..62b22ce 100644
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -131,7 +131,7 @@ static struct net_device *br2684_find_dev(const struct br2684_if_spec *s)
 	case BR2684_FIND_BYIFNAME:
 		list_for_each(lh, &br2684_devs) {
 			net_dev = list_entry_brdev(lh);
-			if (!strncmp(net_dev->name, s->spec.ifname, IFNAMSIZ))
+			if (!memcmp(net_dev->name, s->spec.ifname, IFNAMSIZ))
 				return net_dev;
 		}
 		break;
diff --git a/net/atm/mpc.c b/net/atm/mpc.c
index 74bcc66..fc0d2d0 100644
--- a/net/atm/mpc.c
+++ b/net/atm/mpc.c
@@ -1012,7 +1012,7 @@ static int mpoa_event_listener(struct notifier_block *mpoa_notifier,
 	if (!net_eq(dev_net(dev), &init_net))
 		return NOTIFY_DONE;
 
-	if (dev->name == NULL || strncmp(dev->name, "lec", 3))
+	if (dev->name == NULL || memcmp(dev->name, "lec", 3))
 		return NOTIFY_DONE; /* we are only interested in lec:s */
 
 	switch (event) {
diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index 5fce3d6..108aa9e 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -110,7 +110,7 @@ static void add_conn(struct work_struct *work)
  */
 static int __match_tty(struct device *dev, void *data)
 {
-	return !strncmp(dev_name(dev), "rfcomm", 6);
+	return !memcmp(dev_name(dev), "rfcomm", 6);
 }
 
 static void del_conn(struct work_struct *work)
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 89ad25a..52020a3 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -51,10 +51,10 @@ static int port_cost(struct net_device *dev)
 	}
 
 	/* Old silly heuristics based on name */
-	if (!strncmp(dev->name, "lec", 3))
+	if (!memcmp(dev->name, "lec", 3))
 		return 7;
 
-	if (!strncmp(dev->name, "plip", 4))
+	if (!memcmp(dev->name, "plip", 4))
 		return 2500;
 
 	return 100;	/* assume old 10Mbps */
diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
index fd5799c..8e771a9 100644
--- a/net/bridge/br_sysfs_if.c
+++ b/net/bridge/br_sysfs_if.c
@@ -278,7 +278,7 @@ int br_sysfs_renameif(struct net_bridge_port *p)
 	/* If a rename fails, the rollback will cause another
 	 * rename call with the existing name.
 	 */
-	if (!strncmp(p->sysfs_name, p->dev->name, IFNAMSIZ))
+	if (!memcmp(p->sysfs_name, p->dev->name, IFNAMSIZ))
 		return 0;
 
 	err = sysfs_rename_link(br->ifobj, &p->kobj,
diff --git a/net/core/dev.c b/net/core/dev.c
index 0dd54a6..44d9940 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -608,7 +608,7 @@ struct net_device *__dev_get_by_name(struct net *net, const char *name)
 	struct hlist_head *head = dev_name_hash(net, name);
 
 	hlist_for_each_entry(dev, p, head, name_hlist)
-		if (!strncmp(dev->name, name, IFNAMSIZ))
+		if (!memcmp(dev->name, name, IFNAMSIZ))
 			return dev;
 
 	return NULL;
@@ -634,7 +634,7 @@ struct net_device *dev_get_by_name_rcu(struct net *net, const char *name)
 	struct hlist_head *head = dev_name_hash(net, name);
 
 	hlist_for_each_entry_rcu(dev, p, head, name_hlist)
-		if (!strncmp(dev->name, name, IFNAMSIZ))
+		if (!memcmp(dev->name, name, IFNAMSIZ))
 			return dev;
 
 	return NULL;
@@ -900,7 +900,7 @@ static int __dev_alloc_name(struct net *net, const char *name, char *buf)
 
 			/*  avoid cases where sscanf is not exact inverse of printf */
 			snprintf(buf, IFNAMSIZ, name, i);
-			if (!strncmp(buf, d->name, IFNAMSIZ))
+			if (!memcmp(buf, d->name, IFNAMSIZ))
 				set_bit(i, inuse);
 		}
 
@@ -991,7 +991,7 @@ int dev_change_name(struct net_device *dev, const char *newname)
 	if (dev->flags & IFF_UP)
 		return -EBUSY;
 
-	if (strncmp(newname, dev->name, IFNAMSIZ) == 0)
+	if (memcmp(newname, dev->name, IFNAMSIZ) == 0)
 		return 0;
 
 	memcpy(oldname, dev->name, IFNAMSIZ);
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 33bc382..cb4056a 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3645,7 +3645,7 @@ static struct pktgen_dev *pktgen_find_dev(struct pktgen_thread *t,
 
 	if_lock(t);
 	list_for_each_entry(p, &t->if_list, list)
-		if (strncmp(p->odevname, ifname, len) == 0) {
+		if (memcmp(p->odevname, ifname, len) == 0) {
 			if (p->odevname[len]) {
 				if (exact || p->odevname[len] != '@')
 					continue;
diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 3a6e1ec..b8add8f 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -193,7 +193,7 @@ static bool __init ic_device_match(struct net_device *dev)
 	if (user_dev_name[0] ? !strcmp(dev->name, user_dev_name) :
 	    (!(dev->flags & IFF_LOOPBACK) &&
 	     (dev->flags & (IFF_POINTOPOINT|IFF_BROADCAST)) &&
-	     strncmp(dev->name, "dummy", 5)))
+	     memcmp(dev->name, "dummy", 5)))
 		return true;
 	return false;
 }
diff --git a/net/irda/irnet/irnet_irda.c b/net/irda/irnet/irnet_irda.c
index 7f17a80..532699c 100644
--- a/net/irda/irnet/irnet_irda.c
+++ b/net/irda/irnet/irnet_irda.c
@@ -471,7 +471,7 @@ irnet_dname_to_daddr(irnet_socket *	self)
   for(i = 0; i < number; i++)
     {
       /* Does the name match ? */
-      if(!strncmp(discoveries[i].info, self->rname, NICKNAME_MAX_LEN))
+      if(!memcmp(discoveries[i].info, self->rname, NICKNAME_MAX_LEN))
 	{
 	  /* Yes !!! Get it.. */
 	  self->daddr = discoveries[i].daddr;
diff --git a/net/irda/irnet/irnet_ppp.c b/net/irda/irnet/irnet_ppp.c
index 7c567b8..662b508 100644
--- a/net/irda/irnet/irnet_ppp.c
+++ b/net/irda/irnet/irnet_ppp.c
@@ -96,7 +96,7 @@ irnet_ctrl_write(irnet_socket *	ap,
        * We can't use "switch" with strings, so hack with "continue" */
 
       /* First command : name -> Requested IrDA nickname */
-      if(!strncmp(start, "name", 4))
+      if(!memcmp(start, "name", 4))
 	{
 	  /* Copy the name only if is included and not "any" */
 	  if((length > 5) && (strcmp(start + 5, "any")))
@@ -119,9 +119,9 @@ irnet_ctrl_write(irnet_socket *	ap,
 
       /* Second command : addr, daddr -> Requested IrDA destination address
        * Also process : saddr -> Requested IrDA source address */
-      if((!strncmp(start, "addr", 4)) ||
-	 (!strncmp(start, "daddr", 5)) ||
-	 (!strncmp(start, "saddr", 5)))
+      if((!memcmp(start, "addr", 4)) ||
+	 (!memcmp(start, "daddr", 5)) ||
+	 (!memcmp(start, "saddr", 5)))
 	{
 	  __u32		addr = DEV_ADDR_ANY;
 
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 18260aa..2d891bc 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -83,7 +83,7 @@ static ssize_t tsf_write(struct file *file,
 		return -EFAULT;
 	buf[len] = '\0';
 
-	if (strncmp(buf, "reset", 5) == 0) {
+	if (memcmp(buf, "reset", 5) == 0) {
 		if (local->ops->reset_tsf) {
 			drv_reset_tsf(local);
 			wiphy_info(local->hw.wiphy, "debugfs reset TSF\n");
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index cbdf36d..76fcc35 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -203,7 +203,7 @@ static ssize_t ieee80211_if_parse_smps(struct ieee80211_sub_if_data *sdata,
 	enum ieee80211_smps_mode mode;
 
 	for (mode = 0; mode < IEEE80211_SMPS_NUM_MODES; mode++) {
-		if (strncmp(buf, smps_modes[mode], buflen) == 0) {
+		if (memcmp(buf, smps_modes[mode], buflen) == 0) {
 			int err = ieee80211_set_smps(sdata, mode);
 			if (!err)
 				return buflen;
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 4601fea..56ed3f3 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -167,21 +167,21 @@ static ssize_t sta_agg_status_write(struct file *file, const char __user *userbu
 
 	buf[sizeof(_buf) - 1] = '\0';
 
-	if (strncmp(buf, "tx ", 3) == 0) {
+	if (memcmp(buf, "tx ", 3) == 0) {
 		buf += 3;
 		tx = true;
-	} else if (strncmp(buf, "rx ", 3) == 0) {
+	} else if (memcmp(buf, "rx ", 3) == 0) {
 		buf += 3;
 		tx = false;
 	} else
 		return -EINVAL;
 
-	if (strncmp(buf, "start ", 6) == 0) {
+	if (memcmp(buf, "start ", 6) == 0) {
 		buf += 6;
 		start = true;
 		if (!tx)
 			return -EINVAL;
-	} else if (strncmp(buf, "stop ", 5) == 0) {
+	} else if (memcmp(buf, "stop ", 5) == 0) {
 		buf += 5;
 		start = false;
 	} else
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index bcf47eb..f22a502 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -700,7 +700,7 @@ static const char *ct_sdp_header_search(const char *dptr, const char *limit,
 	for (limit -= len; dptr < limit; dptr++) {
 		if (*dptr == '\r' || *dptr == '\n')
 			break;
-		if (strncmp(dptr, needle, len) == 0)
+		if (memcmp(dptr, needle, len) == 0)
 			return dptr;
 	}
 	return NULL;
@@ -963,7 +963,7 @@ static const struct sdp_media_type *sdp_media_type(const char *dptr,
 	for (i = 0; i < ARRAY_SIZE(sdp_media_types); i++) {
 		t = &sdp_media_types[i];
 		if (matchlen < t->len ||
-		    strncmp(dptr + matchoff, t->name, t->len))
+		    memcmp(dptr + matchoff, t->name, t->len))
 			continue;
 		return t;
 	}
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 9f4ab00..101670d 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -49,7 +49,7 @@ helper_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	if (info->name[0] == '\0')
 		ret = !ret;
 	else
-		ret ^= !strncmp(helper->name, info->name,
+		ret ^= !memcmp(helper->name, info->name,
 				strlen(helper->name));
 	return ret;
 }
diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 44059d0..9f0c4b9 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -601,7 +601,7 @@ struct net_device *nr_dev_first(void)
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, dev) {
 		if ((dev->flags & IFF_UP) && dev->type == ARPHRD_NETROM)
-			if (first == NULL || strncmp(dev->name, first->name, 3) < 0)
+			if (first == NULL || memcmp(dev->name, first->name, 3) < 0)
 				first = dev;
 	}
 	if (first)
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index b4fdaac..8efc690 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -612,7 +612,7 @@ struct net_device *rose_dev_first(void)
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, dev) {
 		if ((dev->flags & IFF_UP) && dev->type == ARPHRD_ROSE)
-			if (first == NULL || strncmp(dev->name, first->name, 3) < 0)
+			if (first == NULL || memcmp(dev->name, first->name, 3) < 0)
 				first = dev;
 	}
 	rcu_read_unlock();
diff --git a/net/sched/sch_fifo.c b/net/sched/sch_fifo.c
index 4dfecb0..c179243 100644
--- a/net/sched/sch_fifo.c
+++ b/net/sched/sch_fifo.c
@@ -150,7 +150,7 @@ int fifo_set_limit(struct Qdisc *q, unsigned int limit)
 	int ret = -ENOMEM;
 
 	/* Hack to avoid sending change message to non-FIFO */
-	if (strncmp(q->ops->id + 1, "fifo", 4) != 0)
+	if (memcmp(q->ops->id + 1, "fifo", 4) != 0)
 		return 0;
 
 	nla = kmalloc(nla_attr_size(sizeof(struct tc_fifo_qopt)), GFP_KERNEL);
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 6359c42..099aa9d 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -78,13 +78,13 @@ param_set_pool_mode(const char *val, struct kernel_param *kp)
 		goto out;
 
 	err = 0;
-	if (!strncmp(val, "auto", 4))
+	if (!memcmp(val, "auto", 4))
 		*ip = SVC_POOL_AUTO;
-	else if (!strncmp(val, "global", 6))
+	else if (!memcmp(val, "global", 6))
 		*ip = SVC_POOL_GLOBAL;
-	else if (!strncmp(val, "percpu", 6))
+	else if (!memcmp(val, "percpu", 6))
 		*ip = SVC_POOL_PERCPU;
-	else if (!strncmp(val, "pernode", 7))
+	else if (!memcmp(val, "pernode", 7))
 		*ip = SVC_POOL_PERNODE;
 	else
 		err = -EINVAL;
diff --git a/net/tipc/eth_media.c b/net/tipc/eth_media.c
index 6e988ba..6b8b29f 100644
--- a/net/tipc/eth_media.c
+++ b/net/tipc/eth_media.c
@@ -149,7 +149,7 @@ static int enable_bearer(struct tipc_bearer *tb_ptr)
 	/* Find device with specified name */
 
 	for_each_netdev(&init_net, pdev){
-		if (!strncmp(pdev->name, driver_name, IFNAMSIZ)) {
+		if (!memcmp(pdev->name, driver_name, IFNAMSIZ)) {
 			dev = pdev;
 			break;
 		}
diff --git a/scripts/conmakehash.c b/scripts/conmakehash.c
index 263a44d..783694a 100644
--- a/scripts/conmakehash.c
+++ b/scripts/conmakehash.c
@@ -184,7 +184,7 @@ int main(int argc, char *argv[])
 	     same length */
 	  while (*p == ' ' || *p == '\t')
 	    p++;
-	  if (!strncmp(p, "idem", 4))
+	  if (!memcmp(p, "idem", 4))
 	    {
 	      for (i=fp0; i<=fp1; i++)
 		addpair(i,i);
diff --git a/scripts/dtc/dtc.h b/scripts/dtc/dtc.h
index 08d54c8..881ecbf 100644
--- a/scripts/dtc/dtc.h
+++ b/scripts/dtc/dtc.h
@@ -77,7 +77,7 @@ typedef uint32_t cell_t;
 
 
 #define streq(a, b)	(strcmp((a), (b)) == 0)
-#define strneq(a, b, n)	(strncmp((a), (b), (n)) == 0)
+#define strneq(a, b, n)	(memcmp((a), (b), (n)) == 0)
 
 #define ALIGN(x, a)	(((x) + (a) - 1) & ~((a) - 1))
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 60dd3eb..3c2d62d 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -638,7 +638,7 @@ int main(int argc, char **argv)
 		for (i = 1; i < argc; i++) {
 			if(strcmp(argv[i], "--all-symbols") == 0)
 				all_symbols = 1;
-			else if (strncmp(argv[i], "--symbol-prefix=", 16) == 0) {
+			else if (memcmp(argv[i], "--symbol-prefix=", 16) == 0) {
 				char *p = &argv[i][16];
 				/* skip quote */
 				if ((*p == '"' && *(p+2) == '"') || (*p == '\'' && *(p+2) == '\''))
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 9df8011..443136b 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -253,7 +253,7 @@ load:
 			if (!p)
 				continue;
 			*p++ = 0;
-			if (strncmp(p, "is not set", 10))
+			if (memcmp(p, "is not set", 10))
 				continue;
 			if (def == S_DEF_USER) {
 				sym = sym_find(line + 2 + strlen(CONFIG_));
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 33122ca..ca973b9 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -546,15 +546,15 @@ static int ignore_undef_symbol(struct elf_info *info, const char *symname)
 		return 1;
 	if (info->hdr->e_machine == EM_PPC)
 		/* Special register function linked on all modules during final link of .ko */
-		if (strncmp(symname, "_restgpr_", sizeof("_restgpr_") - 1) == 0 ||
-		    strncmp(symname, "_savegpr_", sizeof("_savegpr_") - 1) == 0 ||
-		    strncmp(symname, "_rest32gpr_", sizeof("_rest32gpr_") - 1) == 0 ||
-		    strncmp(symname, "_save32gpr_", sizeof("_save32gpr_") - 1) == 0)
+		if (memcmp(symname, "_restgpr_", sizeof("_restgpr_") - 1) == 0 ||
+		    memcmp(symname, "_savegpr_", sizeof("_savegpr_") - 1) == 0 ||
+		    memcmp(symname, "_rest32gpr_", sizeof("_rest32gpr_") - 1) == 0 ||
+		    memcmp(symname, "_save32gpr_", sizeof("_save32gpr_") - 1) == 0)
 			return 1;
 	if (info->hdr->e_machine == EM_PPC64)
 		/* Special register function linked on all modules during final link of .ko */
-		if (strncmp(symname, "_restgpr0_", sizeof("_restgpr0_") - 1) == 0 ||
-		    strncmp(symname, "_savegpr0_", sizeof("_savegpr0_") - 1) == 0)
+		if (memcmp(symname, "_restgpr0_", sizeof("_restgpr0_") - 1) == 0 ||
+		    memcmp(symname, "_savegpr0_", sizeof("_savegpr0_") - 1) == 0)
 			return 1;
 	/* Do not ignore this symbol */
 	return 0;
@@ -575,7 +575,7 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
 		break;
 	case SHN_ABS:
 		/* CRC'd symbol */
-		if (strncmp(symname, CRC_PFX, strlen(CRC_PFX)) == 0) {
+		if (memcmp(symname, CRC_PFX, strlen(CRC_PFX)) == 0) {
 			crc = (unsigned int) sym->st_value;
 			sym_update_crc(symname + strlen(CRC_PFX), mod, crc,
 					export);
@@ -619,7 +619,7 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
 		break;
 	default:
 		/* All exported symbols */
-		if (strncmp(symname, KSYMTAB_PFX, strlen(KSYMTAB_PFX)) == 0) {
+		if (memcmp(symname, KSYMTAB_PFX, strlen(KSYMTAB_PFX)) == 0) {
 			sym_add_exported(symname + strlen(KSYMTAB_PFX), mod,
 					export);
 		}
@@ -665,7 +665,7 @@ static char *get_next_modinfo(void *modinfo, unsigned long modinfo_len,
 	}
 
 	for (p = modinfo; p; p = next_string(p, &size)) {
-		if (strncmp(p, tag, taglen) == 0 && p[taglen] == '=')
+		if (memcmp(p, tag, taglen) == 0 && p[taglen] == '=')
 			return p + taglen + 1;
 	}
 	return NULL;
@@ -765,12 +765,12 @@ static int match(const char *sym, const char * const pat[])
 		}
 		/* "foo*" */
 		else if (*endp == '*') {
-			if (strncmp(sym, p, strlen(p) - 1) == 0)
+			if (memcmp(sym, p, strlen(p) - 1) == 0)
 				return 1;
 		}
 		/* "foo$" */
 		else if (*endp == '$') {
-			if (strncmp(sym, p, strlen(p) - 1) == 0) {
+			if (memcmp(sym, p, strlen(p) - 1) == 0) {
 				if (number_prefix(sym + strlen(p) - 1))
 					return 1;
 			}
@@ -1073,13 +1073,13 @@ static int secref_whitelist(const struct sectioncheck *mismatch,
 	/* Check for pattern 1 */
 	if (match(tosec, init_data_sections) &&
 	    match(fromsec, data_sections) &&
-	    (strncmp(fromsym, "__param", strlen("__param")) == 0))
+	    (memcmp(fromsym, "__param", strlen("__param")) == 0))
 		return 0;
 
 	/* Check for pattern 1a */
 	if (strcmp(tosec, ".init.text") == 0 &&
 	    match(fromsec, data_sections) &&
-	    (strncmp(fromsym, "__param_ops_", strlen("__param_ops_")) == 0))
+	    (memcmp(fromsym, "__param_ops_", strlen("__param_ops_")) == 0))
 		return 0;
 
 	/* Check for pattern 2 */
@@ -1822,7 +1822,7 @@ static void add_staging_flag(struct buffer *b, const char *name)
 {
 	static const char *staging_dir = "drivers/staging";
 
-	if (strncmp(staging_dir, name, strlen(staging_dir)) == 0)
+	if (memcmp(staging_dir, name, strlen(staging_dir)) == 0)
 		buf_printf(b, "\nMODULE_INFO(staging, \"Y\");\n");
 }
 
diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
index ecf9c7d..150bc0e 100644
--- a/scripts/mod/sumversion.c
+++ b/scripts/mod/sumversion.c
@@ -340,7 +340,7 @@ static int parse_source_files(const char *objfile, struct md4_ctx *md)
 	*/
 	while ((line = get_next_line(&pos, file, flen)) != NULL) {
 		char* p = line;
-		if (strncmp(line, "deps_", sizeof("deps_")-1) == 0) {
+		if (memcmp(line, "deps_", sizeof("deps_")-1) == 0) {
 			check_files = 1;
 			continue;
 		}
@@ -468,7 +468,7 @@ static int strip_rcs_crap(char *version)
 {
 	unsigned int len, full_len;
 
-	if (strncmp(version, "$Revision", strlen("$Revision")) != 0)
+	if (memcmp(version, "$Revision", strlen("$Revision")) != 0)
 		return 0;
 
 	/* Space for version string follows. */
diff --git a/scripts/unifdef.c b/scripts/unifdef.c
index 44d3978..1620ffa 100644
--- a/scripts/unifdef.c
+++ b/scripts/unifdef.c
@@ -566,7 +566,7 @@ parseline(void)
 		cp = skipsym(cp);
 		kwlen = cp - keyword;
 		/* no way can we deal with a continuation inside a keyword */
-		if (strncmp(cp, "\\\n", 2) == 0)
+		if (memcmp(cp, "\\\n", 2) == 0)
 			Eioccc();
 		if (strlcmp("ifdef", keyword, kwlen) == 0 ||
 		    strlcmp("ifndef", keyword, kwlen) == 0) {
@@ -753,7 +753,7 @@ eval_unary(const struct ops *ops, int *valp, const char **cpp)
 			return (LT_ERROR);
 		lt = *valp ? LT_TRUE : LT_FALSE;
 		cp = skipsym(cp);
-	} else if (strncmp(cp, "defined", 7) == 0 && endsym(cp[7])) {
+	} else if (memcmp(cp, "defined", 7) == 0 && endsym(cp[7])) {
 		cp = skipcomment(cp+7);
 		debug("eval%d defined", ops - eval_ops);
 		if (*cp == '(') {
@@ -821,7 +821,7 @@ eval_table(const struct ops *ops, int *valp, const char **cpp)
 	for (;;) {
 		cp = skipcomment(cp);
 		for (op = ops->op; op->str != NULL; op++)
-			if (strncmp(cp, op->str, strlen(op->str)) == 0)
+			if (memcmp(cp, op->str, strlen(op->str)) == 0)
 				break;
 		if (op->str == NULL)
 			break;
@@ -875,28 +875,28 @@ skipcomment(const char *cp)
 	}
 	while (*cp != '\0')
 		/* don't reset to LS_START after a line continuation */
-		if (strncmp(cp, "\\\n", 2) == 0)
+		if (memcmp(cp, "\\\n", 2) == 0)
 			cp += 2;
 		else switch (incomment) {
 		case NO_COMMENT:
-			if (strncmp(cp, "/\\\n", 3) == 0) {
+			if (memcmp(cp, "/\\\n", 3) == 0) {
 				incomment = STARTING_COMMENT;
 				cp += 3;
-			} else if (strncmp(cp, "/*", 2) == 0) {
+			} else if (memcmp(cp, "/*", 2) == 0) {
 				incomment = C_COMMENT;
 				cp += 2;
-			} else if (strncmp(cp, "//", 2) == 0) {
+			} else if (memcmp(cp, "//", 2) == 0) {
 				incomment = CXX_COMMENT;
 				cp += 2;
-			} else if (strncmp(cp, "\'", 1) == 0) {
+			} else if (memcmp(cp, "\'", 1) == 0) {
 				incomment = CHAR_LITERAL;
 				linestate = LS_DIRTY;
 				cp += 1;
-			} else if (strncmp(cp, "\"", 1) == 0) {
+			} else if (memcmp(cp, "\"", 1) == 0) {
 				incomment = STRING_LITERAL;
 				linestate = LS_DIRTY;
 				cp += 1;
-			} else if (strncmp(cp, "\n", 1) == 0) {
+			} else if (memcmp(cp, "\n", 1) == 0) {
 				linestate = LS_START;
 				cp += 1;
 			} else if (strchr(" \t", *cp) != NULL) {
@@ -905,7 +905,7 @@ skipcomment(const char *cp)
 				return (cp);
 			continue;
 		case CXX_COMMENT:
-			if (strncmp(cp, "\n", 1) == 0) {
+			if (memcmp(cp, "\n", 1) == 0) {
 				incomment = NO_COMMENT;
 				linestate = LS_START;
 			}
@@ -922,7 +922,7 @@ skipcomment(const char *cp)
 					cp += 1;
 				else
 					cp += 2;
-			} else if (strncmp(cp, "\n", 1) == 0) {
+			} else if (memcmp(cp, "\n", 1) == 0) {
 				if (incomment == CHAR_LITERAL)
 					error("unterminated char literal");
 				else
@@ -931,10 +931,10 @@ skipcomment(const char *cp)
 				cp += 1;
 			continue;
 		case C_COMMENT:
-			if (strncmp(cp, "*\\\n", 3) == 0) {
+			if (memcmp(cp, "*\\\n", 3) == 0) {
 				incomment = FINISHING_COMMENT;
 				cp += 3;
-			} else if (strncmp(cp, "*/", 2) == 0) {
+			} else if (memcmp(cp, "*/", 2) == 0) {
 				incomment = NO_COMMENT;
 				cp += 2;
 			} else
diff --git a/security/apparmor/include/apparmor.h b/security/apparmor/include/apparmor.h
index 38ccaea..1bb6cb0 100644
--- a/security/apparmor/include/apparmor.h
+++ b/security/apparmor/include/apparmor.h
@@ -65,7 +65,7 @@ void kvfree(void *buffer);
  */
 static inline bool aa_strneq(const char *str, const char *sub, int len)
 {
-	return !strncmp(str, sub, len) && !str[len];
+	return !memcmp(str, sub, len) && !str[len];
 }
 
 /**
diff --git a/security/apparmor/path.c b/security/apparmor/path.c
index 36cc0cc..0afebae 100644
--- a/security/apparmor/path.c
+++ b/security/apparmor/path.c
@@ -114,7 +114,7 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
 	if (!connected) {
 		/* is the disconnect path a sysctl? */
 		if (tmp.dentry->d_sb->s_magic == PROC_SUPER_MAGIC &&
-		    strncmp(*name, "/sys/", 5) == 0) {
+		    memcmp(*name, "/sys/", 5) == 0) {
 			/* TODO: convert over to using a per namespace
 			 * control instead of hard coded /proc
 			 */
diff --git a/security/commoncap.c b/security/commoncap.c
index 64c2ed9..7d08fb4 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -568,7 +568,7 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
 		return 0;
 	}
 
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+	if (!memcmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -594,7 +594,7 @@ int cap_inode_removexattr(struct dentry *dentry, const char *name)
 		return 0;
 	}
 
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+	if (!memcmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 203de97..066d910 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -30,7 +30,7 @@ int ima_initialized;
 char *ima_hash = "sha1";
 static int __init hash_setup(char *str)
 {
-	if (strncmp(str, "md5", 3) == 0)
+	if (memcmp(str, "md5", 3) == 0)
 		ima_hash = "md5";
 	return 1;
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 65fa8bf..86ff933 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -401,7 +401,7 @@ static int sb_finish_set_opts(struct super_block *sb)
 		sbsec->flags &= ~SE_SBLABELSUPP;
 
 	/* Special handling for sysfs. Is genfs but also has setxattr handler*/
-	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs")) == 0)
+	if (memcmp(sb->s_type->name, "sysfs", sizeof("sysfs")) == 0)
 		sbsec->flags |= SE_SBLABELSUPP;
 
 	/* Initialize the root inode. */
@@ -2681,7 +2681,7 @@ static int selinux_inode_setotherxattr(struct dentry *dentry, const char *name)
 {
 	const struct cred *cred = current_cred();
 
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+	if (!memcmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof XATTR_SECURITY_PREFIX - 1)) {
 		if (!strcmp(name, XATTR_NAME_CAPS)) {
 			if (!capable(CAP_SETFCAP))
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 223c1ff..13fe7de 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2235,7 +2235,7 @@ int security_genfs_sid(const char *fstype,
 	for (c = genfs->head; c; c = c->next) {
 		len = strlen(c->u.name);
 		if ((!c->v.sclass || sclass == c->v.sclass) &&
-		    (strncmp(c->u.name, path, len) == 0))
+		    (memcmp(c->u.name, path, len) == 0))
 			break;
 	}
 
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index f4fac64..0f11888 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -336,7 +336,7 @@ struct smack_known *smk_import_entry(const char *string, int len)
 
 	found = 0;
 	list_for_each_entry_rcu(skp, &smack_known_list, list) {
-		if (strncmp(skp->smk_known, smack, SMK_MAXLEN) == 0) {
+		if (memcmp(skp->smk_known, smack, SMK_MAXLEN) == 0) {
 			found = 1;
 			break;
 		}
@@ -423,7 +423,7 @@ u32 smack_to_secid(const char *smack)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(skp, &smack_known_list, list) {
-		if (strncmp(skp->smk_known, smack, SMK_MAXLEN) == 0) {
+		if (memcmp(skp->smk_known, smack, SMK_MAXLEN) == 0) {
 			rcu_read_unlock();
 			return skp->smk_secid;
 		}
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 489a85a..556e96d 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -290,23 +290,23 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 		if (commap != NULL)
 			*commap++ = '\0';
 
-		if (strncmp(op, SMK_FSHAT, strlen(SMK_FSHAT)) == 0) {
+		if (memcmp(op, SMK_FSHAT, strlen(SMK_FSHAT)) == 0) {
 			op += strlen(SMK_FSHAT);
 			nsp = smk_import(op, 0);
 			if (nsp != NULL)
 				sp->smk_hat = nsp;
-		} else if (strncmp(op, SMK_FSFLOOR, strlen(SMK_FSFLOOR)) == 0) {
+		} else if (memcmp(op, SMK_FSFLOOR, strlen(SMK_FSFLOOR)) == 0) {
 			op += strlen(SMK_FSFLOOR);
 			nsp = smk_import(op, 0);
 			if (nsp != NULL)
 				sp->smk_floor = nsp;
-		} else if (strncmp(op, SMK_FSDEFAULT,
+		} else if (memcmp(op, SMK_FSDEFAULT,
 				   strlen(SMK_FSDEFAULT)) == 0) {
 			op += strlen(SMK_FSDEFAULT);
 			nsp = smk_import(op, 0);
 			if (nsp != NULL)
 				sp->smk_default = nsp;
-		} else if (strncmp(op, SMK_FSROOT, strlen(SMK_FSROOT)) == 0) {
+		} else if (memcmp(op, SMK_FSROOT, strlen(SMK_FSROOT)) == 0) {
 			op += strlen(SMK_FSROOT);
 			nsp = smk_import(op, 0);
 			if (nsp != NULL)
diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 7556315..e266b95 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -306,9 +306,9 @@ static s8 tomoyo_find_yesno(const char *string, const char *find)
 	const char *cp = strstr(string, find);
 	if (cp) {
 		cp += strlen(find);
-		if (!strncmp(cp, "=yes", 4))
+		if (!memcmp(cp, "=yes", 4))
 			return 1;
-		else if (!strncmp(cp, "=no", 3))
+		else if (!memcmp(cp, "=no", 3))
 			return 0;
 	}
 	return -1;
@@ -757,7 +757,7 @@ static bool tomoyo_select_one(struct tomoyo_io_buffer *head, const char *data)
 			domain = tomoyo_real_domain(p);
 		read_unlock(&tasklist_lock);
 		rcu_read_unlock();
-	} else if (!strncmp(data, "domain=", 7)) {
+	} else if (!memcmp(data, "domain=", 7)) {
 		if (tomoyo_domain_def(data + 7))
 			domain = tomoyo_find_domain(data + 7);
 	} else
diff --git a/security/tomoyo/file.c b/security/tomoyo/file.c
index 9d32f18..f1eb003 100644
--- a/security/tomoyo/file.c
+++ b/security/tomoyo/file.c
@@ -1145,7 +1145,7 @@ int tomoyo_write_file(char *data, struct tomoyo_domain_info *domain,
 	u8 type;
 	if (!tomoyo_tokenize(data, w, sizeof(w)) || !w[1][0])
 		return -EINVAL;
-	if (strncmp(w[0], "allow_", 6))
+	if (memcmp(w[0], "allow_", 6))
 		goto out;
 	w[0] += 6;
 	for (type = 0; type < TOMOYO_MAX_PATH_OPERATION; type++) {
diff --git a/security/tomoyo/util.c b/security/tomoyo/util.c
index 9bfc1ee..b9f29ca 100644
--- a/security/tomoyo/util.c
+++ b/security/tomoyo/util.c
@@ -200,7 +200,7 @@ bool tomoyo_str_starts(char **src, const char *find)
 	const int len = strlen(find);
 	char *tmp = *src;
 
-	if (strncmp(tmp, find, len))
+	if (memcmp(tmp, find, len))
 		return false;
 	tmp += len;
 	*src = tmp;
@@ -377,7 +377,7 @@ bool tomoyo_correct_path(const char *filename)
  */
 bool tomoyo_correct_domain(const unsigned char *domainname)
 {
-	if (!domainname || strncmp(domainname, TOMOYO_ROOT_NAME,
+	if (!domainname || memcmp(domainname, TOMOYO_ROOT_NAME,
 				   TOMOYO_ROOT_NAME_LEN))
 		goto out;
 	domainname += TOMOYO_ROOT_NAME_LEN;
@@ -408,7 +408,7 @@ bool tomoyo_correct_domain(const unsigned char *domainname)
  */
 bool tomoyo_domain_def(const unsigned char *buffer)
 {
-	return !strncmp(buffer, TOMOYO_ROOT_NAME, TOMOYO_ROOT_NAME_LEN);
+	return !memcmp(buffer, TOMOYO_ROOT_NAME, TOMOYO_ROOT_NAME_LEN);
 }
 
 /**
@@ -557,7 +557,7 @@ static bool tomoyo_file_matches_pattern2(const char *filename,
 		case '2':
 		case '3':
 			if (c == '\\' && tomoyo_byte_range(filename + 1)
-			    && strncmp(filename + 1, pattern, 3) == 0) {
+			    && memcmp(filename + 1, pattern, 3) == 0) {
 				filename += 3;
 				pattern += 2;
 				break;
@@ -757,7 +757,7 @@ bool tomoyo_path_matches_pattern(const struct tomoyo_path_info *filename,
 	if (filename->is_dir != pattern->is_dir)
 		return false;
 	/* Compare the initial length without patterns. */
-	if (strncmp(f, p, len))
+	if (memcmp(f, p, len))
 		return false;
 	f += len;
 	p += len;
diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index 3ff8cc5..0f03dc1 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -172,7 +172,7 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 
 	if (strlen(np->name) != 5)
 		return 0;
-	if (strncmp(np->name, "i2s-", 4))
+	if (memcmp(np->name, "i2s-", 4))
 		return 0;
 
 	dev = kzalloc(sizeof(struct i2sbus_dev), GFP_KERNEL);
diff --git a/sound/core/control.c b/sound/core/control.c
index 45a8180..2eabf6f 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -551,7 +551,7 @@ struct snd_kcontrol *snd_ctl_find_id(struct snd_card *card,
 			continue;
 		if (kctl->id.subdevice != id->subdevice)
 			continue;
-		if (strncmp(kctl->id.name, id->name, sizeof(kctl->id.name)))
+		if (memcmp(kctl->id.name, id->name, sizeof(kctl->id.name)))
 			continue;
 		if (kctl->id.index > id->index)
 			continue;
diff --git a/sound/core/info.c b/sound/core/info.c
index 7077f60..a26d2e6 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -62,7 +62,7 @@ int snd_info_check_reserved_words(const char *str)
 			return 0;
 		xstr++;
 	}
-	if (!strncmp(str, "card", 4))
+	if (!memcmp(str, "card", 4))
 		return 0;
 	return 1;
 }
diff --git a/sound/core/seq/seq_queue.c b/sound/core/seq/seq_queue.c
index e7a8e9e..74e941d 100644
--- a/sound/core/seq/seq_queue.c
+++ b/sound/core/seq/seq_queue.c
@@ -240,7 +240,7 @@ struct snd_seq_queue *snd_seq_queue_find_name(char *name)
 
 	for (i = 0; i < SNDRV_SEQ_MAX_QUEUES; i++) {
 		if ((q = queueptr(i)) != NULL) {
-			if (strncmp(q->name, name, sizeof(q->name)) == 0)
+			if (memcmp(q->name, name, sizeof(q->name)) == 0)
 				return q;
 			queuefree(q);
 		}
diff --git a/sound/isa/gus/interwave.c b/sound/isa/gus/interwave.c
index c7b80e4..3ee7b1f 100644
--- a/sound/isa/gus/interwave.c
+++ b/sound/isa/gus/interwave.c
@@ -447,7 +447,7 @@ static void __devinit snd_interwave_detect_memory(struct snd_gus_card * gus)
 		       iwave[0], iwave[1], iwave[2], iwave[3],
 		       iwave[4], iwave[5], iwave[6], iwave[7]);
 #endif
-		if (strncmp(iwave, "INTRWAVE", 8))
+		if (memcmp(iwave, "INTRWAVE", 8))
 			continue;	/* first check */
 		csum = 0;
 		for (i = 0; i < sizeof(struct rom_hdr); i++)
diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
index 9a8bbf6..848fec5 100644
--- a/sound/isa/sc6000.c
+++ b/sound/isa/sc6000.c
@@ -414,7 +414,7 @@ static int __devinit sc6000_init_board(char __iomem *vport,
 	 * My SC-6000 card return "SC-6000" in DSPCopyright, so
 	 * if we have something different, we have to be warned.
 	 */
-	if (strncmp("SC-6000", answer, 7))
+	if (memcmp("SC-6000", answer, 7))
 		snd_printk(KERN_WARNING "Warning: non SC-6000 audio card!\n");
 
 	if (sc6000_dsp_get_answer(vport, GET_DSP_VERSION, version, 2) < 2) {
diff --git a/sound/isa/sscape.c b/sound/isa/sscape.c
index e2d5d2d..a154163 100644
--- a/sound/isa/sscape.c
+++ b/sound/isa/sscape.c
@@ -1269,7 +1269,7 @@ static int __devinit sscape_pnp_detect(struct pnp_card_link *pcard,
 	/*
 	 * Identify card model ...
 	 */
-	if (!strncmp("ENS4081", pid->id, 7))
+	if (!memcmp("ENS4081", pid->id, 7))
 		sscape->type = SSCAPE_VIVO;
 	else
 		sscape->type = SSCAPE_PNP;
diff --git a/sound/oss/au1550_ac97.c b/sound/oss/au1550_ac97.c
index a8f626d..03cf294 100644
--- a/sound/oss/au1550_ac97.c
+++ b/sound/oss/au1550_ac97.c
@@ -2134,7 +2134,7 @@ au1550_setup(char *options)
 	while ((this_opt = strsep(&options, ","))) {
 		if (!*this_opt)
 			continue;
-		if (!strncmp(this_opt, "vra", 3)) {
+		if (!memcmp(this_opt, "vra", 3)) {
 			vra = 1;
 		}
 	}
diff --git a/sound/oss/sb_card.c b/sound/oss/sb_card.c
index 84ef4d0..d9303b5 100644
--- a/sound/oss/sb_card.c
+++ b/sound/oss/sb_card.c
@@ -177,7 +177,7 @@ static void sb_dev2cfg(struct pnp_dev *dev, struct sb_card_config *scc)
 
 	/* All clones layout their PnP tables differently and some use
 	   different logical devices for the MPU */
-	if(!strncmp("CTL",scc->card_id,3)) {
+	if(!memcmp("CTL",scc->card_id,3)) {
 		scc->conf.io_base   = pnp_port_start(dev,0);
 		scc->conf.irq       = pnp_irq(dev,0);
 		scc->conf.dma       = pnp_dma(dev,0);
@@ -185,14 +185,14 @@ static void sb_dev2cfg(struct pnp_dev *dev, struct sb_card_config *scc)
 		scc->mpucnf.io_base = pnp_port_start(dev,1);
 		return;
 	}
-	if(!strncmp("tBA",scc->card_id,3)) {
+	if(!memcmp("tBA",scc->card_id,3)) {
 		scc->conf.io_base   = pnp_port_start(dev,0);
 		scc->conf.irq       = pnp_irq(dev,0);
 		scc->conf.dma       = pnp_dma(dev,0);
 		scc->conf.dma2      = pnp_dma(dev,1);
 		return;
 	}
-	if(!strncmp("ESS",scc->card_id,3)) {
+	if(!memcmp("ESS",scc->card_id,3)) {
 		scc->conf.io_base   = pnp_port_start(dev,0);
 		scc->conf.irq       = pnp_irq(dev,0);
 		scc->conf.dma       = pnp_dma(dev,0);
@@ -200,21 +200,21 @@ static void sb_dev2cfg(struct pnp_dev *dev, struct sb_card_config *scc)
 	       	scc->mpucnf.io_base = pnp_port_start(dev,2);
 		return;
 	}
-	if(!strncmp("CMI",scc->card_id,3)) {
+	if(!memcmp("CMI",scc->card_id,3)) {
 		scc->conf.io_base = pnp_port_start(dev,0);
 		scc->conf.irq     = pnp_irq(dev,0);
 		scc->conf.dma     = pnp_dma(dev,0);
 		scc->conf.dma2    = pnp_dma(dev,1);
 		return;
 	}
-	if(!strncmp("RWB",scc->card_id,3)) {
+	if(!memcmp("RWB",scc->card_id,3)) {
 		scc->conf.io_base = pnp_port_start(dev,0);
 		scc->conf.irq     = pnp_irq(dev,0);
 		scc->conf.dma     = pnp_dma(dev,0);
 		return;
 	}
-	if(!strncmp("ALS",scc->card_id,3)) {
-		if(!strncmp("ALS0007",scc->card_id,7)) {
+	if(!memcmp("ALS",scc->card_id,3)) {
+		if(!memcmp("ALS0007",scc->card_id,7)) {
 			scc->conf.io_base = pnp_port_start(dev,0);
 			scc->conf.irq     = pnp_irq(dev,0);
 			scc->conf.dma     = pnp_dma(dev,0);
@@ -226,7 +226,7 @@ static void sb_dev2cfg(struct pnp_dev *dev, struct sb_card_config *scc)
 		}
 		return;
 	}
-	if(!strncmp("RTL",scc->card_id,3)) {
+	if(!memcmp("RTL",scc->card_id,3)) {
 		scc->conf.io_base = pnp_port_start(dev,0);
 		scc->conf.irq     = pnp_irq(dev,0);
 		scc->conf.dma     = pnp_dma(dev,1);
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 644e3f1..0e65202 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -4785,7 +4785,7 @@ int snd_hda_add_imux_item(struct hda_input_mux *imux, const char *label,
 		return -EINVAL;
 	}
 	for (i = 0; i < imux->num_items; i++) {
-		if (!strncmp(label, imux->items[i].label, strlen(label)))
+		if (!memcmp(label, imux->items[i].label, strlen(label)))
 			label_idx++;
 	}
 	if (type_idx)
diff --git a/sound/pci/hda/hda_eld.c b/sound/pci/hda/hda_eld.c
index cb0c23a..1d746de 100644
--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -534,7 +534,7 @@ static void hdmi_write_eld_info(struct snd_info_entry *entry,
 			e->spk_alloc = val;
 		else if (!strcmp(name, "sad_count"))
 			e->sad_count = val;
-		else if (!strncmp(name, "sad", 3)) {
+		else if (!memcmp(name, "sad", 3)) {
 			sname = name + 4;
 			n = name[3] - '0';
 			if (name[4] >= '0' && name[4] <= '9') {
diff --git a/sound/pci/oxygen/oxygen_mixer.c b/sound/pci/oxygen/oxygen_mixer.c
index 2849b36..b84e6ad 100644
--- a/sound/pci/oxygen/oxygen_mixer.c
+++ b/sound/pci/oxygen/oxygen_mixer.c
@@ -972,7 +972,7 @@ static int add_controls(struct oxygen *chip,
 		if (!strcmp(template.name, "Stereo Upmixing") &&
 		    chip->model.dac_channels == 2)
 			continue;
-		if (!strncmp(template.name, "CD Capture ", 11) &&
+		if (!memcmp(template.name, "CD Capture ", 11) &&
 		    !(chip->model.device_config & AC97_CD_INPUT))
 			continue;
 		if (!strcmp(template.name, "Master Playback Volume") &&
diff --git a/sound/pci/oxygen/xonar_pcm179x.c b/sound/pci/oxygen/xonar_pcm179x.c
index d491fd6..b165993 100644
--- a/sound/pci/oxygen/xonar_pcm179x.c
+++ b/sound/pci/oxygen/xonar_pcm179x.c
@@ -922,7 +922,7 @@ static const DECLARE_TLV_DB_SCALE(pcm1796_db_scale, -6000, 50, 0);
 
 static int xonar_d2_control_filter(struct snd_kcontrol_new *template)
 {
-	if (!strncmp(template->name, "CD Capture ", 11))
+	if (!memcmp(template->name, "CD Capture ", 11))
 		/* CD in is actually connected to the video in pin */
 		template->private_value ^= AC97_CD ^ AC97_VIDEO;
 	return 0;
diff --git a/sound/ppc/keywest.c b/sound/ppc/keywest.c
index 8f064c7..9a4bfb4 100644
--- a/sound/ppc/keywest.c
+++ b/sound/ppc/keywest.c
@@ -51,7 +51,7 @@ static int keywest_attach_adapter(struct i2c_adapter *adapter)
 	if (! keywest_ctx)
 		return -EINVAL;
 
-	if (strncmp(adapter->name, "mac-io", 6))
+	if (memcmp(adapter->name, "mac-io", 6))
 		return 0; /* ignored */
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
diff --git a/sound/ppc/tumbler.c b/sound/ppc/tumbler.c
index 961d982..4402fa7 100644
--- a/sound/ppc/tumbler.c
+++ b/sound/ppc/tumbler.c
@@ -1141,7 +1141,7 @@ static long tumbler_find_device(const char *device, const char *platform,
 	} else {
 		const u32 *prop = NULL;
 		gp->active_state = IS_G4DA
-				&& !strncmp(device, "keywest-gpio1", 13);
+				&& !memcmp(device, "keywest-gpio1", 13);
 		gp->active_val = 0x4;
 		gp->inactive_val = 0x5;
 		/* Here are some crude hacks to extract the GPIO polarity and
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 441285a..4bedf55 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2582,7 +2582,7 @@ int snd_soc_limit_volume(struct snd_soc_codec *codec,
 		return -EINVAL;
 
 	list_for_each_entry(kctl, &card->controls, list) {
-		if (!strncmp(kctl->id.name, name, sizeof(kctl->id.name))) {
+		if (!memcmp(kctl->id.name, name, sizeof(kctl->id.name))) {
 			found = 1;
 			break;
 		}
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 31f60a2..220cdbb 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -765,7 +765,7 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __used)
 
 	symbol__init();
 
-	if (!strncmp(argv[0], "rec", 3)) {
+	if (!memcmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
 	} else if (!strcmp(argv[0], "stat")) {
 		setup_cpunode_map();
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 34d1e85..f323948 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -127,15 +127,15 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __used)
 		file_name = name_buffer;
 	}
 
-	if (!strncmp(argv[0], "rec", 3))
+	if (!memcmp(argv[0], "rec", 3))
 		return __cmd_record(argc, argv);
-	else if (!strncmp(argv[0], "rep", 3))
+	else if (!memcmp(argv[0], "rep", 3))
 		return __cmd_report(argc, argv);
-	else if (!strncmp(argv[0], "diff", 4))
+	else if (!memcmp(argv[0], "diff", 4))
 		return cmd_diff(argc, argv, NULL);
-	else if (!strncmp(argv[0], "top", 3))
+	else if (!memcmp(argv[0], "top", 3))
 		return cmd_top(argc, argv, NULL);
-	else if (!strncmp(argv[0], "buildid-list", 12))
+	else if (!memcmp(argv[0], "buildid-list", 12))
 		return __cmd_buildid_list(argc, argv);
 	else
 		usage_with_options(kvm_usage, kvm_options);
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 821c158..5bfdaea 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -971,9 +971,9 @@ int cmd_lock(int argc, const char **argv, const char *prefix __used)
 	if (!argc)
 		usage_with_options(lock_usage, lock_options);
 
-	if (!strncmp(argv[0], "rec", 3)) {
+	if (!memcmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
-	} else if (!strncmp(argv[0], "report", 6)) {
+	} else if (!memcmp(argv[0], "report", 6)) {
 		trace_handler = &report_lock_ops;
 		if (argc) {
 			argc = parse_options(argc, argv,
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5de405d..82b6f8b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -389,16 +389,16 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 		return -1;
 
 	/* get the output mode */
-	if (!strncmp(tok, "graph", strlen(arg)))
+	if (!memcmp(tok, "graph", strlen(arg)))
 		callchain_param.mode = CHAIN_GRAPH_ABS;
 
-	else if (!strncmp(tok, "flat", strlen(arg)))
+	else if (!memcmp(tok, "flat", strlen(arg)))
 		callchain_param.mode = CHAIN_FLAT;
 
-	else if (!strncmp(tok, "fractal", strlen(arg)))
+	else if (!memcmp(tok, "fractal", strlen(arg)))
 		callchain_param.mode = CHAIN_GRAPH_REL;
 
-	else if (!strncmp(tok, "none", strlen(arg))) {
+	else if (!memcmp(tok, "none", strlen(arg))) {
 		callchain_param.mode = CHAIN_NONE;
 		symbol_conf.use_callchain = false;
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 55f3b5d..afd09d5 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1894,9 +1894,9 @@ int cmd_sched(int argc, const char **argv, const char *prefix __used)
 		return cmd_trace(argc, argv, prefix);
 
 	symbol__init();
-	if (!strncmp(argv[0], "rec", 3)) {
+	if (!memcmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
-	} else if (!strncmp(argv[0], "lat", 3)) {
+	} else if (!memcmp(argv[0], "lat", 3)) {
 		trace_handler = &lat_ops;
 		if (argc > 1) {
 			argc = parse_options(argc, argv, latency_options, latency_usage, 0);
@@ -1909,7 +1909,7 @@ int cmd_sched(int argc, const char **argv, const char *prefix __used)
 		trace_handler = &map_ops;
 		setup_sorting();
 		__cmd_map();
-	} else if (!strncmp(argv[0], "rep", 3)) {
+	} else if (!memcmp(argv[0], "rep", 3)) {
 		trace_handler = &replay_ops;
 		if (argc) {
 			argc = parse_options(argc, argv, replay_options, replay_usage, 0);
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 9bcc38f..02551c6 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1029,7 +1029,7 @@ int cmd_timechart(int argc, const char **argv, const char *prefix __used)
 
 	symbol__init();
 
-	if (argc && !strncmp(argv[0], "rec", 3))
+	if (argc && !memcmp(argv[0], "rec", 3))
 		return __cmd_record(argc, argv);
 	else if (argc)
 		usage_with_options(timechart_usage, options);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index dd62580..33e6704 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -947,8 +947,8 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 	if (!strcmp(name, "_text") ||
 	    !strcmp(name, "_etext") ||
 	    !strcmp(name, "_sinittext") ||
-	    !strncmp("init_module", name, 11) ||
-	    !strncmp("cleanup_module", name, 14) ||
+	    !memcmp("init_module", name, 11) ||
+	    !memcmp("cleanup_module", name, 14) ||
 	    strstr(name, "_text_start") ||
 	    strstr(name, "_text_end"))
 		return 1;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 86cfe38..bd0f962 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -387,7 +387,7 @@ static char *ends_with(char *str, const char *suffix)
 
 	if (strlen(str) > suffix_len) {
 		p = str + strlen(str) - suffix_len;
-		if (!strncmp(p, suffix, suffix_len))
+		if (!memcmp(p, suffix, suffix_len))
 			return p;
 	}
 
@@ -429,13 +429,13 @@ static int read_script_info(struct script_desc *desc, const char *filename)
 		if (strlen(p) && p[strlen(p) - 1] == '\n')
 			p[strlen(p) - 1] = '\0';
 
-		if (!strncmp(p, "description:", strlen("description:"))) {
+		if (!memcmp(p, "description:", strlen("description:"))) {
 			p += strlen("description:");
 			desc->half_liner = strdup(ltrim(p));
 			continue;
 		}
 
-		if (!strncmp(p, "args:", strlen("args:"))) {
+		if (!memcmp(p, "args:", strlen("args:"))) {
 			p += strlen("args:");
 			desc->args = strdup(ltrim(p));
 			continue;
@@ -629,13 +629,13 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 	argc = parse_options(argc, argv, options, trace_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 
-	if (argc > 1 && !strncmp(argv[0], "rec", strlen("rec"))) {
+	if (argc > 1 && !memcmp(argv[0], "rec", strlen("rec"))) {
 		rec_script_path = get_script_path(argv[1], RECORD_SUFFIX);
 		if (!rec_script_path)
 			return cmd_record(argc, argv, NULL);
 	}
 
-	if (argc > 1 && !strncmp(argv[0], "rep", strlen("rep"))) {
+	if (argc > 1 && !memcmp(argv[0], "rep", strlen("rep"))) {
 		rep_script_path = get_script_path(argv[1], REPORT_SUFFIX);
 		if (!rep_script_path) {
 			fprintf(stderr,
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4af5bd5..a128aef 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -579,7 +579,7 @@ parse_breakpoint_event(const char **strp, struct perf_event_attr *attr)
 	if (!target)
 		return EVT_FAILED;
 
-	if (strncmp(*strp, "mem", target - *strp) != 0)
+	if (memcmp(*strp, "mem", target - *strp) != 0)
 		return EVT_FAILED;
 
 	target++;
@@ -621,12 +621,12 @@ static int check_events(const char *str, unsigned int i)
 	int n;
 
 	n = strlen(event_symbols[i].symbol);
-	if (!strncmp(str, event_symbols[i].symbol, n))
+	if (!memcmp(str, event_symbols[i].symbol, n))
 		return n;
 
 	n = strlen(event_symbols[i].alias);
 	if (n)
-		if (!strncmp(str, event_symbols[i].alias, n))
+		if (!memcmp(str, event_symbols[i].alias, n))
 			return n;
 	return 0;
 }
diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 99d02aa..6a9d9d1 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -224,7 +224,7 @@ static int parse_long_opt(struct parse_opt_ctx_t *p, const char *arg,
 		}
 		if (!rest) {
 			/* abbreviated? */
-			if (!strncmp(options->long_name, arg, arg_end - arg)) {
+			if (!memcmp(options->long_name, arg, arg_end - arg)) {
 is_abbreviated:
 				if (abbrev_option) {
 					/*
@@ -248,7 +248,7 @@ is_abbreviated:
 				goto is_abbreviated;
 			}
 			/* negated? */
-			if (strncmp(arg, "no-", 3))
+			if (memcmp(arg, "no-", 3))
 				continue;
 			flags |= OPT_UNSET;
 			rest = skip_prefix(arg + 3, options->long_name);
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 3b6a529..6321fa3 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -117,7 +117,7 @@ const char *kernel_get_module_path(const char *module)
 
 	if (module) {
 		list_for_each_entry(dso, &machine.kernel_dsos, node) {
-			if (strncmp(dso->short_name + 1, module,
+			if (memcmp(dso->short_name + 1, module,
 				    dso->short_name_len - 2) == 0)
 				goto found;
 		}
diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
index 6783a20..9297d3e 100644
--- a/tools/perf/util/strlist.c
+++ b/tools/perf/util/strlist.c
@@ -128,7 +128,7 @@ struct str_node *strlist__find(struct strlist *self, const char *entry)
 
 static int strlist__parse_list_entry(struct strlist *self, const char *s)
 {
-	if (strncmp(s, "file://", 7) == 0)
+	if (memcmp(s, "file://", 7) == 0)
 		return strlist__load(self, s + 7);
 
 	return strlist__add(self, s);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 0500895..9a88de8 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1430,7 +1430,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 
 	self->adjust_symbols = 0;
 
-	if (strncmp(self->name, "/tmp/perf-", 10) == 0) {
+	if (memcmp(self->name, "/tmp/perf-", 10) == 0) {
 		ret = dso__load_perf_map(self, map, filter);
 		self->origin = ret > 0 ? DSO__ORIG_JAVA_JIT :
 					 DSO__ORIG_NOT_FOUND;
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 73a0222..a80c9a0 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -756,7 +756,7 @@ static int field_is_string(struct format_field *field)
 
 static int field_is_dynamic(struct format_field *field)
 {
-	if (!strncmp(field->type, "__data_loc", 10))
+	if (!memcmp(field->type, "__data_loc", 10))
 		return 1;
 
 	return 0;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7562707..9b43d86 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -159,7 +159,7 @@ extern void disable_buildid_cache(void);
 static inline const char *skip_prefix(const char *str, const char *prefix)
 {
 	size_t len = strlen(prefix);
-	return strncmp(str, prefix, len) ? NULL : str + len;
+	return memcmp(str, prefix, len) ? NULL : str + len;
 }
 
 #ifdef __GLIBC_PREREQ

--------------090909050803010705050900--
