Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab2FSTtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 15:49:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab2FSTtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 15:49:06 -0400
Date: Tue, 19 Jun 2012 21:46:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] uprobes: don't recheck vma/f_mapping in write_opcode()
Message-ID: <20120619194655.GA30146@redhat.com>
References: <20120619194636.GA30137@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120619194636.GA30137@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write_opcode() rechecks valid_vma() and ->f_mapping, this is pointless.
The caller, register_for_each_vma() or uprobe_mmap(), has already done
these checks under mmap_sem.

To clarify, uprobe_mmap() checks valid_vma() only, but we can rely on
build_probe_list(vm_file->f_mapping->host).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index f935327..a2b32a5 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -206,33 +206,16 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
 			unsigned long vaddr, uprobe_opcode_t opcode)
 {
 	struct page *old_page, *new_page;
-	struct address_space *mapping;
 	void *vaddr_old, *vaddr_new;
 	struct vm_area_struct *vma;
-	struct uprobe *uprobe;
 	int ret;
+
 retry:
 	/* Read the page with vaddr into memory */
 	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 0, &old_page, &vma);
 	if (ret <= 0)
 		return ret;
 
-	ret = -EINVAL;
-
-	/*
-	 * We are interested in text pages only. Our pages of interest
-	 * should be mapped for read and execute only. We desist from
-	 * adding probes in write mapped pages since the breakpoints
-	 * might end up in the file copy.
-	 */
-	if (!valid_vma(vma, is_swbp_insn(&opcode)))
-		goto put_out;
-
-	uprobe = container_of(auprobe, struct uprobe, arch);
-	mapping = uprobe->inode->i_mapping;
-	if (mapping != vma->vm_file->f_mapping)
-		goto put_out;
-
 	ret = -ENOMEM;
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
 	if (!new_page)
-- 
1.5.5.1


