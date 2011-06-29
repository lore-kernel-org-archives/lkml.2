Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab1F2AIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 20:08:23 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22338 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab1F2AIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 20:08:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=to:cc:from:subject:message-id:date:x-system-of-record;
	b=qkcDeTkQvflU0VAlKqgDE/nlNYqM5Gen61kgKrVlqO7XbGZCJ5pD20j65R3KZpZiP
	7vVuzpauJGSVmwSr5slbQ==
To: linux-kernel@vger.kernel.org, Nancy Yuen <yeunn@google.com>,
        Mike Ditto <mditto@google.com>, Shane Nay <snay@google.com>,
        Andrew Morton <akpm@google.com>, Andi Kleen <andi@firstfloor.org>
Cc: Rick van Rein <rick@vanrein.org>, Stefan Assmann <sassmann@kpanic.de>,
        Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>
From: craigb <craigb@google.com>
Subject: [RFC, PATCH] x86: mm: dynamic BadRAM (extended E820)
Message-Id: <20110629000758.94FC213A0F8@firestorm2.mtv.corp.google.com>
Date: Tue, 28 Jun 2011 17:07:58 -0700 (PDT)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nancy Yuen <yuenn@google.com>

This patch implements "extended e820 support" for BadRAM, but
admittedly needs a bit of cleanup before being integrated into any
upstream kernel.  This posting is in response to a request from
members of the LKML community for Google's BadRAM patch based on an
"extended e820".  The patch should apply cleanly to vanilla linux-2.6.34.


The existing BadRAM patch did not meet Google's needs because:

* BadRAM marks the pages as bad, but this happens later in kernel
boot.  It doesn't prevent the kernel from allocating from bad regions
during earlier boot.

* The command line interface can't handle the number of entries
expected by Google's repair tool, even with patterns.

* The command line syntax in the existing BadRAM patch does not
support non-power-of-two interleaving.


Making use of this patch requires modifications to your bootloader (obviously
not included here).  The modifications should cause an "extended e820 map"
to be loaded in addresses just after the kernel image.


We believe that the best general-purpose solution is probably a hybrid
of this approach and that which is being proposed by Rick van Rein.  An
ideal solution could support small installations with small quantities of
memory mapped out via command line parameters and large quantities of memory
mapped out in large installations via extended e820 support.


It's probably worth noting that this is not my own code but was
written by a few of my fellow Googlers.  Nancy Yuen <yuenn@google.com>
and Mike Ditto <mditto@google.com> are this patch's primary authors.



Signed-off-by: Nancy Yuen <yuenn@google.com>
---
 arch/x86/Kconfig                   |   13 ++
 arch/x86/boot/compressed/head_64.S |   31 ++++
 arch/x86/boot/compressed/misc.c    |  138 ++++++++++++++++++
 arch/x86/include/asm/e820.h        |   30 ++++-
 arch/x86/kernel/e820.c             |  270 +++++++++++++++++++++++++++++-------
 arch/x86/kernel/efi.c              |    2 +-
 arch/x86/kernel/setup.c            |    8 +-
 7 files changed, 436 insertions(+), 56 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9458685..70ba9bd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1153,6 +1153,15 @@ config DIRECT_GBPAGES
 	  support it. This can improve the kernel's performance a tiny bit by
 	  reducing TLB pressure. If in doubt, say "Y".
 
+config E820EX
+	bool "Support extended e820 map for marking BadRAM"
+	default y
+	help
+	  To allow you to mark memory regions as BadRAM, an "extended
+	  e820 map" can be appended to the kernel as a binary map by your
+	  boot loader.  This can allow you to reliably run a machine with
+	  memory modules that contain certain kinds of faults.
+
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support"
@@ -1268,6 +1277,10 @@ config ARCH_SPARSEMEM_ENABLE
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
 
