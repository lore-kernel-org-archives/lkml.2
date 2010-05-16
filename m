Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0EPL1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 07:27:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35173 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab0EPL1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 07:27:04 -0400
Date: Sun, 16 May 2010 13:26:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@alien8.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>
Subject: Re: perf, ftrace and MCEs
Message-ID: <20100516112641.GA20248@elte.hu>
References: <20100501181212.GA25352@liondog.tnic>
 <20100504113227.GA14067@elte.hu>
 <20100515134312.GA25375@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100515134312.GA25375@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, May 04, 2010 at 01:32:27PM +0200
> 
> Hi,
> 
> > To start with this, a quick initial prototype could use the 'perf trace' live 
> > mode tracing script. (See latest -tip, 'perf trace --script <script-name>' and 
> > 'perf record -o -' to activate live mode.)
> 
> so I did some experimenting with this and have a 
> pretty rough prototype which conveys decoded MCEs 
> to userspace where they're read with perf.

nice :-)

> More specifically, I did
> 
> perf record -e mce:mce_record -a
> 
> after tweaking the mce_record tracepoint to include 
> the decoded error string.
> 
> And then doing
> 
> perf trace -g python
> perf trace -s perf-trace.py
> 
> got me:
> 
> in trace_begin
> mce__mce_record          6 00600.700632283        0 init                  mcgcap=262, mcgstatus=0, bank=4, status=15888347641659525651, addr=26682366720, misc=13837309867997528064, ip=0, cs=0, tsc=0, walltime=1273928155, cpu=6, cpuid=1052561, apicid=6, socketid=0, cpuvendor=2, decoded_err= Northbridge Error, node 1ECC/ChipKill ECC error.
> CE err addr: 0x636649b00
> CE page 0x636649, offset 0xb00, grain 0, syndrome 0x1fd, row 3, channel 0
>  Transaction type: generic read(mem access), no t
> in trace_end
> 
> which shows the signature of an ECC which I 
> injected earlier over the EDAC sysfs interface. And 
> yes, the decoded_err appears truncated so I'll have 
> to think of a slicker way to collect that info.
> 
> Although they're pretty rough yet, I've attached 
> the relevant patches so that one could get an 
> impression of where we're moving here.
> 
> 0001-amd64_edac-Remove-polling-mechanism.patch 
> removes the EDAC polling mechanism in favor of 
> hooking into the machine_check_poll polling 
> function using the atomic notifier which we already 
> use for uncorrectable errors.
> 
> The other two
> 
> 0002-mce-trace-Add-decoded-string-to-mce_record-s-format.patch
> 0003-edac-mce-Prepare-error-decoded-info.patch
> 
> add that decoded_err string. I'm open for better 
> ideas here though.

Yes, this is exactly what i was thinking about.

> Concerning the early MCE logging and reporting, I'm 
> thinking of using the mce.c ring buffer temporarily 
> until the ftrace buffer has been initialized and 
> then copying all records into the last. We might do 
> a more elegant solution in the future after all 
> that bootmem churn has quieted down and allocate 
> memory early for a dedicated MCE ring buffer or 
> whatever.

Agreed.

There's overlap here with the boot tracer as well, 
which we want to convert over to perf events as well.

That could be achieved via the concept of 'persistent 
events', which are basically task-less events brought 
active and attached to a buffer space to dump the 
events to.

That buffer space could be initialized very early on.

> Wrt critical MCEs, I'm leaning towards bypassing 
> perf/ftrace subsystem altogether in favor of 
> executing the smallest amount of code possible 
> like, for example, switching to a tty, dumping the 
> decoded error and in certain cases not panicking 
> but shutting down gracefully after a timeout. Of 
> course, graceful shutdown is completely dependent 
> on the type of hw failure and in some cases we 
> can't do anything else but freeze in order to 
> prevent faulty data propagation.

I agree that the critical functionality itself should 
be implemented in the kernel - and not all routed 
through a user-space component.

But please generate the callbacks via perf events, 
like the new watchdog code does in -tip 
(tip:perf/nmi):

