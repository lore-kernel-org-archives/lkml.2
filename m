Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163052Ab1FAI0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:26:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:45024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162991Ab1FAI0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:26:44 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:09 2011
Message-Id: <20110601081209.107816626@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:41 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [131/165] eCryptfs: Clear i_nlink in rmdir
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 932
Lines: 29

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit 07850552b92b3637fa56767b5e460b4238014447 upstream.

eCryptfs wasn't clearing the eCryptfs inode's i_nlink after a successful
vfs_rmdir() on the lower directory. This resulted in the inode evict and
destroy paths to be missed.

https://bugs.launchpad.net/ecryptfs/+bug/723518

Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -527,6 +527,8 @@ static int ecryptfs_rmdir(struct inode *
 	dget(lower_dentry);
 	rc = vfs_rmdir(lower_dir_dentry->d_inode, lower_dentry);
 	dput(lower_dentry);
+	if (!rc && dentry->d_inode)
+		clear_nlink(dentry->d_inode);
 	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
 	dir->i_nlink = lower_dir_dentry->d_inode->i_nlink;
 	unlock_dir(lower_dir_dentry);


