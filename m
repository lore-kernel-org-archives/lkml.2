Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1FNVOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 17:14:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab1FNVOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 17:14:15 -0400
Date: Tue, 14 Jun 2011 17:14:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: CFQ: async queue blocks the whole system
Message-ID: <20110614211411.GI2525@redhat.com>
References: <20110609182706.GG29913@redhat.com>
 <4DF1B035.7080009@tao.ma>
 <20110610091427.GB4183@redhat.com>
 <4DF1EB45.1070706@tao.ma>
 <20110610154414.GA31853@redhat.com>
 <4DF5E1A8.7080100@tao.ma>
 <20110613214154.GL633@redhat.com>
 <4DF707BC.20007@tao.ma>
 <20110614133047.GA2525@redhat.com>
 <4DF78157.6020907@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF78157.6020907@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 11:42:15PM +0800, Tao Ma wrote:
> On 06/14/2011 09:30 PM, Vivek Goyal wrote:
> > On Tue, Jun 14, 2011 at 03:03:24PM +0800, Tao Ma wrote:
> >> Hi Vivek,
> >> On 06/14/2011 05:41 AM, Vivek Goyal wrote:
> >>> On Mon, Jun 13, 2011 at 06:08:40PM +0800, Tao Ma wrote:
> >>>
> >>> [..]
> >>>>> You can also run iostat on disk and should be able to see that with
> >>>>> the patch you are dispatching writes more often than before.
> >>>> Sorry, the patch doesn't work.
> >>>>
> >>>> I used trace event to capture all the blktraces since it doesn't
> >>>> interfere with the tests, hope it helps.
> >>>
> >>> Actually I was looking for CFQ traces. This seems to be generic block
> >>> layer trace points. May be you can use "blktrace -d /dev/<device>"
> >>> and then blkparse. It also gives the aggregate view which is helpful.
> >>>
> >>>>
> >>>> Please downloaded it from http://blog.coly.li/tmp/blktrace.tar.bz2
> >>>
> >>> What concerns me is following.
> >>>
> >>> 5255.521353: block_rq_issue: 8,0 W 0 () 571137153 + 8 [attr_set]
> >>> 5578.863871: block_rq_issue: 8,0 W 0 () 512950473 + 48 [kworker/0:1]
> >>>
> >>> IIUC, we dispatched second write more than 300 seconds after dispatching
> >>> 1 write. What happened in between. We should have dispatched more writes.
> >>>
> >>> CFQ traces might give better idea in terms of whether wl_type for async
> >>> queues was scheduled or not at all.
> >> I tried several times today, but it looks like that if I enable
> >> blktrace, the hung_task will not show up in the message. So do you think
> >> the blktrace at that time is still useful? If yes, I can capture 1
> >> minute for you. Thanks.
> > 
> > Capturing 1 min output will also be good. 
> OK, I captured 2 mins blkparse log before the hung. You can downloaded
> it from http://blog.coly.li/tmp/blkparse.tar.bz2

Thanks. I looked at this log and looks like now we are not starving
WRITES.

I did grep on the logs.

grep -e "wl_type:0" -e "cfq3068A / sl_used" blkparse.log | async-dispatch

And I see that now async WRITES are being dispatched at regular interval
and we are not seeing long delays (atleast in this log).

A sample output is as follows. What I am expecting from the patch is that
it will avoid the starvation of async queues in presence of lots of
writers. That's a different thing that one might not be able to push
enough WRITES in 120 seconds window and one can still get hung task
timeout message. 

 5.135877740     0  m   N cfq3068A / set_active wl_prio:0 wl_type:0
 5.231137776     0  m   N cfq3068A / sl_used=95 disp=1 charge=95 iops=0 sect=16
13.311745653     0  m   N cfq3068A / set_active wl_prio:0 wl_type:0
13.373046196     0  m   N cfq3068A / sl_used=1 disp=16 charge=1 iops=0 sect=136
18.097413421     0  m   N cfq3068A / set_active wl_prio:0 wl_type:0
18.097466598     0  m   N cfq3068A / sl_used=1 disp=3 charge=1 iops=0 sect=32
18.119371182     0  m   N cfq3068A / set_active wl_prio:0 wl_type:0
18.159420999     0  m   N cfq3068A / sl_used=40 disp=1592 charge=40 iops=0 sect=14360
18.159424767     0  m   N cfq3068A / set_active wl_prio:0 wl_type:0
18.199409182     0  m   N cfq3068A / sl_used=40 disp=1646 charge=40 iops=0 sect=13584
18.199414996     0  m   N cfq3068A / set_active wl_prio:0 wl_type:0
18.239374395     0  m   N cfq3068A / sl_used=40 disp=1678 charge=40 iops=0 sect=13872
18.239378182     0  m   N cfq3068A / set_active wl_prio:0 wl_type:0
18.254531670     0  m   N cfq3068A / sl_used=15 disp=603 charge=15 iops=0 sect=4920
27.580961230     0  m   N cfq3068A / set_active wl_prio:0 wl_type:0
27.653340897     0  m   N cfq3068A / sl_used=72 disp=16 charge=72 iops=0 sect=128

Thanks
Vivek
