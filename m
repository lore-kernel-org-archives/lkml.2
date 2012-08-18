Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab2HRIcB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 04:32:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:10632 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab2HRI34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 04:29:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,790,1336374000"; 
   d="scan'208";a="182264744"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 02/11] x86/lib/cpio.c: Find cpio data by its file name
Date: Sat, 18 Aug 2012 01:15:20 -0700
Message-Id: <1345277729-8399-3-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Given a file's name, find its starting point in a cpio formated area. This will
be used to find microcode in combined initrd image. But this function is
generic and could be used in other places.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/cpio.h |   10 +++
 arch/x86/lib/Makefile       |    2 +
 arch/x86/lib/cpio.c         |  179 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 191 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/cpio.h
 create mode 100644 arch/x86/lib/cpio.c

diff --git a/arch/x86/include/asm/cpio.h b/arch/x86/include/asm/cpio.h
new file mode 100644
index 0000000..26a4333
--- /dev/null
+++ b/arch/x86/include/asm/cpio.h
@@ -0,0 +1,10 @@
+#include <stddef.h>
+#include <stdbool.h>
+
+struct cpio_data {
+	void *data;
+	unsigned long size;
+};
+
+extern struct cpio_data
+find_cpio_data(const char *name, const void *data, size_t len);
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index b00f678..452a4b5 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -45,3 +45,5 @@ else
         lib-y += copy_user_64.o copy_user_nocache_64.o
 	lib-y += cmpxchg16b_emu.o
 endif
+
+obj-y += cpio.o
diff --git a/arch/x86/lib/cpio.c b/arch/x86/lib/cpio.c
new file mode 100644
index 0000000..70ac474
--- /dev/null
+++ b/arch/x86/lib/cpio.c
@@ -0,0 +1,179 @@
+/*
+ * findcpio.c
+ *
+ * Find a specific cpio member; must precede any compressed content.
+ *
+ *	Copyright (C) 2012	H Peter Anvin" <hpa@zytor.com>
+ *				Fenghua Yu <fenghua.yu@intel.com>
+ */
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/swap.h>
+#include <linux/slab.h>
+#include <linux/sysctl.h>
+#include <linux/bitmap.h>
+#include <linux/signal.h>
+#include <linux/printk.h>
+#include <linux/proc_fs.h>
+#include <linux/security.h>
+#include <linux/ctype.h>
+#include <linux/kmemcheck.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/kobject.h>
+#include <linux/net.h>
+#include <linux/sysrq.h>
+#include <linux/highuid.h>
+#include <linux/writeback.h>
+#include <linux/ratelimit.h>
+#include <linux/compaction.h>
+#include <linux/hugetlb.h>
+#include <linux/initrd.h>
+#include <linux/key.h>
+#include <linux/times.h>
+#include <linux/limits.h>
+#include <linux/dcache.h>
+#include <linux/dnotify.h>
+#include <linux/syscalls.h>
+#include <asm/cpio.h>
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
+#if defined(__i386__) || defined(__x86_64__)
+static size_t cpio_strlen(const char *name)
+{
+	size_t n = -1;
+
+	asm("repne; scasb"
+	    : "+D" (name), "+c" (n)
+	    : "a" (0));
+
+	return -2 - n;
+}
+
+static int cpio_memcmp(const void *p1, const void *p2, size_t n)
+{
+	unsigned char rv;
+
+	asm("repe; cmpsb; setne %0"
+	    : "=r" (rv), "+S" (p1), "+D" (p2), "+c" (n));
+
+	return rv;
+}
+#else
+static size_t cpio_strlen(const char *name)
+{
+	size_t n = 0;
+
+	while (*name++)
+		n++;
+
+	return n;
+}
+
+static int cpio_memcmp(const void *p1, const void *p2, size_t n)
+{
+	const unsigned char *u1 = p1;
+	const unsigned char *u2 = p2;
+	int d;
+
+	while (n--) {
+		d = *u2++ - *u1++;
+		if (d)
+			return d;
+	}
+	return 0;
+}
+#endif
+
+#define ALIGN4(p) ((void *)(((size_t)p + 3) & ~3))
+
+struct cpio_data find_cpio_data(const char *name, const void *data, size_t len)
+{
+	const size_t cpio_header_len = 8*C_NFIELDS - 2;
+	struct cpio_data cd = { NULL, 0 };
+	const char *p, *dptr, *nptr;
+	unsigned int ch[C_NFIELDS], *chp, v;
+	unsigned char c, x;
+	size_t mynamesize = cpio_strlen(name) + 1;
+	int i, j;
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
+		if ((ch[C_MODE] & 0170000) == 0100000 &&
+		    ch[C_NAMESIZE] == mynamesize &&
+		    !cpio_memcmp(p, name, mynamesize)) {
+			cd.data = (void *)dptr;
+			cd.size = ch[C_FILESIZE];
+			return cd; /* Found it! */
+		}
+
+		len -= (nptr - p);
+		p = nptr;
+	}
+
+quit:
+	return cd;
+}
-- 
1.7.2

