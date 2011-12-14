Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab1LNOgC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:36:02 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63590 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab1LNOgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:36:00 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH resend] audit: fix mark refcounting
References: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu>
Date: Wed, 14 Dec 2011 15:35:09 +0100
In-Reply-To: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu> (Miklos Szeredi's message
	of "Mon, 07 Nov 2011 15:59:18 +0100")
Message-ID: <87ipljcjc2.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this should go into 3.2 (and stable).

Please apply.

Thanks,
Miklos
----

From: Miklos Szeredi <mszeredi@suse.cz>
Subject: audit: fix mark refcounting

Removing the parent of a watched file results in "kernel BUG at
fs/notify/mark.c:139".

To reproduce

  add "-w /tmp/audit/dir/watched_file" to audit.rules
  rm -rf /tmp/audit/dir

This is caused by fsnotify_destroy_mark() being called without an
extra reference taken by the caller.

Reported by Francesco Cosoleto here:

  https://bugzilla.novell.com/show_bug.cgi?id=689860

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Eric Paris <eparis@redhat.com>
CC: stable@vger.kernel.org
---
 kernel/audit_watch.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux.git/kernel/audit_watch.c
===================================================================
--- linux.git.orig/kernel/audit_watch.c	2011-12-06 16:39:48.000000000 +0100
+++ linux.git/kernel/audit_watch.c	2011-12-13 14:05:37.000000000 +0100
@@ -349,7 +349,9 @@ static void audit_remove_parent_watches(
 	}
 	mutex_unlock(&audit_filter_mutex);
 
+	audit_get_parent(parent);
 	fsnotify_destroy_mark(&parent->mark);
+	audit_put_parent(parent);
 }
 
 /* Get path information necessary for adding watches. */
