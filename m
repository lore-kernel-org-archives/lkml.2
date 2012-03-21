Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145Ab2CUUNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 16:13:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9793 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093Ab2CUUNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:13:11 -0400
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=WDqTJvPei78A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=D6_8q99FMep-hr_qlsUA:9 a=DA6IXVnOCVby-kSkeoMA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120321201310.193721209@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 21 Mar 2012 16:12:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 1/2] Revert "kprobes: adjust "fix a memory leak in function
 pre_handler_kretprobe()""
References: <20120321201227.979421546@goodmis.org>
Content-Disposition: inline; filename=0001-Revert-kprobes-adjust-fix-a-memory-leak-in-function-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This reverts commit b8a0040ef7112439ad2efac6f1a79aa842b5924f.

As pointed out by John Kacur, the patch breaks 3.0-rt.

Because rt pulls in 7b8d0e5, the above fix which comes from v3.0.24
should not be applied. kretprobe is a raw_spinlock_t for real-time.

Before the revert we get the following compile errors

kernel/kprobes.c:1664: warning: passing argument 1 of 'rt_spin_lock' from incompatible pointer type
kernel/kprobes.c:1666: warning: passing argument 1 of 'rt_spin_unlock' from incompatible pointer type

Signed-off-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
1.7.8.3


