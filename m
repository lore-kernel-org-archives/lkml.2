Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab1LWNgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:36:12 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:48227 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168Ab1LWNgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:36:00 -0500
X-AuditID: b753bd60-a1286ba000000655-b5-4ef4830add3f
X-AuditID: b753bd60-a1286ba000000655-b5-4ef4830add3f
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Subject: [RFC PATCH 3/5][RESEND] livedump: Add page splitting functionality
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kevin Hilman <khilman@ti.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Michal Marek <mmarek@suse.cz>, Rik van Riel <riel@redhat.com>,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, frank.rowand@am.sony.com, jan.kiszka@web.de,
        yrl.pp-manager.tt@hitachi.com,
        YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 23 Dec 2011 22:14:42 +0900
Message-ID: <20111223131441.13217.8977.stgit@t3500.sdl.hitachi.co.jp>
In-Reply-To: <20111223131441.13217.68917.stgit@t3500.sdl.hitachi.co.jp>
References: <20111223131441.13217.68917.stgit@t3500.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds function "wrprotect_split" to split all large pages in
kernel space into 4K pages. This patch also adds tools/livedump/livedump
to kick wrprotect_split via ioctl operation.

***ATTENTION PLEASE***
Right now, the livedump module can handle only 4K pages. Before setting up
write protection, it has to split all large pages into 4K pages.
I think this job (page splitting) can be eliminated in the future.

Signed-off-by: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org
---

 arch/x86/Kconfig                 |   16 +++++++++++++++-
 arch/x86/include/asm/wrprotect.h |   26 ++++++++++++++++++++++++++
 arch/x86/mm/Makefile             |    2 ++
 arch/x86/mm/wrprotect.c          |   33 +++++++++++++++++++++++++++++++++
 kernel/livedump.c                |    5 +++++
 tools/livedump/livedump          |   13 +++++++++++++
 6 files changed, 94 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/include/asm/wrprotect.h
 create mode 100644 arch/x86/mm/wrprotect.c
 create mode 100755 tools/livedump/livedump

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 32bc16d..9e6b53a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1702,9 +1702,23 @@ config CMDLINE_OVERRIDE
 	  This is used to work around broken boot loaders.  This should
 	  be set to 'N' under normal conditions.
 
+config WRPROTECT
+	bool "Write protection on kernel space"
+	depends on X86_64
+	---help---
+	  Set this option to 'Y' to allow the kernel to write protect
+	  its own memory space and to handle page fault caused by the
+	  write protection.
+
+	  This feature regularly causes small overhead on kernel.
+	  Once this feature is activated, it causes much more overhead
+	  on kernel.
+
+	  If in doubt, say N.
+
 config LIVEDUMP
 	bool "Live Dump support"
-	depends on X86_64
+	depends on WRPROTECT
 	---help---
 	  Set this option to 'Y' to allow the kernel support to acquire
 	  a consistent snapshot of kernel space without stopping system.
diff --git a/arch/x86/include/asm/wrprotect.h b/arch/x86/include/asm/wrprotect.h
new file mode 100644
index 0000000..40489e0
--- /dev/null
+++ b/arch/x86/include/asm/wrprotect.h
@@ -0,0 +1,26 @@
+/* wrprortect.h - Kernel space write protection support
+ * Copyright (C) 2011 Hitachi, Ltd.
+ * Author: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA  02110-1301, USA.
+ */
+
+#ifndef _WRPROTECT_H
+#define _WRPROTECT_H
+
+extern int wrprotect_split(void);
+
+#endif /* _WRPROTECT_H */
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 3d11327..781a368 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -30,3 +30,5 @@ obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 obj-$(CONFIG_HAVE_MEMBLOCK)		+= memblock.o
 
 obj-$(CONFIG_MEMTEST)		+= memtest.o
+
+obj-$(CONFIG_WRPROTECT)		+= wrprotect.o
diff --git a/arch/x86/mm/wrprotect.c b/arch/x86/mm/wrprotect.c
new file mode 100644
index 0000000..2a69735
--- /dev/null
+++ b/arch/x86/mm/wrprotect.c
@@ -0,0 +1,33 @@
+/* wrprotect.c - Kernel space write protection support
+ * Copyright (C) 2011 Hitachi, Ltd.
+ * Author: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA  02110-1301, USA.
+ */
+
+#include <asm/wrprotect.h>
+#include <linux/highmem.h>
+
+int wrprotect_split(void)
+{
+	unsigned long pfn;
+	for (pfn = 0; pfn < num_physpages; pfn++) {
+		int ret = set_memory_4k((unsigned long)pfn_to_kaddr(pfn), 1);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
diff --git a/kernel/livedump.c b/kernel/livedump.c
index 198bda5..899d572 100644
--- a/kernel/livedump.c
+++ b/kernel/livedump.c
@@ -18,6 +18,8 @@
  * MA  02110-1301, USA.
  */
 
+#include <asm/wrprotect.h>
+
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
@@ -25,11 +27,14 @@
 #define DEVICE_NAME	"livedump"
 
 #define LIVEDUMP_IOC(x)	_IO(0xff, x)
+#define LIVEDUMP_IOC_SPLIT LIVEDUMP_IOC(1)
 
 static long livedump_ioctl(
 		struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
+	case LIVEDUMP_IOC_SPLIT:
+		return wrprotect_split();
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/tools/livedump/livedump b/tools/livedump/livedump
new file mode 100755
index 0000000..c5e34d6
--- /dev/null
+++ b/tools/livedump/livedump
@@ -0,0 +1,13 @@
+#!/usr/bin/python
+
+import sys
+import fcntl
+
+cmds = {
+	'split':0xff01,
+	}
+cmd = cmds[sys.argv[1]]
+
+f = open('/dev/livedump')
+fcntl.ioctl(f, cmd)
+f.close

