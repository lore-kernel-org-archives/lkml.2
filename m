Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab1EWQpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:45:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:20002 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab1EWQpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:45:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,257,1304319600"; 
   d="scan'208";a="6167387"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>
CC: huang ying <huang.ying.caritas@gmail.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@alien8.de>
Date: Mon, 23 May 2011 09:45:50 -0700
Subject: RE: [PATCH 5/9] HWPoison: add memory_failure_queue()
Thread-Topic: [PATCH 5/9] HWPoison: add memory_failure_queue()
Thread-Index: AcwZONv90LFc5ZBhRSie905s4oTWowALKNFA
Message-ID: <987664A83D2D224EAE907B061CE93D5301D5BF823C@orsmsx505.amr.corp.intel.com>
References: <20110517084622.GE22093@elte.hu> <4DD23750.3030606@intel.com>
 <20110517092620.GI22093@elte.hu> <4DD31C78.6000209@intel.com>
 <20110520115614.GH14745@elte.hu>
 <BANLkTi=5Y0fqsmhsoPm8si=nQBc-tCwtrw@mail.gmail.com>
 <20110522100021.GA28177@elte.hu>
 <BANLkTi=VDQMOfWe5tP7nXSv2AEsiUUEteg@mail.gmail.com>
 <20110522132515.GA13078@elte.hu> <4DD9C8B9.5070004@intel.com>
 <20110523110151.GD24674@elte.hu>
In-Reply-To: <20110523110151.GD24674@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> - NMI handler run for the hardware error, where hardware error
>>   information is collected and put into perf ring buffer as 'event'.
>
> Correct.
>
> Note that for MCE errors we want the 'persistent event' framework Boris has 
> posted: we want these events to be buffered up to a point even if there is no 
> tool listening in on them:

This is a very opportune time to have this discussion. I've been working
on getting "in context" recoverable errors working. Sandybridge Server
platforms will allow for recovery for both instruction and data fetches
in the current execution context. These are flagged in the machine check
bank with the "AR" (Action Required) set to 1 (along with several other
bits making up a recognizable signature).

The critical feature here is that we must not return from the machine
check handler to the context that tripped over the error. In the case
of the data fault, we'll just re-execute the same access and take
another machine check. In the case of the instruction fault there is
no valid context to return to (MCGSTATUS.RIPV is zero).

There are a couple of cases where recovery is possible:

1) The memory error was found while executing user mode code.

The code I have now for recovery makes use of TIF_MCE_NOTIFY to
make sure that we don't return to the user, but instead end up
in arch/x86/kernel/signal.c:do_notify_resume() where we arrange
to have the process handle its own recovery (using mm/memory-failure.c
to figure out the type of page, and probably resulting in the mapping
out of the page and sending SIGBUS to the process).

In your proposed solution, we'd generate an event that would be handled
by some process/daemon ... but how would we ensure that the affected
process does not run in the mean time? Could we create some analogous
method to the ptrace stopped state, and hand control of the affected
process to the daemon that gets the event?

2) The memory error was found in certain special sections of the
   kernel for which recovery is possible (e.g. while copying to/from
   user memory, perhaps also page copy and page clear).

Here I don't have a solution. TIF_MCE_NOTIFY isn't checked when returning
from do_machine_check() to kernel code.

In a CONFIG_PREEMPT=y kernel, all of the recoverable cases ought to be
in places where pre-emption is allowed ... so perhaps we can also use
the stop-and-switch option here?

-Tony

