Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab0JEKmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:42:13 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:16080 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab0JEKmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:42:12 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9TCBK-01-CJK-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Maynard Johnson <maynardj@us.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>,
        William Cohen <wcohen@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH] oprofile: disable write access to oprofilefs while profiler is running
Date: Tue, 5 Oct 2010 12:36:57 +0200
Message-ID: <1286275017-32497-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oprofile counters are setup when profiling is disabled. Thus, writing
to oprofilefs has no immediate effect. Changes are updated only after
oprofile is reenabled.

To keep userland and kernel states synchronized, we now allow
configuration of oprofile only if profiling is disabled.  In this case
it checks if the profiler is running and then disables write access to
oprofilefs by returning -EBUSY. The change should be backward
compatible with current oprofile userland daemon.

Cc: Maynard Johnson <maynardj@us.ibm.com>
Cc: William Cohen <wcohen@redhat.com>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/oprof.c          |   19 +++++--------------
 drivers/oprofile/oprof.h          |    2 +-
 drivers/oprofile/oprofile_files.c |    7 +++++--
 drivers/oprofile/oprofilefs.c     |    8 ++++++--
 4 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index b4a6857..a7ab09e 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -225,26 +225,17 @@ post_sync:
 	mutex_unlock(&start_mutex);
 }
 
-int oprofile_set_backtrace(unsigned long val)
+int oprofile_set_ulong(unsigned long *addr, unsigned long val)
 {
-	int err = 0;
+	int err = -EBUSY;
 
 	mutex_lock(&start_mutex);
-
 	if (oprofile_started) {
-		err = -EBUSY;
-		goto out;
-	}
-
-	if (!oprofile_ops.backtrace) {
-		err = -EINVAL;
-		goto out;
+		*addr = val;
+		err = 0;
 	}
-
-	oprofile_backtrace_depth = val;
-
-out:
 	mutex_unlock(&start_mutex);
+
 	return err;
 }
 
diff --git a/drivers/oprofile/oprof.h b/drivers/oprofile/oprof.h
index 47e12cb..177b73d 100644
--- a/drivers/oprofile/oprof.h
+++ b/drivers/oprofile/oprof.h
@@ -37,7 +37,7 @@ void oprofile_create_files(struct super_block *sb, struct dentry *root);
 int oprofile_timer_init(struct oprofile_operations *ops);
 void oprofile_timer_exit(void);
 
-int oprofile_set_backtrace(unsigned long depth);
+int oprofile_set_ulong(unsigned long *addr, unsigned long val);
 int oprofile_set_timeout(unsigned long time);
 
 #endif /* OPROF_H */
diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
index bbd7516..ccf099e 100644
--- a/drivers/oprofile/oprofile_files.c
+++ b/drivers/oprofile/oprofile_files.c
@@ -79,14 +79,17 @@ static ssize_t depth_write(struct file *file, char const __user *buf, size_t cou
 	if (*offset)
 		return -EINVAL;
 
+	if (!oprofile_ops.backtrace)
+		return -EINVAL;
+
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
 	if (retval)
 		return retval;
 
-	retval = oprofile_set_backtrace(val);
-
+	retval = oprofile_set_ulong(&oprofile_backtrace_depth, val);
 	if (retval)
 		return retval;
+
 	return count;
 }
 
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index 789a1a8..1944621 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -91,16 +91,20 @@ static ssize_t ulong_read_file(struct file *file, char __user *buf, size_t count
 
 static ssize_t ulong_write_file(struct file *file, char const __user *buf, size_t count, loff_t *offset)
 {
-	unsigned long *value = file->private_data;
+	unsigned long value;
 	int retval;
 
 	if (*offset)
 		return -EINVAL;
 
-	retval = oprofilefs_ulong_from_user(value, buf, count);
+	retval = oprofilefs_ulong_from_user(&value, buf, count);
+	if (retval)
+		return retval;
 
+	retval = oprofile_set_ulong(file->private_data, value);
 	if (retval)
 		return retval;
+
 	return count;
 }
 
-- 
1.7.2.2


