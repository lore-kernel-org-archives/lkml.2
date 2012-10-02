Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab2JBA2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:28:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64745 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab2JBARX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:23 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 11/49] vfs: allocate page instead of names_cache buffer in mount_block_root
Date: Mon,  1 Oct 2012 20:16:20 -0400
Message-Id: <1349137018-21948-12-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, it's incorrect to call putname() after __getname_gfp() since the
bare __getname_gfp() call skips the auditing code, while putname()
doesn't.

mount_block_root allocates a PATH_MAX buffer via __getname_gfp, and then
calls get_fs_names to fill the buffer. That function can call
get_filesystem_list which assumes that that buffer is a full page in
size. On arches where PAGE_SIZE != 4k, then this could potentially
overrun.

In practice, it's hard to imagine the list of filesystem names even
approaching 4k, but it's best to be safe. Just allocate a page for this
purpose instead.

With this, we can also remove the __getname_gfp() definition since there
are no more callers.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/fs.h | 3 +--
 init/do_mounts.c   | 7 ++++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index aa11047..69513a7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2221,8 +2221,7 @@ extern void __init vfs_caches_init(unsigned long);
 
 extern struct kmem_cache *names_cachep;
 
-#define __getname_gfp(gfp)	kmem_cache_alloc(names_cachep, (gfp))
-#define __getname()		__getname_gfp(GFP_KERNEL)
+#define __getname()		kmem_cache_alloc(names_cachep, GFP_KERNEL)
 #define __putname(name)		kmem_cache_free(names_cachep, (void *)(name))
 #ifndef CONFIG_AUDITSYSCALL
 #define putname(name)   __putname(name)
diff --git a/init/do_mounts.c b/init/do_mounts.c
index d3f0aee..f8a6642 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -353,8 +353,9 @@ static int __init do_mount_root(char *name, char *fs, int flags, void *data)
 
 void __init mount_block_root(char *name, int flags)
 {
-	char *fs_names = __getname_gfp(GFP_KERNEL
-		| __GFP_NOTRACK_FALSE_POSITIVE);
+	struct page *page = alloc_page(GFP_KERNEL |
+					__GFP_NOTRACK_FALSE_POSITIVE);
+	char *fs_names = page_address(page);
 	char *p;
 #ifdef CONFIG_BLOCK
 	char b[BDEVNAME_SIZE];
@@ -406,7 +407,7 @@ retry:
 #endif
 	panic("VFS: Unable to mount root fs on %s", b);
 out:
-	putname(fs_names);
+	put_page(page);
 }
  
 #ifdef CONFIG_ROOT_NFS
-- 
1.7.11.4

