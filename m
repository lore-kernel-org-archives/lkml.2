Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934668Ab1JaWfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:35:36 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64840 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934573Ab1JaWfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:35:32 -0400
Date: Mon, 31 Oct 2011 15:35:26 -0700
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com
Subject: [PATCH 19/17] freezer: use lock_task_sighand() in
 fake_signal_wake_up()
Message-ID: <20111031223526.GE18855@google.com>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_freezer calls freeze_task() without holding tasklist_lock and,
if the task is exiting, its ->sighand may be gone by the time
fake_signal_wake_up() is called.  Use lock_task_sighand() instead of
accessing ->sighand directly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Paul Menage <paul@paulmenage.org>
---
 kernel/freezer.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index 10f9840..a9c18c7 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -93,9 +93,10 @@ static void fake_signal_wake_up(struct task_struct *p)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&p->sighand->siglock, flags);
-	signal_wake_up(p, 1);
-	spin_unlock_irqrestore(&p->sighand->siglock, flags);
+	if (lock_task_sighand(p, &flags)) {
+		signal_wake_up(p, 1);
+		unlock_task_sighand(p, &flags);
+	}
 }
 
 /**
-- 
1.7.3.1

