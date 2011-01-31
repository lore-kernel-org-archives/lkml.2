Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab1AaMw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:52:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:39009 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589Ab1AaMwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:52:25 -0500
Date: Mon, 31 Jan 2011 12:51:53 GMT
From: tip-bot for Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, marcin.slusarz@gmail.com, fweisbec@gmail.com,
        stable@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, marcin.slusarz@gmail.com, fweisbec@gmail.com,
        stable@kernel.org, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1296230433-6261-2-git-send-email-dzickus@redhat.com>
References: <1296230433-6261-2-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] watchdog: Fix sysctl consistency
Message-ID: <tip-397357666de6b5b6adb5fa99f9758ec8cf30ac34@git.kernel.org>
Git-Commit-ID: 397357666de6b5b6adb5fa99f9758ec8cf30ac34
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 12:51:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  397357666de6b5b6adb5fa99f9758ec8cf30ac34
Gitweb:     http://git.kernel.org/tip/397357666de6b5b6adb5fa99f9758ec8cf30ac34
Author:     Marcin Slusarz <marcin.slusarz@gmail.com>
AuthorDate: Fri, 28 Jan 2011 11:00:32 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 Jan 2011 13:22:43 +0100

watchdog: Fix sysctl consistency

If it was not possible to enable watchdog for any cpu, switch
watchdog_enabled back to 0, because it's visible via
kernel.watchdog sysctl.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: <stable@kernel.org>
LKML-Reference: <1296230433-6261-2-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index d9961ea..c7e0049 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -429,9 +429,6 @@ static int watchdog_enable(int cpu)
 		wake_up_process(p);
 	}
 
-	/* if any cpu succeeds, watchdog is considered enabled for the system */
-	watchdog_enabled = 1;
-
 	return 0;
 }
 
@@ -459,12 +456,16 @@ static void watchdog_disable(int cpu)
 static void watchdog_enable_all_cpus(void)
 {
 	int cpu;
-	int result = 0;
+
+	watchdog_enabled = 0;
 
 	for_each_online_cpu(cpu)
-		result += watchdog_enable(cpu);
+		if (!watchdog_enable(cpu))
+			/* if any cpu succeeds, watchdog is considered
+			   enabled for the system */
+			watchdog_enabled = 1;
 
-	if (result)
+	if (!watchdog_enabled)
 		printk(KERN_ERR "watchdog: failed to be enabled on some cpus\n");
 
 }
