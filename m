Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab1EPXgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:36:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62877 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1EPXgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:36:17 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/4] watchdog: disable watchdog when thresh is zero
Date: Mon, 16 May 2011 16:35:00 -0700
Message-Id: <1305588901-8141-3-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1305588901-8141-1-git-send-email-msb@chromium.org>
References: <1305588901-8141-1-git-send-email-msb@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This restores the previous behavior of softlock_thresh.

Currently, setting watchdog_thresh to zero causes the watchdog
kthreads to consume a lot of CPU.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index cf0e09f..50c2f62 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -526,7 +526,20 @@ int proc_dowatchdog_thresh(struct ctl_table *table, int write,
 			     void __user *buffer,
 			     size_t *lenp, loff_t *ppos)
 {
-	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	int ret;
+
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (ret || !write)
+		goto out;
+
+	if (softlockup_thresh)
+		watchdog_enable_all_cpus();
+	else
+		watchdog_disable_all_cpus();
+
+out:
+	return ret;
+
 }
 #endif /* CONFIG_SYSCTL */
 
-- 
1.7.3.1

