Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab1C1Drh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 23:47:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab1C1Drg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 23:47:36 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric B Munson <emunson@mgebm.net>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [Patch] proc: check error pointer returned by m_start()
Date: Mon, 28 Mar 2011 11:46:38 +0800
Message-Id: <1301284006-18808-1-git-send-email-amwang@redhat.com>
In-Reply-To: <20110327175203.GA15862@fibrous.localdomain>
References: <20110327175203.GA15862@fibrous.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anca reported a bug:

[15117.080119] BUG: unable to handle kernel paging request at fffffffffffffff3
[15117.080152] IP: [<ffffffff811b4989>] vma_stop+0x19/0x40

Linus did the initial analysis, and found this was caused
by commit ec6fd8a4355c ("report errors in /proc/*/*map*
sanely"), which replaces NULL with various ERR_PTR() cases.

This is true, that commit changed the return value of m_start(),
which will return an error pointer on failure, but Al forgot
to check the error pointer in m_stop() which will be called
when m_start() fails. This patches fixes it.

Reported-by: Anca Emanuel <anca.emanuel@gmail.com>
Tested-by: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 7c708a4..6b82632 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -90,7 +90,7 @@ static void pad_len_spaces(struct seq_file *m, int len)
 
 static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
 {
-	if (vma && vma != priv->tail_vma) {
+	if (vma && !IS_ERR(vma) && vma != priv->tail_vma) {
 		struct mm_struct *mm = vma->vm_mm;
 		up_read(&mm->mmap_sem);
 		mmput(mm);
