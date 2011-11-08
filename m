Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1KHDs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 22:48:58 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32076 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab1KHDsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 22:48:54 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6523"; a="135611802"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christine Chan <cschan@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv2 1/3] debugobjects: Be smarter about static objects
Date: Mon,  7 Nov 2011 19:48:26 -0800
Message-Id: <1320724108-20788-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0.46.g5ae0f
In-Reply-To: <1320724108-20788-1-git-send-email-sboyd@codeaurora.org>
References: <1320724108-20788-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the WARN_ON() in timer_fixup_activate() and actually use
the return code from fixup to tell the debugobjects code to print
a warning. This provides better diagnostic information via a nice
debugobjects warning instead of a simple WARN_ON(1) in the timer
code with no information as to what is wrong. We also assign a
dummy timer callback so that if the timer is actually set to
fire we don't oops.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Christine Chan <cschan@codeaurora.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c     |    9 ++++++++-
 lib/debugobjects.c |   15 +++++++++++----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index dbaa624..317087d 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -427,6 +427,12 @@ static int timer_fixup_init(void *addr, enum debug_obj_state state)
 	}
 }
 
+/* Stub timer callback for improperly used timers. */
+static void stub_timer(unsigned long data)
+{
+	WARN_ON(1);
+}
+
 /*
  * fixup_activate is called when:
  * - an active object is activated
@@ -450,7 +456,8 @@ static int timer_fixup_activate(void *addr, enum debug_obj_state state)
 			debug_object_activate(timer, &timer_debug_descr);
 			return 0;
 		} else {
-			WARN_ON_ONCE(1);
+			setup_timer(timer, stub_timer, 0);
+			return 1;
 		}
 		return 0;
 
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index a78b7c6..0b07cc5 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -268,12 +268,15 @@ static void debug_print_object(struct debug_obj *obj, char *msg)
  * Try to repair the damage, so we have a better chance to get useful
  * debug output.
  */
-static void
+static int
 debug_object_fixup(int (*fixup)(void *addr, enum debug_obj_state state),
 		   void * addr, enum debug_obj_state state)
 {
+	int fixed = 0;
 	if (fixup)
-		debug_objects_fixups += fixup(addr, state);
+		fixed = fixup(addr, state);
+	debug_objects_fixups += fixed;
+	return fixed;
 }
 
 static void debug_object_is_on_stack(void *addr, int onstack)
@@ -386,6 +389,9 @@ void debug_object_activate(void *addr, struct debug_obj_descr *descr)
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
+	struct debug_obj o = { .object = addr,
+			       .state = ODEBUG_STATE_NOTAVAILABLE,
+			       .descr = descr };
 
 	if (!debug_objects_enabled)
 		return;
@@ -425,8 +431,9 @@ void debug_object_activate(void *addr, struct debug_obj_descr *descr)
 	 * let the type specific code decide whether this is
 	 * true or not.
 	 */
-	debug_object_fixup(descr->fixup_activate, addr,
-			   ODEBUG_STATE_NOTAVAILABLE);
+	if (debug_object_fixup(descr->fixup_activate, addr,
+			   ODEBUG_STATE_NOTAVAILABLE))
+		debug_print_object(&o, "activate");
 }
 
 /**
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

