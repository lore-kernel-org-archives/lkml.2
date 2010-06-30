Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab0F3RTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 13:19:35 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59546 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab0F3RTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 13:19:34 -0400
Message-ID: <4C2B7C9F.5070100@linux.vnet.ibm.com>
Date: Wed, 30 Jun 2010 10:19:27 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
References: <20100624142804.431553874@chello.nl> <4C262949.3030804@linux.vnet.ibm.com> <1277738009.3561.129.camel@laptop>
In-Reply-To: <1277738009.3561.129.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 08:13 AM, Peter Zijlstra wrote:
> On Sat, 2010-06-26 at 09:22 -0700, Corey Ashford wrote:
> As for the "hardware write batching", can you describe a bit more about
>> what you have in mind there?  I wonder if this might have something to
>> do with accounting for PMU hardware which is slow to access, for
>> example, via I2C via an internal bridge.
>
> Right, so the write batching is basically delaying writing out the PMU
> state to hardware until pmu::pmu_enable() time. It avoids having to
> re-program the hardware when, due to a scheduling constraint, we have to
> move counters around.
>
> So say, we context switch a task, and remove the old events and add the
> new ones under a single pmu::pmu_disable()/::pmu_enable() pair, we will
> only hit the hardware twice (once to disable, once to enable), instead
> of for each individual ::del()/::add().
>
> For this to work we need to have an association between a context and a
> pmu, otherwise its very hard to know what pmu to disable/enable; the
> alternative is all of them which isn't very attractive.
>
> Then again, it doesn't make sense to have task-counters on an I2C
> attached PMU simply because writing to the PMU could cause context
> switches.

Thanks for your reply.

In our case, writing to some of the nest PMUs' control registers is done 
via an internal bridge.  We write to a specific memory address and an 
internal MMIO-to-SCOM bridge (SCOM is similar to I2C) translates it to 
serial and sends it over the internal serial bus.  The address we write 
to is based upon the control register's serial bus address, plus an 
offset from the base of MMIO-to-SCOM bridge.  The same process works for 
reads.

While it does not cause a context switch because there are no IO drivers 
to go through, it will take several thousand CPU cycles to complete, 
which by the same token, still makes them inappropriate for 
task-counters (not to mention that the nest units operate asynchronously 
from the CPU).

However, there still are concerns relative to writing these control 
registers from an interrupt handler because of the latency that will be 
incurred, however slow we choose to do the event rotation.  So at least 
for the Wire-Speed processor, we may need a worker thread of some sort 
to hand off the work to.

Our current code, based on linux 2.6.31 (soon to be 2.6.32) doesn't use 
worker threads; we are just taking the latency hit for now.

- Corey
