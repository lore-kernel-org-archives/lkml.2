Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002Ab2DKBt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 21:49:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32118 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755968Ab2DKBtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 21:49:18 -0400
X-IronPort-AV: E=Sophos;i="4.75,402,1330876800"; 
   d="scan'208";a="4725353"
Message-ID: <4F84E30E.7020507@cn.fujitsu.com>
Date: Wed, 11 Apr 2012 09:49:02 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: avi@redhat.com, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, joerg.roedel@amd.com,
        dzickus@redhat.com, paul.gortmaker@windriver.com, gregkh@suse.de,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH 1/4] x86: Add helper variables and functions to hold VMCSINFO
References: <4F84E0DF.8040206@cn.fujitsu.com>
In-Reply-To: <4F84E0DF.8040206@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 09:48:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 09:48:43,
	Serialize complete at 2012/04/11 09:48:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a set of variables to hold the VMCSINFO and also
some helper functions to help fill the VMCSINFO.

Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/include/asm/vmcsinfo.h |   42 +++++++++++++++++++++++
 arch/x86/kernel/Makefile        |    2 +
 arch/x86/kernel/vmcsinfo.c      |   70 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 114 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/vmcsinfo.h
 create mode 100644 arch/x86/kernel/vmcsinfo.c

diff --git a/arch/x86/include/asm/vmcsinfo.h b/arch/x86/include/asm/vmcsinfo.h
new file mode 100644
index 0000000..cfdc984
--- /dev/null
+++ b/arch/x86/include/asm/vmcsinfo.h
@@ -0,0 +1,42 @@
+#ifndef _ASM_X86_VMCSINFO_H
+#define _ASM_X86_VMCSINFO_H
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#include <linux/elf.h>
+
+/*
+ * Currently, 2 pages are enough for vmcsinfo.
+ */
+#define VMCSINFO_BYTES             (8192)
+#define VMCSINFO_NOTE_NAME         "VMCSINFO"
+#define VMCSINFO_NOTE_NAME_BYTES   ALIGN(sizeof(VMCSINFO_NOTE_NAME), 4)
+#define VMCSINFO_NOTE_HEAD_BYTES   ALIGN(sizeof(struct elf_note), 4)
+#define VMCSINFO_NOTE_SIZE         (VMCSINFO_NOTE_HEAD_BYTES*2 \
+				    + VMCSINFO_BYTES \
+				    + VMCSINFO_NOTE_NAME_BYTES)
+
+extern size_t vmcsinfo_size;
+extern size_t vmcsinfo_max_size;
+
+extern void update_vmcsinfo_note(void);
+extern void vmcsinfo_append_str(const char *fmt, ...);
+extern unsigned long paddr_vmcsinfo_note(void);
+
+#define VMCSINFO_REVISION_ID(id) \
+	vmcsinfo_append_str("REVISION_ID=%x\n", id)
+#define VMCSINFO_FIELD16(name, value) \
+	vmcsinfo_append_str("FIELD(%s)=%04x\n", #name, value)
+#define VMCSINFO_FIELD32(name, value) \
+	vmcsinfo_append_str("FIELD(%s)=%08x\n", #name, value)
+#define VMCSINFO_FIELD64(name, value) \
+	vmcsinfo_append_str("FIELD(%s)=%016llx\n", #name, value)
+
+#ifdef CONFIG_X86_64
+#define VMCSINFO_FIELD(name, value) VMCSINFO_FIELD64(name, value)
+#else
+#define VMCSINFO_FIELD(name, value) VMCSINFO_FIELD32(name, value)
+#endif
+
+#endif /* __ASSEMBLY__ */
+#endif /* _ASM_X86_VMCSINFO_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 532d2e0..63edf33 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -102,6 +102,8 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 obj-$(CONFIG_OF)			+= devicetree.o
 
+obj-y					+= vmcsinfo.o
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/vmcsinfo.c b/arch/x86/kernel/vmcsinfo.c
new file mode 100644
index 0000000..c1306ef
--- /dev/null
+++ b/arch/x86/kernel/vmcsinfo.c
@@ -0,0 +1,70 @@
+/*
+ * Architecture specific (i386/x86_64) functions for storing vmcs
+ * field information.
+ *
+ * Created by: zhangyanfei (zhangyanfei@cn.fujitsu.com)
+ *
+ * Copyright (C) Fujitsu Corporation, 2012. All rights reserved.
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+#include <asm/vmcsinfo.h>
+#include <linux/module.h>
+#include <linux/elf.h>
+
+static unsigned char vmcsinfo_data[VMCSINFO_BYTES];
+static u32 vmcsinfo_note[VMCSINFO_NOTE_SIZE/4];
+size_t vmcsinfo_max_size = sizeof(vmcsinfo_data);
+size_t vmcsinfo_size;
+EXPORT_SYMBOL(vmcsinfo_size);
+
+void update_vmcsinfo_note(void)
+{
+	u32 *buf = vmcsinfo_note;
+	struct elf_note note;
+
+	if (!vmcsinfo_size)
+		return;
+
+	note.n_namesz = strlen(VMCSINFO_NOTE_NAME) + 1;
+	note.n_descsz = vmcsinfo_size;
+	note.n_type   = 0;
+	memcpy(buf, &note, sizeof(note));
+	buf += (sizeof(note) + 3)/4;
+	memcpy(buf, VMCSINFO_NOTE_NAME, note.n_namesz);
+	buf += (note.n_namesz + 3)/4;
+	memcpy(buf, vmcsinfo_data, note.n_descsz);
+	buf += (note.n_descsz + 3)/4;
+
+	note.n_namesz = 0;
+	note.n_descsz = 0;
+	note.n_type   = 0;
+	memcpy(buf, &note, sizeof(note));
+}
+EXPORT_SYMBOL(update_vmcsinfo_note);
+
+void vmcsinfo_append_str(const char *fmt, ...)
+{
+	va_list args;
+	char buf[0x50];
+	int r;
+
+	va_start(args, fmt);
+	r = vsnprintf(buf, sizeof(buf), fmt, args);
+	va_end(args);
+
+	if (r + vmcsinfo_size > vmcsinfo_max_size)
+		r = vmcsinfo_max_size - vmcsinfo_size;
+
+	memcpy(&vmcsinfo_data[vmcsinfo_size], buf, r);
+
+	vmcsinfo_size += r;
+}
+EXPORT_SYMBOL(vmcsinfo_append_str);
+
+unsigned long paddr_vmcsinfo_note(void)
+{
+	return __pa((unsigned long)(char *)&vmcsinfo_note);
+}
-- 
1.7.1
