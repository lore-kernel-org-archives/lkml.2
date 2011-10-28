Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1J1Hx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 03:53:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab1J1Hxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 03:53:55 -0400
Subject: Re: [PATCH 12/13] vfs: count unlinked inodes
From: Miklos Szeredi <mszeredi@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jack@suse.cz, akpm@linux-foundation.org, toshi.okajima@jp.fujitsu.com
In-Reply-To: <20111028060801.GA15345@infradead.org>
References: <1318430946-7091-1-git-send-email-miklos@szeredi.hu>
	 <1318430946-7091-13-git-send-email-miklos@szeredi.hu>
	 <20111028060801.GA15345@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 09:53:53 +0200
Message-ID: <1319788433.13842.8.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-28 at 02:08 -0400, Christoph Hellwig wrote:
> This one gets me a repeated spew of WARN_ONs during XFS log recover,
> repeating the following pattern:

The assumption here is that set_nlink() is called with a non-zero count.
The point of introducing set_nlink() was to verify this assumption,
otherwise pending delete accounting will be screwed up.

If setting i_nlink to zero is not a bug in xfs we can do two things:

 1) do a conditional clear_nlink() in xfs_setup_inode() to document that
nlink can indeed be zero

 2) remove the warning from set_nlink().  That may hide some cases where
i_nlink was cleared without the intention of the filesystem but it will
work just fine wrt. the pending delete accounting. 

Thanks,
Miklos

> 
> [ 1083.852789] ------------[ cut here ]------------
> [ 1083.854471] WARNING: at /home/hch/work/linux-2.6/fs/inode.c:323
> set_nlink+0x46/0x50()
> [ 1083.857632] Hardware name: Bochs
> [ 1083.858731] Modules linked in:
> [ 1083.859932] Pid: 3111, comm: mount Not tainted 3.1.0+ #88
> [ 1083.861735] Call Trace:
> [ 1083.862694]  [<ffffffff8108743a>] warn_slowpath_common+0x7a/0xb0
> [ 1083.864995]  [<ffffffff81087485>] warn_slowpath_null+0x15/0x20
> [ 1083.867465]  [<ffffffff81153b76>] set_nlink+0x46/0x50
> [ 1083.868970]  [<ffffffff813d70a9>] xfs_setup_inode+0x59/0x2b0
> [ 1083.870817]  [<ffffffff813d1b36>] xfs_iget+0x386/0x880
> [ 1083.871809]  [<ffffffff81427406>] xlog_recover_process_one_iunlink+0x46/0x1f0
> [ 1083.872675]  [<ffffffff813c914c>] ? xfs_buf_rele+0x8c/0x1e0
> [ 1083.873523]  [<ffffffff81427648>] xlog_recover_process_iunlinks+0x98/0x130
> [ 1083.874378]  [<ffffffff8142833e>] xlog_recover_finish+0x3e/0xd0
> [ 1083.875130]  [<ffffffff8142ebd4>] xfs_log_mount_finish+0x44/0x50
> [ 1083.875933]  [<ffffffff8142b91e>] xfs_mountfs+0x51e/0x7c0
> [ 1083.876748]  [<ffffffff813d8eda>] ? xfs_mru_cache_create+0x15a/0x180
> [ 1083.877582]  [<ffffffff813db42d>] xfs_fs_fill_super+0x1cd/0x280
> [ 1083.878399]  [<ffffffff8113e662>] mount_bdev+0x1a2/0x1e0
> [ 1083.879090]  [<ffffffff813db260>] ? xfs_finish_flags+0x120/0x120
> [ 1083.879881]  [<ffffffff813d92c0>] xfs_fs_mount+0x10/0x20
> [ 1083.880716]  [<ffffffff8113f12b>] mount_fs+0x1b/0xd0
> [ 1083.881374]  [<ffffffff81157e19>] vfs_kern_mount+0x69/0xf0
> [ 1083.882117]  [<ffffffff811582af>] do_kern_mount+0x4f/0x100
> [ 1083.882831]  [<ffffffff81159dd2>] do_mount+0x542/0x850
> [ 1083.883642]  [<ffffffff81116621>] ? memdup_user+0x41/0x80
> [ 1083.884347]  [<ffffffff811166b3>] ? strndup_user+0x53/0x70
> [ 1083.885062]  [<ffffffff81180c6f>] compat_sys_mount+0xdf/0x260
> [ 1083.885798]  [<ffffffff819e15c5>] sysenter_dispatch+0x7/0x2b
> [ 1083.886518] ---[ end trace 4902e59f8848ff74 ]---
> 


