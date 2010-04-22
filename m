Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab0DVT7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:59:52 -0400
Received: from kroah.org ([198.145.64.141]:59418 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757895Ab0DVT7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:43 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:06 2010
Message-Id: <20100422195406.090651965@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Mahoney <jeffm@suse.com>,
       Thomas Siedentopf <thomas.siedentopf@novell.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [013/139] reiserfs: Fix locking BUG during mount failure
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Mahoney <jeffm@jeffreymahoney.com>

commit b7b7fa43103a9fb30dbcc60cbd5161fdfc25f904 upstream.

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
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/reiserfs/super.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1619,10 +1619,8 @@ static int reiserfs_fill_super(struct su
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
@@ -1879,12 +1877,12 @@ static int reiserfs_fill_super(struct su
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


