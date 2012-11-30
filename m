Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab2K3TXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:23:18 -0500
Received: from mail.kernel.org ([198.145.19.201]:58439 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992722Ab2K3S4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>
Subject: [ 33/56] jbd: Fix lock ordering bug in journal_unmap_buffer()
Date: Fri, 30 Nov 2012 10:55:25 -0800
Message-Id: <20121130185121.652401086@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd/transaction.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1963,7 +1963,9 @@ retry:
 			spin_unlock(&journal->j_list_lock);
 			jbd_unlock_bh_state(bh);
 			spin_unlock(&journal->j_state_lock);
+			unlock_buffer(bh);
 			log_wait_commit(journal, tid);
+			lock_buffer(bh);
 			goto retry;
 		}
 		/*


