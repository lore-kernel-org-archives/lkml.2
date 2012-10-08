Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab2JHPKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 11:10:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065Ab2JHPJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:09:57 -0400
Date: Mon, 8 Oct 2012 11:09:49 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: bhutchings@solarflare.com, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: mpol_to_str revisited.
Message-ID: <20121008150949.GA15130@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	bhutchings@solarflare.com, linux-mm@kvack.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last month I sent in 80de7c3138ee9fd86a98696fd2cf7ad89b995d0a to remove
a user triggerable BUG in mempolicy.

Ben Hutchings pointed out to me that my change introduced a potential leak
of stack contents to userspace, because none of the callers check the return value.

This patch adds the missing return checking, and also clears the buffer beforehand.

Reported-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: stable@kernel.org
Signed-off-by: Dave Jones <davej@redhat.com>

--- 
unanswered question: why are the buffer sizes here different ? which is correct?


diff -durpN '--exclude-from=/home/davej/.exclude' src/git-trees/kernel/linux/fs/proc/task_mmu.c linux-dj/fs/proc/task_mmu.c
--- src/git-trees/kernel/linux/fs/proc/task_mmu.c	2012-05-31 22:32:46.778150675 -0400
+++ linux-dj/fs/proc/task_mmu.c	2012-10-04 19:31:41.269988984 -0400
@@ -1162,6 +1162,7 @@ static int show_numa_map(struct seq_file
 	struct mm_walk walk = {};
 	struct mempolicy *pol;
 	int n;
+	int ret;
 	char buffer[50];
 
 	if (!mm)
@@ -1178,7 +1179,11 @@ static int show_numa_map(struct seq_file
 	walk.mm = mm;
 
 	pol = get_vma_policy(proc_priv->task, vma, vma->vm_start);
-	mpol_to_str(buffer, sizeof(buffer), pol, 0);
+	memset(buffer, 0, sizeof(buffer));
+	ret = mpol_to_str(buffer, sizeof(buffer), pol, 0);
+	if (ret < 0)
+		return 0;
+
 	mpol_cond_put(pol);
 
 	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
diff -durpN '--exclude-from=/home/davej/.exclude' src/git-trees/kernel/linux/mm/shmem.c linux-dj/mm/shmem.c
--- src/git-trees/kernel/linux/mm/shmem.c	2012-10-02 15:49:51.977277944 -0400
+++ linux-dj/mm/shmem.c	2012-10-04 19:32:28.862949907 -0400
@@ -885,13 +885,15 @@ redirty:
 static void shmem_show_mpol(struct seq_file *seq, struct mempolicy *mpol)
 {
 	char buffer[64];
+	int ret;
 
 	if (!mpol || mpol->mode == MPOL_DEFAULT)
 		return;		/* show nothing */
 
-	mpol_to_str(buffer, sizeof(buffer), mpol, 1);
-
-	seq_printf(seq, ",mpol=%s", buffer);
+	memset(buffer, 0, sizeof(buffer));
+	ret = mpol_to_str(buffer, sizeof(buffer), mpol, 1);
+	if (ret > 0)
+		seq_printf(seq, ",mpol=%s", buffer);
 }
 
 static struct mempolicy *shmem_get_sbmpol(struct shmem_sb_info *sbinfo)
