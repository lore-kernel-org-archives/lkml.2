Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab1D1KBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:01:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:51191 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758406Ab1D1KBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:01:10 -0400
Date: Thu, 28 Apr 2011 10:00:46 GMT
From: tip-bot for Jeff Mahoney <jeffm@suse.com>
Message-ID: <tip-e11feaa1192a079ba8e88a12121e9b12d55d4239@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jeffm@suse.com, tglx@linutronix.de, msb@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jeffm@suse.com, tglx@linutronix.de, msb@google.com, mingo@elte.hu
In-Reply-To: <4DB8600C.8080000@suse.com>
References: <4DB8600C.8080000@suse.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] watchdog, hung_task_timeout: Add Kconfig configurable default
Git-Commit-ID: e11feaa1192a079ba8e88a12121e9b12d55d4239
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 28 Apr 2011 10:00:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e11feaa1192a079ba8e88a12121e9b12d55d4239
Gitweb:     http://git.kernel.org/tip/e11feaa1192a079ba8e88a12121e9b12d55d4239
Author:     Jeff Mahoney <jeffm@suse.com>
AuthorDate: Wed, 27 Apr 2011 14:27:24 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 28 Apr 2011 09:13:17 +0200

watchdog, hung_task_timeout: Add Kconfig configurable default

This patch allows the default value for sysctl_hung_task_timeout_secs
to be set at build time. The feature carries virtually no overhead,
so it makes sense to keep it enabled. On heavily loaded systems, though,
it can end up triggering stack traces when there is no bug other than
the system being underprovisioned. We use this patch to keep the hung task
facility available but disabled at boot-time.

The default of 120 seconds is preserved. As a note, commit e162b39a may
have accidentally reverted commit fb822db4, which raised the default from
120 seconds to 480 seconds.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: Mandeep Singh Baines <msb@google.com>
Link: http://lkml.kernel.org/r/4DB8600C.8080000@suse.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/hung_task.c |    2 +-
 lib/Kconfig.debug  |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 53ead17..ea64012 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -33,7 +33,7 @@ unsigned long __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
 /*
  * Zero means infinite timeout - no checking done:
  */
-unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;
+unsigned long __read_mostly sysctl_hung_task_timeout_secs = CONFIG_DEFAULT_HUNG_TASK_TIMEOUT;
 
 unsigned long __read_mostly sysctl_hung_task_warnings = 10;
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c768bcd..debbb05 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -238,6 +238,21 @@ config DETECT_HUNG_TASK
 	  enabled then all held locks will also be reported. This
 	  feature has negligible overhead.
 
+config DEFAULT_HUNG_TASK_TIMEOUT
+	int "Default timeout for hung task detection (in seconds)"
+	depends on DETECT_HUNG_TASK
+	default 120
+	help
+	  This option controls the default timeout (in seconds) used
+	  to determine when a task has become non-responsive and should
+	  be considered hung.
+
+	  It can be adjusted at runtime via the kernel.hung_task_timeout
+	  sysctl or by writing a value to /proc/sys/kernel/hung_task_timeout.
+
+	  A timeout of 0 disables the check.  The default is two minutes.
+	  Keeping the default should be fine in most cases.
+
 config BOOTPARAM_HUNG_TASK_PANIC
 	bool "Panic (Reboot) On Hung Tasks"
 	depends on DETECT_HUNG_TASK