+config MAX_ACTIVE_REGIONS
+	int "Maximum number of distinct ranges of memory." if E820EX
+	default 2048
+
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
 	depends on ARCH_SPARSEMEM_ENABLE
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index faff0dc..9c856b5 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -33,6 +33,9 @@
 #include <asm/msr.h>
 #include <asm/processor-flags.h>
 #include <asm/asm-offsets.h>
+#ifdef CONFIG_E820EX
+#include <asm/e820.h>
+#endif /* CONFIG_E820EX */
 
 	__HEAD
 	.code32
@@ -65,6 +68,34 @@ ENTRY(startup_32)
 1:	popl	%ebp
 	subl	$1b, %ebp
 
+#ifdef CONFIG_E820EX
+/* Move extended e820 memory map if found.
+ * The bootloader loads the extended e820 map in memory, immediately after
+ * the compressed kernel.  But the kernel's bootstrapping code uses that memory
+ * as bss.  The extended e820 memory map must be moved out of the way, at this
+ * point before the memory is overwritten with bss data.
+ * Check for an E820 memory map data structure at the (512 byte) sector
+ * following the kernel image.  If found, copy it to address E820EX_MAP
+ * where the kernel knows to look for it.
+ */
+	movl	%esi, %eax		/* save %esi */
+	leal	_edata+511(%ebp), %esi
+	andl	$-512, %esi		/* %rsi points to header */
+	cmpl	$E820EX_MAGIC, (%esi)	/* header->magic */
+	jne	invalid
+	cmpl	$E820EX_MAX, 12(%esi)	/* header->nr_map */
+	ja	invalid
+	movl	4(%esi), %ecx		/* header->len */
+	cmp	$(E820EX_MAX*20), %ecx	/* 20=sizeof (struct e820entry) */
+	ja	invalid
+	movl	$E820EX_MAP, %edi	/* destination */
+	shrl	$2, %ecx		/* bytes to (32-bit) words */
+	addl	$4, %ecx		/* 4 more words for header */
+	cld; rep; movsl			/* repeated move */
+invalid:
+	movl	%eax, %esi		/* restore %esi */
+#endif /* CONFIG_E820EX */
+
 /* setup a stack and make sure cpu supports long mode. */
 	movl	$boot_stack_end, %eax
 	addl	%ebp, %eax
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 51e2407..f98ac14 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -26,6 +26,7 @@
 #include <asm/page.h>
 #include <asm/boot.h>
 #include <asm/bootparam.h>
+#include <asm/e820.h>
 
 /* WARNING!!
  * This code is compiled with -fPIC and it is relocated dynamically
@@ -161,6 +162,59 @@ static int lines, cols;
 #include "../../../../lib/decompress_unlzo.c"
 #endif
 
+static ulg crc_32_tab[256];
+
+/*
+ * Code to compute the CRC-32 table. Borrowed from
+ * lib/inflate.c.
+ */
+
+static void makecrc(void)
+{
+	/* Not copyrighted 1990 Mark Adler */
+
+	unsigned long c;	/* crc shift register */
+	unsigned long e;	/* polynomial exclusive-or pattern */
+	int i;			/* counter for all possible eight bit values */
+	int k;			/* byte being shifted into crc apparatus */
+
+	/* terms of polynomial defining this crc (except x^32): */
+	static const int p[] = {0, 1, 2, 4, 5, 7, 8, 10, 11, 12, 16,
+				22, 23, 26};
+
+	/* Make exclusive-or pattern from polynomial */
+	e = 0;
+	for (i = 0; i < sizeof(p)/sizeof(int); i++)
+		e |= 1L << (31 - p[i]);
+
+	crc_32_tab[0] = 0;
+
+	for (i = 1; i < 256; i++) {
+		c = 0;
+		for (k = i | 256; k != 1; k >>= 1) {
+			c = c & 1 ? (c >> 1) ^ e : c >> 1;
+			if (k & 1)
+				c ^= e;
+		}
+		crc_32_tab[i] = c;
+	}
+}
+
+static __u32 crc32(const void *buf, size_t len)
+{
+	const unsigned char *in = buf;
+	unsigned char ch;
+	unsigned int n;
+	__u32 crc = 0xffffffffU;
+
+	for (n = 0; n < len; n++) {
+		ch = *in++;
+		crc = crc_32_tab[(crc ^ ch) & 0xff] ^ (crc >> 8);
+	}
+
+	return crc;
+}
+
 static void scroll(void)
 {
 	int i;
@@ -237,6 +291,20 @@ void *memcpy(void *dest, const void *src, size_t n)
 	return dest;
 }
 
