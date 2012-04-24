Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab2DXWiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:38:04 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:49931 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932818Ab2DXWhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:37:55 -0400
Message-Id: <20120424223254.862179878@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shaohua Li <shli@fusionio.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: [ 16/42] jbd2: use GFP_NOFS for blkdev_issue_flush
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/commit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -683,7 +683,7 @@ start_journal_io:
 	if (commit_transaction->t_need_data_flush &&
 	    (journal->j_fs_dev != journal->j_dev) &&
 	    (journal->j_flags & JBD2_BARRIER))
-		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
+		blkdev_issue_flush(journal->j_fs_dev, GFP_NOFS, NULL);
 
 	/* Done it all: now write the commit record asynchronously. */
 	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
@@ -819,7 +819,7 @@ wait_for_iobuf:
 	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
 				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT) &&
 	    journal->j_flags & JBD2_BARRIER) {
-		blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL);
+		blkdev_issue_flush(journal->j_dev, GFP_NOFS, NULL);
 	}
 
 	if (err)


