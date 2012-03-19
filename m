Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161951Ab2CSQaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:30:21 -0400
Received: from mail-we0-f194.google.com ([74.125.82.194]:58924 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031218Ab2CSQaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:30:18 -0400
Date: Mon, 19 Mar 2012 17:30:15 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/build changes for v3.4
Message-ID: <20120319163015.GA9988@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-build-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-build-for-linus

   HEAD: a51f4047758d2bcd099ea113b833ed380f4024ba x86, build: Fix portability issues when cross-building


out-of-topic modifications in x86-build-for-linus:
--------------------------------------------------
tools/include/tools/be_byteshift.h # a07f767: tools/include: Add byteshift head
tools/include/tools/le_byteshift.h # a07f767: tools/include: Add byteshift head
tools/usb/Makefile                 # 24fa9a9: USB: ffs-test: Don't duplicate {g
tools/usb/ffs-test.c               # 24fa9a9: USB: ffs-test: Don't duplicate {g

 Thanks,

	Ingo

------------------>
H. Peter Anvin (2):
      x86, tools: Remove unneeded header files from tools/build.c
      x86, build: Fix portability issues when cross-building

Matt Fleming (6):
      tools/include: Add byteshift headers for endian access
      x86, relocs: Don't open code put_unaligned_le32()
      x86, mkpiggy: Don't open code put_unaligned_le32()
      x86, boot: Restrict CFLAGS for hostprogs
      x86, efi: Fix endian issues and unaligned accesses
      USB: ffs-test: Don't duplicate {get,put}_unaligned*() functions


 arch/x86/boot/Makefile             |    5 ++-
 arch/x86/boot/compressed/Makefile  |    1 +
 arch/x86/boot/compressed/mkpiggy.c |   11 +-----
 arch/x86/boot/compressed/relocs.c  |    6 +--
 arch/x86/boot/tools/build.c        |   40 ++++++++++-----------
 tools/include/tools/be_byteshift.h |   70 ++++++++++++++++++++++++++++++++++++
 tools/include/tools/le_byteshift.h |   70 ++++++++++++++++++++++++++++++++++++
 tools/usb/Makefile                 |    2 +-
 tools/usb/ffs-test.c               |   29 +--------------
 9 files changed, 169 insertions(+), 65 deletions(-)
 create mode 100644 tools/include/tools/be_byteshift.h
 create mode 100644 tools/include/tools/le_byteshift.h

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 95365a8..3e02148 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -37,8 +37,9 @@ setup-y		+= video-bios.o
 targets		+= $(setup-y)
 hostprogs-y	:= mkcpustr tools/build
 
-HOST_EXTRACFLAGS += $(LINUXINCLUDE)
-
+HOSTCFLAGS_mkcpustr.o := -I$(srctree)/arch/$(SRCARCH)/include
+HOST_EXTRACFLAGS += -I$(objtree)/include -I$(srctree)/tools/include \
+                   -include $(srctree)/include/linux/kconfig.h
 $(obj)/cpu.o: $(obj)/cpustr.h
 
 quiet_cmd_cpustr = CPUSTR  $@
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index b123b9a..fd55a2f 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -22,6 +22,7 @@ LDFLAGS := -m elf_$(UTS_MACHINE)
 LDFLAGS_vmlinux := -T
 
 hostprogs-y	:= mkpiggy
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
 VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index 46a8238..958a641 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -29,14 +29,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <inttypes.h>
-
-static uint32_t getle32(const void *p)
-{
-	const uint8_t *cp = p;
-
-	return (uint32_t)cp[0] + ((uint32_t)cp[1] << 8) +
-		((uint32_t)cp[2] << 16) + ((uint32_t)cp[3] << 24);
-}
+#include <tools/le_byteshift.h>
 
 int main(int argc, char *argv[])
 {
@@ -69,7 +62,7 @@ int main(int argc, char *argv[])
 	}
 
 	ilen = ftell(f);
-	olen = getle32(&olen);
+	olen = get_unaligned_le32(&olen);
 	fclose(f);
 
 	/*
diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index 89bbf4e..d3c0b02 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -10,6 +10,7 @@
 #define USE_BSD
 #include <endian.h>
 #include <regex.h>
+#include <tools/le_byteshift.h>
 
 static void die(char *fmt, ...);
 
@@ -605,10 +606,7 @@ static void emit_relocs(int as_text)
 		fwrite("\0\0\0\0", 4, 1, stdout);
 		/* Now print each relocation */
 		for (i = 0; i < reloc_count; i++) {
-			buf[0] = (relocs[i] >>  0) & 0xff;
-			buf[1] = (relocs[i] >>  8) & 0xff;
-			buf[2] = (relocs[i] >> 16) & 0xff;
-			buf[3] = (relocs[i] >> 24) & 0xff;
+			put_unaligned_le32(relocs[i], buf);
 			fwrite(buf, 4, 1, stdout);
 		}
 	}
diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index 4e9bd6b..ed54976 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -29,18 +29,18 @@
 #include <stdarg.h>
 #include <sys/types.h>
 #include <sys/stat.h>
-#include <sys/sysmacros.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <sys/mman.h>
-#include <asm/boot.h>
+#include <tools/le_byteshift.h>
 
 typedef unsigned char  u8;
 typedef unsigned short u16;
-typedef unsigned long  u32;
+typedef unsigned int   u32;
 
 #define DEFAULT_MAJOR_ROOT 0
 #define DEFAULT_MINOR_ROOT 0
+#define DEFAULT_ROOT_DEV (DEFAULT_MAJOR_ROOT << 8 | DEFAULT_MINOR_ROOT)
 
 /* Minimal number of setup sectors */
 #define SETUP_SECT_MIN 5
@@ -159,7 +159,7 @@ int main(int argc, char ** argv)
 		die("read-error on `setup'");
 	if (c < 1024)
 		die("The setup must be at least 1024 bytes");
-	if (buf[510] != 0x55 || buf[511] != 0xaa)
+	if (get_unaligned_le16(&buf[510]) != 0xAA55)
 		die("Boot block hasn't got boot flag (0xAA55)");
 	fclose(file);
 
@@ -171,8 +171,7 @@ int main(int argc, char ** argv)
 	memset(buf+c, 0, i-c);
 
 	/* Set the default root device */
-	buf[508] = DEFAULT_MINOR_ROOT;
-	buf[509] = DEFAULT_MAJOR_ROOT;
+	put_unaligned_le16(DEFAULT_ROOT_DEV, &buf[508]);
 
 	fprintf(stderr, "Setup is %d bytes (padded to %d bytes).\n", c, i);
 
@@ -192,44 +191,42 @@ int main(int argc, char ** argv)
 
 	/* Patch the setup code with the appropriate size parameters */
 	buf[0x1f1] = setup_sectors-1;
-	buf[0x1f4] = sys_size;
-	buf[0x1f5] = sys_size >> 8;
-	buf[0x1f6] = sys_size >> 16;
-	buf[0x1f7] = sys_size >> 24;
+	put_unaligned_le32(sys_size, &buf[0x1f4]);
 
 #ifdef CONFIG_EFI_STUB
 	file_sz = sz + i + ((sys_size * 16) - sz);
 
-	pe_header = *(unsigned int *)&buf[0x3c];
+	pe_header = get_unaligned_le32(&buf[0x3c]);
 
 	/* Size of code */
-	*(unsigned int *)&buf[pe_header + 0x1c] = file_sz;
+	put_unaligned_le32(file_sz, &buf[pe_header + 0x1c]);
 
 	/* Size of image */
-	*(unsigned int *)&buf[pe_header + 0x50] = file_sz;
+	put_unaligned_le32(file_sz, &buf[pe_header + 0x50]);
 
 #ifdef CONFIG_X86_32
 	/* Address of entry point */
-	*(unsigned int *)&buf[pe_header + 0x28] = i;
+	put_unaligned_le32(i, &buf[pe_header + 0x28]);
 
 	/* .text size */
-	*(unsigned int *)&buf[pe_header + 0xb0] = file_sz;
+	put_unaligned_le32(file_sz, &buf[pe_header + 0xb0]);
 
 	/* .text size of initialised data */
