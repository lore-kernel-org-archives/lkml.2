Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab1JaWfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:35:09 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33561 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934573Ab1JaWfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:35:04 -0400
Date: Mon, 31 Oct 2011 15:34:59 -0700
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com
Subject: [PATCH 18/17] freezer: restructure __refrigerator()
Message-ID: <20111031223459.GD18855@google.com>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If another freeze happens before all tasks leave FROZEN state after
being thawed, the freezer can see the existing FROZEN and consider the
tasks to be frozen but they can clear FROZEN without checking the new
freezing().

Oleg suggested restructuring __refrigerator() such that there's single
condition check section inside freezer_lock and sigpending is cleared
afterwards, which fixes the problem and simplifies the code.
Restructure accordingly.

-v2: Frozen loop exited without releasing freezer_lock.  Fixed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/freezer.c |   32 +++++++++++---------------------
 1 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index a95250c..10f9840 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -52,39 +52,29 @@ bool __refrigerator(bool check_kthr_stop)
 	/* Hmm, should we be allowed to suspend when there are realtime
 	   processes around? */
 	bool was_frozen = false;
-	long save;
+	long save = current->state;
 
-	/*
-	 * No point in checking freezing() again - the caller already did.
-	 * Proceed to enter FROZEN.
-	 */
-	spin_lock_irq(&freezer_lock);
-repeat:
-	current->flags |= PF_FROZEN;
-	spin_unlock_irq(&freezer_lock);
-
-	save = current->state;
 	pr_debug("%s entered refrigerator\n", current->comm);
 
-	spin_lock_irq(&current->sighand->siglock);
-	recalc_sigpending(); /* We sent fake signal, clean it up */
-	spin_unlock_irq(&current->sighand->siglock);
-
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
+
+		spin_lock_irq(&freezer_lock);
+		current->flags |= PF_FROZEN;
 		if (!freezing(current) ||
 		    (check_kthr_stop && kthread_should_stop()))
+			current->flags &= ~PF_FROZEN;
+		spin_unlock_irq(&freezer_lock);
+
+		if (!(current->flags & PF_FROZEN))
 			break;
 		was_frozen = true;
 		schedule();
 	}
 
-	/* leave FROZEN */
-	spin_lock_irq(&freezer_lock);
-	if (freezing(current))
-		goto repeat;
-	current->flags &= ~PF_FROZEN;
-	spin_unlock_irq(&freezer_lock);
+	spin_lock_irq(&current->sighand->siglock);
+	recalc_sigpending(); /* We sent fake signal, clean it up */
+	spin_unlock_irq(&current->sighand->siglock);
 
 	pr_debug("%s left refrigerator\n", current->comm);
 
-- 
1.7.3.1

