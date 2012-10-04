Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2JDVv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:51:26 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56720 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061Ab2JDVXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:23:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Miklos Szeredi <mszeredi@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 01/52] vfs: dcache: fix deadlock in tree traversal
Date: Thu,  4 Oct 2012 14:20:52 -0700
Message-Id: <20121004210635.539049678@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1116,6 +1116,8 @@ positive:
 	return 1;
 
 rename_retry:
+	if (locked)
+		goto again;
 	locked = 1;
 	write_seqlock(&rename_lock);
 	goto again;
@@ -1218,6 +1220,8 @@ out:
 rename_retry:
 	if (found)
 		return found;
+	if (locked)
+		goto again;
 	locked = 1;
 	write_seqlock(&rename_lock);
 	goto again;
@@ -2963,6 +2967,8 @@ resume:
 	return;
 
 rename_retry:
+	if (locked)
+		goto again;
 	locked = 1;
 	write_seqlock(&rename_lock);
 	goto again;


