Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab2IDQRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:17:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52033 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab2IDQRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:17:53 -0400
Date: Tue, 4 Sep 2012 17:17:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org,
        bfields@fieldses.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
Message-ID: <20120904161747.GJ23464@ZenIV.linux.org.uk>
References: <1346774264-8031-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346774264-8031-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 12:57:44AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> All the files on a FAT partition have an on-disk directory entry.
> The location of these entries, i_pos, is unique and is constructed by the
> fat_make_i_pos() function.We can use this as the inode number making it
> peristent across remounts.

> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -954,6 +954,8 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	new_dir->i_version++;
>  
>  	fat_detach(old_inode);
> +	if (MSDOS_SB(sb)->options.nfs)
> +		old_inode->i_ino = new_i_pos;

Sigh...  Inode numbers are reported by fstat() in stat.st_ino.  They must
	* remain constant from open() to close(), even if file gets
unlinked or renamed.
	* be equal for two simultaneously opened descriptors with the same
st_dev *ONLY* if those descriptors refer to the same file (i.e. if writing
through one of those would change the data read through another, etc.)

And yes, the userland code does depend on those properties.  There's a damn
good reason why we had gone for all those convolutions with separate hash,
etc.

inode->i_ino on a live struct inode is _never_ changed.  Period.
