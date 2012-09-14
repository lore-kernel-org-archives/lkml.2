Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523Ab2INMMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:12:08 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38771 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758727Ab2INMMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:12:05 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
References: <87wr002z39.fsf@devron.myhome.or.jp>
	<20120913063906.GA24974@localhost>
	<871ui6e4tl.fsf@devron.myhome.or.jp>
	<20120914111429.GA19509@localhost>
Date: Fri, 14 Sep 2012 21:12:02 +0900
In-Reply-To: <20120914111429.GA19509@localhost> (Fengguang Wu's message of
	"Fri, 14 Sep 2012 19:14:29 +0800")
Message-ID: <87r4q4n6r1.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

>> >> @@ -120,6 +120,9 @@ __bdi_start_writeback(struct backing_dev
>> >>  {
>> >>  	struct wb_writeback_work *work;
>> >>  
>> >> +	if (!bdi_cap_writeback_dirty(bdi))
>> >> +		return;
>> >
>> > Will someone in the current kernel actually call
>> > __bdi_start_writeback() on a BDI_CAP_NO_WRITEBACK bdi?
>> >
>> > If the answer is no, VM_BUG_ON(!bdi_cap_writeback_dirty(bdi)) looks better.
>> 
>> I guess nobody call it in current kernel though. Hmm.., but we also have
>> check in __mark_inode_dirty(), nobody should be using it, right?
>> 
>> If we defined it as the bug, I can't see what BDI_CAP_NO_WRITEBACK wants
>> to do actually.  We are not going to allow to disable the writeback task?
>
>> I was going to use this to disable writeback task on my developing FS...
>
> That sounds like an interesting use case. Can you elaborate a bit more?
>
> Note that even if you disable __bdi_start_writeback() here, the kernel
> may also start writeback in the page reclaim path, the fsync() path,
> and perhaps more.

page reclaim and fsync path have FS handler. So, FS can control those.

The modern FS have to control to flush carefully. Many FSes are already
ignoring if wbc->sync_mode != WB_SYNC_ALL (e.g. ext3_write_inode,
nilfs_writepages), and have own FS task to flush.

The writeback task is always called with sync_mode != WB_SYNC_ALL except
sync_inodes_sb(). But FS has sb->s_op->sync_fs() handler for
sync_inodes_sb() path. So, writeback task just bothers FS to control to
flush.

Also it wants to control the reclaimable of inode cache too, because FS
have to control to flush, and wants to use inode in own FS task, and it
knows when inode is cleaned and can be reclaimed.

I thought there are 2 options - 1) pin inode with iget(), and iput() on
own FS task, 2) disable writeback task and care about inode reclaim by
dirty flags.

(1) was complex (e.g. inode can be the orphan inode), and seems to be
ineffective workaround to survive with writeback task.

So, I want to do (2).

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
