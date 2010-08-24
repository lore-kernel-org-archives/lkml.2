Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0HXJnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:43:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab0HXJnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:43:09 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org
Cc: nhorman@tuxdriver.com, linux-kernel@vger.kernel.org,
        Xiaotian Feng <dfeng@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>
Subject: [PATCH v4] core_pattern: fix long parameters was truncated by core_pattern handler
Date: Tue, 24 Aug 2010 17:42:46 +0800
Message-Id: <1282642966-2296-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <20100823141843.f177bf1f.akpm@linux-foundation.org>
References: <20100823141843.f177bf1f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We met a parameter truncated issue, consider following:
> > echo "|/root/core_pattern_pipe_test %p /usr/libexec/blah-blah-blah \
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

Changes since v3:
make handling of single char also uses cn_printf, suggested by Andrew Morton.

Changes since v2:
Introduced generic function cn_printf and make format_corename remember the time
has been expanded, suggested by Olg Nesterov and Neil Horman.

Changes since v1:
This patch allocates corename at runtime, if the replace doesn't have enough
memory, expand the corename dynamically, suggested by Neil Horman.

I've tested with some core_pattern strings, it works fine now.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Roland McGrath <roland@redhat.com>
---
 fs/exec.c |  158 +++++++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 97 insertions(+), 61 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 2d94552..0151923 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -65,6 +65,12 @@ char core_pattern[CORENAME_MAX_SIZE] = "core";
 unsigned int core_pipe_limit;
 int suid_dumpable = 0;
 
+struct core_name {
+	char *corename;
+	int used, size;
+};
+static atomic_t call_count = ATOMIC_INIT(1);
+
 /* The maximal length of core_pattern is also specified in sysctl.c */
 
 static LIST_HEAD(formats);
@@ -1440,127 +1446,149 @@ void set_binfmt(struct linux_binfmt *new)
 
 EXPORT_SYMBOL(set_binfmt);
 
