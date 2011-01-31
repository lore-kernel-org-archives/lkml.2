Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab1AaOEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:04:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:46451 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797Ab1AaOEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:04:49 -0500
Date: Mon, 31 Jan 2011 14:04:17 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20110127145900.23248.73352.stgit@localhost>
References: <20110127145900.23248.73352.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time: Move get_jiffies_64 to kernel/time/jiffies.c
Message-ID: <tip-fbad1ea94159a71bc0f68b00e57ae803606af9fb@git.kernel.org>
Git-Commit-ID: fbad1ea94159a71bc0f68b00e57ae803606af9fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:04:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fbad1ea94159a71bc0f68b00e57ae803606af9fb
Gitweb:     http://git.kernel.org/tip/fbad1ea94159a71bc0f68b00e57ae803606af9fb
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 15:59:00 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:42 +0100

time: Move get_jiffies_64 to kernel/time/jiffies.c

Move the jiffies access functions to the jiffies clocksource code.

[ tglx: Add missing include ]

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: yong.zhang0@gmail.com
Cc: hch@infradead.org
LKML-Reference: <20110127145900.23248.73352.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time.c         |   17 -----------------
 kernel/time/jiffies.c |   18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index 3217435..a31b512 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -674,23 +674,6 @@ unsigned long nsecs_to_jiffies(u64 n)
 #endif
 }
 
-#if (BITS_PER_LONG < 64)
-u64 get_jiffies_64(void)
-{
-	unsigned long seq;
-	u64 ret;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		ret = jiffies_64;
-	} while (read_seqretry(&xtime_lock, seq));
-	return ret;
-}
-EXPORT_SYMBOL(get_jiffies_64);
-#endif
-
-EXPORT_SYMBOL(jiffies);
-
 /*
  * Add two timespec values and do a safety check for overflow.
  * It's assumed that both values are valid (>= 0)
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 5404a84..2fbc207 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -22,6 +22,7 @@
 ************************************************************************/
 #include <linux/clocksource.h>
 #include <linux/jiffies.h>
+#include <linux/module.h>
 #include <linux/init.h>
 
 /* The Jiffies based clocksource is the lowest common
@@ -64,6 +65,23 @@ struct clocksource clocksource_jiffies = {
 	.shift		= JIFFIES_SHIFT,
 };
 
+#if (BITS_PER_LONG < 64)
+u64 get_jiffies_64(void)
+{
+	unsigned long seq;
+	u64 ret;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		ret = jiffies_64;
+	} while (read_seqretry(&xtime_lock, seq));
+	return ret;
+}
+EXPORT_SYMBOL(get_jiffies_64);
+#endif
+
+EXPORT_SYMBOL(jiffies);
+
 static int __init init_jiffies_clocksource(void)
 {
 	return clocksource_register(&clocksource_jiffies);