+void *memmove(void *dest, const void *src, size_t n)
+{
+	int i;
+	const char *s = src;
+	char *d = dest;
+
+	if (dest < src)
+		return memcpy(dest, src, n);
+
+	for (i = n - 1; i >= 0; i--)
+		d[i] = s[i];
+	return dest;
+}
+
 
 static void error(char *x)
 {
@@ -298,6 +366,71 @@ static void parse_elf(void *output)
 	}
 }
 
+#ifdef CONFIG_E820EX
+/* Verify extended e820.
+ * The assembly code in head.S moves the extended e820 data to E820EX_MAP
+ * if it exists.
+ * verify_e820() verifies the extended e820 data.  It checks if an
+ * extended e820 map exists at E820EX_MAP by looking for E820EX_MAGIC.  It also
+ * verifies that the number of e820 entries (e820ex->nr_map) is consistent with
+ * the specified length (e820ex->len).  Then the crc of the e820 entries is
+ * computed and compared with the included (e820ex->crc).  If the crc's match,
+ * then the extended e820 map has been found and a pointer to the extended
+ * e820 map is returned.
+ */
+static struct e820map_ex *verify_e820(void)
+{
+	struct e820map_ex *e820ex = (struct e820map_ex *)E820EX_MAP;
+
+	if (e820ex->magic == E820EX_MAGIC) {
+		putstr("Potential extended e820 map.");
+		/* Check that the number of entries don't exceed predefined
+		 * max, E820EX_MAX. Sanity check against the length.
+		 */
+		if (e820ex->nr_map <= E820EX_MAX &&
+		    sizeof(struct e820entry) * e820ex->nr_map == e820ex->len) {
+			__u32 crc = crc32(e820ex->e820_entries, e820ex->len);
+
+			if (crc == e820ex->crc)
+				return e820ex;
+		}
+		/* Kill the invalid map. */
+		e820ex->magic = 0;
+	}
+
+	return NULL;
+}
+
+/*
+ * Process extended e820 map if it is present.
+ * Any extended e820 map has been relocated to address E820EX_MAP by head_64.S.
+ * Append a copy of the BIOS's e820 map from the boot_params and update the
+ * length in the header.
+ *
+ * This doesn't bother to update the CRC - the kernel does not check it.
+ */
+static void handle_e820(void)
+{
+	const unsigned int e820_nr = real_mode->e820_entries;
+	struct e820map_ex *e820ex = verify_e820();
+	unsigned int biosmaplen = sizeof(struct e820entry) * e820_nr;
+	char *end;
+
+	if (e820ex == NULL)
+		return;
+
+	/* Extended e820 found */
+	putstr("Found extended e820\n");
+
+	/* Append BIOS e820 map entries */
+	end = (char *)e820ex->e820_entries + e820ex->len;
+	memcpy(end, real_mode->e820_map, biosmaplen);
+	/* Update count and len with # entries and length from BIOS map. */
+	e820ex->nr_map += e820_nr;
+	e820ex->len += biosmaplen;
+}
+#endif /* CONFIG_E820EX */
+
 asmlinkage void decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *input_data,
 				  unsigned long input_len,
