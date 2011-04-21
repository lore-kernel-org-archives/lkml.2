Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1DUR0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 13:26:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57914 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab1DUR0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 13:26:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=qdXhKd/9qFRg9vThdy1IhH6iSWsh3fyqrvEdXSiubJUJhwvS1rqkg5CFOAOT9VFsyz
         ZbmfM7+65JQbG4YDMYdyFe0Zm/MilFSG2BOgwunLy9xsKNd2N8AJGdTC16O+Imx+0ByK
         2oOfB4Aif/+EUpVmKcoustmfQy4kh8QvzTBUM=
From: Miklos Szeredi <miklos@szeredi.hu>
To: Michal Suchanek <hramrach@centrum.cz>
Cc: Jordi Pujol <jordipujolp@gmail.com>,
        Phillip Lougher <phillip.lougher@gmail.com>,
        Andreas Dilger <adilger@dilger.ca>, Jiri Kosina <jkosina@suse.cz>,
        Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ian Kent <ikent@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] tmpfs: implement generic xattr support
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	<871v0wvuod.fsf@tucsk.pomaz.szeredi.hu>
	<BANLkTikv+iCVgG_cgejqJjuS0xURrAvQuw@mail.gmail.com>
	<201104211658.35618.jordipujolp@gmail.com>
	<BANLkTimPN-9dmZKU25oLmUjtGQYDsyCvgw@mail.gmail.com>
	<BANLkTi=HER-HDjLpu8Hw4fCMUwE7ii54_g@mail.gmail.com>
Date: Thu, 21 Apr 2011 19:26:01 +0200
In-Reply-To: <BANLkTi=HER-HDjLpu8Hw4fCMUwE7ii54_g@mail.gmail.com> (Michal
	Suchanek's message of "Thu, 21 Apr 2011 17:43:27 +0200")
Message-ID: <87vcy7v7me.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Suchanek <hramrach@centrum.cz> writes:

> You will be probably interested in this log:
>
> ls: cannot access /usr/share/doc/ucb*: No such file or directory
> ...
> rmdir("/usr/share/doc/ucblogo.dpkg-new") = -1 ENOENT (No such file or directory)
> rmdir("/usr/share/doc/ucblogo.dpkg-tmp") = -1 ENOENT (No such file or directory)
> mkdir("/usr/share/doc/ucblogo.dpkg-new", 0) = 0
> chown32("/usr/share/doc/ucblogo.dpkg-new", 0, 0) = 0
> chmod("/usr/share/doc/ucblogo.dpkg-new", 0755) = 0
> utime("/usr/share/doc/ucblogo.dpkg-new", [2011/04/21-15:37:05,
> 2008/06/08-11:38:17]) = 0
> rename("/usr/share/doc/ucblogo.dpkg-new", "/usr/share/doc/ucblogo") =
> -1 EOPNOTSUPP (Operation not supported)

Oops, stupid mistake.

Following patch should fix it. 

Thanks,
Miklos

commit e90f1946938da7c9502337340126beae1931d239
Author: Miklos Szeredi <mszeredi@suse.cz>
Date:   Thu Apr 21 19:18:23 2011 +0200

    tmpfs: xattr: fix xattr for directories and special files
    
    Forgot to update the xattr methods for some file types.
    
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

diff --git a/mm/shmem.c b/mm/shmem.c
index ac8ec9e..c527484 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2714,10 +2714,10 @@ static const struct inode_operations shmem_dir_inode_operations = {
 	.rename		= shmem_rename,
 #endif
 #ifdef CONFIG_TMPFS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
-	.listxattr	= generic_listxattr,
-	.removexattr	= generic_removexattr,
+	.setxattr	= shmem_setxattr,
+	.getxattr	= shmem_getxattr,
+	.listxattr	= shmem_listxattr,
+	.removexattr	= shmem_removexattr,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_notify_change,
@@ -2727,10 +2727,10 @@ static const struct inode_operations shmem_dir_inode_operations = {
 
 static const struct inode_operations shmem_special_inode_operations = {
 #ifdef CONFIG_TMPFS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
-	.listxattr	= generic_listxattr,
-	.removexattr	= generic_removexattr,
+	.setxattr	= shmem_setxattr,
+	.getxattr	= shmem_getxattr,
+	.listxattr	= shmem_listxattr,
+	.removexattr	= shmem_removexattr,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_notify_change,