+static int expand_corename(struct core_name *cn)
+{
+	char *old_corename = cn->corename;
+
+	cn->size = CORENAME_MAX_SIZE * atomic_inc_return(&call_count);
+	cn->corename = krealloc(old_corename, cn->size, GFP_KERNEL);
+
+	if (!cn->corename) {
+		kfree(old_corename);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int cn_printf(struct core_name *cn, const char *fmt, ...)
+{
+	char *cur;
+	int need;
+	int ret;
+	va_list arg;
+
+	va_start(arg, fmt);
+	need = vsnprintf(NULL, 0, fmt, arg);
+	va_end(arg);
+
+	if (likely(need < cn->size - cn->used))
+		goto out_printf;
+
+	ret = expand_corename(cn);
+	if (ret)
+		goto expand_fail;
+
+out_printf:
+	cur = cn->corename + cn->used;
+	va_start(arg, fmt);
+	vsnprintf(cur, need + 1, fmt, arg);
+	va_end(arg);
+	cn->used += need;
+	return 0;
+
+expand_fail:
+	return ret;
+}
+
 /* format_corename will inspect the pattern parameter, and output a
  * name into corename, which must have space for at least
  * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
  */
-static int format_corename(char *corename, long signr)
+static int format_corename(struct core_name *cn, long signr)
 {
 	const struct cred *cred = current_cred();
 	const char *pat_ptr = core_pattern;
 	int ispipe = (*pat_ptr == '|');
-	char *out_ptr = corename;
-	char *const out_end = corename + CORENAME_MAX_SIZE;
-	int rc;
 	int pid_in_pattern = 0;
+	int err = 0;
+
+	cn->size = CORENAME_MAX_SIZE * atomic_read(&call_count);
+	cn->corename = kmalloc(cn->size, GFP_KERNEL);
+	cn->used = 0;
+
+	if (!cn->corename)
+		return -ENOMEM;
 
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
 	while (*pat_ptr) {
 		if (*pat_ptr != '%') {
-			if (out_ptr == out_end)
-				goto out;
-			*out_ptr++ = *pat_ptr++;
+			err = cn_printf(cn, "%c", *pat_ptr++);
 		} else {
 			switch (*++pat_ptr) {
+			/* single % at the end, drop that */
 			case 0:
+				err = cn_printf(cn, "%c", '\0');
+				if (err)
+					break;
 				goto out;
 			/* Double percent, output one percent */
 			case '%':
-				if (out_ptr == out_end)
-					goto out;
-				*out_ptr++ = '%';
+				err = cn_printf(cn, "%c", '%');
 				break;
 			/* pid */
 			case 'p':
 				pid_in_pattern = 1;
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", task_tgid_vnr(current));
-				if (rc > out_end - out_ptr)
-					goto out;
-				out_ptr += rc;
+				err = cn_printf(cn, "%d",
+					      task_tgid_vnr(current));
 				break;
 			/* uid */
 			case 'u':
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", cred->uid);
-				if (rc > out_end - out_ptr)
-					goto out;
-				out_ptr += rc;
+				err = cn_printf(cn, "%d", cred->uid);
 				break;
 			/* gid */
 			case 'g':
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", cred->gid);
-				if (rc > out_end - out_ptr)
-					goto out;
-				out_ptr += rc;
+				err = cn_printf(cn, "%d", cred->gid);
 				break;
 			/* signal that caused the coredump */
 			case 's':
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%ld", signr);
-				if (rc > out_end - out_ptr)
-					goto out;
-				out_ptr += rc;
+				err = cn_printf(cn, "%ld", signr);
 				break;
 			/* UNIX time of coredump */
 			case 't': {
 				struct timeval tv;
 				do_gettimeofday(&tv);
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%lu", tv.tv_sec);
-				if (rc > out_end - out_ptr)
-					goto out;
-				out_ptr += rc;
+				err = cn_printf(cn, "%lu", tv.tv_sec);
 				break;
 			}
 			/* hostname */
 			case 'h':
 				down_read(&uts_sem);
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%s", utsname()->nodename);
+				err = cn_printf(cn, "%s",
+					      utsname()->nodename);
 				up_read(&uts_sem);
-				if (rc > out_end - out_ptr)
-					goto out;
-				out_ptr += rc;
 				break;
 			/* executable */
 			case 'e':
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%s", current->comm);
-				if (rc > out_end - out_ptr)
-					goto out;
-				out_ptr += rc;
+				err = cn_printf(cn, "%s", current->comm);
 				break;
 			/* core limit size */
 			case 'c':
-				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%lu", rlimit(RLIMIT_CORE));
-				if (rc > out_end - out_ptr)
-					goto out;
-				out_ptr += rc;
+				err = cn_printf(cn, "%lu",
+					      rlimit(RLIMIT_CORE));
 				break;
 			default:
 				break;
 			}
 			++pat_ptr;
 		}
+
+		if (err)
+			return err;
 	}
+
 	/* Backward compatibility with core_uses_pid:
 	 *
 	 * If core_pattern does not include a %p (as is the default)
 	 * and core_uses_pid is set, then .%pid will be appended to
 	 * the filename. Do not do this for piped commands. */
 	if (!ispipe && !pid_in_pattern && core_uses_pid) {
-		rc = snprintf(out_ptr, out_end - out_ptr,
-			      ".%d", task_tgid_vnr(current));
-		if (rc > out_end - out_ptr)
-			goto out;
-		out_ptr += rc;
+		err = cn_printf(cn, ".%d", task_tgid_vnr(current));
+		if (err)
+			return err;
 	}
 out:
-	*out_ptr = 0;
 	return ispipe;
 }
 
@@ -1837,7 +1865,7 @@ static int umh_pipe_setup(struct subprocess_info *info)
 void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 {
 	struct core_state core_state;
-	char corename[CORENAME_MAX_SIZE + 1];
+	struct core_name cn;
 	struct mm_struct *mm = current->mm;
 	struct linux_binfmt * binfmt;
 	const struct cred *old_cred;
@@ -1892,7 +1920,13 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	 */
 	clear_thread_flag(TIF_SIGPENDING);
 
-	ispipe = format_corename(corename, signr);
+	ispipe = format_corename(&cn, signr);
+
+	if (ispipe == -ENOMEM) {
+		printk(KERN_WARNING "format_corename failed\n");
+		printk(KERN_WARNING "Aborting core\n");
+		goto fail_corename;
+	}
 
  	if (ispipe) {
 		int dump_count;
@@ -1929,7 +1963,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 			goto fail_dropcount;
 		}
 
-		helper_argv = argv_split(GFP_KERNEL, corename+1, NULL);
+		helper_argv = argv_split(GFP_KERNEL, cn.corename+1, NULL);
 		if (!helper_argv) {
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
@@ -1942,7 +1976,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		argv_free(helper_argv);
 		if (retval) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
-			       corename);
+			       cn.corename);
 			goto close_fail;
  		}
 	} else {
@@ -1951,7 +1985,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		if (cprm.limit < binfmt->min_coredump)
 			goto fail_unlock;
 
-		cprm.file = filp_open(corename,
+		cprm.file = filp_open(cn.corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
 		if (IS_ERR(cprm.file))
@@ -1993,6 +2027,8 @@ fail_dropcount:
 	if (ispipe)
 		atomic_dec(&core_dump_count);
 fail_unlock:
+	kfree(cn.corename);
+fail_corename:
 	coredump_finish(mm);
 	revert_creds(old_cred);
 fail_creds:
-- 
1.7.2.1

