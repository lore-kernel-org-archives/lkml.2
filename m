Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab2KZRMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:12:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47990 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933761Ab2KZRMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:12:38 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 204/270] Staging: android: binder: Fix memory leak on thread/process exit
Date: Mon, 26 Nov 2012 14:58:14 -0200
Message-Id: <1353949160-26803-205-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>

commit 675d66b0ed5fd170d6a44cf8dbb3fa56a5347bdb upstream.

If a thread or process exited while a reply, one-way transaction or
death notification was pending, the struct holding the pending work
was leaked.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/android/binder.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index c283212..80acd0e 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2507,14 +2507,38 @@ static void binder_release_work(struct list_head *list)
 			struct binder_transaction *t;
 
 			t = container_of(w, struct binder_transaction, work);
-			if (t->buffer->target_node && !(t->flags & TF_ONE_WAY))
+			if (t->buffer->target_node &&
+			    !(t->flags & TF_ONE_WAY)) {
 				binder_send_failed_reply(t, BR_DEAD_REPLY);
+			} else {
+				binder_debug(BINDER_DEBUG_DEAD_TRANSACTION,
+					"binder: undelivered transaction %d\n",
+					t->debug_id);
+				t->buffer->transaction = NULL;
+				kfree(t);
+				binder_stats_deleted(BINDER_STAT_TRANSACTION);
+			}
 		} break;
 		case BINDER_WORK_TRANSACTION_COMPLETE: {
+			binder_debug(BINDER_DEBUG_DEAD_TRANSACTION,
+				"binder: undelivered TRANSACTION_COMPLETE\n");
 			kfree(w);
 			binder_stats_deleted(BINDER_STAT_TRANSACTION_COMPLETE);
 		} break;
+		case BINDER_WORK_DEAD_BINDER_AND_CLEAR:
+		case BINDER_WORK_CLEAR_DEATH_NOTIFICATION: {
+			struct binder_ref_death *death;
+
+			death = container_of(w, struct binder_ref_death, work);
+			binder_debug(BINDER_DEBUG_DEAD_TRANSACTION,
+				"binder: undelivered death notification, %p\n",
+				death->cookie);
+			kfree(death);
+			binder_stats_deleted(BINDER_STAT_DEATH);
+		} break;
 		default:
+			pr_err("binder: unexpected work type, %d, not freed\n",
+			       w->type);
 			break;
 		}
 	}
@@ -2984,6 +3008,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 		nodes++;
 		rb_erase(&node->rb_node, &proc->nodes);
 		list_del_init(&node->work.entry);
+		binder_release_work(&node->async_todo);
 		if (hlist_empty(&node->refs)) {
 			kfree(node);
 			binder_stats_deleted(BINDER_STAT_NODE);
@@ -3022,6 +3047,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 		binder_delete_ref(ref);
 	}
 	binder_release_work(&proc->todo);
+	binder_release_work(&proc->delivered_death);
 	buffers = 0;
 
 	while ((n = rb_first(&proc->allocated_buffers))) {
-- 
1.7.9.5

