Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756Ab1LPU4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:56:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1LPUz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 15:55:58 -0500
Date: Fri, 16 Dec 2011 12:55:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Hugh Dickins <hughd@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: [PATCH] mm: add missing mutex lock arround notify_change
Message-Id: <20111216125556.db2bf308.akpm@linux-foundation.org>
In-Reply-To: <20111216112534.GA13147@dztty>
References: <20111216112534.GA13147@dztty>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Dec 2011 12:25:34 +0100
Djalal Harouni <tixxdz@opendz.org> wrote:

> 
> Calls to notify_change() must hold i_mutex.
> 

It seems that this is true.  It's tersely documented in
Documentation/filesystems/porting.  It should be mentioned in the
non-existent notify_change() kerneldoc.

<does a quick audit>

fs/hpfs/namei.c and fs/nfsd/vfs.c:nfsd_setattr() aren't obviosuly
holding that lock when calling notify_change().  Everything else under
fs/ looks OK.

I'll add the below to my tree and shall slip it into linux-next, but not
mainline:

--- a/fs/attr.c~a
+++ a/fs/attr.c
@@ -171,6 +171,8 @@ int notify_change(struct dentry * dentry
 	struct timespec now;
 	unsigned int ia_valid = attr->ia_valid;
 
+	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));
+
 	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_TIMES_SET)) {
 		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 			return -EPERM;
@@ -245,5 +247,4 @@ int notify_change(struct dentry * dentry
 
 	return error;
 }
-
 EXPORT_SYMBOL(notify_change);


> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1994,10 +1994,16 @@ EXPORT_SYMBOL(should_remove_suid);
>  
>  static int __remove_suid(struct dentry *dentry, int kill)
>  {
> +	int ret;
>  	struct iattr newattrs;
>  
>  	newattrs.ia_valid = ATTR_FORCE | kill;
> -	return notify_change(dentry, &newattrs);
> +
> +	mutex_lock(&dentry->d_inode->i_mutex);
> +	ret = notify_change(dentry, &newattrs);
> +	mutex_unlock(&dentry->d_inode->i_mutex);
> +
> +	return ret;
>  }
>  
>  int file_remove_suid(struct file *file)

Looks good to me.
