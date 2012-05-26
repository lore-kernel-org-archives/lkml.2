Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab2EZBgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 21:36:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31373 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2EZBgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 21:36:47 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Aua4qMZyJ18A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=KwlEga3hPrP5s0ycNigA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337996205.13348.277.camel@gandalf.stny.rr.com>
Subject: Re: BUG - function tracing with breakpoints
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Fri, 25 May 2012 21:36:45 -0400
In-Reply-To: <1337979086.13348.269.camel@gandalf.stny.rr.com>
References: <20120524160146.GA6226@redhat.com>
	 <1337876398.13348.178.camel@gandalf.stny.rr.com>
	 <20120524172223.GA10689@redhat.com>
	 <1337902816.13348.224.camel@gandalf.stny.rr.com>
	 <4FBEC9E6.8040301@linux.intel.com>
	 <1337909963.13348.232.camel@gandalf.stny.rr.com>
	 <1337910106.13348.234.camel@gandalf.stny.rr.com>
	 <1337956262.13348.257.camel@gandalf.stny.rr.com>
	 <1337959746.13348.264.camel@gandalf.stny.rr.com>
	 <4FBFC421.3020901@linux.intel.com>
	 <1337971575.13348.268.camel@gandalf.stny.rr.com>
	 <1337979086.13348.269.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 16:51 -0400, Steven Rostedt wrote:
> On Fri, 2012-05-25 at 14:46 -0400, Steven Rostedt wrote:
> > On Fri, 2012-05-25 at 10:40 -0700, H. Peter Anvin wrote:
> > > On 05/25/2012 08:29 AM, Steven Rostedt wrote:
> > > > 
> > > > This would make sense for this bug, as if modifying_ftrace_code was not
> > > > seen by other CPUs, it wouldn't go into the ftrace_int3_handler() path.
> > > > That would cause this issue. But the bug remains after the smp_mb()'s
> > > > were put in place. Although it behaves a little differently not. Maybe
> > > > there's something else I missed?
> > > > 
> > > 
> > > Perhaps you should make the modifying_ftrace_code modification atomic...
> > > it seems odd to have it not be atomic when it is clearly accessed across
> > > CPUs that way.
> > 
> > I guess I can make it atomic. Not really a big deal as this (and soon
> > one other place) is the only place that changes its value.
> > 
> > I've found another place that may be causing harm, and I'm currently
> > working on fixing it. Hopefully after that's done, this problem will go
> > away.
> 

OK, here's another clue.

I've added tons of debug, and filtering out functions to trace. I even
added a 64 entry buffer that records what spots are being hit by the
breakpoint (it always dies with just the breakpoints, it never makes it
to the update instruction part).

Basically it always crashes with this path:

[   45.050159]    [ffffffff8109c1a9 ktime_get+0x19/0xe0]
[   45.050159]    [ffffffff810a3921 update_ts_time_stats+0x11/0xa0]
[   45.050159]    [ffffffff8104ef29 ns_to_timeval+0x9/0x40]
[   45.050159]    [ffffffff8104eea9 ns_to_timespec+0x9/0x80]
[   45.050159]    [ffffffff8104ef29 ns_to_timeval+0x9/0x40]
[   45.050159]    [ffffffff8104eea9 ns_to_timespec+0x9/0x80]
[   45.050159]    [ffffffff814bda45 __cpufreq_driver_getavg+0x15/0x80]
[   45.050159]    [ffffffff814bd735 cpufreq_cpu_get+0x15/0xd0]
[   45.050159]    [ffffffff810b6aad try_module_get+0x1d/0x140]
[   45.050159]    [ffffffff814c387c cpufreq_get_measured_perf+0xc/0xa0]
[   45.050159]    [ffffffff810b2dbd smp_call_function_single+0x1d/0x1c0]
[   45.050159]    [ffffffff814c391a read_measured_perf_ctrs+0xa/0x70]
[   45.050159]    [ffffffff814bcfe5 cpufreq_cpu_put+0x5/0x30]
[   45.050159]    [ffffffff810b67ad module_put+0x1d/0x130]
[   45.050159]    [ffffffff814bcf55 __cpufreq_driver_target+0x15/0xa0]
[   45.050159]    [ffffffff814c3ef2 acpi_cpufreq_target+0x12/0x380]
[   45.050159]    [ffffffff814c21b2 cpufreq_frequency_table_target+0x12/0x1a0]
[   45.050159]    [ffffffff814beced cpufreq_notify_transition+0x1d/0x2c0]
[   45.050159]    [ffffffff81074365 srcu_notifier_call_chain+0x5/0x20]
[   45.050159]    [ffffffff810742bd __srcu_notifier_call_chain+0x1d/0xc0]
[   45.050159]    [ffffffff810736d8 __srcu_read_lock+0x8/0x70]
[   45.050159]    [ffffffff81616072 notifier_call_chain.isra.1+0x12/0xb0]
[   45.050159]    [ffffffff81010efa save_stack_trace+0xa/0x50]

I see it always hitting the cpufreq code just before the crash.
Actually, it never finishes the cpufreq code. Something about this code
causes issues with breakpoints.

/me continues the hunt.

-- Steve


