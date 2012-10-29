Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582Ab2J2WRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:17:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:47300 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757812Ab2J2Vgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:36:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: =?UTF-8?q?=5B=20025/101=5D=20Staging=3A=20android=3A=20binder=3A=20Fix=20memory=20leak=20on=20thread/process=20exit?=
Date: Mon, 29 Oct 2012 14:34:38 -0700
Message-Id: <20121029213242.974002393@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arve Hjønnevåg <arve@android.com>

commit 675d66b0ed5fd170d6a44cf8dbb3fa56a5347bdb upstream.

If a thread or process exited while a reply, one-way transaction or
death notification was pending, the struct holding the pending work
was leaked.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/android/binder.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2507,14 +2507,38 @@ static void binder_release_work(struct l
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
@@ -2984,6 +3008,7 @@ static void binder_deferred_release(stru
 		nodes++;
 		rb_erase(&node->rb_node, &proc->nodes);
 		list_del_init(&node->work.entry);
+		binder_release_work(&node->async_todo);
 		if (hlist_empty(&node->refs)) {
 			kfree(node);
 			binder_stats_deleted(BINDER_STAT_NODE);
@@ -3022,6 +3047,7 @@ static void binder_deferred_release(stru
 		binder_delete_ref(ref);
 	}
 	binder_release_work(&proc->todo);
+	binder_release_work(&proc->delivered_death);
 	buffers = 0;
 
 	while ((n = rb_first(&proc->allocated_buffers))) {


