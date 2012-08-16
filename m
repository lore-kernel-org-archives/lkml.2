Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab2HPWH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 18:07:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55730 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab2HPWH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 18:07:27 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org
Cc: mathieu.poirier@linaro.org, arve@android.com, kernel-team@android.com,
        dmitry.torokhov@gmail.com, john.stultz@linaro.org
Subject: [PATCH] [RFC]: drivers/tty: Folding Android's keyreset driver in sysRQ
Date: Thu, 16 Aug 2012 16:06:50 -0600
Message-Id: <1345154810-1509-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>

This patch adds keyreset functionality to the sysrq driver. It
allows certain button/key combinations to be used in order to
trigger device resets.

The first time the key-combo is detected a work function that syncs
the filesystems is scheduled and the kernel rebooted. If all the keys
are released and then pressed again, it calls panic. Reboot on panic
should be set for this to work.  A platform device that specify a
reset key-combo should be added to the board file to trigger the
feature.

This functionality comes from the keyreset driver submitted by
Arve Hjønnevåg in the Android kernel.  It is sent out as an initial
draft and comments are welcomed.

In the design most of the original author's code has been added
alongside the sysrq functionality, taking great care not to
remove or constrain functionality people might currently be using.

The keyreset platform data and driver name were kept intact to
minimize disruption on products that already instantiate the
keyreset driver.

Cc: arve@android.com
Cc: kernel-team@android.com
Cc: dmitry.torokhov@gmail.com
Cc: john.stultz@linaro.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/tty/sysrq.c   |  159 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysrq.h |    8 +++
 2 files changed, 167 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 05728894..c2b869d 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -41,6 +41,9 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/uaccess.h>
+#include <linux/platform_device.h>
+#include <linux/syscalls.h>
+#include <linux/atomic.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
@@ -49,6 +52,11 @@
 static int __read_mostly sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
 static bool __read_mostly sysrq_always_enabled;
 
+static struct input_handler sysrq_handler;
+
+/* Keep track of what has been called */
+static atomic_t restart_requested;
+
 static bool sysrq_on(void)
 {
 	return sysrq_enabled || sysrq_always_enabled;
@@ -570,6 +578,15 @@ struct sysrq_state {
 	struct input_handle handle;
 	struct work_struct reinject_work;
 	unsigned long key_down[BITS_TO_LONGS(KEY_CNT)];
+	unsigned long keybit[BITS_TO_LONGS(KEY_CNT)];
+	unsigned long upbit[BITS_TO_LONGS(KEY_CNT)];
+	unsigned long key[BITS_TO_LONGS(KEY_CNT)];
+	int (*reset_fn)(void);
+	int key_down_target;
+	int key_down_ctn;
+	int key_up_ctn;
+	int keyreset_data;
+	int restart_disabled;
 	unsigned int alt;
 	unsigned int alt_use;
 	bool active;
@@ -603,6 +620,92 @@ static void sysrq_reinject_alt_sysrq(struct work_struct *work)
 	}
 }
 
+
+static int sysrq_probe(struct platform_device *pdev)
+{
+	struct keyreset_platform_data *pdata = pdev->dev.platform_data;
+
+	/* No sequence of keys to trigger on,
+	 * assuming default sysRQ behavior.
+	 */
+	if (pdata) {
+		atomic_set(&restart_requested, 0);
+		sysrq_handler.private = pdata;
+	} else
+		sysrq_handler.private = NULL;
+
+	/* FETCH DT INFO HERE */
+
+	return 0;
+
+}
+
+static void deferred_restart(struct work_struct *dummy)
+{
+	atomic_inc(&restart_requested);
+	sys_sync();
+	atomic_inc(&restart_requested);
+	kernel_restart(NULL);
+}
+static DECLARE_WORK(restart_work, deferred_restart);
+
+static int do_keyreset_event(struct sysrq_state *state,
+					 unsigned int code, int value)
+{
+	int ret;
+	int processed = 0;
+
+	/* Is the code is of interestest to us */
+	if (!test_bit(code, state->keybit))
+		return processed;
+
+	/* No need to take care of key up events */
+	if (!test_bit(code, state->key) == !value)
+		return processed;
+
+	/* Record new entry */
+	__change_bit(code, state->key);
+
+	processed = 1;
+
+	if (test_bit(code, state->upbit)) {
+		if (value) {
+			state->restart_disabled = 1;
+			state->key_up_ctn++;
+		} else
+			state->key_up_ctn--;
+	} else {
+		if (value)
+			state->key_down_ctn++;
+		else
+			state->key_down_ctn--;
+	}
+
+	if (state->key_down_ctn == 0 && state->key_up_ctn == 0)
+		state->restart_disabled = 0;
+
+	if (value && !state->restart_disabled &&
+			state->key_down_ctn == state->key_down_target) {
+		state->restart_disabled = 1;
+		if (atomic_read(&restart_requested))
+			panic(KERN_ERR "keyboard reset failed, %d - panic\n",
+					 atomic_read(&restart_requested));
+		if (state->reset_fn) {
+			ret = state->reset_fn();
+			atomic_set(&restart_requested, ret);
+		} else {
+			pr_info("keyboard reset\n");
+			schedule_work(&restart_work);
+			atomic_inc(&restart_requested);
+		}
+	}
+
+	/* no need to suppress keyreset characters */
+	state->active = false;
+
+	return processed;
+}
+
 static bool sysrq_filter(struct input_handle *handle,
 			 unsigned int type, unsigned int code, int value)
 {
@@ -669,6 +772,11 @@ static bool sysrq_filter(struct input_handle *handle,
 			if (sysrq->active && value && value != 2) {
 				sysrq->need_reinject = false;
 				__handle_sysrq(sysrq_xlate[code], true);
+			} else if (sysrq->keyreset_data) {
+				if (do_keyreset_event(sysrq, code, value)) {
+					suppress = sysrq->active;
+					goto end;
+				}
 			}
 			break;
 		}
@@ -704,9 +812,44 @@ static bool sysrq_filter(struct input_handle *handle,
 		break;
 	}
 
+	/*
+	 * suppress == true - suppress passing to other subsystems.
+	 * suppress == false - passing to other subsystems.
+	 */
+end:
 	return suppress;
 }
 
