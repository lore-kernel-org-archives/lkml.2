Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab1LPKrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:47:16 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:48164 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab1LPKrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:47:05 -0500
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/2] ptrace: add ability to attach a file descriptor to another task
Date: Fri, 16 Dec 2011 13:46:23 +0300
Message-Id: <1324032383-791758-3-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1324032383-791758-1-git-send-email-avagin@openvz.org>
References: <1324032383-791758-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 include/linux/ptrace.h |    1 +
 kernel/ptrace.c        |   27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 800f113..8439ce9 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -50,6 +50,7 @@
 #define PTRACE_SEIZE		0x4206
 #define PTRACE_INTERRUPT	0x4207
 #define PTRACE_LISTEN		0x4208
+#define PTRACE_DUPFD		0x4209
 
 /* flags in @data for PTRACE_SEIZE */
 #define PTRACE_SEIZE_DEVEL	0x80000000 /* temp flag for development */
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 24d0447..a646d01 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -24,6 +24,7 @@
 #include <linux/regset.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/cn_proc.h>
+#include <linux/file.h>
 
 
 static int ptrace_trapping_sleep_fn(void *flags)
@@ -826,6 +827,32 @@ int ptrace_request(struct task_struct *child, long request,
 		break;
 	}
 #endif
+	case PTRACE_DUPFD:
+	{
+		struct file *file = fget_raw(data);
+		ret = -EBADF;
+
+		if (!file)
+			break;
+
+		task_lock(child);
+		if (!child->files)
+			goto out_getfd;
+
+		ret = alloc_task_fd(child, 0, 0);
+		if (ret < 0) {
+			fput(file);
+			goto out_getfd;
+		}
+
+		fd_task_install(child, ret, file);
+
+out_getfd:
+		task_unlock(child);
+
+		break;
+	}
+
 	default:
 		break;
 	}
-- 
1.7.1

