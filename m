Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2E3PYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:24:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45789 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2E3PYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:24:15 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>
Cc: linux-kernel@vger.kernel.org, Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH v2] prctl: Removed redunant assignment of "error" to zero
Date: Wed, 30 May 2012 20:57:24 +0530
Message-Id: <1338391644-26777-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just setting the "error" to error number is enough on failure and
It doesn't require to set "error" variable to zero in each switch case, since
it was already initialized with zero. And also removed return 0 in switch case
with break statement

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 kernel/sys.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 6df4262..fd52619 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1920,7 +1920,6 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 				break;
 			}
 			me->pdeath_signal = arg2;
-			error = 0;
 			break;
 		case PR_GET_PDEATHSIG:
 			error = put_user(me->pdeath_signal, (int __user *)arg2);
@@ -1934,7 +1933,6 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 				break;
 			}
 			set_dumpable(me->mm, arg2);
-			error = 0;
 			break;
 
 		case PR_SET_UNALIGN:
@@ -1961,10 +1959,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		case PR_SET_TIMING:
 			if (arg2 != PR_TIMING_STATISTICAL)
 				error = -EINVAL;
-			else
-				error = 0;
 			break;
-
 		case PR_SET_NAME:
 			comm[sizeof(me->comm)-1] = 0;
 			if (strncpy_from_user(comm, (char __user *)arg2,
@@ -1972,20 +1967,19 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 				return -EFAULT;
 			set_task_comm(me, comm);
 			proc_comm_connector(me);
-			return 0;
+			break;
 		case PR_GET_NAME:
 			get_task_comm(comm, me);
 			if (copy_to_user((char __user *)arg2, comm,
 					 sizeof(comm)))
 				return -EFAULT;
-			return 0;
+			break;
 		case PR_GET_ENDIAN:
 			error = GET_ENDIAN(me, arg2);
 			break;
 		case PR_SET_ENDIAN:
 			error = SET_ENDIAN(me, arg2);
 			break;
-
 		case PR_GET_SECCOMP:
 			error = prctl_get_seccomp();
 			break;
@@ -2013,7 +2007,6 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 					current->default_timer_slack_ns;
 			else
 				current->timer_slack_ns = arg2;
-			error = 0;
 			break;
 		case PR_MCE_KILL:
 			if (arg4 | arg5)
@@ -2039,7 +2032,6 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			default:
 				return -EINVAL;
 			}
-			error = 0;
 			break;
 		case PR_MCE_KILL_GET:
 			if (arg2 | arg3 | arg4 | arg5)
@@ -2055,7 +2047,6 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			break;
 		case PR_SET_CHILD_SUBREAPER:
 			me->signal->is_child_subreaper = !!arg2;
-			error = 0;
 			break;
 		case PR_GET_CHILD_SUBREAPER:
 			error = put_user(me->signal->is_child_subreaper,
-- 
1.7.3.4

