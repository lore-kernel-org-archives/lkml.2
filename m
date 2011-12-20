Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab1LTTQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:16:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53390 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab1LTTQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:16:49 -0500
Date: Tue, 20 Dec 2011 20:14:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] oprofile fix
Message-ID: <20111220191454.GA13415@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

 Thanks,

	Ingo

------------------>
Robert Richter (1):
      oprofile: Fix uninitialized memory access when writing to writing to oprofilefs


 arch/s390/oprofile/init.c         |    2 +-
 drivers/oprofile/oprofile_files.c |    7 ++++---
 drivers/oprofile/oprofilefs.c     |   11 +++++++++--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index 6efc18b..bd58b72 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -88,7 +88,7 @@ static ssize_t hwsampler_write(struct file *file, char const __user *buf,
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	if (oprofile_started)
diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
index 89f6345..84a208d 100644
--- a/drivers/oprofile/oprofile_files.c
+++ b/drivers/oprofile/oprofile_files.c
@@ -45,7 +45,7 @@ static ssize_t timeout_write(struct file *file, char const __user *buf,
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	retval = oprofile_set_timeout(val);
@@ -84,7 +84,7 @@ static ssize_t depth_write(struct file *file, char const __user *buf, size_t cou
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	retval = oprofile_set_ulong(&oprofile_backtrace_depth, val);
@@ -141,9 +141,10 @@ static ssize_t enable_write(struct file *file, char const __user *buf, size_t co
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
+	retval = 0;
 	if (val)
 		retval = oprofile_start();
 	else
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index d0de6cc..2f0aa0f 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -60,6 +60,13 @@ ssize_t oprofilefs_ulong_to_user(unsigned long val, char __user *buf, size_t cou
 }
 
 
+/*
+ * Note: If oprofilefs_ulong_from_user() returns 0, then *val remains
+ * unchanged and might be uninitialized. This follows write syscall
+ * implementation when count is zero: "If count is zero ... [and if]
+ * no errors are detected, 0 will be returned without causing any
+ * other effect." (man 2 write)
+ */
 int oprofilefs_ulong_from_user(unsigned long *val, char const __user *buf, size_t count)
 {
 	char tmpbuf[TMPBUFSIZE];
@@ -79,7 +86,7 @@ int oprofilefs_ulong_from_user(unsigned long *val, char const __user *buf, size_
 	raw_spin_lock_irqsave(&oprofilefs_lock, flags);
 	*val = simple_strtoul(tmpbuf, NULL, 0);
 	raw_spin_unlock_irqrestore(&oprofilefs_lock, flags);
-	return 0;
+	return count;
 }
 
 
@@ -99,7 +106,7 @@ static ssize_t ulong_write_file(struct file *file, char const __user *buf, size_
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&value, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	retval = oprofile_set_ulong(file->private_data, value);
