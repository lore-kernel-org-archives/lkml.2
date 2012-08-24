Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab2HXLuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 07:50:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65125 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2HXLut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 07:50:49 -0400
MIME-Version: 1.0
In-Reply-To: <1345333117-2826-1-git-send-email-mail@danrl.de>
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
Date: Fri, 24 Aug 2012 17:20:48 +0530
Message-ID: <CAPEGOO+2fSWg2wiXouEQx6tn2Tp2sFwDg6TrqgACtV-1sqr2cQ@mail.gmail.com>
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
From: Prashant Shah <kerneldev100@gmail.com>
To: Dan Luedtke <mail@danrl.de>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, chaosman@ontika.net, muthur@gmail.com,
        kerolasa@iki.fi, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Aug 19, 2012 at 5:08 AM, Dan Luedtke <mail@danrl.de> wrote:

> +
> +       /* allocate filesystem private data */
> +       fsi = kzalloc(sizeof(*fsi), GFP_KERNEL);
> +       if (!fsi)
> +               return -ENOMEM;
> +       spin_lock_init(&fsi->lock);
> +       sb->s_fs_info = fsi;
> +
> +       /* set blocksize to minimum size for fetching superblock */
> +       if (!sb_set_blocksize(sb, 1 << LANYFS_MIN_BLOCKSIZE)) {
> +               if (!silent)
> +                       lanyfs_err(sb, "error setting blocksize to %d bytes",
> +                                  1 << LANYFS_MIN_BLOCKSIZE);
> +               return -EIO;
> +       }
> +
> +       /* fetch superblock */
> +       bh = sb_bread(sb, LANYFS_SUPERBLOCK);
> +       if (!bh) {
> +               if (!silent)
> +                       lanyfs_err(sb, "error reading superblock");
> +               return -EIO;
> +       }
> +       lanysb = (struct lanyfs_sb *) bh->b_data;
> +
> +       /* check magic */
> +       if (lanysb->magic != cpu_to_le32(LANYFS_SUPER_MAGIC)) {
> +               if (!silent)
> +                       lanyfs_info(sb, "bad magic 0x%x",
> +                                   lanysb->magic);
> +               goto exit_invalid;
> +       }
> +       sb->s_magic = LANYFS_SUPER_MAGIC;
> +
> +       /* check block type */
> +       if (lanysb->type != LANYFS_TYPE_SB) {
> +               if (!silent)
> +                       lanyfs_err(sb, "bad block type 0x%x", lanysb->type);
> +               goto exit_invalid;
> +       }
> +
> +       /* check version */
> +       if (lanysb->major > LANYFS_MAJOR_VERSION) {
> +               if (!silent)
> +                       lanyfs_err(sb, "major version mismatch");
> +               goto exit_invalid;
> +       }
> +
> +       /* check address length */
> +       if (lanysb->addrlen < LANYFS_MIN_ADDRLEN ||
> +           lanysb->addrlen > LANYFS_MAX_ADDRLEN) {
> +               if (!silent)
> +                       lanyfs_err(sb, "unsupported address length");
> +               goto exit_invalid;
> +       }
> +       fsi->addrlen = lanysb->addrlen;
> +
> +       /* check blocksize */
> +       if (lanysb->blocksize < LANYFS_MIN_BLOCKSIZE ||
> +           lanysb->blocksize > LANYFS_MAX_BLOCKSIZE) {
> +               if (!silent)
> +                       lanyfs_err(sb, "unsupported blocksize");
> +               goto exit_invalid;
> +       }
> +       fsi->blocksize = lanysb->blocksize;
> +

> +
> +       /* release block buffer */
> +       brelse(bh);
> +
> +       /* parse mount options */
> +       save_mount_options(sb, options);
> +       err = lanyfs_super_options(sb, (char *) options, silent);
> +       if (err)
> +               return err;
> +
> +       /* set blocksize to correct size */
> +       if (!sb_set_blocksize(sb, 1 << fsi->blocksize)) {
> +               if (!silent)
> +                       lanyfs_err(sb, "error setting blocksize to %d bytes",
> +                                  1 << fsi->blocksize);
> +               return -EIO;
> +       }
> +       /* default flags */
> +       sb->s_maxbytes = 0xffffffff; /* TODO: hmmmmm */
> +       sb->s_op = &lanyfs_super_operations;
> +       sb->s_time_gran = 1;
> +       sb->s_flags = MS_NOSUID | MS_NOATIME | MS_NODIRATIME;
> +
> +       /* make root directory */
> +       inode = lanyfs_iget(sb, fsi->rootdir);
> +       if (!inode)
> +               return -ENOMEM;
> +
> +       sb->s_root = d_make_root(inode);
> +       if (!sb->s_root) {
> +               iput(inode);
> +               return -ENOMEM;
> +       }
> +       return 0;
> +
> +exit_invalid:
> +       brelse(bh);
> +       if (!silent)
> +               lanyfs_info(sb, "no valid lanyard filesystem found");
> +       return -EINVAL;
> +}

You should free the memory for "fsi" on error.

Regards.
