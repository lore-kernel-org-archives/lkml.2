Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872Ab1LPO6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:58:03 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:35221 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759731Ab1LPO5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:57:52 -0500
Subject: [PATCH] lockdep: do not disable on OOT taint
From: Johannes Berg <johannes@sipsolutions.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Dec 2011 15:57:49 +0100
Message-ID: <1324047469.3429.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

There's no reason to disable lockdep due to
out-of-tree taint since you can just ignore
lockdep reports with OOT taint if you like
but for people who develop out of tree it's
still useful to have lockdep available.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 kernel/panic.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/kernel/panic.c	2011-12-16 15:20:38.000000000 +0100
+++ b/kernel/panic.c	2011-12-16 15:51:37.000000000 +0100
@@ -240,8 +240,16 @@ void add_taint(unsigned flag)
 	 * Also we want to keep up lockdep for staging development and
 	 * post-warning case.
 	 */
-	if (flag != TAINT_CRAP && flag != TAINT_WARN && __debug_locks_off())
-		printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
+	switch (flag) {
+	case TAINT_CRAP:
+	case TAINT_WARN:
+	case TAINT_OOT_MODULE:
+		break;
+	default:
+		if (__debug_locks_off())
+			printk(KERN_WARNING
+			       "Disabling lock debugging due to kernel taint\n");
+	}
 
 	set_bit(flag, &tainted_mask);
 }


