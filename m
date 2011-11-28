Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1K1OTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:19:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53480 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab1K1OTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:19:33 -0500
Date: Mon, 28 Nov 2011 06:18:54 -0800
From: tip-bot for Stephen Boyd <sboyd@codeaurora.org>
Message-ID: <tip-feac18dda25134005909e7770c77464e65608bd8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sboyd@codeaurora.org, john.stultz@linaro.org,
        akpm@linux-foundation.org, cschan@codeaurora.org, tglx@linutronix.de
Reply-To: john.stultz@linaro.org, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        cschan@codeaurora.org, tglx@linutronix.de, sboyd@codeaurora.org
In-Reply-To: <1320724108-20788-2-git-send-email-sboyd@codeaurora.org>
References: <1320724108-20788-2-git-send-email-sboyd@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/debugobjects] debugobjects: Be smarter about static objects
Git-Commit-ID: feac18dda25134005909e7770c77464e65608bd8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 28 Nov 2011 06:19:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  feac18dda25134005909e7770c77464e65608bd8
Gitweb:     http://git.kernel.org/tip/feac18dda25134005909e7770c77464e65608bd8
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Mon, 7 Nov 2011 19:48:26 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 23 Nov 2011 18:49:22 +0100

debugobjects: Be smarter about static objects

Make debugobjects use the return code from the fixup function. That
allows us better diagnostics in the activate check than relying on a
WARN_ON() in the object specific code.

[ tglx@linutronix.de: Split out the debugobjects vs. the timer change ]

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Christine Chan <cschan@codeaurora.org>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1320724108-20788-2-git-send-email-sboyd@codeaurora.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 lib/debugobjects.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index a78b7c6..b7a5305 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -268,12 +268,16 @@ static void debug_print_object(struct debug_obj *obj, char *msg)
  * Try to repair the damage, so we have a better chance to get useful
  * debug output.
  */
-static void
+static int
 debug_object_fixup(int (*fixup)(void *addr, enum debug_obj_state state),
 		   void * addr, enum debug_obj_state state)
 {
+	int fixed = 0;
+
 	if (fixup)
-		debug_objects_fixups += fixup(addr, state);
+		fixed = fixup(addr, state);
+	debug_objects_fixups += fixed;
+	return fixed;
 }
 
 static void debug_object_is_on_stack(void *addr, int onstack)
@@ -386,6 +390,9 @@ void debug_object_activate(void *addr, struct debug_obj_descr *descr)
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
+	struct debug_obj o = { .object = addr,
+			       .state = ODEBUG_STATE_NOTAVAILABLE,
+			       .descr = descr };
 
 	if (!debug_objects_enabled)
 		return;
@@ -425,8 +432,9 @@ void debug_object_activate(void *addr, struct debug_obj_descr *descr)
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
