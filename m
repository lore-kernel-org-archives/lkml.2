Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab2KSHZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 02:25:31 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:57992 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2KSHZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 02:25:30 -0500
Date: Sun, 18 Nov 2012 23:25:25 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, arve@android.com, kernel-team@android.com,
        john.stultz@linaro.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH v4] drivers/tty: Folding Android's keyreset driver in
 sysRQ
Message-ID: <20121119072525.GA16730@core.coreip.homeip.net>
References: <1352665488-13818-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1352665488-13818-1-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

On Sun, Nov 11, 2012 at 01:24:48PM -0700, mathieu.poirier@linaro.org wrote:
> From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>
> 
> This patch adds keyreset functionality to the sysrq driver. It
> allows certain button/key combinations to be used in order to
> trigger device resets.
> 
> The first time the key-combo is detected a work function that syncs
> the filesystems is scheduled and the kernel rebooted. If all the keys
> are released and then pressed again, it calls panic. Reboot on panic
> should be set for this to work.
> 
> Redefining the '__weak sysrq_keyreset_get_params' function is required
> to trigger the feature.  Alternatively keys can be passed to the
> driver via the "/sys/module/sysrq" interface.
> 
> This functionality comes from the keyreset driver submitted by
> Arve Hjønnevåg in the Android kernel.

Thank you for making the changes. This still looks pretty complicated,
how about if we trim it a bit, like in the patch below.

Thanks.

-- 
Dmitry

Input: sysrq - allow specifying alternate reset sequence

From: Mathieu J. Poirier <mathieu.poirier@linaro.org>

This patch adds keyreset functionality to the sysrq driver. It allows
certain button/key combinations to be used in order to trigger emergency
reboots.

Redefining the '__weak platform_sysrq_reset_seq' variable is required
to trigger the feature.  Alternatively keys can be passed to the driver
via a module parameter.

This functionality comes from the keyreset driver submitted by
Arve Hjønnevåg in the Android kernel.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/tty/sysrq.c |  114 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 16ee6ce..9dddaf7 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/uaccess.h>
+#include <linux/moduleparam.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
@@ -576,8 +577,73 @@ struct sysrq_state {
 	bool active;
 	bool need_reinject;
 	bool reinjecting;
+
+	/* reset sequence handling */
+	bool reset_canceled;
+	unsigned long reset_keybit[BITS_TO_LONGS(KEY_CNT)];
+	int reset_seq_len;
+	int reset_seq_cnt;
+	int reset_seq_version;
 };
 
+#define SYSRQ_KEY_RESET_MAX	20 /* Should be plenty */
+static unsigned short sysrq_reset_seq[SYSRQ_KEY_RESET_MAX];
+static unsigned int sysrq_reset_seq_len;
+static unsigned int sysrq_reset_seq_version = 1;
+
+static void sysrq_parse_reset_sequence(struct sysrq_state *state)
+{
+	int i;
+	unsigned short key;
+
+	state->reset_seq_cnt = 0;
+
+	for (i = 0; i < sysrq_reset_seq_len; i++) {
+		key = sysrq_reset_seq[i];
+
+		if (key == KEY_RESERVED || key > KEY_MAX)
+			break;
+
+		__set_bit(key, state->reset_keybit);
+		state->reset_seq_len++;
+
+		if (test_bit(key, state->key_down))
+			state->reset_seq_cnt++;
+	}
+}
+
+static bool sysrq_detect_reset_sequence(struct sysrq_state *state,
+					unsigned int code, int value)
+{
+	if (state->reset_seq_version != sysrq_reset_seq_version) {
+		sysrq_parse_reset_sequence(state);
+		/* Disable reset until old keys are not released */
+		state->reset_canceled = state->reset_seq_cnt != 0;
+		state->reset_seq_version = sysrq_reset_seq_version;
+	}
+
+	if (!test_bit(code, state->reset_keybit)) {
+		/*
+		 * Pressing any key _not_ in reset sequence cancels
+		 * the reset sequence.
+		 */
+		if (value && state->reset_seq_cnt)
+			state->reset_canceled = true;
+	} else if (value == 0) {
+		/* key release */
+		if (--state->reset_seq_cnt == 0)
+			state->reset_canceled = false;
+	} else if (value == 1) {
+		/* key press, not autorepeat */
+		if (++state->reset_seq_cnt == state->reset_seq_len &&
+		    !state->reset_canceled) {
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static void sysrq_reinject_alt_sysrq(struct work_struct *work)
 {
 	struct sysrq_state *sysrq =
@@ -690,6 +756,11 @@ static bool sysrq_filter(struct input_handle *handle,
 			if (was_active)
 				schedule_work(&sysrq->reinject_work);
 
+			if (sysrq_detect_reset_sequence(sysrq, code, value)) {
+				/* Force emergency reboot */
+				__handle_sysrq(sysrq_xlate[KEY_B], false);
+			}
+
 		} else if (value == 0 &&
 			   test_and_clear_bit(code, sysrq->key_down)) {
 			/*
@@ -785,7 +856,20 @@ static bool sysrq_handler_registered;
 
 static inline void sysrq_register_handler(void)
 {
+	extern unsigned short platform_sysrq_reset_seq[] __weak;
+	unsigned short key;
 	int error;
+	int i;
+
+	if (platform_sysrq_reset_seq) {
+		for (i = 0; i < ARRAY_SIZE(sysrq_reset_seq); i++) {
+			key = platform_sysrq_reset_seq[i];
+			if (key == KEY_RESERVED || key > KEY_MAX)
+				break;
+
+			sysrq_reset_seq[sysrq_reset_seq_len++] = key;
+		}
+	}
 
 	error = input_register_handler(&sysrq_handler);
 	if (error)
@@ -802,6 +886,36 @@ static inline void sysrq_unregister_handler(void)
 	}
 }
 
+static int sysrq_reset_seq_param_set(const char *buffer,
+				     const struct kernel_param *kp)
+{
+	unsigned long val;
+	int error;
+
+	error = strict_strtoul(buffer, 0, &val);
+	if (error < 0)
+		return error;
+
+	if (val > KEY_MAX)
+		return -EINVAL;
+
+	*((unsigned short *)kp->arg) = val;
+	sysrq_reset_seq_version++;
+
+	return 0;
+}
+
+static struct kernel_param_ops param_ops_sysrq_reset_seq = {
+	.get	= param_get_ushort,
+	.set	= sysrq_reset_seq_param_set,
+};
+
+#define param_check_sysrq_reset_seq(name, p)	\
+	__param_check(name, p, unsigned short)
+
+module_param_array_named(reset_seq, sysrq_reset_seq, sysrq_reset_seq,
+			 &sysrq_reset_seq_len, 0644);
+
 #else
 
 static inline void sysrq_register_handler(void)
