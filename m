Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab0HVOUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 10:20:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51409 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab0HVOTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 10:19:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IijX0Qi4VM6b1QZ0nTG77ejIVFWFuXb/sG2/F+yFOPLQCLFy8rlIB0IG8quAsW46lQ
         +qJh0WYC6hKf8IjHX90ZOb/69ZtIn+mAFbBKpDmPZNg2Uy/pt2+JZtxzyGt/3uKb046O
         tJsxToEpa9xw6PTUXMJDecBpU2nUXjRz/0m+s=
From: Namhyung Kim <namhyung@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] workqueue: mark lock acquisition on worker_maybe_bind_and_lock()
Date: Sun, 22 Aug 2010 23:19:43 +0900
Message-Id: <1282486783-4573-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

worker_maybe_bind_and_lock() actually grabs gcwq->lock but was missing proper
annotation. Add it. So this patch will remove following sparse warnings:

 kernel/workqueue.c:1214:13: warning: context imbalance in 'worker_maybe_bind_and_lock' - wrong count at exit
 arch/x86/include/asm/irqflags.h:44:9: warning: context imbalance in 'worker_rebind_fn' - unexpected unlock
 kernel/workqueue.c:1991:17: warning: context imbalance in 'rescuer_thread' - unexpected unlock

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/workqueue.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index be0b71d..1145c50 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1212,6 +1212,7 @@ static void worker_leave_idle(struct worker *worker)
  * bound), %false if offline.
  */
 static bool worker_maybe_bind_and_lock(struct worker *worker)
+__acquires(&gcwq->lock)
 {
 	struct global_cwq *gcwq = worker->gcwq;
 	struct task_struct *task = worker->task;
-- 
1.7.0.4

