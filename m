Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2GRKgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:36:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab2GRKgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:36:12 -0400
From: Thomas Renninger <trenn@suse.de>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, initramfs@vger.kernel.org,
        bigeasy@linutronix.de, Thomas Renninger <trenn@suse.de>
Subject: [PATCH 1/2] init: Introduce early initrd files through uncompressed cpio passing
Date: Wed, 18 Jul 2012 12:36:03 +0200
Message-Id: <1342607764-66747-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1342607764-66747-1-git-send-email-trenn@suse.de>
References: <1342607764-66747-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpio parsing code comes from  H. Peter Anvin.
The CONFIG_EARLY_INITRD feature is architecture independent, but
for now only enabled/called for X86.
The problem is that initrd_start must be valid, but there is no
architecture independent reserve_initrd() call in init/main.c or
similiar.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: hpa@zytor.com
---
 Documentation/initrd.txt |   22 ++++++++
 arch/x86/kernel/setup.c  |    2 +
 include/linux/initrd.h   |   12 ++++
 init/Makefile            |    1 +
 init/initrd_early.c      |  131 ++++++++++++++++++++++++++++++++++++++++++++++
 usr/Kconfig              |   12 ++++
 6 files changed, 180 insertions(+), 0 deletions(-)
 create mode 100644 init/initrd_early.c

diff --git a/Documentation/initrd.txt b/Documentation/initrd.txt
index 4e1839c..e515e83 100644
--- a/Documentation/initrd.txt
+++ b/Documentation/initrd.txt
@@ -93,6 +93,28 @@ mkdir /tmp/imagefile
 cd /tmp/imagefile
 gzip -cd /boot/imagefile.img | cpio -imd --quiet
 
+
+Multiple cpio images glued together
+-----------------------------------
+
+Several cpio images, compressed or uncompressed can be concatenated.
+There is especially one use-case for this: see kernel accessing
+initrd data early section below.
+
+
+Accessing initrd data early
+---------------------------
+
+There is a mechanism to access data passed from the initrd much earlier.
+This only works if the data needed early is encapsulated in an uncompressed
+cpio image is passed. It must be the first cpio archive if multiple
+cpio archives are concatenated and passed as initrd.
+Typically if you want to pass data which is supposed to be consumed by
+the kernel really early, one would pass two cpio images glued together:
+   - One compressed, holding the big data which is needed by userspace
+   - One uncompressed cpio image holding files for early kernel initialization
+For further details look out for the CONFIG_EARLY_INITRD option in the sources.
+
 Installation
 ------------
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 16be6dc..9e039f6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -941,6 +941,8 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_initrd();
 
+	early_initrd_find_cpio_data((void *)initrd_start, initrd_end - initrd_start);
+
 	reserve_crashkernel();
 
 	vsmp_init();
diff --git a/include/linux/initrd.h b/include/linux/initrd.h
index 55289d2..3fe262e 100644
--- a/include/linux/initrd.h
+++ b/include/linux/initrd.h
@@ -18,3 +18,15 @@ extern unsigned long initrd_start, initrd_end;
 extern void free_initrd_mem(unsigned long, unsigned long);
 
 extern unsigned int real_root_dev;
+
+
+#define MAX_EARLY_INITRD_CB 16
+
+#ifdef CONFIG_EARLY_INITRD
+extern int early_initrd_find_cpio_data(const char *data, size_t len);
+#else
+static int early_initrd_find_cpio_data(const char *data, size_t len)
+{
+	return 0;
+}
+#endif
diff --git a/init/Makefile b/init/Makefile
index 7bc47ee..c8408ec 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -9,6 +9,7 @@ else
 obj-$(CONFIG_BLK_DEV_INITRD)   += initramfs.o
 endif
 obj-$(CONFIG_GENERIC_CALIBRATE_DELAY) += calibrate.o
+obj-$(CONFIG_EARLY_INITRD)     += initrd_early.o
 
 ifneq ($(CONFIG_ARCH_INIT_TASK),y)
 obj-y                          += init_task.o
