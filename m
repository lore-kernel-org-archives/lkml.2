Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab1FIOO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:14:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab1FIOOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:14:55 -0400
Date: Thu, 9 Jun 2011 10:14:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: CFQ: async queue blocks the whole system
Message-ID: <20110609141451.GD29913@redhat.com>
References: <1307616577-6101-1-git-send-email-tm@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307616577-6101-1-git-send-email-tm@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 06:49:37PM +0800, Tao Ma wrote:
> Hi Jens and Vivek,
> 	We are current running some heavy ext4 metadata test,
> and we found a very severe problem for CFQ. Please correct me if
> my statement below is wrong.
> 
> CFQ only has an async queue for every priority of every class and
> these queues have a very low serving priority, so if the system
> has a large number of sync reads, these queues will be delayed a
> lot of time. As a result, the flushers will be blocked, then the
> journal and finally our applications[1].
> 
> I have tried to let jbd/2 to use WRITE_SYNC so that they can checkpoint
> in time and the patches are sent. But today we found another similar
> block in kswapd which make me think that maybe CFQ should be changed
> somehow so that all these callers can benefit from it.
> 
> So is there any way to let the async queue work timely or at least
> is there any deadline for async queue to finish an request in time
> even in case there are many reads?
> 
> btw, We have tested deadline scheduler and it seems to work in our test.
> 
> [1] the message we get from one system:
> INFO: task flush-8:0:2950 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> flush-8:0       D ffff88062bfde738     0  2950      2 0x00000000
>  ffff88062b137820 0000000000000046 ffff88062b137750 ffffffff812b7bc3
>  ffff88032cddc000 ffff88062bfde380 ffff88032d3d8840 0000000c2be37400
>  000000002be37601 0000000000000006 ffff88062b137760 ffffffff811c242e
> Call Trace:
>  [<ffffffff812b7bc3>] ? scsi_request_fn+0x345/0x3df
>  [<ffffffff811c242e>] ? __blk_run_queue+0x1a/0x1c
>  [<ffffffff811c57cc>] ? queue_unplugged+0x77/0x8e
>  [<ffffffff813dbe67>] io_schedule+0x47/0x61
>  [<ffffffff811c512c>] get_request_wait+0xe0/0x152

Ok, so flush slept on trying to get a "request" allocated on request 
queue. That means all the ASYNC request descriptors are already consumed
and we are not making progress with ASYNc requests.

A relatively recent patch allowed sync queues to always preempt async queues
and schedule sync workload instead of async. This had the potential to
starve async queues and looks like that's what we are running into.

commit f8ae6e3eb8251be32c6e913393d9f8d9e0609489
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Fri Jan 14 08:41:02 2011 +0100

    block cfq: make queue preempt work for queues from different workload

Do you have few seconds of blktrace. I just wanted to verify that this
is what we are running into. 

Thanks
Vivek
