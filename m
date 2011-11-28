Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab1K1PEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:04:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab1K1PEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:04:02 -0500
Date: Mon, 28 Nov 2011 16:04:00 +0100
From: Jan Kara <jack@suse.cz>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, dm-devel@redhat.com,
        Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [PATCH] deadlock with suspend and quotas
Message-ID: <20111128150400.GE6366@quack.suse.cz>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Fri 25-11-11 15:25:16, Mikulas Patocka wrote:
> This script causes a kernel deadlock:
> #!/bin/sh
> set -e
> DEVICE=/dev/vg1/linear
> lvchange -ay $DEVICE
> mkfs.ext3 $DEVICE
> mount -t ext3 -o usrquota,grpquota $DEVICE /mnt/test
> quotacheck -gu /mnt/test
> umount /mnt/test
> mount -t ext3 -o usrquota,grpquota $DEVICE /mnt/test
> quotaon /mnt/test
> dmsetup suspend $DEVICE
> setquota -u root 1 2 3 4 /mnt/test &
> sleep 1
> dmsetup resume $DEVICE
> 
> setquota acquired semaphore s_umount for read and then tried to perform
> a transaction (and waits because the device is suspended).
> dmsetup resume tries to acquire s_umount for write before resuming the device
> (and waits for setquota).
> 
> Here are stacktraces:
> setquota:
> [   67.524456]  [<ffffffff810aa84e>] ? get_page_from_freelist+0x31e/0x790
> [   67.524529]  [<ffffffffa0250265>] ? start_this_handle.isra.9+0x265/0x3b0 [jbd]
> [   67.524604]  [<ffffffff8105bc00>] ? add_wait_queue+0x60/0x60
> [   67.524675]  [<ffffffffa02505a1>] ? journal_start+0xc1/0x100 [jbd]
> [   67.524742]  [<ffffffff810e62d6>] ? kmem_cache_alloc+0xf6/0x1b0
> [   67.524808]  [<ffffffffa028018d>] ? ext3_acquire_dquot+0x3d/0x80 [ext3]
> [   67.524872]  [<ffffffff81143749>] ? dqget+0x359/0x3b0
> [   67.524916]  [<ffffffff81143ad4>] ? dquot_get_dqblk+0x14/0x1b0
> [   67.524985]  [<ffffffff81147c34>] ? quota_getquota+0x24/0xd0
> [   67.525048]  [<ffffffff810ff3db>] ? do_path_lookup+0x2b/0x90
> [   67.525082]  [<ffffffff810ff8cd>] ? kern_path+0x1d/0x40
> [   67.525134]  [<ffffffff81148311>] ? do_quotactl+0x421/0x540
> [   67.525191]  [<ffffffff811073f0>] ? dput+0x20/0x230
> [   67.525234]  [<ffffffff81148507>] ? sys_quotactl+0xd7/0x1a0
> [   67.525304]  [<ffffffff8130a03b>] ? system_call_fastpath+0x16/0x1b
> 
> dmsetup resume:
> [   67.525887]  [<ffffffffa0238280>] ? dev_wait+0xc0/0xc0 [dm_mod]
> [   67.525948]  [<ffffffff81309225>] ? rwsem_down_failed_common+0xc5/0x160
> [   67.526013]  [<ffffffff81198a43>] ? call_rwsem_down_write_failed+0x13/0x20
> [   67.526058]  [<ffffffff81308adc>] ? down_write+0x1c/0x1d
> [   67.526103]  [<ffffffff810f3a91>] ? thaw_super+0x21/0xc0
> [   67.526166]  [<ffffffff81124d4d>] ? thaw_bdev+0x6d/0x90
> [   67.526223]  [<ffffffff8105583e>] ? queue_work+0x4e/0x60
> [   67.526269]  [<ffffffffa0230e63>] ? unlock_fs+0x23/0x40 [dm_mod]
> [   67.526341]  [<ffffffffa02336d0>] ? dm_resume+0xb0/0xd0 [dm_mod]
> [   67.526388]  [<ffffffffa0238420>] ? dev_suspend+0x1a0/0x230 [dm_mod]
> [   67.526441]  [<ffffffffa0238a59>] ? ctl_ioctl+0x159/0x2a0 [dm_mod]
> [   67.526510]  [<ffffffff8116c4ee>] ? ipc_addid+0x4e/0xd0
> [   67.526555]  [<ffffffffa0238bae>] ? dm_ctl_ioctl+0xe/0x20 [dm_mod]
> [   67.526620]  [<ffffffff811025de>] ? do_vfs_ioctl+0x8e/0x4e0
> [   67.526670]  [<ffffffff811073f0>] ? dput+0x20/0x230
> [   67.526737]  [<ffffffff810f3112>] ? fput+0x162/0x220
> [   67.526783]  [<ffffffff81102a79>] ? sys_ioctl+0x49/0x90
> [   67.526838]  [<ffffffff8130a03b>] ? system_call_fastpath+0x16/0x1b
> 
> The following patch fixes the deadlock. When the quota subsystem takes s_umount,
> it checks if the filesystem is frozen. If it is, we drop s_umount, wait for
> the filesystem to resume and retry.
  Thanks for the patch. I'm aware of the deadlock and Val Henson is working
on resolving these types of deadlocks more systematically. But since I
haven't heard from her for a while, I guess I'll merge your fix and she'll
update her series to reflect your change since those patches are going to
go in at earliest in the next merge window.
  To sum up: I've merged your patch.

								Honza
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> CC: stable@kernel.org
> 
> ---
>  fs/quota/quota.c   |   12 ++++++++++++
>  include/linux/fs.h |    1 +
>  2 files changed, 13 insertions(+)
> 
> Index: linux-3.1-fast/fs/quota/quota.c
> ===================================================================
> --- linux-3.1-fast.orig/fs/quota/quota.c	2011-11-25 20:19:14.000000000 +0100
> +++ linux-3.1-fast/fs/quota/quota.c	2011-11-25 21:12:32.000000000 +0100
> @@ -310,7 +310,19 @@ static struct super_block *quotactl_bloc
>  	putname(tmp);
>  	if (IS_ERR(bdev))
>  		return ERR_CAST(bdev);
> +retry_super:
>  	sb = get_super(bdev);
> +	if (sb && sb->s_frozen != SB_UNFROZEN) {
> +		/*
> +		 * When resuming a frozen device, s_umount is taken for write.
> +		 * To avoid deadlock, we drop s_umount if the filesystem
> +		 * is frozen and wait for it to thaw.
> +		 */
> +		up_read(&sb->s_umount);
> +		vfs_check_frozen(sb, SB_FREEZE_WRITE);
> +		put_super(sb);
> +		goto retry_super;
> +	}
>  	bdput(bdev);
>  	if (!sb)
>  		return ERR_PTR(-ENODEV);
> Index: linux-3.1-fast/include/linux/fs.h
> ===================================================================
> --- linux-3.1-fast.orig/include/linux/fs.h	2011-11-25 21:13:56.000000000 +0100
> +++ linux-3.1-fast/include/linux/fs.h	2011-11-25 21:14:03.000000000 +0100
> @@ -2496,6 +2496,7 @@ extern struct file_system_type *get_fs_t
>  extern struct super_block *get_super(struct block_device *);
>  extern struct super_block *get_active_super(struct block_device *bdev);
>  extern struct super_block *user_get_super(dev_t);
> +extern void put_super(struct super_block *sb);
>  extern void drop_super(struct super_block *sb);
>  extern void iterate_supers(void (*)(struct super_block *, void *), void *);
>  extern void iterate_supers_type(struct file_system_type *,
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
