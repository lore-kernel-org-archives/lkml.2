Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab2BASH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:07:57 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35255 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab2BASHb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:07:31 -0500
Date: Wed, 1 Feb 2012 18:07:05 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Colin Cross <ccross@android.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [linux-pm] [PATCH 0/3] coupled cpuidle state support
Message-ID: <20120201180705.GA20936@e102568-lin.cambridge.arm.com>
References: <1324426147-16735-1-git-send-email-ccross@android.com>
 <4F1929E9.7070707@linaro.org>
 <CAMbhsRTbVqV6p0py9NGZrpFPf2yvp-B0dr+o-m7qbdja_-Lfzw@mail.gmail.com>
 <CAKfTPtAsO8z_8AnR8zSGZ9cm_7orDNxB3r09JAFk+2jdezUVmQ@mail.gmail.com>
 <CAMbhsRQYVXTZ2pX4mBrM6=SyGTqn_GY8xsW4rt_e21zerEzctA@mail.gmail.com>
 <CAKfTPtB3Kcy41H9g9u3u81kEHJeypi=GvOfOjcpdztzqN991nA@mail.gmail.com>
 <20120201145934.GA20421@e102568-lin.cambridge.arm.com>
 <CAMbhsRTFzc8aGsSGUs2==4FiqBb7zOit4cO=6U698k+RCE+kqQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAMbhsRTFzc8aGsSGUs2==4FiqBb7zOit4cO=6U698k+RCE+kqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 01 Feb 2012 18:07:08.0967 (UTC) FILETIME=[50483B70:01CCE10C]
X-MC-Unique: 112020118071400401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 05:30:15PM +0000, Colin Cross wrote:
> On Wed, Feb 1, 2012 at 6:59 AM, Lorenzo Pieralisi
> <lorenzo.pieralisi@arm.com> wrote:
> > On Wed, Feb 01, 2012 at 12:13:26PM +0000, Vincent Guittot wrote:
> >
> > [...]
> >
> >> >> In your patch, you put in safe state (WFI for most of platform) the
> >> >> cpus that become idle and these cpus are woken up each time a new cpu
> >> >> of the cluster becomes idle. Then, the cluster state is chosen and the
> >> >> cpus enter the selected C-state. On ux500, we are using another
> >> >> behavior for synchronizing  the cpus. The cpus are prepared to enter
> >> >> the c-state that has been chosen by the governor and the last cpu,
> >> >> that enters idle, chooses the final cluster state (according to cpus'
> >> >> C-state). The main advantage of this solution is that you don't need
> >> >> to wake other cpus to enter the C-state of a cluster. This can be
> >> >> quite worth full when tasks mainly run on one cpu. Have you also think
> >> >> about such behavior when developing the coupled cpuidle driver ? It
> >> >> could be interesting to add such behavior.
> >> >
> >> > Waking up the cpus that are in the safe state is not done just to
> >> > choose the target state, it's done to allow the cpus to take
> >> > themselves to the target low power state.  On ux500, are you saying
> >> > you take the cpus directly from the safe state to a lower power state
> >> > without ever going back to the active state?  I once implemented Tegra
> >>
> >> yes it is
> >
> > But if there is a single power rail for the entire cluster, when a CPU
> > is "prepared" for shutdown this means that you have to save the context and
> > clean L1, maybe for nothing since if other CPUs are up and running the
> > CPU going idle can just enter a simple standby wfi (clock-gated but power on).
> >
> > With Colin's approach, context is saved and L1 cleaned only when it is
> > almost certain the cluster is powered off (so the CPUs).
> >
> > It is a trade-off, I am not saying one approach is better than the
> > other; we just have to make sure that preparing the CPU for "possible" shutdown
> > is better than sending IPIs to take CPUs out of wfi and synchronize
> > them (this happens if and only if CPUs enter coupled C-states).
> >
> > As usual this will depend on use cases (and silicon implementations :) )
> >
> > It is definitely worth benchmarking them.
> >
> 
> I'm less worried about performance, and more worried about race
> conditions.  How do you deal with the following situation:
> CPU0 goes to WFI, and saves its state
> CPU1 goes idle, and selects a deep idle state that powers down CPU0
> CPU1 saves is state, and is about to trigger the power down
> CPU0 gets an interrupt, restores its state, and modifies state (maybe
> takes a spinlock during boot)
> CPU1 cuts the power to CPU0
> 
> On OMAP4, the race is handled in hardware.  When CPU1 tries to cut the
> power to the blocks shared by CPU0 the hardware will ignore the
> request if CPU0 is not in WFI.  On Tegra2, there is no hardware
> support and I had to handle it with a spinlock implemented in scratch
> registers because CPU0 is out of coherency when it starts booting and
> ldrex/strex don't work.  I'm not convinced my implementation is
> correct, and I'd be curious to see any other implementations.

That's a problem you solved with coupled C-states (ie your example in
the cover letter), where the primary waits for other CPUs to be reset
before issuing the power down command, right ? At that point in time 
secondaries cannot wake up (?) and if wfi (ie power down) aborts you just
take the secondaries out of reset and restart executing simultaneously,
correct ? It mirrors the suspend behaviour, which is easier to deal with
than completely random idle paths.

It is true that this should be managed by the PM HW; if HW is not
capable of managing these situations things get nasty as you highlighted.

And it is also true ldrex/strex on cacheable memory might not be available in
those early warm-boot stages. I came up with a locking algorithm on
strongly ordered memory to deal with that, but I am still not sure it is
something we really really need.

I will test coupled C-state code ASAP, and come back with feedback.

Thanks,
Lorenzo

