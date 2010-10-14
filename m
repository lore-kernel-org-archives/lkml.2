Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0JNLaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 07:30:15 -0400
Received: from bohort.kerlabs.com ([90.80.97.101]:33756 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab0JNLaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 07:30:13 -0400
From: Louis Rilling <louis.rilling@kerlabs.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?utf-8?q?Matthieu=20Fertr=C3=A9?= <matthieu.fertre@kerlabs.com>,
        Louis Rilling <louis.rilling@kerlabs.com>
Subject: [RESEND PATCH] futex: fix key reference counter in case of requeue.
Date: Thu, 14 Oct 2010 13:30:05 +0200
Message-Id: <1287055805-18233-1-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthieu Fertré <matthieu.fertre@kerlabs.com>

This patch ensures that we are referring to the right key when dropping
reference for the futex_wait operation.

The following scenario explains a typical case where the bug was
happening:

Process P calls futex_wait() on futex identified by 'key1'. 2 references
are taken on this key: one for the struct futex_q itself, and one for the
futex_wait operation.
If now, process P is requeued on a futex identified by 'key2', its
futex_q->key is updated from 'key1' to 'key2' and a reference is got
to 'key2' and one is dropped to 'key1'.
Later, another process calls futex_wake(): it gets a reference to
'key2', wakes process P, and drops reference to 'key2'.
Once process P is woken up, it should unqueue, drop reference to 'key2'
(the one referring to the futex_q, this is done in unqueue_me())
and to 'key1' (the one referring to futex_wait operation). Without this
patch it drops reference to 'key2' instead of 'key1'.

Signed-off-by: Matthieu Fertré <matthieu.fertre@kerlabs.com>
Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 kernel/futex.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6a3a5fa..bed6717 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1791,6 +1791,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 	struct restart_block *restart;
 	struct futex_hash_bucket *hb;
 	struct futex_q q;
+	union futex_key key;
 	int ret;
 
 	if (!bitset)
@@ -1817,6 +1818,9 @@ retry:
 	if (ret)
 		goto out;
 
+	/* save the key in case of requeue. */
+	key = q.key;
+
 	/* queue_me and wait for wakeup, timeout, or a signal. */
 	futex_wait_queue_me(hb, &q, to);
 
@@ -1833,7 +1837,7 @@ retry:
 	 * victim of a spurious wakeup as well.
 	 */
 	if (!signal_pending(current)) {
-		put_futex_key(fshared, &q.key);
+		put_futex_key(fshared, &key);
 		goto retry;
 	}
 
@@ -1857,7 +1861,7 @@ retry:
 	ret = -ERESTART_RESTARTBLOCK;
 
 out_put_key:
-	put_futex_key(fshared, &q.key);
+	put_futex_key(fshared, &key);
 out:
 	if (to) {
 		hrtimer_cancel(&to->timer);
-- 
1.5.6.5

