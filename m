Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1EWLM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:12:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:41552 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab1EWLMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:12:55 -0400
Date: Mon, 23 May 2011 11:12:43 GMT
From: tip-bot for Mandeep Singh Baines <msb@chromium.org>
Message-ID: <tip-e04ab2bc41b35c0cb6cdb07c8443f91aa738cf78@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, msb@chromium.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, marcin.slusarz@gmail.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, msb@chromium.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        marcin.slusarz@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1306127423-3347-2-git-send-email-msb@chromium.org>
References: <1306127423-3347-2-git-send-email-msb@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] watchdog: Only disable/enable watchdog if neccessary
Git-Commit-ID: e04ab2bc41b35c0cb6cdb07c8443f91aa738cf78
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 23 May 2011 11:12:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e04ab2bc41b35c0cb6cdb07c8443f91aa738cf78
Gitweb:     http://git.kernel.org/tip/e04ab2bc41b35c0cb6cdb07c8443f91aa738cf78
Author:     Mandeep Singh Baines <msb@chromium.org>
AuthorDate: Sun, 22 May 2011 22:10:21 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 May 2011 11:58:58 +0200

watchdog: Only disable/enable watchdog if neccessary

Don't take any action on an unsuccessful write to /proc.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1306127423-3347-2-git-send-email-msb@chromium.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
