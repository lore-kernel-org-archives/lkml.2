Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab1BXU0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:26:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:59727 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab1BXU03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:26:29 -0500
Subject: Re: [PATCH V5 2/2] tracing, perf : add cpu hotplug trace events
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        linux-hotplug@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110224201124.138311ba@lxorguk.ukuu.org.uk>
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com>
	 <1298573197.2428.457.camel@twins>
	 <20110224201124.138311ba@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 21:27:50 +0100
Message-ID: <1298579271.5226.832.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 20:11 +0000, Alan Cox wrote:
> > Anybody who is interested in the latency of cpu hotplug is deluding
> > himself, also cpu hotplug is _NOT_ a power management feature, so the
> > rest of your justification just disappeared as well.
> 
> Actually CPU hotplug is a power management feature on some devices where
> you need to shutdown one of the cores to enter low power modes.

Aren't we confusing things here? Surely simply idling a core is good
enough? Why would we want to go through the whole CPU hotplug dance
simply to enter a low power state?

> Remember we use it as part of the suspend paths and various processors
> nowdays drop into a suspend to RAM type state on CPU idling.

Which would illustrate the above point. CPU hotplug is a terribly
expensive op, and doing so from idle is really utterly ridiculous (nor
can we, idle is not supposed to schedule and cpu-hotplug needs to
schedule)

Why can't we do these things from the normal idle path, presumably these
state transitions are 'fast', so we can implement them as normal idle
modes. 

The scheduler has (due to power7 support) the ability to favour lower
cpu nrs when placing tasks, so idle !bsp (assuming cpu0 is the bsp) can
drop into their special state, and then when the bsp goes idle it can do
whatever it needs to do.

All that needs is to make sure smp_send_reschedule() can wake !bsp cores
from their special sleep state, but that's all arch code anyway.

I really see no reason to conflate cpu-hotplug and idle/power-states.

