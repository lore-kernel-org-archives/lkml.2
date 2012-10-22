Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab2JVMoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:44:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:52441 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2JVMoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:44:21 -0400
Message-ID: <1350909815.2768.100.camel@twins>
Subject: re: sched, numa, mm: Implement constant, per task Working Set
 Sampling (WSS) rate
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org
Date: Mon, 22 Oct 2012 14:43:35 +0200
In-Reply-To: <20121022115545.GA631@elgon.mountain>
References: <20121022115545.GA631@elgon.mountain>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-22 at 14:55 +0300, Dan Carpenter wrote:
> Hello Peter Zijlstra,
> 
> The patch 3d049f8a5398: "sched, numa, mm: Implement constant, per
> task Working Set Sampling (WSS) rate" from Oct 14, 2012, leads to the
> following warning:
> kernel/sched/fair.c:954 task_numa_work()
> 	 error: we previously assumed 'vma' could be null (see line 948)
> 
>    943          if (!vma) {
>    944                  ACCESS_ONCE(mm->numa_scan_seq)++;
>    945                  offset = 0;
>    946                  vma = mm->mmap;
>    947          }
>    948          while (vma && !vma_migratable(vma)) {
>                        ^^^
> If this is NULL,
>    949                  vma = vma->vm_next;
>    950                  if (!vma)
>    951                          goto again;
>    952          }
>    953  
>    954          offset = max(offset, vma->vm_start);
>                                      ^^^^^^^^^^^^^
> then it leads to a NULL dereference here.

Ah.. indeed so. There's also what looks like an infinite loop in there
if nothing is migratable or if length is stupid large. The below should
avoid the reported NULL deref as well as break out when we've reached
the end of the address space.


---
 kernel/sched/fair.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c68b877..5a6d8f5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -939,29 +939,22 @@ void task_numa_work(struct callback_head *work)
 
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, offset);
-again:
 	if (!vma) {
 		ACCESS_ONCE(mm->numa_scan_seq)++;
 		offset = 0;
 		vma = mm->mmap;
 	}
-	while (vma && !vma_migratable(vma)) {
-		vma = vma->vm_next;
-		if (!vma)
-			goto again;
-	}
-
-	offset = max(offset, vma->vm_start);
-	end = min(ALIGN(offset + length, HPAGE_SIZE), vma->vm_end);
-	length -= end - offset;
+	for (; vma && length > 0; vma = vma->vm_next) {
+		if (!vma_migratable(vma))
+			continue;
 
-	change_prot_none(vma, offset, end);
+		offset = max(offset, vma->vm_start);
+		end = min(ALIGN(offset + length, HPAGE_SIZE), vma->vm_end);
+		length -= end - offset;
 
-	offset = end;
+		change_prot_none(vma, offset, end);
 
-	if (length > 0) {
-		vma = vma->vm_next;
-		goto again;
+		offset = end;
 	}
 	mm->numa_scan_offset = offset;
 	up_read(&mm->mmap_sem);