-	*(unsigned int *)&buf[pe_header + 0xb8] = file_sz;
+	put_unaligned_le32(file_sz, &buf[pe_header + 0xb8]);
 #else
 	/*
 	 * Address of entry point. startup_32 is at the beginning and
 	 * the 64-bit entry point (startup_64) is always 512 bytes
 	 * after.
 	 */
-	*(unsigned int *)&buf[pe_header + 0x28] = i + 512;
+	put_unaligned_le32(i + 512, &buf[pe_header + 0x28]);
 
 	/* .text size */
-	*(unsigned int *)&buf[pe_header + 0xc0] = file_sz;
+	put_unaligned_le32(file_sz, &buf[pe_header + 0xc0]);
 
 	/* .text size of initialised data */
-	*(unsigned int *)&buf[pe_header + 0xc8] = file_sz;
+	put_unaligned_le32(file_sz, &buf[pe_header + 0xc8]);
+
 #endif /* CONFIG_X86_32 */
 #endif /* CONFIG_EFI_STUB */
 
@@ -250,8 +247,9 @@ int main(int argc, char ** argv)
 	}
 
 	/* Write the CRC */
-	fprintf(stderr, "CRC %lx\n", crc);
-	if (fwrite(&crc, 1, 4, stdout) != 4)
+	fprintf(stderr, "CRC %x\n", crc);
+	put_unaligned_le32(crc, buf);
+	if (fwrite(buf, 1, 4, stdout) != 4)
 		die("Writing CRC failed");
 
 	close(fd);
