Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab1BBWGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:06:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:50185 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab1BBWGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:06:03 -0500
Date: Wed, 2 Feb 2011 22:05:43 GMT
From: tip-bot for Richard Cochran <richard.cochran@omicron.at>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134420.062860200@linutronix.de>
References: <20110201134420.062860200@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Add support for fd based clocks
Message-ID: <tip-81e294cba2596f5f10848bbe19d98b344c2a2d5c@git.kernel.org>
Git-Commit-ID: 81e294cba2596f5f10848bbe19d98b344c2a2d5c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 22:05:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  81e294cba2596f5f10848bbe19d98b344c2a2d5c
Gitweb:     http://git.kernel.org/tip/81e294cba2596f5f10848bbe19d98b344c2a2d5c
Author:     Richard Cochran <richard.cochran@omicron.at>
AuthorDate: Tue, 1 Feb 2011 13:52:32 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:19 +0100

posix-timers: Add support for fd based clocks

Extend the negative clockids which are currently used by posix cpu
timers to encode the PID with a file descriptor based type which
encodes the fd in the upper bits.

Originally-from: Richard Cochran <richard.cochran@omicron.at>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20110201134420.062860200@linutronix.de>
---
 include/linux/posix-timers.h |   13 +++++++++++++
 kernel/posix-timers.c        |    2 +-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 79a1cea..88b9256 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -18,6 +18,17 @@ struct cpu_timer_list {
 	int firing;
 };
 
+/*
+ * Bit fields within a clockid:
+ *
+ * The most significant 29 bits hold either a pid or a file descriptor.
+ *
+ * Bit 2 indicates whether a cpu clock refers to a thread or a process.
+ *
+ * Bits 1 and 0 give the type: PROF=0, VIRT=1, SCHED=2, or FD=3.
+ *
+ * A clockid is invalid if bits 2, 1, and 0 are all set.
+ */
 #define CPUCLOCK_PID(clock)		((pid_t) ~((clock) >> 3))
 #define CPUCLOCK_PERTHREAD(clock) \
 	(((clock) & (clockid_t) CPUCLOCK_PERTHREAD_MASK) != 0)
@@ -29,6 +40,8 @@ struct cpu_timer_list {
 #define CPUCLOCK_VIRT		1
 #define CPUCLOCK_SCHED		2
 #define CPUCLOCK_MAX		3
+#define CLOCKFD			CPUCLOCK_MAX
+#define CLOCKFD_MASK		(CPUCLOCK_PERTHREAD_MASK|CPUCLOCK_CLOCK_MASK)
 
 #define MAKE_PROCESS_CPUCLOCK(pid, clock) \
 	((~(clockid_t) (pid) << 3) | (clockid_t) (clock))
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 5a5a4f1..df629d8 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -488,7 +488,7 @@ static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 static struct k_clock *clockid_to_kclock(const clockid_t id)
 {
 	if (id < 0)
-		return &clock_posix_cpu;
+		return (id & CLOCKFD_MASK) == CLOCKFD ? NULL : &clock_posix_cpu;
 
 	if (id >= MAX_CLOCKS || !posix_clocks[id].clock_getres)
 		return NULL;
