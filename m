Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab2JESAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 14:00:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34502 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab2JESAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 14:00:01 -0400
From: mathieu.poirier@linaro.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
        mathieu.poirier@linaro.org, arve@android.com, kernel-team@android.com,
        dmitry.torokhov@gmail.com, john.stultz@linaro.org,
        alan@lxorguk.ukuu.org.uk
Subject: [PATCH] drivers/tty: Folding Android's keyreset driver in sysRQ
Date: Fri,  5 Oct 2012 11:59:29 -0600
Message-Id: <1349459969-17473-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>

Andrew,

After requesting a number of changes that, to my understanding
have been implemented, I have not been able to get the attention
of the subsystem maintainer on this patch.

If there are still issues, I'm open to making changes but I want
to make sure it doesn't get forgotten.  If there no objections,
would you consider queuint it ?

This patch adds keyreset functionality to the sysrq driver. It
allows certain button/key combinations to be used in order to
trigger device resets.

The first time the key-combo is detected a work function that syncs
the filesystems is scheduled and the kernel rebooted. If all the keys
are released and then pressed again, it calls panic. Reboot on panic
should be set for this to work.

A platform device that specify a reset key-combo should be added to
the board file to trigger the feature.  Alternatively keys can be
passed to the driver via the "/sys/module/sysrq" interface.

This functionality comes from the keyreset driver submitted by
Arve Hjønnevåg in the Android kernel.

Cc: arve@android.com
Cc: kernel-team@android.com
Cc: dmitry.torokhov@gmail.com
Cc: john.stultz@linaro.org
Cc: alan@lxorguk.ukuu.org.uk
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/tty/sysrq.c   |  308 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysrq.h |    8 ++
 2 files changed, 316 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 05728894..c44056f 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -41,14 +41,30 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/uaccess.h>
+#include <linux/platform_device.h>
+#include <linux/syscalls.h>
+#include <linux/atomic.h>
+#include <linux/moduleparam.h>
+#include <linux/mutex.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
 
+#define KEY_DOWN_MAX	20 /* how  many is enough ? */
+int keyreset_param[KEY_DOWN_MAX];
+struct mutex sysrq_mutex;
+static struct sysrq_state *sysrq_handle;
+
 /* Whether we react on sysrq keys or just ignore them */
 static int __read_mostly sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
 static bool __read_mostly sysrq_always_enabled;
 
+static struct input_handler sysrq_handler;
+
+/* Keep track of what has been called */
+static atomic_t restart_requested;
+
+
 static bool sysrq_on(void)
 {
 	return sysrq_enabled || sysrq_always_enabled;
@@ -570,6 +586,15 @@ struct sysrq_state {
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
@@ -603,6 +628,101 @@ static void sysrq_reinject_alt_sysrq(struct work_struct *work)
 	}
 }
 
