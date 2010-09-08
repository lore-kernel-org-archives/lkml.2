Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab0IHQu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:50:58 -0400
Received: from mail.openrapids.net ([64.15.138.104]:58822 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752773Ab0IHQu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 12:50:56 -0400
Date: Wed, 8 Sep 2010 12:50:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH 1/2] Idle notifier standardization (v2)
Message-ID: <20100908165054.GA22185@Krystal>
References: <20100908155659.GA23344@Krystal> <alpine.LFD.2.00.1009081810470.2477@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009081810470.2477@localhost6.localdomain6>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:48:50 up 228 days, 19:25,  5 users,  load average: 0.00, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> On Wed, 8 Sep 2010, Mathieu Desnoyers wrote:
> 
> > Move idle notifiers into arch-agnostic code. Adapt x86 64 accordingly to call
> > the new architecture-agnostic notifiers rather than its own.
> > 
> > The architectures implementing the idle notifier define the config option:
> > 
> > CONFIG_HAVE_IDLE_NOTIFIER
> > 
> > Changelog since v1:
> > * Add CONFIG_HAVE_IDLE_NOTIFIER.
> > 
> > 
> > This is needed by the generic ring buffer. It needs to let the system sleep if
> > there is nothing going on other than tracing on a cpu, but for streaming it also
> > has to provide an upper bound on the delay before the information is sent out
> > (for merging across event streams coming from different CPUs). These notifiers
> > lets the ring buffer use deferrable timers to perform data delivery by forcing a
> > buffer flush before going to sleep.
> 
> I really have a hard time to understand how this is related to
> deferrable timers. The whole point of deferrable timers is that they
> do not fire when the machine is idle. 
> 
> I understand that you want to not care about the timer, but at the
> same time you want to flush the buffer when going idle. 
> 
> So why do you keep the timer armed ? Just that it fires when the CPU
> comes out of a long idle sleep and you flush the buffer again? So why
> not cancel the timer on idle enter and rearm it when the machine
> starts again?

That sounds exactly like what I am trying to achieve. Letting the timer fire
upon exit from idle was a side-effect I could really do without.

> 
> So really, the reason why you want those notifiers is to flush the
> buffer and _not_ to allow you the usage of deferrable timers.

Yep.

> 
> Aside of that I really hate it to sprinkle the same notifier crap into
> all arch idle functions - you even blindly copied the 64 bit
> implementation to 32bit instead of moving it into the shared process.c
> file.

Yep, I would have moved it to process.c, but I guess I'll hook on nohz instead.

> 
> The whole point of your exercise seems to be power saving related, so
> why don't you hook that tracer flush stuff into
> tick_nohz_stop_sched_tick() and tick_nohz_restart_sched_tick()
> instead?  Those are called on idle enter and exit from all archs which
> use NOHZ, so you should be all set. No need for adding that notifier
> horror to every arch, really.

Yep. I'll do that. Thanks a ton for looking into this.

Mathieu

> 
> Thanks,
> 
> 	tglx

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
