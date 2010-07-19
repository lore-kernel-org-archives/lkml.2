Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966941Ab0GSWFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 18:05:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966846Ab0GSWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 18:05:22 -0400
Date: Mon, 19 Jul 2010 18:05:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Divyesh Shah <dpshah@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        guijianfeng@cn.fujitsu.com
Subject: Re: [PATCH 1/3] cfq-iosched: Improve time slice charging logic
Message-ID: <20100719220505.GA4912@redhat.com>
References: <1279560008-2905-1-git-send-email-vgoyal@redhat.com>
 <1279560008-2905-2-git-send-email-vgoyal@redhat.com>
 <x49mxtntikn.fsf@segfault.boston.devel.redhat.com>
 <20100719185828.GB32503@redhat.com>
 <AANLkTikqd3VzLSkJfGoN0s29NzhkqJSYSPEEOS2s0TOn@mail.gmail.com>
 <20100719204446.GF32503@redhat.com>
 <AANLkTinIj5v7kYdZWFEpNP6RnF45BpT1N4U1smA0W5r2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinIj5v7kYdZWFEpNP6RnF45BpT1N4U1smA0W5r2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 11:19:21PM +0200, Corrado Zoccolo wrote:
> On Mon, Jul 19, 2010 at 10:44 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Mon, Jul 19, 2010 at 01:32:24PM -0700, Divyesh Shah wrote:
> >> On Mon, Jul 19, 2010 at 11:58 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > Yes it is mixed now for default CFQ case. Whereever we don't have the
> >> > capability to determine the slice_used, we charge IOPS.
> >> >
> >> > For slice_idle=0 case, we should charge IOPS almost all the time. Though
> >> > if there is a workload where single cfqq can keep the request queue
> >> > saturated, then current code will charge in terms of time.
> >> >
> >> > I agree that this is little confusing. May be in case of slice_idle=0
> >> > we can always charge in terms of IOPS.
> >>
> >> I agree with Jeff that this is very confusing. Also there are
> >> absolutely no bets that one job may end up getting charged in IOPs for
> >> this behavior while other jobs continue getting charged in timefor
> >> their IOs. Depending on the speed of the disk, this could be a huge
> >> advantage or disadvantage for the cgroup being charged in IOPs.
> >>
> >> It should be black or white, time or IOPs and also very clearly called
> >> out not just in code comments but in the Documentation too.
> >
> > Ok, how about always charging in IOPS when slice_idle=0?
> >
> > So on fast devices, admin/user space tool, can set slice_idle=0, and CFQ
> > starts doing accounting in IOPS instead of time. On slow devices we
> > continue to run with slice_idle=8 and nothing changes.
> >
> > Personally I feel that it is hard to sustain time based logic on high end
> > devices and still get good throughput. We could make CFQ a dual mode kind
> > of scheduler which is capable of doing accouting both in terms of time as
> > well as IOPS. When slice_idle !=0, we do accounting in terms of time and
> > it will be same CFQ as of today. When slice_idle=0, CFQ starts accounting
> > in terms of IOPS.
> There is an other mode in which cfq can operate: for ncq ssds, it
> basically ignores slice_idle, and operates as if it was 0.
> This mode should also be handled as an IOPS counting mode.
> SSD mode, though, differs from rotational mode for the definition of
> "seekyness", and we should think if this mode is appropriate also for
> the other hardware where slice_idle=0 is beneficial.

I am always wondering that in practice, what is the difference between
slice_idle=0 and rotational=0. I think the only difference is NCQ queue
detection. slice_idle=0 will always not idle, irrespective of the fact
whether queue is NCQ or not and rotational=0 will disable idling only
if device supports NCQ.

If that's the case, then we can probably internally switch the
slice_idle=0 once we have detected that an SSD supports NCQ and we can
get rid of this confusion.

Well looking more closely, there seems to be one more difference. With
SSD, and NCQ, we still idle on sync-noidle tree. This seemingly, will
provide us protection from WRITES. Not sure if this is true for good
SSDs also. I am assuming they should be giving priority to reads and
balancing things out. cfq_should_idle() is interesting though, that
we disable idling for sync-idle tree. So we idle on sync-noidle tree
but do not provide any protection to sequential readers. Anyway, that's
a minor detail....

In fact we can switch to IOPS model for NCQ SSD also.

> >
> > I think this change should bring us one step closer to our goal of one
> > IO sheduler for all devices.
> 
> I think this is an interesting instance of a more general problem: cfq
> needs a cost function applicable to all requests on any hardware. The
> current function is a concrete one (measured time), but unfortunately
> it is not always applicable, because:
> - for fast hardware the resolution is too coarse (this can be fixed
> using higher resolution timers)

Yes this is fixable.

> - for hardware that allows parallel dispatching, we can't measure the
> cost of a single request (can we try something like average cost of
> the requests executed in parallel?).

This is the biggest problem. How to get right estimate of time when
a request queue can have requests from multiple processes at the same
time.

> IOPS, instead, is a synthetic cost measure. It is a simplified model,
> that will approximate some devices (SSDs) better than others
> (multi-spindle rotational disks).

Agreed that IOPS is a simplified model.

> But if we want to go for the
> synthetic path, we can have more complex measures, that also take into
> account other parameters, as sequentiality of the requests,

Once we start dispatching requests from multiple cfq queues at a time,
notion of sequentiality is lost (at least on the device).

> their size
> and so on, all parameters that may have still some impact on high-end
> devices.

size is an interesting factor though. Again we can only come up with
some kind of approximation only as this cost will vary from device to
device

I think we can begin with something simple (IOPS) and if it works fine,
then we can take into account additional factors (especially size of
request) and factor that into the cost.

The only thing to keep in mind is that group scheduling will benefit
most from it. The notion of ioprio is fairly weak currently in CFQ
(especially on SSD and with slice_idle=0).

Thanks
Vivek

> 
> Thanks,
> Corrado
> >
> > Jens, what do you think?
> >
> > Thanks
> > Vivek
