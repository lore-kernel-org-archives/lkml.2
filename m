Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab2ECUTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 16:19:00 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40187 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758553Ab2ECUS7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 16:18:59 -0400
MIME-Version: 1.0
In-Reply-To: <201205032200.01823.rjw@sisk.pl>
References: <1335816551-27756-1-git-send-email-ccross@android.com>
	<201204302354.41969.rjw@sisk.pl>
	<CAMbhsRQcDDW5vWbqb1FRtvOmq6UjOjXj9MCfSt2KF9fHrcY59Q@mail.gmail.com>
	<201205032200.01823.rjw@sisk.pl>
Date: Thu, 3 May 2012 13:18:58 -0700
X-Google-Sender-Auth: WepOSWYUbYBtPNGa10fcYn1ZYUo
Message-ID: <CAMbhsRS8D=d9aAbikosOis+Q+jMU04Oj9xaRg0jMVxtQ7nijTw@mail.gmail.com>
Subject: Re: [PATCHv3 0/5] coupled cpuidle state support
From: Colin Cross <ccross@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 1:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
<snip>
> There are two distinct cases to consider here, (1) when the last I/O
> device in the domain becomes idle and the question is whether or not to
> power off the entire domain and (2) when a CPU core in a power domain
> becomes idle while all of the devices in the domain are idle already.
>
> Case (2) is quite straightforward, the .enter() routine for the
> "domain" C-state has to check whether the domain can be turned off and
> do it eventually.
>
> Case (1) is more difficult and (assuming that all CPU cores in the domain
> are already idle at this point) i see two possible ways to handle it:
> (a) Wake up all of the (idle) CPU cores in the domain and let the
>  "domain" C-state's .enter() do the job (ie. turn it into case (2)),
>  similarly to your patchset.
> (b) If cpuidle has prepared the cores for going into deeper idle,
>  turn the domain off directly without waking up the cores.

Multiple clusters is a design that has been considered in this
patchset (all the data structures are in the right place to support
it), and can be supported in the future, but does not exist in any
current systems that would be using this.  In all of today's SoCs,
there is a single cluster, so (1) can't happen - no code can be
executing while all cpus are idle.

(b) is an optimization that would not be possible on any future SoC
that is similar to the current SoCs, where "turn the domain off" is
very tightly integrated with TrustZone secure code running on the
primary cpu of the cluster.

<snip>

> Having considered this for a while I think that it may be more straightforward
> to avoid waking up the already idled cores.
>
> For instance, say we have 4 CPU cores in a cluster (package) such that each
> core has its own idle state (call it C1) and there is a multicore idle state
> entered by turning off the entire cluster (call this state C-multi).  One of
> the possible ways to handle this seems to be to use an identical table of
> C-states for each core containing the C1 entry and a kind of fake entry called
> (for example) C4 with the time characteristics of C-multi and a special
> .enter() callback.  That callback will prepare the core it is called for to
> enter C-multi, but instead of simply turning off the whole package it will
> decrement a counter.  If the counte happens to be 0 at this point, the
> package will be turned off.  Otherwise, the core will be put into the idle
> state corresponding to C1, but it will be ready for entering C-multi at
> any time. The counter will be incremented on exiting the C4 "state".

I implemented something very similar to this on Tegra2 (having each
cpu go to C1, but with enough state saved for C-multi), but it turns
out not to work in hardware.  On every existing ARM SMP system where I
have worked with cpuidle (Tegra2, OMAP4, Exynos5, and some Tegra3),
only cpu 0 can trigger the transition to C-multi.  The cause of this
restriction is different on every platform - sometimes it's by design,
sometimes it's a bug in the SoC ROM code, but the restriction exists.
The primary cpu of the cluster always needs to be awake.

In addition, it may not be possible to transition secondary cpus from
C1 to C-multi without waking them.  That would generally involve
cutting power to a CPU that is in clock gating, which is not a
supported power transition in any SoC that I have a datasheet for.  I
made it work for cpu1 on Tegra2, but I can't guarantee that there are
not unsolvable HW race conditions.

The only generic way to make this work is to wake up all cpus.  Waking
up a subset of cpus is certainly worth investigating as an
optimization, but it would not be used on Tegra2, OMAP4, or Exynos5.
Tegra3 may benefit from it.

> It looks like this should work without modifying the cpuidle core, but
> the drawback here is that the cpuidle core doesn't know how much time
> spend in C4 is really in C1 and how much of it is in C-multi, so the
> statistics reported by it won't reflect the real energy usage.

Idle statistics are extremely important when determining why a
particular use case is drawing too much power, and it is worth
modifying the cpuidle core if only to keep them accurate.  Especially
when justifying the move from the cpufreq hotplug governor based code
that every SoC vendor uses in their BSP to a proper multi-CPU cpuidle
implementation.
