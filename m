Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab2GRKgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:36:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab2GRKgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:36:12 -0400
From: Thomas Renninger <trenn@suse.de>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, initramfs@vger.kernel.org,
        bigeasy@linutronix.de, Thomas Renninger <trenn@suse.de>,
        eric.piel@tremplin-utc.net, vojcek@tlen.pl,
        Lin Ming <ming.m.lin@intel.com>, robert.moore@intel.com
Subject: [PATCH 2/2] ACPI: Override arbitrary ACPI tables via initrd for debugging
Date: Wed, 18 Jul 2012 12:36:04 +0200
Message-Id: <1342607764-66747-3-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1342607764-66747-1-git-send-email-trenn@suse.de>
References: <1342607764-66747-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Details can be found in:
Documentation/acpi/initrd_table_override.txt

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: eric.piel@tremplin-utc.net
CC: vojcek@tlen.pl
CC: Lin Ming <ming.m.lin@intel.com>
CC: lenb@kernel.org
CC: robert.moore@intel.com
CC: hpa@zytor.com
---
 Documentation/acpi/initrd_table_override.txt |  119 ++++++++++++++++
 drivers/acpi/Kconfig                         |   10 ++
 drivers/acpi/osl.c                           |  193 ++++++++++++++++++++++++--
 include/linux/acpi.h                         |    6 +
 include/linux/initrd.h                       |    4 +-
 init/initramfs.c                             |   23 +++-
 init/initrd_early.c                          |   10 ++
 7 files changed, 349 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/acpi/initrd_table_override.txt

