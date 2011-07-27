Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1G0TNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 15:13:09 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:55022 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab1G0TNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 15:13:06 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH RFCv2 8/8] rcu: Rewrite and rename list_splice_init_rcu()
Date: Wed, 27 Jul 2011 21:10:25 +0200
Message-Id: <1311793825-31933-9-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

Rewrite list_splice_init_rcu() to make use of the newly introduced
__list_splice_rcu(). Also, add "_sync" to the name, so that we can
differentiate whether the list to be spliced is allowed to have its own
concurrent readers: with "_sync", readers not belonging to the
destination list are allowed and the function will block; without
"_sync", readers not belonging to the destination list are forbidden and
the function will not block.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 drivers/char/ipmi/ipmi_msghandler.c |    2 +-
 fs/btrfs/volumes.c                  |    2 +-
 include/linux/rculist.h             |   19 +++++++++----------
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 58c0e63..62b48e8 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -502,7 +502,7 @@ static void clean_up_interface_data(ipmi_smi_t intf)
 	 */
 	mutex_lock(&intf->cmd_rcvrs_mutex);
 	INIT_LIST_HEAD(&list);
-	list_splice_init_rcu(&intf->cmd_rcvrs, &list, synchronize_rcu);
+	list_splice_init_rcu_sync(&intf->cmd_rcvrs, &list, synchronize_rcu);
 	mutex_unlock(&intf->cmd_rcvrs_mutex);
 
 	list_for_each_entry_safe(rcvr, rcvr2, &list, link)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 19450bc..e1d5149 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1440,7 +1440,7 @@ static int btrfs_prepare_sprout(struct btrfs_trans_handle *trans,
 	mutex_init(&seed_devices->device_list_mutex);
 
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
-	list_splice_init_rcu(&fs_devices->devices, &seed_devices->devices,
+	list_splice_init_rcu_sync(&fs_devices->devices, &seed_devices->devices,
 			      synchronize_rcu);
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index c5db505..b695e88 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -277,7 +277,8 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
 }
 
 /**
- * list_splice_init_rcu - splice an RCU-protected list into an existing list.
+ * list_splice_init_rcu_sync - splice an RCU-protected list into an existing
+ *			       RCU-protected list.
  * @list:	the RCU-protected list to splice
  * @head:	the place in the list to splice the first list into
  * @sync:	function to sync: synchronize_rcu(), synchronize_sched(), ...
@@ -293,18 +294,19 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
  *	based on call_rcu() could be created.  But only if -really-
  *	needed -- there is no shortage of RCU API members.
  */
-static inline void list_splice_init_rcu(struct list_head *list,
+static inline void list_splice_init_rcu_sync(struct list_head *list,
 					struct list_head *head,
 					void (*sync)(void))
 {
-	struct list_head *first = list->next;
-	struct list_head *last = list->prev;
-	struct list_head *at = head->next;
+	struct list_head tmp;
 
 	if (list_empty(head))
 		return;
 
-	/* "first" and "last" tracking list, so initialize it. */
+	tmp.next = list->next;
+	tmp.prev = list->prev;
+
+	/* "tmp" is tracking "list", so we can safely initialize "list". */
 
 	INIT_LIST_HEAD(list);
 
@@ -325,10 +327,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	 * this function.
 	 */
 
-	last->next = at;
-	rcu_assign_pointer(list_next_rcu(head), first);
-	first->prev = head;
-	at->prev = last;
+	__list_splice_rcu(&tmp, head, head->next);
 }
 
 /**
-- 
1.7.6

