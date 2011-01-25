Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab1AYAZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:25:13 -0500
Received: from smtp-out.google.com ([74.125.121.67]:59960 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1AYAZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:25:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=ew9qejRZUFMhxhFwxB6ep13IySc26g08rwGlJm5nwfqPs5QNl+To+BY5BYYwALZlV
	W6hMiJJwhz9Gr3v8g4W0A==
Subject: [PATCH v1 4/6] driver: Google Bootlog
To: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org
From: Mike Waychison <mikew@google.com>
Cc: San Mehat <san@google.com>, Aaron Durbin <adurbin@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Date: Mon, 24 Jan 2011 16:24:54 -0800
Message-ID: <20110125002454.12637.4700.stgit@mike.mtv.corp.google.com>
In-Reply-To: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bootlog driver supports older firmware that is used at Google for
communicating between the kernel and the BIOS reasons for reboots.

The BIOS manages a small (a couple bytes) of CMOS nvram that is
communicated to the driver.  This CMOS is written to by both the BIOS
(at bootup) as well as the kernel (on the way towards shutdown) to log
*why* things are happening.  This has enabled us to debug various types
of hardware faults, as the BIOS bootup reasons are typically hidden by
BIOSes clearing this information out before the kernel starts.

In addition to the bootlog portion, a couple bytes of the CMOS may be
dedicated to leaving any interesting data that would have been present
at warm bootup in one of the CPUs MCA banks.  This happens for example
when the CPU was so confused that the system initiated a reset.

No userland interfaces are exposed by this driver.

Signed-off-by: Duncan Laurie <dlaurie@google.com>
Signed-off-by: San Mehat <san@google.com>
Signed-off-by: Tim Hockin <thockin@google.com>
Signed-off-by: Aaron Durbin <adurbin@google.com>
Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/firmware/Kconfig          |    8 
 drivers/firmware/google/Kconfig   |    7 
 drivers/firmware/google/Makefile  |    1 
 drivers/firmware/google/bootlog.c |  884 +++++++++++++++++++++++++++++++++++++
 4 files changed, 900 insertions(+), 0 deletions(-)
 create mode 100644 drivers/firmware/google/bootlog.c

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index d848b26..e6cc39d 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -136,4 +136,12 @@ config ISCSI_IBFT
 
 source "drivers/firmware/google/Kconfig"
 
+config BOOTLOG_SUPPORT
+	bool "Bootlog Support"
+	depends on FIRMWARE_EVENTS && X86
+	default n
+	---help---
+	  This enables support for displaying boot log information in dmesg
+	  as well as logging the kernel shutdown reasons.
+
 endmenu
diff --git a/drivers/firmware/google/Kconfig b/drivers/firmware/google/Kconfig
index 2d2be7c..0490a62 100644
--- a/drivers/firmware/google/Kconfig
+++ b/drivers/firmware/google/Kconfig
@@ -21,4 +21,11 @@ config GOOGLE_SMI
 	  clearing the EFI event log and reading and writing NVRAM
 	  variables.
 
+config GOOGLE_BOOTLOG
+	bool "Bootlog Support"
+	default y
+	---help---
+	  This enables support for displaying boot log information in dmesg
+	  as well as logging the kernel shutdown reasons.
+
 endmenu
diff --git a/drivers/firmware/google/Makefile b/drivers/firmware/google/Makefile
index fb127d7..d45e10c 100644
--- a/drivers/firmware/google/Makefile
+++ b/drivers/firmware/google/Makefile
@@ -1,2 +1,3 @@
 
 obj-$(CONFIG_GOOGLE_SMI)		+= gsmi.o
+obj-$(CONFIG_GOOGLE_BOOTLOG)		+= bootlog.o
diff --git a/drivers/firmware/google/bootlog.c b/drivers/firmware/google/bootlog.c
new file mode 100644
index 0000000..232cd7d
--- /dev/null
+++ b/drivers/firmware/google/bootlog.c
@@ -0,0 +1,884 @@
+/*
+ * bootlog.c
+ *
+ * Boot Logging infrastructure for tracking and
+ * system resets initiated by a variety of methods.
+ *
+ * Copyright 2005 Google Inc. All Rights Reserved.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/notifier.h>
+#include <linux/kdebug.h>
+#include <linux/reboot.h>
+#include <linux/io.h>
+
+/*
+ * Kernel shutdown flags
+ */
+#define BLOG_K_CLEAN		0	/* Clean Shutdown */
+#define BLOG_K_NMIWDT		1	/* NMI Watchdog */
+#define BLOG_K_PANIC		2	/* Panic */
+#define BLOG_K_OOPS		3	/* Oops */
+#define BLOG_K_DIE		4	/* Die */
+#define BLOG_K_MCE		5	/* MCE */
+#define BLOG_K_SOFTWDT		6	/* Software Watchdog */
+#define BLOG_K_MBE		7	/* MBE */
+#define BLOG_K_TRIPLE		8	/* Triple Fault */
+
+/*
+ * Flags and descriptions of BIOS bootlog.
+ */
+#define BLOG_B_DRAMECC		0	/* DRAM ECC error */
+#define BLOG_B_SYNCFLOOD	1	/* Sync Flood */
+#define BLOG_B_PWRFAIL		2	/* Power Fail */
+#define BLOG_B_TCO2TO		3	/* Hardware TCO Timeout 2 */
+#define BLOG_B_NBRDGCRC		4	/* NB CRC Error */
+#define BLOG_B_SBRDGSFLOOD1	5	/* SB Sync Flood */
+#define BLOG_B_SBRDGCRC1	6	/* SB CRC Error */
+#define BLOG_B_POWERON		7	/* Power On */
+#define BLOG_B_SBRDGSFLOOD2	8	/* Southbridge Sync Flood */
+#define BLOG_B_SBRDGCRC2	9	/* Southbridge CRC Error */
+#define BLOG_B_THERMTRIP	10	/* Thermtrip */
+#define BLOG_B_PCIFATAL		11	/* PCI Fatal Error */
+
+#define BLOG_SUPPORT_IOPAIR8	1
+
+/*
+ * Search for a BLOG pointer in the EBDA.
+ * The EBDA segment is stored at offset 0xe in the BDA (segment 40).
+ */
+#define BLOG_EBDA_POINTER	0x040E
+
+/*
+ * How many BLOG records to print?
+ */
+#define BLOG_DEF_COUNT		5
+
+/*
+ * Size of the on-stack string buffers.
+ * Don't shrink this without counting out the ultimate length of the
+ * generated strings.
+ */
+#define SBUF_SIZE	200
+
+/*
+ * This structure is stored in the EBDA by the BIOS and
+ * indicates to the kernel how to access the boot log.
+ *
+ * If (method == BLOG_METHOD_IOPAIR8):
+ *   The iopair8 method_data defines the index/data ports
+ *   to be used to access the BLOG data and base indicates
+ *   the starting index to read from.
+ */
+
+struct bootlog_ptr {
+	uint32_t signature;		/* "BLOG" */
+	uint8_t version;		/* header version */
+	uint8_t method;			/* access method */
+	union {
+		struct {
+			uint8_t index_port;
+			uint8_t data_port;
+			uint8_t base;
+			uint8_t ecc_base;
+			uint8_t ecc_length;
+		} iopair8;		/* 8 bit IO index/data pair*/
+		struct {
+			uint16_t port;
+			uint16_t base;
+			uint16_t ecc_base;
+			uint16_t ecc_length;
+		} io8;			/* 8 bit IO */
+	} method_data;
+} __packed;
+
+/* we find and save the bootlog_ptr during initialization */
+static struct bootlog_ptr *blog_ptr;
+
+/* this is the signature we find in the EBDA to indicate the BLOG pointer */
+#define BLOG_PTR_MAGIC		(('B')|('L'<<8)|('O'<<16)|('G'<<24))
+
+/* these define the layout of the BLOG pointer */
+#define BLOG_PTR_VERSION_1	1
+#define BLOG_PTR_VERSION_2	2
+
+/* these define the possible BLOG methods (bootlog_ptr.method) */
+#define BLOG_METHOD_IOPAIR8	1
+#define BLOG_METHOD_IO8		2
+
+/*
+ * Each BLOG record consists of two parts:
+ *   Part 1: BIOS-generated info about the boot
+ *   Part 2: kernel-generated info about the shutdown
+ *
+ * This structure is independent of any particular BLOG method.
+ */
+struct bootlog_record {
+	uint32_t bootup;
+	uint32_t shutdown;
+};
+
+/*
+ * Each BLOG method must provide a bootlog_ops structure.
+ */
+struct bootlog_ops {
+	/* method-specific init */
+	int (*init)(void);
+	/* get the method-specific version */
+	int (*version)(void);
+	/* get the boot count */
+	int (*bootcount)(void);
+	/* get the number of records */
+	int (*nrecords)(void);
+	/* get a BLOG record */
+	struct bootlog_record *(*get_record)(int recnum);
+	/* get ECCLog data */
+	int (*get_ecc)(int *boot, uint64_t *status, uint64_t *address);
+	/* add a new shutdown reason */
+	uint32_t (*add_reason)(int reason);
+};
+
+/* this is the global ops table */
+struct bootlog_ops *blog_ops;
+
+/* serialize access to bootlog */
+static DEFINE_SPINLOCK(bootlog_lock);
+
+/* number of BLOG records to display on boot */
+static uint8_t bootlog_count = BLOG_DEF_COUNT;
+
+/*
+ * Used to describe BLOG flags below.
+ */
+struct bootlog_flag {
+	uint16_t flag;
+	const char *desc;
+};
+
+/*
+ * Descriptions for Kernel bootlog flags.
+ */
+static struct bootlog_flag bootlog_kernel_flags[] = {
+	{ BLOG_K_CLEAN,		"Clean" },
+	{ BLOG_K_NMIWDT,	"NMI Watchdog" },
+	{ BLOG_K_PANIC,		"Panic" },
+	{ BLOG_K_OOPS,		"Oops" },
+	{ BLOG_K_DIE,		"Die" },
+	{ BLOG_K_MCE,		"MCE Panic" },
+	{ BLOG_K_SOFTWDT,	"Software Watchdog" },
+	{ BLOG_K_MBE,		"Multi-bit ECC" },
+	{ BLOG_K_TRIPLE,	"Triple Fault" },
+	{ 0,			NULL }
+};
+
+static struct bootlog_flag bootlog_bios_flags[] = {
+	{ BLOG_B_PWRFAIL,	"Power Failure" },
+	{ BLOG_B_POWERON,	"Power On" },
+	{ BLOG_B_SYNCFLOOD,	"Sync Flood" },
+	{ BLOG_B_DRAMECC,	"DRAM ECC" },
+	{ BLOG_B_TCO2TO,	"TCO Watchdog Timeout" },
+	{ BLOG_B_SBRDGSFLOOD1,	"Southbridge Sync Flood" },
+	{ BLOG_B_SBRDGCRC1,	"Southbridge CRC Error" },
+	{ BLOG_B_NBRDGCRC,	"Northbridge CRC Error" },
+	{ BLOG_B_SBRDGSFLOOD2,	"Southbridge Sync Flood" },
+	{ BLOG_B_SBRDGCRC2,	"Southbridge CRC Error" },
+	{ BLOG_B_THERMTRIP,	"Thermtrip" },
+	{ BLOG_B_PCIFATAL,	"PCI Fatal Error" },
+	{ 0,			NULL }
+};
+
+int __init setup_bootlog_count(char * str)
+{
+	int count;
+
+	get_option(&str, &count);
+
+	if (count < 1 && count > 256)
+		return 0;
+
+	bootlog_count = count;
+	return 1;
+}
+__setup("bootlog_count=", setup_bootlog_count);
+
+/*
+ * Search for the BLOG pointer.
+ */
+static struct bootlog_ptr * __init bootlog_find_pointer(void)
+{
+	unsigned long address, length, cur;
+	struct bootlog_ptr *bp;
+
+	/* EBDA pointer contains segment the extended BIOS data area */
+	address = *(uint16_t *)phys_to_virt(BLOG_EBDA_POINTER);
+	address <<= 4;	/* convert segment to physical address */
+
+	/* EBDA length is byte 0 of the EBDA (stored in kB) */
+	length = *(uint8_t *)phys_to_virt(address);
+	length <<= 10;	/* convert to bytes */
+
+	/*
+	 * Search through EBDA for the BLOG signature.
+	 * NOTE: the signature is not necessarily DWORD-aligned.
+	 */
+	for (cur = 0; cur < length; cur++) {
+		bp = phys_to_virt(address + cur);
+		if (bp->signature == BLOG_PTR_MAGIC) {
+			/*
+			 * BLOG_PTR_VERSION_1 and VERSION_2 are mostly the
+			 * same. In the future, this will probably have to
+			 * get more complicated.
+			 */
+			return bp;
+		}
+	}
+
+	return NULL;
+}
+
+/*
+ * Print BLOG records to console, where the most recent reboot is
+ * printed out as 1, previous 2 ... indexed up to bootlog_count.
+ */
+static void bootlog_print_records(void)
+{
+	unsigned long flags;
+	char sbuf[SBUF_SIZE];
+	int i;
+
+	if (blog_ptr == NULL)
+		return;
+	if (blog_ops == NULL)
+		return;
+	if (bootlog_count == 0)
+		return;
+
+	/* Reset the buffer */
+	sbuf[0] = '\0';
+
+	spin_lock_irqsave(&bootlog_lock, flags);
+	for (i = 0; i < bootlog_count; i++) {
+		struct bootlog_record *record;
+		struct bootlog_flag *bf;
+
+		/* get a pointer to the BLOG record */
+		record = blog_ops->get_record(i);
+		if (!record)
+			break;
+
+		/* list kernel shutdown reasons from newest to oldest */
+		sprintf(sbuf,
+			"BLOG: Record %d Kernel Shutdown Reason: ", i + 1);
+		if (record->shutdown == 0)
+			strcat(sbuf, "Unknown");
+		else {
+			int count = 0;
+			for (bf = bootlog_kernel_flags; bf->desc; bf++) {
+				if (record->shutdown & (1<<bf->flag)) {
+					if (count++)
+						strcat(sbuf, ", ");
+					strcat(sbuf, bf->desc);
+				}
+			}
+		}
+
+		/* Print and reset the buffer */
+		pr_info("%s\n", sbuf);
+		sbuf[0] = '\0';
+
+		/* list BIOS bootup reasons */
+		sprintf(sbuf,
+			"BLOG: Record %d BIOS Bootup Reason: ", i + 1);
+		if (record->bootup == 0)
+			strcat(sbuf, "Clean");
+		else {
+			int count = 0;
+			for (bf = bootlog_bios_flags; bf->desc; bf++) {
+				if (record->bootup & (1<<bf->flag)) {
+					if (count++)
+						strcat(sbuf, ", ");
+					strcat(sbuf, bf->desc);
+				}
+			}
+		}
+
+		/* Print and reset for next iteration */
+		pr_info("%s\n", sbuf);
+		sbuf[0] = '\0';
+	}
+	spin_unlock_irqrestore(&bootlog_lock, flags);
+}
+
+/*
+ * Print saved Machine Check data (ECC).
+ * Currently only supported if blog_ptr->version == BLOG_PTR_VERSION_2.
+ */
+static void bootlog_print_ecclog(void)
+{
+	int boot;
+	unsigned long long status;
+	unsigned long long address;
+	unsigned long flags;
+	char sbuf[SBUF_SIZE];
+
+	if (blog_ptr == NULL)
+		return;
+	if (blog_ops == NULL)
+		return;
+	if (blog_ptr->version != BLOG_PTR_VERSION_2)
+		return;
+
+	spin_lock_irqsave(&bootlog_lock, flags);
+	if (blog_ops->get_ecc(&boot, &status, &address) == 0) {
+		if (blog_ops->version() == 1) {
+			pr_info("BLOG: Machine Check Log: "
+				"%08llx %08llx %08llx %08llx\n",
+				status >> 32, status & 0xffffffff,
+				address >> 32, address & 0xffffffff);
+		} else if (status) {
+			strcpy(sbuf, "BLOG: ECCLog: Boot ");
+			if (boot)
+				sprintf(sbuf, "%d", boot);
+			else
+				strcat(sbuf, "unknown");
+			pr_info("%s Status 0x%016llx Address 0x%016llx\n",
+				sbuf, status, address);
+		}
+	}
+	spin_unlock_irqrestore(&bootlog_lock, flags);
+}
+
+
+/*
+ * Write the indicated shutdown reason to the BLOG shutdown
+ * byte (2) and update the BLOG checksum byte (N+1)
+ */
+static int bootlog_shutdown_reason(int reason)
+{
+	unsigned long flags;
+	struct bootlog_flag *bf;
+	int count = 0;
+	uint32_t reasons;
+	char sbuf[SBUF_SIZE];
+
+	if (blog_ptr == NULL || blog_ops == NULL)
+		return -1;
+
+	spin_lock_irqsave(&bootlog_lock, flags);
+	reasons = blog_ops->add_reason(reason);
+	spin_unlock_irqrestore(&bootlog_lock, flags);
+
+	sprintf(sbuf, "BLOG: Updated Shutdown reason to 0x%02x (", reasons);
+
+	for (bf = bootlog_kernel_flags; bf->desc; bf++) {
+		if (reasons & (1<<bf->flag)) {
+			if (count++)
+				strcat(sbuf, ", ");
+			strcat(sbuf, bf->desc);
+		}
+	}
+
+	pr_info("%s)\n", sbuf);
+
+	return 0;
+}
+
+#if BLOG_SUPPORT_IOPAIR8
+
+/*
+ * The io8 header.  It's easiest to read and cache this, rather than
+ * hit the IO ports every time we need something.
+ */
+struct bootlog_iopair8_hdr {
+	uint8_t checksum;		/* checksum of header and data */
+	uint8_t version;		/* blog struct version */
+	uint8_t nrecords;		/* number of BLOG records */
+	uint16_t bootcount;		/* number of boots */
+	uint16_t reason;		/* kernel shutdown reason */
+	struct bootlog_record *blog;	/* BLOG records */
+	int ecc_boot;			/* boot number for ECCLog */
+	uint64_t ecc_status;		/* last ECC status */
+	uint64_t ecc_address;		/* last ECC address */
+};
+
+/* we find and save this during initialization */
+static struct bootlog_iopair8_hdr *io8_hdr;
+
+/*
+ * The format of the data pointed to by the iopair8 header is:
+ *   Byte 0     (RW) checksum of header and data
+ *   Byte 1     (R)  log structure version
+ *
+ * If the header version is IO8_VERSION_1:
+ *   Byte 2     (R)  number of BLOG records
+ *   Byte 3     (R)  number of system boots (written by BIOS)
+ *   Byte 4     (W)  shutdown reason (written by kernel)
+ *   Byte 5-N   (R)  BLOG records consisting of kernel and BIOS flags
+ *
+ * If the header version is IO8_VERSION_2:
+ *   Byte 2     (R)  number of BLOG records
+ *   Byte 3,4   (R)  number of system boots [low,high] (written by BIOS)
+ *   Byte 5,6   (W)  shutdown reason [low,high] (written by kernel)
+ *   Byte 7-N   (R)  BLOG records consisting of kernel/bios cause masks
+ *
+ * The ECCLog structure is also dependant on the IO8 header version.
+ * These are offsets from the ecc_base:
+ *   Byte 0-7   (R)  ECC status [low..high] (written by BIOS)
+ *   Byte 8-15  (R)  ECC address [low..high] (written by BIOS)
+ *
+ * If the header version is IO8_VERSION_2:
+ *   Byte 16-17 (R)  ECC boot number [low,high] (written by BIOS)
+ */
+
+#define IO8_OFF_CHECKSUM	0
+#define IO8_OFF_VERSION		1
+
+#define IO8V1_OFF_NRECS		2
+#define IO8V1_OFF_BOOTCNT	3
+#define IO8V1_OFF_REASON	4
+#define IO8V1_OFF_RECORDS	5
+#define IO8V1_OFF_REC(n)	(IO8V1_OFF_RECORDS + (n)*IO8V1_RECSIZE)
+#define IO8V1_RECSIZE		2
+
+#define IO8V2_OFF_NRECS		2
+#define IO8V2_OFF_BOOTCNT	3
+#define IO8V2_OFF_REASON	5
+#define IO8V2_OFF_RECORDS	7
+#define IO8V2_OFF_REC(n)	(IO8V2_OFF_RECORDS + (n)*IO8V2_RECSIZE)
+#define IO8V2_RECSIZE		4
+
+#define IO8_ECC_OFF_STATUS	0
+#define IO8_ECC_OFF_ADDRESS	8
+#define IO8_ECC_OFF_BOOTNUM	16
+
+/* the iopair8 BLOG header is versioned */
+#define IO8_VERSION_1		1
+#define IO8_VERSION_2		2
+
+static uint8_t io8_pair_read(int offset)
+{
+	int base = blog_ptr->method_data.iopair8.base;
+	int iport = blog_ptr->method_data.iopair8.index_port;
+	int dport = blog_ptr->method_data.iopair8.data_port;
+
+	outb(base + offset, iport);
+	return inb(dport);
+}
+
+static uint8_t io8_direct_read(int offset)
+{
+	int base = blog_ptr->method_data.io8.base;
+	int port = blog_ptr->method_data.io8.port;
+
+	return inb(base + port + offset);
+}
+
+static uint8_t io8_read(int offset)
+{
+	if (blog_ptr->method == BLOG_METHOD_IO8)
+		return io8_direct_read(offset);
+
+	return io8_pair_read(offset);
+}
+
+static uint16_t io8_read16(int offset)
+{
+	uint16_t val;
+
+	/* multi-byte values are always stored little endian */
+	val = io8_read(offset+1);
+	val <<= 8;
+	val |= io8_read(offset);
+	return val;
+}
+
+static uint8_t io8_pair_ecc_read(int offset)
+{
+	int base = blog_ptr->method_data.iopair8.ecc_base;
+	int iport = blog_ptr->method_data.iopair8.index_port;
+	int dport = blog_ptr->method_data.iopair8.data_port;
+
+	outb(base + offset, iport);
+	return inb(dport);
+}
+
+static uint8_t io8_direct_ecc_read(int offset)
+{
+	int base = blog_ptr->method_data.io8.ecc_base;
+	int port = blog_ptr->method_data.io8.port;
+
+	return inb(base + port + offset);
+}
+
+static uint8_t io8_ecc_read(int offset)
+{
+	if (blog_ptr->method == BLOG_METHOD_IO8)
+		return io8_direct_ecc_read(offset);
+
+	return io8_pair_ecc_read(offset);
+}
+
+static uint16_t io8_ecc_read16(int offset)
+{
+	uint16_t val;
+
+	/* multi-byte values are always stored little endian */
+	val = io8_ecc_read(offset+1);
+	val <<= 8;
+	val |= io8_ecc_read(offset);
+	return val;
+}
+
+static uint64_t io8_ecc_read64(int offset)
+{
+	uint64_t val;
+	int i;
+
+	/*
+	 * Multi-byte values are always stored little endian.  In this
+	 * case it's stored as 2 32-bit values, high half first.  Ask San
+	 * why, for I know not.
+	 */
+	val = 0;
+	for (i = 3; i >= 0; i--) {
+		val <<= 8;
+		val |= io8_ecc_read(offset+i);
+	}
+	for (i = 3; i >= 0; i--) {
+		val <<= 8;
+		val |= io8_ecc_read(offset+4+i);
+	}
+	return val;
+}
+
+static void io8_pair_write(int offset, uint8_t value)
+{
+	int base = blog_ptr->method_data.iopair8.base;
+	int iport = blog_ptr->method_data.iopair8.index_port;
+	int dport = blog_ptr->method_data.iopair8.data_port;
+
+	outb(base + offset, iport);
+	outb(value, dport);
+}
+
+static void io8_direct_write(int offset, uint8_t value)
+{
+	int base = blog_ptr->method_data.io8.base;
+	int port = blog_ptr->method_data.io8.port;
+
+	outb(value, port + base + offset);
+}
+
+static void io8_write(int offset, uint8_t value)
+{
+	if (blog_ptr->method == BLOG_METHOD_IO8) {
+		io8_direct_write(offset, value);
+		return;
+	}
+
+	io8_pair_write(offset, value);
+}
+
+static void io8_write16(int offset, uint16_t value)
+{
+	uint8_t v;
+
+	/* multi-byte values are always stored little endian */
+	v = value & 0xff;
+	io8_write(offset, v);
+	v = (value >> 8) & 0xff;
+	io8_write(offset+1, v);
+}
+
+static uint8_t io8_checksum(void)
+{
+	int i;
+	int version;
+	int bytes = 0;
+	uint8_t sum = 0;
+
+	/* figure out how many bytes to checksum */
+	version = io8_read(IO8_OFF_VERSION);
+	if (version == IO8_VERSION_1) {
+		int records = io8_read(IO8V1_OFF_NRECS);
+		bytes = IO8V1_OFF_RECORDS + records * IO8V1_RECSIZE;
+	} else if (version == IO8_VERSION_2) {
+		int records = io8_read(IO8V2_OFF_NRECS);
+		bytes = IO8V2_OFF_RECORDS + records * IO8V2_RECSIZE;
+	}
+
+	/* run the checksum, skipping byte 0, which is the csum itself */
+	for (i = 1; i < bytes; i++)
+		sum += io8_read(i);
+
+	return sum;
+}
+
+static int io8_init(void)
+{
+	int version;
+	int checksum;
+
+	if (blog_ptr == NULL)
+		return -1;
+
+	/* make sure we know this format */
+	version = io8_read(IO8_OFF_VERSION);
+	if (version == IO8_VERSION_1 || version == IO8_VERSION_2) {
+		/* validate the checksum */
+		int calcsum;
+		checksum = io8_read(IO8_OFF_CHECKSUM);
+		calcsum = io8_checksum();
+		if (calcsum != checksum) {
+			pr_alert("BLOG: Bad checksum (%02x != %02x)\n",
+				 checksum, calcsum);
+			return -1;
+		}
+
+		io8_hdr = kmalloc(sizeof(*io8_hdr), GFP_KERNEL);
+		if (io8_hdr == NULL)
+			return -1;
+		memset(io8_hdr, 0, sizeof(*io8_hdr));
+	} else {
+		pr_alert("BLOG: Unsupported iopair8 version %d\n",
+			 version);
+		return -1;
+	}
+
+	/* populate the header struct */
+	io8_hdr->version  = version;
+	io8_hdr->checksum = checksum;
+
+	if (version == IO8_VERSION_1) {
+		io8_hdr->nrecords = io8_read(IO8V1_OFF_NRECS);
+		io8_hdr->bootcount = io8_read(IO8V1_OFF_BOOTCNT);
+		io8_hdr->reason = io8_read(IO8V1_OFF_REASON);
+	} else if (version == IO8_VERSION_2) {
+		io8_hdr->nrecords = io8_read(IO8V2_OFF_NRECS);
+		io8_hdr->bootcount = io8_read16(IO8V2_OFF_BOOTCNT);
+		io8_hdr->reason = io8_read16(IO8V2_OFF_REASON);
+	}
+
+	/* initialize the list of BLOG records */
+	if (io8_hdr->nrecords > 0) {
+		int r;
+
+		io8_hdr->blog = kmalloc(sizeof(*io8_hdr->blog) *
+					io8_hdr->nrecords, GFP_KERNEL);
+		if (io8_hdr->blog == NULL) {
+			kfree(io8_hdr);
+			return -1;
+		}
+		memset(io8_hdr->blog, 0,
+			sizeof(*io8_hdr->blog) * io8_hdr->nrecords);
+
+		for (r = 0; r < io8_hdr->nrecords; r++) {
+			uint32_t b = 0, k = 0;
+			if (version == IO8_VERSION_1) {
+				/* each record is 2 1-byte fields */
+				b = io8_read(IO8V1_OFF_REC(r));
+				k = io8_read(IO8V1_OFF_REC(r)+1);
+			} else if (version == IO8_VERSION_2) {
+				/* each record is 2 2-byte fields */
+				b = io8_read16(IO8V2_OFF_REC(r));
+				k = io8_read16(IO8V2_OFF_REC(r)+2);
+			}
+			io8_hdr->blog[r].bootup = b;
+			io8_hdr->blog[r].shutdown = k;
+		}
+	} else {
+		io8_hdr->blog = NULL;
+	}
+
+	/* read the ECCLog data */
+	if (blog_ptr->version == BLOG_PTR_VERSION_2) {
+		if (io8_hdr->version == IO8_VERSION_1)
+			io8_hdr->ecc_boot = 0;
+		else if (io8_hdr->version == IO8_VERSION_2)
+			io8_hdr->ecc_boot = io8_ecc_read16(IO8_ECC_OFF_BOOTNUM);
+		io8_hdr->ecc_status = io8_ecc_read64(IO8_ECC_OFF_STATUS);
+		io8_hdr->ecc_address = io8_ecc_read64(IO8_ECC_OFF_ADDRESS);
+	}
+
+	return 0;
+}
+
+static int io8_version(void)
+{
+	return io8_hdr->version;
+}
+
+static int io8_bootcount(void)
+{
+	return io8_hdr->bootcount;
+}
+
+static int io8_nrecords(void)
+{
+	return io8_hdr->nrecords;
+}
+
+static struct bootlog_record *io8_get_record(int recnum)
+{
+	if (recnum < io8_hdr->nrecords)
+		return &io8_hdr->blog[recnum];
+	return NULL;
+}
+
+static int io8_get_ecc(int *boot, uint64_t *status, uint64_t *address)
+{
+	if (blog_ptr->version >= BLOG_PTR_VERSION_2) {
+		*boot = io8_hdr->ecc_boot;
+		*status = io8_hdr->ecc_status;
+		*address = io8_hdr->ecc_address;
+		return 0;
+	}
+	return -1;
+}
+
+static uint32_t io8_add_reason(int reason)
+{
+	/* update shutdown byte */
+	io8_hdr->reason |= (1<<reason);
+
+	/* write it out */
+	if (io8_hdr->version == IO8_VERSION_1)
+		io8_write(IO8V1_OFF_REASON, io8_hdr->reason);
+	else if (io8_hdr->version == IO8_VERSION_2)
+		io8_write16(IO8V2_OFF_REASON, io8_hdr->reason);
+
+	/* update the checksum */
+	io8_hdr->checksum = io8_checksum();
+	io8_write(IO8_OFF_CHECKSUM, io8_hdr->checksum);
+
+	return io8_hdr->reason;
+}
+
+/*
+ * The io8 operations table.
+ */
+struct bootlog_ops io8_ops = {
+	.init		= io8_init,
+	.version	= io8_version,
+	.bootcount	= io8_bootcount,
+	.nrecords	= io8_nrecords,
+	.get_record	= io8_get_record,
+	.get_ecc	= io8_get_ecc,
+	.add_reason	= io8_add_reason,
+};
+
+#endif /* BLOG_SUPPORT_IOPAIR8 */
+
+static int bootlog_reboot_callback(struct notifier_block *nb,
+				   unsigned long reason, void *arg)
+{
+	bootlog_shutdown_reason(BLOG_K_CLEAN);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block bootlog_reboot_notifier = {
+	.notifier_call = bootlog_reboot_callback
+};
+
+static int bootlog_die_callback(struct notifier_block *nb,
+				unsigned long reason, void *arg)
+{
+	if (reason == DIE_NMIWATCHDOG)
+		bootlog_shutdown_reason(BLOG_K_NMIWDT);
+	else if (reason == DIE_OOPS)
+		bootlog_shutdown_reason(BLOG_K_DIE);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block bootlog_die_notifier = {
+	.notifier_call = bootlog_die_callback
+};
+
+static int bootlog_panic_callback(struct notifier_block *nb,
+				  unsigned long reason, void *arg)
+{
+	bootlog_shutdown_reason(BLOG_K_PANIC);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block bootlog_panic_notifier = {
+	.notifier_call = bootlog_panic_callback
+};
+
+static int bootlog_oops_callback(struct notifier_block *nb,
+				 unsigned long reason, void *arg)
+{
+	if (reason == OOPS_ENTER)
+		bootlog_shutdown_reason(BLOG_K_OOPS);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block bootlog_oops_notifier = {
+	.notifier_call = bootlog_oops_callback
+};
+
+/*
+ * Find the BLOG pointer location and parse BLOG records,
+ * display previous shutdown reason as indicated by kernel and BIOS
+ */
+static int __init bootlog_startup(void)
+{
+	/* search for bootlog pointer in EBDA */
+	blog_ptr = bootlog_find_pointer();
+	if (blog_ptr == NULL) {
+		pr_alert("BLOG: Unable to find pointer in EBDA\n");
+		return -1;
+	}
+
+	pr_info("BIOS BootLog pointer version %d method %d at 0x%08lx\n",
+		blog_ptr->version, blog_ptr->method,
+		(unsigned long)virt_to_phys(blog_ptr));
+
+	/* make sure we know how to handle this pointer version */
+	if (blog_ptr->version > BLOG_PTR_VERSION_2) {
+		pr_alert("BLOG: Unsupported pointer version %d\n",
+			 blog_ptr->version);
+		blog_ptr = NULL;
+		return -1;
+	}
+
+	/* figure out which access method to use */
+	switch (blog_ptr->method) {
+	case BLOG_METHOD_IOPAIR8:
+	case BLOG_METHOD_IO8:
+		blog_ops = &io8_ops;
+		break;
+	default:
+		pr_alert("BLOG: Unsupported method %d\n",
+			 blog_ptr->method);
+		blog_ptr = NULL;
+		return -1;
+	}
+
+	/* do method-specific initialization (including checksum) */
+	if (blog_ops->init() < 0) {
+		blog_ptr = NULL;
+		return -1;
+	}
+
+	register_reboot_notifier(&bootlog_reboot_notifier);
+	register_die_notifier(&bootlog_die_notifier);
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &bootlog_panic_notifier);
+	register_oops_notifier(&bootlog_oops_notifier);
+
+	/* print the BLOG info */
+	pr_info("BLOG: BootLog Rev %d, Boot #%d, %d Record(s)\n",
+		blog_ops->version(), blog_ops->bootcount(),
+		blog_ops->nrecords());
+	bootlog_print_records();
+	bootlog_print_ecclog();
+
+	return 0;
+}
+early_initcall(bootlog_startup);

