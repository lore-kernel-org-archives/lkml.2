Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab0LNKVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:21:52 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36931 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304Ab0LNKVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:21:51 -0500
Date: Tue, 14 Dec 2010 15:52:00 +0530
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
Subject: [Patch 18/21] Generate the data sections for ELF Core
Message-ID: <20101214155200.06b56e57@suzukikp>
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

Generate the "data" for the memory regions. Also write down the section header 
if we have, number of phdrs > PN_XNUM.

The vma areas are read, page by page using access_process_vm() without an 
mmap_sem. If there are active threads, then we may miss a vma if it is removed 
while we are doing the read.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Ananth N. Mavinakayanahalli <ananth@in.ibm.com>
---
 fs/proc/gencore-elf.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 87 insertions(+), 3 deletions(-)

Index: linux-2.6.36-rc7/fs/proc/gencore-elf.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore-elf.c
+++ linux-2.6.36-rc7/fs/proc/gencore-elf.c
@@ -333,10 +333,29 @@ static int create_elf_header(struct core
 	return 0;
 }
 
+/*
+ * Verify if the fpos asked for in read is valid.
+ * Returns the phdr corresponding to offset, else NULL.
+ */
+static struct elf_phdr *get_pos_elfphdr(struct core_proc *cp, loff_t pos)
+{
+	struct elfhdr *elf_hdr = (struct elfhdr *)cp->elf_buf;
+	struct elf_phdr *phdr = (struct elf_phdr*)(cp->elf_buf + elf_hdr->e_phoff);
+	int i;
+
+	for (i = 0; i < cp->nphdrs; i++, phdr++) {
+		unsigned long end = phdr->p_offset + phdr->p_filesz;
+		if ((pos >= phdr->p_offset) && (pos < end))
+			return phdr;
+	}
+	return NULL;
+}
+
 ssize_t elf_read_gencore(struct core_proc *cp, char __user *buffer,
 				size_t buflen, loff_t *fpos)
 {
-	ssize_t ret = 0;
+	ssize_t ret = 0, acc = 0;
+	struct elfhdr *elf_hdr = (struct elfhdr *)cp->elf_buf;
 
 	if (!cp->notes_size) {
 		if (!collect_notes(cp)) {
@@ -367,16 +386,81 @@ ssize_t elf_read_gencore(struct core_pro
 			ret = -EFAULT;
 			goto out;
 		} else {
-			ret = bcp;
+			acc = bcp;
 			*fpos += bcp;
 			buflen -= bcp;
 			buffer += bcp;
 		}
 	}
 
+
 	if (*fpos > cp->size)
-		goto out;
+		goto done;
+
+	/*
+	 * Read from the vma segments
+	 * a. verify if the *fpos is within a phdr
+	 * b. Use access_process_vm() to get data page by page
+	 * c. copy_to_user into user buffer
+	 */
+
+	while (buflen) {
+		size_t bufsz, offset, bytes;
+		char *readbuf;
+		struct elf_phdr *phdr = get_pos_elfphdr(cp, *fpos);
+
+		if (!phdr)
+			break;
+
+		bufsz = (buflen > PAGE_SIZE) ? PAGE_SIZE : buflen;
+		readbuf = kmalloc(bufsz, GFP_KERNEL);
+		if (!readbuf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		offset = *fpos - phdr->p_offset;
+		bytes = access_process_vm(cp->task, (phdr->p_vaddr + offset),
+						readbuf, bufsz, 0);
+		if (!bytes) {
+			ret = -EIO;
+			goto out;
+		}
+		if (copy_to_user(buffer, readbuf, bytes)) {
+			ret = -EFAULT;
+			kfree(readbuf);
+			goto out;
+		} else
+			acc += bytes;
+
+		kfree(readbuf);
+		buflen -= bytes;
+		buffer += bytes;
+		*fpos += bytes;
+	}
+
+	/* Fill extnum section header if present */
+	if (buflen &&
+		elf_hdr->e_shoff &&
+		(*fpos >= elf_hdr->e_shoff) &&
+		(*fpos < (elf_hdr->e_shoff + sizeof(struct elf_shdr)))) {
+
+		off_t offset = *fpos - elf_hdr->e_shoff;
+		size_t shdrsz = sizeof(struct elf_shdr) - offset;
+
+		shdrsz = (buflen < shdrsz) ? buflen : shdrsz;
+		if (copy_to_user(buffer, ((char *)cp->shdr) + offset, shdrsz)) {
+			ret = -EFAULT;
+			goto out;
+		} else {
+			acc += shdrsz;
+			buflen -= shdrsz;
+			buffer += shdrsz;
+		}
+	}
 
+done:
+	ret = acc;
 out:
 	return ret;
 }
