Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1HKV3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:29:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35733 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab1HKV3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:29:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-ext4@vger.kernel.org
Subject: [PATCH] fs / ext3: Always unlock updates in ext3_freeze()
Date: Thu, 11 Aug 2011 23:31:13 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
References: <201108112329.23043.rjw@sisk.pl>
In-Reply-To: <201108112329.23043.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108112331.13241.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

In analogy with ext4 make ext3_freeze() always call
journal_unlock_updates() to prevent it from leaving a locked mutex
behind.  Accordingly, modify ext3_unfreeze() so that it doesn't
call journal_unlock_updates() any more.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Sorry for the duplicate, the previous one was sent too early.

---
 fs/ext3/super.c |   39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

Index: linux/fs/ext3/super.c
===================================================================
--- linux.orig/fs/ext3/super.c
+++ linux/fs/ext3/super.c
@@ -2535,30 +2535,28 @@ static int ext3_sync_fs(struct super_blo
  */
 static int ext3_freeze(struct super_block *sb)
 {
-	int error = 0;
+	int error;
 	journal_t *journal;
 
-	if (!(sb->s_flags & MS_RDONLY)) {
-		journal = EXT3_SB(sb)->s_journal;
+	if (sb->s_flags & MS_RDONLY)
+		return 0;
 
-		/* Now we set up the journal barrier. */
-		journal_lock_updates(journal);
+	journal = EXT3_SB(sb)->s_journal;
 
-		/*
-		 * We don't want to clear needs_recovery flag when we failed
-		 * to flush the journal.
-		 */
-		error = journal_flush(journal);
-		if (error < 0)
-			goto out;
-
-		/* Journal blocked and flushed, clear needs_recovery flag. */
-		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
-		error = ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
-		if (error)
-			goto out;
-	}
-	return 0;
+	/* Now we set up the journal barrier. */
+	journal_lock_updates(journal);
+
+	/*
+	 * We don't want to clear needs_recovery flag when we failed
+	 * to flush the journal.
+	 */
+	error = journal_flush(journal);
+	if (error < 0)
+		goto out;
+
+	/* Journal blocked and flushed, clear needs_recovery flag. */
+	EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
+	error = ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
 
 out:
 	journal_unlock_updates(journal);
@@ -2577,7 +2575,6 @@ static int ext3_unfreeze(struct super_bl
 		EXT3_SET_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
 		ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
 		unlock_super(sb);
-		journal_unlock_updates(EXT3_SB(sb)->s_journal);
 	}
 	return 0;
 }
