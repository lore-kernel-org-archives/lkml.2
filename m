Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab0LND3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 22:29:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab0LND3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 22:29:40 -0500
Date: Mon, 13 Dec 2010 22:29:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8 v2] Introduce CFQ group hierarchical scheduling and
 "use_hierarchy" interface
Message-ID: <20101214032927.GB9004@redhat.com>
References: <4CDF7BC5.9080803@cn.fujitsu.com>
 <4CDF9CC6.2040106@cn.fujitsu.com>
 <20101115165319.GI30792@redhat.com>
 <4CE2718C.6010406@kernel.dk>
 <4D057A6A.8060000@cn.fujitsu.com>
 <20101213142957.GA20454@redhat.com>
 <4D06DF32.2050604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D06DF32.2050604@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 11:06:26AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > On Mon, Dec 13, 2010 at 09:44:10AM +0800, Gui Jianfeng wrote:
> >> Hi
> >>
> >> Previously, I posted a patchset to add support of CFQ group hierarchical scheduling
> >> in the way that it puts all CFQ queues in a hidden group and schedules with other 
> >> CFQ group under their parent. The patchset is available here,
> >> http://lkml.org/lkml/2010/8/30/30
> >>
> >> Vivek think this approach isn't so instinct that we should treat CFQ queues
> >> and groups at the same level. Here is the new approach for hierarchical 
> >> scheduling based on Vivek's suggestion. The most big change of CFQ is that
> >> it gets rid of cfq_slice_offset logic, and makes use of vdisktime for CFQ
> >> queue scheduling just like CFQ group does. But I still give cfqq some jump 
> >> in vdisktime based on ioprio, thanks for Vivek to point out this. Now CFQ 
> >> queue and CFQ group uses the same scheduling algorithm. 
> > 
> > Hi Gui,
> > 
> > Thanks for the patches. Few thoughts.
> > 
> > - I think we can implement vdisktime jump logic for both cfq queue and
> >   cfq groups. So any entity (queue/group) which is being backlogged fresh
> >   will get the vdisktime jump but anything which has been using its slice
> >   will get queued at the end of tree.
> 
> Vivek,
> 
> vdisktime jump for both CFQ queue and CFQ group is ok to me.
> what do you mean "anything which has been using its slice will get queued at the 
> end of tree."
> Currently, if a CFQ entity uses up its time slice, we'll update its vdisktime,
> why should we put it at the end of tree.

Sorry, what I actually meant was that any queue/group which has been using
its slice and is being requeued will be queue at a position based on vdisktime
calculation and no boost logic required. For queues/groups which gets queued
new gets a vdisktime boost. That way once we disable slice_idle=0 and
group_idle=0, we might get good bandwidth utilization at the same time
some service differentation for higher weight queues/groups.

> 
> 
> > 
> > - Have you done testing in true hierarchical mode. In the sense that
> >   create atleast two level of hierarchy and see if bandwidth division
> >   is happening properly. Something like as follows.
> > 
> > 			root
> > 		       /    \ 
> > 		    test1  test2
> > 	           /    \   /  \
> > 		  G1    G2  G3  G4
> 
> yes, I tested with two level, and works fine.
> 
> > 
> > - On what kind of storage you have been doing your testing? I have noticed
> >   that IO controllers works well only with idling on and with idling on
> >   performance is bad on high end storage. The simple reason being that
> >   an storage array can support multiple IOs at the same time and if we
> >   are idling on queue or group in an attempt to provide fairness it hurts.
> >   It hurts especially more if we are doing random IO (I am assuming this
> >   is more typical of workloads).
> >  
> >   So we need to come up with a proper logic so that we can provide some
> >   kind of fairness even with idle disabled. I think that's where this
> >   vdisktime jump logic comes into picture and is important to get it
> >   right.
> > 
> >   So can you also do some testing with idle disabled (both queue 
> >   and group) and see if the vdisktime logic is helping with providing
> >   some kind of service differentation. I think results will vary 
> >   based on what is the storage and what queue depth are you driving. You
> >   can even try to do this testing on an SSD.
> 
> I tested on sata. will do more tests when idle disabled.

Ok, actulally SATA with low queue depth is the case where block IO controller
works best. I am also keen to make it work well for SSDs and faster storage
like storage arrays without losing too much of throughput in the process.

Thanks
Vivek
