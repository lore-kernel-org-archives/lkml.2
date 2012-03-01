Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965571Ab2CAVzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:55:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46239 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965468Ab2CAVu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:29 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.216.4 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213926.418676242@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Colin King <colin.king@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [ 26/34] eCryptfs: Clear i_nlink in rmdir
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit 07850552b92b3637fa56767b5e460b4238014447 upstream.

eCryptfs wasn't clearing the eCryptfs inode's i_nlink after a successful
vfs_rmdir() on the lower directory. This resulted in the inode evict and
destroy paths to be missed.

https://bugs.launchpad.net/ecryptfs/+bug/723518

Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Colin King <colin.king@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -575,6 +575,8 @@ static int ecryptfs_rmdir(struct inode *
 	dget(lower_dentry);
 	rc = vfs_rmdir(lower_dir_dentry->d_inode, lower_dentry);
 	dput(lower_dentry);
+	if (!rc && dentry->d_inode)
+		clear_nlink(dentry->d_inode);
 	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
 	dir->i_nlink = lower_dir_dentry->d_inode->i_nlink;
 	unlock_dir(lower_dir_dentry);


