Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1EWFMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 01:12:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61106 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1EWFLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 01:11:53 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/4] watchdog: only disable/enable watchdog if neccessary
Date: Sun, 22 May 2011 22:10:21 -0700
Message-Id: <1306127423-3347-2-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1306127423-3347-1-git-send-email-msb@chromium.org>
References: <1306127423-3347-1-git-send-email-msb@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't take any action on an unsuccessful write to /proc.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/watchdog.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index a06972d..cf0e09f 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -507,15 +507,19 @@ static void watchdog_disable_all_cpus(void)
 int proc_dowatchdog_enabled(struct ctl_table *table, int write,
 		     void __user *buffer, size_t *length, loff_t *ppos)
 {
-	proc_dointvec(table, write, buffer, length, ppos);
+	int ret;
 
-	if (write) {
-		if (watchdog_enabled)
-			watchdog_enable_all_cpus();
-		else
-			watchdog_disable_all_cpus();
-	}
-	return 0;
+	ret = proc_dointvec(table, write, buffer, length, ppos);
+	if (ret || !write)
+		goto out;
+
+	if (watchdog_enabled)
+		watchdog_enable_all_cpus();
+	else
+		watchdog_disable_all_cpus();
+
+out:
+	return ret;
 }
 
 int proc_dowatchdog_thresh(struct ctl_table *table, int write,
-- 
1.7.3.1

