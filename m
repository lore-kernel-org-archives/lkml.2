Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab1IBS2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 14:28:20 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48944 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab1IBS2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 14:28:16 -0400
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, matthltc@us.ibm.com, rjw@sisk.pl, paul@paulmenage.org
Cc: containers@lists.linux-foundation.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] freezer: use lock_task_sighand() in fake_signal_wake_up()
Date: Sat,  3 Sep 2011 03:27:48 +0900
Message-Id: <1314988070-12244-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314988070-12244-1-git-send-email-tj@kernel.org>
References: <1314988070-12244-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_freezer calls freeze_task() without holding tasklist_lock and,
if the task is exiting, its ->sighand may be gone by the time
fake_signal_wake_up() is called.  Use lock_task_sighand() instead of
accessing ->sighand directly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Paul Menage <paul@paulmenage.org>
---
 kernel/freezer.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index ebee1ab..9846133 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -93,9 +93,10 @@ static void fake_signal_wake_up(struct task_struct *p)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&p->sighand->siglock, flags);
-	signal_wake_up(p, 0);
-	spin_unlock_irqrestore(&p->sighand->siglock, flags);
+	if (lock_task_sighand(p, &flags)) {
+		signal_wake_up(p, 0);
+		unlock_task_sighand(p, &flags);
+	}
 }
 
 /**
-- 
1.7.6

