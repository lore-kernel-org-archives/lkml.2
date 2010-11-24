Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab0KXISo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:18:44 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34062 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab0KXISn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:18:43 -0500
Date: Wed, 24 Nov 2010 17:17:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tim Bird <tim.bird@am.sony.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 09/16 v4] pramfs: dir operations
Message-ID: <20101124081755.GD2212@linux-sh.org>
References: <4CE79C4D.6000104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE79C4D.6000104@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 11:00:45AM +0100, Marco Stornelli wrote:
> +int pram_add_link(struct dentry *dentry, struct inode *inode)
> +{
> +	struct inode *dir = dentry->d_parent->d_inode;
> +	struct pram_inode *pidir, *pi, *pitail = NULL;
> +	u64 tail_ino, prev_ino;
> +
> +	const char *name = dentry->d_name.name;
> +
> +	int namelen = dentry->d_name.len > PRAM_NAME_LEN ?
> +		PRAM_NAME_LEN : dentry->d_name.len;
> +

	namelen = min_t(unsigned int, dentry->d_name.len, PRAM_NAME_LEN);

?

> +#define S_SHIFT 12
> +static unsigned int dtype_by_mode[S_IFMT >> S_SHIFT] = {
> +	[S_IFREG >> S_SHIFT]    DT_REG,
> +	[S_IFDIR >> S_SHIFT]    DT_DIR,
> +	[S_IFCHR >> S_SHIFT]    DT_CHR,
> +	[S_IFBLK >> S_SHIFT]    DT_BLK,
> +	[S_IFIFO >> S_SHIFT]    DT_FIFO,
> +	[S_IFSOCK >> S_SHIFT]   DT_SOCK,
> +	[S_IFLNK >> S_SHIFT]    DT_LNK,
> +};
> +
> +static int pram_readdir(struct file *filp, void *dirent, filldir_t filldir)
> +{
...
> +		ret = filldir(dirent, name, namelen,
> +			      filp->f_pos, ino,
> +			      dtype_by_mode[(be16_to_cpu(pi->i_mode) & S_IFMT)>>S_SHIFT]);
> +		filp->f_pos = pi->i_d.d_next ? be64_to_cpu(pi->i_d.d_next) : 3;

You might try to provide some generic helpers for this, at least GFS2
also does the same thing:

include/linux/gfs2_ondisk.h:#define DT2IF(dt) (((dt) << 12) & S_IFMT)
include/linux/gfs2_ondisk.h:#define IF2DT(sif) (((sif) & S_IFMT) >> 12)
