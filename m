Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0JPIaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 04:30:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59018 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab0JPIaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 04:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=N9U3az9knTd7znCcHx3S7P3rmmm8FW0LX+eV8+GEYZzHKw1kJ7+tZN4zO1J6GviCP3
         qhv7oQpGP7XbTRyY+EpzwTq/3G506UJ2GNoHaQ1rA7xR182VVCZfexOHGxSTEa1SwzUr
         ZnV8nJWkCQ3VPvZcQzdKA+SC54J7w/tSFF0PA=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] jbd: Cleanup __process_buffer()
Date: Sat, 16 Oct 2010 17:30:14 +0900
Message-Id: <1287217814-5782-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change initial value of 'ret' to 1 and set to 0 only if nothing
happens actually.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/jbd/checkpoint.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index e4b87bc..0a687a6 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -280,7 +280,7 @@ static int __process_buffer(journal_t *journal, struct journal_head *jh,
 			struct buffer_head **bhs, int *batch_count)
 {
 	struct buffer_head *bh = jh2bh(jh);
-	int ret = 0;
+	int ret = 1;
 
 	if (buffer_locked(bh)) {
 		get_bh(bh);
@@ -290,7 +290,6 @@ static int __process_buffer(journal_t *journal, struct journal_head *jh,
 		/* the journal_head may have gone by now */
 		BUFFER_TRACE(bh, "brelse");
 		__brelse(bh);
-		ret = 1;
 	} else if (jh->b_transaction != NULL) {
 		transaction_t *t = jh->b_transaction;
 		tid_t tid = t->t_tid;
@@ -299,9 +298,7 @@ static int __process_buffer(journal_t *journal, struct journal_head *jh,
 		jbd_unlock_bh_state(bh);
 		log_start_commit(journal, tid);
 		log_wait_commit(journal, tid);
-		ret = 1;
 	} else if (!buffer_dirty(bh)) {
-		ret = 1;
 		if (unlikely(buffer_write_io_error(bh)))
 			ret = -EIO;
 		J_ASSERT_JH(jh, !buffer_jbddirty(bh));
@@ -330,8 +327,8 @@ static int __process_buffer(journal_t *journal, struct journal_head *jh,
 		if (*batch_count == NR_BATCH) {
 			spin_unlock(&journal->j_list_lock);
 			__flush_batch(journal, bhs, batch_count);
-			ret = 1;
-		}
+		} else
+			ret = 0;
 	}
 	return ret;
 }
-- 
1.7.0.4

