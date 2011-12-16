Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964926Ab1LPUE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:04:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932761Ab1LPTuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:50:21 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:46:01 2011
Message-Id: <20111216194601.772728446@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Miklos Szeredi <mszeredi@suse.cz>,
        Josef Bacik <josef@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [47/53] fuse: fix llseek bug
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit b48c6af2086ab2ba8a9c9b6ce9ecb34592ce500c upstream.

The test in fuse_file_llseek() "not SEEK_CUR or not SEEK_SET" always evaluates
to true.

This was introduced in 3.1 by commit 06222e49 (fs: handle SEEK_HOLE/SEEK_DATA
properly in all fs's that define their own llseek) and changed the behavior of
SEEK_CUR and SEEK_SET to always retrieve the file attributes.  This is a
performance regression.

Fix the test so that it makes sense.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Josef Bacik <josef@redhat.com>
CC: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1556,7 +1556,7 @@ static loff_t fuse_file_llseek(struct fi
 	struct inode *inode = file->f_path.dentry->d_inode;
 
 	mutex_lock(&inode->i_mutex);
-	if (origin != SEEK_CUR || origin != SEEK_SET) {
+	if (origin != SEEK_CUR && origin != SEEK_SET) {
 		retval = fuse_update_attributes(inode, NULL, file, NULL);
 		if (retval)
 			goto exit;


