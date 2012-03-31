Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2CaGxP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 02:53:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36327 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2CaGxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 02:53:12 -0400
Date: Sat, 31 Mar 2012 09:53:05 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Madore <david+ml@madore.org>
Cc: linux-kernel@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
        viro@zeniv.linux.org.uk
Subject: Re: since when does linkat() on deleted /proc/$PID/fd/$num return
 ENOENT ?
Message-ID: <20120331065305.GA3398@p183.telecom.by>
References: <20120330102121.GA5999@aldebaran.gro-tsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330102121.GA5999@aldebaran.gro-tsen.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 12:21:21PM +0200, David Madore wrote:
> It used to be the case (last time I checked was around late 2008 or
> early 2009) that deleted entries from /proc/$PID/fd/ could be linked
> back to the filesystem by using linkat(,,,,AT_SYMLINK_FOLLOW).
> 
> Now this just returns ENOENT.
> 
> I'd like to understand when, how and why this change took place.  What
> commit introduced it and was it a deliberate move (e.g., because the
> feature was a security issue of itself, or came into conflict with
> something else) or was it accidental?

It was explicitly prohibited since 2.6.39:

commit aae8a97d3ec30788790d1720b71d76fd8eb44b73
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Sat Jan 29 18:43:27 2011 +0530

    fs: Don't allow to create hardlink for deleted file
    
    Add inode->i_nlink == 0 check in VFS. Some of the file systems
    do this internally. A followup patch will remove those instance.
    This is needed to ensure that with link by handle we don't allow
    to create hardlink of an unlinked file. The check also prevent a race
    between unlink and link
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/namei.c b/fs/namei.c
index 83e92ba..33be51a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2906,7 +2906,11 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
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
