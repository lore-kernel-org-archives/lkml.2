Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab1CGUea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:34:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab1CGUe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:34:28 -0500
Date: Mon, 7 Mar 2011 15:34:20 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Justin TerAvest <teravest@google.com>, Chad Talbott <ctalbott@google.com>,
        Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: RFC: default group_isolation to 1, remove option
Message-ID: <20110307203420.GJ9540@redhat.com>
References: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com>
 <20110301142002.GB25699@redhat.com>
 <4D6F0ED0.80804@kernel.dk>
 <AANLkTin+TycqQxWGyxWOsuT+WOaEA0XhqFkJBMKe7-uY@mail.gmail.com>
 <4D753488.6090808@kernel.dk>
 <20110307202432.GH9540@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307202432.GH9540@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 03:24:32PM -0500, Vivek Goyal wrote:

[..]
> > 
> > Or not get rid of limits completely, but do a lot more relaxed
> > accounting at the queue level still. That will not require any
> > additional tracking of io contexts etc, but still impose some limit on
> > the number of queued IOs.
> 
> A lot more relaxed limit accounting should help a bit but it after a 
> while it might happen that slow movers eat up lots of request descriptors
> and making not much of progress.
> 
> Long back I had implemented this additional notion of q->nr_group_requests
> where we defined per group number of requests allowed submitter will
> be put to sleep. I also extended it to also export per bdi per group
> congestion notion. So a flusher thread can look at the page and cgroup
> of the page and determine if respective cgroup is congested or not. If
> cgroup is congested, flusher thread can move to next inode so that it
> is not put to sleep behind a slow mover.
> 
> Completely limitless queueu will solve the problem completely. But I guess
> then we can get that complain back that flusher thread submitted too much
> of IO to device.

Also wanted to add that currently blk-throttling code implements limitless
queuing of bio. The reason I did not enforce the limit yet because of
same reason that I will run into issues with async WRITES and flusher
thread.

So once we have figured out what't the right thing to do here, I can
implement similar solution for throttling too.

One side affect of limitless bio queueing is an AIO process can queue up lots
of bios in a group and if one tries to kill the process, it waits for all the
IOs to finish and can take up a very long time depending on throttling limits
of the group.

Thanks
Vivek
