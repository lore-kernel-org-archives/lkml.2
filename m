Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1LTI6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 03:58:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52302 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab1LTI5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 03:57:51 -0500
Date: Tue, 20 Dec 2011 00:57:11 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-913050b91eb94f194392dd797b1ff3779f606ac0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        stable@vger.kernel.org, robert.richter@amd.com,
        oprofile-list@lists.sourceforge.net, akpm@linux-foundation.org,
        tglx@linutronix.de, mikew@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, robert.richter@amd.com,
        oprofile-list@lists.sourceforge.net, akpm@linux-foundation.org,
        mikew@google.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111219153830.GH16765@erda.amd.com>
References: <20111219153830.GH16765@erda.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] oprofile:
  Fix uninitialized memory access when writing to writing to oprofilefs
Git-Commit-ID: 913050b91eb94f194392dd797b1ff3779f606ac0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 20 Dec 2011 00:57:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  913050b91eb94f194392dd797b1ff3779f606ac0
Gitweb:     http://git.kernel.org/tip/913050b91eb94f194392dd797b1ff3779f606ac0
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 19 Dec 2011 16:38:30 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 19 Dec 2011 17:18:43 +0100

oprofile: Fix uninitialized memory access when writing to writing to oprofilefs

If oprofilefs_ulong_from_user() is called with count equals
zero, *val remains unchanged. Depending on the implementation it
might be uninitialized.

Change oprofilefs_ulong_from_user()'s interface to return count
on success. Thus, we are able to return early if count equals
zero which avoids using *val uninitialized. Fixing all users of
oprofilefs_ulong_ from_user().

This follows write syscall implementation when count is zero:
"If count is zero ... [and if] no errors are detected, 0 will be
returned without causing any other effect." (man 2 write)

Reported-By: Mike Waychison <mikew@google.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Cc: oprofile-list <oprofile-list@lists.sourceforge.net>
Link: http://lkml.kernel.org/r/20111219153830.GH16765@erda.amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
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
