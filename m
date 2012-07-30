Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab2G3OSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:18:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45733 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2G3OSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:18:45 -0400
Date: Mon, 30 Jul 2012 07:18:31 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-cb113b47d098185f3f1f67e8300d05ddce842b66@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@redhat.com, hpa@zytor.com,
        mingo@kernel.org, srikar@linux.vnet.ibm.com, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@redhat.com,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120729182242.GA20355@redhat.com>
References: <20120729182242.GA20355@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Introduce vaddr_to_offset(vma, vaddr)
Git-Commit-ID: cb113b47d098185f3f1f67e8300d05ddce842b66
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Jul 2012 07:18:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb113b47d098185f3f1f67e8300d05ddce842b66
Gitweb:     http://git.kernel.org/tip/cb113b47d098185f3f1f67e8300d05ddce842b66
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 29 Jul 2012 20:22:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 30 Jul 2012 11:27:24 +0200

uprobes: Introduce vaddr_to_offset(vma, vaddr)

Add the new helper, vaddr_to_offset(vma, vaddr) which returns
the offset in vma->vm_file this vaddr is mapped at.

Change build_probe_list() and find_active_uprobe() to use the
new helper, the next patch adds another user.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120729182242.GA20355@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 2ef1233..b03256c 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -122,6 +122,11 @@ static loff_t vma_address(struct vm_area_struct *vma, loff_t offset)
 	return vaddr;
 }
 
+static loff_t vaddr_to_offset(struct vm_area_struct *vma, unsigned long vaddr)
+{
+	return ((loff_t)vma->vm_pgoff << PAGE_SHIFT) + (vaddr - vma->vm_start);
+}
+
 /**
  * __replace_page - replace page in vma by new page.
  * based on replace_page in mm/ksm.c
@@ -978,7 +983,7 @@ static void build_probe_list(struct inode *inode,
 	struct uprobe *u;
 
 	INIT_LIST_HEAD(head);
-	min = ((loff_t)vma->vm_pgoff << PAGE_SHIFT) + start - vma->vm_start;
+	min = vaddr_to_offset(vma, start);
 	max = min + (end - start) - 1;
 
 	spin_lock_irqsave(&uprobes_treelock, flags);
@@ -1442,12 +1447,9 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 	vma = find_vma(mm, bp_vaddr);
 	if (vma && vma->vm_start <= bp_vaddr) {
 		if (valid_vma(vma, false)) {
-			struct inode *inode;
-			loff_t offset;
+			struct inode *inode = vma->vm_file->f_mapping->host;
+			loff_t offset = vaddr_to_offset(vma, bp_vaddr);
 
-			inode = vma->vm_file->f_mapping->host;
-			offset = bp_vaddr - vma->vm_start;
-			offset += (loff_t)vma->vm_pgoff << PAGE_SHIFT;
 			uprobe = find_uprobe(inode, offset);
 		}
 
