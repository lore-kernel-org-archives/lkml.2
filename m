Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab2ASBU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:20:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:36592 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756397Ab2ASBUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:20:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="98072266"
Subject: Re: [RFC 0/3]block: An IOPS based ioscheduler
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, jmoyer@redhat.com, zhu.yanhai@gmail.com
In-Reply-To: <20120118130425.GA30204@redhat.com>
References: <20120108221615.GA4198@dastard>
	 <1326071375.22361.543.camel@sli10-conroe>
	 <20120115224532.GD3174@redhat.com>
	 <1326688590.22361.578.camel@sli10-conroe>
	 <20120116071132.GE3174@redhat.com>
	 <1326700541.22361.607.camel@sli10-conroe>
	 <20120116082927.GF3174@redhat.com>
	 <1326762388.22361.613.camel@sli10-conroe>
	 <20120117090220.GB15511@redhat.com>
	 <1326849637.22361.616.camel@sli10-conroe>
	 <20120118130425.GA30204@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jan 2012 09:21:06 +0800
Message-ID: <1326936066.22361.646.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 08:04 -0500, Vivek Goyal wrote:
> On Wed, Jan 18, 2012 at 09:20:37AM +0800, Shaohua Li wrote:
> 
> [..]
> > > I think trying to make to make CFQ work (Or trying to come up with CFQ
> > > like IOPS scheduler) on these fast devices might not lead us anywhere.
> > If only performance matters, I'd rather use noop for ssd. There is
> > requirement to have cgroup support (maybe ioprio) to give different
> > tasks different bandwidth.
> 
> Sure but the issue is that we need to idle in an effort to prioritize
> a task and idling kills performance. So you can implement something but
> I have doubts that on a fast hardware it is going to be very useful.
I didn't do idle in fiops. If workload iodepth is low, this will cause
fairness problem and I just leave it be. There is no way to make low
iodepth workload fair without performance sacrifice. CFQ for SSD has the
same problem too.

> Another issue is that with flash based storage, it can drive really deep
> queue depths. If that's the case, then just ioscheduler can't solve the
> prioritazaion issues (until and unless ioscheduler does not drive deep
> queue depths and kills performance). We need some kind of cooperation
> from device (like device understanding the notion of iopriority), so
> that device can prioritize the requests and one need not to idle. That
> way, we might be able to get service differentiation while getting
> reasonable throughput.
SSD is still like normal disk in terms of queue depth. Don't know the
iodepth of pcie flash card. If the queue depth of such card is very big
(I suppose there is a limitation, because after a critical point
increasing queue depth doesn't increase device performance), we
definitely need reconsider this.

it would be great device let ioscheduler know more info. In my mind, I
hope device can dynamatically adjust its queue depth. For example, in my
ssd, if request size is 4k, I get max throughput with queue depth 32. If
request size is 128k, just 2 queue depth is enough to get peek
throughput. If device can stop fetching request after 2 128k requests
pending, this will solve some fairness issues for low iodepth workload.
Unfortunately device capacity for different request size highly depends
on vendor. The fiops request size scale tries to solve the issue, but I
still didn't find a good scale model for this yet.

I suppose device can not do good prioritization if workload iodepth is
low. If there are just few requests pending, nobody (device or
ioscheduler) can do correct judgment in such case because there isn't
enough info.

Thanks,
Shaohua

