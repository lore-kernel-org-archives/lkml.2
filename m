Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab0G2Mnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 08:43:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab0G2Mni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 08:43:38 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Roland McGrath <roland@redhat.com>
Subject: [RFC PATCH] core_pattern: fix long parameters was truncated by core_pattern handler
Date: Thu, 29 Jul 2010 20:42:44 +0800
Message-Id: <1280407364-32466-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We met a parameter truncated issue, consider following:
> echo "|/root/core_pattern_pipe_test %p /usr/libexec/blah-blah-blah \
%s %c %p %u %g %t 11 1234567890123456789012345678901234567890" > \
/proc/sys/kernel/core_pattern

This is okay because the strings is less than CORENAME_MAX_SIZE.
"cat /proc/sys/kernel/core_pattern" shows the whole string. but
after we run core_pattern_pipe_test in man page, we found last
parameter was truncated like below:
	argc[10]=<12345678901234567890123456789012345678>

The root cause is core_pattern allows % specifiers, which need to be
replaced during parse time, but the replace may expand the strings
to larger than CORENAME_MAX_SIZE.

This patch expands the size of parsing array, and makes the cursor
out_end shift when we replace % specifiers.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Roland McGrath <roland@redhat.com>
---
 fs/exec.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index e19de6a..e67e4b5 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1441,7 +1441,7 @@ EXPORT_SYMBOL(set_binfmt);
 
 /* format_corename will inspect the pattern parameter, and output a
  * name into corename, which must have space for at least
- * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
+ * CORENAME_MAX_SIZE * 3 bytes because of % specifiers.
  */
 static int format_corename(char *corename, long signr)
 {
@@ -1449,7 +1449,7 @@ static int format_corename(char *corename, long signr)
 	const char *pat_ptr = core_pattern;
 	int ispipe = (*pat_ptr == '|');
 	char *out_ptr = corename;
-	char *const out_end = corename + CORENAME_MAX_SIZE;
+	char *out_end = corename + CORENAME_MAX_SIZE;
 	int rc;
 	int pid_in_pattern = 0;
 
@@ -1478,6 +1478,7 @@ static int format_corename(char *corename, long signr)
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
+				out_end += rc - 2;
 				break;
 			/* uid */
 			case 'u':
@@ -1486,6 +1487,7 @@ static int format_corename(char *corename, long signr)
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
+				out_end += rc - 2;
 				break;
 			/* gid */
 			case 'g':
@@ -1494,6 +1496,7 @@ static int format_corename(char *corename, long signr)
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
+				out_end += rc - 2;
 				break;
 			/* signal that caused the coredump */
 			case 's':
@@ -1502,6 +1505,7 @@ static int format_corename(char *corename, long signr)
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
+				out_end += rc - 2;
 				break;
 			/* UNIX time of coredump */
 			case 't': {
@@ -1512,6 +1516,7 @@ static int format_corename(char *corename, long signr)
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
+				out_end += rc - 2;
 				break;
 			}
 			/* hostname */
@@ -1523,6 +1528,7 @@ static int format_corename(char *corename, long signr)
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
+				out_end += rc - 2;
 				break;
 			/* executable */
 			case 'e':
@@ -1531,6 +1537,7 @@ static int format_corename(char *corename, long signr)
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
+				out_end += rc - 2;
 				break;
 			/* core limit size */
 			case 'c':
@@ -1539,6 +1546,7 @@ static int format_corename(char *corename, long signr)
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
+				out_end += rc - 2;
 				break;
 			default:
 				break;
@@ -1836,7 +1844,7 @@ static int umh_pipe_setup(struct subprocess_info *info)
 void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 {
 	struct core_state core_state;
-	char corename[CORENAME_MAX_SIZE + 1];
+	char corename[CORENAME_MAX_SIZE * 3];
 	struct mm_struct *mm = current->mm;
 	struct linux_binfmt * binfmt;
 	const struct cred *old_cred;
-- 
1.7.2