@@ -305,6 +438,11 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 {
 	real_mode = rmode;
 
+#ifdef CONFIG_E820EX
+	makecrc();
+	handle_e820();
+#endif /* CONFIG_E820EX */
+
 	if (real_mode->hdr.loadflags & QUIET_FLAG)
 		quiet = 1;
 
diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 0e22296..61103e7 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -3,6 +3,17 @@
 #define E820MAP	0x2d0		/* our map */
 #define E820MAX	128		/* number of entries in E820MAP */
 
+#ifdef CONFIG_E820EX
+#define E820EX_MAX 0x4000	/* max entries supported in extended e820 */
+#define E820EX_MAGIC 0x1234cafe	/* Magic used in extended e820 header */
+#define E820EX_MAP 0x4000000	/* Temporary location where extended e820 is */
+				/* relocated to in order to get out of the   */
+				/* way of bss. */
+#else /* CONFIG_E820EX */
+#define E820EX_MAX 0
+#endif /* CONFIG_E820EX */
+
+
 /*
  * Legacy E820 BIOS limits us to 128 (E820MAX) nodes due to the
  * constrained space in the zeropage.  If we have more nodes than
@@ -45,6 +56,8 @@
 #define E820_NVS	4
 #define E820_UNUSABLE	5
 
+#define E820_BADRAM	127
+
 /* reserved RAM used by kernel itself */
 #define E820_RESERVED_KERN        128
 
@@ -56,11 +69,26 @@ struct e820entry {
 	__u32 type;	/* type of memory segment */
 } __attribute__((packed));
 
+/* Used by code CONFIG_E820EX code in head_64.S and misc.c.
+ * Changes to e820map_ex must be reflected that code.
+ */
 struct e820map {
 	__u32 nr_map;
-	struct e820entry map[E820_X_MAX];
+	__u32 max_map;
+	struct e820entry *map;
+	struct e820entry map_array[E820_X_MAX];
 };
 
+struct e820map_ex {
+	__u32 magic;	/* should be E820EX_MAGIC */
+	__u32 len;	/* length in bytes of data in e820_entries */
+	__u32 crc;	/* crc over data in e820_entries */
+	__u32 nr_map;	/* number of struct e820entry in e820_entries
+			 * should be sizeof(struct e820entry) * nr_map = len */
+	struct e820entry e820_entries[0];	/* variable array of struct */
+						/* e820entry */
+} __attribute__((packed));
+
 #define ISA_START_ADDRESS	0xa0000
 #define ISA_END_ADDRESS		0x100000
 
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 7bca3c6..0b26153 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -15,6 +15,7 @@
 #include <linux/pfn.h>
 #include <linux/suspend.h>
 #include <linux/firmware-map.h>
+#include <linux/sort.h>
 
 #include <asm/e820.h>
 #include <asm/proto.h>
@@ -107,7 +108,7 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
 {
 	int x = e820x->nr_map;
 
-	if (x >= ARRAY_SIZE(e820x->map)) {
+	if (x >= e820x->max_map) {
 		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
 		return;
 	}
@@ -142,6 +143,9 @@ static void __init e820_print_type(u32 type)
 	case E820_UNUSABLE:
 		printk(KERN_CONT "(unusable)");
 		break;
+	case E820_BADRAM:
+		printk(KERN_CONT "(badram)");
+		break;
 	default:
 		printk(KERN_CONT "type %u", type);
 		break;
@@ -223,22 +227,46 @@ void __init e820_print_map(char *who)
  *	   ____________________33__
  *	   ______________________4_
  */
+struct change_member {
+	struct e820entry *pbios; /* pointer to original bios entry */
+	unsigned long long addr; /* address for this change point */
+};
+
+static int __init cpcompare(const void *a, const void *b)
+{
+	struct change_member * const *app = a, * const *bpp = b;
+	const struct change_member *ap = *app, *bp = *bpp;
 
+	/*
+	 * Inputs are pointers to two elements of change_point[].  If their
+	 * addresses are unequal, their difference dominates.  If the addresses
+	 * are equal, then consider one that represents the end of its region
+	 * to be greater than one that does not.
+	 */
+	if (ap->addr != bp->addr)
+		return ap->addr > bp->addr ? 1 : -1;
+
+	return (ap->addr != ap->pbios->addr) - (bp->addr != bp->pbios->addr);
+}
+
+/* 2 * E820EX_MAX is necessary because the extended e820 entries break up
+ * bios ram entry into additional entries and the sanitize buffers need to be
+ * large enough to hold it all.  In general the extended e820 entries creates
+ * twice its number in entries.  For example, if 1-10 is ram, and two extended
+ * e820 entries, 3-4, 7-8, breaks it up into: 1-2, 3-4, 5-6, 7-8, 9-10.  There
+ * are 4 entries created by the two extended e820 entries.
+ */
+#define SANITIZE_SZ (E820_X_MAX + 2 * E820EX_MAX)
 int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 			     u32 *pnr_map)
 {
-	struct change_member {
-		struct e820entry *pbios; /* pointer to original bios entry */
-		unsigned long long addr; /* address for this change point */
-	};
-	static struct change_member change_point_list[2*E820_X_MAX] __initdata;
-	static struct change_member *change_point[2*E820_X_MAX] __initdata;
-	static struct e820entry *overlap_list[E820_X_MAX] __initdata;
-	static struct e820entry new_bios[E820_X_MAX] __initdata;
-	struct change_member *change_tmp;
+	static struct change_member change_point_list[2*SANITIZE_SZ] __initdata;
+	static struct change_member *change_point[2*SANITIZE_SZ] __initdata;
+	static struct e820entry *overlap_list[SANITIZE_SZ] __initdata;
+	static struct e820entry new_bios[SANITIZE_SZ] __initdata;
 	unsigned long current_type, last_type;
 	unsigned long long last_addr;
-	int chgidx, still_changing;
+	int chgidx;
 	int overlap_entries;
 	int new_bios_entry;
 	int old_nr, new_nr, chg_nr;
@@ -275,35 +303,7 @@ int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 	chg_nr = chgidx;
 
 	/* sort change-point list by memory addresses (low -> high) */
-	still_changing = 1;
-	while (still_changing)	{
-		still_changing = 0;
-		for (i = 1; i < chg_nr; i++)  {
-			unsigned long long curaddr, lastaddr;
-			unsigned long long curpbaddr, lastpbaddr;
-
-			curaddr = change_point[i]->addr;
-			lastaddr = change_point[i - 1]->addr;
-			curpbaddr = change_point[i]->pbios->addr;
-			lastpbaddr = change_point[i - 1]->pbios->addr;
-
-			/*
-			 * swap entries, when:
-			 *
-			 * curaddr > lastaddr or
-			 * curaddr == lastaddr and curaddr == curpbaddr and
-			 * lastaddr != lastpbaddr
-			 */
-			if (curaddr < lastaddr ||
-			    (curaddr == lastaddr && curaddr == curpbaddr &&
-			     lastaddr != lastpbaddr)) {
-				change_tmp = change_point[i];
-				change_point[i] = change_point[i-1];
-				change_point[i-1] = change_tmp;
-				still_changing = 1;
-			}
-		}
-	}
+	sort(change_point, chg_nr, sizeof *change_point, cpcompare, 0);
 
 	/* create a new bios memory map, removing overlaps */
 	overlap_entries = 0;	 /* number of entries in the overlap table */
@@ -571,18 +571,17 @@ void __init update_e820(void)
 	u32 nr_map;
 
 	nr_map = e820.nr_map;
-	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
+	if (sanitize_e820_map(e820.map, e820.max_map, &nr_map))
 		return;
 	e820.nr_map = nr_map;
-	printk(KERN_INFO "modified physical RAM map:\n");
-	e820_print_map("modified");
 }
+
 static void __init update_e820_saved(void)
 {
 	u32 nr_map;
 
 	nr_map = e820_saved.nr_map;
-	if (sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map), &nr_map))
+	if (sanitize_e820_map(e820_saved.map, e820_saved.max_map, &nr_map))
 		return;
 	e820_saved.nr_map = nr_map;
 }
