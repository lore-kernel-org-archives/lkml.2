Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab2ILXeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:34:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab2ILXeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:34:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Jan Kara <jack@suse.cz>
Subject: [ 058/108] jbd: dont write superblock when unmounting an ro filesystem
Date: Wed, 12 Sep 2012 16:28:56 -0700
Message-Id: <20120912232456.628040019@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 2e84f2641ea91a730642ead558a4ee3bd52310c9 upstream.

This sequence:

results in an IO error when unmounting the RO filesystem. The bug was
introduced by:

commit 9754e39c7bc51328f145e933bfb0df47cd67b6e9
Author: Jan Kara <jack@suse.cz>
Date:   Sat Apr 7 12:33:03 2012 +0200

    jbd: Split updating of journal superblock and marking journal empty

which lost some of the magic in journal_update_superblock() which
used to test for a journal with no outstanding transactions.

This is a port of a jbd2 fix by Eric Sandeen.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd/journal.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1113,6 +1113,11 @@ static void mark_journal_empty(journal_t
 
 	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
 	spin_lock(&journal->j_state_lock);
+	/* Is it already empty? */
+	if (sb->s_start == 0) {
+		spin_unlock(&journal->j_state_lock);
+		return;
+	}
 	jbd_debug(1, "JBD: Marking journal as empty (seq %d)\n",
         	  journal->j_tail_sequence);
 


