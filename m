Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161524Ab1FAJXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:23:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161482Ab1FAIKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:10:14 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:07 2011
Message-Id: <20110601080307.257788058@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:41 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [045/146] jbd: fix fsync() tid wraparound bug
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ted Ts'o <tytso@mit.edu>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd/journal.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -437,9 +437,12 @@ int __log_space_left(journal_t *journal)
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
 		 * We want a new commit: OK, mark the request and wakeup the
 		 * commit thread.  We do _not_ do the commit ourselves.
@@ -451,7 +454,14 @@ int __log_start_commit(journal_t *journa
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
 


