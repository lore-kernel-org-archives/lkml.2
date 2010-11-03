Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab0KCSgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:36:25 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37737 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469Ab0KCSgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:36:18 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: =?UTF-8?q?=5BPATCH=205/7=5D=20=5BRFC=5D=20posix=20clocks=3A=20dynamic=20clock=20ids=2E?=
Date: Wed,  3 Nov 2010 11:31:17 -0700
Message-Id: <1288809079-14663-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288809079-14663-1-git-send-email-john.stultz@linaro.org>
References: <1288809079-14663-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>

This patch augments the POSIX clock code to offer a dynamic clock
creation method. Instead of registering a hard coded clock ID, modules
may call create_posix_clock(), which returns a new clock ID.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>

This patch still has un-addressed lifetime issues pointed out by
Alan Cox. More work is needed here, but for now this provides the
functionality needed for the following patches.

Signed-off-by: John Stultz <john.stultz@linaro.org>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Richard Cochran <richardcochran@gmail.com>
CC: Arve Hjønnevåg <arve@android.com>

---
 include/linux/posix-timers.h |    7 ++++++-
 include/linux/time.h         |    2 ++
 kernel/posix-timers.c        |   41 ++++++++++++++++++++++++++++++++++-------
 3 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 3e23844a..a9e601a 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -67,6 +67,7 @@ struct k_itimer {
 };
 
 struct k_clock {
+	clockid_t id;
 	int res;		/* in nanoseconds */
 	int (*clock_getres) (const clockid_t which_clock, struct timespec *tp);
 	int (*clock_set) (const clockid_t which_clock, struct timespec * tp);
@@ -84,7 +85,11 @@ struct k_clock {
 			   struct itimerspec * cur_setting);
 };
 
-void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
+/* Regsiter a posix clock with a "well known" clock id. */
+int register_posix_clock(const clockid_t id, struct k_clock *clock);
+
+/* Create a new posix clock with a dynamic clock id. */
+clockid_t create_posix_clock(struct k_clock *clock);
 
 /* error handlers for timer_create, nanosleep and settime */
 int do_posix_clock_nonanosleep(const clockid_t, int flags, struct timespec *,
diff --git a/include/linux/time.h b/include/linux/time.h
index 9f15ac7..914c48d 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -299,6 +299,8 @@ struct itimerval {
 #define CLOCKS_MASK			(CLOCK_REALTIME | CLOCK_MONOTONIC)
 #define CLOCKS_MONO			CLOCK_MONOTONIC
 
+#define CLOCK_INVALID			-1
+
 /*
  * The various flags for setting POSIX.1b interval timers:
  */
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 9ca4973..2f88d0b 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -132,6 +132,8 @@ static DEFINE_SPINLOCK(idr_lock);
  */
 
 static struct k_clock posix_clocks[MAX_CLOCKS];
+static DECLARE_BITMAP(clocks_map, MAX_CLOCKS);
+static DEFINE_MUTEX(clocks_mux); /* protects 'posix_clocks' and 'clocks_map' */
 
 /*
  * These ones are defined below.
@@ -476,18 +478,43 @@ static struct pid *good_sigevent(sigevent_t * event)
 	return task_pid(rtn);
 }
 
-void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock)
+int register_posix_clock(const clockid_t id, struct k_clock *clock)
 {
-	if ((unsigned) clock_id >= MAX_CLOCKS) {
-		printk("POSIX clock register failed for clock_id %d\n",
-		       clock_id);
-		return;
-	}
+	struct k_clock *kc;
+	int err = 0;
 
-	posix_clocks[clock_id] = *new_clock;
+	mutex_lock(&clocks_mux);
+	if (test_bit(id, clocks_map)) {
+		pr_err("clock_id %d already registered\n", id);
+		err = -EBUSY;
+		goto out;
+	}
+	kc = &posix_clocks[id];
+	*kc = *clock;
+	kc->id = id;
+	set_bit(id, clocks_map);
+out:
+	mutex_unlock(&clocks_mux);
+	return err;
 }
 EXPORT_SYMBOL_GPL(register_posix_clock);
 
+clockid_t create_posix_clock(struct k_clock *clock)
+{
+	clockid_t id;
+
+	mutex_lock(&clocks_mux);
+	id = find_first_zero_bit(clocks_map, MAX_CLOCKS);
+	mutex_unlock(&clocks_mux);
+
+	if (id < MAX_CLOCKS) {
+		register_posix_clock(id, clock);
+		return id;
+	}
+	return CLOCK_INVALID;
+}
+EXPORT_SYMBOL_GPL(create_posix_clock);
+
 static struct k_itimer * alloc_posix_timer(void)
 {
 	struct k_itimer *tmr;
-- 
1.7.3.2.146.gca209

