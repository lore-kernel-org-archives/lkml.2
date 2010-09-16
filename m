Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab0IPTAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:00:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36869 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab0IPTAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:00:45 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>, Andi Kleen <andi@firstfloor.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
        Will Drewry <wad@chromium.org>
Subject: [PATCH][RFC] fs/exec.c: provide the correct process pid to the pipe helper
Date: Thu, 16 Sep 2010 13:59:59 -0500
Message-Id: <1284663599-3549-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

format_corename uses task_tgid_vnr to provide the numeric pid of a
core-dumping process.  For file-based coredumps, this is perfectly
satisfactory.  However, when the core_pattern contains a pipe, the
substituted PID is invalid in the namespace of the core_pattern pipe
helper, the init namespace.

By changing this, any core collector may now find the process in the
init namespace /proc.  This helps with VFS namespacing too since the
mount root is available via /proc.  Unfortunately, it does not help in
cases of more complex namespacing, like net namespaces.  For that, the
helper thread will need to be migrated to the core-dump namespaces.

I have a separate patch series which implements migrating the
____call_usermodehelper thread to the coredump namespace, but it adds a
fair amount of complexity which might be better handled by someone who
understands that code.  I'm happy to mail it out as well though (it
works, but I don't assign a namespaced pid which may open up issues on
its own).

Any and all comments, feedback will be appreciated!

Signed-off-by: Will Drewry <wad@chromium.org>
---
 fs/exec.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 828dd24..0b8a874 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1467,6 +1467,13 @@ static int format_corename(char *corename, long signr)
 	char *const out_end = corename + CORENAME_MAX_SIZE;
 	int rc;
 	int pid_in_pattern = 0;
+	pid_t pid = task_tgid_vnr(current);
+
+	/* The pipe helper runs in the init namespace and should
+	 * receive the matching pid until that changes.
+	 */
+	if (ispipe)
+		pid = task_tgid_nr(current);
 
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
@@ -1489,7 +1496,7 @@ static int format_corename(char *corename, long signr)
 			case 'p':
 				pid_in_pattern = 1;
 				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%d", task_tgid_vnr(current));
+					      "%d", pid);
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
@@ -1568,7 +1575,7 @@ static int format_corename(char *corename, long signr)
 	 * the filename. Do not do this for piped commands. */
 	if (!ispipe && !pid_in_pattern && core_uses_pid) {
 		rc = snprintf(out_ptr, out_end - out_ptr,
-			      ".%d", task_tgid_vnr(current));
+			      ".%d", pid);
 		if (rc > out_end - out_ptr)
 			goto out;
 		out_ptr += rc;
-- 
1.7.0.4

