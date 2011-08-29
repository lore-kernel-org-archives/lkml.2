Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1H2OGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:06:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53826 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1H2OG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:06:28 -0400
Date: Mon, 29 Aug 2011 16:06:21 +0200
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@redhat.com>,
        Paul Menage <paul@paulmenage.org>
Cc: containers@lists.linux-foundation.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH pm-freezer 4/4] freezer: use lock_task_sighand() in
 fake_signal_wake_up()
Message-ID: <20110829140621.GE18871@mtj.dyndns.org>
References: <20110829140418.GB18871@mtj.dyndns.org>
 <20110829140509.GC18871@mtj.dyndns.org>
 <20110829140549.GD18871@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829140549.GD18871@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: work/kernel/freezer.c
===================================================================
--- work.orig/kernel/freezer.c
+++ work/kernel/freezer.c
@@ -103,9 +103,10 @@ static void fake_signal_wake_up(struct t
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
