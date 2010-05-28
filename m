Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab0E1H4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:56:38 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:41586 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab0E1H4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:56:36 -0400
Date: Fri, 28 May 2010 16:56:59 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: akpm@linux-foundation.org, viro@zeniv.linux.org.uk
Cc: d.hatayama@jp.fujitsu.com, dhowells@redhat.com, vapier@gentoo.org,
       lethal@linux-sh.org, takuya.yoshikawa@gmail.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] binfmt_elf_fdpic: fix clear_user() error handling
Message-Id: <20100528165659.1e6fd136.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I found some places in bin_elf_fdpic at which clear_user() is
incorrectly handled, by chance, when I was trying to check how to
use clear_user().

IIUC, the following commit was not correct.

  commit ab4ad55512e95b68ca3e25516068e18874f89252
  bin_elf_fdpic: check the return value of clear_user

Although I don't have an appropriate test box for this, I wrote a
simple patch to fix this. So if this is worth fixing, please pick
this up.

Thanks,
  Takuya

===
clear_user() returns the number of bytes, unsigned long, that could not
be copied. So we should return -EFAULT rather than directly return the results.

Without this patch, positive values may be passed to elf_fdpic_map_file() and
the following error handlings do not function as expected.

1.
	ret = elf_fdpic_map_file_constdisp_on_uclinux(params, file, mm);
	if (ret < 0)
		return ret;
2.
	ret = elf_fdpic_map_file_by_direct_mmap(params, file, mm);
	if (ret < 0)
		return ret;

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
CC: David Howells <dhowells@redhat.com>
CC: Mike Frysinger <vapier@gentoo.org>
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
 
-- 
1.7.0.4

