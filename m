Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab0JXL0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 07:26:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34029 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497Ab0JXL0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 07:26:04 -0400
Date: Sun, 24 Oct 2010 13:25:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
Message-ID: <20101024112540.GA21267@elte.hu>
References: <20101019184111.GA17266@elte.hu>
 <20101020154045.GA18353@elte.hu>
 <20101020164324.GC7348@redhat.com>
 <20101020183329.GA12666@elte.hu>
 <20101021110925.GA27219@elte.hu>
 <20101022175845.GF6498@redhat.com>
 <20101022182433.GA24637@elte.hu>
 <20101022183900.GG6498@redhat.com>
 <20101023200216.GA19324@elte.hu>
 <1287881618.16971.657.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287881618.16971.657.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 2010-10-23 at 22:02 +0200, Ingo Molnar wrote:
> > * Jason Baron <jbaron@redhat.com> wrote:
> > 
> > > > Not the same config, and it's very spurious - i.e. a slightly different -tip 
> > > > version with the same config will boot fine. (this suggests some race)
> > > 
> > > if possible, can you post that .config?
> > 
> > I just reproduced it again with tip-1128a72 - config and full bootlog attached.
> > 
> > The crash picture tends to vary - sometimes it crashes in fork, sometimes in the 
> > timer interrupt. Here's the current one:
> > 
> > [   15.384483] Running tests on trace events:
> > [   15.388580] Testing event kfree_skb: 
> > [   15.392381] BUG: unable to handle kernel NULL pointer dereference at (null)
> > [   15.395408] IP: [<(null)>] (null)
> 
> Interesting, the jump was to NULL. I'm thinking it hit a trace point and
> jumped to a NULL address. I guess there's some strange race here. Is a
> cache flush missing somewhere. I'll look more into this on Monday.

NULL wasnt the only crash i've seen in the past though, here's an older one:

 [    4.983527] Running tests on all trace events:
 [    4.988002] Testing all events:
 [    5.001006] BUG: unable to handle kernel paging request at 7d693ae5
 [    5.001999] IP: [<bf206c23>] 0xbf206c23
 [    5.001999] *pde = 00000000
 [    5.001999] Oops: 0002 [#1] SMP
 [    5.001999] last sysfs file:
 [    5.001999] Modules linked in:
 [    5.001999]
 [    5.001999] Pid: 0, comm: kworker/0:0 Not tainted 2.6.36-rc7-tip+ #48497 /
 [    5.001999] EIP: 0060:[<bf206c23>] EFLAGS: 00010082 CPU: 1
 [    5.001999] EIP is at 0xbf206c23
 [    5.001999] EAX: bf206c25 EBX: 25a98103 ECX: 0001ba00 EDX: 00000000
 [    5.001999] ESI: be48cec0 EDI: 813cba88 EBP: bf206c00 ESP: bec89ee0
 [    5.001999]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068

Another one was:

 [    6.980461] Testing event hrtimer_expire_entry:
 [    7.000007] BUG: unable to handle kernel paging request at a0fe7dfc
 [    7.004000] IP: [<c101b631>] __ticket_spin_lock+0x5/0x15
 [    7.004000] *pde = 00000000
 [    7.004000] Oops: 0002 [#1] SMP
 [    7.004000] last sysfs file:
 [    7.004000] Modules linked in:
 [    7.004000]
 [    7.004000] Pid: 0, comm: kworker/0:0 Not tainted 2.6.36-rc7-tip-01858-g336fdd2-dirty #48488 A8N-E/System Product Name
 [    7.004000] EIP: 0060:[<c101b631>] EFLAGS: 00010002 CPU: 1
 [    7.004000] EIP is at __ticket_spin_lock+0x5/0x15
 [    7.004000] Call Trace:
 [    7.004000]  [<c127e84c>] ? _raw_spin_lock+0x5/0x7
 [    7.004000]  [<c1044699>] ? hrtimer_run_queues+0x1af/0x1fd
 [    7.004000]  [<c1036da9>] ? run_local_timers+0x5/0xf
 [    7.004000]  [<c1036dd4>] ? update_process_times+0x21/0x43
 [    7.004000]  [<c104be84>] ? tick_handle_periodic+0x14/0x68
 [    7.004000]  [<c1015c84>] ? smp_apic_timer_interrupt+0x66/0x75
 [    7.004000]  [<c127f0ff>] ? apic_timer_interrupt+0x2f/0x34
 [    7.004000]  [<c101afc4>] ? native_safe_halt+0x2/0x3
 [    7.004000]  [<c10081c8>] ? default_idle+0x66/0x91
 [    7.004000]  [<c1001901>] ? cpu_idle+0x53/0x9a

so i'd suggest to not limit things to a NULL overwrite alone.

Thanks,

	Ingo
