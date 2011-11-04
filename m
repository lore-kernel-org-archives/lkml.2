Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1KDMX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:23:26 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:63243 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab1KDMXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:23:24 -0400
Date: Fri, 4 Nov 2011 13:23:21 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: siglesia@cern.ch, manohar.vanga@cern.ch
Subject: [RFC PATCH 2/2] modpost: use config and ELF sections to build
 file2alias
Message-ID: <5fc02021bb75a6d325b7ebcdd657ca81667fe8b2.1320408578.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1320408578.git.rubini@gnudd.com>
In-Reply-To: <cover.1320408578.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds a temporary ELF section, then folded into .data, in
order to be able to split bus types to their own individual files.
Since modpost is built for each specific kernel, we can leave off
device types that are not relevant.

Even better, people adding new bus types can just drop in their own
file without patching file2alias over and over, with high chances to
get a collision.

The patch only pulls 4 bus types off file2alias, as a working example
that the approach works and the result is maintainable.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Samuel I. Gonsalvez <siglesia@cern.ch>
Acked-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 scripts/mod/Makefile        |   13 +++-
 scripts/mod/alias_acpi.c    |   14 ++++
 scripts/mod/alias_bcma.c    |   25 +++++++
 scripts/mod/alias_pci.c     |   49 +++++++++++++
 scripts/mod/alias_spi.c     |   15 ++++
 scripts/mod/device_switch.h |   47 +++++++++++++
 scripts/mod/file2alias.c    |  162 +++----------------------------------------
 scripts/mod/modpost.h       |   18 +++++
 scripts/mod/modpost.lds     |    9 +++
 9 files changed, 200 insertions(+), 152 deletions(-)
 create mode 100644 scripts/mod/alias_acpi.c
 create mode 100644 scripts/mod/alias_bcma.c
 create mode 100644 scripts/mod/alias_pci.c
 create mode 100644 scripts/mod/alias_spi.c
 create mode 100644 scripts/mod/device_switch.h
 create mode 100644 scripts/mod/modpost.lds

diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index ff954f8..96c3b58 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -1,7 +1,18 @@
 hostprogs-y	:= modpost mk_elfconfig
 always		:= $(hostprogs-y) empty.o
 
-modpost-objs	:= modpost.o file2alias.o sumversion.o
+# we can use bool or tristate options here
+modpost-y	:= modpost.o file2alias.o sumversion.o
+modpost-$(CONFIG_ACPI)		+= alias_acpi.o
+modpost-$(CONFIG_BCMA)		+= alias_bcma.o
+modpost-$(CONFIG_PCI)		+= alias_pci.o
+modpost-$(CONFIG_SPI)		+= alias_spi.o
+modpost-y	+= $(modpost-m)
+
+
+modpost-objs	+= $(modpost-y)
+
+HOSTLDFLAGS := $(obj)/modpost.lds
 
 # dependencies on generated files need to be listed explicitly
 
