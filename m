Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab0DNHKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 03:10:30 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:35459 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0DNHK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 03:10:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g3D87bixQFITc42WXCXUgm0DtS2C0jCfKSfDT1+pXUIr43YGA+0ge3yviuO64a2azx
         GjXvdu7IE7fdseUv2gGYe5zk5RTy7DVGcGvYyU7fRI+yK1kAWCLKCliSRP5/ufYOgCR4
         /7JTH2p1vQ3tQkp0yQEYmj7upxsmVwaxIuQ/A=
MIME-Version: 1.0
In-Reply-To: <1271104905-8804-6-git-send-email-jblunck@suse.de>
References: <1271104905-8804-1-git-send-email-jblunck@suse.de>
	 <1271104905-8804-6-git-send-email-jblunck@suse.de>
Date: Wed, 14 Apr 2010 12:40:28 +0530
Message-ID: <o2r3f9a31f41004140010t7c553e39ib51e69fa9022a75f@mail.gmail.com>
Subject: Re: [PATCH 5/5] ext2: Add ext2_sb_info s_lock spinlock
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Jan Blunck <jblunck@suse.de>
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 13, 2010 at 2:11 AM, Jan Blunck <jblunck@suse.de> wrote:
> Add a spinlock that protects against concurrent modifications of
> s_mount_state, s_blocks_last, s_overhead_last and the content of the
> superblock's buffer pointed to by sbi->s_es. This is a preparation patch
> for removing the BKL from ext2 in the next patch.
>
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
>  fs/ext2/inode.c            |    2 ++
>  fs/ext2/super.c            |   31 +++++++++++++++++++++++++++++--
>  include/linux/ext2_fs_sb.h |    6 ++++++
>  3 files changed, 37 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index fc13cc1..5d15442 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1407,9 +1407,11 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
>                                * created, add a flag to the superblock.
>                                */
>                                lock_kernel();
> +                               spin_lock(&EXT2_SB(sb)->s_lock);
>                                ext2_update_dynamic_rev(sb);
>                                EXT2_SET_RO_COMPAT_FEATURE(sb,
>                                        EXT2_FEATURE_RO_COMPAT_LARGE_FILE);
> +                               spin_unlock(&EXT2_SB(sb)->s_lock);
>                                unlock_kernel();
>                                ext2_write_super(sb);

Do we need both locks (kernel lock and spin lock)

Thanks,
--
JSR