@@ -677,7 +676,7 @@ void __init parse_e820_ext(struct setup_data *sdata, unsigned long pa_data)
 		sdata = early_ioremap(pa_data, map_len);
 	extmap = (struct e820entry *)(sdata->data);
 	__append_e820_map(extmap, entries);
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map(e820.map, e820.max_map, &e820.nr_map);
 	if (map_len > PAGE_SIZE)
 		early_iounmap(sdata, map_len);
 	printk(KERN_INFO "extended physical RAM map:\n");
@@ -1044,7 +1043,7 @@ void __init finish_e820_parsing(void)
 	if (userdef) {
 		u32 nr = e820.nr_map;
 
-		if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
+		if (sanitize_e820_map(e820.map, e820.max_map, &nr) < 0)
 			early_panic("Invalid user supplied memory map");
 		e820.nr_map = nr;
 
@@ -1061,6 +1060,7 @@ static inline const char *e820_type_to_string(int e820_type)
 	case E820_ACPI:	return "ACPI Tables";
 	case E820_NVS:	return "ACPI Non-volatile Storage";
 	case E820_UNUSABLE:	return "Unusable memory";
+	case E820_BADRAM:	return "BadRAM";
 	default:	return "reserved";
 	}
 }
@@ -1148,12 +1148,14 @@ void __init e820_reserve_resources_late(void)
 		struct e820entry *entry = &e820.map[i];
 		u64 start, end;
 