diff --git a/scripts/mod/alias_acpi.c b/scripts/mod/alias_acpi.c
new file mode 100644
index 0000000..acb6842
--- /dev/null
+++ b/scripts/mod/alias_acpi.c
@@ -0,0 +1,14 @@
+#include "modpost.h"
+#include "device_switch.h"
+
+/* looks like: "acpi:ACPI0003 or acpi:PNP0C0B" or "acpi:LNXVIDEO" */
+static int do_acpi_entry(const char *filename,
+			struct acpi_device_id *id, char *alias)
+{
+	sprintf(alias, "acpi*:%s:*", id->id);
+	return 1;
+}
+
+static struct devtable_switch dt_sw_acpi[] __DEVTABLE_SWITCH = {
+	E("acpi", "__mod_acpi_device_table", acpi_device_id, do_acpi_entry),
+};
diff --git a/scripts/mod/alias_bcma.c b/scripts/mod/alias_bcma.c
new file mode 100644
index 0000000..87fa860
--- /dev/null
+++ b/scripts/mod/alias_bcma.c
@@ -0,0 +1,25 @@
+
+#include "modpost.h"
+#include "device_switch.h"
+
+/* Looks like: bcma:mNidNrevNclN. */
+static int do_bcma_entry(const char *filename,
+			 struct bcma_device_id *id, char *alias)
+{
+	id->manuf = TO_NATIVE(id->manuf);
+	id->id = TO_NATIVE(id->id);
+	id->rev = TO_NATIVE(id->rev);
+	id->class = TO_NATIVE(id->class);
+
+	strcpy(alias, "bcma:");
+	ADD(alias, "m", id->manuf != BCMA_ANY_MANUF, id->manuf);
+	ADD(alias, "id", id->id != BCMA_ANY_ID, id->id);
+	ADD(alias, "rev", id->rev != BCMA_ANY_REV, id->rev);
+	ADD(alias, "cl", id->class != BCMA_ANY_CLASS, id->class);
+	add_wildcard(alias);
+	return 1;
+}
+
+static struct devtable_switch dt_sw_bcma[] __DEVTABLE_SWITCH = {
+	E("bcma", "__mod_bcma_device_table", bcma_device_id, do_bcma_entry),
+};
diff --git a/scripts/mod/alias_pci.c b/scripts/mod/alias_pci.c
new file mode 100644
index 0000000..90f3a9a
--- /dev/null
+++ b/scripts/mod/alias_pci.c
@@ -0,0 +1,49 @@
+#include "modpost.h"
+#include "device_switch.h"
+
+/* Looks like: pci:vNdNsvNsdNbcNscNiN. */
+static int do_pci_entry(const char *filename,
+			struct pci_device_id *id, char *alias)
+{
+	/* Class field can be divided into these three. */
+	unsigned char baseclass, subclass, interface,
+		baseclass_mask, subclass_mask, interface_mask;
+
+	id->vendor = TO_NATIVE(id->vendor);
+	id->device = TO_NATIVE(id->device);
+	id->subvendor = TO_NATIVE(id->subvendor);
+	id->subdevice = TO_NATIVE(id->subdevice);
+	id->class = TO_NATIVE(id->class);
+	id->class_mask = TO_NATIVE(id->class_mask);
+
+	strcpy(alias, "pci:");
+	ADD(alias, "v", id->vendor != PCI_ANY_ID, id->vendor);
+	ADD(alias, "d", id->device != PCI_ANY_ID, id->device);
+	ADD(alias, "sv", id->subvendor != PCI_ANY_ID, id->subvendor);
+	ADD(alias, "sd", id->subdevice != PCI_ANY_ID, id->subdevice);
+
+	baseclass = (id->class) >> 16;
+	baseclass_mask = (id->class_mask) >> 16;
+	subclass = (id->class) >> 8;
+	subclass_mask = (id->class_mask) >> 8;
+	interface = id->class;
+	interface_mask = id->class_mask;
+
+	if ((baseclass_mask != 0 && baseclass_mask != 0xFF)
+	    || (subclass_mask != 0 && subclass_mask != 0xFF)
+	    || (interface_mask != 0 && interface_mask != 0xFF)) {
+		warn("Can't handle masks in %s:%04X\n",
+		     filename, id->class_mask);
+		return 0;
+	}
+
+	ADD(alias, "bc", baseclass_mask == 0xFF, baseclass);
+	ADD(alias, "sc", subclass_mask == 0xFF, subclass);
+	ADD(alias, "i", interface_mask == 0xFF, interface);
+	add_wildcard(alias);
+	return 1;
+}
+
+static struct devtable_switch dt_sw_pci[] __DEVTABLE_SWITCH = {
+	E("pci", "__mod_pci_device_table", pci_device_id, do_pci_entry),
+};
diff --git a/scripts/mod/alias_spi.c b/scripts/mod/alias_spi.c
new file mode 100644
index 0000000..d509820
--- /dev/null
+++ b/scripts/mod/alias_spi.c
@@ -0,0 +1,15 @@
+#include "modpost.h"
+#include "device_switch.h"
+
+/* Looks like: spi:S */
+static int do_spi_entry(const char *filename, struct spi_device_id *id,
+			char *alias)
+{
+	sprintf(alias, SPI_MODULE_PREFIX "%s", id->name);
+
+	return 1;
+}
+
+static struct devtable_switch dt_sw_spi[] __DEVTABLE_SWITCH = {
+	E("spi", "__mod_spi_device_table", spi_device_id, do_spi_entry),
+};
diff --git a/scripts/mod/device_switch.h b/scripts/mod/device_switch.h
new file mode 100644
index 0000000..9443cd5
--- /dev/null
+++ b/scripts/mod/device_switch.h
@@ -0,0 +1,47 @@
+/* We use the ELF typedefs for kernel_ulong_t but bite the bullet and
+ * use either stdint.h or inttypes.h for the rest. */
+#if KERNEL_ELFCLASS == ELFCLASS32
+typedef Elf32_Addr	kernel_ulong_t;
+#define BITS_PER_LONG 32
+#else
+typedef Elf64_Addr	kernel_ulong_t;
+#define BITS_PER_LONG 64
+#endif
+#ifdef __sun__
+#include <inttypes.h>
+#else
+#include <stdint.h>
+#endif
+
+#include <ctype.h>
+
+typedef uint32_t	__u32;
+typedef uint16_t	__u16;
+typedef unsigned char	__u8;
+
+/* Big exception to the "don't include kernel headers into userspace, which
+ * even potentially has different endianness and word sizes, since
+ * we handle those differences explicitly below */
+#include "../../include/linux/mod_devicetable.h"
+
+#define ADD(str, sep, cond, field)                              \
+do {                                                            \
+        strcat(str, sep);                                       \
+        if (cond)                                               \
+                sprintf(str + strlen(str),                      \
+                        sizeof(field) == 1 ? "%02X" :           \
+                        sizeof(field) == 2 ? "%04X" :           \
+                        sizeof(field) == 4 ? "%08X" : "",       \
+                        field);                                 \
+        else                                                    \
+                sprintf(str + strlen(str), "*");                \
+} while(0)
+
+/* Always end in a wildcard, for future extension */
+static inline void add_wildcard(char *str)
+{
+	int len = strlen(str);
+
+	if (str[len - 1] != '*')
+		strcat(str + len, "*");
+}
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 1247bc9..8e91fe4 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -11,54 +11,7 @@
  */
 
 #include "modpost.h"
