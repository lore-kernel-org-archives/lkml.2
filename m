Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab2HTEOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:14:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54493 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2HTD6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:58:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 16/32] ext4: make sure the journal sb is written in ext4_clear_journal_err()
Date: Sun, 19 Aug 2012 20:57:12 -0700
Message-Id: <20120820035650.114172576@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035647.862247088@linuxfoundation.org>
References: <20120820035647.862247088@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit d796c52ef0b71a988364f6109aeb63d79c5b116b upstream.

After we transfer set the EXT4_ERROR_FS bit in the file system
superblock, it's not enough to call jbd2_journal_clear_err() to clear
the error indication from journal superblock --- we need to call
jbd2_journal_update_sb_errno() as well.  Otherwise, when the root file
system is mounted read-only, the journal is replayed, and the error
indicator is transferred to the superblock --- but the s_errno field
in the jbd2 superblock is left set (since although we cleared it in
memory, we never flushed it out to disk).

This can end up confusing e2fsck.  We should make e2fsck more robust
in this case, but the kernel shouldn't be leaving things in this
confused state, either.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c      |    1 +
 fs/jbd2/journal.c    |    3 ++-
 include/linux/jbd2.h |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4227,6 +4227,7 @@ static void ext4_clear_journal_err(struc
 		ext4_commit_super(sb, 1);
 
 		jbd2_journal_clear_err(journal);
+		jbd2_journal_update_sb_errno(journal);
 	}
 }
 
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1340,7 +1340,7 @@ static void jbd2_mark_journal_empty(jour
  * Update a journal's errno.  Write updated superblock to disk waiting for IO
  * to complete.
  */
-static void jbd2_journal_update_sb_errno(journal_t *journal)
+void jbd2_journal_update_sb_errno(journal_t *journal)
 {
 	journal_superblock_t *sb = journal->j_superblock;
 
@@ -1352,6 +1352,7 @@ static void jbd2_journal_update_sb_errno
 
 	jbd2_write_superblock(journal, WRITE_SYNC);
 }
+EXPORT_SYMBOL(jbd2_journal_update_sb_errno);
 
 /*
  * Read the superblock for a given journal, performing initial
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1091,6 +1091,7 @@ extern int	   jbd2_journal_destroy    (j
 extern int	   jbd2_journal_recover    (journal_t *journal);
 extern int	   jbd2_journal_wipe       (journal_t *, int);
 extern int	   jbd2_journal_skip_recovery	(journal_t *);
+extern void	   jbd2_journal_update_sb_errno(journal_t *);
 extern void	   jbd2_journal_update_sb_log_tail	(journal_t *, tid_t,
 				unsigned long, int);
 extern void	   __jbd2_journal_abort_hard	(journal_t *);


