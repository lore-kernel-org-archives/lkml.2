Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab2HROdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 10:33:20 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57936 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab2HROdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 10:33:18 -0400
MIME-Version: 1.0
In-Reply-To: <502EA680.4080608@genband.com>
References: <5028F12C.7080405@intel.com>
	<1345028738.31459.82.camel@twins>
	<502C98E8.20800@linux.vnet.ibm.com>
	<502CFD35.5000801@linux.intel.com>
	<20120817184100.GA13369@srcf.ucam.org>
	<502E90F3.2000702@linux.intel.com>
	<20120817184705.GB13369@srcf.ucam.org>
	<502E9F45.6030606@genband.com>
	<20120817195033.GA15589@srcf.ucam.org>
	<502EA680.4080608@genband.com>
Date: Sat, 18 Aug 2012 22:33:16 +0800
Message-ID: <CAJRGBZygPfmRcVmMzDiCrf7uJVDb_6pHsrfthdERmUZnDfygWw@mail.gmail.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in scheduler
From: Luming Yu <luming.yu@gmail.com>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        preeti <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 4:16 AM, Chris Friesen
<chris.friesen@genband.com> wrote:
> On 08/17/2012 01:50 PM, Matthew Garrett wrote:
>>
>> On Fri, Aug 17, 2012 at 01:45:09PM -0600, Chris Friesen wrote:
>>>
>>> On 08/17/2012 12:47 PM, Matthew Garrett wrote:
>>
>>
>>> The datasheet for the Xeon E5 (my variant at least) says it doesn't
>>> do C7 so never powers down the LLC.  However, as you said earlier
>>> once you can put the socket into C6 which saves about 30W compared
>>> to C1E.
>>>
>>> So as far as I can see with this CPU at least you would benefit from
>>> shutting down a whole socket when possible.
>>
>>
>> Having any active cores on the system prevents all packages from going
>> into PC6 or deeper. What I'm not clear on is whether less deep package C
>> states are also blocked.
>>
>
> Right, we need the memory controller.
>
> The E5 datasheet is a bit ambiguous, it reads:
>
>
> A processor enters the package C3 low power state when:
>  -At least one core is in the C3 state.
>  -The other cores are in a C3 or lower power state, and the processor has
> been granted permission by the platform.
>
>
> Unfortunately it doesn't specify whether that is the other cores in the
> package, or the other cores on the whole system.
>

Hardware limitations is just part of the problem. We could find them
out from various white papers or data sheets, or test out.To me, the
key problem in terms of power and performance balancing still lies in
CPU and memory allocation method.  For example, on a system we can
benefit from shutting down a whole socket when possible, if a workload
allocates 50% CPU cycles and 50% memory bandwidth and space on a two
socket system(modern), an ideal allocation method ( I assume it's our
goal of the discussion) should leave CPU, cache, memory controller and
memory on one socket ( node) completely idle and in deepest power
saving mode. But obviously, we need to spread as much as possible
across all cores in another socket(to race to idle). So from the
example above, we see a threshold that we need to reference before
selecting one from two complete different policy: spread or not
spread... As long as there is hardware limitation, we could always
need knob like that referenced threshold to adapt on different
hardware in one kernel....

/l
