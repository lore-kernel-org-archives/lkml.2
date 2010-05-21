Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934328Ab0EUQzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:55:07 -0400
Received: from kroah.org ([198.145.64.141]:39155 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934117Ab0EUQye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:34 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/38] sysfs: Remove usage of S_BIAS to avoid merge conflict with the vfs tree
Date: Fri, 21 May 2010 09:53:58 -0700
Message-Id: <1274460848-11377-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@aristanetworks.com>

In Al's latest vfs tree the code is reworked and S_BIAS has been removed.

It turns out that checking to see if a super block is in the
middle of an unmount in sysfs_exit_ns is unnecessary because we
remove the super_block from the s_supers/s_instances list before
struct sysfs_super_info pointed to by sb->s_fs_info is freed.

For now just delete the unnecessary check to see if a superblock is in the
middle of an unmount, it isn't necessary with or without Al's changes
and it just causes a needless conflict.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/mount.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 1afa32b..281c0c9 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -138,6 +138,9 @@ static void sysfs_kill_sb(struct super_block *sb)
 {
 	struct sysfs_super_info *info = sysfs_info(sb);
 
+	/* Remove the superblock from fs_supers/s_instances
+	 * so we can't find it, before freeing sysfs_super_info.
+	 */
 	kill_anon_super(sb);
 	kfree(info);
 }
@@ -156,9 +159,11 @@ void sysfs_exit_ns(enum kobj_ns_type type, const void *ns)
 	spin_lock(&sb_lock);
 	list_for_each_entry(sb, &sysfs_fs_type.fs_supers, s_instances) {
 		struct sysfs_super_info *info = sysfs_info(sb);
-		/* Ignore superblocks that are in the process of unmounting */
-		if (sb->s_count <= S_BIAS)
-			continue;
+		/*
+		 * If we see a superblock on the fs_supers/s_instances
+		 * list the unmount has not completed and sb->s_fs_info
+		 * points to a valid struct sysfs_super_info.
+		 */
 		/* Ignore superblocks with the wrong ns */
 		if (info->ns[type] != ns)
 			continue;
-- 
1.7.0.3

