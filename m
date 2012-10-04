Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab2JDNtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:49:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933097Ab2JDNtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:49:04 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] ntp, add debugfs entries for time_status and time_state
Date: Thu,  4 Oct 2012 09:48:41 -0400
Message-Id: <1349358521-4386-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add debugfs entries for ntp time_status and time_state.  These are useful
for debugging ntp issues.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/ntp.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 24174b4..e1ba393 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -15,6 +15,7 @@
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/debugfs.h>
 
 #include "tick-internal.h"
 
@@ -965,3 +966,42 @@ void __init ntp_init(void)
 {
 	ntp_clear();
 }
+
+static int time_status_get(void *data, u64 *val)
+{
+	*val = time_status;
+	return 0;
+}
+DEFINE_SIMPLE_ATTRIBUTE(time_status_fops, time_status_get, NULL, "0x%0llx\n");
+
+static int time_state_get(void *data, u64 *val)
+{
+	*val = time_state;
+	return 0;
+}
+DEFINE_SIMPLE_ATTRIBUTE(time_state_fops, time_state_get, NULL, "0x%llx\n");
+
+static int __init ntp_debugfs_init(void)
+{
+	struct dentry *ntp_dentry, *time_status_dentry, *time_state_dentry;
+
+	ntp_dentry = debugfs_create_dir("ntp", NULL);
+	if (!ntp_dentry)
+		return -ENOMEM;
+
+	time_status_dentry = debugfs_create_file("time_status", 0444,
+						 ntp_dentry, NULL,
+						 &time_status_fops);
+	if (!time_status_dentry)
+		return -ENOMEM;
+
+	time_state_dentry = debugfs_create_file("time_state", 0444,
+						ntp_dentry, NULL,
+						&time_state_fops);
+	if (!time_state_dentry)
+		return -ENOMEM;
+
+	return 0;
+}
+/* debugfs init is core_initcall */
+postcore_initcall(ntp_debugfs_init);
-- 
1.7.9.3

