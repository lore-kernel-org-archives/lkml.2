Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0GGRIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 13:08:16 -0400
Received: from relay.parallels.com ([195.214.232.42]:37661 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab0GGRIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 13:08:14 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Jul 2010 13:08:14 EDT
Subject: [PATCH] ipc/sem.c: shrink size of struct sem_undo
To: <linux-kernel@vger.kernel.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Wed, 7 Jul 2010 20:58:15 +0400
Message-ID: <20100707165815.28007.57836.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combine ->list_id and ->rcu fields,
this is safe because this list is not rcu protected.
This change reduce sizeof(struct sem_undo) from 72 to 54 bytes,
so for small sem-arrays now sem_undo will fit into slab-64.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/sem.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/sem.h b/include/linux/sem.h
index f2961af..f6e0433 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -122,9 +122,11 @@ struct sem_queue {
 struct sem_undo {
 	struct list_head	list_proc;	/* per-process list: all undos from one process. */
 						/* rcu protected */
-	struct rcu_head		rcu;		/* rcu struct for sem_undo() */
+	union {
+		struct list_head list_id;	/* per semaphore array list: all undos for one array */
+		struct rcu_head	 rcu;		/* rcu struct for sem_undo() */
+	};
 	struct sem_undo_list	*ulp;		/* sem_undo_list for the process */
-	struct list_head	list_id;	/* per semaphore array list: all undos for one array */
 	int			semid;		/* semaphore set identifier */
 	short *			semadj;		/* array of adjustments, one per semaphore */
 };