diff --git a/Documentation/acpi/initrd_table_override.txt b/Documentation/acpi/initrd_table_override.txt
new file mode 100644
index 0000000..e985dea
--- /dev/null
+++ b/Documentation/acpi/initrd_table_override.txt
@@ -0,0 +1,119 @@
+Overriding ACPI tables via initrd
+=================================
+
+1) Introduction (What is this about)
+2) What is this for
+3) How does it work
+4) References (Where to retrieve userspace tools)
+
+1) What is this about
+---------------------
+
+If ACPI_INITRD_TABLE_OVERRIDE compile option is true, it is possible to
+override nearly any ACPI table provided by the BIOS with an instrumented,
+modified one.
+
+For a full list of ACPI tables that can be overridden, take a look at
+the char *table_sigs[MAX_ACPI_SIGNATURE]; definition in drivers/acpi/osl.c
+All ACPI tables iasl (Intel's ACPI compiler and disassembler) knows should
+be overridable, except:
+   - ACPI_SIG_RSDP (has a signature of 6 bytes)
+   - ACPI_SIG_FACS (does not have an ordinary ACPI table header)
+Both could get implemented as well.
+
+
+2) What is this for
+-------------------
+
+Please keep in mind that this is a debug option.
+ACPI tables should not get overridden for productive use.
+If BIOS ACPI tables are overridden the kernel will get tainted with the
+TAINT_OVERRIDDEN_ACPI_TABLE flag.
+Complain to your platform/BIOS vendor if you find a bug which is that sever
+that a workaround is not accepted in the Linus kernel.
+
+Still, it can and should be enabled in any kernel, because:
+  - There is no functional change with not instrumented initrds
+  - It provides a powerful feature to easily debug and test ACPI BIOS table
+    compatibility with the Linux kernel.
+
+Until now it was only possible to override the DSDT by compiling it into
+the kernel. This is a nightmare when trying to work on ACPI related bugs
+and a lot bugs got stuck because of that.
+Even for people with enough kernel knowledge, building a kernel to try out
+things is very time consuming. Also people may have to browse and modify the
+ACPI interpreter code to find a possible BIOS bug. With this feature, people
+can correct the ACPI tables and try out quickly whether this is the root cause
+that needs to get addressed in the kernel.
+
+This could even ease up testing for BIOS providers who could flush their BIOS
+to test, but overriding table via initrd is much easier and quicker.
+For example one could prepare different initrds overriding NUMA tables with
+different affinity settings. Set up a script, let the machine reboot and
+run tests over night and one can get a picture how these settings influence
+the Linux kernel and which values are best.
+
+People can instrument the dynamic ACPI (ASL) code (for example with debug
+statements showing up in syslog when the ACPI code is processed, etc.),
+to better understand BIOS to OS interfaces, to hunt down ACPI BIOS code related
+bugs quickly or to easier develop ACPI based drivers.
+
+Intstrumenting ACPI code in SSDTs is now much easier. Before, one had to copy
+all SSDTs into the DSDT to compile it into the kernel for testing
+(because only DSDT could get overridden). That's what the acpi_no_auto_ssdt
+boot param is for: the BIOS provided SSDTs are ignored and all have to get
+copied into the DSDT, complicated and time consuming.
+
+Much more use cases, depending on which ACPI parts you are working on...
+
+
+3) How does it work
+-------------------
+
+# Extract the machine's ACPI tables:
+acpidump >acpidump
+acpixtract -a acpidump
+# Disassemble, modify and recompile them:
+iasl -d *.dat
+# For example add this statement into a _PRT (PCI Routing Table) function
+# of the DSDT:
+Store("Hello World", debug)
+iasl -sa *.dsl
+# Add the raw ACPI tables to an uncompressed cpio archive.
+# They must be put into /kernel/firmware/acpi directory inside the cpio
+# archive.
+# If you want to override other firmware files early (for example CPU
+# microcode), you must use only one uncompressed cpio archive and it must
+# be the first. Other, typically compressed cpio archives, must be
+# concatenated on top of the uncompressed one.
+# For further info read the "Accessing initrd data early" chapter in
+# Documtenation/initrd.txt.
+mkdir -p /tmp/early_cpio/kernel/firmware/acpi
+cp TBL1.dat /tmp/early_cpio/kernel/firmware/acpi
+cat TBL2.dat /tmp/early_cpio/kernel/firmware/acpi
+cat TBL3.dat /tmp/early_cpio/kernel/firmware/acpi
+cd /tmp/early_cpio
+find . | cpio -H newc --create > /boot/instrumented_initrd
+cat /boot/initrd >>/boot/instrumented_initrd
+# reboot with increased acpi debug level, e.g. boot params:
+acpi.debug_level=0x2 acpi.debug_layer=0xFFFFFFFF
+# and check your syslog:
+[    1.268089] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
+[    1.272091] [ACPI Debug]  String [0x0B] "HELLO WORLD"
+
+iasl is able to disassemble and recompile quite a lot different,
+also static ACPI tables.
+
+4) Where to retrieve userspace tools
+------------------------------------
+
+iasl and acpixtract are part of Intel's ACPICA project:
+http://acpica.org/
+and should be packaged by distributions (for example in the acpica package
+on SUSE).
+
+acpidump can be found in Len Browns pmtools:
+ftp://kernel.org/pub/linux/kernel/people/lenb/acpi/utils/pmtools/acpidump
+This tool is also part of the acpica package on SUSE.
+Alternatively used ACPI tables can be retrieved via sysfs in latest kernels:
+/sys/firmware/acpi/tables
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 8099895..9d49efb 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -261,6 +261,16 @@ config ACPI_CUSTOM_DSDT
 	bool
 	default ACPI_CUSTOM_DSDT_FILE != ""
 
+config ACPI_INITRD_TABLE_OVERRIDE
+	bool
+	depends on EARLY_INITRD
+	default y
+	help
+	  This option provides functionality to override arbitrary ACPI tables
+	  via initrd. No functional change if no ACPI tables are passed via
+	  initrd, therefore it's safe to say Y.
+	  See Documentation/acpi/initrd_table_override.txt for details
+
 config ACPI_BLACKLIST_YEAR
 	int "Disable ACPI for systems before Jan 1st this year" if X86_32
 	default 0
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index c3881b2..059be34 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -45,6 +45,7 @@
 #include <linux/list.h>
 #include <linux/jiffies.h>
 #include <linux/semaphore.h>
+#include <linux/memblock.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -534,6 +535,126 @@ acpi_os_predefined_override(const struct acpi_predefined_names *init_val,
 	return AE_OK;
 }
 