+static void parse_platform_data(struct sysrq_state *sysrq)
+{
+	int key, *keyp;
+	struct keyreset_platform_data *pdata = sysrq_handler.private;
+
+
+	keyp = pdata->keys_down;
+	while ((key = *keyp++)) {
+		if (key >= KEY_MAX)
+			continue;
+		sysrq->key_down_target++;
+		__set_bit(key, sysrq->keybit);
+	}
+
+	if (pdata->keys_up) {
+		keyp = pdata->keys_up;
+		while ((key = *keyp++)) {
+			if (key >= KEY_MAX)
+				continue;
+			__set_bit(key, sysrq->keybit);
+			__set_bit(key, sysrq->upbit);
+		}
+	}
+
+	if (pdata->reset_fn)
+		sysrq->reset_fn = pdata->reset_fn;
+
+	sysrq->keyreset_data = 1;
+}
+
 static int sysrq_connect(struct input_handler *handler,
 			 struct input_dev *dev,
 			 const struct input_device_id *id)
@@ -718,6 +861,13 @@ static int sysrq_connect(struct input_handler *handler,
 	if (!sysrq)
 		return -ENOMEM;
 
+	/* input_register_handle() calls sysrq_probe(), who
+	 * in turn will put the keyreset information in
+	 * sysrq_handler's private field.
+	 */
+	if (handler->private)
+		parse_platform_data(sysrq);
+
 	INIT_WORK(&sysrq->reinject_work, sysrq_reinject_alt_sysrq);
 
 	sysrq->handle.dev = dev;
@@ -780,12 +930,21 @@ static struct input_handler sysrq_handler = {
 	.id_table	= sysrq_ids,
 };
 
+struct platform_driver sysrq_driver = {
+	.driver.name = SYSRQ_KRESET_NAME,
+	.probe = sysrq_probe,
+};
+
 static bool sysrq_handler_registered;
 
 static inline void sysrq_register_handler(void)
 {
 	int error;
 
+	error = platform_driver_register(&sysrq_driver);
+	if (error)
+		pr_err("Failed to sysrq_keyreset driver, error %d", error);
+
 	error = input_register_handler(&sysrq_handler);
 	if (error)
 		pr_err("Failed to register input handler, error %d", error);
diff --git a/include/linux/sysrq.h b/include/linux/sysrq.h
index 7faf933..d470ae5 100644
--- a/include/linux/sysrq.h
+++ b/include/linux/sysrq.h
@@ -17,6 +17,8 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 
+#define SYSRQ_KRESET_NAME	"keyreset"
+
 /* Enable/disable SYSRQ support by default (0==no, 1==yes). */
 #define SYSRQ_DEFAULT_ENABLE	1
 
@@ -38,6 +40,12 @@ struct sysrq_key_op {
 	int enable_mask;
 };
 
+struct keyreset_platform_data {
+	int (*reset_fn)(void);
+	int *keys_up;
+	int keys_down[]; /* 0 terminated */
+};
+
 #ifdef CONFIG_MAGIC_SYSRQ
 
 /* Generic SysRq interface -- you may call it from any device driver, supplying
-- 
1.7.5.4

