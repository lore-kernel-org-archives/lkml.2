Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab1GCOO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 10:14:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52593 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1GCOOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 10:14:54 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
        Jiri Kosina <jkosina@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 1/7] pm: improve error code of pm_notifier_call_chain()
Date: Sun,  3 Jul 2011 23:16:15 +0900
Message-Id: <1309702581-16863-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
References: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables pm_notifier_call_chain() to get the actual error code
in the callback rather than always assume -EINVAL by converting all
PM notifier calls to return encapsulate error code with
notifier_from_errno().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/char/apm-emulation.c   |    2 +-
 drivers/s390/char/vmwatchdog.c |    4 ++--
 drivers/s390/cio/css.c         |    8 ++++----
 kernel/power/main.c            |    5 +++--
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index 548708c..a7346ab 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -606,7 +606,7 @@ static int apm_suspend_notifier(struct notifier_block *nb,
 			return NOTIFY_OK;
 
 		/* interrupted by signal */
-		return NOTIFY_BAD;
+		return notifier_from_errno(err);
 
 	case PM_POST_SUSPEND:
 		/*
diff --git a/drivers/s390/char/vmwatchdog.c b/drivers/s390/char/vmwatchdog.c
index 12ef912..11312f4 100644
--- a/drivers/s390/char/vmwatchdog.c
+++ b/drivers/s390/char/vmwatchdog.c
@@ -258,13 +258,13 @@ static int vmwdt_suspend(void)
 	if (test_and_set_bit(VMWDT_OPEN, &vmwdt_is_open)) {
 		pr_err("The system cannot be suspended while the watchdog"
 			" is in use\n");
-		return NOTIFY_BAD;
+		return notifier_from_errno(-EBUSY);
 	}
 	if (test_bit(VMWDT_RUNNING, &vmwdt_is_open)) {
 		clear_bit(VMWDT_OPEN, &vmwdt_is_open);
 		pr_err("The system cannot be suspended while the watchdog"
 			" is running\n");
-		return NOTIFY_BAD;
+		return notifier_from_errno(-EBUSY);
 	}
 	return NOTIFY_DONE;
 }
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index c47b25f..92d7324 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -814,8 +814,8 @@ static int css_power_event(struct notifier_block *this, unsigned long event,
 				mutex_unlock(&css->mutex);
 				continue;
 			}
-			if (__chsc_do_secm(css, 0))
-				ret = NOTIFY_BAD;
+			ret = __chsc_do_secm(css, 0);
+			ret = notifier_from_errno(ret);
 			mutex_unlock(&css->mutex);
 		}
 		break;
@@ -831,8 +831,8 @@ static int css_power_event(struct notifier_block *this, unsigned long event,
 				mutex_unlock(&css->mutex);
 				continue;
 			}
-			if (__chsc_do_secm(css, 1))
-				ret = NOTIFY_BAD;
+			ret = __chsc_do_secm(css, 1);
+			ret = notifier_from_errno(ret);
 			mutex_unlock(&css->mutex);
 		}
 		/* search for subchannels, which appeared during hibernation */
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 2981af4..6c601f8 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -37,8 +37,9 @@ EXPORT_SYMBOL_GPL(unregister_pm_notifier);
 
 int pm_notifier_call_chain(unsigned long val)
 {
-	return (blocking_notifier_call_chain(&pm_chain_head, val, NULL)
-			== NOTIFY_BAD) ? -EINVAL : 0;
+	int ret = blocking_notifier_call_chain(&pm_chain_head, val, NULL);
+
+	return notifier_to_errno(ret);
 }
 
 /* If set, devices may be suspended and resumed asynchronously. */
-- 
1.7.4.4

