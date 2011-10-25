Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab1JYClC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 22:41:02 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33840 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab1JYCk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 22:40:58 -0400
Message-ID: <4EA621C9.3040206@gmail.com>
Date: Mon, 24 Oct 2011 22:41:13 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        dledford@redhat.com, amwang@redhat.com, serue@us.ibm.com,
        jslaby@suse.cz, joe.korty@ccur.com
Subject: [PATCH 3/3] ipc/mqueue: separate mqueue default value from maximum,
 value
References: <4EA61FC5.4010500@gmail.com>
In-Reply-To: <4EA61FC5.4010500@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b231cca438 (message queues: increase range limits)
changed mqueue default value when attr parameter is specified NULL
from hard coded value to fs.mqueue.{msg,msgsize}_max sysctl value.

This made large side effect. When user need to use two mqueue
applications 1) using !NULL attr parameter and it require big
message size and 2) using NULL attr parameter and only need small
size message, app (1) require to raise fs.mqueue.msgsize_max and
app (2) consume large memory size even though it doesn't need.

The solution is to separate default value from maximum value.

Note: msg_default and msgsize_default have slightly strange
initial value. It is necessary to keep backward compatibility.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Joe Korty <joe.korty@ccur.com>
---
 Documentation/sysctl/fs.txt   |    7 +++++++
 include/linux/ipc_namespace.h |    3 +++
 ipc/mq_sysctl.c               |   18 ++++++++++++++++++
 ipc/mqueue.c                  |    8 ++++++--
 ipc/msgutil.c                 |    4 ++++
 5 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 88fd7f5..5f644b3 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -225,6 +225,13 @@ a queue must be less or equal then msg_max.
 maximum  message size value (it is every  message queue's attribute set during
 its creation).

+/proc/sys/fs/mqueue/msg_default is  a read/write  file for setting/getting the
+default number of messages in a queue value if attr parameter of mq_open(2) is
+NULL. If it exceed msg_max, the default value is initialized msg_max instead.
+
+/proc/sys/fs/mqueue/msgsize_default is a read/write file for setting/getting
+the default message size value if attr parameter of mq_open(2) is NULL. If it
+exceed msgsize_max, the default value is initialized msgsize_max instead.

 4. /proc/sys/fs/epoll - Configuration options for the epoll interface
 --------------------------------------------------------
diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 6bb4c3b..4483234 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -63,6 +63,9 @@ struct ipc_namespace {
 	unsigned int    mq_msg_max;      /* initialized to DFLT_MSGMAX */
 	unsigned int    mq_msgsize_max;  /* initialized to DFLT_MSGSIZEMAX */

+	unsigned int    mq_msg_default;
+	unsigned int    mq_msgsize_default;
+
 	/* user_ns which owns the ipc ns */
 	struct user_namespace *user_ns;
 };
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
index 7e01da7..8b2de4f 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -143,8 +143,10 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 		info->qsize = 0;
 		info->user = NULL;	/* set when all is ok */
 		memset(&info->attr, 0, sizeof(info->attr));
-		info->attr.mq_maxmsg = ipc_ns->mq_msg_max;
-		info->attr.mq_msgsize = ipc_ns->mq_msgsize_max;
+		info->attr.mq_maxmsg = min(ipc_ns->mq_msg_default,
+					   ipc_ns->mq_msg_max);
+		info->attr.mq_msgsize = min(ipc_ns->mq_msgsize_default,
+					    ipc_ns->mq_msgsize_max);
 		if (attr) {
 			info->attr.mq_maxmsg = attr->mq_maxmsg;
 			info->attr.mq_msgsize = attr->mq_msgsize;
@@ -1262,6 +1264,8 @@ int mq_init_ns(struct ipc_namespace *ns)
 	ns->mq_queues_max    = DFLT_QUEUESMAX;
 	ns->mq_msg_max       = DFLT_MSGMAX;
 	ns->mq_msgsize_max   = DFLT_MSGSIZEMAX;
+	ns->mq_msg_default   = HARD_MSGMAX;
+	ns->mq_msgsize_default  = HARD_MSGSIZEMAX;

 	ns->mq_mnt = kern_mount_data(&mqueue_fs_type, ns);
 	if (IS_ERR(ns->mq_mnt)) {
diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index 8b5ce5d3..e2d6b0e 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -31,6 +31,10 @@ struct ipc_namespace init_ipc_ns = {
 	.mq_queues_max   = DFLT_QUEUESMAX,
 	.mq_msg_max      = DFLT_MSGMAX,
 	.mq_msgsize_max  = DFLT_MSGSIZEMAX,
+
+	/* strange default for backward compatibility. */
+	.mq_msg_default  = HARD_MSGMAX,
+	.mq_msgsize_default  = HARD_MSGSIZEMAX,
 #endif
 	.user_ns = &init_user_ns,
 };
-- 
1.7.5.2

