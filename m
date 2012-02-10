Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2BJPLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:11:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab2BJPLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:11:50 -0500
From: Matthew Garrett <mjg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com, vgoyal@redhat.com,
        seiji.aguchi@hds.com, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] kmsg_dump: Don't run on non-error paths by default
Date: Fri, 10 Feb 2012 10:11:33 -0500
Message-Id: <1328886693-20670-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 04c6862c055fb687c90d9652f32c11a063df15cf kmsg_dump() gets run on
normal paths including poweroff and reboot. This is less than ideal given
pstore implementations that can only represent single backtraces, since a
reboot may overwrite a stored oops before it's been picked up by userspace.
In addition, some pstore backends may have low performance and provide a
significant delay in reboot as a result.

This patch adds a printk.always_kmsg_dump kernel parameter (which can also
be changed from userspace). Without it, the code will only be run on
failure paths rather than on normal paths. The option can be enabled in
environments where there's a desire to attempt to audit whether or not
a reboot was cleanly requested or not.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 include/linux/kmsg_dump.h           |    9 +++++++--
 kernel/printk.c                     |    6 ++++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 033d4e6..d99fd9c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2211,6 +2211,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 			default: off.
 
+	printk.always_kmsg_dump=
+			Trigger kmsg_dump for cases other than kernel oops or
+			panics
+			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
+			default: disabled
+
 	printk.time=	Show timing data prefixed to each printk message line
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 
diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h
index fee6631..35f7237 100644
--- a/include/linux/kmsg_dump.h
+++ b/include/linux/kmsg_dump.h
@@ -15,13 +15,18 @@
 #include <linux/errno.h>
 #include <linux/list.h>
 
+/*
+ * Keep this list arranged in rough order of priority. Anything listed after
+ * KMSG_DUMP_OOPS will not be logged by default unless printk.always_kmsg_dump
+ * is passed to the kernel.
+ */
 enum kmsg_dump_reason {
-	KMSG_DUMP_OOPS,
 	KMSG_DUMP_PANIC,
+	KMSG_DUMP_OOPS,
+	KMSG_DUMP_EMERG,
 	KMSG_DUMP_RESTART,
 	KMSG_DUMP_HALT,
 	KMSG_DUMP_POWEROFF,
-	KMSG_DUMP_EMERG,
 };
 
 /**
diff --git a/kernel/printk.c b/kernel/printk.c
index 13c0a11..e7d07f5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -702,6 +702,9 @@ static bool printk_time = 0;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
+static bool always_kmsg_dump;
+module_param_named(always_kmsg_dump, always_kmsg_dump, bool, S_IRUGO | S_IWUSR);
+
 /* Check if we have any console registered that can be called early in boot. */
 static int have_callable_console(void)
 {
@@ -1732,6 +1735,9 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 	unsigned long l1, l2;
 	unsigned long flags;
 
+	if (reason > KMSG_DUMP_PANIC && !always_kmsg_dump)
+		return;
+
 	/* Theoretically, the log could move on after we do this, but
 	   there's not a lot we can do about that. The new messages
 	   will overwrite the start of what we dump. */
-- 
1.7.7.6

