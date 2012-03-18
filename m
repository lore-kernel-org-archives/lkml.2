Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab2CRQvE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 12:51:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52931 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab2CRQvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 12:51:00 -0400
Date: Sun, 18 Mar 2012 09:50:56 -0700
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: myungjoo.ham@gmail.com, markgross@thegnar.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <mavej@redhat.com>,
        linux-pm@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] PM / QoS: Introduce new classes: DMA-Throughput and
 DVFS-Latency
Message-ID: <20120318165056.GB12163@envy17>
Reply-To: markgross@thegnar.org
References: <13197479.540821330911965933.JavaMail.weblogic@epv6ml06>
 <20120308034722.GA10286@envy17>
 <CAJ0PZbTfw1U8raiwiNX14x+jnaWa7ptAgpaaTJgCCZKZU24TDg@mail.gmail.com>
 <201203102353.24218.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203102353.24218.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 11:53:23PM +0100, Rafael J. Wysocki wrote:
> On Friday, March 09, 2012, MyungJoo Ham wrote:
> > On Thu, Mar 8, 2012 at 12:47 PM, mark gross <markgross@thegnar.org> wrote:
> > > On Wed, Mar 07, 2012 at 02:02:01PM +0900, MyungJoo Ham wrote:
> > >> 1. CPU_DMA_THROUGHPUT
> > ...
> > >> 2. DVFS_LATENCY
> > >
> > > The cpu_dma_throughput looks ok to me.  I do however; wonder about the
> > > dvfs_lat_pm_qos.  Should that knob be exposed to user mode?  Does that
> > > matter so much?  why can't dvfs_lat use the cpu_dma_lat?
> > >
> > > BTW I'll be out of town for the next 10 days and probably will not get
> > > to this email account until I get home.
> > >
> > > --mark
> > >
> > 
> > 1. Should DVFS Latency be exposed to user mode?
> > 
> > It would depend on the policy of the given system; however, yes, there
> > are systems that require a user interface for DVFS Latency.
> > With the example of user input response (response to user click,
> > typing, touching, and etc), a user program (probably platform s/w or
> > middleware) may input QoS requests. Besides, when a new "application"
> > is starting, such "middleware" may want faster responses from DVFS
> > mechanisms.
> 
> But this is a global knob, isn't it?  And it seems that a per-device one
> is needed rather than that?
> 
> It also applies to your CPU_DMA_THROUGHPUT thing, doesn't it?
> 
> > 2. Does DVFS Latency matter?
> > 
> > Yes, in our experimental sets w/ Exynos4210 (those slapped in Galaxy
> > S2 equivalent; not exactly as I'm not conducted in Android systems,
> > but Tizen), we could see noticable difference w/ bare eyes for
> > user-input responses. When we shortened DVFS polling interval with
> > touches, the touch responses were greatly improved; e.g., losing 10
> > frames into losing 0 or 1 frame for a sudden input rush.
> 
> Well, this basically means PM QoS matters, which is kind of obvious.
> It doesn't mean that it can't be implemented in a better way, though.
> 
> > 3. Why not replace DVFS Latency w/ CPU-DMA-Latency/Throughput?
> > 
> > When we implement the user-input response enhancement with CPU-DMA QoS
> > requests, the PM-QoS will unconditionally increase CPU and BUS
> > frequencies/voltages with user inputs. However, with many cases it is
> > unnecessary; i.e., a user input means that there will be unexpected
> > changes soon; however, the change does not mean that the load will
> > increase. Thus, allowing DVFS mechanism to evolve faster was enough to
> > shorten the response time and not to increase frequencies and voltages
> > when not needed. There were significant difference in power
> > consumption with this changes if the user inputs were not involving
> > drastic graphics jobs; e.g., typing a text message.
> 
> Again, you're arguing for having PM QoS rather than not having it.  You don't
> have to do that. :-)
> 
> Generally speaking, I don't think we should add any more PM QoS "classes"
> as defined in pm_qos.h, since they are global and there's only one
> list of requests per class.  While that may be good for CPU power
> management (in an SMP system all CPUs are identical, so the same list of
> requests may be applied to all of them), it generally isn't for I/O
> devices (some of them work in different time scales, for example).
> 
> So, for example, most likely, a list of PM QoS requests for storage devices
> shouldn't be applied to input devices (keyboards and mice to be precise) and
> vice versa.
> 
> On the other hand, I don't think that applications should access PM QoS
> interfaces associated with individual devices directly, because they may
> not have enough information about the relationships between devices in the
> system.  So, perhaps, there needs to be an interface allowing applications
> to specify their PM QoS expectations in a general way (e.g. "I want <number>
> disk I/O throughput") and a code layer between that interface and device
> drivers translating those expecataions into PM QoS requests for specific
> devices.  However, that would require support from subsystems throughout
> the kernel (e.g. if an application wants specific disk I/O throughput,
> we need to figure out what disks are used by that application and apply
> appropriate PM QoS requests to them on behalf of it and that may require
> support from the VFS and the block layer).

FWIW The thought experiment I try to do (but sometimes forget to do) is
to consider how a qos constraint can be expressed in a platform
independent way.  i.e. can I write an application or middle ware in such
a way that it can express the exact same qos-request on a ARM based
system and an x86 based system (or even a different ARM system with say,
many cores or different performance characteristics) and have it work right.

If the answer is no, you need to tune the application for the platform
its running on then, we need to step back and thing things through
before exposing them though to user mode.  Candidate implementations
need to scale across architectures and board implementations.

> I don't really think we have sufficiently understood the problem area yet.

I agree.  However; I do know that this is an area we need to work on.
FWIW the x86 SOC's are also starting to have use of such things as well.

--mark

> 
