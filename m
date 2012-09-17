Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2IQJjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:39:14 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:39606 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab2IQJjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:39:13 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>, viro@zeniv.linux.org.uk, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
References: <20120913063906.GA24974@localhost>
	<871ui6e4tl.fsf@devron.myhome.or.jp>
	<20120914111429.GA19509@localhost>
	<87r4q4n6r1.fsf@devron.myhome.or.jp>
	<20120914131952.GA4952@quack.suse.cz>
	<87ipbgn2gz.fsf@devron.myhome.or.jp>
	<20120914144543.GB4952@quack.suse.cz>
	<878vccmygy.fsf@devron.myhome.or.jp>
	<20120916214912.GA7503@quack.suse.cz>
	<87wqzt7drb.fsf@devron.myhome.or.jp>
	<20120917084853.GA9150@quack.suse.cz>
Date: Mon, 17 Sep 2012 18:39:05 +0900
In-Reply-To: <20120917084853.GA9150@quack.suse.cz> (Jan Kara's message of
	"Mon, 17 Sep 2012 10:48:53 +0200")
Message-ID: <87627d6lae.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> I think you know how to solve it though. You can add the periodic flush
>> in own task. And you can check bdi->dirty_exceeded in any handlers.
>   Sure, you can have your private thread. That is possible but you will
> have to duplicate flusher logic and you will still get odd behavior e.g.
> when your filesystem is on one partition and another filesystem is on a
> different partition of the same disk.

Right. But it is what current FSes are doing more or less.

>> Well, ok. The alternative plan but more bigger change is to add the
>> handler to writeback task path. This would be better way, and core
>> should be able to request to flush with usual way (I guess this is what
>> you are concerning).  And I believe some FS can implement the simpler
>> and more efficient writeback path.
>> 
>> But this would look like what reiserfs4 was submitted in past (before
>> bdi was introduced), and unfortunately never accepted though.
>> 
>> Since situation was changed, will we accept it?
>> 
>> OK, why my FS requires it? Because basic strategy try to keep the
>> consistency of user view, not only internal metadata consistency.
>> I.e. it works like to flush the snapshot of user view.
>> 
>> So, flushing metadata/data by arbitrary order like current writeback
>> task does is unacceptable (of course, except request by user). And
>> writeback task will never know the correct order of FS.
>   OK, thanks for explanation. Now I understand what you are trying to do.
> Would it be enough if you could track dirty inodes inside your filesystem
> and provide some callback for flusher so that you can queue these inodes in
> the IO queue?

Yes, I guess so. I'm not doing the experiment this plan yet, so I'm not
sure though.  If we provide the callback something like
->writeback_sb_inodes(), it would work.

And the better design is to remove duplication of dirty inode tracking
on writeback task and own FS though. (However, this is quite optional)

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
