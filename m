Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab2IPRu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 13:50:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab2IPRu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 13:50:56 -0400
Date: Sun, 16 Sep 2012 19:52:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] uprobes: Change valid_vma() to demand VM_MAYEXEC
	rather than VM_EXEC
Message-ID: <20120916175246.GA32370@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120916175210.GA32337@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe_register() or uprobe_mmap() requires VM_READ | VM_EXEC, this
is not right. An apllication can do mprotect(PROT_EXEC) later and
execute this code.

Change valid_vma(is_register => true) to check VM_MAYEXEC instead.
No need to check VM_MAYREAD, it is always set.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index fa1579a..b9b50dd 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -106,8 +106,8 @@ static bool valid_vma(struct vm_area_struct *vma, bool is_register)
 	if (!is_register)
 		return true;
 
-	if ((vma->vm_flags & (VM_HUGETLB|VM_READ|VM_WRITE|VM_EXEC|VM_SHARED))
-				== (VM_READ|VM_EXEC))
+	if ((vma->vm_flags & (VM_HUGETLB | VM_WRITE | VM_MAYEXEC | VM_SHARED))
+				== VM_MAYEXEC)
 		return true;
 
 	return false;
-- 
1.5.5.1

