Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab1BBV4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:56:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:32808 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431Ab1BBV43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:56:29 -0500
Date: Wed, 2 Feb 2011 21:56:11 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134417.841974553@linutronix.de>
References: <20110201134417.841974553@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Introduce clock_posix_cpu
Message-ID: <tip-1976945eeaab5fa461735a6225a82c3cf1e65d62@git.kernel.org>
Git-Commit-ID: 1976945eeaab5fa461735a6225a82c3cf1e65d62
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 21:56:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1976945eeaab5fa461735a6225a82c3cf1e65d62
Gitweb:     http://git.kernel.org/tip/1976945eeaab5fa461735a6225a82c3cf1e65d62
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:51:06 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:12 +0100

posix-timers: Introduce clock_posix_cpu

The CLOCK_DISPATCH() macro is a horrible magic. We call common
functions if a function pointer is not set. That's just backwards.

To support dynamic file decriptor based clocks we need to cleanup that
dispatch logic.

Create a k_clock struct clock_posix_cpu which has all the
posix-cpu-timer functions filled in. After the cleanup the functions
can be made static.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134417.841974553@linutronix.de>
---
 include/linux/posix-timers.h |    2 ++
 kernel/posix-cpu-timers.c    |   12 ++++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index b2c14cb..1330ff3 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -85,6 +85,8 @@ struct k_clock {
 			   struct itimerspec * cur_setting);
 };
 
+extern struct k_clock clock_posix_cpu;
+
 void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
 
 /* error handlers for timer_create, nanosleep and settime */
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 11b91dc..816cd49 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1604,6 +1604,18 @@ static long thread_cpu_nsleep_restart(struct restart_block *restart_block)
 	return -EINVAL;
 }
 
+struct k_clock clock_posix_cpu = {
+	.clock_getres	= posix_cpu_clock_getres,
+	.clock_set	= posix_cpu_clock_set,
+	.clock_get	= posix_cpu_clock_get,
+	.timer_create	= posix_cpu_timer_create,
+	.nsleep		= posix_cpu_nsleep,
+	.nsleep_restart	= posix_cpu_nsleep_restart,
+	.timer_set	= posix_cpu_timer_set,
+	.timer_del	= posix_cpu_timer_del,
+	.timer_get	= posix_cpu_timer_get,
+};
+
 static __init int init_posix_cpu_timers(void)
 {
 	struct k_clock process = {