-
-/* We use the ELF typedefs for kernel_ulong_t but bite the bullet and
- * use either stdint.h or inttypes.h for the rest. */
-#if KERNEL_ELFCLASS == ELFCLASS32
-typedef Elf32_Addr	kernel_ulong_t;
-#define BITS_PER_LONG 32
-#else
-typedef Elf64_Addr	kernel_ulong_t;
-#define BITS_PER_LONG 64
-#endif
-#ifdef __sun__
-#include <inttypes.h>
-#else
-#include <stdint.h>
-#endif
-
-#include <ctype.h>
-
-typedef uint32_t	__u32;
-typedef uint16_t	__u16;
-typedef unsigned char	__u8;
-
-/* Big exception to the "don't include kernel headers into userspace, which
- * even potentially has different endianness and word sizes, since
- * we handle those differences explicitly below */
-#include "../../include/linux/mod_devicetable.h"
-
-#define ADD(str, sep, cond, field)                              \
-do {                                                            \
-        strcat(str, sep);                                       \
-        if (cond)                                               \
-                sprintf(str + strlen(str),                      \
-                        sizeof(field) == 1 ? "%02X" :           \
-                        sizeof(field) == 2 ? "%04X" :           \
-                        sizeof(field) == 4 ? "%08X" : "",       \
-                        field);                                 \
-        else                                                    \
-                sprintf(str + strlen(str), "*");                \
-} while(0)
-
-/* Always end in a wildcard, for future extension */
-static inline void add_wildcard(char *str)
-{
-	int len = strlen(str);
-
-	if (str[len - 1] != '*')
-		strcat(str + len, "*");
-}
+#include "device_switch.h"
 
 unsigned int cross_build = 0;
 /**
@@ -314,49 +267,6 @@ static int do_ieee1394_entry(const char *filename,
 	return 1;
 }
 
-/* Looks like: pci:vNdNsvNsdNbcNscNiN. */
-static int do_pci_entry(const char *filename,
-			struct pci_device_id *id, char *alias)
-{
-	/* Class field can be divided into these three. */
-	unsigned char baseclass, subclass, interface,
-		baseclass_mask, subclass_mask, interface_mask;
-
-	id->vendor = TO_NATIVE(id->vendor);
-	id->device = TO_NATIVE(id->device);
-	id->subvendor = TO_NATIVE(id->subvendor);
-	id->subdevice = TO_NATIVE(id->subdevice);
-	id->class = TO_NATIVE(id->class);
-	id->class_mask = TO_NATIVE(id->class_mask);
-
-	strcpy(alias, "pci:");
-	ADD(alias, "v", id->vendor != PCI_ANY_ID, id->vendor);
-	ADD(alias, "d", id->device != PCI_ANY_ID, id->device);
-	ADD(alias, "sv", id->subvendor != PCI_ANY_ID, id->subvendor);
-	ADD(alias, "sd", id->subdevice != PCI_ANY_ID, id->subdevice);
-
-	baseclass = (id->class) >> 16;
-	baseclass_mask = (id->class_mask) >> 16;
-	subclass = (id->class) >> 8;
-	subclass_mask = (id->class_mask) >> 8;
-	interface = id->class;
-	interface_mask = id->class_mask;
-
-	if ((baseclass_mask != 0 && baseclass_mask != 0xFF)
-	    || (subclass_mask != 0 && subclass_mask != 0xFF)
-	    || (interface_mask != 0 && interface_mask != 0xFF)) {
-		warn("Can't handle masks in %s:%04X\n",
-		     filename, id->class_mask);
-		return 0;
-	}
-
-	ADD(alias, "bc", baseclass_mask == 0xFF, baseclass);
-	ADD(alias, "sc", subclass_mask == 0xFF, subclass);
-	ADD(alias, "i", interface_mask == 0xFF, interface);
-	add_wildcard(alias);
-	return 1;
-}
-
 /* looks like: "ccw:tNmNdtNdmN" */
 static int do_ccw_entry(const char *filename,
 			struct ccw_device_id *id, char *alias)
