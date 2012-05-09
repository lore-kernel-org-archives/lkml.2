Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab2EIGSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:18:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38980 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756455Ab2EIFxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:25 -0400
Message-Id: <20120509055033.164719500@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shaohua Li <shli@kernel.org>,
        Shaohua Li <shli@fusionio.com>, Theodore Tso <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>
Subject: [ 026/167] [PATCH] jbd2: use GFP_NOFS for blkdev_issue_flush
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaohua Li <shli@kernel.org>

commit 99aa78466777083255b876293e9e83dec7cd809a upstream.

flush request is issued in transaction commit code path, so looks using
GFP_KERNEL to allocate memory for flush request bio falls into the classic
deadlock issue.  I saw btrfs and dm get it right, but ext4, xfs and md are
using GFP.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/jbd2/commit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 806525a..840f70f 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -723,7 +723,7 @@ start_journal_io:
 	if (commit_transaction->t_need_data_flush &&
 	    (journal->j_fs_dev != journal->j_dev) &&
 	    (journal->j_flags & JBD2_BARRIER))
-		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
+		blkdev_issue_flush(journal->j_fs_dev, GFP_NOFS, NULL);
 
 	/* Done it all: now write the commit record asynchronously. */
 	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
@@ -859,7 +859,7 @@ wait_for_iobuf:
 	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
 				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT) &&
 	    journal->j_flags & JBD2_BARRIER) {
-		blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL);
+		blkdev_issue_flush(journal->j_dev, GFP_NOFS, NULL);
 	}
 
 	if (err)
-- 
1.7.10



