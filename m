Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908Ab0GWNK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 09:10:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:53498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368Ab0GWNKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 09:10:25 -0400
Date: Fri, 23 Jul 2010 13:10:04 GMT
From: tip-bot for Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        arjan@linux.intel.com, tglx@linutronix.de, ppannuto@codeaurora.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, tglx@linutronix.de, ppannuto@codeaurora.org
In-Reply-To: <4C44CDD2.1070708@codeaurora.org>
References: <4C44CDD2.1070708@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timer: Added usleep[_range] timer
Message-ID: <tip-22b8f15c2f7130bb0386f548428df2ffd4e81903@git.kernel.org>
Git-Commit-ID: 22b8f15c2f7130bb0386f548428df2ffd4e81903
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Jul 2010 13:10:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22b8f15c2f7130bb0386f548428df2ffd4e81903
Gitweb:     http://git.kernel.org/tip/22b8f15c2f7130bb0386f548428df2ffd4e81903
Author:     Patrick Pannuto <ppannuto@codeaurora.org>
AuthorDate: Mon, 19 Jul 2010 15:09:26 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 23 Jul 2010 15:08:12 +0200

timer: Added usleep[_range] timer

usleep[_range] are finer precision implementations of msleep
and are designed to be drop-in replacements for udelay where
a precise sleep / busy-wait is unnecessary. They also allow
an easy interface to specify slack when a precise (ish)
wakeup is unnecessary to help minimize wakeups

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: akinobu.mita@gmail.com
Cc: sboyd@codeaurora.org
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <4C44CDD2.1070708@codeaurora.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/delay.h |    6 ++++++
 kernel/timer.c        |   22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/linux/delay.h b/include/linux/delay.h
index fd832c6..0e303d1 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -45,6 +45,12 @@ extern unsigned long lpj_fine;
 void calibrate_delay(void);
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
+void usleep_range(unsigned long min, unsigned long max);
+
+static inline void usleep(unsigned long usecs)
+{
+	usleep_range(usecs, usecs);
+}
 
 static inline void ssleep(unsigned int seconds)
 {
diff --git a/kernel/timer.c b/kernel/timer.c
index ce98685..f110f24 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1755,3 +1755,25 @@ unsigned long msleep_interruptible(unsigned int msecs)
 }
 
 EXPORT_SYMBOL(msleep_interruptible);
+
+static int __sched do_usleep_range(unsigned long min, unsigned long max)
+{
+	ktime_t kmin;
+	unsigned long delta;
+
+	kmin = ktime_set(0, min * NSEC_PER_USEC);
+	delta = max - min;
+	return schedule_hrtimeout_range(&kmin, delta, HRTIMER_MODE_REL);
+}
+
+/**
+ * usleep_range - Drop in replacement for udelay where wakeup is flexible
+ * @min: Minimum time in usecs to sleep
+ * @max: Maximum time in usecs to sleep
+ */
+void usleep_range(unsigned long min, unsigned long max)
+{
+	__set_current_state(TASK_UNINTERRUPTIBLE);
+	do_usleep_range(min, max);
+}
+EXPORT_SYMBOL(usleep_range);
