Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2BCLMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 06:12:39 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:45072 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab2BCLMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 06:12:37 -0500
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        avagin@openvz.org
Subject: [PATCH] ptrace: add ability to get clear_tid_address
Date: Fri,  3 Feb 2012 14:11:23 +0300
Message-Id: <1328267483-3225342-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zero is written at clear_tid_address, when the process exits.
This functionality is used by pthread_join().

sys_set_tid_address() changes this address for current task.

Before this patch clear_tid_address could not be got from user space.
I want to dump a full state of a task, so I need this address.
Also I think it may be useful for debugging a multithreading program.

I am not sure that ptrace is suitable place. It may be added in prctl,
but I think it's a bit useless and strange. I can't image a real
situation (avoid checkpointing) when a thread will want to get own
clear_tid_address from itself, this address is used by parent ussually.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 include/linux/ptrace.h |    3 +++
 kernel/ptrace.c        |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index c2f1f6a..79b84a3 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -51,6 +51,9 @@
 #define PTRACE_INTERRUPT	0x4207
 #define PTRACE_LISTEN		0x4208
 
+/* Get clear_child_tid address */
+#define PTRACE_GET_TID_ADDRESS	0x4209
+
 /* flags in @data for PTRACE_SEIZE */
 #define PTRACE_SEIZE_DEVEL	0x80000000 /* temp flag for development */
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 00ab2ca..ed7fbe7 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -845,6 +845,9 @@ int ptrace_request(struct task_struct *child, long request,
 		break;
 	}
 #endif
+	case PTRACE_GET_TID_ADDRESS:
+		return put_user(child->clear_child_tid, (int __user **) data);
+
 	default:
 		break;
 	}
-- 
1.7.1

