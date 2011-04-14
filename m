Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab1DNRyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:54:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:38442 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933357Ab1DNRrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ken Chen <kenchen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 064/209] latencytop: fix per task accumulator
Date: Thu, 14 Apr 2011 13:41:34 -0400
Message-Id: <1302803039-9400-65-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Chen <kenchen@google.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/latencytop.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index 877fb30..17110a4 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -194,14 +194,7 @@ __account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
 
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
 
@@ -227,8 +220,14 @@ __account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
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
-- 
1.7.4.4

