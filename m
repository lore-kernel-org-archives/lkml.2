Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab2DJK3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:29:41 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4152 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab2DJK3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:29:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 10 Apr 2012 03:29:22 -0700
Date: Tue, 10 Apr 2012 13:28:57 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC PATCH] cpuidle: allow per cpu latencies
Message-ID: <20120410102857.GA22721@tbergstrom-lnx.Nvidia.com>
References: <1333619620-21201-1-git-send-email-pdeschrijver@nvidia.com>
 <4F7DA009.4010802@linux.intel.com>
 <CAMQu2gzwe0F3qcaTqASEPUASdG1SjpUxrBrSp-RrYLgy3W24OQ@mail.gmail.com>
 <4F7F0D52.8080305@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F7F0D52.8080305@linaro.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 05:35:46PM +0200, Daniel Lezcano wrote:
> On 04/06/2012 12:32 PM, Shilimkar, Santosh wrote:
> > Peter,
> >
> > On Thu, Apr 5, 2012 at 7:07 PM, Arjan van de Ven<arjan@linux.intel.com>  wrote:
> >> On 4/5/2012 2:53 AM, Peter De Schrijver wrote:
> >>> This patch doesn't update all cpuidle device registrations. I will do that
> >>
> >> question is if you want to do per cpu latencies, or if you want to have
> >> both types of C state in one big table, and have each of the tegra cpyu
> >> types pick half of them...
> >>
> >>
> > Indeed !! That should work.
> > I thought the C-states are always per CPU based and during the
> > cpuidle registration you can register C-state accordingly based on the
> > specific CPU types with different latencies if needed.
> >
> > Am I missing something ?
> 
> That was the case before the cpuidle_state were moved from the 
> cpuidle_device to the cpuidle_driver structure [1].
> 
> That had the benefit of using a single latencies array instead of 
> multiple copy of the same array, which was the case until today.
> 
> I looked at the white paper for the tegra3 and understand this is no 
> longer true because of the 4-plus-1 architecture [2].
> 

The reason is not so much 4-plus-1, but in 4 CPU mode, only CPUs 1 - 3 can
be powergated individually. To turn off CPU0, the external regulator for
the entire cluster is turned off. This means latencies for CPU0 are different
from the other CPUs.

> With the increasing number of SoCs, we have a lot of new cpuidle drivers 
> and each time we modify something in the cpuidle core, that impacts all 
> the cpuidle drivers.
> 
> My feeling is we are going back and forth when patching the cpuidle core 
> and may be it is time to define a clear semantic before patching again 
> the cpuidle, no ?
> 
> What could nice is to have:
> 
>   * in case of the same latencies for all cpus, use a single array
> 
>   * in case of different latencies, group the same latencies into a 
> single array (I assume this is the case for 4-plus-1, right ?)
> 
> May be we can move the cpuidle_state to a per_cpu pointer like 
> cpuidle_devices in cpuidle.c and then add:
> 
> register_latencies(struct cpuidle_latencies l, int cpu);
> 
> If we have the same latencies for all the cpus, then we can register the 
> same array, which is only a pointer.

Maybe we also want to make the 'disabled' flag per CPU then or provide some
other way the number of C states can be different per CPU?

Cheers,

Peter.
