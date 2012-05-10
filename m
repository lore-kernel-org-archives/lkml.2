Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373Ab2EJVQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:16:18 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:45130 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758221Ab2EJVQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:16:16 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh84d07hz2fh2a8h668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.194.231;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail04v.am.sony.com;RD:mail04.sonyusa.com;EFVD:NLI
Message-ID: <4FAC302F.2090004@am.sony.com>
Date: Thu, 10 May 2012 14:16:31 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Brian Swetland <swetland@google.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] staging: android: logger: Allocate logs dynamically at
 boot (v2)
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

Change from a fixed set of static log structures, to allocation
at init time into a list.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 drivers/staging/android/logger.c |  107 ++++++++++++++++++++++----------------
 1 file changed, 62 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index ea69b6a..9ebcf42 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -25,6 +25,7 @@
 #include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/time.h>
+#include <linux/vmalloc.h>
 #include "logger.h"

 #include <asm/ioctls.h>
@@ -45,8 +46,12 @@ struct logger_log {
 	size_t			w_off;	/* current write head offset */
 	size_t			head;	/* new readers start here */
 	size_t			size;	/* size of the log */
+	struct list_head	logs;	/* list of log channels (myself)*/
 };

+static LIST_HEAD(log_list);
+
+
 /*
  * struct logger_reader - a logging device open for reading
  *
@@ -408,7 +413,15 @@ ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	return ret;
 }

-static struct logger_log *get_log_from_minor(int);
+static struct logger_log *get_log_from_minor(int minor)
+{
+	struct logger_log *log;
+
+	list_for_each_entry(log, &log_list, logs)
+		if (log->misc.minor == minor)
+			return log;
+	return NULL;
+}

 /*
  * logger_open - the log's open() file operation
@@ -565,80 +578,84 @@ static const struct file_operations logger_fops = {
 };

 /*
- * Defines a log structure with name 'NAME' and a size of 'SIZE' bytes, which
- * must be a power of two, greater than LOGGER_ENTRY_MAX_LEN, and less than
- * LONG_MAX minus LOGGER_ENTRY_MAX_LEN.
+ * Log size must be a power of two, greater than LOGGER_ENTRY_MAX_LEN,
+ * and less than LONG_MAX minus LOGGER_ENTRY_MAX_LEN.
  */
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
+static int __init create_log(char *log_name, int size)
+{
+	int ret = 0;
+	struct logger_log *log;
+	unsigned char *buffer;

-DEFINE_LOGGER_DEVICE(log_main, LOGGER_LOG_MAIN, 256*1024)
-DEFINE_LOGGER_DEVICE(log_events, LOGGER_LOG_EVENTS, 256*1024)
-DEFINE_LOGGER_DEVICE(log_radio, LOGGER_LOG_RADIO, 256*1024)
-DEFINE_LOGGER_DEVICE(log_system, LOGGER_LOG_SYSTEM, 256*1024)
+	buffer = vmalloc(size);
+	if (buffer == NULL)
+		return -1;

-static struct logger_log *get_log_from_minor(int minor)
-{
-	if (log_main.misc.minor == minor)
-		return &log_main;
-	if (log_events.misc.minor == minor)
-		return &log_events;
-	if (log_radio.misc.minor == minor)
-		return &log_radio;
-	if (log_system.misc.minor == minor)
-		return &log_system;
-	return NULL;
-}
+	log = kzalloc(sizeof(struct logger_log), GFP_KERNEL);
+	if (log == NULL) {
+		ret = -1;
+		goto out_free_buffer;
+	}
+	log->buffer = buffer;

-static int __init init_log(struct logger_log *log)
-{
-	int ret;
+	log->misc.minor = MISC_DYNAMIC_MINOR;
+	log->misc.name = kstrdup(log_name, GFP_KERNEL);
+	if (log->misc.name == NULL) {
+		ret = -1;
+		goto out_free_log;
+	}
+
+	log->misc.fops = &logger_fops;
+	log->misc.parent = NULL;

+	init_waitqueue_head(&log->wq);
+	INIT_LIST_HEAD(&log->readers);
+	mutex_init(&log->mutex);
+	log->w_off = 0;
+	log->head = 0;
+	log->size = size;
+
+	INIT_LIST_HEAD(&log->logs);
+	list_add_tail(&log->logs, &log_list);
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


