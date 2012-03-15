Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161139Ab2CORAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:00:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34222 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161096Ab2CORAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:00:45 -0400
From: John Kacur <jkacur@redhat.com>
To: rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH-rt] Revert "kprobes: adjust "fix a memory leak in function pre_handler_kretprobe()""
Date: Thu, 15 Mar 2012 18:00:38 +0100
Message-Id: <1331830838-28945-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit b8a0040ef7112439ad2efac6f1a79aa842b5924f.

Because rt pulls in 7b8d0e5, the above fix which comes from v3.0.24
should not be applied. kretprobe is a raw_spinlock_t for real-time.

Before the revert we get the following compile errors

kernel/kprobes.c:1664: warning: passing argument 1 of ‘rt_spin_lock’ from incompatible pointer type
kernel/kprobes.c:1666: warning: passing argument 1 of ‘rt_spin_unlock’ from incompatible pointer type

Note: This patch is for v3.0.24-rt42-rc1

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/kprobes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index a7dcf06..9cdbf26 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1661,9 +1661,9 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 		ri->task = current;
 
 		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
-			spin_lock_irqsave(&rp->lock, flags);
+			raw_spin_lock_irqsave(&rp->lock, flags);
 			hlist_add_head(&ri->hlist, &rp->free_instances);
-			spin_unlock_irqrestore(&rp->lock, flags);
+			raw_spin_unlock_irqrestore(&rp->lock, flags);
 			return 0;
 		}
 
-- 
1.7.2.3

