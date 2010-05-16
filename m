Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab0EPQvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 12:51:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42859 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab0EPQvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 12:51:11 -0400
Date: Sun, 16 May 2010 18:51:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>
Subject: Re: perf, ftrace and MCEs
Message-ID: <20100516165104.GA11947@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Lin Ming <ming.m.lin@intel.com>
References: <20100501181212.GA25352@liondog.tnic>
 <20100504113227.GA14067@elte.hu>
 <20100515134312.GA25375@liondog.tnic>
 <20100516112641.GA20248@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100516112641.GA20248@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sun, May 16, 2010 at 01:26:41PM +0200

Hi,

> > in trace_begin
> > mce__mce_record          6 00600.700632283        0 init                  mcgcap=262, mcgstatus=0, bank=4, status=15888347641659525651, addr=26682366720, misc=13837309867997528064, ip=0, cs=0, tsc=0, walltime=1273928155, cpu=6, cpuid=1052561, apicid=6, socketid=0, cpuvendor=2, decoded_err= Northbridge Error, node 1ECC/ChipKill ECC error.
> > CE err addr: 0x636649b00
> > CE page 0x636649, offset 0xb00, grain 0, syndrome 0x1fd, row 3, channel 0
> >  Transaction type: generic read(mem access), no t
> > in trace_end
> > 
> > which shows the signature of an ECC which I 
> > injected earlier over the EDAC sysfs interface. And 
> > yes, the decoded_err appears truncated so I'll have 
> > to think of a slicker way to collect that info.
> > 
> > Although they're pretty rough yet, I've attached 
> > the relevant patches so that one could get an 
> > impression of where we're moving here.
> > 
> > 0001-amd64_edac-Remove-polling-mechanism.patch 
> > removes the EDAC polling mechanism in favor of 
> > hooking into the machine_check_poll polling 
> > function using the atomic notifier which we already 
> > use for uncorrectable errors.
> > 
> > The other two
> > 
> > 0002-mce-trace-Add-decoded-string-to-mce_record-s-format.patch
> > 0003-edac-mce-Prepare-error-decoded-info.patch
> > 
> > add that decoded_err string. I'm open for better 
> > ideas here though.
> 
> Yes, this is exactly what i was thinking about.

The decoded string handling is still clumsy since it is of variable
length and I have to allocate a string of the maximal possible length of
any error for it to not get truncated.

We could avoid this by spitting error codes of fixed length, instead,
which the RAS daemon would map to strings in userspace but the coding
scheme would need some thinking so that it works adequately for all
possible error types.

Anyway, we can always improve this if needed and as we go...

> > Concerning the early MCE logging and reporting, I'm 
> > thinking of using the mce.c ring buffer temporarily 
> > until the ftrace buffer has been initialized and 
> > then copying all records into the last. We might do 
> > a more elegant solution in the future after all 
> > that bootmem churn has quieted down and allocate 
> > memory early for a dedicated MCE ring buffer or 
> > whatever.
> 
> Agreed.
> 
> There's overlap here with the boot tracer as well, 
> which we want to convert over to perf events as well.
> 
> That could be achieved via the concept of 'persistent 
> events', which are basically task-less events brought 
> active and attached to a buffer space to dump the 
> events to.

Yep, sounds neat.

> That buffer space could be initialized very early on.
> 
> > Wrt critical MCEs, I'm leaning towards bypassing 
> > perf/ftrace subsystem altogether in favor of 
> > executing the smallest amount of code possible 
> > like, for example, switching to a tty, dumping the 
> > decoded error and in certain cases not panicking 
> > but shutting down gracefully after a timeout. Of 
> > course, graceful shutdown is completely dependent 
> > on the type of hw failure and in some cases we 
> > can't do anything else but freeze in order to 
> > prevent faulty data propagation.
> 
> I agree that the critical functionality itself should 
> be implemented in the kernel - and not all routed 
> through a user-space component.
> 
> But please generate the callbacks via perf events, 
> like the new watchdog code does in -tip 
> (tip:perf/nmi):

[snip]

My only concern here is that going over the perf events and callbacks
adds unnecessary additional code when we're in emergency mode handling
an uncorrectable error. However, I don't know how much that code would
be and whether its overhead would be relevant or not...

> Then those callbacks can be used to implement some 
> minimal critical functionality: panic/print 
> decisions, tty switching, etc.
> 
> The essence of the method is (see kernel/watchdog.c):
> 
>   event = perf_event_create_kernel_counter(
>                    &wd_attr, hotcpu, -1, wd_overflow);
> 
> the wd_overflow() is the callback you get. It's 
> called when the event triggers. You can put arbitrary 
> functionality into that callback.

Correct me if I'm wrong but since the trace_mce_record() is a
tracepoint, we don't want to register callbacks over the perf_event*
interface but rather use the ftrace path, like Steven's example with
register_trace_sched_switch().

If we do it this way, there's no overhead at all and we add all
the needed functionality like tty switching and emergency shutdown
preparations to the proper path in the proper order - right after having
decoded the MCE and still in the NMI context of do_machine_check, i.e.
at the earliest possible moment and without wasting time.

And with tracepoints we still have the event unification/enumeration you
mention below so I think it can't get any better than that :).

> Doing it this way is basically a constant, gradual 
> process of unifying our currently woefully 
> inconsistent callbacks within the x86 platform and 
> the core kernel, and collecting these events into the 
> TRACE_EVENT and perf umbrella - without any loss in 
> functionality.
> 
> You can still call back on those events and add 
> arbitrary EDAC and RAS features on top of that. (if 
> there's something you cannot do via that method, or 
> if it feels clumsy please let us know and we'll 
> fix/enhance it.)
> 
> The advantage of that approach is that almost as a 
> side-effect we also gain an event described in a 
> structured way - which other tools can (and do) make 
> use of.

see above.

> Another related development is the ongoing work to 
> describe events in sysfs, not in debugfs. The current 
> plans put them under special files:
> 
>     /sys/kernel/sched/events/wakeup/id
>     /sys/kernel/sched/events/wakeup/format
> 
>     /sys/devices/system/cpu/events/cycles/id
>     /sys/devices/system/cpu/events/instructions/id
> 
>     /sys/kernel/events/mce/mce_record/id
>     /sys/kernel/events/mce/mce_record/format
> 
> The exact placement is not yet final - we could 
> reasonably put the MCE events under 
> /sys/devices/system/cpu/events/mce/ as well - and 
> alias them to multiple places.

Well, since MCEs are per CPU, the proper way to map those would be

/sys/devices/system/cpu/cpuX/events/mce/

With this, we could have the additional functionality to disable some
MCEs per CPU if it makes sense for certain cases...

Hmm?

> Likewise, memory controller events could show up 
> under /sys/devices/system/node/events/ ?
> 
> All events could be found via /sys/class/events/ and 
> could be enumerated from there by EDAC/RAS tools.
> 
> See the discussion and patch from Lin Ming that 
> started this on lkml:
> 
>   [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
> 
> Plus, mid-term/long-term we could also split EDAC/RAS 
> functionality from tools/perf/ and put it into 
> tools/ras/, tools/mce/ or tools/edac/, and librarize 
> common functionality to share as much code as 
> possible.

Well, both mce and edac are a subset of RAS so calling it perf/ras/ is
the most sensible way to go IMHO. Also, this is where the perf inject
can be reused since we can inject true hardware errors and not only
simulate them in software.

> We dont 'have to' have a 'perf mce' sub-tool - that's 
> just a convenient starting place for you i suspect.

ditto, 'perf ras' is what I'm thinking.

Thanks.

-- 
Regards/Gruss,
    Boris.
