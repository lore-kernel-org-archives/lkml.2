Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1AVAzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:55:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63211 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab1AVAzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:55:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YIuPm4XPuSvOK16oL2EP+6TL6Ym0Ag46cWpDJmXeIAWRbNzHn++T/nVlRISiM8vg6J
         WYR7xXXMuOR4nSzMisscQlr8yVufg2V7YhtXoWYUfGBHEItYgx4tmeFZvICJ0eBA2rv8
         MkPRaG/JaV5pSW+chBchM0si27r9qapZxwq0E=
Message-ID: <4D3A2B69.4010300@gmail.com>
Date: Sat, 22 Jan 2011 00:57:13 +0000
From: Stuart Swales <stuart.swales.croftnuisk@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adfs: add hexadecimal filetype suffix option
References: <4D2DEDDB.1070605@gmail.com> <201101211747.17544.arnd@arndb.de> <20110121172658.GA17911@flint.arm.linux.org.uk> <201101212302.44641.arnd@arndb.de>
In-Reply-To: <201101212302.44641.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure, will give it a thrash on SMP system this weekend.

Stuart

On 21/01/2011 22:02, Arnd Bergmann wrote:
> On Friday 21 January 2011 18:26:58 Russell King wrote:
>> On Fri, Jan 21, 2011 at 05:47:17PM +0100, Arnd Bergmann wrote:
>>
>>> Would you be able to take a look at this? The straightforward approach
>>> would be to add a mutex to adfs_sb_info and use that in place of
>>> lock_kernel. It's mostly a matter of testing to make sure that no
>>> deadlocks get introduced in the process.
>>
>> Note that write support is very limited.  From memory, the only writing it
>> supports is changing directory entries and writing data into existing files
>> (but not extending or truncating them.)
>>
>> The only thing that's supported is updating of existing directory entries,
>> for which it has a read/write lock to protect against multiple callers.
>> I think I assumed at the time that I wouldn't rely on the BKL, so it
>> should be safe to kill it.
>
> Makes sense. Proving that the BKL is not needed is obviously preferred
> over replacing it with a mutex. After your explanation and another look
> at the code, I agree that we can simply remove all references to the BKL
> from adfs, unless someone can find a reason we still need it.
>
> Stuart, could you add this patch to your series then, and give it some
> testing?
>
> 	Arnd
>
> 8<-----
> Subject: adfs: remove the big kernel lock
>
> According to Russell King, adfs was written to not require the big
> kernel lock, and all inode updates are done under adfs_dir_lock.
>
> All other metadata in adfs is read-only and does not require locking.
> The use of the BKL is the result of various pushdowns from the VFS
> operations.
>
> Signed-off-by: Arnd Bergmann<arnd@arndb.de>
> Cc: Russell King<rmk@arm.linux.org.uk>
> Cc: Stuart Swales<stuart.swales.croftnuisk@gmail.com>
> ---
>
>   fs/adfs/dir.c   |    6 ------
>   fs/adfs/inode.c |    6 ------
>   fs/adfs/super.c |   13 +------------
>   3 files changed, 1 insertions(+), 24 deletions(-)
>
> diff --git a/fs/adfs/dir.c b/fs/adfs/dir.c
> index 3b4a764..3d83075 100644
> --- a/fs/adfs/dir.c
> +++ b/fs/adfs/dir.c
> @@ -9,7 +9,6 @@
>    *
>    *  Common directory handling for ADFS
>    */
> -#include<linux/smp_lock.h>
>   #include "adfs.h"
>
>   /*
> @@ -27,8 +26,6 @@ adfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
>   	struct adfs_dir dir;
>   	int ret = 0;
>
> -	lock_kernel();	
> -
>   	if (filp->f_pos>>  32)
>   		goto out;
>
> @@ -70,7 +67,6 @@ free_out:
>   	ops->free(&dir);
>
>   out:
> -	unlock_kernel();
>   	return ret;
>   }
>
> @@ -276,7 +272,6 @@ adfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
>   	struct object_info obj;
>   	int error;
>
> -	lock_kernel();
>   	error = adfs_dir_lookup_byname(dir,&dentry->d_name,&obj);
>   	if (error == 0) {
>   		error = -EACCES;
> @@ -288,7 +283,6 @@ adfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
>   		if (inode)
>   			error = 0;
>   	}
> -	unlock_kernel();
>   	d_add(dentry, inode);
>   	return ERR_PTR(error);
>   }
> diff --git a/fs/adfs/inode.c b/fs/adfs/inode.c
> index 65794b8..09fe401 100644
> --- a/fs/adfs/inode.c
> +++ b/fs/adfs/inode.c
> @@ -7,7 +7,6 @@
>    * it under the terms of the GNU General Public License version 2 as
>    * published by the Free Software Foundation.
>    */
> -#include<linux/smp_lock.h>
>   #include<linux/buffer_head.h>
>   #include<linux/writeback.h>
>   #include "adfs.h"
> @@ -316,8 +315,6 @@ adfs_notify_change(struct dentry *dentry, struct iattr *attr)
>   	unsigned int ia_valid = attr->ia_valid;
>   	int error;
>   	
> -	lock_kernel();
> -
>   	error = inode_change_ok(inode, attr);
>
>   	/*
> @@ -359,7 +356,6 @@ adfs_notify_change(struct dentry *dentry, struct iattr *attr)
>   	if (ia_valid&  (ATTR_SIZE | ATTR_MTIME | ATTR_MODE))
>   		mark_inode_dirty(inode);
>   out:
> -	unlock_kernel();
>   	return error;
>   }
>
> @@ -374,7 +370,6 @@ int adfs_write_inode(struct inode *inode, struct writeback_control *wbc)
>   	struct object_info obj;
>   	int ret;
>
> -	lock_kernel();
>   	obj.file_id	= inode->i_ino;
>   	obj.name_len	= 0;
>   	obj.parent_id	= ADFS_I(inode)->parent_id;
> @@ -384,6 +379,5 @@ int adfs_write_inode(struct inode *inode, struct writeback_control *wbc)
>   	obj.size	= inode->i_size;
>
>   	ret = adfs_dir_update(sb,&obj, wbc->sync_mode == WB_SYNC_ALL);
> -	unlock_kernel();
>   	return ret;
>   }
> diff --git a/fs/adfs/super.c b/fs/adfs/super.c
> index 2d79540..06d7388 100644
> --- a/fs/adfs/super.c
> +++ b/fs/adfs/super.c
> @@ -14,7 +14,6 @@
>   #include<linux/mount.h>
>   #include<linux/seq_file.h>
>   #include<linux/slab.h>
> -#include<linux/smp_lock.h>
>   #include<linux/statfs.h>
>   #include "adfs.h"
>   #include "dir_f.h"
> @@ -120,15 +119,11 @@ static void adfs_put_super(struct super_block *sb)
>   	int i;
>   	struct adfs_sb_info *asb = ADFS_SB(sb);
>
> -	lock_kernel();
> -
>   	for (i = 0; i<  asb->s_map_size; i++)
>   		brelse(asb->s_map[i].dm_bh);
>   	kfree(asb->s_map);
>   	kfree(asb);
>   	sb->s_fs_info = NULL;
> -
> -	unlock_kernel();
>   }
>
>   static int adfs_show_options(struct seq_file *seq, struct vfsmount *mnt)
> @@ -359,15 +354,11 @@ static int adfs_fill_super(struct super_block *sb, void *data, int silent)
>   	struct adfs_sb_info *asb;
>   	struct inode *root;
>
> -	lock_kernel();
> -
>   	sb->s_flags |= MS_NODIRATIME;
>
>   	asb = kzalloc(sizeof(*asb), GFP_KERNEL);
> -	if (!asb) {
> -		unlock_kernel();
> +	if (!asb)
>   		return -ENOMEM;
> -	}
>   	sb->s_fs_info = asb;
>
>   	/* set default options */
> @@ -485,7 +476,6 @@ static int adfs_fill_super(struct super_block *sb, void *data, int silent)
>   		adfs_error(sb, "get root inode failed\n");
>   		goto error;
>   	}
> -	unlock_kernel();
>   	return 0;
>
>   error_free_bh:
> @@ -493,7 +483,6 @@ error_free_bh:
>   error:
>   	sb->s_fs_info = NULL;
>   	kfree(asb);
> -	unlock_kernel();
>   	return -EINVAL;
>   }
>


-- 
Stuart Swales
