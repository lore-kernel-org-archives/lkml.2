Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2EBHX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 03:23:29 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:50059 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751707Ab2EBHWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 03:22:41 -0400
Message-ID: <4FA0E0B1.5010605@ti.com>
Date: Wed, 02 May 2012 12:52:25 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCHv3 0/5] coupled cpuidle state support
References: <1335816551-27756-1-git-send-email-ccross@android.com> <201204302325.09505.rjw@sisk.pl> <CAMbhsRRReyiv2LgUNgp6XiW07V8Eb0gd4fb7W6nBjMZ1FpmOBQ@mail.gmail.com> <20120501104310.GB28930@e102568-lin.cambridge.arm.com> <CAMbhsRRhJ-7Am0k0OCJG0E9C=w+ApVi2Ce4b-BfV_6frJfTh=Q@mail.gmail.com>
In-Reply-To: <CAMbhsRRhJ-7Am0k0OCJG0E9C=w+ApVi2Ce4b-BfV_6frJfTh=Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2012 05:41 AM, Colin Cross wrote:
> On Tue, May 1, 2012 at 3:43 AM, Lorenzo Pieralisi
> <lorenzo.pieralisi@arm.com> wrote:
>> Hi Colin,
>>
>> On Mon, Apr 30, 2012 at 10:37:30PM +0100, Colin Cross wrote:
> <snip>
> 
>>> On Tegra3, the deepest individual cpu state for cpus 1-3 is OFF, the
>>> same state the cpu would go into as the first step of a transition to
>>> a deeper power state (cpus 0-3 OFF).  It would be more optimal in that
>>> case to bypass the SMP cross call, and leave the cpu in OFF, but that
>>> would require some way of disabling all wakeups for the secondary cpus
>>> and then verifying that they didn't start waking up just before the
>>> wakeups were disabled.  I have just started considering this
>>> optimization, but I don't see anything in the existing code that would
>>> prevent adding it later.
>>
I was also looking at how we can avoid the un-necessary wakeup on
secondary CPUs if the timer event is not for those CPUs. As you
rightly said, we can add all the optimisations once we have the
base patches merged.

>> I agree it is certainly an optimisation that can be added later if benchmarks
>> show it is needed (but again it is heavily platform dependent, ie technology
>> dependent).
>> On a side note, disabling (or move to the primary) wake-ups for "secondaries"
>> on platforms where every core is in a different power domain is still needed
>> to avoid having a situation where a CPU can independently get out of idle, ie
>> abort idle, after hitting the coupled barrier.
>> Still do not know if for those platforms coupled C-states should be used, but
>> it is much better to have a choice there IMHO.
> 
> Yes, that is the primary need for the coupled_cpuidle_parallel_barrier
> function - secondary cpus need to disable their wakeup sources, then
> check that a wakeup was not already pending and abort if necessary.
> 
>> I have also started thinking about a cluster or multi-CPU "next-event" that
>> could avoid triggering heavy operations like L2 cleaning (ie cluster shutdown)
>> if a timer is about to expire on a given CPU (as you know CPUs get in and out
>> of idle independently so the governor decision at the point the coupled state
>> barrier is hit might be stale).
> 
> It would be possible to re-check the governor to decide the next state
> (maybe only if the previous decision is out of date by more than the
> target_residency?), but I left that as an additional optimization.
>
Yep. If the remaining time for idle is not enough, we
should abort that C-states since the CPU won't stay for good
enough time in the C-state to save power.

>> I reckon the coupled C-state concept can prove to be an effective one for
>> some platforms, currently benchmarking it.
>>
>>> A simple measurement using the tracing may show that it is
>>> unnecessary.  If the wakeup time for CPU1 to go from OFF to active is
>>> small there might be no need to optimize out the extra wakeup.
>>
>> Indeed, it is all about resetting the CPU and getting it started, with
>> inclusive L2 the power cost of shutting down a CPU and resuming it should be
>> low (and timing very fast) for most platforms.
> 
> The limiting factor may be the amount of time spent in ROM/Trustzone
> code when bringing a cpu back online.

It is fast but it's not very small time and will vary on CPU speed too.
As mentioned by Colin it all depends on secure code, CPU restore code
as well as the power domain transition time. Of course power domain
transition time will be different on different platforms.

Regards
santosh

