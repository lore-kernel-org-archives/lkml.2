Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2EDKFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 06:05:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42706 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab2EDKFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 06:05:43 -0400
Date: Fri, 4 May 2012 11:04:55 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Colin Cross <ccross@android.com>, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCHv3 0/5] coupled cpuidle state support
Message-ID: <20120504100455.GA14578@e102568-lin.cambridge.arm.com>
References: <1335816551-27756-1-git-send-email-ccross@android.com>
 <201204302354.41969.rjw@sisk.pl>
 <CAMbhsRQcDDW5vWbqb1FRtvOmq6UjOjXj9MCfSt2KF9fHrcY59Q@mail.gmail.com>
 <201205032200.01823.rjw@sisk.pl>
MIME-Version: 1.0
In-Reply-To: <201205032200.01823.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 04 May 2012 10:06:31.0847 (UTC) FILETIME=[946FAB70:01CD29DD]
X-MC-Unique: 112050411051212701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 09:00:01PM +0100, Rafael J. Wysocki wrote:
> On Tuesday, May 01, 2012, Colin Cross wrote:
> > On Mon, Apr 30, 2012 at 2:54 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Monday, April 30, 2012, Colin Cross wrote:
> > >> On Mon, Apr 30, 2012 at 2:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

[...]

> Having considered this for a while I think that it may be more straightforward
> to avoid waking up the already idled cores.
> 
> For instance, say we have 4 CPU cores in a cluster (package) such that each
> core has its own idle state (call it C1) and there is a multicore idle state
> entered by turning off the entire cluster (call this state C-multi).  One of
> the possible ways to handle this seems to be to use an identical table of
> C-states for each core containing the C1 entry and a kind of fake entry called
> (for example) C4 with the time characteristics of C-multi and a special
> .enter() callback.  That callback will prepare the core it is called for to
> enter C-multi, but instead of simply turning off the whole package it will
> decrement a counter.  If the counte happens to be 0 at this point, the
> package will be turned off.  Otherwise, the core will be put into the idle
> state corresponding to C1, but it will be ready for entering C-multi at
> any time. The counter will be incremented on exiting the C4 "state".
> 
> It looks like this should work without modifying the cpuidle core, but
> the drawback here is that the cpuidle core doesn't know how much time
> spend in C4 is really in C1 and how much of it is in C-multi, so the
> statistics reported by it won't reflect the real energy usage.

This is exactly what has been done in some ARM platforms with per-CPU power
rails ("C1" means shutdown here) and that are completely symmetric (ie every
CPU can trigger cluster shutdown); a "C4" multi-CPU state with target_residency
equivalent to the cluster shutdown implied power break-even point.

There are two issues with this approach. One you already mentioned it.
Second is that CPUs go idle at different times. Hence, by the time the last
CPU calls C4.enter() other CPUs in the package might already have a timer
that is about to expire. If we start cluster shutdown we are wasting power
(eg caches write-back to DDR) for nothing.

Colin and Santosh mentioned it already, we have to peek at the next event for
all CPUs in the package (or peek the broadcast global timer if CPUs rely
on it) and make a decision accordingly.

Lorenzo

