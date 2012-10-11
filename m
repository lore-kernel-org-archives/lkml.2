Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab2JKOyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:54:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59528 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab2JKOyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:54:14 -0400
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhart@linux.intel.com>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: [PATCH] Take over futex of dead task only if FUTEX_WAITERS is not set
Date: Thu, 11 Oct 2012 20:22:25 +0530
Message-Id: <1349967145-7462-1-git-send-email-siddhesh.poyarekar@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In futex_lock_pi_atomic, we consider that if the value in the futex
variable is 0 with additional flags, then it is safe for takeover
since the owner of the futex is dead.  However, when FUTEX_WAITERS is
set in the futex value, handle_futex_death calls futex_wake to wake up
one task. Hence the assumption in futex_lock_pi_atomic is not correct.
The correct assumption is that a futex may be considered safe for a
takeover if The FUTEX_OWNER_DIED bit is set, the TID bits are 0 and
the FUTEX_WAITERS bit is not set.

The race described above can be seen in the reproducer in the
following glibc bug report:

http://sourceware.org/bugzilla/show_bug.cgi?id=14076

Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
---
 kernel/futex.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 3717e7b..9aa2d5a 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -760,9 +760,14 @@ retry:
 	 * case. We also do an unconditional take over, when the owner
 	 * of the futex died.
 	 *
+	 * We do not take over the futex if FUTEX_WAITERS is set because we
+	 * could end up waking two tasks, the current one and the one that the
+	 * futex death event wakes in handle_futex_death.
+	 *
 	 * This is safe as we are protected by the hash bucket lock !
 	 */
-	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
+	if (unlikely(ownerdied ||
+			!(curval & (FUTEX_TID_MASK | FUTEX_WAITERS)))) {
 		/* Keep the OWNER_DIED bit */
 		newval = (curval & ~FUTEX_TID_MASK) | vpid;
 		ownerdied = 0;
-- 
1.7.7.6

