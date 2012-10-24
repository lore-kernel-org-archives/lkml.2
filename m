Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934004Ab2JXGyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:54:53 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45946 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727Ab2JXGyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:54:49 -0400
X-AuditID: 9c930197-b7c4aae000004160-73-508790b6f7b5
From: Namhyung Kim <namhyung@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-man@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>,
        Stephane Eranian <eranian@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [RFC] perf: proposed perf_event_open() manpage
References: <alpine.DEB.2.02.1210221623340.19390@pianoman.cluster.toy>
	<alpine.DEB.2.02.1210221629560.29528@vincent-weaver-1.um.maine.edu>
	<CAKgNAkjKFiu2CPxq_eT5C_a2H0WKT_u_jX940=2xS9Smfkmgqg@mail.gmail.com>
	<alpine.DEB.2.02.1210222325200.23913@atom-power>
	<CAKgNAkjW5tp+f7Ai3FMtWcbUWhztoROCQ1=WM=3okFQLCDY3+Q@mail.gmail.com>
	<alpine.DEB.2.02.1210231127550.24986@vincent-weaver-1.um.maine.edu>
Date: Wed, 24 Oct 2012 15:54:46 +0900
In-Reply-To: <alpine.DEB.2.02.1210231127550.24986@vincent-weaver-1.um.maine.edu>
	(Vince Weaver's message of "Tue, 23 Oct 2012 11:35:13 -0400 (EDT)")
Message-ID: <878vaw9x6x.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vince,

Great work!

On Tue, 23 Oct 2012 11:35:13 -0400 (EDT), Vince Weaver wrote:
> Hello
>
> attached is a proposed manpage for the perf_event_open() system call.
>
> I'd appreciate any review or comments, especially for the parts marked
> as FIXME or "[To be documented]"
>
> This system call has a complicated interface and I'm sure I've missed
> or glossed over various important features, so your feedback is needed and 
> appreciated.
>
> The eventual goal is to have this included with the Linux man-pages 
> project.
[snip]
> .BI "int perf_event_open(struct perf_event_attr *" hw_event ,

hw_event?  Looks unusual.. how about 'attr'?


> .BI "                    pid_t " pid ", int " cpu ", int " group_fd ,
> .BI "                    unsigned long " flags  );
> .fi
[snip]
> .SS Arguments
> .P
> The argument
> .I pid
> allows events to be attached to processes in various ways.
> If
> .I pid
> is 0, measurements happen on the current task, if
> .I pid
> is greater than 0, the process indicated by
> .I pid
> is measured, and if
> .I pid
> is less than 0, all processes are counted.

Is that true?  Shouldn't pid be -1?


>
> The
> .I cpu
> argument allows measurements to be specific to a CPU.
> If
> .I cpu
> is greater than or equal to 0,
> measurements are restricted to the specified CPU;
> if
> .I cpu
> is \-1, the events are measured on all CPUs.
> .P
> Note that the combination of
> .IR pid " == \-1"
> and
> .IR cpu " == \-1"
> is not valid.
> .P
> A
> .IR pid " > 0"

s/>/>=/ ?


> and
> .IR cpu " == \-1"
> setting measures per-process and follows that process to whatever CPU the
> process gets scheduled to.
> Per-process events can be created by any user.
> .P
> A
> .IR pid " == \-1"
> and
> .IR cpu " >= 0"
> setting is per-CPU and measures all processes on the specified CPU.
> Per-CPU events need the
> .B CAP_SYS_ADMIN
> capability.

Or value of perf_event_paranoid is less than 1.


> .TP
> .RB "dynamic PMU"
> Since Linux 2.6.39,
> .BR perf_event_open()
> can support multiple PMUs.
> To enable this, a value exported by the kernel can be used in the
> .I type
> field to indicate which PMU to use.
> The value to use can be found in the sysfs filesystem:
> there is a subdirectory per PMU instance under
> .IR /sys/devices .

/sys/bus/event_source/devices will be the right place.


> In each sub-directory there is a
> .I type
> file whose content is an integer that can be used in the
> .I type
> field.
> For instance,
> .I /sys/devices/cpu/type

/sys/bus/event_source/devices/cpu/type


> contains the value for the core CPU PMU, which is usually 4.
> .RE
>
[snip]
> .TP
> .IR sample_period ", " sample_freq
> A "sampling" counter is one that generates an interrupt
> every N events, where N is given by
> .IR sample_period .
> A sampling counter has
> .IR sample_period " > 0."

How about adding this here:

"When an (overflow) interrupt generated, requested data (sample) would
be recorded."

> The
> .I sample_type
> field controls what data is recorded on each interrupt.
>
> .I sample_freq
> can be used if you wish to use frequency rather than period.
> In this case you set the
> .I freq
> flag.
> The kernel will adjust the sampling period
> to try and achieve the desired rate.
> The rate of adjustment is a
> timer tick.

Is that true?  I thought it'd be adjusted whenever overflow occures.


>
>
> .TP
> .I "sample_type"
> The various bits in this field specify which values to include
> in the overflow packets.

I guess the overflow packets here means samples.  It'd be better if we
use a consistent word for specifying a thing.


> They will be recorded in a ring-buffer,
> which is available to user-space using
> .BR mmap (2).
> The order in which the values are saved in the
> overflow packets as documented in the MMAP Layout subsection below;
> it is not the
> .I "enum perf_event_sample_format"
> order.
> .RS
> .TP
> .B PERF_SAMPLE_IP
> instruction pointer
> .TP
> .B PERF_SAMPLE_TID
> thread id
> .TP
> .B PERF_SAMPLE_TIME
> time
> .TP
> .B PERF_SAMPLE_ADDR
> address
> .TP
> .B PERF_SAMPLE_READ
> [To be documented]

It's for an event group to sample leader only.  Values of other members
will be read when an interrupt occurred on the leader.

Jiri is working on it.

> .TP
> .B PERF_SAMPLE_CALLCHAIN
> [To be documented]

callchain (or stack backtrace)

> .TP
> .B PERF_SAMPLE_ID
> [To be documented]

unique(?) id for the opened event.

> .TP
> .B PERF_SAMPLE_CPU
> [To be documented]

cpu number

> .TP
> .B PERF_SAMPLE_PERIOD
> [To be documented]

event count

> .TP
> .B PERF_SAMPLE_STREAM_ID
> [To be documented]
> .TP
> .B PERF_SAMPLE_RAW
> [To be documented]

additional data - usually for tracepoint events

> .TP
> .BR PERF_SAMPLE_BRANCH_STACK " (Since Linux 3.4)"
> [To be documented]

requested branch stack - only supported on intel machines which has LBR
feature(?).  See branch_sample_type.

> .RE
[snip]
> .SS /proc/sys/kernel/perf_event_paranoid
>
> The
> .I /proc/sys/kernel/perf_event_paranoid
> file can be set to restrict access to the performance counters.
> 2
> means no measurements allowed,

This is not true.  It only allows user mode measurements.

$ cat /proc/sys/kernel/perf_event_paranoid 
2

$ perf stat usleep 1
  Error: You may not have permission to collect stats.
	 Consider tweaking /proc/sys/kernel/perf_event_paranoid or running as root.
Not all events could be opened.

$ perf stat -e cycles:u usleep 1

 Performance counter stats for 'usleep 1':

           253,055 cycles:u                  #    0.000 GHz                    

       0.001988538 seconds time elapsed


> 1
> means normal counter access,

This includes kernel mode measurements.

> 0
> means you can access CPU-specific data, and

But cannot access raw tracepoint samples.

> \-1
> means no restrictions.


Thanks,
Namhyung
