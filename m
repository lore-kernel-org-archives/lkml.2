Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab1KGPA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:00:27 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58251 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1KGPAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:00:25 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] audit: fix mark refcounting
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 07 Nov 2011 15:59:18 +0100
Message-ID: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

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
--- linux.git.orig/kernel/audit_watch.c	2011-09-13 16:08:20.000000000 +0200
+++ linux.git/kernel/audit_watch.c	2011-11-07 15:19:07.000000000 +0100
@@ -349,7 +349,9 @@ static void audit_remove_parent_watches(
 	}
 	mutex_unlock(&audit_filter_mutex);
 
+	audit_get_parent(parent);
 	fsnotify_destroy_mark(&parent->mark);
+	audit_put_parent(parent);
 }
 
 /* Get path information necessary for adding watches. */