diff --git a/init/initrd_early.c b/init/initrd_early.c
new file mode 100644
index 0000000..c657a4b
--- /dev/null
+++ b/init/initrd_early.c
@@ -0,0 +1,131 @@
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/initrd.h>
+
+struct initrd_early_data {
+	/* Path where relevant files can be found in uncompressed cpio */
+ 	char *namesp;
+	/* Callback called for each found file in above path */
+	int (*cb)(void *data, int size, const char *name);
+	/* Finalize callback: Called if file scanning finished and above
+	   callback has been called one or more times successfully */
+	void (*final)(void);
+};
+
+/*
+ * Add here new callback functions and the path relevant files show up in an
+ * uncompressed cpio
+ */
+static __initdata struct initrd_early_data initrd_early_callbacks[] =
+{
+	{
+		.namesp = NULL,
+	}
+};
+
+enum cpio_fields {
+	C_MAGIC,
+	C_INO,
+	C_MODE,
+	C_UID,
+	C_GID,
+	C_NLINK,
+	C_MTIME,
+	C_FILESIZE,
+	C_MAJ,
+	C_MIN,
+	C_RMAJ,
+	C_RMIN,
+	C_NAMESIZE,
+	C_CHKSUM,
+	C_NFIELDS
+};
+
+#define ALIGN4(p) ((void *)(((size_t)p + 3) & ~3))
+
+void __init early_initrd_find_cpio_data(const char *data, size_t len)
+{
+	const size_t cpio_header_len = 8*C_NFIELDS - 2;
+	const char *p, *dptr, *nptr;
+	unsigned int ch[C_NFIELDS], *chp, v;
+	unsigned char c, x;
+	int i, j;
+	struct initrd_early_data *ied;
+	int str_len[MAX_EARLY_INITRD_CB];
+	int match[MAX_EARLY_INITRD_CB];
+
+	for(i = 0, ied = initrd_early_callbacks; ied->namesp; ied++, i++) {
+		str_len[i] = strlen(ied->namesp);
+		match[i] = 0;
+	}
+
+	p = data;
+
+	while (len > cpio_header_len) {
+		if (!*p) {
+			/* All cpio headers need to be 4-byte aligned */
+			p += 4;
+			len -= 4;
+			continue;
+		}
+
+		j = 6;		/* The magic field is only 6 characters */
+		chp = ch;
+		for (i = C_NFIELDS; i; i--) {
+			v = 0;
+			while (j--) {
+				v <<= 4;
+				c = *p++;
+
+				x = c - '0';
+				if (x < 10) {
+					v += x;
+					continue;
+				}
+
+				x = (c | 0x20) - 'a';
+				if (x < 6) {
+					v += x + 10;
+					continue;
+				}
+
+				goto quit; /* Invalid hexadecimal */
+			}
+			*chp++ = v;
+			j = 8;	/* All other fields are 8 characters */
+		}
+
+		if ((ch[C_MAGIC] - 0x070701) > 1)
+			goto quit; /* Invalid magic */
+
+		len -= cpio_header_len;
+
+		dptr = ALIGN4(p + ch[C_NAMESIZE]);
+		nptr = ALIGN4(dptr + ch[C_FILESIZE]);
+
+		if (nptr > p + len || dptr < p || nptr < dptr)
+			goto quit; /* Buffer overrun */
+
+		if ((ch[C_MODE] & 0170000) == 0100000) {
+			for(i = 0, ied = initrd_early_callbacks; ied->namesp;
+			    ied++, i++) {
+				int min_len = (str_len[i] < ch[C_NAMESIZE])
+					? str_len[i] : ch[C_NAMESIZE];
+				if (!memcmp(p, ied->namesp, min_len)) {
+					if (!ied->cb((void *)dptr,
+					     ch[C_FILESIZE], p + min_len))
+						match[i]++;
+				}
+			}
+		}
+
+		len -= (nptr - p);
+		p = nptr;
+	}
+
+quit:
+	for(i = 0, ied = initrd_early_callbacks; ied->namesp; ied++, i++) {
+		if (match[i])
+			ied->final();
+	}
+}
diff --git a/usr/Kconfig b/usr/Kconfig
index 085872b..3b832ed 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -166,3 +166,15 @@ config INITRAMFS_COMPRESSION_LZO
 	  (both compression and decompression) is the fastest.
 
 endchoice
+
+config EARLY_INITRD
+	bool "Ability to pass data to the kernel which is needed really early"
+	default y
+	depends on BLK_DEV_INITRD && X86
+	help
+	 CPU microcode updates could be loaded before CPU initialization.
+	 BIOS data can be overridden via initrd for debugging purposes.
+	 If you are unsure whether your Hardware or kernel makes use of this,
+	 it is safe to say yes here. As long as no data is passed through an
+	 uncompressed cpio via initrd the kernel could make use of, nothing
+	 will happen.
-- 
1.7.6.1

