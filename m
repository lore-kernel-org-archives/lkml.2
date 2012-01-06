Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab2AFE6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 23:58:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40025 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab2AFE6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 23:58:41 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=QcgJSxWpgi8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=XtckqA8Zus7rZaHtIyIA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325825918.12696.64.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 05 Jan 2012 23:58:38 -0500
In-Reply-To: <1325765791.12696.41.camel@gandalf.stny.rr.com>
References: <20111221123624.193898256@goodmis.org>
	 <20120101180949.GA25066@elte.hu> <20120102105856.GA6661@elte.hu>
	 <20120102134856.GA32673@elte.hu>
	 <1325635373.12696.4.camel@gandalf.stny.rr.com>
	 <1325635922.12696.8.camel@gandalf.stny.rr.com>
	 <1325653301.12696.20.camel@gandalf.stny.rr.com>
	 <20120104141107.GA24770@elte.hu>
	 <1325696759.12696.24.camel@gandalf.stny.rr.com>
	 <20120105091916.GA22598@elte.hu>
	 <1325764011.12696.38.camel@gandalf.stny.rr.com>
	 <1325765791.12696.41.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-05 at 07:16 -0500, Steven Rostedt wrote:
> On Thu, 2012-01-05 at 06:46 -0500, Steven Rostedt wrote:
> 
> > When I reverted this, my machine booted. I'm now trying that machine
> > again with your allyesconfig.
> 
> After reverting that patch, your allyesconfig boots up fine on this
> machine. I'll reboot it several more times to see if I can reproduce any
> of the lockups you see. If I'm not getting anywhere on this, I'll go and
> test the NMI side.

Still no luck. Although I found if I disable CONFIG_SYSFS_DEPRECATED_V2,
I was able to boot on another box. This box I started testing the NMI
code and I hit this lockup with this stack trace:

