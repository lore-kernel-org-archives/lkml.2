Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab2ILIBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:01:00 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:37855 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2ILIA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:00:58 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
References: <87wr002z39.fsf@devron.myhome.or.jp>
	<20120912024249.GB17922@localhost>
Date: Wed, 12 Sep 2012 17:00:48 +0900
In-Reply-To: <20120912024249.GB17922@localhost> (Fengguang Wu's message of
	"Wed, 12 Sep 2012 10:42:49 +0800")
Message-ID: <87sjan3c27.fsf@devron.myhome.or.jp>
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
>
> Thanks for catching this! Does this bug have any side effects other
> than memory leaking?
>
> It may be possible for some caller that actually expect it to do some
> work to make progress, otherwise will eventually block.  If so, we'll
> need to fix the caller.

If used custom bdi with BDI_CAP_NO_WRITEBACK, wait_for_completion()
(e.g. sync_inodes_sb()) will be blocked forever.

I tested by custom bdi with BDI_CAP_NO_WRITEBACK - sync(2) blocked
forever by this reason.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
