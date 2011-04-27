Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab1D0S12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:27:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab1D0S11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:27:27 -0400
Message-ID: <4DB8600C.8080000@suse.com>
Date: Wed, 27 Apr 2011 14:27:24 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] hung_task_timeout: configurable default
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/hung_task.c |    3 ++-
 lib/Kconfig.debug  |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -33,7 +33,8 @@ unsigned long __read_mostly sysctl_hung_
 /*
  * Zero means infinite timeout - no checking done:
  */
-unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;
+unsigned long __read_mostly sysctl_hung_task_timeout_secs =
+					CONFIG_DEFAULT_HUNG_TASK_TIMEOUT;
 
 unsigned long __read_mostly sysctl_hung_task_warnings = 10;
 
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -214,6 +214,20 @@ config DETECT_HUNG_TASK
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
+	  A timeout of 0 disables the check.  The default is 120 seconds.
+
 config BOOTPARAM_HUNG_TASK_PANIC
 	bool "Panic (Reboot) On Hung Tasks"
 	depends on DETECT_HUNG_TASK
-- 
Jeff Mahoney
SUSE Labs
