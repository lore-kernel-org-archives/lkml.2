Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0DNIAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 04:00:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:37891 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab0DNIAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 04:00:23 -0400
Date: Wed, 14 Apr 2010 10:00:19 +0200
From: Jan Blunck <jblunck@suse.de>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH 5/5] ext2: Add ext2_sb_info s_lock spinlock
Message-ID: <20100414080019.GQ10776@bolzano.suse.de>
References: <1271104905-8804-1-git-send-email-jblunck@suse.de> <1271104905-8804-6-git-send-email-jblunck@suse.de> <o2r3f9a31f41004140010t7c553e39ib51e69fa9022a75f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <o2r3f9a31f41004140010t7c553e39ib51e69fa9022a75f@mail.gmail.com>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, Jaswinder Singh Rajput wrote:

> Hello,
> 
> On Tue, Apr 13, 2010 at 2:11 AM, Jan Blunck <jblunck@suse.de> wrote:
> > Add a spinlock that protects against concurrent modifications of
> > s_mount_state, s_blocks_last, s_overhead_last and the content of the
> > superblock's buffer pointed to by sbi->s_es. This is a preparation patch
> > for removing the BKL from ext2 in the next patch.
> >
> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > Cc: Andi Kleen <andi@firstfloor.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> > ---
> >  fs/ext2/inode.c            |    2 ++
> >  fs/ext2/super.c            |   31 +++++++++++++++++++++++++++++--
> >  include/linux/ext2_fs_sb.h |    6 ++++++
> >  3 files changed, 37 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> > index fc13cc1..5d15442 100644
> > --- a/fs/ext2/inode.c
> > +++ b/fs/ext2/inode.c
> > @@ -1407,9 +1407,11 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
> >                                * created, add a flag to the superblock.
> >                                */
> >                                lock_kernel();
> > +                               spin_lock(&EXT2_SB(sb)->s_lock);
> >                                ext2_update_dynamic_rev(sb);
> >                                EXT2_SET_RO_COMPAT_FEATURE(sb,
> >                                        EXT2_FEATURE_RO_COMPAT_LARGE_FILE);
> > +                               spin_unlock(&EXT2_SB(sb)->s_lock);
> >                                unlock_kernel();
> >                                ext2_write_super(sb);
> 
> Do we need both locks (kernel lock and spin lock)
> 

The BKL is removed in a separate patch. First I though it should get merged
through Frederic's tree but since the removal does not depend on the pushdown
from do_new_mount() I guess it is safe to add here.

Thanks,
Jan
