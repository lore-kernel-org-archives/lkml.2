Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687Ab0EYSTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:19:35 -0400
Received: from kroah.org ([198.145.64.141]:44393 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933376Ab0EYSRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:17:32 -0400
X-Mailbox-Line: From gregkh@clark.site Tue May 25 11:12:13 2010
Message-Id: <20100525181213.565182425@clark.site>
User-Agent: quilt/0.48-8.10
Date: Tue, 25 May 2010 11:09:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Carpenter <error27@gmail.com>
Subject: [15/25] USB: fix testing the wrong variable in fs_create_by_name()
In-Reply-To: <20100525181259.GA18630@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -510,13 +510,13 @@ static int fs_create_by_name (const char
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


