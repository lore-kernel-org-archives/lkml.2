Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab0IHQnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:43:51 -0400
Received: from www.tglx.de ([62.245.132.106]:53133 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab0IHQnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 12:43:49 -0400
Date: Wed, 8 Sep 2010 18:43:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
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
In-Reply-To: <20100908155659.GA23344@Krystal>
Message-ID: <alpine.LFD.2.00.1009081810470.2477@localhost6.localdomain6>
References: <20100908155659.GA23344@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010, Mathieu Desnoyers wrote:

> Move idle notifiers into arch-agnostic code. Adapt x86 64 accordingly to call
> the new architecture-agnostic notifiers rather than its own.
> 
> The architectures implementing the idle notifier define the config option:
> 
> CONFIG_HAVE_IDLE_NOTIFIER
> 
> Changelog since v1:
> * Add CONFIG_HAVE_IDLE_NOTIFIER.
> 
> 
> This is needed by the generic ring buffer. It needs to let the system sleep if
> there is nothing going on other than tracing on a cpu, but for streaming it also
> has to provide an upper bound on the delay before the information is sent out
> (for merging across event streams coming from different CPUs). These notifiers
> lets the ring buffer use deferrable timers to perform data delivery by forcing a
> buffer flush before going to sleep.

I really have a hard time to understand how this is related to
deferrable timers. The whole point of deferrable timers is that they
do not fire when the machine is idle. 

I understand that you want to not care about the timer, but at the
same time you want to flush the buffer when going idle. 

So why do you keep the timer armed ? Just that it fires when the CPU
comes out of a long idle sleep and you flush the buffer again? So why
not cancel the timer on idle enter and rearm it when the machine
starts again?

So really, the reason why you want those notifiers is to flush the
buffer and _not_ to allow you the usage of deferrable timers.

Aside of that I really hate it to sprinkle the same notifier crap into
all arch idle functions - you even blindly copied the 64 bit
implementation to 32bit instead of moving it into the shared process.c
file.

The whole point of your exercise seems to be power saving related, so
why don't you hook that tracer flush stuff into
tick_nohz_stop_sched_tick() and tick_nohz_restart_sched_tick()
instead?  Those are called on idle enter and exit from all archs which
use NOHZ, so you should be all set. No need for adding that notifier
horror to every arch, really.

Thanks,

	tglx
