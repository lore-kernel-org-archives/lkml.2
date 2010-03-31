Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab0CaRYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 13:24:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52972 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab0CaRYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 13:24:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=A2jZobkk6RnM+iq0XL+5WX7innlj3I0N0ZW+cQ4X2/k01Z+UmEgbVSl0nHbmFBVSa
	JKuhud7Mw31Z7rayyK9iQ==
From: San Mehat <san@google.com>
To: linux-kernel@vger.kernel.org
Cc: San Mehat <san@google.com>, Brian Swetland <swetland@google.com>,
       Matt Mackall <mpm@selenic.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] proc: pagemap: Hold mmap_sem during page walk
Date: Wed, 31 Mar 2010 10:23:47 -0700
Message-Id: <1270056227-5442-1-git-send-email-san@google.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the mmap_sem is not held while we walk_page_range(), then
it is possible for find_vma() to race with a remove_vma_list()
caused by do_munmap() (or others).

Unable to handle kernel paging request at virtual address 6b6b6b5b
Internal error: Oops: 5 [#1] PREEMPT
CPU: 0    Not tainted  (2.6.32.9-27154-ge3e6e27 #1)
PC is at find_vma+0x40/0x7c
LR is at walk_page_range+0x70/0x230
pc : [<c00aa3ac>]    lr : [<c00b298c>]    psr: 20000013
sp : c6aa9eb8  ip : 6b6b6b53  fp : c6a58f60
r10: c7e1d1b8  r9 : 0001bca0  r8 : 47000000
r7 : c6aa9f80  r6 : c6aa8000  r5 : 46fbd000  r4 : 6b6b6b6b
r3 : c7ca4820  r2 : 6b6b6b6b  r1 : 46fbd000  r0 : c70e3e40
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c5787d  Table: 26574019  DAC: 00000015

[<c00aa3ac>] (find_vma+0x40/0x7c) from [<c00b298c>] (walk_page_range+0x70/0x230)
[<c00b298c>] (walk_page_range+0x70/0x230) from [<c00f5d3c>] (pagemap_read+0x1a4/0x278)
[<c00f5d3c>] (pagemap_read+0x1a4/0x278) from [<c00bac40>] (vfs_read+0xa8/0x150)
[<c00bac40>] (vfs_read+0xa8/0x150) from [<c00bad94>] (sys_read+0x3c/0x68)
[<c00bad94>] (sys_read+0x3c/0x68) from [<c0026f00>] (ret_fast_syscall+0x0/0x2c)
Code: 98bd8010 e5932004 e3a00000 ea000008 (e5124010)

Signed-off-by: San Mehat <san@google.com>
Cc: Brian Swetland <swetland@google.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/proc/task_mmu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2a1bef9..3f300c1 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -726,8 +726,6 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	down_read(&current->mm->mmap_sem);
 	ret = get_user_pages(current, current->mm, uaddr, pagecount,
 			     1, 0, pages, NULL);
-	up_read(&current->mm->mmap_sem);
-
 	if (ret < 0)
 		goto out_free;
 
@@ -776,6 +774,7 @@ out_pages:
 		page_cache_release(page);
 	}
 out_free:
+	up_read(&current->mm->mmap_sem);
 	kfree(pages);
 out_mm:
 	mmput(mm);
-- 
1.7.0.1

