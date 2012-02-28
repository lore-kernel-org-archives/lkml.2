Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965530Ab2B1BTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:19:34 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64391 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965515Ab2B1BT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:19:29 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.136.97 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010430.212124679@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tyler Hicks <tyhicks@canonical.com>,
        Sebastien Bacher <seb128@ubuntu.com>,
        John Johansen <john.johansen@canonical.com>
Subject: [ 09/72] eCryptfs: Copy up lower inode attrs after setting lower xattr
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit 545d680938be1e86a6c5250701ce9abaf360c495 upstream.

After passing through a ->setxattr() call, eCryptfs needs to copy the
inode attributes from the lower inode to the eCryptfs inode, as they
may have changed in the lower filesystem's ->setxattr() path.

One example is if an extended attribute containing a POSIX Access
Control List is being set. The new ACL may cause the lower filesystem to
modify the mode of the lower inode and the eCryptfs inode would need to
be updated to reflect the new mode.

https://launchpad.net/bugs/926292

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Reported-by: Sebastien Bacher <seb128@ubuntu.com>
Cc: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1104,6 +1104,8 @@ ecryptfs_setxattr(struct dentry *dentry,
 	}
 
 	rc = vfs_setxattr(lower_dentry, name, value, size, flags);
+	if (!rc)
+		fsstack_copy_attr_all(dentry->d_inode, lower_dentry->d_inode);
 out:
 	return rc;
 }


