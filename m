Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab2ARBUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:20:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:58690 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab2ARBUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:20:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="99782757"
Subject: Re: [RFC 0/3]block: An IOPS based ioscheduler
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, jmoyer@redhat.com, zhu.yanhai@gmail.com
In-Reply-To: <20120117090220.GB15511@redhat.com>
References: <1325746241.22361.503.camel@sli10-conroe>
	 <1325826750.22361.533.camel@sli10-conroe> <20120108221615.GA4198@dastard>
	 <1326071375.22361.543.camel@sli10-conroe>
	 <20120115224532.GD3174@redhat.com>
	 <1326688590.22361.578.camel@sli10-conroe>
	 <20120116071132.GE3174@redhat.com>
	 <1326700541.22361.607.camel@sli10-conroe>
	 <20120116082927.GF3174@redhat.com>
	 <1326762388.22361.613.camel@sli10-conroe>
	 <20120117090220.GB15511@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Jan 2012 09:20:37 +0800
Message-ID: <1326849637.22361.616.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 04:02 -0500, Vivek Goyal wrote:
> On Tue, Jan 17, 2012 at 09:06:28AM +0800, Shaohua Li wrote:
> > On Mon, 2012-01-16 at 03:29 -0500, Vivek Goyal wrote:
> > > On Mon, Jan 16, 2012 at 03:55:41PM +0800, Shaohua Li wrote:
> > > > On Mon, 2012-01-16 at 02:11 -0500, Vivek Goyal wrote:
> > > > > On Mon, Jan 16, 2012 at 12:36:30PM +0800, Shaohua Li wrote:
> > > > > > On Sun, 2012-01-15 at 17:45 -0500, Vivek Goyal wrote:
> > > > > > > On Mon, Jan 09, 2012 at 09:09:35AM +0800, Shaohua Li wrote:
> > > > > > > 
> > > > > > > [..]
> > > > > > > > > You need to present raw numbers and give us some idea of how close
> > > > > > > > > those numbers are to raw hardware capability for us to have any idea
> > > > > > > > > what improvements these numbers actually demonstrate.
> > > > > > > > Yes, your guess is right. The hardware has limitation. 12 SSD exceeds
> > > > > > > > the jbod capability, for both throughput and IOPS, that's why only
> > > > > > > > read/write mixed workload impacts. I'll use less SSD in later tests,
> > > > > > > > which will demonstrate the performance better. I'll report both raw
> > > > > > > > numbers and fiops/cfq numbers later.
> > > > > > > 
> > > > > > > If fiops number are better please explain why those numbers are better.
> > > > > > > If you cut down on idling, it is obivious that you will get higher
> > > > > > > throughput on these flash devices. CFQ does disable queue idling for
> > > > > > > non rotational NCQ devices. If higher throughput is due to driving
> > > > > > > deeper queue depths, then CFQ can do that too just by changing quantum
> > > > > > > and disabling idling. 
> > > > > > it's because of quantum. Surely you can change the quantum, and CFQ
> > > > > > performance will increase, but you will find CFQ is very unfair then.
> > > > > 
> > > > > Why increasing quantum leads to CFQ being unfair? In terms of time it
> > > > > still tries to be fair. 
> > > > we can dispatch a lot of requests to NCQ SSD with very small time
> > > > interval. The disk can finish a lot of requests in small time interval
> > > > too. The time is much smaller than 1 jiffy. Increasing quantum can lead
> > > > a task dispatches request more faster and makes the accounting worse,
> > > > because with small quantum the task needs wait to dispatch. you can
> > > > easily verify this with a simple fio test.
> > > > 
> > > > > That's a different thing that with NCQ, right
> > > > > time measurement is not possible with requests from multiple queues
> > > > > being in the driver/disk at the same time. So accouting in terms of
> > > > > iops per queue might make sense.
> > > > yes.
> > > > 
> > > > > > > So I really don't understand that what are you doing fundamentally
> > > > > > > different in FIOPS ioscheduler. 
> > > > > > > 
> > > > > > > The only thing I can think of more accurate accounting per queue in
> > > > > > > terms of number of IOs instead of time. Which can just serve to improve
> > > > > > > fairness a bit for certain workloads. In practice, I think it might
> > > > > > > not matter much.
> > > > > > If quantum is big, CFQ will have better performance, but it actually
> > > > > > fallbacks to Noop, no any fairness. fairness is important and is why we
> > > > > > introduce CFQ.
> > > > > 
> > > > > It is not exactly noop. It still preempts writes and prioritizes reads
> > > > > and direct writes. 
> > > > sure, I mean fairness mostly here.
> > > > 
> > > > > Also, what's the real life workload where you face issues with using
> > > > > say deadline with these flash based storage.
> > > > deadline doesn't provide fairness. mainly cgroup workload. workload with
> > > > different ioprio has issues too, but I don't know which real workload
> > > > uses ioprio.
> > > 
> > > Personally I have not run into any workload which provides deep queue depths
> > > constantly for a very long time. I had to run fio to create such
> > > scnearios.
> > > 
> > > Not running deep queue depths will lead to expiration of queue (Otherwise
> > > idling will kill performance on these fast devices). And without idling
> > > most of the logic of slice and accounting does not help. A queue
> > > dispatches some requests and expires (irrespective of what time slice
> > > you had allocated it based on ioprio).
> > That's true, if workload doesn't drive deep queue depths, any accounting
> > can't help for NCQ disks as far as I tried. Idling is the only method to
> > make accounting correct, but it impacts performance too much.
> 
> Idiling will kill performance and faster the device, more prominent are
> the effects of idling. So to me using CFQ on these fast devices is not
> a very good idea and deadline might just serve well.
> 
> > 
> > > That's why I am insisting that it would be nice that any move in this
> > > direction should be driven by some real workload instead of just coming
> > > up with synthetic workloads.
> > I thought yanhai from taobao (cc-ed) has real workload and he found cfq
> > performance suffers a lot.
> 
> Can we run that real workload with "deadline" and see what kind of
> concerns do we have. Is anybody getting starved for long time. If not,
> then we don't have to do anything.
> 
> I think trying to make to make CFQ work (Or trying to come up with CFQ
> like IOPS scheduler) on these fast devices might not lead us anywhere.
If only performance matters, I'd rather use noop for ssd. There is
requirement to have cgroup support (maybe ioprio) to give different
tasks different bandwidth.

