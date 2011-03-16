Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1CPRSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:18:07 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38720 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab1CPRSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:18:05 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-reply-to: <20110316144253.GT22723@ZenIV.linux.org.uk> (message from Al Viro
	on Wed, 16 Mar 2011 14:42:53 +0000)
Subject: Re: [git pull] several fixes
References: <20110316144253.GT22723@ZenIV.linux.org.uk>
Message-Id: <E1PzuM6-0006iJ-KV@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 16 Mar 2011 18:17:54 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011, Al Viro wrote:
> 	Several fixes, including the brown paperbag one for -ELOOP breakage
> in the last commit of yesterday pull.  Please, pull from the usual place -
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

__fput doesn't need a cdev_put() for O_PATH handles.

Signed-off-by: mszeredi@suse.cz
---
 fs/file_table.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/file_table.c
===================================================================
--- linux-2.6.orig/fs/file_table.c	2011-03-16 16:13:25.000000000 +0100
+++ linux-2.6/fs/file_table.c	2011-03-16 17:50:22.000000000 +0100
@@ -246,8 +246,10 @@ static void __fput(struct file *file)
 		file->f_op->release(inode, file);
 	security_file_free(file);
 	ima_file_free(file);
-	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
+	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL &&
+		     !(file->f_mode & FMODE_PATH))) {
 		cdev_put(inode->i_cdev);
+	}
 	fops_put(file->f_op);
 	put_pid(file->f_owner.pid);
 	file_sb_list_del(file);


