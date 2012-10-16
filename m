Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab2JPAd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:33:58 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:38093 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab2JPAdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:33:02 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: gregkh@linuxfoundation.org
Cc: xiaobing.tu@intel.com, ccross@android.com, davej@redhat.com,
        akpm@linux-foundation.org, mingo@elte.hu, rusty@rustcorp.com.au,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, di.zhang@intel.com, xindong.ma@intel.com,
        alex.zuo@intel.com,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 1/2] Staging: android: binder: Fix memory leak on thread/process exit
Date: Mon, 15 Oct 2012 17:32:41 -0700
Message-Id: <1350347562-32643-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <20121015235836.GA3214@kroah.com>
References: <20121015235836.GA3214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a thread or process exited while a reply, one-way transaction or
death notification was pending, the struct holding the pending work
was leaked.

Change-Id: I2eaafaba1c0ecda3ec0872d449dc16d0721c21e7
Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/staging/android/binder.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 85ed6cf..b89799a 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2548,14 +2548,38 @@ static void binder_release_work(struct list_head *list)
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
@@ -3036,6 +3060,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 		nodes++;
 		rb_erase(&node->rb_node, &proc->nodes);
 		list_del_init(&node->work.entry);
+		binder_release_work(&node->async_todo);
 		if (hlist_empty(&node->refs)) {
 			kfree(node);
 			binder_stats_deleted(BINDER_STAT_NODE);
@@ -3074,6 +3099,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 		binder_delete_ref(ref);
 	}
 	binder_release_work(&proc->todo);
+	binder_release_work(&proc->delivered_death);
 	buffers = 0;
 
 	while ((n = rb_first(&proc->allocated_buffers))) {
-- 
1.7.7.3

