Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab1A2TJc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 14:09:32 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:45499 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab1A2TJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 14:09:29 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V26 14/16] fs: limit linkat syscall with null relative name to CAP_DAC_READ_SEARCH
Date: Sun, 30 Jan 2011 00:38:17 +0530
Message-Id: <1296328099-23263-15-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296328099-23263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296328099-23263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't want to allow creation of private hardlinks by different application
using the fd passed to them via SCM_RIGHTS. So limit the null relative name
usage in linkat syscall to CAP_DAC_READ_SEARCH

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 990b155..5c4902c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3408,6 +3408,18 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 	return error;
 }
 
+static int null_name(const char __user *name)
+{
+	int retval = 0;
+	char *tmp = getname_null(name);
+	if (!IS_ERR(tmp)) {
+		if (*tmp == 0)
+			retval = 1;
+	}
+	putname(tmp);
+	return retval;
+}
+
 /*
  * Hardlinks are often used in delicate situations.  We avoid
  * security-related surprises by not following symlinks on the
@@ -3428,6 +3440,15 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 
 	if ((flags & ~AT_SYMLINK_FOLLOW) != 0)
 		return -EINVAL;
+	/*
+	 * To use null names we require CAP_DAC_READ_SEARCH
+	 * This ensures that not everyone will be able to create
+	 * handlink using the passed filedescriptor.
+	 */
+	if (null_name(oldname)) {
+		if (!capable(CAP_DAC_READ_SEARCH))
+			return -ENOENT;
+	}
 
 	error = user_path_at(olddfd, oldname,
 			     flags & AT_SYMLINK_FOLLOW ? LOOKUP_FOLLOW : 0,
-- 
1.7.1

