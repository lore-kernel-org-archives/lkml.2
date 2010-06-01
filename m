Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0FANLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:11:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab0FANLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:11:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] binfmt_elf_fdpic: Fix clear_user() error handling
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       David Howells <dhowells@redhat.com>, Mike Frysinger <vapier@gentoo.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
       Paul Mundt <lethal@linux-sh.org>
Date: Tue, 01 Jun 2010 14:10:47 +0100
Message-ID: <20100601131047.5456.34014.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>

clear_user() returns the number of bytes that could not be copied rather than
an error code.  So we should return -EFAULT rather than directly returning the
results.

Without this patch, positive values may be returned to elf_fdpic_map_file()
and the following error handlings do not function as expected.

1.
	ret = elf_fdpic_map_file_constdisp_on_uclinux(params, file, mm);
	if (ret < 0)
		return ret;
2.
	ret = elf_fdpic_map_file_by_direct_mmap(params, file, mm);
	if (ret < 0)
		return ret;

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
CC: Paul Mundt <lethal@linux-sh.org>
---

 fs/binfmt_elf_fdpic.c |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)


diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 2c5f9a0..63039ed 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -990,10 +990,9 @@ static int elf_fdpic_map_file_constdisp_on_uclinux(
 
 		/* clear any space allocated but not loaded */
 		if (phdr->p_filesz < phdr->p_memsz) {
-			ret = clear_user((void *) (seg->addr + phdr->p_filesz),
-					 phdr->p_memsz - phdr->p_filesz);
-			if (ret)
-				return ret;
+			if (clear_user((void *) (seg->addr + phdr->p_filesz),
+				       phdr->p_memsz - phdr->p_filesz))
+				return -EFAULT;
 		}
 
 		if (mm) {
@@ -1027,7 +1026,7 @@ static int elf_fdpic_map_file_by_direct_mmap(struct elf_fdpic_params *params,
 	struct elf32_fdpic_loadseg *seg;
 	struct elf32_phdr *phdr;
 	unsigned long load_addr, delta_vaddr;
-	int loop, dvset, ret;
+	int loop, dvset;
 
 	load_addr = params->load_addr;
 	delta_vaddr = 0;
@@ -1127,9 +1126,8 @@ static int elf_fdpic_map_file_by_direct_mmap(struct elf_fdpic_params *params,
 		 * PT_LOAD */
 		if (prot & PROT_WRITE && disp > 0) {
 			kdebug("clear[%d] ad=%lx sz=%lx", loop, maddr, disp);
-			ret = clear_user((void __user *) maddr, disp);
-			if (ret)
-				return ret;
+			if (clear_user((void __user *) maddr, disp))
+				return -EFAULT;
 			maddr += disp;
 		}
 
@@ -1164,19 +1162,17 @@ static int elf_fdpic_map_file_by_direct_mmap(struct elf_fdpic_params *params,
 		if (prot & PROT_WRITE && excess1 > 0) {
 			kdebug("clear[%d] ad=%lx sz=%lx",
 			       loop, maddr + phdr->p_filesz, excess1);
-			ret = clear_user((void __user *) maddr + phdr->p_filesz,
-					 excess1);
-			if (ret)
-				return ret;
+			if (clear_user((void __user *) maddr + phdr->p_filesz,
+				       excess1))
+				return -EFAULT;
 		}
 
 #else
 		if (excess > 0) {
 			kdebug("clear[%d] ad=%lx sz=%lx",
 			       loop, maddr + phdr->p_filesz, excess);
-			ret = clear_user((void *) maddr + phdr->p_filesz, excess);
-			if (ret)
-				return ret;
+			if (clear_user((void *) maddr + phdr->p_filesz, excess))
+				return -EFAULT;
 		}
 #endif
 

