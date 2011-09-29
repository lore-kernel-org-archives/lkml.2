Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab1I2U47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:56:59 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:54177 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab1I2U46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:56:58 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Sep 2011 16:56:58 EDT
From: Arun Raghavan <arun.raghavan@collabora.co.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Henningsson <david.henningsson@canonical.com>,
        linux-kernel@vger.kernel.org,
        Arun Raghavan <arun.raghavan@collabora.co.uk>
Subject: [PATCH] rlimits: Print more information when limits are exceeded
Date: Fri, 30 Sep 2011 02:20:28 +0530
Message-Id: <1317329428-6576-1-git-send-email-arun.raghavan@collabora.co.uk>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This dumps some information in logs when a process exceeds its CPU or RT
limits (soft and hard). Makes debugging easier when userspace triggers
these limits.
---
 kernel/posix-cpu-timers.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 58f405b..1272a5a 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -973,6 +973,9 @@ static void check_thread_timers(struct task_struct *tsk,
 			 * At the hard limit, we just die.
 			 * No need to calculate anything else now.
 			 */
+			printk(KERN_INFO
+				"RT Watchdog Timeout (hard): %s[%d]\n",
+				tsk->comm, task_pid_nr(tsk));
 			__group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);
 			return;
 		}
@@ -985,7 +988,7 @@ static void check_thread_timers(struct task_struct *tsk,
 				sig->rlim[RLIMIT_RTTIME].rlim_cur = soft;
 			}
 			printk(KERN_INFO
-				"RT Watchdog Timeout: %s[%d]\n",
+				"RT Watchdog Timeout (soft): %s[%d]\n",
 				tsk->comm, task_pid_nr(tsk));
 			__group_send_sig_info(SIGXCPU, SEND_SIG_PRIV, tsk);
 		}
@@ -1138,6 +1141,9 @@ static void check_process_timers(struct task_struct *tsk,
 			 * At the hard limit, we just die.
 			 * No need to calculate anything else now.
 			 */
+			printk(KERN_INFO
+				"CPU Watchdog Timeout (hard): %s[%d]\n",
+				tsk->comm, task_pid_nr(tsk));
 			__group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);
 			return;
 		}
@@ -1145,6 +1151,9 @@ static void check_process_timers(struct task_struct *tsk,
 			/*
 			 * At the soft limit, send a SIGXCPU every second.
 			 */
+			printk(KERN_INFO
+				"CPU Watchdog Timeout (soft): %s[%d]\n",
+				tsk->comm, task_pid_nr(tsk));
 			__group_send_sig_info(SIGXCPU, SEND_SIG_PRIV, tsk);
 			if (soft < hard) {
 				soft++;
-- 
1.7.6.1

