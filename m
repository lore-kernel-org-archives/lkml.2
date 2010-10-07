Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285Ab0JGKxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 06:53:03 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:41009 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542Ab0JGKxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 06:53:01 -0400
Date: Thu, 7 Oct 2010 12:50:15 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: reiserfs-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] reiserfs: simplify conditional
Message-ID: <20101007125015.3040dcc6@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify:
 ((!a && b) || (!a && c) || (!a && d) || (!a && e)) =>
  (!a && (b || c || d || e))

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 fs/reiserfs/journal.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 076c8b1..7fa0814 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -3055,15 +3055,14 @@ static int do_journal_begin_r(struct reiserfs_transaction_handle *th,
 	 ** we don't sleep if there aren't other writers
 	 */
 
-	if ((!join && journal->j_must_wait > 0) ||
-	    (!join
-	     && (journal->j_len_alloc + nblocks + 2) >= journal->j_max_batch)
-	    || (!join && atomic_read(&journal->j_wcount) > 0
-		&& journal->j_trans_start_time > 0
-		&& (now - journal->j_trans_start_time) >
-		journal->j_max_trans_age) || (!join
-					      && atomic_read(&journal->j_jlock))
-	    || (!join && journal->j_cnode_free < (journal->j_trans_max * 3))) {
+	if (!join &&
+	    ((journal->j_must_wait > 0) ||
+	     ((journal->j_len_alloc + nblocks + 2) >= journal->j_max_batch) ||
+	     (atomic_read(&journal->j_wcount) > 0 &&
+	      journal->j_trans_start_time > 0 &&
+	      (now - journal->j_trans_start_time) > journal->j_max_trans_age) ||
+	     (atomic_read(&journal->j_jlock)) ||
+	     (journal->j_cnode_free < (journal->j_trans_max * 3)))) {
 
 		old_trans_id = journal->j_trans_id;
 		unlock_journal(sb);	/* allow others to finish this transaction */
-- 
1.7.2.2
