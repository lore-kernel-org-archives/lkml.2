Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab0EJXTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:19:49 -0400
Received: from kroah.org ([198.145.64.141]:51647 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932818Ab0EJW5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:41 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:36 2010
Message-Id: <20100510223536.231753968@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Carpenter <error27@gmail.com>
Subject: [20/98] USB: fix testing the wrong variable in fs_create_by_name()
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit fa7fe7af146a7b613e36a311eefbbfb5555325d1 upstream.

There is a typo here.  We should be testing "*dentry" which was just
assigned instead of "dentry".  This could result in dereferencing an
ERR_PTR inside either usbfs_mkdir() or usbfs_create().

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -515,13 +515,13 @@ static int fs_create_by_name (const char
 	*dentry = NULL;
 	mutex_lock(&parent->d_inode->i_mutex);
 	*dentry = lookup_one_len(name, parent, strlen(name));
-	if (!IS_ERR(dentry)) {
+	if (!IS_ERR(*dentry)) {
 		if ((mode & S_IFMT) == S_IFDIR)
 			error = usbfs_mkdir (parent->d_inode, *dentry, mode);
 		else 
 			error = usbfs_create (parent->d_inode, *dentry, mode);
 	} else
-		error = PTR_ERR(dentry);
+		error = PTR_ERR(*dentry);
 	mutex_unlock(&parent->d_inode->i_mutex);
 
 	return error;


