Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2HBKFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:05:31 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41575 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab2HBKFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:05:30 -0400
Date: Thu, 2 Aug 2012 15:35:15 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] uprobes: Ignore unsupported instructions in uprobe_mmap
Message-ID: <20120802100515.GC5782@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120728163157.GA22719@redhat.com>
 <20120731064730.GB5087@linux.vnet.ibm.com>
 <20120731124805.GA485@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120731124805.GA485@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080210-5112-0000-0000-00000AA7710E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe_mmap()->install_breakpoint() can fail if the probed insn is not
supported (remember, uprobe_register() succeeds if nobody mmaps
inode/offset). Failure in uprobe_mmap() causes mmap_region/do_fork to
fail too.

However failing mmap_region()/do_fork() because of a probe on an
unsupported instruction is wrong.

Hence change uprobe_mmap() to ignore unsupported instructions.

Oleg Nesterov analyzed the root cause of this problem.

While at it, add a missing put_uprobe() in the path where uprobe_mmap()
races with uprobe_unregister().

Reported-by: William Cohen <wcohen@redhat.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org> # v3.5
---
 kernel/events/uprobes.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index c08a22d..c8a8c39 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1051,8 +1051,10 @@ int uprobe_mmap(struct vm_area_struct *vma)
 			if (ret == -EEXIST) {
 				ret = 0;
 
-				if (!is_swbp_at_addr(vma->vm_mm, vaddr))
+				if (!is_swbp_at_addr(vma->vm_mm, vaddr)) {
+					put_uprobe(uprobe);
 					continue;
+				}
 
 				/*
 				 * Unable to insert a breakpoint, but
@@ -1060,6 +1062,15 @@ int uprobe_mmap(struct vm_area_struct *vma)
 				 * probe count.
 				 */
 				atomic_inc(&vma->vm_mm->uprobes_state.count);
+			} else if (ret == -ENOTSUPP) {
+				/*
+				 * A probe at unsupported instruction
+				 * shouldnt cause mmap_region() / do_fork()
+				 * to fail.
+				 */
+				ret = 0;
+				put_uprobe(uprobe);
+				continue;
 			}
 
 			if (!ret)

