Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab0JEKcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:32:06 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56713 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945Ab0JEKcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:32:02 -0400
Message-Id: <20101005103133.895162262@szeredi.hu>
References: <20101005103108.288743609@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 05 Oct 2010 12:31:09 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] vfs: fix infinite loop caused by clone_mnt race
Content-Disposition: inline; filename=vfs-fix-clone-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If clone_mnt() happens while mnt_make_readonly() is running, the
cloned mount might have MNT_WRITE_HOLD flag set, which results in
mnt_want_write() spinning forever on this mount.

Needs CAP_SYS_ADMIN to trigger deliberately and unlikely to happen
accidentally.  But if it does happen it can hang the machine.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-10-01 21:54:17.000000000 +0200
+++ linux-2.6/fs/namespace.c	2010-10-01 21:54:30.000000000 +0200
@@ -595,7 +595,7 @@ static struct vfsmount *clone_mnt(struct
 				goto out_free;
 		}
 
-		mnt->mnt_flags = old->mnt_flags;
+		mnt->mnt_flags = old->mnt_flags & ~MNT_WRITE_HOLD;
 		atomic_inc(&sb->s_active);
 		mnt->mnt_sb = sb;
 		mnt->mnt_root = dget(root);

-- 
