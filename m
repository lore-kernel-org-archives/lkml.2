Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620Ab0EYSTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:19:33 -0400
Received: from kroah.org ([198.145.64.141]:44396 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933434Ab0EYSRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:17:33 -0400
X-Mailbox-Line: From gregkh@clark.site Tue May 25 11:12:13 2010
Message-Id: <20100525181213.659393652@clark.site>
User-Agent: quilt/0.48-8.10
Date: Tue, 25 May 2010 11:09:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [16/25] nfs d_revalidate() is too trigger-happy with d_drop()
In-Reply-To: <20100525181259.GA18630@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -826,6 +826,8 @@ out_zap_parent:
 		/* If we have submounts, don't unhash ! */
 		if (have_submounts(dentry))
 			goto out_valid;
+		if (dentry->d_flags & DCACHE_DISCONNECTED)
+			goto out_valid;
 		shrink_dcache_parent(dentry);
 	}
 	d_drop(dentry);


