Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0HBMYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:24:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403Ab0HBMYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:24:24 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Roland McGrath <roland@redhat.com>
Subject: [RFC PATCH V2] core_pattern: fix long parameters was truncated by core_pattern handler
Date: Mon,  2 Aug 2010 20:23:56 +0800
Message-Id: <1280751836-1826-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <20100729130707.GA31154@shamino.rdu.redhat.com>
References: <20100729130707.GA31154@shamino.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We met a parameter truncated issue, consider following:
> echo "|/root/core_pattern_pipe_test %p /usr/libexec/blah-blah-blah \
%s %c %p %u %g 11 12345678901234567890123456789012345678 %t" > \
/proc/sys/kernel/core_pattern

This is okay because the strings is less than CORENAME_MAX_SIZE.
"cat /proc/sys/kernel/core_pattern" shows the whole string. but
after we run core_pattern_pipe_test in man page, we found last
parameter was truncated like below:
        argc[10]=<12807486>

The root cause is core_pattern allows % specifiers, which need to be
replaced during parse time, but the replace may expand the strings
to larger than CORENAME_MAX_SIZE. So if the last parameter is %
specifiers, the replace code is using snprintf(out_ptr, out_end - out_ptr, ...),
this will write out of corename array.

This patch allocates corename at runtime, if the replace doesn't have enough
memory, expand the corename dynamically.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Roland McGrath <roland@redhat.com>
---
 fs/exec.c |  194 ++++++++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 142 insertions(+), 52 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index e19de6a..d9e1e4f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1439,26 +1439,56 @@ void set_binfmt(struct linux_binfmt *new)
 
 EXPORT_SYMBOL(set_binfmt);
 
+static int expand_corename(char **corename, char **out_end,
+			   char **out_ptr, int *size)
+{
+	unsigned long ptr_offset;
+	char *old_corename = *corename;
+
+	(*size)++;
+	ptr_offset = *out_ptr - *corename;
+	*corename = krealloc(*corename, *size * CORENAME_MAX_SIZE,
+			     GFP_KERNEL);
+
+	if (*corename == NULL) {
+		kfree(old_corename);
+		return -ENOMEM;
+	}
+
+	*out_end = *corename + *size * CORENAME_MAX_SIZE - 1;
+	*out_ptr = *corename + ptr_offset;
+	return 0;
+}
 /* format_corename will inspect the pattern parameter, and output a
- * name into corename, which must have space for at least
- * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
+ * name into corename, which will be allocated at runtime.
  */
