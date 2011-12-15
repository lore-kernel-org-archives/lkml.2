Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab1LOJEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 04:04:34 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63239 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab1LOJEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 04:04:31 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] audit: fix mark refcounting
References: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu>
	<87ipljcjc2.fsf@tucsk.pomaz.szeredi.hu>
	<CA+55aFxuGPj5rhFYt3O1yci_CqHe+Xs8U7WrWOih2W9U73N69w@mail.gmail.com>
	<20111215084050.GQ2203@ZenIV.linux.org.uk>
	<87fwgmjjr9.fsf@tucsk.pomaz.szeredi.hu>
Date: Thu, 15 Dec 2011 10:03:41 +0100
In-Reply-To: <87fwgmjjr9.fsf@tucsk.pomaz.szeredi.hu> (Miklos Szeredi's message
	of "Thu, 15 Dec 2011 09:56:26 +0100")
Message-ID: <87aa6ujjf6.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated patch:

----
From: Miklos Szeredi <mszeredi@suse.cz>
Subject: fsnotify: hold reference to mark around destroy

Removing the parent of a watched file results in "kernel BUG at
fs/notify/mark.c:139".

To reproduce

  add "-w /tmp/audit/dir/watched_file" to audit.rules
  rm -rf /tmp/audit/dir

This is caused by fsnotify_destroy_mark() being called without an
extra reference taken by the caller.

Reported by Francesco Cosoleto here:

  https://bugzilla.novell.com/show_bug.cgi?id=689860

Linus noticed that the call in

 fs/notify/inotify/inotify_fsnotify.c

has also missing reference to mark.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Eric Paris <eparis@redhat.com>
CC: stable@vger.kernel.org
---
 fs/notify/inotify/inotify_fsnotify.c |    5 ++++-
 kernel/audit_watch.c                 |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: linux.git/kernel/audit_watch.c
===================================================================
--- linux.git.orig/kernel/audit_watch.c	2011-12-14 13:59:47.000000000 +0100
+++ linux.git/kernel/audit_watch.c	2011-12-15 09:57:53.000000000 +0100
@@ -349,7 +349,9 @@ static void audit_remove_parent_watches(
 	}
 	mutex_unlock(&audit_filter_mutex);
 
+	audit_get_parent(parent);
 	fsnotify_destroy_mark(&parent->mark);
+	audit_put_parent(parent);
 }
 
 /* Get path information necessary for adding watches. */
Index: linux.git/fs/notify/inotify/inotify_fsnotify.c
===================================================================
--- linux.git.orig/fs/notify/inotify/inotify_fsnotify.c	2011-09-13 16:08:20.000000000 +0200
+++ linux.git/fs/notify/inotify/inotify_fsnotify.c	2011-12-15 09:59:15.000000000 +0100
@@ -130,8 +130,11 @@ static int inotify_handle_event(struct f
 			ret = PTR_ERR(added_event);
 	}
 
-	if (inode_mark->mask & IN_ONESHOT)
+	if (inode_mark->mask & IN_ONESHOT) {
+		fsnotify_get_mark(inode_mark);
 		fsnotify_destroy_mark(inode_mark);
+		fsnotify_put_mark(inode_mark);
+	}
 
 	return ret;
 }
