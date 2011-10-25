Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab1JYCcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 22:32:25 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54264 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab1JYCcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 22:32:24 -0400
Message-ID: <4EA61FC5.4010500@gmail.com>
Date: Mon, 24 Oct 2011 22:32:37 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        dledford@redhat.com, amwang@redhat.com, serue@us.ibm.com,
        jslaby@suse.cz, joe.korty@ccur.com
Subject: [PATCH 1/3] Revert "ipc/mqueue: update maximums for the mqueue, subsystem"
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current linux-next doesn't work following test.

  # MSGSZ=10000
  # echo $MSGSZ > /proc/sys/fs/mqueue/msgsize_max
  # ./mq_open -c  /testN
  # ./mq_send -b $MSGSZ /testN
     => EMSGSIZE

Because mq_open(path, flags, mode, NULL) don't respect msgsize_max knob anymore.

Commit e30a8a7b58 (ipc/mqueue: update maximums for the mqueue subsystem) claim
Commit b231cca4381ee ("message queues: increase range limits") changed the
maximum size of a message in a message queue from INT_MAX to 8192*128. and The patch
fix up the maximum value. However it also changes default mqueue value and
changed mqueue.msg_max and mqueue.msgsize_max sysctl semantics.

In general, basic compatibility rule is:
1. Increase hard coded maximum limitation
   -> safe
2. Decrease hard coded maximum limitation
   -> unsafe
3. Increase sysctl default value
   -> safe if the new value don't exceed another limitation *and*
      every application don't depend on old value.
4. Decrease sysctl default value
   -> unsafe
5. Change hard coded value to flexible knob
   -> safe if default value is unchanged.
6. Change knob to hard coded value
   -> unsafe

"ipc/mqueue: switch back to using non-max values on create" breaks rule 6 and
"ipc/mqueue: update maximums for the mqueue subsystem" breaks rule 3.

Thus, this patch reverts following three commits.

- ipc/mqueue: switch back to using non-max values on create
- ipc/mqueue: update maximums for the mqueue subsystem
- ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes

The right way is to only bump up hard coded maximum value and don't touch
default value. Look! Commit b231cca4381ee ("message queues: increase range limits")
only changed hard coded value. If anyone think it is regression, they have to
touch only the same place. Unnecessary change brings another regression. The
subsequent patches do it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Joe Korty <joe.korty@ccur.com>
---
 include/linux/ipc_namespace.h |   45 +++++++++-------------------------------
 ipc/mqueue.c                  |   15 +++----------
 2 files changed, 14 insertions(+), 46 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index e2bac00..1372b56 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -90,41 +90,16 @@ static inline void shm_destroy_orphaned(struct ipc_namespace *ns) {}

 #ifdef CONFIG_POSIX_MQUEUE
 extern int mq_init_ns(struct ipc_namespace *ns);
-/*
- * POSIX Message Queue default values:
- *
- * MIN_*: Lowest value an admin can set the maximum unprivileged limit to
- * DFLT_*MAX: Default values for the maximum unprivileged limits
- * DFLT_{MSG,MSGSIZE}: Default values used when the user doesn't supply
- *   an attribute to the open call and the queue must be created
- * HARD_*: Highest value the maximums can be set to.  These are enforced
- *   on CAP_SYS_RESOURCE apps as well making them inviolate (so make them
- *   suitably high)
- *
- * POSIX Requirements:
- *   Per app minimum openable message queues - 8.  This does not map well
- *     to the fact that we limit the number of queues on a per namespace
- *     basis instead of a per app basis.  So, make the default high enough
- *     that no given app should have a hard time opening 8 queues.
- *   Minimum maximum for HARD_MSGMAX - 32767.  I bumped this to 65536.
- *   Minimum maximum for HARD_MSGSIZEMAX - POSIX is silent on this.  However,
- *     we have run into a situation where running applications in the wild
- *     require this to be at least 5MB, and preferably 10MB, so I set the
- *     value to 16MB in hopes that this user is the worst of the bunch and
- *     the new maximum will handle anyone else.  I may have to revisit this
- *     in the future.
- */
-#define MIN_QUEUESMAX			1
-#define DFLT_QUEUESMAX		      256
-#define HARD_QUEUESMAX		     1024
-#define MIN_MSGMAX			1
-#define DFLT_MSG		       64U
-#define DFLT_MSGMAX		     1024
-#define HARD_MSGMAX		    65536
-#define MIN_MSGSIZEMAX		      128
-#define DFLT_MSGSIZE		     8192U
-#define DFLT_MSGSIZEMAX		(1024*1024)
-#define HARD_MSGSIZEMAX	     (16*1024*1024)
+/* default values */
+#define MIN_QUEUESMAX  1
+#define DFLT_QUEUESMAX 256     /* max number of message queues */
+#define HARD_QUEUESMAX 1024
+#define MIN_MSGMAX     1
+#define DFLT_MSGMAX    10      /* max number of messages in each queue */
+#define HARD_MSGMAX    (32768*sizeof(void *)/4)
+#define MIN_MSGSIZEMAX  128
+#define DFLT_MSGSIZEMAX 8192   /* max message size */
+#define HARD_MSGSIZEMAX (8192*128)
 #else
 static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
 #endif
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 229a5fb..1eb0198 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -143,18 +143,14 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 		info->qsize = 0;
 		info->user = NULL;	/* set when all is ok */
 		memset(&info->attr, 0, sizeof(info->attr));
-		info->attr.mq_maxmsg = min(ipc_ns->mq_msg_max, DFLT_MSG);
-		info->attr.mq_msgsize =
-			min(ipc_ns->mq_msgsize_max, DFLT_MSGSIZE);
+		info->attr.mq_maxmsg = ipc_ns->mq_msg_max;
+		info->attr.mq_msgsize = ipc_ns->mq_msgsize_max;
 		if (attr) {
 			info->attr.mq_maxmsg = attr->mq_maxmsg;
 			info->attr.mq_msgsize = attr->mq_msgsize;
 		}
 		mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
-		if (mq_msg_tblsz > KMALLOC_MAX_SIZE)
-			info->messages = vmalloc(mq_msg_tblsz);
-		else
-			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
+		info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
 		if (!info->messages)
 			goto out_inode;

@@ -275,10 +271,7 @@ static void mqueue_evict_inode(struct inode *inode)
 	spin_lock(&info->lock);
 	for (i = 0; i < info->attr.mq_curmsgs; i++)
 		free_msg(info->messages[i]);
-	if (info->attr.mq_maxmsg * sizeof(struct msg_msg *) > KMALLOC_MAX_SIZE)
-		vfree(info->messages);
-	else
-		kfree(info->messages);
+	kfree(info->messages);
 	spin_unlock(&info->lock);

 	/* Total amount of bytes accounted for the mqueue */
-- 
1.7.5.2

