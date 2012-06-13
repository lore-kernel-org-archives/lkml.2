Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2FMSwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:52:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab2FMSwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:52:31 -0400
Date: Wed, 13 Jun 2012 20:50:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] uprobes: no need to re-check vma_address() in
	write_opcode()
Message-ID: <20120613185030.GC13878@redhat.com>
References: <20120613184933.GA13870@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613184933.GA13870@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write_opcode() is called by register_for_each_vma() and uprobe_mmap()
paths. In both cases the caller has already verified this vaddr under
mmap_sem, no need to re-check.

Note also that this check is wrong anyway, we should not truncate
loff_t returned by vma_address() if we do not trust this mapping.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 9bb5571..799d6ed 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -211,7 +211,6 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	struct vm_area_struct *vma;
 	struct uprobe *uprobe;
 	unsigned long pgoff;
-	loff_t addr;
 	int ret;
 retry:
 	/* Read the page with vaddr into memory */
@@ -235,10 +234,6 @@ retry:
 	if (mapping != vma->vm_file->f_mapping)
 		goto put_out;
 
-	addr = vma_address(vma, uprobe->offset);
-	if (vaddr != (unsigned long)addr)
-		goto put_out;
-
 	ret = -ENOMEM;
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
 	if (!new_page)
-- 
1.5.5.1


