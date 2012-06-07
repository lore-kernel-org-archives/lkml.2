Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab2FGESS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:18:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59627 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab2FGESL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:18:11 -0400
Message-Id: <20120607040341.877426395@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:14 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 38/82] vfs: umount_tree() might be called on subtree that had never made it
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 63d37a84ab6004c235314ffd7a76c5eb28c2fae0 upstream.

__mnt_make_shortterm() in there undoes the effect of __mnt_make_longterm()
we'd done back when we set ->mnt_ns non-NULL; it should not be done to
vfsmounts that had never gone through commit_tree() and friends.  Kudos to
lczerner for catching that one...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1073,8 +1073,9 @@ void umount_tree(struct mount *mnt, int
 		list_del_init(&p->mnt_expire);
 		list_del_init(&p->mnt_list);
 		__touch_mnt_namespace(p->mnt_ns);
+		if (p->mnt_ns)
+			__mnt_make_shortterm(p);
 		p->mnt_ns = NULL;
-		__mnt_make_shortterm(p);
 		list_del_init(&p->mnt_child);
 		if (mnt_has_parent(p)) {
 			p->mnt_parent->mnt_ghosts++;


