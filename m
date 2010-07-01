Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434Ab0GAVsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:48:51 -0400
Received: from kroah.org ([198.145.64.141]:60982 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759037Ab0GAVOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:04 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:54 2010
Message-Id: <20100701174254.267009471@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [093/200] clean DCACHE_CANT_MOUNT in d_delete()
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 13e3c5e5b9c67e59074d24e29f3ff794bb4dfef0 upstream.

We set the "it's dead, don't mount on it" flag _and_ do not remove it if
we turn the damn thing negative and leave it around.  And if it goes
positive afterwards, well...

Fortunately, there's only one place where that needs to be caught:
only d_delete() can turn the sucker negative without immediately freeing
it; all other places that can lead to ->d_iput() call are followed by
unconditionally freeing struct dentry in question.  So the fix is obvious:

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16014
Reported-by: Adam Tkac <vonsch@gmail.com>
Tested-by: Adam Tkac <vonsch@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/dcache.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1529,6 +1529,7 @@ void d_delete(struct dentry * dentry)
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
 	if (atomic_read(&dentry->d_count) == 1) {
+		dentry->d_flags &= ~DCACHE_CANT_MOUNT;
 		dentry_iput(dentry);
 		fsnotify_nameremove(dentry, isdir);
 		return;


