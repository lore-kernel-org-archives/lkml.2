Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab2AKLaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 06:30:20 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:48802 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab2AKLaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 06:30:18 -0500
Message-ID: <1326281412.2819.3.camel@br98xy6r>
Subject: [PATCH] kdump: Define KEXEC_NOTE_BYTES arch specific for s390x
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: akpm@linux-foundation.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Date: Wed, 11 Jan 2012 12:30:12 +0100
Organization: IBM
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12011111-4966-0000-0000-00000120CB2D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

kdump only allocates memory for the prstatus ELF note. For s390x,
besides of prstatus multiple ELF notes for various different register
types are stored. Therefore the currently allocated memory is not
sufficient. With this patch the KEXEC_NOTE_BYTES macro can be
defined by architecture code and for s390x it is set to the correct
size now.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/include/asm/kexec.h |   18 ++++++++++++++++++
 include/linux/kexec.h         |    2 ++
 2 files changed, 20 insertions(+)

--- a/arch/s390/include/asm/kexec.h
+++ b/arch/s390/include/asm/kexec.h
@@ -42,6 +42,24 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_S390
 
+/*
+ * Size for s390x ELF notes per CPU
+ *
+ * Seven notes plus zero note at the end: prstatus, fpregset, timer,
+ * tod_cmp, tod_reg, control regs, and prefix
+ */
+#define KEXEC_NOTE_BYTES \
+	(ALIGN(sizeof(struct elf_note), 4) * 8 + \
+	 ALIGN(sizeof("CORE"), 4) * 7 + \
+	 ALIGN(sizeof(struct elf_prstatus), 4) + \
+	 ALIGN(sizeof(elf_fpregset_t), 4) + \
+	 ALIGN(sizeof(u64), 4) + \
+	 ALIGN(sizeof(u64), 4) + \
+	 ALIGN(sizeof(u32), 4) + \
+	 ALIGN(sizeof(u64) * 16, 4) + \
+	 ALIGN(sizeof(u32), 4) \
+	)
+
 /* Provide a dummy definition to avoid build failures. */
 static inline void crash_setup_regs(struct pt_regs *newregs,
 					struct pt_regs *oldregs) { }
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -50,9 +50,11 @@
  * note header.  For kdump, the code in vmcore.c runs in the context
  * of the second kernel to combine them into one note.
  */
+#ifndef KEXEC_NOTE_BYTES
 #define KEXEC_NOTE_BYTES ( (KEXEC_NOTE_HEAD_BYTES * 2) +		\
 			    KEXEC_CORE_NOTE_NAME_BYTES +		\
 			    KEXEC_CORE_NOTE_DESC_BYTES )
+#endif
 
 /*
  * This structure is used to hold the arguments that are used when loading


