Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab2DUAYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:24:04 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:52573 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab2DUAYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:24:01 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH] [RFC] android-alarm: Switch from wakelocks to wakeup sources
Date: Fri, 20 Apr 2012 17:23:50 -0700
Message-Id: <1334967830-26624-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042100-7408-0000-0000-0000046320EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In their current AOSP tree, the Android in-kernel wakelock
infrastructure has been reimplemented in terms of wakeup
sources:
http://git.linaro.org/gitweb?p=people/jstultz/android.git;a=commitdiff;h=e9911f4efdc55af703b8b3bb8c839e6f5dd173bb

The Android alarm driver currently has stubbed out calls
to wakelock functionality. So this patch simply converts
the stubbed out wakelock calls to wakeup source calls, and
removes the empty wakelock macros

This is something I'd like to propose for staging, but wanted
to get some input from Arve, Colin or other member of the
Android team first.

Thoughts or objections?

CC: Colin Cross <ccross@android.com>
CC: Arve Hjønnevåg <arve@android.com>
CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/alarm-dev.c |   26 +++++++-------------------
 1 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index 04075b3..53ce6ec 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -25,17 +25,6 @@
 #include <linux/alarmtimer.h>
 #include "android_alarm.h"
 
-/* XXX - Hack out wakelocks, while they are out of tree */
-struct wake_lock {
-	int i;
-};
-#define wake_lock(x)
-#define wake_lock_timeout(x, y)
-#define wake_unlock(x)
-#define WAKE_LOCK_SUSPEND 0
-#define wake_lock_init(x, y, z) ((x)->i = 1)
-#define wake_lock_destroy(x)
-
 #define ANDROID_ALARM_PRINT_INFO (1U << 0)
 #define ANDROID_ALARM_PRINT_IO (1U << 1)
 #define ANDROID_ALARM_PRINT_INT (1U << 2)
@@ -61,7 +50,7 @@ module_param_named(debug_mask, debug_mask, int, S_IRUGO | S_IWUSR | S_IWGRP);
 
 static int alarm_opened;
 static DEFINE_SPINLOCK(alarm_slock);
-static struct wake_lock alarm_wake_lock;
+static struct wakeup_source alarm_wake_lock;
 static DECLARE_WAIT_QUEUE_HEAD(alarm_wait_queue);
 static uint32_t alarm_pending;
 static uint32_t alarm_enabled;
@@ -154,7 +143,7 @@ static long alarm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (alarm_pending) {
 			alarm_pending &= ~alarm_type_mask;
 			if (!alarm_pending && !wait_pending)
-				wake_unlock(&alarm_wake_lock);
+				__pm_relax(&alarm_wake_lock);
 		}
 		alarm_enabled &= ~alarm_type_mask;
 		spin_unlock_irqrestore(&alarm_slock, flags);
@@ -192,7 +181,7 @@ from_old_alarm_set:
 		spin_lock_irqsave(&alarm_slock, flags);
 		pr_alarm(IO, "alarm wait\n");
 		if (!alarm_pending && wait_pending) {
-			wake_unlock(&alarm_wake_lock);
+			__pm_relax(&alarm_wake_lock);
 			wait_pending = 0;
 		}
 		spin_unlock_irqrestore(&alarm_slock, flags);
@@ -284,7 +273,7 @@ static int alarm_release(struct inode *inode, struct file *file)
 			if (alarm_pending)
 				pr_alarm(INFO, "alarm_release: clear "
 					"pending alarms %x\n", alarm_pending);
-			wake_unlock(&alarm_wake_lock);
+			__pm_relax(&alarm_wake_lock);
 			wait_pending = 0;
 			alarm_pending = 0;
 		}
@@ -302,7 +291,7 @@ static void devalarm_triggered(struct devalarm *alarm)
 	pr_alarm(INT, "devalarm_triggered type %d\n", alarm->type);
 	spin_lock_irqsave(&alarm_slock, flags);
 	if (alarm_enabled & alarm_type_mask) {
-		wake_lock_timeout(&alarm_wake_lock, 5 * HZ);
+		__pm_wakeup_event(&alarm_wake_lock, 5000); /* 5secs */
 		alarm_enabled &= ~alarm_type_mask;
 		alarm_pending |= alarm_type_mask;
 		wake_up(&alarm_wait_queue);
@@ -368,15 +357,14 @@ static int __init alarm_dev_init(void)
 			alarms[i].u.hrt.function = devalarm_hrthandler;
 	}
 
-	wake_lock_init(&alarm_wake_lock, WAKE_LOCK_SUSPEND, "alarm");
-
+	wakeup_source_init(&alarm_wake_lock, "alarm");
 	return 0;
 }
 
 static void  __exit alarm_dev_exit(void)
 {
 	misc_deregister(&alarm_device);
-	wake_lock_destroy(&alarm_wake_lock);
+	wakeup_source_trash(&alarm_wake_lock);
 }
 
 module_init(alarm_dev_init);
-- 
1.7.3.2.146.gca209

