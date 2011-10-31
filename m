Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934633Ab1JaTIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:08:17 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44251 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934504Ab1JaTF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:05:59 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/17] freezer: test freezable conditions while holding freezer_lock
Date: Mon, 31 Oct 2011 12:05:21 -0700
Message-Id: <1320087928-32307-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try_to_freeze_tasks() and thaw_processes() use freezable() and
frozen() as preliminary tests before initiating operations on a task.
These are done without any synchronization and hinder with
synchronization cleanup without any real performance benefits.

In try_to_freeze_tasks(), open code self test and move PF_NOFREEZE and
frozen() tests inside freezer_lock in freeze_task().

thaw_processes() can simply drop freezable() test as frozen() test in
__thaw_task() is enough.

Note: This used to be a part of larger patch to fix set_freezable()
      race.  Separated out to satisfy ordering among dependent fixes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/freezer.c       |    3 ++-
 kernel/power/process.c |   16 +---------------
 2 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index 05afd68..5c911c0 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -109,7 +109,8 @@ bool freeze_task(struct task_struct *p, bool sig_only)
 
 	spin_lock_irqsave(&freezer_lock, flags);
 
-	if (sig_only && !should_send_signal(p))
+	if ((p->flags & PF_NOFREEZE) ||
+	    (sig_only && !should_send_signal(p)))
 		goto out_unlock;
 
 	if (frozen(p))
diff --git a/kernel/power/process.c b/kernel/power/process.c
index e6e2739..e59676f 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -22,14 +22,6 @@
  */
 #define TIMEOUT	(20 * HZ)
 
-static inline int freezable(struct task_struct * p)
-{
-	if ((p == current) ||
-	    (p->flags & PF_NOFREEZE))
-		return 0;
-	return 1;
-}
-
 static int try_to_freeze_tasks(bool sig_only)
 {
 	struct task_struct *g, *p;
@@ -52,10 +44,7 @@ static int try_to_freeze_tasks(bool sig_only)
 		todo = 0;
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			if (frozen(p) || !freezable(p))
-				continue;
-
-			if (!freeze_task(p, sig_only))
+			if (p == current || !freeze_task(p, sig_only))
 				continue;
 
 			/*
@@ -181,9 +170,6 @@ void thaw_processes(void)
 
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
-		if (!freezable(p))
-			continue;
-
 		if (cgroup_freezing_or_frozen(p))
 			continue;
 
-- 
1.7.3.1

