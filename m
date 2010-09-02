Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab0IBPSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:18:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab0IBPSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:18:49 -0400
Date: Thu, 2 Sep 2010 11:18:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Nauman Rafique <nauman@google.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Divyesh Shah <dpshah@google.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, arighi@develer.com,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC PATCH] Bio Throttling support for block IO controller
Message-ID: <20100902151824.GA2702@redhat.com>
References: <20100901175830.GC22149@redhat.com>
 <20100901200756.GE22149@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901200756.GE22149@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 04:07:56PM -0400, Vivek Goyal wrote:
> On Wed, Sep 01, 2010 at 01:58:30PM -0400, Vivek Goyal wrote:
> > Hi,
> > 
> > Currently CFQ provides the weight based proportional division of bandwidth.
> > People also have been looking at extending block IO controller to provide
> > throttling/max bandwidth control.
> > 
> > I have started to write the support for throttling in block layer on 
> > request queue so that it can be used both for higher level logical
> > devices as well as leaf nodes. This patch is still work in progress but
> > I wanted to post it for early feedback.
> > 
> > Basically currently I have hooked into __make_request() function to 
> > check which cgroup bio belongs to and if it is exceeding the specified
> > BW rate. If no, thread can continue to dispatch bio as it is otherwise
> > bio is queued internally and dispatched later with the help of a worker
> > thread.
> > 
> > HOWTO
> > =====
> > - Mount blkio controller
> > 	mount -t cgroup -o blkio none /cgroup/blkio
> > 
> > - Specify a bandwidth rate on particular device for root group. The format
> >   for policy is "<major>:<minor>  <byes_per_second>".
> > 
> > 	echo "8:16  1048576" > /cgroup/blkio/blkio.read_bps_device
> > 
> >   Above will put a limit of 1MB/second on reads happening for root group
> >   on device having major/minor number 8:16.
> > 
> > - Run dd to read a file and see if rate is throttled to 1MB/s or not.
> > 
> > 	# dd if=/mnt/common/zerofile of=/dev/null bs=4K count=1024 iflag=direct
> > 	1024+0 records in
> > 	1024+0 records out
> > 	4194304 bytes (4.2 MB) copied, 4.0001 s, 1.0 MB/s
> >  
> >  Limits for writes can be put using blkio.write_bps_device file.
> > 
> > Open Issues
> > ===========
> > - Do we need to provide additional queue congestion semantics as we are
> >   throttling and queuing bios at request queue and probably we don't want
> >   a user space application to consume all the memory allocating bios
> >   and bombarding request queue with those bios.
> > 
> > - How to handle the current blkio cgroup stats file and two policies
> >   in the background. If for some reason both throttling and proportional
> >   BW policies are operating on request queue, then stats will be very
> >   confusing.
> > 
> >   May be we can allow activating either throttling or proportional BW
> >   policy per request queue and we can create a /sys tunable to list and
> >   chose between policies (something like choosing IO scheduler). The
> >   only downside of this apporach is that user also need to be aware of
> >   the storage hierachy and activate right policy at each node/request
> >   queue.
> 
> Thinking more about it. The issue of stats from proportional bandwidth
> controller and max bandwidth controller clobbering each other can 
> probably be solved by also specifying policy name with the stat. For 
> example, currently blkio.io_serviced, looks as follows.
> 
> # cat blkio.io_serviced
> 253:2 Read 61
> 253:2 Write 0
> 253:2 Sync 61
> 253:2 Async 0
> 253:2 Total 61
> 
> We can introduce one more field to specify policy for which this stats are as 
> follows.
> 
> # cat blkio.io_serviced
> 253:2 Read 61	throttle
> 253:2 Write 0	throttle
> 253:2 Sync 61	throttle
> 253:2 Async 0	throttle
> 253:2 Total 61	throttle
> 
> 253:2 Read 61	proportional	
> 253:2 Write 0	proportional
> 253:2 Sync 61   proportional
> 253:2 Async 0   proportional
> 253:2 Total 61  proportional
> 

Option 1
========
I was looking at the blkio stat code more. It seems to be key value pair
thing. So looks like I shall have to change the format of the file and
use second field for policy name and that will break any existing tools
parsing these blkio cgroup files.

# cat blkio.io_serviced
253:2 throttle Read 61
253:2 throttle Write 0
253:2 throttle Sync 61
253:2 throttle Async 0
253:2 throttle Total 61

253:2 proportional Read 61
253:2 proportional Write 0
253:2 proportional Sync 61
253:2 proportional Async 0
253:2 proportional Total 61

Option 2
========
Introduce policy column only for new policy. 

253:2 Read 61
253:2 Write 0
253:2 Sync 61
253:2 Async 0
253:2 Total 61

253:2 throttle Read 61
253:2 throttle Write 0
253:2 throttle Sync 61
253:2 throttle Async 0
253:2 throttle Total 61

Here old lines continue to represent proportional weight policy stats and
new lines with "throttle" key word represent throttling stats.

This is just like adding new fields to "stat" file. I guess it might still
might break some script which might get stumped by new lines. But if scripts
are not parsing all the lines and just selectively picking data then these
should be fine.

Option 3
========
The other option is that I introduce new cgroup files for the new
policy. Something like what memory cgroup has done for swap accounting
files.

blkio.throttle.io_serviced
blkio.throttle.io_service_bytes

That will make sure ABI is not broken but number of files per cgroup
increase and there are already significant number of files in the group.

Actually I think I should atleast rename the read and write bw files so that
they explicitly tell these belong to throtlling poilcy.

blkio.throttle.read_bps_device
blkio.throttle.write_bps_device

Any thoughts on what is the best way forward.

Vivek

> It will allow us following.
> 
> - Avoid two control policies overwritting each other's stats.
> - Allow both policies (throttle, proportional) to be operational on
>   same request queue at the same time instead of forcing user to choose
>   one.
> - We don't have to introduce another /sys variable per request queue and
>   that will make life easier in terms of configuration.
> 
> Thoughts?
> 
> Vivek
