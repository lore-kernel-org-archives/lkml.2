Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab2DQPqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:46:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755724Ab2DQPqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:46:34 -0400
From: Doug Ledford <dledford@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, kosaki.motohiro@gmail.com,
        Doug Ledford <dledford@redhat.com>
Subject: [Patch 2/8] ipc/mqueue: switch back to using non-max values on create
Date: Tue, 17 Apr 2012 11:46:19 -0400
Message-Id: <a9cfc656e665735e11606d452a536a9a9e6ebdde.1334676645.git.dledford@redhat.com>
In-Reply-To: <cover.1334676645.git.dledford@redhat.com>
References: <cover.1334676645.git.dledford@redhat.com>
In-Reply-To: <cover.1334676645.git.dledford@redhat.com>
References: <cover.1334676645.git.dledford@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b231cca4381ee15ec99afbfb244fbc0324869927 changed
how we create a queue that does not include an attr
struct passed to open so that it creates the queue
with whatever the maximum values are.  However, if the
admin has set the maximums to allow flexibility in
creating a queue (aka, both a large size and large queue
are allowed, but combined they create a queue too large
for the RLIMIT_MSGQUEUE of the user), then attempts to
create a queue without an attr struct will fail.  Switch
back to using acceptable defaults regardless of what
the maximums are.

Note: so far, we only know of a few applications that rely
on this behavior (specifically, set the maximums in /proc,
then run the application which calls mq_open() without
passing in an attr struct, and the application expects the
newly created message queue to have the maximum sizes that
were set in /proc used on the mq_open() call, and all of
those applications that we know of are actually part of
regression test suites that were coded to do something
like this:

for size in 4096 65536 $((1024 * 1024)) $((16 * 1024 * 1024)); do
	echo $size > /proc/sys/fs/mqueue/msgsize_max
	mq_open || echo "Error opening mq with size $size"
done

These test suites that depend on any behavior like this are
broken.  The concept that programs should rely upon the
system wide maximum in order to get their desired results
instead of simply using a attr struct to specify what they
want is fundamentally unfriendly programming practice for
any multi-tasking OS.

Fixing this will break those few apps that we know of (and
those app authors recognize the brokenness of their code
and the need to fix it).  However, a future patch will allow
a workaround in the form of new knobs for the default
msg queue creation parameters for any software out there that
we don't already know about that might rely on this behavior
at the moment.

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 include/linux/ipc_namespace.h |    2 ++
 ipc/mqueue.c                  |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 1372b56..bde094e 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -95,9 +95,11 @@ extern int mq_init_ns(struct ipc_namespace *ns);
 #define DFLT_QUEUESMAX 256     /* max number of message queues */
 #define HARD_QUEUESMAX 1024
 #define MIN_MSGMAX     1
+#define DFLT_MSG       10U
 #define DFLT_MSGMAX    10      /* max number of messages in each queue */
 #define HARD_MSGMAX    (32768*sizeof(void *)/4)
 #define MIN_MSGSIZEMAX  128
+#define DFLT_MSGSIZE    8192U
 #define DFLT_MSGSIZEMAX 8192   /* max message size */
 #define HARD_MSGSIZEMAX (8192*128)
 #else
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 28bd64d..b178268 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -142,8 +142,9 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 		info->qsize = 0;
 		info->user = NULL;	/* set when all is ok */
 		memset(&info->attr, 0, sizeof(info->attr));
-		info->attr.mq_maxmsg = ipc_ns->mq_msg_max;
-		info->attr.mq_msgsize = ipc_ns->mq_msgsize_max;
+		info->attr.mq_maxmsg = min(ipc_ns->mq_msg_max, DFLT_MSG);
+		info->attr.mq_msgsize =
+			min(ipc_ns->mq_msgsize_max, DFLT_MSGSIZE);
 		if (attr) {
 			info->attr.mq_maxmsg = attr->mq_maxmsg;
 			info->attr.mq_msgsize = attr->mq_msgsize;
-- 
1.7.7.6

