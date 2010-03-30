Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab0C3XGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:06:48 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37930 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab0C3XGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=X+pTpOl938dwnLwwMo8QOhRIGkkQrm+AkFVv7TCazJLsJ4H5mT5SnEo+ToY4mEUhtI
         rPI3ySroRaWmAhzc79Zy3bjd8DEsRyj48soNNNI2aU1iLT7C5E83gy/sM7Oo8Y6hJxUA
         EYx947oQjZYitGiW+RwI0CMYiWCciAUY/zqD0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Siedentopf <thomas.siedentopf@novell.com>,
       Jeff Mahoney <jeffm@suse.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "2 . 6 . 33 . x" <stable@kernel.org>
Subject: [GIT PULL] reiserfs fix
Date: Wed, 31 Mar 2010 01:06:49 +0200
Message-Id: <1269990409-6238-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the reiserfs/kill-bkl branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	reiserfs/kill-bkl

Thanks,
	Frederic
---

Jeff Mahoney (1):
      reiserfs: Fix locking BUG during mount failure


 fs/reiserfs/super.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

---
commit b7b7fa43103a9fb30dbcc60cbd5161fdfc25f904
Author: Jeff Mahoney <jeffm@jeffreymahoney.com>
Date:   Mon Mar 29 15:12:39 2010 -0400

    reiserfs: Fix locking BUG during mount failure
    
    Commit 8ebc423238341b52912c7295b045a32477b33f09 (reiserfs: kill-the-BKL)
    introduced a bug in the mount failure case.
    
    The error label releases the lock before calling journal_release_error,
    but it requires that the lock be held. do_journal_release unlocks and
    retakes it. When it releases it without it held, we trigger a BUG().
    
    The error_alloc label skips the unlock since the lock isn't held yet
    but none of the other conditions that are clean up exist yet either.
    
    This patch returns immediately after the kzalloc failure and moves
    the reiserfs_write_unlock after the journal_release_error call.
    
    This was reported in https://bugzilla.novell.com/show_bug.cgi?id=591807
    
    Reported-by:  Thomas Siedentopf <thomas.siedentopf@novell.com>
    Signed-off-by: Jeff Mahoney <jeffm@suse.com>
    Cc: Thomas Siedentopf <thomas.siedentopf@novell.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: 2.6.33.x <stable@kernel.org>
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 04bf5d7..ab19051 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1618,10 +1618,8 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	save_mount_options(s, data);
 
 	sbi = kzalloc(sizeof(struct reiserfs_sb_info), GFP_KERNEL);
-	if (!sbi) {
-		errval = -ENOMEM;
-		goto error_alloc;
-	}
+	if (!sbi)
+		return -ENOMEM;
 	s->s_fs_info = sbi;
 	/* Set default values for options: non-aggressive tails, RO on errors */
 	REISERFS_SB(s)->s_mount_opt |= (1 << REISERFS_SMALLTAIL);
@@ -1878,12 +1876,12 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	return (0);
 
 error:
-	reiserfs_write_unlock(s);
-error_alloc:
 	if (jinit_done) {	/* kill the commit thread, free journal ram */
 		journal_release_error(NULL, s);
 	}
 
+	reiserfs_write_unlock(s);
+
 	reiserfs_free_bitmap_cache(s);
 	if (SB_BUFFER_WITH_SB(s))
 		brelse(SB_BUFFER_WITH_SB(s));
