Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052Ab2EOCRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:49004 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964869Ab2EOCQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:09 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 012/179] jbd: fix fsync() tid wraparound bug
Date: Mon, 14 May 2012 22:11:48 -0400
Message-ID: <1337048075-6132-13-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ted Ts'o <tytso@mit.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d9b01934d56a96d9f4ae2d6204d4ea78a36f5f36 upstream.

If an application program does not make any changes to the indirect
blocks or extent tree, i_datasync_tid will not get updated.  If there
are enough commits (i.e., 2**31) such that tid_geq()'s calculations
wrap, and there isn't a currently active transaction at the time of
the fdatasync() call, this can end up triggering a BUG_ON in
fs/jbd/commit.c:

	J_ASSERT(journal->j_running_transaction != NULL);

It's pretty rare that this can happen, since it requires the use of
fdatasync() plus *very* frequent and excessive use of fsync().  But
with the right workload, it can.

We fix this by replacing the use of tid_geq() with an equality test,
since there's only one valid transaction id that is valid for us to
start: namely, the currently running transaction (if it exists).

Reported-by: Martin_Zielinski@McAfee.com
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/jbd/journal.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index bd224ee..45905ff 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -435,9 +435,12 @@ int __log_space_left(journal_t *journal)
 int __log_start_commit(journal_t *journal, tid_t target)
 {
 	/*
-	 * Are we already doing a recent enough commit?
+	 * The only transaction we can possibly wait upon is the
+	 * currently running transaction (if it exists).  Otherwise,
+	 * the target tid must be an old one.
 	 */
-	if (!tid_geq(journal->j_commit_request, target)) {
+	if (journal->j_running_transaction &&
+	    journal->j_running_transaction->t_tid == target) {
 		/*
 		 * We want a new commit: OK, mark the request and wakup the
 		 * commit thread.  We do _not_ do the commit ourselves.
@@ -449,7 +452,14 @@ int __log_start_commit(journal_t *journal, tid_t target)
 			  journal->j_commit_sequence);
 		wake_up(&journal->j_wait_commit);
 		return 1;
-	}
+	} else if (!tid_geq(journal->j_commit_request, target))
+		/* This should never happen, but if it does, preserve
+		   the evidence before kjournald goes into a loop and
+		   increments j_commit_sequence beyond all recognition. */
+		WARN_ONCE(1, "jbd: bad log_start_commit: %u %u %u %u\n",
+		    journal->j_commit_request, journal->j_commit_sequence,
+		    target, journal->j_running_transaction ?
+		    journal->j_running_transaction->t_tid : 0);
 	return 0;
 }
 
-- 
1.7.9.6

