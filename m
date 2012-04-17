Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab2DQPrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:47:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183Ab2DQPrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:47:09 -0400
From: Doug Ledford <dledford@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, kosaki.motohiro@gmail.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [Patch 7/8] mqueue: separate mqueue default value from maximum value v2
Date: Tue, 17 Apr 2012 11:46:24 -0400
Message-Id: <3ec3acf3b66f655a05ab05c38fe3bd2762e2c8c4.1334676645.git.dledford@redhat.com>
In-Reply-To: <cover.1334676645.git.dledford@redhat.com>
References: <cover.1334676645.git.dledford@redhat.com>
In-Reply-To: <cover.1334676645.git.dledford@redhat.com>
References: <cover.1334676645.git.dledford@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit b231cca438 (message queues: increase range limits)
changed mqueue default value when attr parameter is specified NULL
from hard coded value to fs.mqueue.{msg,msgsize}_max sysctl value.

This made large side effect. When user need to use two mqueue
applications 1) using !NULL attr parameter and it require big
message size and 2) using NULL attr parameter and only need small
size message, app (1) require to raise fs.mqueue.msgsize_max and
app (2) consume large memory size even though it doesn't need.

Doug Ledford propsed to switch back it to static hard coded value.
However it also has a compatibility problem. Some applications might
started depend on the default value is tunable.

The solution is to separate default value from maximum value.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Doug Ledford <dledford@redhat.com>
Acked-by: Joe Korty <joe.korty@ccur.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Jiri Slaby <jslaby@suse.cz>

v1->v2: Slightly modified because msgutil.c no longer needs mq
  namespace initialization

Signed-off-by (v2): Doug Ledford <dledford@redhat.com>
---
 Documentation/sysctl/fs.txt   |    7 +++++++
 include/linux/ipc_namespace.h |    2 ++
 ipc/mq_sysctl.c               |   18 ++++++++++++++++++
 ipc/mqueue.c                  |    9 ++++++---
 4 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 88fd7f5..13d6166 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -225,6 +225,13 @@ a queue must be less or equal then msg_max.
 maximum  message size value (it is every  message queue's attribute set during
 its creation).
 
+/proc/sys/fs/mqueue/msg_default is  a read/write  file for setting/getting the
+default number of messages in a queue value if attr parameter of mq_open(2) is
+NULL. If it exceed msg_max, the default value is initialized msg_max.
+
+/proc/sys/fs/mqueue/msgsize_default is a read/write file for setting/getting
+the default message size value if attr parameter of mq_open(2) is NULL. If it
+exceed msgsize_max, the default value is initialized msgsize_max.
 
 4. /proc/sys/fs/epoll - Configuration options for the epoll interface
 --------------------------------------------------------
diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 2488535..5499c92 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -62,6 +62,8 @@ struct ipc_namespace {
 	unsigned int    mq_queues_max;   /* initialized to DFLT_QUEUESMAX */
 	unsigned int    mq_msg_max;      /* initialized to DFLT_MSGMAX */
 	unsigned int    mq_msgsize_max;  /* initialized to DFLT_MSGSIZEMAX */
+	unsigned int    mq_msg_default;
+	unsigned int    mq_msgsize_default;
 
 	/* user_ns which owns the ipc ns */
 	struct user_namespace *user_ns;
diff --git a/ipc/mq_sysctl.c b/ipc/mq_sysctl.c
index e22336a..383d638 100644
--- a/ipc/mq_sysctl.c
+++ b/ipc/mq_sysctl.c
@@ -73,6 +73,24 @@ static ctl_table mq_sysctls[] = {
 		.extra1		= &msg_maxsize_limit_min,
 		.extra2		= &msg_maxsize_limit_max,
 	},
+	{
+		.procname	= "msg_default",
+		.data		= &init_ipc_ns.mq_msg_default,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_mq_dointvec_minmax,
+		.extra1		= &msg_max_limit_min,
+		.extra2		= &msg_max_limit_max,
+	},
+	{
+		.procname	= "msgsize_default",
+		.data		= &init_ipc_ns.mq_msgsize_default,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_mq_dointvec_minmax,
+		.extra1		= &msg_maxsize_limit_min,
+		.extra2		= &msg_maxsize_limit_max,
+	},
 	{}
 };
 
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index f9f0782..04cc77e 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -142,9 +142,10 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 		info->qsize = 0;
 		info->user = NULL;	/* set when all is ok */
 		memset(&info->attr, 0, sizeof(info->attr));
-		info->attr.mq_maxmsg = min(ipc_ns->mq_msg_max, DFLT_MSG);
-		info->attr.mq_msgsize =
-			min(ipc_ns->mq_msgsize_max, DFLT_MSGSIZE);
+		info->attr.mq_maxmsg = min(ipc_ns->mq_msg_max,
+					   ipc_ns->mq_msg_default);
+		info->attr.mq_msgsize = min(ipc_ns->mq_msgsize_max,
+					    ipc_ns->mq_msgsize_default);
 		if (attr) {
 			info->attr.mq_maxmsg = attr->mq_maxmsg;
 			info->attr.mq_msgsize = attr->mq_msgsize;
@@ -1254,6 +1255,8 @@ int mq_init_ns(struct ipc_namespace *ns)
 	ns->mq_queues_max    = DFLT_QUEUESMAX;
 	ns->mq_msg_max       = DFLT_MSGMAX;
 	ns->mq_msgsize_max   = DFLT_MSGSIZEMAX;
+	ns->mq_msg_default   = DFLT_MSG;
+	ns->mq_msgsize_default  = DFLT_MSGSIZE;
 
 	ns->mq_mnt = kern_mount_data(&mqueue_fs_type, ns);
 	if (IS_ERR(ns->mq_mnt)) {
-- 
1.7.7.6

