Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab0INMoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 08:44:19 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48642 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab0INMoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 08:44:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F3lxUfZx7xGT4hK5S2EyXAOubrAbhbYVfu1+ss/I0X31GaGopft4EbGCMIdGAfGg8/
         Zko2OvtgK4oGH13/pRr6wqYM0PAHEjzSZ+E712Opb6VCuVks+HyBnhpmMZ0zjXbtyMEf
         iDSOwiiUqCoylxATuQ9BGcr896LjXluS0VhsI=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Darren Hart <dvhltc@us.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] futex: add lock context annotations
Date: Tue, 14 Sep 2010 21:43:48 +0900
Message-Id: <1284468228-8723-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1284468228-8723-1-git-send-email-namhyung@gmail.com>
References: <1284468228-8723-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

queue_lock/unlock/me() and unqueue_me_pi() grab/release spinlocks
but were missing proper annotations. Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/futex.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 45e448a..92a31d4 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1360,6 +1360,7 @@ out:
 
 /* The key must be already stored in q->key. */
 static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
+	__acquires(&hb->lock)
 {
 	struct futex_hash_bucket *hb;
 
@@ -1373,6 +1374,7 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 
 static inline void
 queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
+	__releases(&hb->lock)
 {
 	spin_unlock(&hb->lock);
 	drop_futex_key_refs(&q->key);
@@ -1391,6 +1393,7 @@ queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
  * an example).
  */
 static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
+	__releases(&hb->lock)
 {
 	int prio;
 
@@ -1471,6 +1474,7 @@ retry:
  * and dropped here.
  */
 static void unqueue_me_pi(struct futex_q *q)
+	__releases(q->lock_ptr)
 {
 	WARN_ON(plist_node_empty(&q->list));
 	plist_del(&q->list, &q->list.plist);
-- 
1.7.2.2

