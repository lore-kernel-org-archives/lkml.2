Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab2IPXYo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 19:24:44 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:39456 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2IPXYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 19:24:16 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>, viro@zeniv.linux.org.uk, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
References: <87wr002z39.fsf@devron.myhome.or.jp>
	<20120913063906.GA24974@localhost>
	<871ui6e4tl.fsf@devron.myhome.or.jp>
	<20120914111429.GA19509@localhost>
	<87r4q4n6r1.fsf@devron.myhome.or.jp>
	<20120914131952.GA4952@quack.suse.cz>
	<87ipbgn2gz.fsf@devron.myhome.or.jp>
	<20120914144543.GB4952@quack.suse.cz>
	<878vccmygy.fsf@devron.myhome.or.jp>
	<20120916214912.GA7503@quack.suse.cz>
Date: Mon, 17 Sep 2012 08:24:08 +0900
In-Reply-To: <20120916214912.GA7503@quack.suse.cz> (Jan Kara's message of
	"Sun, 16 Sep 2012 23:49:12 +0200")
Message-ID: <87wqzt7drb.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> I'm not sure what you meant though. What is the difference with ignoring
>> WBC_SYNC_NONE?
>   When you completely ignore WB_SYNC_NONE writeback, you'll soon drive the
> machine close to dirty limits and processes dirtying pages will get
> throttled. Because flusher threads won't be able to write pages - they
> do WB_SYNC_NONE writeback when we have too many dirty pages - processes
> will be throttled until somebody calls sync(1) or someone writes the data
> for some other reason... So I suspect things won't really work as you
> expect.

I think you know how to solve it though. You can add the periodic flush
in own task. And you can check bdi->dirty_exceeded in any handlers.

Well, ok. The alternative plan but more bigger change is to add the
handler to writeback task path. This would be better way, and core
should be able to request to flush with usual way (I guess this is what
you are concerning).  And I believe some FS can implement the simpler
and more efficient writeback path.

But this would look like what reiserfs4 was submitted in past (before
bdi was introduced), and unfortunately never accepted though.

Since situation was changed, will we accept it?

OK, why my FS requires it? Because basic strategy try to keep the
consistency of user view, not only internal metadata consistency.
I.e. it works like to flush the snapshot of user view.

So, flushing metadata/data by arbitrary order like current writeback
task does is unacceptable (of course, except request by user). And
writeback task will never know the correct order of FS.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
