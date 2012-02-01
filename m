Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab2BAPA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 10:00:59 -0500
Received: from service87.mimecast.com ([91.220.42.44]:33882 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab2BAPA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 10:00:57 -0500
Date: Wed, 1 Feb 2012 14:59:35 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Colin Cross <ccross@android.com>,
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
Message-ID: <20120201145934.GA20421@e102568-lin.cambridge.arm.com>
References: <1324426147-16735-1-git-send-email-ccross@android.com>
 <4F1929E9.7070707@linaro.org>
 <CAMbhsRTbVqV6p0py9NGZrpFPf2yvp-B0dr+o-m7qbdja_-Lfzw@mail.gmail.com>
 <CAKfTPtAsO8z_8AnR8zSGZ9cm_7orDNxB3r09JAFk+2jdezUVmQ@mail.gmail.com>
 <CAMbhsRQYVXTZ2pX4mBrM6=SyGTqn_GY8xsW4rt_e21zerEzctA@mail.gmail.com>
 <CAKfTPtB3Kcy41H9g9u3u81kEHJeypi=GvOfOjcpdztzqN991nA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAKfTPtB3Kcy41H9g9u3u81kEHJeypi=GvOfOjcpdztzqN991nA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 01 Feb 2012 14:59:38.0924 (UTC) FILETIME=[1EBBE6C0:01CCE0F2]
X-MC-Unique: 112020115000104301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 12:13:26PM +0000, Vincent Guittot wrote:

[...]

> >> In your patch, you put in safe state (WFI for most of platform) the
> >> cpus that become idle and these cpus are woken up each time a new cpu
> >> of the cluster becomes idle. Then, the cluster state is chosen and the
> >> cpus enter the selected C-state. On ux500, we are using another
> >> behavior for synchronizing  the cpus. The cpus are prepared to enter
> >> the c-state that has been chosen by the governor and the last cpu,
> >> that enters idle, chooses the final cluster state (according to cpus'
> >> C-state). The main advantage of this solution is that you don't need
> >> to wake other cpus to enter the C-state of a cluster. This can be
> >> quite worth full when tasks mainly run on one cpu. Have you also think
> >> about such behavior when developing the coupled cpuidle driver ? It
> >> could be interesting to add such behavior.
> >
> > Waking up the cpus that are in the safe state is not done just to
> > choose the target state, it's done to allow the cpus to take
> > themselves to the target low power state.  On ux500, are you saying
> > you take the cpus directly from the safe state to a lower power state
> > without ever going back to the active state?  I once implemented Tegra
> 
> yes it is

But if there is a single power rail for the entire cluster, when a CPU
is "prepared" for shutdown this means that you have to save the context and
clean L1, maybe for nothing since if other CPUs are up and running the
CPU going idle can just enter a simple standby wfi (clock-gated but power on).

With Colin's approach, context is saved and L1 cleaned only when it is
almost certain the cluster is powered off (so the CPUs).

It is a trade-off, I am not saying one approach is better than the
other; we just have to make sure that preparing the CPU for "possible" shutdown 
is better than sending IPIs to take CPUs out of wfi and synchronize
them (this happens if and only if CPUs enter coupled C-states).

As usual this will depend on use cases (and silicon implementations :) )

It is definitely worth benchmarking them.

Lorenzo

