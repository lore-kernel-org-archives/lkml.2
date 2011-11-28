Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1K1OUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:20:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53514 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab1K1OUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:20:42 -0500
Date: Mon, 28 Nov 2011 06:20:25 -0800
From: tip-bot for Stephen Boyd <sboyd@codeaurora.org>
Message-ID: <tip-fb16b8cf0b66386134b09e7b8b7056450272d159@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sboyd@codeaurora.org, john.stultz@linaro.org,
        akpm@linux-foundation.org, cschan@codeaurora.org, tglx@linutronix.de
Reply-To: john.stultz@linaro.org, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        cschan@codeaurora.org, tglx@linutronix.de, sboyd@codeaurora.org
In-Reply-To: <1320724108-20788-2-git-send-email-sboyd@codeaurora.org>
References: <1320724108-20788-2-git-send-email-sboyd@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/debugobjects] timer: Setup uninitialized timer with a stub callback
Git-Commit-ID: fb16b8cf0b66386134b09e7b8b7056450272d159
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 28 Nov 2011 06:20:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb16b8cf0b66386134b09e7b8b7056450272d159
Gitweb:     http://git.kernel.org/tip/fb16b8cf0b66386134b09e7b8b7056450272d159
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Mon, 7 Nov 2011 19:48:26 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 23 Nov 2011 18:49:23 +0100

timer: Setup uninitialized timer with a stub callback

Remove the WARN_ON() in timer_fixup_activate() as we now get the
debugobjects printout in the debugobjects activate check.

We also assign a dummy timer callback so that if the timer is
actually set to fire we don't oops.

[ tglx@linutronix.de: Split out the debugobjects vs. the timer change ]

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Christine Chan <cschan@codeaurora.org>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1320724108-20788-2-git-send-email-sboyd@codeaurora.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

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
 
