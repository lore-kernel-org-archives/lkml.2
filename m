Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab1LNE75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 23:59:57 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61639 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab1LNE74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 23:59:56 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6559"; a="146480790"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john.stultz@linaro.org, Ingo Molnar <mingo@elte.hu>,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, cschan@codeaurora.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] debugobjects: Fix selftest for static warnings
Date: Tue, 13 Dec 2011 20:59:53 -0800
Message-Id: <1323838793-28304-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.110.g4cb5d1
In-Reply-To: <alpine.LFD.2.02.1112132127180.3020@ionos>
References: <alpine.LFD.2.02.1112132127180.3020@ionos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugobjects is now printing a warning when a fixup for a
NOTAVAILABLE object is run. This causes the selftest to fail
like:

[    0.000000] ODEBUG: selftest warnings failed 4 != 5

We could just increase the number of warnings that the selftest
is expecting to see because that is actually what has changed.
But, it turns out that fixup_activate() was written with inverted
logic and thus a fixup for a static object returned 1 indicating
the object had been fixed, and 0 otherwise. Fix the logic to be
correct and update the counts to reflect that nothing needed
fixing for a static object.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Reported-By: Thomas Gleixner <tglx@linutronix.de>
---
 lib/debugobjects.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 77cb245..0ab9ae8 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -818,17 +818,9 @@ static int __init fixup_activate(void *addr, enum debug_obj_state state)
 		if (obj->static_init == 1) {
 			debug_object_init(obj, &descr_type_test);
 			debug_object_activate(obj, &descr_type_test);
-			/*
-			 * Real code should return 0 here ! This is
-			 * not a fixup of some bad behaviour. We
-			 * merily call the debug_init function to keep
-			 * track of the object.
-			 */
-			return 1;
-		} else {
-			/* Real code needs to emit a warning here */
+			return 0;
 		}
-		return 0;
+		return 1;
 
 	case ODEBUG_STATE_ACTIVE:
 		debug_object_deactivate(obj, &descr_type_test);
@@ -967,7 +959,7 @@ static void __init debug_objects_selftest(void)
 
 	obj.static_init = 1;
 	debug_object_activate(&obj, &descr_type_test);
-	if (check_results(&obj, ODEBUG_STATE_ACTIVE, ++fixups, warnings))
+	if (check_results(&obj, ODEBUG_STATE_ACTIVE, fixups, warnings))
 		goto out;
 	debug_object_init(&obj, &descr_type_test);
 	if (check_results(&obj, ODEBUG_STATE_INIT, ++fixups, ++warnings))
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

