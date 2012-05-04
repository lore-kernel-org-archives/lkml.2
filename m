Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673Ab2EDXdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 19:33:12 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:58769
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757008Ab2EDXdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 19:33:11 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh84d07hz2fh668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4FA4673C.7010209@am.sony.com>
Date: Fri, 4 May 2012 16:33:16 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Brian Swetland <swetland@google.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: android: logger: Allocate logs dynamically at boot
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the log initialization to be dynamic, but still
at boot time.  These changes are a predecessor to implementing
runtime allocation and freeing of logs, to make the Android logger
less hard-coded.

This makes no ABI changes with user space.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 drivers/staging/android/logger.c |  117 ++++++++++++++++++++++++--------------
 1 file changed, 75 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index ea69b6a..fa5fd71 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -25,6 +25,7 @@
 #include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/time.h>
+#include <linux/vmalloc.h>
 #include "logger.h"

 #include <asm/ioctls.h>
@@ -564,81 +565,113 @@ static const struct file_operations logger_fops = {
 	.release = logger_release,
 };

-/*
- * Defines a log structure with name 'NAME' and a size of 'SIZE' bytes, which
- * must be a power of two, greater than LOGGER_ENTRY_MAX_LEN, and less than
- * LONG_MAX minus LOGGER_ENTRY_MAX_LEN.
- */
-#define DEFINE_LOGGER_DEVICE(VAR, NAME, SIZE) \
-static unsigned char _buf_ ## VAR[SIZE]; \
-static struct logger_log VAR = { \
-	.buffer = _buf_ ## VAR, \
-	.misc = { \
-		.minor = MISC_DYNAMIC_MINOR, \
-		.name = NAME, \
-		.fops = &logger_fops, \
-		.parent = NULL, \
-	}, \
-	.wq = __WAIT_QUEUE_HEAD_INITIALIZER(VAR .wq), \
-	.readers = LIST_HEAD_INIT(VAR .readers), \
-	.mutex = __MUTEX_INITIALIZER(VAR .mutex), \
-	.w_off = 0, \
-	.head = 0, \
-	.size = SIZE, \
-};
-
-DEFINE_LOGGER_DEVICE(log_main, LOGGER_LOG_MAIN, 256*1024)
-DEFINE_LOGGER_DEVICE(log_events, LOGGER_LOG_EVENTS, 256*1024)
-DEFINE_LOGGER_DEVICE(log_radio, LOGGER_LOG_RADIO, 256*1024)
-DEFINE_LOGGER_DEVICE(log_system, LOGGER_LOG_SYSTEM, 256*1024)
+#define MAX_LOGS	5
+struct logger_log *logs_array[MAX_LOGS];

 static struct logger_log *get_log_from_minor(int minor)
 {
-	if (log_main.misc.minor == minor)
-		return &log_main;
-	if (log_events.misc.minor == minor)
-		return &log_events;
-	if (log_radio.misc.minor == minor)
-		return &log_radio;
-	if (log_system.misc.minor == minor)
-		return &log_system;
+	int i;
+
+	for (i = 0; i < MAX_LOGS; i++) {
+		if (logs_array[i]->misc.minor == minor)
+			return logs_array[i];
+	}
 	return NULL;
 }

-static int __init init_log(struct logger_log *log)
+static int __init add_log(struct logger_log *log)
 {
-	int ret;
+	int i;

+	for (i = 0; i < MAX_LOGS; i++) {
+		if (logs_array[i] == 0) {
+			logs_array[i] = log;
+			return 0;
+		}
+	}
+	return -1;
+}
+
+/*
+ * Log size must be a power of two, greater than LOGGER_ENTRY_MAX_LEN,
+ * and less than LONG_MAX minus LOGGER_ENTRY_MAX_LEN.
+ */
+static int __init create_log(char *log_name, int size)
+{
+	int ret = 0;
+	struct logger_log *log;
+	unsigned char *buffer;
+
+	buffer = vmalloc(size);
+	if (buffer == NULL)
+		return -1;
+
+	log = kzalloc(sizeof(struct logger_log), GFP_KERNEL);
+	if (log == NULL) {
+		ret = -1;
+		goto out_free_buffer;
+	}
+	log->buffer = buffer;
+
+	log->misc.minor = MISC_DYNAMIC_MINOR;
+	log->misc.name = kstrdup(log_name, GFP_KERNEL);
+	if (log->misc.name == NULL) {
+		ret = -1;
+		goto out_free_log;
+	}
+
+	log->misc.fops = &logger_fops;
+	log->misc.parent = NULL;
+
+	init_waitqueue_head(&log->wq);
+	INIT_LIST_HEAD(&log->readers);
+	mutex_init(&log->mutex);
+	log->w_off = 0;
+	log->head = 0;
+	log->size = size;
+
+	ret = add_log(log);
+	if (unlikely(ret))
+		goto out_free_log;
+
+	/* finally, initialize the misc device for this log */
 	ret = misc_register(&log->misc);
 	if (unlikely(ret)) {
 		printk(KERN_ERR "logger: failed to register misc "
 		       "device for log '%s'!\n", log->misc.name);
-		return ret;
+		goto out_free_log;
 	}

 	printk(KERN_INFO "logger: created %luK log '%s'\n",
 	       (unsigned long) log->size >> 10, log->misc.name);

 	return 0;
+
+out_free_log:
+	kfree(log);
+
+out_free_buffer:
+	vfree(buffer);
+	return ret;
 }

 static int __init logger_init(void)
 {
 	int ret;

-	ret = init_log(&log_main);
+	ret = create_log(LOGGER_LOG_MAIN, 256*1024);
 	if (unlikely(ret))
 		goto out;

-	ret = init_log(&log_events);
+	ret = create_log(LOGGER_LOG_EVENTS, 256*1024);
 	if (unlikely(ret))
 		goto out;

-	ret = init_log(&log_radio);
+	ret = create_log(LOGGER_LOG_RADIO, 256*1024);
 	if (unlikely(ret))
 		goto out;

-	ret = init_log(&log_system);
+	ret = create_log(LOGGER_LOG_SYSTEM, 256*1024);
 	if (unlikely(ret))
 		goto out;

-- 
1.7.9.5