diff --git a/tools/include/tools/be_byteshift.h b/tools/include/tools/be_byteshift.h
new file mode 100644
index 0000000..f4912e2
--- /dev/null
+++ b/tools/include/tools/be_byteshift.h
@@ -0,0 +1,70 @@
+#ifndef _TOOLS_BE_BYTESHIFT_H
+#define _TOOLS_BE_BYTESHIFT_H
+
+#include <linux/types.h>
+
+static inline __u16 __get_unaligned_be16(const __u8 *p)
+{
+	return p[0] << 8 | p[1];
+}
+
+static inline __u32 __get_unaligned_be32(const __u8 *p)
+{
+	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
+}
+
+static inline __u64 __get_unaligned_be64(const __u8 *p)
+{
+	return (__u64)__get_unaligned_be32(p) << 32 |
+	       __get_unaligned_be32(p + 4);
+}
+
+static inline void __put_unaligned_be16(__u16 val, __u8 *p)
+{
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline void __put_unaligned_be32(__u32 val, __u8 *p)
+{
+	__put_unaligned_be16(val >> 16, p);
+	__put_unaligned_be16(val, p + 2);
+}
+
+static inline void __put_unaligned_be64(__u64 val, __u8 *p)
+{
+	__put_unaligned_be32(val >> 32, p);
+	__put_unaligned_be32(val, p + 4);
+}
+
+static inline __u16 get_unaligned_be16(const void *p)
+{
+	return __get_unaligned_be16((const __u8 *)p);
+}
+
+static inline __u32 get_unaligned_be32(const void *p)
+{
+	return __get_unaligned_be32((const __u8 *)p);
+}
+
+static inline __u64 get_unaligned_be64(const void *p)
+{
+	return __get_unaligned_be64((const __u8 *)p);
+}
+
+static inline void put_unaligned_be16(__u16 val, void *p)
+{
+	__put_unaligned_be16(val, p);
+}
+
+static inline void put_unaligned_be32(__u32 val, void *p)
+{
+	__put_unaligned_be32(val, p);
+}
+
+static inline void put_unaligned_be64(__u64 val, void *p)
+{
+	__put_unaligned_be64(val, p);
+}
+
+#endif /* _TOOLS_BE_BYTESHIFT_H */
diff --git a/tools/include/tools/le_byteshift.h b/tools/include/tools/le_byteshift.h
new file mode 100644
index 0000000..c99d45a
--- /dev/null
+++ b/tools/include/tools/le_byteshift.h
@@ -0,0 +1,70 @@
+#ifndef _TOOLS_LE_BYTESHIFT_H
+#define _TOOLS_LE_BYTESHIFT_H
+
+#include <linux/types.h>
+
+static inline __u16 __get_unaligned_le16(const __u8 *p)
+{
+	return p[0] | p[1] << 8;
+}
+
+static inline __u32 __get_unaligned_le32(const __u8 *p)
+{
+	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
+}
+
+static inline __u64 __get_unaligned_le64(const __u8 *p)
+{
+	return (__u64)__get_unaligned_le32(p + 4) << 32 |
+	       __get_unaligned_le32(p);
+}
+
+static inline void __put_unaligned_le16(__u16 val, __u8 *p)
+{
+	*p++ = val;
+	*p++ = val >> 8;
+}
+
+static inline void __put_unaligned_le32(__u32 val, __u8 *p)
+{
+	__put_unaligned_le16(val >> 16, p + 2);
+	__put_unaligned_le16(val, p);
+}
+
+static inline void __put_unaligned_le64(__u64 val, __u8 *p)
+{
+	__put_unaligned_le32(val >> 32, p + 4);
+	__put_unaligned_le32(val, p);
+}
+
+static inline __u16 get_unaligned_le16(const void *p)
+{
+	return __get_unaligned_le16((const __u8 *)p);
+}
+
+static inline __u32 get_unaligned_le32(const void *p)
+{
+	return __get_unaligned_le32((const __u8 *)p);
+}
+
+static inline __u64 get_unaligned_le64(const void *p)
+{
+	return __get_unaligned_le64((const __u8 *)p);
+}
+
+static inline void put_unaligned_le16(__u16 val, void *p)
+{
+	__put_unaligned_le16(val, p);
+}
+
+static inline void put_unaligned_le32(__u32 val, void *p)
+{
+	__put_unaligned_le32(val, p);
+}
+
+static inline void put_unaligned_le64(__u64 val, void *p)
+{
+	__put_unaligned_le64(val, p);
+}
+
+#endif /* _TOOLS_LE_BYTESHIFT_H */
diff --git a/tools/usb/Makefile b/tools/usb/Makefile
index 8b704af..396d6c4 100644
--- a/tools/usb/Makefile
+++ b/tools/usb/Makefile
@@ -3,7 +3,7 @@
 CC = $(CROSS_COMPILE)gcc
 PTHREAD_LIBS = -lpthread
 WARNINGS = -Wall -Wextra
-CFLAGS = $(WARNINGS) -g $(PTHREAD_LIBS)
+CFLAGS = $(WARNINGS) -g $(PTHREAD_LIBS) -I../include
 
 all: testusb ffs-test
 %: %.c
diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index b9c7986..384f47a 100644
--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -36,6 +36,7 @@
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <unistd.h>
+#include <tools/le_byteshift.h>
 
 #include "../../include/linux/usb/functionfs.h"
 
@@ -47,34 +48,6 @@
 #define le32_to_cpu(x)  le32toh(x)
 #define le16_to_cpu(x)  le16toh(x)
 
-static inline __u16 get_unaligned_le16(const void *_ptr)
-{
-	const __u8 *ptr = _ptr;
-	return ptr[0] | (ptr[1] << 8);
-}
-
-static inline __u32 get_unaligned_le32(const void *_ptr)
-{
-	const __u8 *ptr = _ptr;
-	return ptr[0] | (ptr[1] << 8) | (ptr[2] << 16) | (ptr[3] << 24);
-}
-
-static inline void put_unaligned_le16(__u16 val, void *_ptr)
-{
-	__u8 *ptr = _ptr;
-	*ptr++ = val;
-	*ptr++ = val >> 8;
-}
-
-static inline void put_unaligned_le32(__u32 val, void *_ptr)
-{
-	__u8 *ptr = _ptr;
-	*ptr++ = val;
-	*ptr++ = val >>  8;
-	*ptr++ = val >> 16;
-	*ptr++ = val >> 24;
-}
-
 
 /******************** Messages and Errors ***********************************/
 
