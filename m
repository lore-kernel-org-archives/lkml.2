Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab2EATIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:08:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758026Ab2EATIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:08:25 -0400
From: Doug Ledford <dledford@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, sfr@canb.auug.org.au,
        Doug Ledford <dledford@redhat.com>
Subject: [Patch 2/4] ipc/mqueue: correct mq_attr_ok test
Date: Tue,  1 May 2012 13:50:53 -0400
Message-Id: <4a62cbda48cf31ca796f37fa8904f314f643db57.1335894230.git.dledford@redhat.com>
In-Reply-To: <1335894655-11398-1-git-send-email-dledford@redhat.com>
References: <1335894655-11398-1-git-send-email-dledford@redhat.com>
In-Reply-To: <5b62749cb9227016ed5965fa57b96c0dccce37a8.1335894230.git.dledford@redhat.com>
References: <5b62749cb9227016ed5965fa57b96c0dccce37a8.1335894230.git.dledford@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on the other parts of the mqueue stuff, I noticed that
the calculation for overflow in mq_attr_ok didn't actually match
reality (this is especially true since my last patch which changed
how we account memory slightly).

In particular, we used to test for overflow using:
  msgs * msgsize + msgs * sizeof(struct msg_msg *)

That was never really correct because each message we allocate via
load_msg() is actually a struct msg_msg followed by the data for
the message (and if struct msg_msg + data exceeds PAGE_SIZE we end
up allocating struct msg_msgseg structs too, but accounting for them
would get really tedious, so let's ignore those...they're only a
pointer in size anyway).  This patch updates the calculation to be
more accurate in regards to maximum possible memory consumption by the
mqueue.

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 ipc/mqueue.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index fd49cfc..4b2892e 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -670,6 +670,8 @@ static void remove_notification(struct mqueue_inode_info *info)
 
 static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *attr)
 {
+	int mq_treesize;
+
 	if (attr->mq_maxmsg <= 0 || attr->mq_msgsize <= 0)
 		return 0;
 	if (capable(CAP_SYS_RESOURCE)) {
@@ -684,8 +686,11 @@ static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *attr)
 	/* check for overflow */
 	if (attr->mq_msgsize > ULONG_MAX/attr->mq_maxmsg)
 		return 0;
-	if ((unsigned long)(attr->mq_maxmsg * (attr->mq_msgsize
-	    + sizeof (struct msg_msg *))) <
+	mq_treesize = attr->mq_maxmsg * sizeof(struct msg_msg) +
+		min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
+		sizeof(struct posix_msg_tree_node);
+	if ((unsigned long)(attr->mq_maxmsg * attr->mq_msgsize +
+			    mq_treesize) <
 	    (unsigned long)(attr->mq_maxmsg * attr->mq_msgsize))
 		return 0;
 	return 1;
-- 
1.7.7.6

