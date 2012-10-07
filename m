Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab2JGXXP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:23:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38490 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754290Ab2JGXWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:48 -0400
Message-Id: <20121007225843.414964653@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Miklos Szeredi <miklos@szeredi.hu>, Miklos Szeredi <mszeredi@suse.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 063/108] vfs: dcache: fix deadlock in tree traversal
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <miklos@szeredi.hu>

commit 8110e16d42d587997bcaee0c864179e6d93603fe upstream.

IBM reported a deadlock in select_parent().  This was found to be caused
by taking rename_lock when already locked when restarting the tree
traversal.

There are two cases when the traversal needs to be restarted:

 1) concurrent d_move(); this can only happen when not already locked,
    since taking rename_lock protects against concurrent d_move().

 2) racing with final d_put() on child just at the moment of ascending
    to parent; rename_lock doesn't protect against this rare race, so it
    can happen when already locked.

Because of case 2, we need to be able to handle restarting the traversal
when rename_lock is already held.  This patch fixes all three callers of
try_to_ascend().

IBM reported that the deadlock is gone with this patch.

[ I rewrote the patch to be smaller and just do the "goto again" if the
  lock was already held, but credit goes to Miklos for the real work.
   - Linus ]

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/dcache.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 0364af2..693f95b 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1134,6 +1134,8 @@ positive:
 	return 1;
 
 rename_retry:
+	if (locked)
+		goto again;
 	locked = 1;
 	write_seqlock(&rename_lock);
 	goto again;
@@ -1236,6 +1238,8 @@ out:
 rename_retry:
 	if (found)
 		return found;
+	if (locked)
+		goto again;
 	locked = 1;
 	write_seqlock(&rename_lock);
 	goto again;
@@ -3035,6 +3039,8 @@ resume:
 	return;
 
 rename_retry:
+	if (locked)
+		goto again;
 	locked = 1;
 	write_seqlock(&rename_lock);
 	goto again;


