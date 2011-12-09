Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1LIWhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 17:37:08 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34835 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab1LIWhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 17:37:04 -0500
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Randy Dunlap <rdunlap@xenotime.net> (maintainer:DOCUMENTATION 
	,commit_signer:2/3=67%),
        Rik van Riel <riel@redhat.com> (commit_signer:1/3=33%),
        Joe Korty <joe.korty@ccur.com> (commit_signer:1/3=33% 
	,commit_signer:2/9=22%,commit_signer:1/2=50%,commit_signer:2/13=15%),
        Federica Teodori <federica.teodori@googlemail.com> (commit_signer:1/3=33%),
        Doug Ledford <dledford@redhat.com> (commit_signer:5/9=56% 
	,commit_signer:2/2=100%,commit_signer:5/13=38%,commit_signer:1/2=50%),
        "Eric W. Biederman" <ebiederm@xmission.com> (commit_signer:2/9=22% 
	,commit_signer:1/2=50%),
        David Howells <dhowells@redhat.com> (commit_signer:2/9=22% 
	,commit_signer:1/2=50%),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [resend][PATCH 3/3] mqueue: separate mqueue default value from maximum value
Date: Fri,  9 Dec 2011 17:35:57 -0500
Message-Id: <1323470163-8723-3-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1323470163-8723-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1323470163-8723-1-git-send-email-kosaki.motohiro@gmail.com>
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
---
 Documentation/sysctl/fs.txt   |    7 +++++++
 include/linux/ipc_namespace.h |    2 ++
 ipc/mq_sysctl.c               |   18 ++++++++++++++++++
 ipc/mqueue.c                  |    9 ++++++---
 ipc/msgutil.c                 |    2 ++
 5 files changed, 35 insertions(+), 3 deletions(-)

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
index 315f84f..894a61b 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -143,9 +143,10 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
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
@@ -1266,6 +1267,8 @@ int mq_init_ns(struct ipc_namespace *ns)
 	ns->mq_queues_max    = DFLT_QUEUESMAX;
 	ns->mq_msg_max       = DFLT_MSGMAX;
 	ns->mq_msgsize_max   = DFLT_MSGSIZEMAX;
+	ns->mq_msg_default   = DFLT_MSG;
+	ns->mq_msgsize_default  = DFLT_MSGSIZE;
 
 	ns->mq_mnt = kern_mount_data(&mqueue_fs_type, ns);
 	if (IS_ERR(ns->mq_mnt)) {
diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index 8b5ce5d..a344216 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -31,6 +31,8 @@ struct ipc_namespace init_ipc_ns = {
 	.mq_queues_max   = DFLT_QUEUESMAX,
 	.mq_msg_max      = DFLT_MSGMAX,
 	.mq_msgsize_max  = DFLT_MSGSIZEMAX,
+	.mq_msg_default	    = DFLT_MSG,
+	.mq_msgsize_default = DFLT_MSGSIZE,
 #endif
 	.user_ns = &init_user_ns,
 };
-- 
1.7.1

