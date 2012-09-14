Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab2INNH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:07:56 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38797 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab2INNHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:07:55 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
References: <87wr002z39.fsf@devron.myhome.or.jp>
	<20120913063906.GA24974@localhost>
	<871ui6e4tl.fsf@devron.myhome.or.jp>
	<20120914111429.GA19509@localhost>
	<87r4q4n6r1.fsf@devron.myhome.or.jp>
	<20120914125312.GA20973@localhost>
Date: Fri, 14 Sep 2012 22:07:48 +0900
In-Reply-To: <20120914125312.GA20973@localhost> (Fengguang Wu's message of
	"Fri, 14 Sep 2012 20:53:12 +0800")
Message-ID: <87mx0sn463.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

>> The writeback task is always called with sync_mode != WB_SYNC_ALL except
>> sync_inodes_sb(). But FS has sb->s_op->sync_fs() handler for
>> sync_inodes_sb() path. So, writeback task just bothers FS to control to
>> flush.
>> 
>> Also it wants to control the reclaimable of inode cache too, because FS
>> have to control to flush, and wants to use inode in own FS task, and it
>> knows when inode is cleaned and can be reclaimed.
>> 
>> I thought there are 2 options - 1) pin inode with iget(), and iput() on
>> own FS task, 2) disable writeback task and care about inode reclaim by
>> dirty flags.
>> 
>> (1) was complex (e.g. inode can be the orphan inode), and seems to be
>> ineffective workaround to survive with writeback task.
>
> In principle, the VFS should of course give enough flexibility for the
> FS. But it's all about the details that matter. As for the
> BDI_CAP_NO_WRITEBACK approach, I'm afraid you'll not get the expected
> "FS control" through it. Because the flusher thread may already have a
> long queue of works which will take long time to finish. It even have
> its internal background/periodic works that's not controllable this
> way, see wb_check_background_flush().

wb_check_background_flush() is called from,

bdi_forker_thread()
    bdi_writeback_thread()
        wb_do_writeback()
            wb_check_background_flush()

But, bdi_forker_thread() never start bdi_writeback_thread() if
!bdi_cap_writeback_dirty(bdi).

Or I'm seeing something wrong here?

> And BDI_CAP_NO_WRITEBACK is expected to be a static/constant flag that
> always evaluate to true/false for a given bdi.  There will be
> correctness problems if you change the BDI_CAP_NO_WRITEBACK flag
> dynamically.

I'm going to use it as static or per-sb by initialized in
fill_super(). And it uses always BDI_CAP_NO_WRITEBACK if sb is
available. Because own FS task flush instead.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
