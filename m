Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964776Ab2FAORH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:17:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:39264 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933321Ab2FAORE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:17:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="147036897"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: [PATCH 4/5] reiserfs: mark the superblock as dirty a bit later
Date: Fri,  1 Jun 2012 17:18:07 +0300
Message-Id: <1338560288-10727-5-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338560288-10727-1-git-send-email-dedekind1@gmail.com>
References: <1338560288-10727-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The 'journal_mark_dirty()' function currently first marks the superblock as
dirty by setting 's_dirt' to 1, then does various sanity checks and returns,
then actuall does all the magic with the journal.

This is not an ideal order, though. It makes more sense to first do all the
checks, then do all the internal stuff, and at the end notify the VFS that the
superblock is now dirty.

This patch moves the 's_dirt = 1' assignment from the very beginning of this
function to the very end.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/reiserfs/journal.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 68aea62..e5e06dd 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -3231,8 +3231,6 @@ int journal_mark_dirty(struct reiserfs_transaction_handle *th,
 			       th->t_trans_id, journal->j_trans_id);
 	}
 
-	sb->s_dirt = 1;
-
 	prepared = test_clear_buffer_journal_prepared(bh);
 	clear_buffer_journal_restore_dirty(bh);
 	/* already in this transaction, we are done */
@@ -3316,6 +3314,7 @@ int journal_mark_dirty(struct reiserfs_transaction_handle *th,
 		journal->j_first = cn;
 		journal->j_last = cn;
 	}
+	sb->s_dirt = 1;
 	return 0;
 }
 
-- 
1.7.7.6

