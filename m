Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965825Ab0GPPSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 11:18:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965799Ab0GPPSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 11:18:04 -0400
Date: Fri, 16 Jul 2010 11:17:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, Jens Axboe <axboe@kernel.dk>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] CFQ: Make prio_trees per cfq group basis to
 improve IO performance
Message-ID: <20100716151756.GH15382@redhat.com>
References: <4C40247C.2010405@cn.fujitsu.com>
 <20100716140034.GC15382@redhat.com>
 <x49y6dbv75x.fsf@segfault.boston.devel.redhat.com>
 <20100716145600.GF15382@redhat.com>
 <x49tynzv52b.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49tynzv52b.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 11:07:08AM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Fri, Jul 16, 2010 at 10:21:46AM -0400, Jeff Moyer wrote:
> >> Vivek Goyal <vgoyal@redhat.com> writes:
> >> 
> >> > On Fri, Jul 16, 2010 at 05:21:00PM +0800, Gui Jianfeng wrote:
> >> >> Currently, prio_trees is global, and we rely on cfqq_close() to search
> >> >> a coorperator. If the returned cfqq and the active cfqq don't belong to
> >> >> the same group, coorperator searching fails. Actually, that's not the case.
> >> >> Even if cfqq_close() returns a cfqq which belong to another cfq group, 
> >> >> it's still likely that a coorperator(same cfqg) resides in prio_trees.
> >> >> This patch introduces per cfq group prio_trees that should solve the above
> >> >> issue.
> >> >> 
> >> >
> >> > Hi Gui,
> >> >
> >> > I am not sure I understand the issue here.  So are you saying that once
> >> > we find a cfqq which is close but belongs to a different group we reject
> >> > it. But there could be another cfqq in the same group which is not as
> >> > close but still close enough.
> >> >
> >> > For example, assume there are two queues q1 and q2 and in group and third
> >> > queue q3 in group B. Assume q1 is active queue and we are searching for
> >> > cooperator. If cooperator code finds q3 as closest then we will not pick
> >> > this queue as it belongs to a different group. But it could happen that
> >> > q2 is also close enough and we never considered that possibility.
> >> >
> >> > If yes, then its a good theoritical concern but I am worried practically
> >> > how often does it happen. Do you have any workload which suffers because
> >> > of this?
> >> 
> >> That was my reading.  It also means that, in the case that we have
> >> cgroups in use, each rb tree will be smaller.
> >> 
> >> > I am not too inclined to push more complexity in CFQ until and unless we
> >> > have a good use case.
> >> 
> >> I don't think this adds complexity, does it?  It simply moves the
> >> priority trees up a level, which is arguably where they belong.
> >
> > What happens when cfqq moves to a different group. group_isolation=0. Then
> > we also need to add code to change prio tree of the cfqq. Curretnly prio
> > tree are global so we don't have to worry about it. I don't think this
> > patch takes are of that issue.
> 
> Yeah, that had occurred to me.
> 
> > That's a different thing that I am beginning to not like group_isoation=0
> > because this additional variable that cfqq's can move dynamically across
> > groups is making life hard while adding more code in CFQ. So if nobody
> > is using it I was thinking of getting rid of group_isolation tunable.
> >
> > It does bring the issue of severe performance penalty for sync-noidle
> > workloads across groups. I think that should be solved by a different
> > tunable like don't worry about fairness if group is not driving a minimum
> > queue depth and this should be adjustable by tunable so that system admin
> > can decide the right balance between fairness/isolation and throughput.
> 
> I'm not sure what you concluded here.  ;-)
> 
> The way I see it, Gui's patch makes sense.  It sounds like you agree,
> but you didn't like it because you have to write extra code to deal with
> the case of group_isolation=0.  I simply don't agree with that line of
> reasoning.
> 
> Now, there is the question of whether Gui's patch introduces any *real*
> benefit.  I'd honestly be surprised if it did.  Gui, can you give us
> some benchmark results that show the benefit?  If there is no benefit,
> then I'm happy to leave the code the way it is.

If there are no significant benefits of this patch, let us not do it at
least for the time being. I don't prefer to coplicate moving queues around
logic across groups without significant benefits.

Thanks
Vivek