cafcd80: lockup_detector: Cross arch compile fixes
23637d4: lockup_detector: Introduce CONFIG_HARDLOCKUP_DETECTOR
c01d432: lockup_detector: Adapt CONFIG_PERF_EVENT_NMI to other archs
e16bb1d: lockup_detector: Update some config
5e85391: x86, watchdog: Fix build error in hw_nmi.c
0167c78: watchdog: Export touch_softlockup_watchdog
19cc36c: lockup_detector: Fix forgotten config conversion
89d7ce2: lockup_detector: Make BOOTPARAM_SOFTLOCKUP_PANIC depend on LOCKUP_DETECTOR
d7c5473: lockup_detector: Separate touch_nmi_watchdog code path from touch_watchdog
10f9014: x86: Cleanup hw_nmi.c cruft
7cbb7e7: x86: Move trigger_all_cpu_backtrace to its own die_notifier
f69bcf6: lockup_detector: Remove nmi_watchdog.c file
2508ce1: lockup_detector: Remove old softlockup code
332fbdb: lockup_detector: Touch_softlockup cleanups and softlockup_tick removal
58687ac: lockup_detector: Combine nmi_watchdog and softlockup detector
5671a10: nmi_watchdog: Tell the world we're active
c99c30f: nmi_watchdog: Turn it off by default
47195d5: nmi_watchdog: Clean up various small details
2cc4452: nmi_watchdog: Fix undefined 'apic' build bug
96ca402: nmi_watchdog: Properly configure for software events
6081b6c: nmi_watchdog: support for oprofile
cf454ae: nmi_watchdog: Fallback to software events when no hardware pmu detected
504d7cf: nmi_watchdog: Compile and portability fixes
c3128fb: nmi_watchdog: Use a boolean config flag for compiling
8e7672c: nmi_watchdog: Only enable on x86 for now
84e478c: nmi_watchdog: Config option to enable new nmi_watchdog
1fb9d6a: nmi_watchdog: Add new, generic implementation, using perf events
e40b172: x86: Move notify_die from nmi.c to traps.c

Then those callbacks can be used to implement some 
minimal critical functionality: panic/print 
decisions, tty switching, etc.

The essence of the method is (see kernel/watchdog.c):

  event = perf_event_create_kernel_counter(
                   &wd_attr, hotcpu, -1, wd_overflow);

the wd_overflow() is the callback you get. It's 
called when the event triggers. You can put arbitrary 
functionality into that callback.

Doing it this way is basically a constant, gradual 
process of unifying our currently woefully 
inconsistent callbacks within the x86 platform and 
the core kernel, and collecting these events into the 
TRACE_EVENT and perf umbrella - without any loss in 
functionality.

You can still call back on those events and add 
arbitrary EDAC and RAS features on top of that. (if 
there's something you cannot do via that method, or 
if it feels clumsy please let us know and we'll 
fix/enhance it.)

The advantage of that approach is that almost as a 
side-effect we also gain an event described in a 
structured way - which other tools can (and do) make 
use of.

Another related development is the ongoing work to 
describe events in sysfs, not in debugfs. The current 
plans put them under special files:

    /sys/kernel/sched/events/wakeup/id
    /sys/kernel/sched/events/wakeup/format

    /sys/devices/system/cpu/events/cycles/id
    /sys/devices/system/cpu/events/instructions/id

    /sys/kernel/events/mce/mce_record/id
    /sys/kernel/events/mce/mce_record/format

The exact placement is not yet final - we could 
reasonably put the MCE events under 
/sys/devices/system/cpu/events/mce/ as well - and 
alias them to multiple places.

Likewise, memory controller events could show up 
under /sys/devices/system/node/events/ ?

All events could be found via /sys/class/events/ and 
could be enumerated from there by EDAC/RAS tools.

See the discussion and patch from Lin Ming that 
started this on lkml:

  [RFC][PATCH 3/9] perf: export registerred pmus via sysfs

Plus, mid-term/long-term we could also split EDAC/RAS 
functionality from tools/perf/ and put it into 
tools/ras/, tools/mce/ or tools/edac/, and librarize 
common functionality to share as much code as 
possible.

We dont 'have to' have a 'perf mce' sub-tool - that's 
just a convenient starting place for you i suspect.

Thanks,

	Ingo
