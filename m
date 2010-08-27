Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab0H0LEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:04:01 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52541 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab0H0LD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:03:58 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V19 07/15] vfs: Add handle based chown syscall
Date: Fri, 27 Aug 2010 16:32:54 +0530
Message-Id: <1282906982-26918-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/open.c                |   20 ++++++++++++++++++++
 include/linux/syscalls.h |    2 ++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 7abdcba..5e06c12 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -623,6 +623,26 @@ out:
 	return error;
 }
 
+SYSCALL_DEFINE4(handle_chown, int, mountdirfd, struct file_handle __user *, ufh,
+		uid_t, user, gid_t, group)
+{
+	struct path path;
+	int error = -EINVAL;
+
+	error = handle_to_path(mountdirfd, ufh, &path);
+	if (error)
+		goto out;
+	error = mnt_want_write(path.mnt);
+	if (error)
+		goto out_release;
+	error = chown_common(&path, user, group);
+	mnt_drop_write(path.mnt);
+out_release:
+	path_put(&path);
+out:
+	return error;
+}
+
 /*
  * You have to be very careful that these write
  * counts get cleaned up in error cases and
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 9c82364..6dab72b 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -852,4 +852,6 @@ asmlinkage long sys_handle_stat(int mountdirfd,
 #endif
 asmlinkage long sys_handle_link(int mountdirfd, struct file_handle __user *uofh,
 				int newfd, const char __user *newname);
+asmlinkage long sys_handle_chown(int mountdirfd, struct file_handle __user *ufh,
+				 uid_t user, gid_t group);
 #endif
-- 
1.7.0.4