@@ -415,14 +325,6 @@ static int do_serio_entry(const char *filename,
 	return 1;
 }
 
-/* looks like: "acpi:ACPI0003 or acpi:PNP0C0B" or "acpi:LNXVIDEO" */
-static int do_acpi_entry(const char *filename,
-			struct acpi_device_id *id, char *alias)
-{
-	sprintf(alias, "acpi*:%s:*", id->id);
-	return 1;
-}
-
 /* looks like: "pnp:dD" */
 static void do_pnp_device_entry(void *symval, unsigned long size,
 				struct module *mod)
@@ -702,24 +604,6 @@ static int do_ssb_entry(const char *filename,
 	return 1;
 }
 
-/* Looks like: bcma:mNidNrevNclN. */
-static int do_bcma_entry(const char *filename,
-			 struct bcma_device_id *id, char *alias)
-{
-	id->manuf = TO_NATIVE(id->manuf);
-	id->id = TO_NATIVE(id->id);
-	id->rev = TO_NATIVE(id->rev);
-	id->class = TO_NATIVE(id->class);
-
-	strcpy(alias, "bcma:");
-	ADD(alias, "m", id->manuf != BCMA_ANY_MANUF, id->manuf);
-	ADD(alias, "id", id->id != BCMA_ANY_ID, id->id);
-	ADD(alias, "rev", id->rev != BCMA_ANY_REV, id->rev);
-	ADD(alias, "cl", id->class != BCMA_ANY_CLASS, id->class);
-	add_wildcard(alias);
-	return 1;
-}
-
 /* Looks like: virtio:dNvN */
 static int do_virtio_entry(const char *filename, struct virtio_device_id *id,
 			   char *alias)
@@ -765,13 +649,14 @@ static int do_i2c_entry(const char *filename, struct i2c_device_id *id,
 	return 1;
 }
 
