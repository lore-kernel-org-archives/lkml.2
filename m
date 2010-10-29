Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729Ab0J2J6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 05:58:32 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56593 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933703Ab0J2J62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 05:58:28 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V22 06/14] fs: Don't allow to create hardlink for deleted file
Date: Fri, 29 Oct 2010 15:27:15 +0530
Message-Id: <1288346243-12211-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288346243-12211-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1288346243-12211-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add inode->i_nlink == 0 check in VFS. Some of the file systems
do this internally. A followup patch will remove those instance.
This is needed to ensure that with link by handle we don't allow
to create hardlink of an unlinked file. The check also prevent a race
between unlink and link

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index ea6656e..9c8d4cc 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2620,7 +2620,11 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 		return error;
 
 	mutex_lock(&inode->i_mutex);
-	error = dir->i_op->link(old_dentry, dir, new_dentry);
+	/* Make sure we don't allow creating hardlink to an unlinked file */
+	if (inode->i_nlink == 0)
+		error =  -ENOENT;
+	else
+		error = dir->i_op->link(old_dentry, dir, new_dentry);
 	mutex_unlock(&inode->i_mutex);
 	if (!error)
 		fsnotify_link(dir, inode, new_dentry);
-- 
1.7.1