-static int format_corename(char *corename, long signr)
+static int format_corename(char **corename, long signr)
 {
 	const struct cred *cred = current_cred();
 	const char *pat_ptr = core_pattern;
 	int ispipe = (*pat_ptr == '|');
-	char *out_ptr = corename;
-	char *const out_end = corename + CORENAME_MAX_SIZE;
-	int rc;
+	char *out_ptr, *out_end, *old_corename;
+	int size = 1;
+	int rc, ret;
 	int pid_in_pattern = 0;
 
+	*corename = kmalloc(CORENAME_MAX_SIZE, GFP_KERNEL);
+	if (*corename == NULL)
+		return -ENOMEM;
+
+	old_corename = *corename;
+	out_ptr = *corename;
+	out_end = *corename + CORENAME_MAX_SIZE - 1;
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
 	while (*pat_ptr) {
 		if (*pat_ptr != '%') {
-			if (out_ptr == out_end)
-				goto out;
+			if (out_ptr == out_end) {
+				ret = expand_corename(corename, &out_end,
+						      &out_ptr, &size);
+				if (ret)
+					return ret;
+			}
 			*out_ptr++ = *pat_ptr++;
 		} else {
 			switch (*++pat_ptr) {
@@ -1466,78 +1496,126 @@ static int format_corename(char *corename, long signr)
 				goto out;
 			/* Double percent, output one percent */
 			case '%':
-				if (out_ptr == out_end)
-					goto out;
 				*out_ptr++ = '%';
 				break;
 			/* pid */
 			case 'p':
 				pid_in_pattern = 1;
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", task_tgid_vnr(current));
-				if (rc > out_end - out_ptr)
-					goto out;
+				rc = snprintf(NULL, 0, "%d",
+					      task_tgid_vnr(current));
+				if (rc > out_end - out_ptr) {
+					ret = expand_corename(corename,
+							      &out_end,
+							      &out_ptr, &size);
+					if (ret)
+						return ret;
+				}
+				rc = snprintf(out_ptr, rc + 1, "%d",
+					      task_tgid_vnr(current));
 				out_ptr += rc;
 				break;
 			/* uid */
 			case 'u':
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", cred->uid);
-				if (rc > out_end - out_ptr)
-					goto out;
+				rc = snprintf(NULL, 0, "%d", cred->uid);
+				if (rc > out_end - out_ptr) {
+					ret = expand_corename(corename,
+							      &out_end,
+							      &out_ptr, &size);
+					if (ret)
+						return ret;
+				}
+				rc = snprintf(out_ptr, rc + 1, "%d", cred->uid);
 				out_ptr += rc;
 				break;
 			/* gid */
 			case 'g':
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", cred->gid);
-				if (rc > out_end - out_ptr)
-					goto out;
+				rc = snprintf(NULL, 0, "%d", cred->gid);
+				if (rc > out_end - out_ptr) {
+					ret = expand_corename(corename,
+							      &out_end,
+							      &out_ptr, &size);
+					if (ret)
+						return ret;
+				}
+				rc = snprintf(out_ptr, rc + 1, "%d", cred->gid);
 				out_ptr += rc;
 				break;
 			/* signal that caused the coredump */
 			case 's':
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%ld", signr);
-				if (rc > out_end - out_ptr)
-					goto out;
+				rc = snprintf(NULL, 0, "%ld", signr);
+				if (rc > out_end - out_ptr) {
+					ret = expand_corename(corename,
+							      &out_end,
+							      &out_ptr, &size);
+					if (ret == -ENOMEM)
+						return ret;
+				}
+				rc = snprintf(out_ptr, rc + 1, "%ld", signr);
 				out_ptr += rc;
 				break;
 			/* UNIX time of coredump */
 			case 't': {
 				struct timeval tv;
 				do_gettimeofday(&tv);
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%lu", tv.tv_sec);
-				if (rc > out_end - out_ptr)
-					goto out;
+				rc = snprintf(NULL, 0, "%lu", tv.tv_sec);
+				if (rc > out_end - out_ptr) {
+					ret = expand_corename(corename,
+							      &out_end,
+							      &out_ptr, &size);
+					if (ret)
+						return ret;
+				}
+				rc = snprintf(out_ptr, rc + 1, "%lu",
+					      tv.tv_sec);
 				out_ptr += rc;
 				break;
 			}
 			/* hostname */
 			case 'h':
 				down_read(&uts_sem);
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%s", utsname()->nodename);
+				rc = snprintf(NULL, 0, "%s",
+					      utsname()->nodename);
+				up_read(&uts_sem);
+				if (rc > out_end - out_ptr) {
+					ret = expand_corename(corename,
+							      &out_end,
+							      &out_ptr, &size);
+					if (ret)
+						return ret;
+				}
+				down_read(&uts_sem);
+				rc = snprintf(out_ptr, rc + 1, "%s",
+					      utsname()->nodename);
 				up_read(&uts_sem);
-				if (rc > out_end - out_ptr)
-					goto out;
 				out_ptr += rc;
 				break;
 			/* executable */
 			case 'e':
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%s", current->comm);
-				if (rc > out_end - out_ptr)
-					goto out;
+				rc = snprintf(NULL, 0, "%s", current->comm);
+				if (rc > out_end - out_ptr) {
+					ret = expand_corename(corename,
+							      &out_end,
+							      &out_ptr, &size);
+					if (ret)
+						return ret;
+				}
+				rc = snprintf(out_ptr, rc + 1, "%s",
+					      current->comm);
 				out_ptr += rc;
 				break;
 			/* core limit size */
 			case 'c':
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%lu", rlimit(RLIMIT_CORE));
-				if (rc > out_end - out_ptr)
-					goto out;
+				rc = snprintf(NULL, 0, "%lu",
+					      rlimit(RLIMIT_CORE));
+				if (rc > out_end - out_ptr) {
+					ret = expand_corename(corename,
+							      &out_end,
+							      &out_ptr, &size);
+					if (ret == -ENOMEM)
+						return ret;
+				}
+				rc = snprintf(out_ptr, rc + 1, "%lu",
+					      rlimit(RLIMIT_CORE));
 				out_ptr += rc;
 				break;
 			default:
@@ -1552,10 +1630,14 @@ static int format_corename(char *corename, long signr)
 	 * and core_uses_pid is set, then .%pid will be appended to
 	 * the filename. Do not do this for piped commands. */
 	if (!ispipe && !pid_in_pattern && core_uses_pid) {
-		rc = snprintf(out_ptr, out_end - out_ptr,
-			      ".%d", task_tgid_vnr(current));
-		if (rc > out_end - out_ptr)
-			goto out;
+		rc = snprintf(NULL, 0, ".%d", task_tgid_vnr(current));
+		if (rc > out_end - out_ptr) {
+			ret = expand_corename(corename, &out_end, &out_ptr,
+					      &size);
+			if (ret == -ENOMEM)
+				return ret;
+		}
+		rc = snprintf(out_ptr, rc + 1, "%d", task_tgid_vnr(current));
 		out_ptr += rc;
 	}
 out:
@@ -1836,7 +1918,7 @@ static int umh_pipe_setup(struct subprocess_info *info)
 void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 {
 	struct core_state core_state;
-	char corename[CORENAME_MAX_SIZE + 1];
+	char *corename;
 	struct mm_struct *mm = current->mm;
 	struct linux_binfmt * binfmt;
 	const struct cred *old_cred;
@@ -1895,11 +1977,17 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	 * lock_kernel() because format_corename() is controlled by sysctl, which
 	 * uses lock_kernel()
 	 */
- 	lock_kernel();
-	ispipe = format_corename(corename, signr);
+	lock_kernel();
+	ispipe = format_corename(&corename, signr);
 	unlock_kernel();
 
- 	if (ispipe) {
+	if (ispipe == -ENOMEM) {
+		printk(KERN_WARNING "format_corename failed\n");
+		printk(KERN_WARNING "Aborting core\n");
+		goto fail_corename;
+	}
+
+	if (ispipe) {
 		int dump_count;
 		char **helper_argv;
 
@@ -1946,10 +2034,10 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 					NULL, &cprm);
 		argv_free(helper_argv);
 		if (retval) {
- 			printk(KERN_INFO "Core dump to %s pipe failed\n",
+			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
 			goto close_fail;
- 		}
+		}
 	} else {
 		struct inode *inode;
 
@@ -1998,6 +2086,8 @@ fail_dropcount:
 	if (ispipe)
 		atomic_dec(&core_dump_count);
 fail_unlock:
+	kfree(corename);
+fail_corename:
 	coredump_finish(mm);
 	revert_creds(old_cred);
 fail_creds:
-- 
1.7.2

