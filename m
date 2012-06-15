Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab2FOPrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:47:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423Ab2FOPpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:45:52 -0400
Date: Fri, 15 Jun 2012 17:43:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] uprobes: no need to re-check vma_address() in
	write_opcode()
Message-ID: <20120615154347.GA9604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615154241.GA9524@redhat.com>
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
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 kernel/events/uprobes.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 2db1d94..14c71a2 100644
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

