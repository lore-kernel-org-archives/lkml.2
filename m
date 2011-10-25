Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab1JYCkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 22:40:33 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33840 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab1JYCkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 22:40:32 -0400
Message-ID: <4EA621AD.2040200@gmail.com>
Date: Mon, 24 Oct 2011 22:40:45 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        dledford@redhat.com, amwang@redhat.com, serue@us.ibm.com,
        jslaby@suse.cz, joe.korty@ccur.com
Subject: [PATCH 2/3] ipc/mqueue: bump up mqueue hard coded limit
References: <4EA61FC5.4010500@gmail.com>
In-Reply-To: <4EA61FC5.4010500@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quote from Doug's original patch:
    Commit b231cca4381ee ("message queues: increase range limits") changed the
    maximum size of a message in a message queue from INT_MAX to 8192*128.
    Unfortunately, we had customers that relied on a size much larger than
    8192*128 on their production systems.  After reviewing POSIX, we found
    that it is silent on the maximum message size.  We did find a couple other
    areas in which it was not silent.  Fix up the mqueue maximums so that the
    customer's system can continue to work, and document both the POSIX and
    real world requirements in ipc_namespace.h so that we don't have this
    issue crop back up.

    Also, commit 9cf18e1dd74c ("ipc: HARD_MSGMAX should be higher not lower on
    64bit") fiddled with HARD_MSGMAX without realizing that the number was
    intentionally in place to limit the msg queue depth to one that was small
    enough to kmalloc an array of pointers (hence why we divided 128k by
    sizeof(long)).  If we wish to meet POSIX requirements, we have no choice
    but to change our allocation to a vmalloc instead (at least for the large
    queue size case).  With that, it's possible to increase our allowed
    maximum to the POSIX requirements (or more if we choose).

changes:
 o Don't change default value. It's a part of ABI.
 o Use PAGE_SIZE for vmalloc threshold. KMALLOC_MAX_SIZE is
   clearly too large and bring a fragmentation issue.
 o use is_vmalloc_addr()
 o bump up HARD_QUEUESMAX too.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Joe Korty <joe.korty@ccur.com>
---
 include/linux/ipc_namespace.h |   41 +++++++++++++++++++++++++++++++----------
 ipc/mqueue.c                  |   11 +++++++++--
 2 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 1372b56..6bb4c3b 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -90,16 +90,37 @@ static inline void shm_destroy_orphaned(struct ipc_namespace *ns) {}

 #ifdef CONFIG_POSIX_MQUEUE
 extern int mq_init_ns(struct ipc_namespace *ns);
-/* default values */
-#define MIN_QUEUESMAX  1
-#define DFLT_QUEUESMAX 256     /* max number of message queues */
-#define HARD_QUEUESMAX 1024
-#define MIN_MSGMAX     1
-#define DFLT_MSGMAX    10      /* max number of messages in each queue */
-#define HARD_MSGMAX    (32768*sizeof(void *)/4)
-#define MIN_MSGSIZEMAX  128
-#define DFLT_MSGSIZEMAX 8192   /* max message size */
-#define HARD_MSGSIZEMAX (8192*128)
+/*
+ * POSIX Message Queue default values:
+ *
+ * MIN_*: Lowest value an admin can set the maximum unprivileged limit to
+ * DFLT_*MAX: Default values for the maximum unprivileged limits
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
+#define MIN_QUEUESMAX		    1
+#define DFLT_QUEUESMAX		  256
+#define HARD_QUEUESMAX	  (1024*1024)
+#define MIN_MSGMAX		    1
+#define DFLT_MSGMAX		   10
+#define HARD_MSGMAX		65536
+#define MIN_MSGSIZEMAX		  128
+#define DFLT_MSGSIZEMAX		 8192
+#define HARD_MSGSIZEMAX	 (16*1024*1024)
 #else
 static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
 #endif
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 1eb0198..7e01da7 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -150,7 +150,11 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 			info->attr.mq_msgsize = attr->mq_msgsize;
 		}
 		mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
-		info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
+
+		if (mq_msg_tblsz > PAGE_SIZE)
+			info->messages = vmalloc(mq_msg_tblsz);
+		else
+			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
 		if (!info->messages)
 			goto out_inode;

@@ -271,7 +275,10 @@ static void mqueue_evict_inode(struct inode *inode)
 	spin_lock(&info->lock);
 	for (i = 0; i < info->attr.mq_curmsgs; i++)
 		free_msg(info->messages[i]);
-	kfree(info->messages);
+	if (is_vmalloc_addr(info->messages))
+		vfree(info->messages);
+	else
+		kfree(info->messages);
 	spin_unlock(&info->lock);

 	/* Total amount of bytes accounted for the mqueue */
-- 
1.7.5.2


