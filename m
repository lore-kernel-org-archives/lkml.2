Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab0IRKXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 06:23:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:42791 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580Ab0IRKXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 06:23:10 -0400
Date: Sat, 18 Sep 2010 10:22:50 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        namhyung@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1284468228-8723-3-git-send-email-namhyung@gmail.com>
References: <1284468228-8723-3-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/futexes] futex: Add lock context annotations
Message-ID: <tip-15e408cd6ccc3f4f453d87ccd5bc7a84d59feb96@git.kernel.org>
Git-Commit-ID: 15e408cd6ccc3f4f453d87ccd5bc7a84d59feb96
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 18 Sep 2010 10:22:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15e408cd6ccc3f4f453d87ccd5bc7a84d59feb96
Gitweb:     http://git.kernel.org/tip/15e408cd6ccc3f4f453d87ccd5bc7a84d59feb96
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 14 Sep 2010 21:43:48 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 18 Sep 2010 12:19:21 +0200

futex: Add lock context annotations

queue_lock/unlock/me() and unqueue_me_pi() grab/release spinlocks
but are missing proper annotations. Add them.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Darren Hart <dvhltc@us.ibm.com>
LKML-Reference: <1284468228-8723-3-git-send-email-namhyung@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
