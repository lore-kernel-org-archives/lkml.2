Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab1I0Wbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 18:31:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab1I0Wb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 18:31:27 -0400
From: Doug Ledford <dledford@redhat.com>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, joe.korty@ccur.com, amwang@redhat.com,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 4/4] ipc/mqueue: update maximums for the mqueue subsystem
Date: Tue, 27 Sep 2011 18:30:13 -0400
Message-Id: <1317162613-11060-5-git-send-email-dledford@redhat.com>
In-Reply-To: <1317162613-11060-1-git-send-email-dledford@redhat.com>
References: <1317162613-11060-1-git-send-email-dledford@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b231cca4381ee15ec99afbfb244fbc0324869927 changed
the maximum size of a message in a message queue from
INT_MAX to 8192*128.  Unfortunately, we had customers
that relied on a size much larger than 8192*128 on their
production systems.  After reviewing POSIX, we found that
it is silent on the maximum message size.  We did find
a couple other areas in which it was not silent.  Fix up
the mqueue maximums so that the customer's system can
continue to work, and document both the POSIX and real
world requirements in ipc_namespace.h so that we don't
have this issue crop back up.

Also, commit 9cf18e1dd74cd0061d58ac55029784ca3dd88f6a
fiddled with HARD_MSGMAX without realizing that the
number was intentionally in place to limit the msg
queue depth to one that was small enough to kmalloc
an array of pointers (hence why we divided 128k by
sizeof(long)).  If we wish to meet POSIX requirements,
we have no choice but to change our allocation to
a vmalloc instead (at least for the large queue size
case).  With that, it's possible to increase our
allowed maximum to the POSIX requirements (or more if
we choose).

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 include/linux/ipc_namespace.h |   47 ++++++++++++++++++++++++++++++----------
 ipc/mqueue.c                  |   10 +++++++-
 2 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index bde094e..ceeef68 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -90,18 +90,41 @@ static inline void shm_destroy_orphaned(struct ipc_namespace *ns) {}
 
 #ifdef CONFIG_POSIX_MQUEUE
 extern int mq_init_ns(struct ipc_namespace *ns);
-/* default values */
-#define MIN_QUEUESMAX  1
-#define DFLT_QUEUESMAX 256     /* max number of message queues */
-#define HARD_QUEUESMAX 1024
-#define MIN_MSGMAX     1
-#define DFLT_MSG       10U
-#define DFLT_MSGMAX    10      /* max number of messages in each queue */
-#define HARD_MSGMAX    (32768*sizeof(void *)/4)
-#define MIN_MSGSIZEMAX  128
-#define DFLT_MSGSIZE    8192U
-#define DFLT_MSGSIZEMAX 8192   /* max message size */
-#define HARD_MSGSIZEMAX (8192*128)
+/*
+ * POSIX Message Queue default values:
+ *
+ * MIN_*: Lowest value an admin can set the maximum unprivileged limit to
+ * DFLT_*MAX: Default values for the maximum unprivileged limits
+ * DFLT_{MSG,MSGSIZE}: Default values used when the user doesn't supply
+ *   an attribute to the open call and the queue must be created
+ * HARD_*: Highest value the maximums can be set to.  These are enforced
+ *   on CAP_SYS_RESOURCE apps as well making them inviolate (so make them
+ *   suitably high)
+ *
+ * POSIX Requirements:
+ *   Per app minimum openable message queues - 8.  This does not map well
+ *     to the fact that we limit the number of queues on a per namespace
+ *     basis instead of a per app basis.  So, make the default high enough
+ *     that no given app should have a hard time opening 8 queues.
+ *   Minimum maximum for HARD_MSGMAX - 32767.  I bumped this to 65536.
+ *   Minimum maximum for HARD_MSGSIZEMAX - POSIX is silent on this.  However,
+ *     we have run into a situation where running applications in the wild
+ *     require this to be at least 5MB, and preferably 10MB, so I set the
+ *     value to 16MB in hopes that this user is the worst of the bunch and
+ *     the new maximum will handle anyone else.  I may have to revisit this
+ *     in the future.
+ */
+#define MIN_QUEUESMAX			1
+#define DFLT_QUEUESMAX		      256
+#define HARD_QUEUESMAX		     1024
+#define MIN_MSGMAX			1
+#define DFLT_MSG		       64U
+#define DFLT_MSGMAX		     1024
+#define HARD_MSGMAX		    65536
+#define MIN_MSGSIZEMAX		      128
+#define DFLT_MSGSIZE		     8192U
+#define DFLT_MSGSIZEMAX		1024*1024
+#define HARD_MSGSIZEMAX	     16*1024*1024
 #else
 static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
 #endif
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 7cda828..0474ddb 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -150,7 +150,10 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 			info->attr.mq_msgsize = attr->mq_msgsize;
 		}
 		mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
-		info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
+		if (mq_msg_tblsz > KMALLOC_MAX_SIZE)
+			info->messages = vmalloc(mq_msg_tblsz);
+		else
+			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
 		if (!info->messages)
 			goto out_inode;
 
@@ -271,7 +274,10 @@ static void mqueue_evict_inode(struct inode *inode)
 	spin_lock(&info->lock);
 	for (i = 0; i < info->attr.mq_curmsgs; i++)
 		free_msg(info->messages[i]);
-	kfree(info->messages);
+	if (info->attr.mq_maxmsg * sizeof(struct msg_msg *) > KMALLOC_MAX_SIZE)
+		vfree(info->messages);
+	else
+		kfree(info->messages);
 	spin_unlock(&info->lock);
 
 	/* Total amount of bytes accounted for the mqueue */
-- 
1.7.6

