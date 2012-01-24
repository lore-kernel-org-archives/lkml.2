Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab2AXCrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:47:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655Ab2AXCrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:47:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:30 2012
Message-Id: <20120124023930.191626652@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Miklos Szeredi <mszeredi@suse.cz>
Subject: [071/129] fsnotify: dont BUG in fsnotify_destroy_mark()
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1575
Lines: 55

From: Miklos Szeredi <mszeredi@suse.cz>

commit fed474857efbed79cd390d0aee224231ca718f63 upstream.

Removing the parent of a watched file results in "kernel BUG at
fs/notify/mark.c:139".

To reproduce

  add "-w /tmp/audit/dir/watched_file" to audit.rules
  rm -rf /tmp/audit/dir

This is caused by fsnotify_destroy_mark() being called without an
extra reference taken by the caller.

Reported by Francesco Cosoleto here:

  https://bugzilla.novell.com/show_bug.cgi?id=689860

Fix by removing the BUG_ON and adding a comment about not accessing mark after
the iput.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/notify/mark.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -135,9 +135,6 @@ void fsnotify_destroy_mark(struct fsnoti
 
 	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
 
-	/* 1 from caller and 1 for being on i_list/g_list */
-	BUG_ON(atomic_read(&mark->refcnt) < 2);
-
 	spin_lock(&group->mark_lock);
 
 	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
@@ -182,6 +179,11 @@ void fsnotify_destroy_mark(struct fsnoti
 		iput(inode);
 
 	/*
+	 * We don't necessarily have a ref on mark from caller so the above iput
+	 * may have already destroyed it.  Don't touch from now on.
+	 */
+
+	/*
 	 * it's possible that this group tried to destroy itself, but this
 	 * this mark was simultaneously being freed by inode.  If that's the
 	 * case, we finish freeing the group here.


