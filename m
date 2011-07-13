Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051Ab1GMSHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 14:07:51 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37250 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249Ab1GMSHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 14:07:48 -0400
Subject: [RFC PATCH 06/10] fadump: Add PT_NOTE program header for vmcoreinfo
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>, Haren Myneni <hbabu@us.ibm.com>,
        Anton Blanchard <anton@samba.org>, Milton Miller <miltonm@bga.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 13 Jul 2011 23:37:43 +0530
Message-ID: <20110713180734.6210.55823.stgit@mars.in.ibm.com>
In-Reply-To: <20110713180252.6210.34810.stgit@mars.in.ibm.com>
References: <20110713180252.6210.34810.stgit@mars.in.ibm.com>
User-Agent: StGit/0.15-1-ged5e-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

Introduce a PT_NOTE program header that points to physical address of
vmcoreinfo_note buffer declared in kernel/kexec.c. The vmcoreinfo
note buffer is populated during crash_fadump() at the time of system
crash.

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/fadump.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 51e645c..fee132b 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -817,6 +817,19 @@ static void setup_crash_memory_ranges(void)
 	}
 }
 
+/*
+ * If the given physical address falls within the boot memory region then
+ * return the relocated address that points to the dump region reserved
+ * for saving initial boot memory contents.
+ */
+static inline unsigned long relocate(unsigned long paddr)
+{
+	if (paddr > RMR_START && paddr < fw_dump.boot_memory_size)
+		return fdm.rmr_region.destination_address + paddr;
+	else
+		return paddr;
+}
+
 static int create_elfcore_headers(char *bufp)
 {
 	struct elfhdr *elf;
@@ -849,6 +862,22 @@ static int create_elfcore_headers(char *bufp)
 	/* Increment number of program headers. */
 	(elf->e_phnum)++;
 
+	/* setup ELF PT_NOTE for vmcoreinfo */
+	phdr = (struct elf_phdr *)bufp;
+	bufp += sizeof(struct elf_phdr);
+	phdr->p_type	= PT_NOTE;
+	phdr->p_flags	= 0;
+	phdr->p_vaddr	= 0;
+	phdr->p_align	= 0;
+
+	phdr->p_paddr	= relocate(paddr_vmcoreinfo_note());
+	phdr->p_offset	= phdr->p_paddr;
+	phdr->p_memsz	= vmcoreinfo_max_size;
+	phdr->p_filesz	= vmcoreinfo_max_size;
+
+	/* Increment number of program headers. */
+	(elf->e_phnum)++;
+
 	/* setup PT_LOAD sections. */
 
 	for (i = 0; i < crash_mem_ranges; i++) {

