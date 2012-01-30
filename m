Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab2A3QNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:13:35 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55091 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab2A3QNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:13:33 -0500
From: Jiang Liu <liuj97@gmail.com>
To: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: [PATCH] kprobes: fix a memory leak in function pre_handler_kretprobe()
Date: Tue, 31 Jan 2012 00:10:12 +0800
Message-Id: <1327939812-17157-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function pre_handler_kretprobe(), the allocated kretprobe_instance object
will get leaked if the entry_handler callback returns non-zero. This may cause
all the preallocated kretprobe_instance objects exhausted. This issue could be
reproduced by changing samples/kprobes/kretprobe_example.c to probe
"mutex_unlock". And the fix is straight forward, just put the allocated
kretprobe_instance object back onto the free_instances list.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Jim Keniston <jkenisto@us.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: stable@vger.kernel.org
---
 kernel/kprobes.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index e5d8464..2423295 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1673,8 +1673,12 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 		ri->rp = rp;
 		ri->task = current;
 
-		if (rp->entry_handler && rp->entry_handler(ri, regs))
+		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
+			spin_lock_irqsave(&rp->lock, flags);
+			hlist_add_head(&ri->hlist, &rp->free_instances);
+			spin_unlock_irqrestore(&rp->lock, flags);
 			return 0;
+		}
 
 		arch_prepare_kretprobe(ri, regs);
 
-- 
1.7.5.4