-		if (entry->type != E820_RAM)
+		if (entry->type != E820_RAM && entry->type != E820_BADRAM)
 			continue;
 		start = entry->addr + entry->size;
 		end = round_up(start, ram_alignment(start)) - 1;
 		if (end > MAX_RESOURCE_SIZE)
 			end = MAX_RESOURCE_SIZE;
+		if (i < e820.nr_map - 1 && end > e820.map[i + 1].addr - 1)
+			end = e820.map[i + 1].addr - 1;
 		if (start >= end)
 			continue;
 		printk(KERN_DEBUG "reserve RAM buffer: %016llx - %016llx ",
@@ -1163,6 +1165,168 @@ void __init e820_reserve_resources_late(void)
 	}
 }
 
+static void __init e820_set_array(struct e820map *e820x, u32 nr_map)
+{
+	e820x->map = e820x->map_array;
+	e820x->max_map = ARRAY_SIZE(e820x->map_array);
+	e820x->nr_map = nr_map;
+}
+
+#ifdef CONFIG_E820EX
+/*
+ * Acquiring the extended E820 map requires some tricks because it has
+ * variable size, we don't yet have access to dynamic memory allocation, and
+ * we don't want to waste any memory when there is no (or a small) map.
+ *
+ * The approach used is to use static __initdata temporary buffers big enough
+ * to hold the maximum sized data, and copy from those temporary buffers to
+ * allocated memory later, when that becomes possible (in an early_initcall).
+ * There is one buffer for the actual E820 map.  All __initdata is freed when
+ * the kernel completes its initialization phase.
+ */
+
+static u32 e820_nr_map __initdata;
+static struct e820entry e820ex_intermediate[SANITIZE_SZ] __initdata;
+
+static void __init e820_set_intermediate(u32 nr_map)
+{
+	e820.map = e820ex_intermediate;
+	e820.max_map = ARRAY_SIZE(e820ex_intermediate);
+	e820.nr_map = nr_map;
+}
+
+static int __init e820ex_init(void)
+{
+	if (e820.map == e820ex_intermediate) {
+		u32 max_buffer_entries = e820.nr_map + E820_X_MAX;
+		u32 size = sizeof(struct e820entry) * max_buffer_entries;
+		struct e820entry *entry = NULL;
+		entry = (struct e820entry *)__get_free_pages(
+			GFP_KERNEL, get_order(size));
+		if (entry) {
+			printk(KERN_INFO "e820ex: Final resting place 0x%p.\n",
+			       entry);
+			memcpy(entry, e820.map,
+			       e820.nr_map * sizeof(struct e820entry));
+			e820.map = entry;
+			e820.max_map = max_buffer_entries;
+		} else {
+			printk(KERN_INFO "e820ex: ioremap failed.\n");
+			e820_set_array(&e820, e820_nr_map);
+		}
+	}
+
+	if (e820.map == e820.map_array)
+		printk(KERN_INFO "e820ex: Using BIOS e820 map.\n");
+	else
+		printk(KERN_INFO "e820ex: Using extended e820 map.\n");
+
+	return 0;
+}
+early_initcall(e820ex_init);
+
+static size_t __init pa_memcpy(void *dest, phys_addr_t pa_src, size_t size)
+{
+	u64 max_remap_len = PAGE_SIZE * NR_FIX_BTMAPS;
+	u64 remapped_len;
+	u64 len_copied = 0;
+	phys_addr_t start_addr = pa_src;
+	u8 *dest_addr = dest;
+	phys_addr_t page_start;
+	phys_addr_t page_end;
+	phys_addr_t end;
+	phys_addr_t end_addr = start_addr + size;
+	void *remapped_addr = NULL;
+
+	while (len_copied < size) {
+		page_start = start_addr & PAGE_MASK;
+		page_end = page_start + max_remap_len;
+		end = end_addr < page_end ? end_addr : page_end;
+
+		remapped_len = end - start_addr;
+		remapped_addr = early_memremap(start_addr, remapped_len);
+		if (!remapped_addr)
+			break;
+		memcpy(dest_addr + len_copied, remapped_addr,
+		       remapped_len);
+
+		early_iounmap(remapped_addr, remapped_len);
+		len_copied += remapped_len;
+		start_addr += remapped_len;
+	}
+
+	return len_copied;
+}
+
+static int __init e820ex_copy_intermediate(phys_addr_t pa_data)
+{
+	struct e820map_ex ex;
+	size_t len_copied;
+
+	/* Initially, existence of the map is unknown, as is the size of the
+	 * extended e820 map.  Copy the e820ex header to check for existence of
+	 * the extended e820 map, before copy the rest of it.
+	 */
+	if (pa_memcpy(&ex, pa_data, sizeof(ex)) < sizeof(ex)) {
+		printk(KERN_DEBUG "Error copying extended e820 metadata.\n");
+		return 0;
+	}
+
+	if (ex.magic != E820EX_MAGIC || ex.len > sizeof(e820ex_intermediate)) {
+		printk(KERN_INFO "%s: No valid extended e820 found.\n",
+		       __func__);
+		return 0;
+	}
+
+	len_copied = pa_memcpy(
+		&e820ex_intermediate,
+		pa_data + offsetof(struct e820map_ex, e820_entries),
+		ex.len);
+	if (len_copied != ex.len) {
+		printk(KERN_INFO "%s: 0x%lx of 0x%x copied.\n",
+		       __func__, len_copied, ex.len);
+		return 0;
+	}
+
+	return ex.nr_map;
+}
+
+/* Process extended e820 map.
+ * The early kernel boot relocated the extended e820 map from the end
+ * of the compressed kernel, out of the way of decompress_kernel(), to physical
+ * address E820_MAP.
+ * Process the extended e820 map at physical address, pa_data:
+ *   1. First check if e820 map exists by checking for E820EX_MAGIC.
+ *   2. Copy e820 map to intermediate location.
+ *   3. Call sanitize() on e820 map located at intermediate location.
+ */
+static int __init handle_e820_map_ex(phys_addr_t pa_data)
+{
+	int found = 0;
+	u32 nr_map = 0;
+	nr_map = e820ex_copy_intermediate(pa_data);
+	if (nr_map) {
+		if (sanitize_e820_map(
+			e820ex_intermediate, ARRAY_SIZE(e820ex_intermediate),
+			&nr_map) < 0) {
+			printk(KERN_ERR "Extended e820 sanitize failed.\n");
+		} else {
+			e820_nr_map = e820.nr_map;
+			/* Temporarily make the extended e820 the one used by
+			 * global variable e820.
+			 */
+			e820_set_intermediate(nr_map);
+			found = 1;
+			printk(KERN_INFO "Extended e820 sanitized.\n");
+		}
+	} else {
+		printk(KERN_DEBUG "Extended e820 data not found.\n");
+	}
+
+	return found ? 0 : -1;
+}
+#endif /* CONFIG_E820EX */
+
 char *__init default_machine_specific_memory_setup(void)
 {
 	char *who = "BIOS-e820";
@@ -1173,10 +1337,10 @@ char *__init default_machine_specific_memory_setup(void)
 	 * Otherwise fake a memory map; one section from 0k->640k,
 	 * the next section from 1mb->appropriate_mem_k
 	 */
+	e820_set_array(&e820, 0);
+	e820_set_array(&e820_saved, 0);
 	new_nr = boot_params.e820_entries;
-	sanitize_e820_map(boot_params.e820_map,
-			ARRAY_SIZE(boot_params.e820_map),
-			&new_nr);
+	sanitize_e820_map(boot_params.e820_map, e820.max_map, &new_nr);
 	boot_params.e820_entries = new_nr;
 	if (append_e820_map(boot_params.e820_map, boot_params.e820_entries)
 	  < 0) {
@@ -1209,4 +1373,10 @@ void __init setup_memory_map(void)
 	memcpy(&e820_saved, &e820, sizeof(struct e820map));
 	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
 	e820_print_map(who);
+
+#ifdef CONFIG_E820EX
+	if (handle_e820_map_ex(E820EX_MAP) < 0)
+		printk(KERN_ERR "Error processing extended e820.  Ignoring.\n");
+
+#endif /* CONFIG_E820EX */
 }
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index c2fa9b8..9af87e3 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -272,7 +272,7 @@ static void __init do_add_efi_memmap(void)
 		}
 		e820_add_region(start, size, e820_type);
 	}
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map(e820.map, e820.max_map, &e820.nr_map);
 }
 
 void __init efi_reserve_early(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c4851ef..1372e02 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -462,7 +462,7 @@ static void __init e820_reserve_setup_data(void)
 	if (!found)
 		return;
 
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map(e820.map, e820.max_map, &e820.nr_map);
 	memcpy(&e820_saved, &e820, sizeof(struct e820map));
 	printk(KERN_INFO "extended physical RAM map:\n");
 	e820_print_map("reserve setup_data");
@@ -625,7 +625,7 @@ static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 		d->ident);
 
 	e820_update_range(0, 0x10000, E820_RAM, E820_RESERVED);
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map(e820.map, e820.max_map, &e820.nr_map);
 
 	return 0;
 }
@@ -694,7 +694,7 @@ static void __init trim_bios_range(void)
 	 * take them out.
 	 */
 	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map(e820.map, e820.max_map, &e820.nr_map);
 }
 
 /*
@@ -865,7 +865,7 @@ void __init setup_arch(char **cmdline_p)
 	if (ppro_with_ram_bug()) {
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
 				  E820_RESERVED);
-		sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+		sanitize_e820_map(e820.map, e820.max_map, &e820.nr_map);
 		printk(KERN_INFO "fixed physical RAM map:\n");
 		e820_print_map("bad_ppro");
 	}
-- 
1.7.3.1

