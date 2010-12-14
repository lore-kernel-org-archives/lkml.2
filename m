Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037Ab0LNKIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:08:24 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:57153 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0LNKIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:08:22 -0500
Date: Tue, 14 Dec 2010 15:38:28 +0530
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
Subject: [Patch 8/21] ia64 Implementation of elf_core_copy_extra_phdrs()
Message-ID: <20101214153828.2b3fd160@suzukikp>
In-Reply-To: <20101214152259.67896960@suzukikp>
References: <20101214152259.67896960@suzukikp>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia64 impelementation for elf_core_copy_extra_phdrs(). Adapted from 
elf_core_write_extra_phdrs().

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 arch/ia64/kernel/elfcore.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

Index: linux-2.6.36-rc7/arch/ia64/kernel/elfcore.c
===================================================================
--- linux-2.6.36-rc7.orig/arch/ia64/kernel/elfcore.c
+++ linux-2.6.36-rc7/arch/ia64/kernel/elfcore.c
@@ -42,6 +42,40 @@ int elf_core_write_extra_phdrs(struct fi
 	return 1;
 }
 
+int elf_core_copy_extra_phdrs(char *bufp, loff_t offset, size_t *size,
+				unsigned long limit)
+{
+	const struct elf_phdr *const gate_phdrs =
+		(const struct elf_phdr *) (GATE_ADDR + GATE_EHDR->e_phoff);
+	int i;
+	Elf64_Off ofs = 0;
+	struct elf_phdr *phdr = (struct elf_phdr *) bufp;
+
+	for (i = 0; i < GATE_EHDR->e_phnum; ++i) {
+		*size += sizeof(*phdr);
+		if (*size > limit)
+			return 0;
+
+		*phdr = gate_phdrs[i];
+
+		if (phdr->p_type == PT_LOAD) {
+			phdr->p_memsz = PAGE_ALIGN(phdr->p_memsz);
+			phdr->p_filesz = phdr->p_memsz;
+			if (ofs == 0) {
+				ofs = phdr->p_offset = *offset;
+				offset += phdr->p_filesz;
+			} else {
+				phdr->p_offset = ofs;
+			}
+		} else {
+			phdr->p_offset += ofs;
+		}
+		phdr->p_paddr = 0; /* match other core phdrs */
+		phdr++;
+	}
+	return 1;
+}
+
 int elf_core_write_extra_data(struct file *file, size_t *size,
 			      unsigned long limit)
 {
