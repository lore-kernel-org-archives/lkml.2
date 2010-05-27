Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614Ab0E0T5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:57:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab0E0T5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:57:35 -0400
Date: Thu, 27 May 2010 21:56:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] blackfin: ptrace: fix the unsafe usage of mm/find_vma
	in is_user_addr_valid()
Message-ID: <20100527195609.GB25935@redhat.com>
References: <20100521162659.GA16193@redhat.com> <20100521183512.4477F40476@magilla.sf.frob.com> <20100522165320.GA19573@redhat.com> <25539.1274711817@redhat.com> <20100524151445.GA6393@redhat.com> <17134.1274778852@redhat.com> <20100525102345.GA23574@redhat.com> <AANLkTilT3D8c86LYK2DxcNpM2F3D8iCbgY_sfUg8h58p@mail.gmail.com> <20100526124006.GA28358@redhat.com> <20100527195544.GA25935@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527195544.GA25935@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. is_user_addr_valid() must not assume child->mm != NULL, we can
   race with SIGKILL. Use get_task_mm().

2. find_vma() needs mm->mmap_sem, we can race with another thread
   which shares ->mm with the tracee.

3. Move the simple FIXED_CODE_ checks up, before other potentially
   costly checks, and thus outside of mmap_sem.

4. Uninline it, it is fat and has 2 callers.

Note: we scan mm->context.sram_list under mmap_sem too. Currently this
is unnecessary, but see the next patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/blackfin/kernel/ptrace.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- 34-rc1/arch/blackfin/kernel/ptrace.c~IUAV_1_GET_MM_TAKE_SEM	2010-05-27 17:52:36.000000000 +0200
+++ 34-rc1/arch/blackfin/kernel/ptrace.c	2010-05-27 20:07:10.000000000 +0200
@@ -113,29 +113,40 @@ put_reg(struct task_struct *task, long r
 /*
  * check that an address falls within the bounds of the target process's memory mappings
  */
-static inline int is_user_addr_valid(struct task_struct *child,
+static int is_user_addr_valid(struct task_struct *child,
 				     unsigned long start, unsigned long len)
 {
+	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	struct sram_list_struct *sraml;
+	int ret = 0;
 
 	/* overflow */
 	if (start + len < start)
 		return -EIO;
+	if (start >= FIXED_CODE_START && start + len < FIXED_CODE_END)
+		return 0;
 
-	vma = find_vma(child->mm, start);
+	mm = get_task_mm(child);
+	if (!mm)
+		return -EIO;
+
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, start);
 	if (vma && start >= vma->vm_start && start + len <= vma->vm_end)
-			return 0;
+			goto out;
 
-	for (sraml = child->mm->context.sram_list; sraml; sraml = sraml->next)
+	for (sraml = mm->context.sram_list; sraml; sraml = sraml->next)
 		if (start >= (unsigned long)sraml->addr
 		    && start + len < (unsigned long)sraml->addr + sraml->length)
-			return 0;
+			goto out;
 
-	if (start >= FIXED_CODE_START && start + len < FIXED_CODE_END)
-		return 0;
+	ret = -EIO;
+out:
+	up_read(&mm->mmap_sem);
+	mmput(mm);
 
-	return -EIO;
+	return ret;
 }
 
 /*

