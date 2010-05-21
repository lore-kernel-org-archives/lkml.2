Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934345Ab0EUQ7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:59:30 -0400
Received: from kroah.org ([198.145.64.141]:39123 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934256Ab0EUQy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:28 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@maxwell.aristanetworks.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/38] sysfs: Add support for tagged directories with untagged members.
Date: Fri, 21 May 2010 09:53:52 -0700
Message-Id: <1274460848-11377-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.aristanetworks.com>

I had hopped to avoid this but the bonding driver adds a file
to /sys/class/net/  and the easiest way to handle that file is
to make it untagged and to register it only once.

So relax the rules on tagged directories, and make bonding work.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |   12 +++---------
 fs/sysfs/inode.c |    2 ++
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b2b8306..a63eb4b 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -383,12 +383,6 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 	if (sysfs_find_dirent(acxt->parent_sd, sd->s_ns, sd->s_name))
 		return -EEXIST;
 
-	if (sysfs_ns_type(acxt->parent_sd) && !sd->s_ns) {
-		WARN(1, KERN_WARNING "sysfs: ns required in '%s' for '%s'\n",
-			acxt->parent_sd->s_name, sd->s_name);
-		return -EINVAL;
-	}
-
 	sd->s_parent = sysfs_get(acxt->parent_sd);
 
 	sysfs_link_sibling(sd);
@@ -545,7 +539,7 @@ struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
 	struct sysfs_dirent *sd;
 
 	for (sd = parent_sd->s_dir.children; sd; sd = sd->s_sibling) {
-		if (sd->s_ns != ns)
+		if (ns && sd->s_ns && (sd->s_ns != ns))
 			continue;
 		if (!strcmp(sd->s_name, name))
 			return sd;
@@ -879,7 +873,7 @@ static struct sysfs_dirent *sysfs_dir_pos(const void *ns,
 		while (pos && (ino > pos->s_ino))
 			pos = pos->s_sibling;
 	}
-	while (pos && pos->s_ns != ns)
+	while (pos && pos->s_ns && pos->s_ns != ns)
 		pos = pos->s_sibling;
 	return pos;
 }
@@ -890,7 +884,7 @@ static struct sysfs_dirent *sysfs_dir_next_pos(const void *ns,
 	pos = sysfs_dir_pos(ns, parent_sd, ino, pos);
 	if (pos)
 		pos = pos->s_sibling;
-	while (pos && pos->s_ns != ns)
+	while (pos && pos->s_ns && pos->s_ns != ns)
 		pos = pos->s_sibling;
 	return pos;
 }
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index cf2bad1..bbd77e9 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -335,6 +335,8 @@ int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const void *ns, const cha
 	sysfs_addrm_start(&acxt, dir_sd);
 
 	sd = sysfs_find_dirent(dir_sd, ns, name);
+	if (sd && (sd->s_ns != ns))
+		sd = NULL;
 	if (sd)
 		sysfs_remove_one(&acxt, sd);
 
-- 
1.7.0.3

