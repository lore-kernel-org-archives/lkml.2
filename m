Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab1DYHbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 03:31:01 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57480 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab1DYHa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 03:30:59 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [PATCH] freezer: use smp barriers
Date: Mon, 25 Apr 2011 03:31:05 -0400
Message-Id: <1303716665-27584-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The freezer processes are dealing with multiple threads running
simultaneously, and on a UP system, the memory reads/writes do
not need barriers to keep things in sync.  These are only needed
on SMP systems, so use SMP barriers instead.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 kernel/freezer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index 66ecd2e..7b01de9 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -17,7 +17,7 @@ static inline void frozen_process(void)
 {
 	if (!unlikely(current->flags & PF_NOFREEZE)) {
 		current->flags |= PF_FROZEN;
-		wmb();
+		smp_wmb();
 	}
 	clear_freeze_flag(current);
 }
@@ -93,7 +93,7 @@ bool freeze_task(struct task_struct *p, bool sig_only)
 	 * the task as frozen and next clears its TIF_FREEZE.
 	 */
 	if (!freezing(p)) {
-		rmb();
+		smp_rmb();
 		if (frozen(p))
 			return false;
 
-- 
1.7.5.rc1

