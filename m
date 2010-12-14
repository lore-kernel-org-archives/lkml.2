Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225Ab0LNK1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:27:30 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38910 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758779Ab0LNK12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:27:28 -0500
Date: Tue, 14 Dec 2010 15:57:37 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch 21/21] Compat ELF class Core generation support
Message-ID: <20101214155737.040a49e3@suzukikp>
In-Reply-To: <20101214152259.67896960@suzukikp>
References: <20101214152259.67896960@suzukikp>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add full support for the compat ELF class objects. The gencore-compat-elf.c 
reuses the gencore-elf.c, by renaming the ABI structures and functions. 
(Inspired by compat_binfmt_elf.c)

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>

---
 fs/proc/Makefile             |    1 
 fs/proc/gencore-compat-elf.c |   61 +++++++++++++++++++++++++++++++++++++++++++
 fs/proc/gencore.c            |    4 ++
 fs/proc/gencore.h            |    4 ++
 4 files changed, 70 insertions(+)

Index: linux-2.6.36-rc7/fs/proc/gencore.h
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore.h
+++ linux-2.6.36-rc7/fs/proc/gencore.h
@@ -64,4 +64,8 @@ static inline int  get_max_regsets(struc
 
 extern ssize_t elf_read_gencore(struct core_proc *cp, char __user *buffer,
 					size_t buflen, loff_t *foffset);
+#ifdef CONFIG_COMPAT_BINFMT_ELF
+extern ssize_t compat_elf_read_gencore(struct core_proc *cp, char __user *buffer,
+					size_t buflen, loff_t *foffset);
+#endif
 #endif
Index: linux-2.6.36-rc7/fs/proc/gencore.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore.c
+++ linux-2.6.36-rc7/fs/proc/gencore.c
@@ -108,6 +108,10 @@ static ssize_t read_gencore(struct file 
 
 	if (cp->elf_class == ELF_CLASS_NATIVE)
 		ret = elf_read_gencore(cp, buffer, buflen, fpos);
+#ifdef CONFIG_COMPAT_BINFMT_ELF
+	else if (cp->elf_class == ELF_CLASS_COMPAT)
+		ret = compat_elf_read_gencore(cp, buffer, buflen, fpos);
+#endif
 
 out:
 	put_task_struct(task);
Index: linux-2.6.36-rc7/fs/proc/gencore-compat-elf.c
===================================================================
--- /dev/null
+++ linux-2.6.36-rc7/fs/proc/gencore-compat-elf.c
@@ -0,0 +1,61 @@
+/*
+ * Application core dump - compat ELF Class specific code
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2010
+ *
+ * We use macros to rename the types and functions in gencore-elf.c to
+ * the compat versions
+ *
+ */
+
+#include <linux/elfcore-compat.h>
+#include "gencore.h"
+
+#undef elfhdr
+#undef elf_phdr
+#undef elf_shdr
+#undef elf_note
+#undef elf_addr_t
+#define	elfhdr		elf32_hdr
+#define elf_phdr	elf32_phdr
+#define elf_shdr	elf32_shdr
+#define elf_note	elf32_note
+#define elf_addr_t	Elf32_Addr
+
+#undef ELF_CLASS
+#define ELF_CLASS ELF_CASS32
+
+#define elf_prstatus	compat_elf_prstatus
+#define elf_prpsinfo	compat_elf_prpsinfo
+
+/* Functions used from binfmt_elf core code */
+#define fill_psinfo		compat_fill_psinfo
+#define fill_prstatus		compat_fill_prstatus
+#define fill_extnum_info	compat_fill_extnum_info
+#define fill_auxv_note		compat_fill_auxv_note
+#define fill_elf_header		compat_fill_elf_header
+/*
+ * Define the fileds in elf_thread_core_info and core_proc
+ * for compat ELF class
+ */
+#define et_prstatus	u.compat_prstatus
+#define cp_prpsinfo	u.compat_prpsinfo
+
+/* Rename the core function to compat_ */
+#define elf_read_gencore	compat_elf_read_gencore
+
+#include "gencore-elf.c"
Index: linux-2.6.36-rc7/fs/proc/Makefile
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/Makefile
+++ linux-2.6.36-rc7/fs/proc/Makefile
@@ -20,6 +20,7 @@ proc-y	+= uptime.o
 proc-y	+= version.o
 proc-y	+= softirqs.o
 proc-$(CONFIG_ELF_CORE)	+= gencore.o gencore-elf.o
+proc-$(CONFIG_COMPAT_BINFMT_ELF) += gencore-compat-elf.o
 proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
 proc-$(CONFIG_NET)		+= proc_net.o
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
