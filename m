Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab1EYOJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:09:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58533 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757227Ab1EYOJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:09:14 -0400
Date: Wed, 25 May 2011 16:08:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>,
        huang ying <huang.ying.caritas@gmail.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 5/9] HWPoison: add memory_failure_queue()
Message-ID: <20110525140808.GD19118@elte.hu>
References: <20110517092620.GI22093@elte.hu>
 <4DD31C78.6000209@intel.com>
 <20110520115614.GH14745@elte.hu>
 <BANLkTi=5Y0fqsmhsoPm8si=nQBc-tCwtrw@mail.gmail.com>
 <20110522100021.GA28177@elte.hu>
 <BANLkTi=VDQMOfWe5tP7nXSv2AEsiUUEteg@mail.gmail.com>
 <20110522132515.GA13078@elte.hu>
 <4DD9C8B9.5070004@intel.com>
 <20110523110151.GD24674@elte.hu>
 <987664A83D2D224EAE907B061CE93D5301D5BF823C@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301D5BF823C@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> In your proposed solution, we'd generate an event that would be 
> handled by some process/daemon ... but how would we ensure that the 
> affected process does not run in the mean time? Could we create 
> some analogous method to the ptrace stopped state, and hand control 
> of the affected process to the daemon that gets the event?

Ok, i think there is a bit of a misunderstanding here - which is not 
a surprise really: we made generic arguments all along with very few 
specifics.

The RAS daemon would deal with 'slow' policy action: fully recovered 
events. It would also log various events so that people can do post 
mortem etc.

The main point of defining events here is so that there's a single 
method of transport and a single flexible method of defining and 
extracting events.

Some of the event processing would occur in the kernel: in code that 
knows about memory_failure() and calls it while making sure we do not 
execute any user-space instruction.

Some of the code would execute *very* early and in a very atomic way, 
still in NMI context: panicing the box if the error is so severe.

Neither of these are steps that the RAS daemon can or wants to 
handle.

The RAS tools would interact with the regular perf facilities setting 
and configuring the various RAS related events. They'd handle the 
'severity' config bits, they'd initiate testing (injection), etc.

Ideally the RAS daemon and tools would do what syslog does (and 
more), with more structured events. In the end of the day most of the 
'policy action' is taken by humans anyway, who want to take a look at 
some ASCII output. So printk() integration and obvious ASCII output 
for everything is important along the way.

> 2) The memory error was found in certain special sections of the
>    kernel for which recovery is possible (e.g. while copying to/from
>    user memory, perhaps also page copy and page clear).
> 
> Here I don't have a solution. TIF_MCE_NOTIFY isn't checked when 
> returning from do_machine_check() to kernel code.

Well, since we are already in interrupt context (albeit in a very 
atomic NMI context), sending a self-IPI is not strictly necessary. We 
could fix up the return address and jump to the right handler 
straight away during the IRET.

A self-IPI might also not execute *immediately* - there's always the 
chance of APIC related delays.

> In a CONFIG_PREEMPT=y kernel, all of the recoverable cases ought to 
> be in places where pre-emption is allowed ... so perhaps we can 
> also use the stop-and-switch option here?

Yes, these are generally preemptible cases - and if they are not we 
can make the error fatal (we do not have to handle *every* complex 
case, giving up is a fair answer as well - we do not want rare code 
to be complex really).

But you don't need to stop-and-switch: just stack-nesting on top of 
whatever preemptible code was running there would be enough, wouldnt 
it? That stops a task from executing until the decision has been made 
whether it can continue or not.

Thanks,

	Ingo
