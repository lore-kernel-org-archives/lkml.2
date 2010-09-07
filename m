Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab0IGMfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:35:39 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36683 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab0IGMfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:35:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lm6l65K64jmTxKEobWn1uUm+UKb4qEs698rCRkx71Ilsb8Qb4pOFDZi1J4xEAeN9Cy
         qP+bay2Qt+fgr55joVeWbKvetwx04ylgSCweqKUPB/Cudv+jOWXs2ilFiBCdd53uwKNH
         TJ939HAFxuXC4nnqcp6mXk8aveQHEl6G0btPM=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] exit: add lock context annotation on find_new_reaper()
Date: Tue,  7 Sep 2010 21:35:26 +0900
Message-Id: <1283862926-17406-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_new_reaper() releases and regrabs tasklist_lock but was missing
proper annotations. Add it. This remove following sparse warning:

 warning: context imbalance in 'find_new_reaper' - unexpected unlock

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/exit.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 0312022..d31385b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -702,6 +702,8 @@ static void exit_mm(struct task_struct * tsk)
  * space.
  */
 static struct task_struct *find_new_reaper(struct task_struct *father)
+	__releases(&tasklist_lock)
+	__acquires(&tasklist_lock)
 {
 	struct pid_namespace *pid_ns = task_active_pid_ns(father);
 	struct task_struct *thread;
-- 
1.7.2.2