+
+static int sysrq_probe(struct platform_device *pdev)
+{
+	struct keyreset_platform_data *pdata = pdev->dev.platform_data;
+
+	/*
+	 * No sequence of keys to trigger on,
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
+	mutex_lock(&sysrq_mutex);
+
+	/* Is the code of interest to us */
+	if (!test_bit(code, state->keybit)) {
+		mutex_unlock(&sysrq_mutex);
+		return processed;
+	}
+
+	/* No need to take care of key up events */
+	if (!test_bit(code, state->key) == !value) {
+		mutex_unlock(&sysrq_mutex);
+		return processed;
+	}
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
+			panic("keyboard reset failed, %d - panic\n",
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
+	mutex_unlock(&sysrq_mutex);
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
@@ -669,6 +789,11 @@ static bool sysrq_filter(struct input_handle *handle,
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
@@ -704,26 +829,83 @@ static bool sysrq_filter(struct input_handle *handle,
 		break;
 	}
 
+	/*
+	 * suppress == true - suppress passing to other subsystems.
+	 * suppress == false - passing to other subsystems.
+	 */
+end:
 	return suppress;
 }
 
+static void parse_user_data(struct sysrq_state *sysrq,
+				 int *keys_down, int *keys_up)
+{
+	int key, *keyp;
+
+	if (keys_down) {
+		sysrq->key_down_target = 0;
+		memset(sysrq->keybit, 0, BITS_TO_LONGS(KEY_CNT));
+
+		keyp = keys_down;
+		while ((key = *keyp++)) {
+			if (key >= KEY_MAX)
+				continue;
+			sysrq->key_down_target++;
+			__set_bit(key, sysrq->keybit);
+		}
+		sysrq->keyreset_data = 1;
+	}
+
+	if (keys_up) {
+		memset(sysrq->upbit, 0, BITS_TO_LONGS(KEY_CNT));
+		keyp = keys_up;
+		while ((key = *keyp++)) {
+			if (key >= KEY_MAX)
+				continue;
+			__set_bit(key, sysrq->keybit);
+			__set_bit(key, sysrq->upbit);
+		}
+	}
+
+	/* something changed, reset state machine */
+	sysrq->key_down_ctn = 0;
+	sysrq->key_up_ctn = 0;
+	sysrq->restart_disabled = 0;
+	memset(sysrq->key, 0, BITS_TO_LONGS(KEY_CNT));
+
+}
+
 static int sysrq_connect(struct input_handler *handler,
 			 struct input_dev *dev,
 			 const struct input_device_id *id)
 {
 	struct sysrq_state *sysrq;
+	struct keyreset_platform_data *pdata;
 	int error;
 
 	sysrq = kzalloc(sizeof(struct sysrq_state), GFP_KERNEL);
 	if (!sysrq)
 		return -ENOMEM;
 
+	/*
+	 * input_register_handle() calls sysrq_probe(), who
+	 * in turn will put the keyreset information in
+	 * sysrq_handler's private field.
+	 */
+	if (handler->private) {
+		pdata = handler->private;
+		parse_user_data(sysrq, pdata->keys_down, pdata->keys_up);
+		if (pdata->reset_fn)
+			sysrq->reset_fn = pdata->reset_fn;
+	}
+
 	INIT_WORK(&sysrq->reinject_work, sysrq_reinject_alt_sysrq);
 
 	sysrq->handle.dev = dev;
 	sysrq->handle.handler = handler;
 	sysrq->handle.name = "sysrq";
 	sysrq->handle.private = sysrq;
+	sysrq_handle = sysrq;
 
 	error = input_register_handle(&sysrq->handle);
 	if (error) {
@@ -744,6 +926,7 @@ static int sysrq_connect(struct input_handler *handler,
 	input_unregister_handle(&sysrq->handle);
  err_free:
 	kfree(sysrq);
+	sysrq_handle = NULL;
 	return error;
 }
 
@@ -754,6 +937,7 @@ static void sysrq_disconnect(struct input_handle *handle)
 	input_close_device(handle);
 	cancel_work_sync(&sysrq->reinject_work);
 	input_unregister_handle(handle);
+	sysrq_handle = NULL;
 	kfree(sysrq);
 }
 
@@ -780,12 +964,23 @@ static struct input_handler sysrq_handler = {
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
 
+	mutex_init(&sysrq_mutex);
+
+	error = platform_driver_register(&sysrq_driver);
+	if (error)
+		pr_err("Failed to sysrq_keyreset driver, error %d", error);
+
 	error = input_register_handler(&sysrq_handler);
 	if (error)
 		pr_err("Failed to register input handler, error %d", error);
@@ -905,4 +1100,117 @@ static int __init sysrq_init(void)
 
 	return 0;
 }
+
+static int key_array_set(const char *val,
+			 const struct kernel_param *kp, int is_key_down)
+{
+	int num, len;
+	char save;
+	int max = kp->arr->max;
+
+	num = 0;
+
+	mutex_lock(&sysrq_mutex);
+	/*
+	 * Highly tailored on the original code found
+	 * in kernel/params.c
+	 *
+	 * We expect a comma-separated list of values, which should conform to
+	 * values found in linux/input.h.  The list should also be zero
+	 * terminated as with the platform data.  ex:
+	 * $ echo 2,3,4 > /sys/module/sysrq/parameters/key_[down, up]
+	 */
+	do {
+		if (num == max) {
+			pr_err("%s: can only take %i arguments\n",
+								kp->name, max);
+			mutex_unlock(&sysrq_mutex);
+			return -EINVAL;
+		}
+		len = strcspn(val, ",");
+
+		/* null-terminate and parse */
+		save = val[len];
+		((char *)val)[len] = '\0';
+
+		kstrtoint(val, 10, &keyreset_param[num]);
+		val += len + 1;
+		num++;
+	} while (save == ',');
+
+	if (keyreset_param[num] != 0)
+		keyreset_param[num] = 0;
+
+	if (is_key_down)
+		parse_user_data(sysrq_handle, keyreset_param, NULL);
+	else
+		parse_user_data(sysrq_handle, NULL, keyreset_param);
+
+	mutex_unlock(&sysrq_mutex);
+	return 0;
+}
+
+static int print_bits(char *buffer, unsigned long *keybit)
+{
+	int i, off, ret;
+
+	off = 0;
+	i = 0;
+
+	mutex_lock(&sysrq_mutex);
+	while (i < KEY_CNT) {
+		if (test_bit(i, keybit) && i != KEY_SYSRQ) {
+			if (off)
+				buffer[off++] = ',';
+
+			ret = sprintf(buffer + off, "%d", i);
+			off += ret;
+		}
+		i++;
+	}
+
+	buffer[off] = '\0';
+	mutex_unlock(&sysrq_mutex);
+	return off;
+
+}
+
+static int key_down_array_set(const char *val, const struct kernel_param *kp)
+{
+	return key_array_set(val, kp, 1);
+}
+
+static int key_down_array_get(char *buffer, const struct kernel_param *kp)
+{
+	return print_bits(buffer, sysrq_handle->keybit);
+}
+
+static int key_up_array_set(const char *val, const struct kernel_param *kp)
+{
+	return key_array_set(val, kp, 0);
+}
+
+static int key_up_array_get(char *buffer, const struct kernel_param *kp)
+{
+	return print_bits(buffer, sysrq_handle->upbit);
+}
+
+struct kernel_param_ops key_down_array_ops = {
+	.set = key_down_array_set,
+	.get = key_down_array_get,
+};
+
+struct kernel_param_ops key_up_array_ops = {
+	.set = key_up_array_set,
+	.get = key_up_array_get,
+};
+
+static struct kparam_array __param_keyreset = {
+	.max = KEY_DOWN_MAX,
+	.elemsize = sizeof(int),
+	.elem = keyreset_param,
+};
+
+module_param_cb(key_down, &key_down_array_ops, &__param_keyreset, 0644);
+module_param_cb(key_up, &key_up_array_ops, &__param_keyreset, 0644);
 module_init(sysrq_init);
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

