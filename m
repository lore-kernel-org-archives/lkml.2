Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab0LYVcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 16:32:16 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16847 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0LYVcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 16:32:14 -0500
Date: Sat, 25 Dec 2010 22:22:30 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-btrfs@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: [PATCH] btrfs: Don't pass NULL ptr to func that may deref it.
Message-ID: <alpine.LNX.2.00.1012252214540.10759@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In fs/btrfs/inode.c::fixup_tree_root_location() we have this code:

...
 		if (!path) {
 			err = -ENOMEM;
 			goto out;
 		}
...
 	out:
 		btrfs_free_path(path);
 		return err;

btrfs_free_path() passes its argument on to other functions and some of 
them end up dereferencing the pointer.
In the code above that pointer is clearly NULL, so btrfs_free_path() will 
eventually cause a NULL dereference.

There are many ways to cut this cake (fix the bug). The one I chose was to 
make btrfs_free_path() deal gracefully with NULL pointers. If you 
disagree, feel free to come up with an alternative patch.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 ctree.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9ac1715..99599f1 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -105,6 +105,8 @@ noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
 /* this also releases the path */
 void btrfs_free_path(struct btrfs_path *p)
 {
+	if (!p)
+		return;
 	btrfs_release_path(NULL, p);
 	kmem_cache_free(btrfs_path_cachep, p);
 }



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