+#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
+#include <asm/e820.h>
+
+#define ACPI_OVERRIDE_TABLES 10
+
+__initdata static struct{
+	void *data;
+	int size;
+} early_initrd_files[ACPI_OVERRIDE_TABLES];
+static __initdata int table_nr;
+static int all_tables_size;
+static u64 acpi_tables_addr;
+
+/* Copied from acpica/tbutils.c:acpi_tb_checksum() */
+u8 __init acpi_table_checksum(u8 *buffer, u32 length)
+{
+	u8 sum = 0;
+	u8 *end = buffer + length;
+
+	while (buffer < end)
+		sum = (u8) (sum + *(buffer++));
+	return sum;
+}
+
+/* All but ACPI_SIG_RSDP and ACPI_SIG_FACS: */
+static const char *table_sigs[] = {
+	ACPI_SIG_BERT, ACPI_SIG_CPEP, ACPI_SIG_ECDT, ACPI_SIG_EINJ,
+	ACPI_SIG_ERST, ACPI_SIG_HEST, ACPI_SIG_MADT, ACPI_SIG_MSCT,
+	ACPI_SIG_SBST, ACPI_SIG_SLIT, ACPI_SIG_SRAT, ACPI_SIG_ASF,
+	ACPI_SIG_BOOT, ACPI_SIG_DBGP, ACPI_SIG_DMAR, ACPI_SIG_HPET,
+	ACPI_SIG_IBFT, ACPI_SIG_IVRS, ACPI_SIG_MCFG, ACPI_SIG_MCHI,
+	ACPI_SIG_SLIC, ACPI_SIG_SPCR, ACPI_SIG_SPMI, ACPI_SIG_TCPA,
+	ACPI_SIG_UEFI, ACPI_SIG_WAET, ACPI_SIG_WDAT, ACPI_SIG_WDDT,
+	ACPI_SIG_WDRT, ACPI_SIG_DSDT, ACPI_SIG_FADT, ACPI_SIG_PSDT,
+	ACPI_SIG_RSDT, ACPI_SIG_XSDT, ACPI_SIG_SSDT, NULL };
+
+/* Non-fatal errors: Affected tables/files are ignored */
+#define INVALID_TABLE(x, name) \
+	{ printk(KERN_ERR "ACPI OVERRIDE: " x " [%s]\n", name); return 1; }
+
+#define ACPI_HEADER_SIZE sizeof(struct acpi_table_header)
+
+int __init acpi_initrd_table_override(void *data, int size, const char *name)
+{
+	int sig;
+	struct acpi_table_header *table;
+
+	if (table_nr >= ACPI_OVERRIDE_TABLES)
+		INVALID_TABLE("Too much early tables - ignoring", name);
+
+	if (size < sizeof(struct acpi_table_header))
+		INVALID_TABLE("Table smaller than ACPI header", name);
+
+	table = data;
+
+	for (sig = 0; table_sigs[sig]; sig++)
+		if (!memcmp(table->signature, table_sigs[sig], 4))
+			break;
+
+	if (!table_sigs[sig])
+		INVALID_TABLE("Unknown signature", name);
+
+	if (size != table->length)
+		INVALID_TABLE("File length does not match table length", name);
+
+	if (acpi_table_checksum(data, table->length))
+		INVALID_TABLE("Bad table checksum", name);
+
+	printk(KERN_INFO "%4.4s ACPI table found in initrd [%s][%d]\n",
+	       table->signature, name, table->length);
+
+	all_tables_size += table->length;
+	early_initrd_files[table_nr].data =  data;
+	early_initrd_files[table_nr].size =  size;
+	table_nr++;
+	return 0;
+}
+
+void __init acpi_initrd_finalize(void)
+{
+	int i, offset = 0;
+	char *p;
+
+	acpi_tables_addr =
+		memblock_find_in_range(0, max_low_pfn_mapped << PAGE_SHIFT,
+				       all_tables_size, PAGE_SIZE);
+	if (!acpi_tables_addr)
+		panic("Cannot find place for ACPI override tables\n");
+
+	/*
+	 * Only calling e820_add_reserve does not work and the
+	 * tables are invalid (memory got used) later.
+	 * memblock_x86_reserve_range works as expected and the tables
+	 * won't get modified. But it's not enough because ioremap will
+	 * complain later (used by acpi_os_map_memory) that the pages
+	 * that should get mapped are not marked "reserved".
+	 * Both memblock_x86_reserve_range and e820_add_region works fine.
+	 */
+	memblock_reserve(acpi_tables_addr, acpi_tables_addr + all_tables_size);
+	e820_add_region(acpi_tables_addr, all_tables_size, E820_ACPI);
+	update_e820();
+	p = early_ioremap(acpi_tables_addr, all_tables_size);
+
+	for (i = 0; i < table_nr; i++) {
+		memcpy(p + offset, early_initrd_files[i].data,
+		       early_initrd_files[i].size);
+		offset += early_initrd_files[i].size;
+	}
+	early_iounmap(p, all_tables_size);
+}
+#endif /* CONFIG_ACPI_INITRD_TABLE_OVERRIDE */
+
+static void acpi_table_taint(struct acpi_table_header *table)
+{
+	printk(KERN_WARNING PREFIX "Override [%4.4s-%8.8s], "
+	       "this is unsafe: tainting kernel\n",
+	       table->signature, table->oem_table_id);
+	add_taint(TAINT_OVERRIDDEN_ACPI_TABLE);
+}	
+
 acpi_status
 acpi_os_table_override(struct acpi_table_header * existing_table,
 		       struct acpi_table_header ** new_table)
