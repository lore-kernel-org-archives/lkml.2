Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab0EJWwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:52:32 -0400
Received: from kroah.org ([198.145.64.141]:33028 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab0EJWwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:04 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:20 2010
Message-Id: <20100510223320.447017067@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [036/117] nfs d_revalidate() is too trigger-happy with d_drop()
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit d9e80b7de91db05c1c4d2e5ebbfd70b3b3ba0e0f upstream.

If dentry found stale happens to be a root of disconnected tree, we
can't d_drop() it; its d_hash is actually part of s_anon and d_drop()
would simply hide it from shrink_dcache_for_umount(), leading to
all sorts of fun, including busy inodes on umount and oopsen after
that.

Bug had been there since at least 2006 (commit c636eb already has it),
so it's definitely -stable fodder.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -837,6 +837,8 @@ out_zap_parent:
 		/* If we have submounts, don't unhash ! */
 		if (have_submounts(dentry))
 			goto out_valid;
+		if (dentry->d_flags & DCACHE_DISCONNECTED)
+			goto out_valid;
 		shrink_dcache_parent(dentry);
 	}
 	d_drop(dentry);


