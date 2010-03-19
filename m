Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab0CSIjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 04:39:21 -0400
Received: from mail.in-ulm.de ([217.10.8.10]:44740 "HELO mail.in-ulm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753071Ab0CSIjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 04:39:19 -0400
Date: Fri, 19 Mar 2010 09:39:17 +0100
From: Christian Ehrhardt <lk@c--e.de>
To: linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH] Fix ecryptfs related OOPs after umount
Message-ID: <20100319083917.GE16643@lisa.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

the following patch removes a d_drop in ecryptfs that is bogus IMHO.
This d_drop unhashes a perfectly valid and reachable dentry in the
lower FS. The patch fixes this perfectly reproducible kernel oops:

    https://bugzilla.kernel.org/show_bug.cgi?id=10907

It and may or may not be related to this ecryptfs bug:

   https://bugs.launchpad.net/ecryptfs/+bug/363734

At least the BUG_ON is on a dentry that should not be unhashed but is.

      regards   Christian


Signed-off-by: Christian Ehrhardt <lk@c--e.de>

diff --git a/fs/ecryptfs/super.c b/fs/ecryptfs/super.c
index b15a43a..1a037f7 100644
--- a/fs/ecryptfs/super.c
+++ b/fs/ecryptfs/super.c
@@ -85,7 +85,6 @@ static void ecryptfs_destroy_inode(struct inode *inode)
 		if (lower_dentry->d_inode) {
 			fput(inode_info->lower_file);
 			inode_info->lower_file = NULL;
-			d_drop(lower_dentry);
 		}
 	}
 	ecryptfs_destroy_crypt_stat(&inode_info->crypt_stat);
