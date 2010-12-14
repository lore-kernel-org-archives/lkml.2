Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab0LNKJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:09:51 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:52082 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab0LNKJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:09:48 -0500
Date: Tue, 14 Dec 2010 15:39:56 +0530
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
Subject: [Patch 9/21] UML (i386) Implementation of
 elf_core_copy_extra_phdrs()
Message-ID: <20101214153956.1716d261@suzukikp>
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

elf_core_copy_extra_phdrs() for UML. Adapted from elf_core_write_extra_phdrs()

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 arch/um/sys-i386/elfcore.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

Index: linux-2.6.36-rc7/arch/um/sys-i386/elfcore.c
===================================================================
--- linux-2.6.36-rc7.orig/arch/um/sys-i386/elfcore.c
+++ linux-2.6.36-rc7/arch/um/sys-i386/elfcore.c
@@ -41,6 +41,38 @@ int elf_core_write_extra_phdrs(struct fi
 	return 1;
 }
 
+int elf_core_copy_extra_phdrs(char *bufp, loff_t offset, size_t *size,
+				unsigned long limit)
+{
+	if (vsyscall_ehdr) {
+		const struct elfhdr *const ehdrp =
+			(struct elfhdr *) vsyscall_ehdr;
+		const struct elf_phdr *const phdrp =
+			(const struct elf_phdr *) (vsyscall_ehdr + ehdrp->e_phoff);
+		struct elf_phdr *phdr = (struct elf_phdr *)bufp;
+		int i;
+		Elf32_Off ofs = 0;
+
+		for (i = 0; i < ehdrp->e_phnum; ++i) {
+			*size += sizeof(*phdr);
+			if (*size > limit)
+				return 0;
+
+			*phdr = phdrp[i];
+
+			if (phdr.p_type == PT_LOAD) {
+				ofs = phdr.p_offset = offset;
+				offset += phdr.p_filesz;
+			} else {
+				phdr.p_offset += ofs;
+			}
+			phdr.p_paddr = 0; /* match other core phdrs */
+			phdr++;
+		}
+	}
+	return 1;
+}
+
 int elf_core_write_extra_data(struct file *file, size_t *size,
 			      unsigned long limit)
 {