[   71.356011] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 3
[   71.356011] Pid: 665, comm: udevd Tainted: G        W    3.2.0-rc7-test-tip-02011-g1bc2a30 #4
[   71.356011] Call Trace:
[   71.356011]  <NMI>  [<ffffffff830b36eb>] panic+0xa0/0x1c5
[   71.356011]  [<ffffffff8111884d>] watchdog_overflow_callback+0x81/0xa6
[   71.356011]  [<ffffffff8114c0dd>] __perf_event_overflow+0x100/0x189
[   71.356011]  [<ffffffff8105771f>] ? x86_perf_event_set_period+0x107/0x113
[   71.356011]  [<ffffffff8114c453>] perf_event_overflow+0x14/0x16
[   71.356011]  [<ffffffff8105b034>] intel_pmu_handle_irq+0x156/0x1b6
[   71.356011]  [<ffffffff8317e345>] perf_event_nmi_handler+0x19/0x1b
[   71.356011]  [<ffffffff8317db40>] nmi_handle.isra.1+0xb2/0x134
[   71.356011]  [<ffffffff8317daeb>] ? nmi_handle.isra.1+0x5d/0x134
[   71.356011]  [<ffffffff8317dc8f>] default_do_nmi+0x49/0x1a7
[   71.356011]  [<ffffffff8317de4b>] do_nmi+0x5e/0x9f
[   71.356011]  [<ffffffff8317d240>] nmi+0x20/0x39
[   71.356011]  [<ffffffff810e23e6>] ? check_flags.part.37+0xbb/0x16b
[   71.356011]  <<EOE>>  [<ffffffff810e24a8>] check_flags+0x12/0x14
[   71.356011]  [<ffffffff810e34bc>] lock_is_held+0x39/0x9d
[   71.356011]  [<ffffffff810caa15>] ? effective_load+0x8a/0x8a
[   71.356011]  [<ffffffff810bf857>] ? global_rt_runtime+0x23/0x23
[   71.356011]  [<ffffffff810c3a62>] rcu_read_lock_held+0x2e/0x34
[   71.356011]  [<ffffffff810c621f>] walk_tg_tree_from+0x8a/0xe2
[   71.356011]  [<ffffffff810cc51a>] load_balance_fair+0x56/0x16c
[   71.356011]  [<ffffffff810e3ab4>] ? lock_acquired+0x67/0x72
[   71.356011]  [<ffffffff810cf48a>] load_balance+0x185/0x39b
[   71.356011]  [<ffffffff810cacfa>] ? rcu_read_unlock+0x4b/0x5c
[   71.356011]  [<ffffffff810cfaa8>] idle_balance+0xf8/0x16d
[   71.356011]  [<ffffffff8317aef7>] __schedule+0x20b/0x5b4
[   71.356011]  [<ffffffff8317c8ef>] ? _raw_spin_unlock_irqrestore+0x45/0x61
[   71.356011]  [<ffffffff8317b35f>] schedule+0x5a/0x5c
[   71.356011]  [<ffffffff8317a74a>] schedule_hrtimeout_range_clock+0xca/0x11d
[   71.356011]  [<ffffffff810bb45a>] ? update_rmtp+0x6a/0x6a
[   71.356011]  [<ffffffff810bc28a>] ? hrtimer_start_range_ns+0x14/0x16
[   71.356011]  [<ffffffff8317a7b0>] schedule_hrtimeout_range+0x13/0x15
[   71.356011]  [<ffffffff811b46ed>] poll_schedule_timeout+0x48/0x64
[   71.356011]  [<ffffffff811b4da2>] do_poll.isra.5+0x1e2/0x205
[   71.356011]  [<ffffffff811b585f>] do_sys_poll+0xf3/0x16f
[   71.356011]  [<ffffffff811b47b3>] ? poll_freewait+0xaa/0xaa
[   71.356011]  [<ffffffff811b4a78>] ? max_select_fd+0x154/0x154
[   71.356011]  [<ffffffff811b4a78>] ? max_select_fd+0x154/0x154
[   71.356011]  [<ffffffff811b4a78>] ? max_select_fd+0x154/0x154
[   71.356011]  [<ffffffff811b4a78>] ? max_select_fd+0x154/0x154
[   71.356011]  [<ffffffff811b4a78>] ? max_select_fd+0x154/0x154
[   71.356011]  [<ffffffff810e0473>] ? trace_hardirqs_off_caller+0x1f/0x117
[   71.356011]  [<ffffffff810e0578>] ? trace_hardirqs_off+0xd/0xf
[   71.356011]  [<ffffffff810ca713>] ? local_clock+0x36/0x4d
[   71.356011]  [<ffffffff810e07fa>] ? lock_release_holdtime.part.24+0x4e/0x55
[   71.356011]  [<ffffffff8317c8ef>] ? _raw_spin_unlock_irqrestore+0x45/0x61
[   71.356011]  [<ffffffff810e28ab>] ? __trace_hardirqs_on_caller+0x65/0x98
[   71.356011]  [<ffffffff8317c8ef>] ? _raw_spin_unlock_irqrestore+0x45/0x61
[   71.356011]  [<ffffffff810e29e0>] ? trace_hardirqs_on_caller+0x102/0x113
[   71.356011]  [<ffffffff810b86bd>] ? remove_wait_queue+0x32/0x3a
[   71.356011]  [<ffffffff8109a075>] ? do_wait+0x1f8/0x259
[   71.356011]  [<ffffffff8109c178>] ? timespec_add_safe+0x37/0x67
[   71.356011]  [<ffffffff811b4e2b>] ? poll_select_set_timeout+0x66/0x7a
[   71.356011]  [<ffffffff83183d15>] ? sysret_check+0x22/0x5d
[   71.356011]  [<ffffffff811b597e>] sys_poll+0x51/0xbb
[   71.356011]  [<ffffffff83183ce9>] system_call_fastpath+0x16/0x1b


This happened with tip/master with this commit:

1bc2a3035df2f75b061dc5cdc9d1d79d7ad3995e


Not sure what else to do. Have you been able to trigger these bugs
without my patches? All the bugs I've been hitting after merging my
patches, I've been able to hit with tip/master as well.

-- Steve