-/* Looks like: spi:S */
-static int do_spi_entry(const char *filename, struct spi_device_id *id,
-			char *alias)
+static void dmi_ascii_filter(char *d, const char *s)
 {
-	sprintf(alias, SPI_MODULE_PREFIX "%s", id->name);
+	/* Filter out characters we don't want to see in the modalias string */
+	for (; *s; s++)
+		if (*s > ' ' && *s < 127 && *s != ':')
+			*(d++) = *s;
 
-	return 1;
+	*d = 0;
 }
 
 static const struct dmifield {
@@ -793,17 +678,6 @@ static const struct dmifield {
 	{ NULL,  DMI_NONE }
 };
 
-static void dmi_ascii_filter(char *d, const char *s)
-{
-	/* Filter out characters we don't want to see in the modalias string */
-	for (; *s; s++)
-		if (*s > ' ' && *s < 127 && *s != ':')
-			*(d++) = *s;
-
-	*d = 0;
-}
-
-
 static int do_dmi_entry(const char *filename, struct dmi_system_id *id,
 			char *alias)
 {
@@ -891,7 +765,7 @@ static inline int sym_is(const char *symbol, const char *name)
 	return match[strlen(name)] == '\0';
 }
 
-static void do_table(void *symval, unsigned long size,
+void do_table(void *symval, unsigned long size,
 		     unsigned long id_size,
 		     const char *device_id,
 		     void *function,
@@ -913,17 +787,7 @@ static void do_table(void *symval, unsigned long size,
 	}
 }
 
-/* This array collects all instances that use the generic do_table above */
-struct devtable_switch {
-	const char *device_id;
-	const char *symname;
-	unsigned long id_size;
-	void *function;
-};
-#define E(id, name, structname, f) {id, name, sizeof(struct structname), f}
-
-static struct devtable_switch devtable_switch[] = {
-	E("pci", "__mod_pci_device_table", pci_device_id, do_pci_entry),
+static struct devtable_switch devtable_switch[] __DEVTABLE_SWITCH = {
 	E("hid", "__mod_hid_device_table", hid_device_id, do_hid_entry),
 	E("ieee1394", "__mod_ieee1394_device_table",
 	  ieee1394_device_id, do_ieee1394_entry),
@@ -931,7 +795,6 @@ static struct devtable_switch devtable_switch[] = {
 	E("ap", "__mod_ap_device_table", ap_device_id, do_ap_entry),
 	E("css", "__mod_css_device_table", css_device_id, do_css_entry),
 	E("seio", "__mod_serio_device_table", serio_device_id, do_serio_entry),
-	E("acpi", "__mod_acpi_device_table", acpi_device_id, do_acpi_entry),
 	E("pcmcia", "__mod_pcmcia_device_table",
 	  pcmcia_device_id, do_pcmcia_entry),
 	E("of", "__mod_of_device_table", of_device_id, do_of_entry),
@@ -942,13 +805,11 @@ static struct devtable_switch devtable_switch[] = {
 	  parisc_device_id, do_parisc_entry),
 	E("sdio", "__mod_sdio_device_table", sdio_device_id, do_sdio_entry),
 	E("ssb", "__mod_ssb_device_table", ssb_device_id, do_ssb_entry),
-	E("bcma", "__mod_bcma_device_table", bcma_device_id, do_bcma_entry),
 	E("virtio", "__mod_virtio_device_table",
 	  virtio_device_id, do_virtio_entry),
 	E("vmbus", "__mod_vmbus_device_table",
 	  hv_vmbus_device_id, do_vmbus_entry),
 	E("i2c", "__mod_i2c_device_table", i2c_device_id, do_i2c_entry),
-	E("spi", "__mod_spi_device_table", spi_device_id, do_spi_entry),
 	E("dmi", "__mod_dmi_device_table", dmi_system_id, do_dmi_entry),
 	E("platform", "__mod_platform_device_table",
 	  platform_device_id, do_platform_entry),
@@ -989,11 +850,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 	else if (sym_is(symname, "__mod_pnp_card_device_table"))
 		do_pnp_card_entries(symval, sym->st_size, mod);
 	else {
-		struct devtable_switch *p = devtable_switch;
-		int i;
+		struct devtable_switch *p;
 
 		/* scan the array */
-		for (i = 0; i < ARRAY_SIZE(devtable_switch); i++, p++) {
+		for (p = __dt_sw_first; p < __dt_sw_last; p++) {
 			if (sym_is(symname, p->symname)) {
 				do_table(symval, sym->st_size, p->id_size,
 					 p->device_id, p->function, mod);
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 2031119..ea98de3 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -169,6 +169,24 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 			Elf_Sym *sym, const char *symname);
 void add_moddevtable(struct buffer *buf, struct module *mod);
 
+void do_table(void *symval, unsigned long size,
+	      unsigned long id_size,
+	      const char *device_id,
+	      void *function,
+	      struct module *mod);
+
+/* An array of these is assembled at compile time */
+struct devtable_switch {
+	const char *device_id;
+	const char *symname;
+	unsigned long id_size;
+	void *function;
+};
+#define E(id, name, structname, f) {id, name, sizeof(struct structname), f}
+#define __DEVTABLE_SWITCH __attribute__((section(".devtable_switch"),used))
+
+extern struct devtable_switch __dt_sw_first[], __dt_sw_last[];
+
 /* sumversion.c */
 void maybe_frob_rcs_version(const char *modfilename,
 			    char *version,
diff --git a/scripts/mod/modpost.lds b/scripts/mod/modpost.lds
new file mode 100644
index 0000000..0642326
--- /dev/null
+++ b/scripts/mod/modpost.lds
@@ -0,0 +1,9 @@
+SECTIONS
+{
+	.data : {
+		. = ALIGN(0x40);
+		__dt_sw_first = .;
+		*(.devtable_switch);
+		__dt_sw_last = .;
+		}
+}
-- 
1.6.0.2
