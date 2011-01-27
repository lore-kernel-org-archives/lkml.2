Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab1A0O7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:59:07 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:46874 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751734Ab1A0O7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:59:04 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+/ZLdCDR6/6N1buaVzX1mWH5cFjWEqjvAb9lEaS1
	hVYciDE+QaS6Xx
Subject: [PATCH v2 02/20] move get_jiffies_64 to kernel/time/jiffies.c
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, johnstul@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>, yong.zhang0@gmail.com,
        hch@infradead.org
Date: Thu, 27 Jan 2011 15:59:00 +0100
Message-ID: <20110127145900.23248.73352.stgit@localhost>
In-Reply-To: <20110127145741.23248.68098.stgit@localhost>
References: <20110127145741.23248.68098.stgit@localhost>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in order to make the xtime_lock local to kernel/time
all users of this lock need to be moved there.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 kernel/time.c         |   17 -----------------
 kernel/time/jiffies.c |   17 +++++++++++++++++
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index 55337a8..9c72ba5 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -693,23 +693,6 @@ unsigned long nsecs_to_jiffies(u64 n)
 	return (unsigned long)nsecs_to_jiffies64(n);
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
index 5404a84..54441c4 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -64,6 +64,23 @@ struct clocksource clocksource_jiffies = {
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

