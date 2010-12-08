Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab0LHCJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:09:59 -0500
Received: from kroah.org ([198.145.64.141]:58355 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091Ab0LHArT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:19 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:29 2010
Message-Id: <20101208004429.822022881@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ken Chen <kenchen@google.com>
Subject: [055/127] latencytop: fix per task accumulator
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ken Chen <kenchen@google.com>

commit 38715258aa2e8cd94bd4aafadc544e5104efd551 upstream.

Per task latencytop accumulator prematurely terminates due to erroneous
placement of latency_record_count.  It should be incremented whenever a
new record is allocated instead of increment on every latencytop event.

Also fix search iterator to only search known record events instead of
blindly searching all pre-allocated space.

Signed-off-by: Ken Chen <kenchen@google.com>
Reviewed-by: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/latencytop.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -195,14 +195,7 @@ __account_scheduler_latency(struct task_
 
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
 
@@ -228,8 +221,14 @@ __account_scheduler_latency(struct task_
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