@@ -547,24 +668,74 @@ acpi_os_table_override(struct acpi_table_header * existing_table,
 	if (strncmp(existing_table->signature, "DSDT", 4) == 0)
 		*new_table = (struct acpi_table_header *)AmlCode;
 #endif
-	if (*new_table != NULL) {
-		printk(KERN_WARNING PREFIX "Override [%4.4s-%8.8s], "
-			   "this is unsafe: tainting kernel\n",
-		       existing_table->signature,
-		       existing_table->oem_table_id);
-		add_taint(TAINT_OVERRIDDEN_ACPI_TABLE);
-	}
+	if (*new_table != NULL)
+		acpi_table_taint(existing_table);
 	return AE_OK;
 }
 
 acpi_status
 acpi_os_physical_table_override(struct acpi_table_header *existing_table,
-				acpi_physical_address * new_address,
-				u32 *new_table_length)
+				acpi_physical_address *address,
+				u32 *table_length)
 {
-	return AE_SUPPORT;
-}
+#ifndef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
+	*table_length = 0;
+	*address = 0;
+	return AE_OK;
+#else
+	int table_offset = 0;
+	struct acpi_table_header *table;
+
+	*table_length = 0;
+	*address = 0;
+
+	if (!acpi_tables_addr)
+		return AE_OK;
+
+	do {
+		if (table_offset + ACPI_HEADER_SIZE > all_tables_size) {
+			WARN_ON(1);
+			return AE_OK;
+		}
+
+		table = acpi_os_map_memory(acpi_tables_addr + table_offset,
+					   ACPI_HEADER_SIZE);
 
+		if (table_offset + table->length > all_tables_size) {
+			acpi_os_unmap_memory(table, ACPI_HEADER_SIZE);
+			WARN_ON(1);
+			return AE_OK;
+		}
+
+		table_offset += table->length;
+
+		if (memcmp(existing_table->signature, table->signature, 4)) {
+			acpi_os_unmap_memory(table,
+				     ACPI_HEADER_SIZE);
+			continue;
+		}
+
+		/* Only override tables with matching oem id */
+		if (memcmp(table->oem_table_id, existing_table->oem_table_id,
+			   ACPI_OEM_TABLE_ID_SIZE)) {
+			acpi_os_unmap_memory(table,
+				     ACPI_HEADER_SIZE);
+			continue;
+		}
+
+		table_offset -= table->length;
+		*table_length = table->length;
+		acpi_os_unmap_memory(table, ACPI_HEADER_SIZE);
+		*address = acpi_tables_addr + table_offset;
+		add_taint(TAINT_OVERRIDDEN_ACPI_TABLE);
+		break;
+	} while (table_offset + ACPI_HEADER_SIZE < all_tables_size);
+
+	if (*address != 0)
+		acpi_table_taint(existing_table);
+	return AE_OK;
+#endif
+}		
 
 static irqreturn_t acpi_irq(int irq, void *dev_id)
 {
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index f421dd8..9fb292c 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -76,6 +76,12 @@ typedef int (*acpi_table_handler) (struct acpi_table_header *table);
 
 typedef int (*acpi_table_entry_handler) (struct acpi_subtable_header *header, const unsigned long end);
 
+#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
+int __init acpi_initrd_table_override(void *data,
+			      int size, const char *name);
+void __init acpi_initrd_finalize(void);
+#endif
+
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
 void __acpi_unmap_table(char *map, unsigned long size);
 int early_acpi_boot_init(void);
diff --git a/include/linux/initrd.h b/include/linux/initrd.h
index 3fe262e..8b26e4d 100644
--- a/include/linux/initrd.h
+++ b/include/linux/initrd.h
@@ -23,9 +23,9 @@ extern unsigned int real_root_dev;
 #define MAX_EARLY_INITRD_CB 16
 
 #ifdef CONFIG_EARLY_INITRD
-extern int early_initrd_find_cpio_data(const char *data, size_t len);
+extern void early_initrd_find_cpio_data(const char *data, size_t len);
 #else
-static int early_initrd_find_cpio_data(const char *data, size_t len)
+static void early_initrd_find_cpio_data(const char *data, size_t len)
 {
 	return 0;
 }
diff --git a/init/initramfs.c b/init/initramfs.c
index 84c6bf1..70a1972 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -411,8 +411,10 @@ static int __init flush_buffer(void *bufv, unsigned len)
 			buf += written;
 			len -= written;
 			state = Reset;
-		} else
+		} else {
+			pr_info("junk in compressed archive 3 %u", len);
 			error("junk in compressed archive");
+		}
 	}
 	return origLen;
 }
@@ -427,6 +429,10 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len)
 	decompress_fn decompress;
 	const char *compress_name;
 	static __initdata char msg_buf[64];
+	int skipped = 0;
+	unsigned long tot_written = 0;
+
+	pr_info("%s: 0x%p len: %u\n", __FUNCTION__, buf, len);
 
 	header_buf = kmalloc(110, GFP_KERNEL);
 	symlink_buf = kmalloc(PATH_MAX + N_ALIGN(PATH_MAX) + 1, GFP_KERNEL);
@@ -441,13 +447,17 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len)
 	while (!message && len) {
 		loff_t saved_offset = this_header;
 		if (*buf == '0' && !(this_header & 3)) {
+			pr_info("Starting...\n");
 			state = Start;
 			written = write_buffer(buf, len);
 			buf += written;
 			len -= written;
+			pr_info("... %u written, remaining: %u\n",
+				written, len);
 			continue;
 		}
 		if (!*buf) {
+			skipped++;
 			buf++;
 			len--;
 			this_header++;
@@ -456,21 +466,28 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len)
 		this_header = 0;
 		decompress = decompress_method(buf, len, &compress_name);
 		if (decompress) {
+			pr_info("Decompress: %u - buf[0]: 0x%x - buf[1]: 0x%x", len, *buf, *(buf + 1));
+			pr_info("Decompressing via %s\n", compress_name);
 			res = decompress(buf, len, NULL, flush_buffer, NULL,
 				   &my_inptr, error);
 			if (res)
 				error("decompressor failed");
 		} else if (compress_name) {
+			pr_info("Not decompressing via %s\n", compress_name);
 			if (!message) {
 				snprintf(msg_buf, sizeof msg_buf,
 					 "compression method %s not configured",
 					 compress_name);
 				message = msg_buf;
 			}
-		} else
+		} else {
+			pr_info("junk in compressed archive 1 %u - buf[0]: 0x%x - buf[1]: 0x%x", len, *buf, *(buf + 1));
 			error("junk in compressed archive");
-		if (state != Reset)
+		}
+		if (state != Reset) {
+			pr_info("junk in compressed archive 2 %u", len);
 			error("junk in compressed archive");
+		}
 		this_header = saved_offset + my_inptr;
 		buf += my_inptr;
 		len -= my_inptr;
diff --git a/init/initrd_early.c b/init/initrd_early.c
index c657a4b..35d8480 100644
--- a/init/initrd_early.c
+++ b/init/initrd_early.c
@@ -1,6 +1,9 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/initrd.h>
+#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
+#include <linux/acpi.h>
+#endif
 
 struct initrd_early_data {
 	/* Path where relevant files can be found in uncompressed cpio */
@@ -18,6 +21,13 @@ struct initrd_early_data {
  */
 static __initdata struct initrd_early_data initrd_early_callbacks[] =
 {
+#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
+	{
+		.namesp = "kernel/firmware/acpi/",
+		.cb     = acpi_initrd_table_override,
+		.final  = acpi_initrd_finalize,
+	},
+#endif
 	{
 		.namesp = NULL,
 	}
-- 
1.7.6.1

