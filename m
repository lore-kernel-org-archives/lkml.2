Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1LSNq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:46:59 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:12788
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab1LSNq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:46:57 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWGEA3-02-FRX-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>
Subject: [PATCH] oprofile: Fix uninitialized memory access when writing to oprofilefs
Date: Mon, 19 Dec 2011 14:46:13 +0100
Message-ID: <1324302373-30872-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1324302373-30872-1-git-send-email-robert.richter@amd.com>
References: <1324302373-30872-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If oprofilefs_ulong_from_user() is called with count equals zero, *val
must be initialized. Otherwise *val is later used uninitialized as no
error is returned. Alternatively oprofilefs_ulong_from_user() may not
be called if !count. This patch fixes usage of oprofilefs_ulong_from_
user().

This follows write syscall implementation when count is zero: "If
count is zero ... [and if] no errors are detected, 0 will be returned
without causing any other effect." (man 2 write)

Reported-By: Mike Waychison <mikew@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/s390/oprofile/init.c         |    3 +++
 drivers/oprofile/oprofile_files.c |    9 +++++++++
 drivers/oprofile/oprofilefs.c     |   15 ++++++++++++++-
 3 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index 6efc18b..5d605f1 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -87,6 +87,9 @@ static ssize_t hwsampler_write(struct file *file, char const __user *buf,
 	if (*offset)
 		return -EINVAL;
 
+	if (!count)
+		return 0;
+
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
 	if (retval)
 		return retval;
diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
index 89f6345..8265b41 100644
--- a/drivers/oprofile/oprofile_files.c
+++ b/drivers/oprofile/oprofile_files.c
@@ -44,6 +44,9 @@ static ssize_t timeout_write(struct file *file, char const __user *buf,
 	if (*offset)
 		return -EINVAL;
 
+	if (!count)
+		return 0;
+
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
 	if (retval)
 		return retval;
@@ -83,6 +86,9 @@ static ssize_t depth_write(struct file *file, char const __user *buf, size_t cou
 	if (!oprofile_ops.backtrace)
 		return -EINVAL;
 
+	if (!count)
+		return 0;
+
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
 	if (retval)
 		return retval;
@@ -140,6 +146,9 @@ static ssize_t enable_write(struct file *file, char const __user *buf, size_t co
 	if (*offset)
 		return -EINVAL;
 
+	if (!count)
+		return 0;
+
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
 	if (retval)
 		return retval;
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index d0de6cc..1caf1b0 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -59,7 +59,17 @@ ssize_t oprofilefs_ulong_to_user(unsigned long val, char __user *buf, size_t cou
 	return simple_read_from_buffer(buf, count, offset, tmpbuf, maxlen);
 }
 
-
+/*
+ * Note: oprofilefs_ulong_from_user() must be called with *val
+ * initialized, otherwise *val is used uninitialized if !count. This
+ * follows write syscall implementation when count is zero: "If count
+ * is zero ... [and if] no errors are detected, 0 will be returned
+ * without causing any other effect." (man 2 write)
+ *
+ * In case *val is a temporary variable, oprofilefs_ulong_from_user()
+ * may not be called if !count. This causes race conditions due to
+ * missing locking of *var.
+ */
 int oprofilefs_ulong_from_user(unsigned long *val, char const __user *buf, size_t count)
 {
 	char tmpbuf[TMPBUFSIZE];
@@ -98,6 +108,9 @@ static ssize_t ulong_write_file(struct file *file, char const __user *buf, size_
 	if (*offset)
 		return -EINVAL;
 
+	if (!count)
+		return 0;
+
 	retval = oprofilefs_ulong_from_user(&value, buf, count);
 	if (retval)
 		return retval;
-- 
1.7.7


