Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab2LMOgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:36:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44680 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795Ab2LMOJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:09:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 146/241] jbd: Fix lock ordering bug in journal_unmap_buffer()
Date: Thu, 13 Dec 2012 11:58:31 -0200
Message-Id: <1355407206-17100-147-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 25389bb207987b5774182f763b9fb65ff08761c8 upstream.

Commit 09e05d48 introduced a wait for transaction commit into
journal_unmap_buffer() in the case we are truncating a buffer undergoing commit
in the page stradding i_size on a filesystem with blocksize < pagesize. Sadly
we forgot to drop buffer lock before waiting for transaction commit and thus
deadlock is possible when kjournald wants to lock the buffer.

Fix the problem by dropping the buffer lock before waiting for transaction
commit. Since we are still holding page lock (and that is OK), buffer cannot
disappear under us.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/jbd/transaction.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 78b7f84..7f5120b 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1961,7 +1961,9 @@ retry:
 			spin_unlock(&journal->j_list_lock);
 			jbd_unlock_bh_state(bh);
 			spin_unlock(&journal->j_state_lock);
+			unlock_buffer(bh);
 			log_wait_commit(journal, tid);
+			lock_buffer(bh);
 			goto retry;
 		}
 		/*
-- 
1.7.9.5

