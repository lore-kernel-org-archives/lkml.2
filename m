Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab2IMHyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:54:08 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38324 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab2IMHyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:54:06 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
References: <87wr002z39.fsf@devron.myhome.or.jp>
	<20120913063906.GA24974@localhost>
Date: Thu, 13 Sep 2012 16:53:58 +0900
In-Reply-To: <20120913063906.GA24974@localhost> (Fengguang Wu's message of
	"Thu, 13 Sep 2012 14:39:06 +0800")
Message-ID: <871ui6e4tl.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

> On Wed, Sep 12, 2012 at 03:28:42AM +0900, OGAWA Hirofumi wrote:
>> 
>> If bdi has BDI_CAP_NO_WRITEBACK, bdi_forker_thread() doesn't start
>> writeback thread. This means there is no consumer of work item made
>> by bdi_queue_work().
>> 
>> This adds to checking of !bdi_cap_writeback_dirty(sb->s_bdi) before
>> calling bdi_queue_work(), otherwise queued work never be consumed.
>> 
>> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>> ---
>> 
>>  fs/fs-writeback.c |    7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>> 
>> diff -puN fs/fs-writeback.c~noop_backing_dev_info-check-fix fs/fs-writeback.c
>> --- linux/fs/fs-writeback.c~noop_backing_dev_info-check-fix	2012-09-11 06:12:30.000000000 +0900
>> +++ linux-hirofumi/fs/fs-writeback.c	2012-09-11 06:12:30.000000000 +0900
>> @@ -120,6 +120,9 @@ __bdi_start_writeback(struct backing_dev
>>  {
>>  	struct wb_writeback_work *work;
>>  
>> +	if (!bdi_cap_writeback_dirty(bdi))
>> +		return;
>
> Will someone in the current kernel actually call
> __bdi_start_writeback() on a BDI_CAP_NO_WRITEBACK bdi?
>
> If the answer is no, VM_BUG_ON(!bdi_cap_writeback_dirty(bdi)) looks better.

I guess nobody call it in current kernel though. Hmm.., but we also have
check in __mark_inode_dirty(), nobody should be using it, right?

If we defined it as the bug, I can't see what BDI_CAP_NO_WRITEBACK wants
to do actually.  We are not going to allow to disable the writeback task?

I was going to use this to disable writeback task on my developing FS...

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
