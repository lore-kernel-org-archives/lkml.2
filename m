Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab0LMAHX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:07:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36287 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab0LLXrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:09 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: kenchen@google.com, ak@linux.intel.com, arjan@infradead.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [126/223] latencytop: fix per task accumulator
Message-Id: <20101212234707.F2FD9B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ken Chen <kenchen@google.com>

commit 38715258aa2e8cd94bd4aafadc544e5104efd551 upstream.

Per task latencytop accumulator prematurely terminates due to erroneous
placement of latency_record_count.  It should be incremented whenever a
new record is allocated instead of increment on every latencytop event.

Also fix search iterator to only search known record events instead of
blindly searching all pre-allocated space.

Signed-off-by: Ken Chen <kenchen@google.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/latencytop.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

Index: linux/kernel/latencytop.c
===================================================================
--- linux.orig/kernel/latencytop.c
+++ linux/kernel/latencytop.c
@@ -194,14 +194,7 @@ __account_scheduler_latency(struct task_
 
 	account_global_scheduler_latency(tsk, &lat);
 
-	/*
-	 * short term hack; if we're > 32 we stop; future we recycle:
-	 */
-	tsk->latency_record_count++;
-	if (tsk->latency_record_count >= LT_SAVECOUNT)
-		goto out_unlock;
-
-	for (i = 0; i < LT_SAVECOUNT; i++) {
+	for (i = 0; i < tsk->latency_record_count; i++) {
 		struct latency_record *mylat;
 		int same = 1;
 
@@ -227,8 +220,14 @@ __account_scheduler_latency(struct task_
 		}
 	}
 
+	/*
+	 * short term hack; if we're > 32 we stop; future we recycle:
+	 */
+	if (tsk->latency_record_count >= LT_SAVECOUNT)
+		goto out_unlock;
+
 	/* Allocated a new one: */
-	i = tsk->latency_record_count;
+	i = tsk->latency_record_count++;
 	memcpy(&tsk->latency_record[i], &lat, sizeof(struct latency_record));
 
 out_unlock:
