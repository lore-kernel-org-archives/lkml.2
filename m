Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab2ALRAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:00:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50704 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab2ALRAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:00:20 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] audit: fix mark refcounting
References: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu>
	<87ipljcjc2.fsf@tucsk.pomaz.szeredi.hu>
	<CA+55aFxuGPj5rhFYt3O1yci_CqHe+Xs8U7WrWOih2W9U73N69w@mail.gmail.com>
	<20111215084050.GQ2203@ZenIV.linux.org.uk>
	<87fwgmjjr9.fsf@tucsk.pomaz.szeredi.hu>
	<87aa6ujjf6.fsf@tucsk.pomaz.szeredi.hu> <20111215200631.GA2379@Neptun>
	<20111215225517.GT2203@ZenIV.linux.org.uk>
Date: Thu, 12 Jan 2012 17:59:46 +0100
In-Reply-To: <20111215225517.GT2203@ZenIV.linux.org.uk> (Al Viro's message of
	"Thu, 15 Dec 2011 22:55:17 +0000")
Message-ID: <871ur4j1q5.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> Dunno...  Neither instance actually touches the mark after that
> destroy_mark and we have very few of those guys (fortunately).  So
> removing this BUG_ON() instead might be the right thing to do.

So here's a patch doing that.  Tested okay.

Please apply.

Thanks,
Miklos


---
From: Miklos Szeredi <mszeredi@suse.cz>
Subject: fsnotify: don't BUG in fsnotify_destroy_mark()

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
CC: stable@vger.kernel.org
---
 fs/notify/mark.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/fs/notify/mark.c
===================================================================
--- linux-2.6.orig/fs/notify/mark.c	2011-10-26 14:26:23.000000000 +0200
+++ linux-2.6/fs/notify/mark.c	2012-01-12 14:25:40.000000000 +0100
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
