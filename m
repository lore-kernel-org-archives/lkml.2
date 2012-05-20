Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab2ETVGi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 17:06:38 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44326 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753540Ab2ETVGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 17:06:37 -0400
Message-ID: <1337547996.31503.8.camel@joe2Laptop>
Subject: [PATCH] Staging: android: alarm: Rename pr_alarm to alarm_dbg
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Nasir Abed <nasirabed@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        swetland@google.com, Nasir Abed <nasirabed+kernel@gmail.com>
Date: Sun, 20 May 2012 14:06:36 -0700
In-Reply-To: <1337546284.31503.5.camel@joe2Laptop>
References: <1337507659-14740-1-git-send-email-nasirabed+kernel@gmail.com>
	 <alpine.DEB.2.00.1205201328170.10189@chino.kir.corp.google.com>
	 <1337546284.31503.5.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename a macro to make it explicit it's for debugging.

Use %s: __func__ instead of embedding function names.
Coalesce formats, align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/android/alarm-dev.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index 53ce6ec..32614d6 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -29,16 +29,14 @@
 #define ANDROID_ALARM_PRINT_IO (1U << 1)
 #define ANDROID_ALARM_PRINT_INT (1U << 2)
 
-
 static int debug_mask = ANDROID_ALARM_PRINT_INFO;
 module_param_named(debug_mask, debug_mask, int, S_IRUGO | S_IWUSR | S_IWGRP);
 
-#define pr_alarm(debug_level_mask, args...) \
-	do { \
-		if (debug_mask & ANDROID_ALARM_PRINT_##debug_level_mask) { \
-			pr_info(args); \
-		} \
-	} while (0)
+#define alarm_dbg(debug_level_mask, fmt, ...)				\
+do {									\
+	if (debug_mask & ANDROID_ALARM_PRINT_##debug_level_mask)	\
+		pr_info(fmt, ##__VA_ARGS__);				\
+} while (0)
 
 #define ANDROID_ALARM_WAKEUP_MASK ( \
 	ANDROID_ALARM_RTC_WAKEUP_MASK | \
@@ -138,7 +136,7 @@ static long alarm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	switch (ANDROID_ALARM_BASE_CMD(cmd)) {
 	case ANDROID_ALARM_CLEAR(0):
 		spin_lock_irqsave(&alarm_slock, flags);
-		pr_alarm(IO, "alarm %d clear\n", alarm_type);
+		alarm_dbg(IO, "alarm %d clear\n", alarm_type);
 		devalarm_try_to_cancel(&alarms[alarm_type]);
 		if (alarm_pending) {
 			alarm_pending &= ~alarm_type_mask;
@@ -167,8 +165,9 @@ static long alarm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		}
 from_old_alarm_set:
 		spin_lock_irqsave(&alarm_slock, flags);
-		pr_alarm(IO, "alarm %d set %ld.%09ld\n", alarm_type,
-			new_alarm_time.tv_sec, new_alarm_time.tv_nsec);
+		alarm_dbg(IO, "alarm %d set %ld.%09ld\n",
+			  alarm_type,
+			  new_alarm_time.tv_sec, new_alarm_time.tv_nsec);
 		alarm_enabled |= alarm_type_mask;
 		devalarm_start(&alarms[alarm_type],
 			timespec_to_ktime(new_alarm_time));
@@ -179,7 +178,7 @@ from_old_alarm_set:
 		/* fall though */
 	case ANDROID_ALARM_WAIT:
 		spin_lock_irqsave(&alarm_slock, flags);
-		pr_alarm(IO, "alarm wait\n");
+		alarm_dbg(IO, "alarm wait\n");
 		if (!alarm_pending && wait_pending) {
 			__pm_relax(&alarm_wake_lock);
 			wait_pending = 0;
@@ -260,9 +259,10 @@ static int alarm_release(struct inode *inode, struct file *file)
 		for (i = 0; i < ANDROID_ALARM_TYPE_COUNT; i++) {
 			uint32_t alarm_type_mask = 1U << i;
 			if (alarm_enabled & alarm_type_mask) {
-				pr_alarm(INFO, "alarm_release: clear alarm, "
-					"pending %d\n",
-					!!(alarm_pending & alarm_type_mask));
+				alarm_dbg(INFO,
+					  "%s: clear alarm, pending %d\n",
+					  __func__,
+					  !!(alarm_pending & alarm_type_mask));
 				alarm_enabled &= ~alarm_type_mask;
 			}
 			spin_unlock_irqrestore(&alarm_slock, flags);
@@ -271,8 +271,8 @@ static int alarm_release(struct inode *inode, struct file *file)
 		}
 		if (alarm_pending | wait_pending) {
 			if (alarm_pending)
-				pr_alarm(INFO, "alarm_release: clear "
-					"pending alarms %x\n", alarm_pending);
+				alarm_dbg(INFO, "%s: clear pending alarms %x\n",
+					  __func__, alarm_pending);
 			__pm_relax(&alarm_wake_lock);
 			wait_pending = 0;
 			alarm_pending = 0;
@@ -288,7 +288,7 @@ static void devalarm_triggered(struct devalarm *alarm)
 	unsigned long flags;
 	uint32_t alarm_type_mask = 1U << alarm->type;
 
-	pr_alarm(INT, "devalarm_triggered type %d\n", alarm->type);
+	alarm_dbg(INT, "%s: type %d\n", __func__, alarm->type);
 	spin_lock_irqsave(&alarm_slock, flags);
 	if (alarm_enabled & alarm_type_mask) {
 		__pm_wakeup_event(&alarm_wake_lock, 5000); /* 5secs */


