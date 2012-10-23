Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab2JWPeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 11:34:23 -0400
Received: from mail-ye0-f174.google.com ([209.85.213.174]:64731 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975Ab2JWPeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 11:34:21 -0400
Date: Tue, 23 Oct 2012 11:35:13 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-man@vger.kernel.org
cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Stephane Eranian <eranian@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [RFC] perf: proposed perf_event_open() manpage
In-Reply-To: <CAKgNAkjW5tp+f7Ai3FMtWcbUWhztoROCQ1=WM=3okFQLCDY3+Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1210231127550.24986@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1210221623340.19390@pianoman.cluster.toy> <alpine.DEB.2.02.1210221629560.29528@vincent-weaver-1.um.maine.edu> <CAKgNAkjKFiu2CPxq_eT5C_a2H0WKT_u_jX940=2xS9Smfkmgqg@mail.gmail.com> <alpine.DEB.2.02.1210222325200.23913@atom-power>
 <CAKgNAkjW5tp+f7Ai3FMtWcbUWhztoROCQ1=WM=3okFQLCDY3+Q@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-940803195-1351006515=:24986"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-940803195-1351006515=:24986
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hello

attached is a proposed manpage for the perf_event_open() system call.

I'd appreciate any review or comments, especially for the parts marked
as FIXME or "[To be documented]"

This system call has a complicated interface and I'm sure I've missed
or glossed over various important features, so your feedback is needed and 
appreciated.

The eventual goal is to have this included with the Linux man-pages 
project.

Thanks!

Vince Weaver
vincent.weaver@maine.edu


.\" Hey Emacs! This file is -*- nroff -*- source.
.\"
.\" Copyright (c) 2012, Vincent Weaver
.\"
.\" This is free documentation; you can redistribute it and/or
.\" modify it under the terms of the GNU General Public License as
.\" published by the Free Software Foundation; either version 2 of
.\" the License, or (at your option) any later version.
.\"
.\" The GNU General Public License's references to "object code"
.\" and "executables" are to be interpreted as the output of any
.\" document formatting or typesetting system, including
.\" intermediate and printed output.
.\"
.\" This manual is distributed in the hope that it will be useful,
.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
.\" GNU General Public License for more details.
.\"
.\" You should have received a copy of the GNU General Public
.\" License along with this manual; if not, see
.\" <http://www.gnu.org/licenses/>.
.\"
.\" This document is based on the perf_event.h header file, the
.\" tools/perf/design.txt file, and a lot of bitter experience.
.\"
.TH PERF_EVENT_OPEN 2 2012-10-23 "Linux" "Linux Programmer's Manual"
.SH NAME
perf_event_open \- set up performance monitoring
.SH SYNOPSIS
.nf
.B #include <linux/perf_event.h>
.B #include <linux/hw_breakpoint.h>
.sp
.BI "int perf_event_open(struct perf_event_attr *" hw_event ,
.BI "                    pid_t " pid ", int " cpu ", int " group_fd ,
.BI "                    unsigned long " flags  );
.fi

.IR Note :
There is no glibc wrapper for this system call; see NOTES.
.SH DESCRIPTION
Given a list of parameters,
.BR perf_event_open ()
returns a file descriptor, for use in subsequent system calls
.RB ( read "(2), " mmap "(2), " prctl "(2), " fcntl "(2), etc.)."
.PP
A call to
.BR perf_event_open ()
creates a file descriptor that allows measuring performance
information.
Each file descriptor corresponds to one
event that is measured; these can be grouped together
to measure multiple events simultaneously.
.PP
Events can be enabled and disabled in two ways: via
.BR ioctl (2)
and via
.BR prctl (2) .
When an event is disabled it does not count or generate overflows but does
continue to exist and maintain its count value.
Events come in two flavors: counting and sampled.
A
.I counting
event is one that is used for counting the aggregate number of events
that occur.
In general, counting event results are gathered with a
.BR read (2)
call.
A
.I sampling
event periodically writes measurements to a buffer that can then
be accessed via
.BR  mmap (2) .
.SS Arguments
.P
The argument
.I pid
allows events to be attached to processes in various ways.
If
.I pid
is 0, measurements happen on the current task, if
.I pid
is greater than 0, the process indicated by
.I pid
is measured, and if
.I pid
is less than 0, all processes are counted.

The
.I cpu
argument allows measurements to be specific to a CPU.
If
.I cpu
is greater than or equal to 0,
measurements are restricted to the specified CPU;
if
.I cpu
is \-1, the events are measured on all CPUs.
.P
Note that the combination of
.IR pid " == \-1"
and
.IR cpu " == \-1"
is not valid.
.P
A
.IR pid " > 0"
and
.IR cpu " == \-1"
setting measures per-process and follows that process to whatever CPU the
process gets scheduled to.
Per-process events can be created by any user.
.P
A
.IR pid " == \-1"
and
.IR cpu " >= 0"
setting is per-CPU and measures all processes on the specified CPU.
Per-CPU events need the
.B CAP_SYS_ADMIN
capability.
.P
The
.I group_fd
argument allows counter groups to be set up.
A counter group has one counter which is the group leader.
The leader is created first, with
.IR group_fd " = \-1"
in the
.BR perf_event_open ()
call that creates it.
The rest of the group members are created subsequently, with
.IR group_fd
giving the fd of the group leader.
(A single counter on its own is created with
.IR group_fd " = \-1"
and is considered to be a group with only 1 member.)
.P
A counter group is scheduled onto the CPU as a unit: it will only
be put onto the CPU if all of the counters in the group can be put onto
the CPU.
This means that the values of the member counters can be
meaningfully compared, added, divided (to get ratios), etc., with each
other, since they have counted events for the same set of executed
instructions.
.P
The
.I flags
argument takes one of the following values:
.TP
.BR PERF_FLAG_FD_NO_GROUP
.\" FIXME The following sentence is unclear
This flag allows creating an event as part of an event group but
having no group leader.
It is unclear why this is useful.
.\" FIXME So, why is it useful?
.TP
.BR PERF_FLAG_FD_OUTPUT
This flag re-routes the output from an event to the group leader.
.TP
.BR PERF_FLAG_PID_CGROUP " (Since Linux 2.6.39)."
This flag activates per-container system-wide monitoring.
A container
is an abstraction that isolates a set of resources for finer grain
control (CPUs, memory, etc...).
In this mode, the event is measured
only if the thread running on the monitored CPU belongs to the designated
container (cgroup).
The cgroup is identified by passing a file descriptor
opened on its directory in the cgroupfs filesystem.
For instance, if the
cgroup to monitor is called
.IR test ,
then a file descriptor opened on
.I /dev/cgroup/test
(assuming cgroupfs is mounted on
.IR /dev/cgroup )
must be passed as the
.I pid
parameter.
cgroup monitoring is only available
for system-wide events and may therefore require extra permissions.
.P
The
.I perf_event_attr
structure is what is passed into the
.BR perf_event_open ()
syscall.
It is large and has a complicated set of dependent fields.

.in +4n
.nf
struct perf_event_attr {
    __u32     type;         /* Type of event */
    __u32     size;         /* Size of attribute structure */
    __u64     config;       /* Type-specific configuration */

    union {
        __u64 sample_period;    /* Period of sampling */
        __u64 sample_freq;      /* Frequency of sampling */
    };

    __u64     sample_type;  /* Specifies values included in sample */
    __u64     read_format;  /* Specifies values returned in read */

    __u64     disabled       : 1,   /* off by default         */
              inherit        : 1,   /* children inherit it    */
              pinned         : 1,   /* must always be on PMU  */
              exclusive      : 1,   /* only group on PMU      */
              exclude_user   : 1,   /* don't count user       */
              exclude_kernel : 1,   /* don't count kernel     */
              exclude_hv     : 1,   /* don't count hypervisor */
              exclude_idle   : 1,   /* don't count when idle  */
              mmap           : 1,   /* include mmap data      */
              comm           : 1,   /* include comm data      */
              freq           : 1,   /* use freq, not period   */
              inherit_stat   : 1,   /* per task counts        */
              enable_on_exec : 1,   /* next exec enables      */
              task           : 1,   /* trace fork/exit        */
              watermark      : 1,   /* wakeup_watermark       */
              precise_ip     : 2,   /* skid constraint        */
              mmap_data      : 1,   /* non-exec mmap data     */
              sample_id_all  : 1,   /* sample_type all events */
              exclude_host   : 1,   /* don't count in host    */
              exclude_guest  : 1,   /* don't count in guest   */
              __reserved_1   : 43;

    union {
        __u32 wakeup_events;    /* wakeup every n events */
        __u32 wakeup_watermark; /* bytes before wakeup   */
    };

    __u32     bp_type;          /* breakpoint type */

    union {
        __u64 bp_addr;          /* breakpoint address */
        __u64 config1;          /* extension of config */
    };

    union {
        __u64 bp_len;           /* breakpoint length */
        __u64 config2;          /* extension of config1 */
    };
    __u64     branch_sample_type;   /* enum branch_sample_type */
};
.fi
.in

The fields of the
.I perf_event_attr
structure are described in more detail below.

.TP
.I type
This field specifies the overall event type.
It has one of the following values:
.RS
.TP
.B PERF_TYPE_HARDWARE
This indicates one of the "generalized" hardware events provided
by the kernel.
See the
.I config
field definition for more details.
.TP
.B PERF_TYPE_SOFTWARE
This indicates one of the software-defined events provided by the kernel
(even if no hardware support is available).
.TP
.B PERF_TYPE_TRACEPOINT
This indicates a tracepoint
provided by the kernel tracepoint infrastructure.
.TP
.B PERF_TYPE_HW_CACHE
This indicates a hardware cache event.
This has a special encoding, described in the
.I config
field definition.
.TP
.B PERF_TYPE_RAW
This indicates a "raw" implementation-specific event in the
.IR config " field."
.TP
.BR PERF_TYPE_BREAKPOINT " (Since Linux 2.6.33)"
This indicates a hardware breakpoint as provided by the CPU.
Breakpoints can be read/write accesses to an address as well as
execution of an instruction address.
.TP
.RB "dynamic PMU"
Since Linux 2.6.39,
.BR perf_event_open()
can support multiple PMUs.
To enable this, a value exported by the kernel can be used in the
.I type
field to indicate which PMU to use.
The value to use can be found in the sysfs filesystem:
there is a subdirectory per PMU instance under
.IR /sys/devices .
In each sub-directory there is a
.I type
file whose content is an integer that can be used in the
.I type
field.
For instance,
.I /sys/devices/cpu/type
contains the value for the core CPU PMU, which is usually 4.
.RE

.TP
.I "size"
The size of the
.I perf_event_attr
structure for forward/backward compatibility.
Set this using
.I sizeof(struct perf_event_attr)
to allow the kernel to see
the struct size at the time of compilation.

The related define
.B PERF_ATTR_SIZE_VER0
is set to 64; this was the size of the first published struct.
.B PERF_ATTR_SIZE_VER1
is 72, corresponding to the addition of breakpoints in Linux 2.6.33.
.B PERF_ATTR_SIZE_VER2
is 80 corresponding to the addition of branch sampling in Linux 3.4.

.TP
.I "config"
This specifies which event you want, in conjunction with
the
.I type
field.
The
.IR config1 " and " config2
fields are also taken into account in cases where 64 bits is not
enough to fully specify the event.
The encoding of these fields are event dependent.

The most significant bit (bit 63) of
.I config
signifies CPU-specific (raw) counter configuration data;
if the most significant bit is unset, the next 7 bits are an event
type and the rest of the bits are the event identifier.

There are various ways to set the
.I config
field that are dependent on the value of the previously
described
.I type
field.
What follows are various possible settings for
.I config
separated out by
.IR type .

If
.I type
is
.BR PERF_TYPE_HARDWARE ,
we are measuring one of the generalized hardware CPU events.
Not all of these are available on all platforms.
Set
.I config
to one of the following:
.RS 12
.TP
.B PERF_COUNT_HW_CPU_CYCLES
Total cycles.
Be wary of what happens during CPU frequency scaling
.TP
.B PERF_COUNT_HW_INSTRUCTIONS
Retired instructions.
Be careful, these can be affected by various
issues, most notably hardware interrupt counts
.TP
.B PERF_COUNT_HW_CACHE_REFERENCES
Cache accesses.
Usually this indicates Last Level Cache accesses but this may
vary depending on your CPU.
This may include prefetches and coherency messages; again this
depends on the design of your CPU.
.TP
.B PERF_COUNT_HW_CACHE_MISSES
Cache misses.
Usually this indicates Last Level Cache misses; this is intended to be
used in conjunction with the
.B PERF_COUNT_HW_CACHE_REFERENCES
event to calculate cache miss rates.
.TP
.B PERF_COUNT_HW_BRANCH_INSTRUCTIONS
Retired branch instructions.
Prior to Linux 2.6.34, this used
the wrong event on AMD processors.
.TP
.B PERF_COUNT_HW_BRANCH_MISSES
Mispredicted branch instructions.
.TP
.B PERF_COUNT_HW_BUS_CYCLES
Bus cycles, which can be different from total cycles.
.TP
.BR PERF_COUNT_HW_STALLED_CYCLES_FRONTEND " (Since Linux 3.0)"
Stalled cycles during issue.
.TP
.BR PERF_COUNT_HW_STALLED_CYCLES_BACKEND  " (Since Linux 3.0)"
Stalled cycles during retirement.
.TP
.BR PERF_COUNT_HW_REF_CPU_CYCLES  " (Since Linux 3.3)"
Total cycles; not affected by CPU frequency scaling.
.RE
.IP
If
.I type
is
.BR PERF_TYPE_SOFTWARE ,
we are measuring software events provided by the kernel.
Set
.I config
to one of the following:
.RS 12
.TP
.B PERF_COUNT_SW_CPU_CLOCK
This reports the CPU clock, a high-resolution per-CPU timer.
.TP
.B PERF_COUNT_SW_TASK_CLOCK
This reports a clock count specific to the task that is running.
.TP
.B PERF_COUNT_SW_PAGE_FAULTS
This reports the number of page faults.
.TP
.B PERF_COUNT_SW_CONTEXT_SWITCHES
This counts context switches.
Until Linux 2.6.34, these were all reported as user-space
events, after that they are reported as happening in the kernel.
.TP
.B PERF_COUNT_SW_CPU_MIGRATIONS
This reports the number of times the process
has migrated to a new CPU.
.TP
.B PERF_COUNT_SW_PAGE_FAULTS_MIN
This counts the number of minor page faults.
These did not require disk I/O to handle.
.TP
.B PERF_COUNT_SW_PAGE_FAULTS_MAJ
This counts the number of major page faults.
These required disk I/O to handle.
.TP
.BR PERF_COUNT_SW_ALIGNMENT_FAULTS " (Since Linux 2.6.33)"
This counts the number of alignment faults.
These happen when unaligned memory accesses happen; the kernel
can handle these but it reduces performance.
This only happens on some architectures (never on x86).
.TP
.BR PERF_COUNT_SW_EMULATION_FAULTS " (Since Linux 2.6.33)"
This counts the number of emulation faults.
The kernel sometimes traps on unimplemented instructions
and emulates them for userspace.
This can negatively impact performance.
.RE
.RE


.RS
If
.I type
is
.BR PERF_TYPE_TRACEPOINT ,
then we are measuring kernel tracepoints.
The value to use in
.I config
can be obtained from under debugfs
.I tracing/events/*/*/id
if ftrace is enabled in the kernel.

.RE

.RS
If
.I type
is
.BR PERF_TYPE_HW_CACHE ,
then we are measuring a hardware CPU cache event.
To calculate the appropriate
.I config
value use the following equation:
.RS 4
.nf

    (perf_hw_cache_id) | (perf_hw_cache_op_id << 8) |
    (perf_hw_cache_op_result_id << 16)
.fi
.P
where
.I perf_hw_cache_id
is one of:
.RS
.TP
.B PERF_COUNT_HW_CACHE_L1D
for measuring Level 1 Data Cache
.TP
.B PERF_COUNT_HW_CACHE_L1I
for measuring Level 1 Instruction Cache
.TP
.B PERF_COUNT_HW_CACHE_LL
for measuring Last-Level Cache
.TP
.B PERF_COUNT_HW_CACHE_DTLB
for measuring the Data TLB
.TP
.B PERF_COUNT_HW_CACHE_ITLB
for measuring the Instruction TLB
.TP
.B PERF_COUNT_HW_CACHE_BPU
for measuring the branch prediction unit
.TP
.BR PERF_COUNT_HW_CACHE_NODE " (Since Linux 3.0)"
for measuring local memory accesses
.RE

.P
and
.I perf_hw_cache_op_id
is one of
.RS
.TP
.B PERF_COUNT_HW_CACHE_OP_READ
for read accesses
.TP
.B PERF_COUNT_HW_CACHE_OP_WRITE
for write accesses
.TP
.B PERF_COUNT_HW_CACHE_OP_PREFETCH
for prefetch accesses
.RE

.P
and
.I perf_hw_cache_op_result_id
is one of
.RS
.TP
.B PERF_COUNT_HW_CACHE_RESULT_ACCESS
to measure accesses
.TP
.B PERF_COUNT_HW_CACHE_RESULT_MISS
to measure misses
.RE
.RE

If
.I type
is
.BR PERF_TYPE_RAW ,
then a custom "raw"
.I config
value is needed.
Most CPUs support events that are not covered by the "generalized" events.
These are implementation defined; see your CPU manual (for example
the Intel Volume 3B documentation or the AMD BIOS and Kernel Developer
Guide).
The libpfm4 library can be used to translate from the name in the
architectural manuals to the raw hex value
.BR perf_event_open ()
expects in this field.

If
.I type
is
.BR PERF_TYPE_BREAKPOINT ,
then leave
.I config
set to zero.
Its parameters are set in other places.
.RE
.TP
.IR sample_period ", " sample_freq
A "sampling" counter is one that generates an interrupt
every N events, where N is given by
.IR sample_period .
A sampling counter has
.IR sample_period " > 0."
The
.I sample_type
field controls what data is recorded on each interrupt.

.I sample_freq
can be used if you wish to use frequency rather than period.
In this case you set the
.I freq
flag.
The kernel will adjust the sampling period
to try and achieve the desired rate.
The rate of adjustment is a
timer tick.


.TP
.I "sample_type"
The various bits in this field specify which values to include
in the overflow packets.
They will be recorded in a ring-buffer,
which is available to user-space using
.BR mmap (2).
The order in which the values are saved in the
overflow packets as documented in the MMAP Layout subsection below;
it is not the
.I "enum perf_event_sample_format"
order.
.RS
.TP
.B PERF_SAMPLE_IP
instruction pointer
.TP
.B PERF_SAMPLE_TID
thread id
.TP
.B PERF_SAMPLE_TIME
time
.TP
.B PERF_SAMPLE_ADDR
address
.TP
.B PERF_SAMPLE_READ
[To be documented]
.TP
.B PERF_SAMPLE_CALLCHAIN
[To be documented]
.TP
.B PERF_SAMPLE_ID
[To be documented]
.TP
.B PERF_SAMPLE_CPU
[To be documented]
.TP
.B PERF_SAMPLE_PERIOD
[To be documented]
.TP
.B PERF_SAMPLE_STREAM_ID
[To be documented]
.TP
.B PERF_SAMPLE_RAW
[To be documented]
.TP
.BR PERF_SAMPLE_BRANCH_STACK " (Since Linux 3.4)"
[To be documented]
.RE

.TP
.IR "read_format"
This field specifies the format of the data returned by
.BR read (2)
on a
.BR perf_event_open()
file descriptor.
.RS
.TP
.B PERF_FORMAT_TOTAL_TIME_ENABLED
Adds the 64-bit "time_enabled" field.
This can be used to calculate estimated totals if
the PMU is overcommitted and multiplexing is happening.
.TP
.B PERF_FORMAT_TOTAL_TIME_RUNNING
Adds the 64-bit "time_running" field.
This can be used to calculate estimated totals if
the PMU is overcommitted and  multiplexing is happening.
.TP
.B PERF_FORMAT_ID
Adds a 64-bit unique value that corresponds to the event-group.
.TP
.B PERF_FORMAT_GROUP
Allows all counter values in an event-group to be read with one read.
.RE

.TP
.IR "disabled"
The
.I disabled
bit specifies whether the counter starts out disabled or enabled.
If disabled, the event can later be enabled by
.BR ioctl (2),
.BR prctl (2),
or
.IR enable_on_exec .

.TP
.IR "inherit"
The
.I inherit
bit specifies that this counter should count events of child
tasks as well as the task specified.
This only applies to new children, not to any existing children at
the time the counter is created (nor to any new children of
existing children).

Inherit does not work for some combinations of
.IR read_format s,
such as
.BR PERF_FORMAT_GROUP .

.TP
.IR "pinned"
The
.I pinned
bit specifies that the counter should always be on the CPU if at all
possible.
It only applies to hardware counters and only to group leaders.
If a pinned counter cannot be put onto the CPU (e.g., because there are
not enough hardware counters or because of a conflict with some other
event), then the counter goes into an 'error' state, where reads
return end-of-file (i.e.,
.BR read (2)
returns 0) until the counter is subsequently enabled or disabled.

.TP
.IR "exclusive"
The
.I exclusive
bit specifies that when this counter's group is on the CPU,
it should be the only group using the CPU's counters.
In the future this may allow monitoring programs to
support PMU features that need to run alone so that they do not
disrupt other hardware counters.

.TP
.IR "exclude_user"
If this bit is set, the count excludes events that happen in user-space.

.TP
.IR "exclude_kernel"
If this bit is set, the count excludes events that happen in kernel-space.

.TP
.IR "exclude_hv"
If this bit is set, the count excludes events that happen in the
hypervisor.
This is mainly for PMUs that have built-in support for handling this
(such as POWER).
Extra support is needed for handling hypervisor measurements on most
machines.

.TP
.IR "exclude_idle"
If set, don't count when the CPU is idle.

.TP
.IR "mmap"
The
.I mmap
bit enables recording of extra information to a
mmap'd ring-buffer.
This is
described below in subsection MMAP Layout.

.TP
.IR "comm"
The
.I comm
bit enables tracking of process command name as modified by the
.IR exec (2)
and
.IR prctl (PR_SET_NAME)
system calls.
Unfortunately for tools,
there is no way to distinguish one system call versus the other.

.TP
.IR "freq"
If this bit is set, then
.I sample_frequency
not
.I sample_period
is used when setting up the sampling interval.

.TP
.IR "inherit_stat"
This bit enables saving of event counts on context switch for
inherited tasks.
This is only meaningful if the
.I inherit
field is set.

.TP
.IR "enable_on_exec"
If this bit is set, a counter is automatically
enabled after a call to
.BR exec (2).

.TP
.IR "task"
If this bit is set, then
fork/exit notifications are included in the ring buffer.

.TP
.IR "watermark"
If set, have a sampling interrupt happen when we cross the
wakeup_watermark boundary.

.TP
.IR "precise_ip" " (Since Linux 2.6.35)"
This controls the amount of skid.
Skid is how many instructions
execute between an event of interest happening and the kernel
being able to stop and record the event.
Smaller skid is
better and allows more accurate reporting of which events
correspond to which instructions, but hardware is often limited
with how small this can be.

The values of this are the following:
.RS
.TP
0 -
.B SAMPLE_IP
can have arbitrary skid
.TP
1 -
.B SAMPLE_IP
must have constant skid
.TP
2 -
.B SAMPLE_IP
requested to have 0 skid
.TP
3 -
.B SAMPLE_IP
must have 0 skid.
See also
.BR PERF_RECORD_MISC_EXACT_IP .
.RE

.TP
.IR "mmap_data" " (Since Linux 2.6.36)"
Include mmap events in the ring_buffer.

.TP
.IR "sample_id_all" " (Since Linux 2.6.38)"
If set, then all sample ID info (TID, TIME, ID, CPU, STREAM_ID)
will be provided.

.TP
.IR "exclude_host" " (Since Linux 3.2)"
Do not measure time spent in VM host

.TP
.IR "exclude_guest" " (Since Linux 3.2)"
Do not measure time spent in VM guest


.TP
.IR "wakeup_events" ", " "wakeup_watermark"
This union sets how many events
.RI ( wakeup_events )
or bytes
.RI ( wakeup_watermark )
happen before an overflow signal happens.
Which one is used is selected by the
.I watermark
bitflag.

.TP
.IR "bp_type" " (Since Linux 2.6.33)"
This chooses the breakpoint type.
It is one of:
.RS
.TP
.BR HW_BREAKPOINT_EMPTY
no breakpoint
.TP
.BR HW_BREAKPOINT_R
count when we read the memory location
.TP
.BR HW_BREAKPOINT_W
count when we write the memory location
.TP
.BR HW_BREAKPOINT_RW
count when we read or write the memory location
.TP
.BR HW_BREAKPOINT_X
count when we execute code at the memory location

.LP
The values can be combined via a bitwsie or, but the
combination of
.B HW_BREAKPOINT_R
or
.B HW_BREAKPOINT_W
with
.B HW_BREAKPOINT_X
is not allowed.
.RE

.TP
.IR "bp_addr" " (Since Linux 2.6.33)"
.I bp_addr
address of the breakpoint.
For execution breakpoints this is the memory address of the instruction
of interest; for read and write breakpoints it is the memory address
of the memory location of interest.

.TP
.IR "config1" " (Since Linux 2.6.39)"
.I config1
is used for setting events that need an extra register or otherwise
do not fit in the regular config field.
Raw OFFCORE_EVENTS on Nehalem/Westmere/SandyBridge use this field
on 3.3 and later kernels.

.TP
.IR "bp_len" " (Since Linux 2.6.33)"
.I bp_len
is the length of the breakpoint being measured if
.I type
is
.BR PERF_TYPE_BREAKPOINT .
Options are
.BR HW_BREAKPOINT_LEN_1 ,
.BR HW_BREAKPOINT_LEN_2 ,
.BR HW_BREAKPOINT_LEN_4 ,
.BR HW_BREAKPOINT_LEN_8 .
For an execution breakpoint, set this to
.IR sizeof(long) .

.TP
.IR "config2" " (Since Linux 2.6.39)"

.I config2
is a further extension of the
.I config1
field.

.TP
.IR "branch_sample_type" " (Since Linux 3.4)"
This is used with the CPUs hardware branch sampling, if available.
It can have one of the following values:
.RS
.TP
.B PERF_SAMPLE_BRANCH_USER
Branch target is in user space
.TP
.B PERF_SAMPLE_BRANCH_KERNEL
Branch target is in kernel space
.TP
.B PERF_SAMPLE_BRANCH_HV
Branch target is in hypervisor
.TP
.B PERF_SAMPLE_BRANCH_ANY
Any branch type.
.TP
.B PERF_SAMPLE_BRANCH_ANY_CALL
Any call branch
.TP
.B PERF_SAMPLE_BRANCH_ANY_RETURN
Any return branch
.TP
.BR PERF_SAMPLE_BRANCH_IND_CALL
Indirect calls
.TP
.BR PERF_SAMPLE_BRANCH_PLM_ALL
User, kernel, and hv
.RE


.SS "MMAP Layout"

When using
.BR perf_event_open()
in sampled mode, asynchronous events
(like counter overflow or
.B PROT_EXEC
mmap tracking)
are logged into a ring-buffer.
This ring-buffer is created and accessed through
.BR mmap (2).

The mmap size should be 1+2^n pages, where the first page is a
metadata page
.IR ( "struct perf_event_mmap_page" )
that contains various
bits of information such as where the ring-buffer head is.

Before kernel 2.6.39, there is a bug that means you must allocate a mmap
ring buffer when sampling even if you do not plan to access it.

The structure of the first metadata mmap page is as follows:

.in +4n
.nf
struct perf_event_mmap_page {
    __u32 version;          /* version number of this structure   */
    __u32 compat_version;   /* lowest version this is compat with */
    __u32 lock;             /* seqlock for synchronization        */
    __u32 index;            /* hardware counter identifier        */
    __s64 offset;           /* add to hardware counter value      */
    __u64 time_enabled;     /* time event active                  */
    __u64 time_running;     /* time event on CPU                  */
    union {
        __u64   capabilities;
        __u64   cap_usr_time  : 1,
                cap_usr_rdpmc : 1,
    };
    __u16   pmc_width;
    __u16   time_shift;
    __u32   time_mult;
    __u64   time_offset;
    __u64   __reserved[120];   /* Pad to 1k                */
    __u64   data_head;         /* head in the data section */
    __u64   data_tail;         /* user-space written tail  */
}
.fi
.in



The following looks at the fields in the
.I perf_event_mmap_page
structure in more detail.

.RS

.TP
.I version
Version number of this structure.

.TP
.I compat_version
The lowest version this is compatible with.

.TP
.I lock
A seqlock for synchronization.

.TP
.I index;
A unique hardware counter identifier.

.TP
.I offset
.\" FIXME clarify
Add this to hardware counter value??

.TP
.I time_enabled
Time the event was active.

.TP
.I time_running
Time the event was running.

.TP
.I cap_usr_time
User time capability

.TP
.I cap_usr_rdpmc
If the hardware supports user-space read of performance counters
without syscall (this is the "rdpmc" instruction on x86), then
the following code can be used to do a read:

.in +4n
.nf
u32 seq, time_mult, time_shift, idx, width;
u64 count, enabled, running;
u64 cyc, time_offset;
s64 pmc = 0;

do {
    seq = pc\->lock;
    barrier();
    enabled = pc\->time_enabled;
    running = pc\->time_running;

    if (pc\->cap_usr_time && enabled != running) {
        cyc = rdtsc();
        time_offset = pc\->time_offset;
        time_mult   = pc\->time_mult;
        time_shift  = pc\->time_shift;
    }

    idx = pc\->index;
    count = pc\->offset;

    if (pc\->cap_usr_rdpmc && idx) {
        width = pc\->pmc_width;
        pmc = rdpmc(idx \- 1);
    }

    barrier();
} while (pc\->lock != seq);
.fi
.in



.TP
.I pmc_width
If
.IR cap_usr_rdpmc ,
this field provides the bit-width of the value
read using the rdpmc or equivalent instruction.
This can be used to sign extend the result like:

.in +4n
.nf
pmc <<= 64 \- pmc_width;
pmc >>= 64 \- pmc_width; // signed shift right
count += pmc;
.fi
.in


.TP
.IR time_shift ", " time_mult ", " time_offset

If
.IR cap_usr_time ,
these fields can be used to compute the time
delta since time_enabled (in ns) using rdtsc or similar.
.nf

    u64 quot, rem;
    u64 delta;
    quot = (cyc >> time_shift);
    rem = cyc & ((1 << time_shift) \- 1);
    delta = time_offset + quot * time_mult +
            ((rem * time_mult) >> time_shift);
.fi

Where time_offset,time_mult,time_shift and cyc are read in the
seqcount loop described above.
This delta can then be added to
enabled and possible running (if idx), improving the scaling:
.nf

    enabled += delta;
    if (idx)
        running += delta;
    quot = count / running;
    rem  = count % running;
    count = quot * enabled + (rem * enabled) / running;
.fi

.TP
.I data_head
This points to the head of the data section.
On SMP-capable platforms, after reading the data_head value,
user-space should issue an rmb().

.TP
.I data_tail;
When the mapping is
.BR PROT_WRITE ,
the data_tail value should be written by
userspace to reflect the last read data.
In this case the kernel will not over-write unread data.

.RE


The following 2^n ring-buffer pages have the layout described below.

If
.I perf_event_attr.sample_id_all
is set, then all event types will
have the sample_type selected fields related to where/when (identity)
an event took place (TID, TIME, ID, CPU, STREAM_ID) described in
.B PERF_RECORD_SAMPLE
below, it will be stashed just after the
perf_event_header and the fields already present for the existing
fields, i.e., at the end of the payload.
That way a newer perf.data
file will be supported by older perf tools, with these new optional
fields being ignored.

The mmap values start with a header:

.in +4n
.nf
struct perf_event_header {
    __u32   type;
    __u16   misc;
    __u16   size;
};
.fi
.in

Below, we describe the
.I perf_event_header
fields in more detail.

.TP
.I type
The
.I type
value is one of the below.
The values in the corresponding record (that follows the header)
depend on the
.I type
selected as shown.

.RS
.TP
.B PERF_RECORD_MMAP
The MMAP events record the
.B PROT_EXEC
mappings so that we can correlate
userspace IPs to code.
They have the following structure:

.in +4n
.nf
struct {
    struct perf_event_header header;
    u32    pid, tid;
    u64    addr;
    u64    len;
    u64    pgoff;
    char   filename[];
};
.in

.TP
.B PERF_RECORD_LOST
This record indicates when events are lost.

.in +4n
.nf
struct {
    struct perf_event_header header;
    u64 id;
    u64 lost;
};
.fi
.in

.TP
.B PERF_RECORD_COMM
This record indicates a change in the process name.

.in +4n
.nf
struct {
    struct perf_event_header header;
    u32 pid, tid;
    char comm[];
};
.fi
.in

.TP
.B PERF_RECORD_EXIT
This record indicates a process exit event.

.in +4n
.nf
struct {
    struct perf_event_header header;
    u32 pid, ppid;
    u32 tid, ptid;
    u64 time;
};
.fi
.in

.TP
.BR PERF_RECORD_THROTTLE ", " PERF_RECORD_UNTHROTTLE
This record indicates a throttle/unthrottle event.

.in +4n
.nf
struct {
    struct perf_event_header header;
    u64 time;
    u64 id;
    u64 stream_id;
};
.fi
.in

.TP
.B PERF_RECORD_FORK
This record indicates a fork event.

.in +4n
.nf
struct {
    struct perf_event_header header;
    u32 pid, ppid;
    u32 tid, ptid;
    u64 time;
};
.fi
.in

.TP
.B PERF_RECORD_READ
This record indicates a read event.

.in +4n
.nf
struct {
    struct perf_event_header header;
    u32 pid, tid;
    struct read_format values;
};
.fi
.in

.TP
.B PERF_RECORD_SAMPLE
This record indicates a sample.

.in +4n
.nf
struct {
    struct perf_event_header header;
    u64   ip;          /* if PERF_SAMPLE_IP      */
    u32   pid, tid;    /* if PERF_SAMPLE_TID     */
    u64   time;        /* if PERF_SAMPLE_TIME    */
    u64   addr;        /* if PERF_SAMPLE_ADDR    */
    u64   id;          /* if PERF_SAMPLE_ID      */
    u64   stream_id; /* if PERF_SAMPLE_STREAM_ID */
    u32   cpu, res;    /* if PERF_SAMPLE_CPU     */
    u64   period;      /* if PERF_SAMPLE_PERIOD  */
    struct read_format v; /* if PERF_SAMPLE_READ */
    u64   nr;        /* if PERF_SAMPLE_CALLCHAIN */
    u64   ips[nr];   /* if PERF_SAMPLE_CALLCHAIN */
    u32   size;        /* if PERF_SAMPLE_RAW     */
    char  data[size];  /* if PERF_SAMPLE_RAW     */
    u64   from;   /* if PERF_SAMPLE_BRANCH_STACK */
    u64   to;     /* if PERF_SAMPLE_BRANCH_STACK */
    u64   flags;  /* if PERF_SAMPLE_BRANCH_STACK */
    u64   lbr[nr];/* if PERF_SAMPLE_BRANCH_STACK */
};
.fi
.in

The RAW record data is opaque with respect to the ABI.
The ABI doesn't make any promises with respect to the stability
of its content, it may vary depending
on event, hardware, and kernel version.

.RE


.TP
.I misc
The
.I misc
field is one of the following:
.RS
.TP
.B PERF_RECORD_MISC_CPUMODE_MASK
[To be documented]
.TP
.B PERF_RECORD_MISC_CPUMODE_UNKNOWN
[To be documented]
.TP
.B PERF_RECORD_MISC_KERNEL
[To be documented]
.TP
.B PERF_RECORD_MISC_USER
[To be documented]
.TP
.B PERF_RECORD_MISC_HYPERVISOR
[To be documented]
.TP
.B PERF_RECORD_MISC_GUEST_KERNEL
[To be documented]
.TP
.B PERF_RECORD_MISC_GUEST_USER
[To be documented]
.TP
.B PERF_RECORD_MISC_EXACT_IP
This indicates that the content of
.B PERF_SAMPLE_IP
points
to the actual instruction that triggered the event.
See also
.IR perf_event_attr.precise_ip .

.RE

.TP
.I size
This indicates the size of the record.


.SS "Signal Overflow"

Counters can be set to signal when a threshold is crossed.
This is set up using traditional the
.BR poll (2),
.BR select (2),
.BR epoll (2)
and
.BR fcntl (2),
system calls.

Normally, a notification is generated for every page filled, however
one can additionally set
.I perf_event_attr.wakeup_events
to generate one every so many counter overflow events.

.SS "Reading Results"
Once a
.BR perf_event_open()
file descriptor  has been opened, the values
of the events can be read from the file descriptor.
The values that are there are specified by the
.I read_format
field in the attr structure at open time.

If you attempt to read into a buffer that is not big enough to hold the
data, an error is returned
.IR ( ENOSPC ).

Here is the layout of the data returned by a read.

If
.B PERF_FORMAT_GROUP
was specified to allow reading all events in a group at once:

.in +4n
.nf
struct {
    u64 nr;             /* The number of events */
    u64 time_enabled;   /* if PERF_FORMAT_TOTAL_TIME_ENABLED */
    u64 time_running;   /* if PERF_FORMAT_TOTAL_TIME_RUNNING */
    struct {
        u64 value;      /* The value of the event */
        u64 id;         /* if PERF_FORMAT_ID */
    } values[nr];
};
.fi
.in

If
.B PERF_FORMAT_GROUP
was
.I not
specified, then the read values look as following:

.in +4n
.nf
struct {
    u64 value;         /* The value of the event */
    u64 time_enabled;  /* if PERF_FORMAT_TOTAL_TIME_ENABLED */
    u64 time_running;  /* if PERF_FORMAT_TOTAL_TIME_RUNNING */
    u64 id;            /* if PERF_FORMAT_ID */
};
.fi
.in

The values read are described in more detail below.
.RS
.TP
.I nr
The number of events in this file descriptor.
Only available if
.B PERF_FORMAT_GROUP
was specified.

.TP
.IR time_enabled ", " time_running
Total time the event was enabled and running.
Normally these are the same.
If more events are started
than available counter slots on the PMU, then multiplexing
happens and events only run part of the time.
In that case the
.I time_enabled
and
.I time running
values can be used to scale an estimated value for the count.

.TP
.I value
An unsigned 64-bit value containing the counter result.

.TP
.I id
A globally unique value for this particular event, only there if
.B PERF_FORMAT_ID
was specified in read_format.

.RE




.RE

.SS "rdpmc instruction"
Starting with Linux 3.4 on x86, you can use the
.I rdpmc
instruction to get low-latency reads without having to enter the kernel.


.SS "perf_event ioctl calls"
.PP
Various ioctls act on
.BR perf_event_open()
file descriptors
.\" FIXME the arguments for these ioctl() operations need to be described
.TP
.B PERF_EVENT_IOC_ENABLE
Enables an individual counter or counter group.

.TP
.B PERF_EVENT_IOC_DISABLE
Disables an individual counter or counter group.

Enabling or disabling the leader of a group enables or disables the
entire group; that is, while the group leader is disabled, none of the
counters in the group will count.
Enabling or disabling a member of a group other than the leader only
affects that counter; disabling a non-leader
stops that counter from counting but doesn't affect any other counter.

.TP
.B PERF_EVENT_IOC_REFRESH
Non-inherited overflow counters can use this
to enable a counter for 'nr' events, after which it gets disabled again.
.\" FIXME the following needs clarification/confirmation
I think the goal of IOC_REFRESH is not to reload the period but simply to
adjust the number of events before the next notifications.

.TP
.B PERF_EVENT_IOC_RESET
Reset the event count to zero.
This only resets the counts; there is no way to reset the
multiplexing
.I time_enabled
or
.I time_running
values.
When sent to a group leader, only
the leader is reset (child events are not).

.TP
.B PERF_EVENT_IOC_PERIOD
IOC_PERIOD is the command to update the period; it
does not update the current period but instead defers until next.

.TP
.B PERF_EVENT_IOC_SET_OUTPUT
This tells the kernel to report event notifications to the specified
file descriptor rather than the default one.
The file descriptors must all be on the same CPU.

.TP
.BR PERF_EVENT_IOC_SET_FILTER " (Since Linux 2.6.33)"
This adds an ftrace filter to this event.

.SS "Using prctl"
A process can enable or disable all the counter groups that are
attached to it using the
.BR prctl (2)
.B PR_TASK_PERF_EVENTS_ENABLE
and
.B PR_TASK_PERF_EVENTS_DISABLE
operations.
This applies to all counters on the current process, whether created by
this process or by another, and does not affect any counters that this
process has created on other processes.
It only enables or disables
the group leaders, not any other members in the groups.

.SS /proc/sys/kernel/perf_event_paranoid

The
.I /proc/sys/kernel/perf_event_paranoid
file can be set to restrict access to the performance counters.
2
means no measurements allowed,
1
means normal counter access,
0
means you can access CPU-specific data, and
\-1
means no restrictions.

The existence of the
.I perf_event_paranoid
file is the official method for determining if a kernel supports
.BR perf_event_open().

.SH "RETURN VALUE"
.BR perf_event_open ()
returns the new file descriptor, or \-1 if an error occurred
(in which case,
.I errno
is set appropriately).
.SH ERRORS
.TP
.B EINVAL
Returned if the specified event is not available.
.TP
.B ENOSPC
Prior to Linux 3.3, if there was no counter room,
.B ENOSPC
was returned.
Linus did not like this, and this was changed to
.BR EINVAL .
.B ENOSPC
is still returned if you try to read results into
too small a buffer.

.SH VERSION

.BR perf_event_open ()
was introduced in Linux 2.6.31 but was called
.BR perf_counter_open () .
It was renamed in Linux 2.6.32.

.SH CONFORMING TO

This call is specific to Linux
and should not be used in programs intended to be portable.

.SH NOTES
Glibc does not provide a wrapper for this system call; call it using
.BR syscall (2).

The official way of knowing if
.BR perf_event_open()
support is enabled is checking
for the existence of the file
.I /proc/sys/kernel/perf_event_paranoid

.SH BUGS

The
.B F_SETOWN_EX
option to
.IR fcntl (2)
is needed to properly get overflow signals in threads.
This was introduced in Linux 2.6.32.

Prior to Linux 2.6.33 (at least for x86) the kernel did not check
if events could be scheduled together until read time.
The same happens on all known kernels if the NMI watchdog is enabled.
This means to see if a given set of events works you have to
.BR perf_event_open (),
start, then read before you know for sure you
can get valid measurements.

Prior to Linux 2.6.34 event constraints were not enforced by the kernel.
In that case, some events would silently return "0" if the kernel
scheduled them in an improper counter slot.

Prior to Linux 2.6.34 there was a bug when multiplexing where the
wrong results could be returned.

Kernels from Linux 2.6.35 to Linux 2.6.39 can quickly crash the kernel if
"inherit" is enabled and many threads are started.

Prior to Linux 2.6.35,
.B PERF_FORMAT_GROUP
did not work with attached processes.

In older Linux 2.6 versions,
refreshing an event group leader refreshed all siblings,
and refreshing with a parameter of 0 enabled infinite refresh.
This behavior is unsupported and should not be relied on.

There is a bug in the kernel code between
Linux 2.6.36 and Linux 3.0 that ignores the
"watermark" field and acts as if a wakeup_event
was chosen if the union has a
non-zero value in it.

Always double-check your results!  Various generalized events
have had wrong values.
For example, retired branches measured
the wrong thing on AMD machines until Linux 2.6.35.

.SH EXAMPLE
The following is a short example that measures the total
instruction count of a call to printf().
.nf

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/ioctl.h>
#include <linux/perf_event.h>
#include <asm/unistd.h>

long perf_event_open( struct perf_event_attr *hw_event, pid_t pid,
                      int cpu, int group_fd, unsigned long flags )
{
    int ret;

    ret = syscall( __NR_perf_event_open, hw_event, pid, cpu,
                   group_fd, flags );
    return ret;
}


int
main(int argc, char **argv)
{

    struct perf_event_attr pe;
    long long count;
    int fd;

    memset(&pe, 0, sizeof(struct perf_event_attr));
    pe.type = PERF_TYPE_HARDWARE;
    pe.size = sizeof(struct perf_event_attr);
    pe.config = PERF_COUNT_HW_INSTRUCTIONS;
    pe.disabled = 1;
    pe.exclude_kernel = 1;
    pe.exclude_hv = 1;

    fd = perf_event_open(&pe, 0, \-1, \-1, 0);
    if (fd < 0) {
       fprintf(stderr, "Error opening leader %llx\\n", pe.config);
    }

    ioctl(fd, PERF_EVENT_IOC_RESET, 0);
    ioctl(fd, PERF_EVENT_IOC_ENABLE, 0);

    printf("Measuring instruction count for this printf\\n");

    ioctl(fd, PERF_EVENT_IOC_DISABLE, 0);
    read(fd, &count, sizeof(long long));

    printf("Used %lld instructions\\n", count);

    close(fd);
}
.fi

.SH "SEE ALSO"
.BR fcntl (2),
.BR mmap (2),
.BR open (2),
.BR prctl (2),
.BR read (2)
--8323329-940803195-1351006515=:24986
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=perf_event_open.2
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.02.1210231135130.24986@vincent-weaver-1.um.maine.edu>
Content-Description: 
Content-Disposition: attachment; filename=perf_event_open.2

LlwiIEhleSBFbWFjcyEgVGhpcyBmaWxlIGlzIC0qLSBucm9mZiAtKi0gc291
cmNlLg0KLlwiDQouXCIgQ29weXJpZ2h0IChjKSAyMDEyLCBWaW5jZW50IFdl
YXZlcg0KLlwiDQouXCIgVGhpcyBpcyBmcmVlIGRvY3VtZW50YXRpb247IHlv
dSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vcg0KLlwiIG1vZGlmeSBpdCB1
bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNl
bnNlIGFzDQouXCIgcHVibGlzaGVkIGJ5IHRoZSBGcmVlIFNvZnR3YXJlIEZv
dW5kYXRpb247IGVpdGhlciB2ZXJzaW9uIDIgb2YNCi5cIiB0aGUgTGljZW5z
ZSwgb3IgKGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4NCi5c
Ig0KLlwiIFRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSdzIHJlZmVy
ZW5jZXMgdG8gIm9iamVjdCBjb2RlIg0KLlwiIGFuZCAiZXhlY3V0YWJsZXMi
IGFyZSB0byBiZSBpbnRlcnByZXRlZCBhcyB0aGUgb3V0cHV0IG9mIGFueQ0K
LlwiIGRvY3VtZW50IGZvcm1hdHRpbmcgb3IgdHlwZXNldHRpbmcgc3lzdGVt
LCBpbmNsdWRpbmcNCi5cIiBpbnRlcm1lZGlhdGUgYW5kIHByaW50ZWQgb3V0
cHV0Lg0KLlwiDQouXCIgVGhpcyBtYW51YWwgaXMgZGlzdHJpYnV0ZWQgaW4g
dGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwNCi5cIiBidXQgV0lU
SE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3
YXJyYW50eSBvZg0KLlwiIE1FUkNIQU5UQUJJTElUWSBvciBGSVRORVNTIEZP
UiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0aGUNCi5cIiBHTlUgR2Vu
ZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLg0KLlwiDQou
XCIgWW91IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEgY29weSBvZiB0aGUgR05V
IEdlbmVyYWwgUHVibGljDQouXCIgTGljZW5zZSBhbG9uZyB3aXRoIHRoaXMg
bWFudWFsOyBpZiBub3QsIHNlZQ0KLlwiIDxodHRwOi8vd3d3LmdudS5vcmcv
bGljZW5zZXMvPi4NCi5cIg0KLlwiIFRoaXMgZG9jdW1lbnQgaXMgYmFzZWQg
b24gdGhlIHBlcmZfZXZlbnQuaCBoZWFkZXIgZmlsZSwgdGhlDQouXCIgdG9v
bHMvcGVyZi9kZXNpZ24udHh0IGZpbGUsIGFuZCBhIGxvdCBvZiBiaXR0ZXIg
ZXhwZXJpZW5jZS4NCi5cIg0KLlRIIFBFUkZfRVZFTlRfT1BFTiAyIDIwMTIt
MTAtMjMgIkxpbnV4IiAiTGludXggUHJvZ3JhbW1lcidzIE1hbnVhbCINCi5T
SCBOQU1FDQpwZXJmX2V2ZW50X29wZW4gXC0gc2V0IHVwIHBlcmZvcm1hbmNl
IG1vbml0b3JpbmcNCi5TSCBTWU5PUFNJUw0KLm5mDQouQiAjaW5jbHVkZSA8
bGludXgvcGVyZl9ldmVudC5oPg0KLkIgI2luY2x1ZGUgPGxpbnV4L2h3X2Jy
ZWFrcG9pbnQuaD4NCi5zcA0KLkJJICJpbnQgcGVyZl9ldmVudF9vcGVuKHN0
cnVjdCBwZXJmX2V2ZW50X2F0dHIgKiIgaHdfZXZlbnQgLA0KLkJJICIgICAg
ICAgICAgICAgICAgICAgIHBpZF90ICIgcGlkICIsIGludCAiIGNwdSAiLCBp
bnQgIiBncm91cF9mZCAsDQouQkkgIiAgICAgICAgICAgICAgICAgICAgdW5z
aWduZWQgbG9uZyAiIGZsYWdzICApOw0KLmZpDQoNCi5JUiBOb3RlIDoNClRo
ZXJlIGlzIG5vIGdsaWJjIHdyYXBwZXIgZm9yIHRoaXMgc3lzdGVtIGNhbGw7
IHNlZSBOT1RFUy4NCi5TSCBERVNDUklQVElPTg0KR2l2ZW4gYSBsaXN0IG9m
IHBhcmFtZXRlcnMsDQouQlIgcGVyZl9ldmVudF9vcGVuICgpDQpyZXR1cm5z
IGEgZmlsZSBkZXNjcmlwdG9yLCBmb3IgdXNlIGluIHN1YnNlcXVlbnQgc3lz
dGVtIGNhbGxzDQouUkIgKCByZWFkICIoMiksICIgbW1hcCAiKDIpLCAiIHBy
Y3RsICIoMiksICIgZmNudGwgIigyKSwgZXRjLikuIg0KLlBQDQpBIGNhbGwg
dG8NCi5CUiBwZXJmX2V2ZW50X29wZW4gKCkNCmNyZWF0ZXMgYSBmaWxlIGRl
c2NyaXB0b3IgdGhhdCBhbGxvd3MgbWVhc3VyaW5nIHBlcmZvcm1hbmNlDQpp
bmZvcm1hdGlvbi4NCkVhY2ggZmlsZSBkZXNjcmlwdG9yIGNvcnJlc3BvbmRz
IHRvIG9uZQ0KZXZlbnQgdGhhdCBpcyBtZWFzdXJlZDsgdGhlc2UgY2FuIGJl
IGdyb3VwZWQgdG9nZXRoZXINCnRvIG1lYXN1cmUgbXVsdGlwbGUgZXZlbnRz
IHNpbXVsdGFuZW91c2x5Lg0KLlBQDQpFdmVudHMgY2FuIGJlIGVuYWJsZWQg
YW5kIGRpc2FibGVkIGluIHR3byB3YXlzOiB2aWENCi5CUiBpb2N0bCAoMikN
CmFuZCB2aWENCi5CUiBwcmN0bCAoMikgLg0KV2hlbiBhbiBldmVudCBpcyBk
aXNhYmxlZCBpdCBkb2VzIG5vdCBjb3VudCBvciBnZW5lcmF0ZSBvdmVyZmxv
d3MgYnV0IGRvZXMNCmNvbnRpbnVlIHRvIGV4aXN0IGFuZCBtYWludGFpbiBp
dHMgY291bnQgdmFsdWUuDQpFdmVudHMgY29tZSBpbiB0d28gZmxhdm9yczog
Y291bnRpbmcgYW5kIHNhbXBsZWQuDQpBDQouSSBjb3VudGluZw0KZXZlbnQg
aXMgb25lIHRoYXQgaXMgdXNlZCBmb3IgY291bnRpbmcgdGhlIGFnZ3JlZ2F0
ZSBudW1iZXIgb2YgZXZlbnRzDQp0aGF0IG9jY3VyLg0KSW4gZ2VuZXJhbCwg
Y291bnRpbmcgZXZlbnQgcmVzdWx0cyBhcmUgZ2F0aGVyZWQgd2l0aCBhDQou
QlIgcmVhZCAoMikNCmNhbGwuDQpBDQouSSBzYW1wbGluZw0KZXZlbnQgcGVy
aW9kaWNhbGx5IHdyaXRlcyBtZWFzdXJlbWVudHMgdG8gYSBidWZmZXIgdGhh
dCBjYW4gdGhlbg0KYmUgYWNjZXNzZWQgdmlhDQouQlIgIG1tYXAgKDIpIC4N
Ci5TUyBBcmd1bWVudHMNCi5QDQpUaGUgYXJndW1lbnQNCi5JIHBpZA0KYWxs
b3dzIGV2ZW50cyB0byBiZSBhdHRhY2hlZCB0byBwcm9jZXNzZXMgaW4gdmFy
aW91cyB3YXlzLg0KSWYNCi5JIHBpZA0KaXMgMCwgbWVhc3VyZW1lbnRzIGhh
cHBlbiBvbiB0aGUgY3VycmVudCB0YXNrLCBpZg0KLkkgcGlkDQppcyBncmVh
dGVyIHRoYW4gMCwgdGhlIHByb2Nlc3MgaW5kaWNhdGVkIGJ5DQouSSBwaWQN
CmlzIG1lYXN1cmVkLCBhbmQgaWYNCi5JIHBpZA0KaXMgbGVzcyB0aGFuIDAs
IGFsbCBwcm9jZXNzZXMgYXJlIGNvdW50ZWQuDQoNClRoZQ0KLkkgY3B1DQph
cmd1bWVudCBhbGxvd3MgbWVhc3VyZW1lbnRzIHRvIGJlIHNwZWNpZmljIHRv
IGEgQ1BVLg0KSWYNCi5JIGNwdQ0KaXMgZ3JlYXRlciB0aGFuIG9yIGVxdWFs
IHRvIDAsDQptZWFzdXJlbWVudHMgYXJlIHJlc3RyaWN0ZWQgdG8gdGhlIHNw
ZWNpZmllZCBDUFU7DQppZg0KLkkgY3B1DQppcyBcLTEsIHRoZSBldmVudHMg
YXJlIG1lYXN1cmVkIG9uIGFsbCBDUFVzLg0KLlANCk5vdGUgdGhhdCB0aGUg
Y29tYmluYXRpb24gb2YNCi5JUiBwaWQgIiA9PSBcLTEiDQphbmQNCi5JUiBj
cHUgIiA9PSBcLTEiDQppcyBub3QgdmFsaWQuDQouUA0KQQ0KLklSIHBpZCAi
ID4gMCINCmFuZA0KLklSIGNwdSAiID09IFwtMSINCnNldHRpbmcgbWVhc3Vy
ZXMgcGVyLXByb2Nlc3MgYW5kIGZvbGxvd3MgdGhhdCBwcm9jZXNzIHRvIHdo
YXRldmVyIENQVSB0aGUNCnByb2Nlc3MgZ2V0cyBzY2hlZHVsZWQgdG8uDQpQ
ZXItcHJvY2VzcyBldmVudHMgY2FuIGJlIGNyZWF0ZWQgYnkgYW55IHVzZXIu
DQouUA0KQQ0KLklSIHBpZCAiID09IFwtMSINCmFuZA0KLklSIGNwdSAiID49
IDAiDQpzZXR0aW5nIGlzIHBlci1DUFUgYW5kIG1lYXN1cmVzIGFsbCBwcm9j
ZXNzZXMgb24gdGhlIHNwZWNpZmllZCBDUFUuDQpQZXItQ1BVIGV2ZW50cyBu
ZWVkIHRoZQ0KLkIgQ0FQX1NZU19BRE1JTg0KY2FwYWJpbGl0eS4NCi5QDQpU
aGUNCi5JIGdyb3VwX2ZkDQphcmd1bWVudCBhbGxvd3MgY291bnRlciBncm91
cHMgdG8gYmUgc2V0IHVwLg0KQSBjb3VudGVyIGdyb3VwIGhhcyBvbmUgY291
bnRlciB3aGljaCBpcyB0aGUgZ3JvdXAgbGVhZGVyLg0KVGhlIGxlYWRlciBp
cyBjcmVhdGVkIGZpcnN0LCB3aXRoDQouSVIgZ3JvdXBfZmQgIiA9IFwtMSIN
CmluIHRoZQ0KLkJSIHBlcmZfZXZlbnRfb3BlbiAoKQ0KY2FsbCB0aGF0IGNy
ZWF0ZXMgaXQuDQpUaGUgcmVzdCBvZiB0aGUgZ3JvdXAgbWVtYmVycyBhcmUg
Y3JlYXRlZCBzdWJzZXF1ZW50bHksIHdpdGgNCi5JUiBncm91cF9mZA0KZ2l2
aW5nIHRoZSBmZCBvZiB0aGUgZ3JvdXAgbGVhZGVyLg0KKEEgc2luZ2xlIGNv
dW50ZXIgb24gaXRzIG93biBpcyBjcmVhdGVkIHdpdGgNCi5JUiBncm91cF9m
ZCAiID0gXC0xIg0KYW5kIGlzIGNvbnNpZGVyZWQgdG8gYmUgYSBncm91cCB3
aXRoIG9ubHkgMSBtZW1iZXIuKQ0KLlANCkEgY291bnRlciBncm91cCBpcyBz
Y2hlZHVsZWQgb250byB0aGUgQ1BVIGFzIGEgdW5pdDogaXQgd2lsbCBvbmx5
DQpiZSBwdXQgb250byB0aGUgQ1BVIGlmIGFsbCBvZiB0aGUgY291bnRlcnMg
aW4gdGhlIGdyb3VwIGNhbiBiZSBwdXQgb250bw0KdGhlIENQVS4NClRoaXMg
bWVhbnMgdGhhdCB0aGUgdmFsdWVzIG9mIHRoZSBtZW1iZXIgY291bnRlcnMg
Y2FuIGJlDQptZWFuaW5nZnVsbHkgY29tcGFyZWQsIGFkZGVkLCBkaXZpZGVk
ICh0byBnZXQgcmF0aW9zKSwgZXRjLiwgd2l0aCBlYWNoDQpvdGhlciwgc2lu
Y2UgdGhleSBoYXZlIGNvdW50ZWQgZXZlbnRzIGZvciB0aGUgc2FtZSBzZXQg
b2YgZXhlY3V0ZWQNCmluc3RydWN0aW9ucy4NCi5QDQpUaGUNCi5JIGZsYWdz
DQphcmd1bWVudCB0YWtlcyBvbmUgb2YgdGhlIGZvbGxvd2luZyB2YWx1ZXM6
DQouVFANCi5CUiBQRVJGX0ZMQUdfRkRfTk9fR1JPVVANCi5cIiBGSVhNRSBU
aGUgZm9sbG93aW5nIHNlbnRlbmNlIGlzIHVuY2xlYXINClRoaXMgZmxhZyBh
bGxvd3MgY3JlYXRpbmcgYW4gZXZlbnQgYXMgcGFydCBvZiBhbiBldmVudCBn
cm91cCBidXQNCmhhdmluZyBubyBncm91cCBsZWFkZXIuDQpJdCBpcyB1bmNs
ZWFyIHdoeSB0aGlzIGlzIHVzZWZ1bC4NCi5cIiBGSVhNRSBTbywgd2h5IGlz
IGl0IHVzZWZ1bD8NCi5UUA0KLkJSIFBFUkZfRkxBR19GRF9PVVRQVVQNClRo
aXMgZmxhZyByZS1yb3V0ZXMgdGhlIG91dHB1dCBmcm9tIGFuIGV2ZW50IHRv
IHRoZSBncm91cCBsZWFkZXIuDQouVFANCi5CUiBQRVJGX0ZMQUdfUElEX0NH
Uk9VUCAiIChTaW5jZSBMaW51eCAyLjYuMzkpLiINClRoaXMgZmxhZyBhY3Rp
dmF0ZXMgcGVyLWNvbnRhaW5lciBzeXN0ZW0td2lkZSBtb25pdG9yaW5nLg0K
QSBjb250YWluZXINCmlzIGFuIGFic3RyYWN0aW9uIHRoYXQgaXNvbGF0ZXMg
YSBzZXQgb2YgcmVzb3VyY2VzIGZvciBmaW5lciBncmFpbg0KY29udHJvbCAo
Q1BVcywgbWVtb3J5LCBldGMuLi4pLg0KSW4gdGhpcyBtb2RlLCB0aGUgZXZl
bnQgaXMgbWVhc3VyZWQNCm9ubHkgaWYgdGhlIHRocmVhZCBydW5uaW5nIG9u
IHRoZSBtb25pdG9yZWQgQ1BVIGJlbG9uZ3MgdG8gdGhlIGRlc2lnbmF0ZWQN
CmNvbnRhaW5lciAoY2dyb3VwKS4NClRoZSBjZ3JvdXAgaXMgaWRlbnRpZmll
ZCBieSBwYXNzaW5nIGEgZmlsZSBkZXNjcmlwdG9yDQpvcGVuZWQgb24gaXRz
IGRpcmVjdG9yeSBpbiB0aGUgY2dyb3VwZnMgZmlsZXN5c3RlbS4NCkZvciBp
bnN0YW5jZSwgaWYgdGhlDQpjZ3JvdXAgdG8gbW9uaXRvciBpcyBjYWxsZWQN
Ci5JUiB0ZXN0ICwNCnRoZW4gYSBmaWxlIGRlc2NyaXB0b3Igb3BlbmVkIG9u
DQouSSAvZGV2L2Nncm91cC90ZXN0DQooYXNzdW1pbmcgY2dyb3VwZnMgaXMg
bW91bnRlZCBvbg0KLklSIC9kZXYvY2dyb3VwICkNCm11c3QgYmUgcGFzc2Vk
IGFzIHRoZQ0KLkkgcGlkDQpwYXJhbWV0ZXIuDQpjZ3JvdXAgbW9uaXRvcmlu
ZyBpcyBvbmx5IGF2YWlsYWJsZQ0KZm9yIHN5c3RlbS13aWRlIGV2ZW50cyBh
bmQgbWF5IHRoZXJlZm9yZSByZXF1aXJlIGV4dHJhIHBlcm1pc3Npb25zLg0K
LlANClRoZQ0KLkkgcGVyZl9ldmVudF9hdHRyDQpzdHJ1Y3R1cmUgaXMgd2hh
dCBpcyBwYXNzZWQgaW50byB0aGUNCi5CUiBwZXJmX2V2ZW50X29wZW4gKCkN
CnN5c2NhbGwuDQpJdCBpcyBsYXJnZSBhbmQgaGFzIGEgY29tcGxpY2F0ZWQg
c2V0IG9mIGRlcGVuZGVudCBmaWVsZHMuDQoNCi5pbiArNG4NCi5uZg0Kc3Ry
dWN0IHBlcmZfZXZlbnRfYXR0ciB7DQogICAgX191MzIgICAgIHR5cGU7ICAg
ICAgICAgLyogVHlwZSBvZiBldmVudCAqLw0KICAgIF9fdTMyICAgICBzaXpl
OyAgICAgICAgIC8qIFNpemUgb2YgYXR0cmlidXRlIHN0cnVjdHVyZSAqLw0K
ICAgIF9fdTY0ICAgICBjb25maWc7ICAgICAgIC8qIFR5cGUtc3BlY2lmaWMg
Y29uZmlndXJhdGlvbiAqLw0KDQogICAgdW5pb24gew0KICAgICAgICBfX3U2
NCBzYW1wbGVfcGVyaW9kOyAgICAvKiBQZXJpb2Qgb2Ygc2FtcGxpbmcgKi8N
CiAgICAgICAgX191NjQgc2FtcGxlX2ZyZXE7ICAgICAgLyogRnJlcXVlbmN5
IG9mIHNhbXBsaW5nICovDQogICAgfTsNCg0KICAgIF9fdTY0ICAgICBzYW1w
bGVfdHlwZTsgIC8qIFNwZWNpZmllcyB2YWx1ZXMgaW5jbHVkZWQgaW4gc2Ft
cGxlICovDQogICAgX191NjQgICAgIHJlYWRfZm9ybWF0OyAgLyogU3BlY2lm
aWVzIHZhbHVlcyByZXR1cm5lZCBpbiByZWFkICovDQoNCiAgICBfX3U2NCAg
ICAgZGlzYWJsZWQgICAgICAgOiAxLCAgIC8qIG9mZiBieSBkZWZhdWx0ICAg
ICAgICAgKi8NCiAgICAgICAgICAgICAgaW5oZXJpdCAgICAgICAgOiAxLCAg
IC8qIGNoaWxkcmVuIGluaGVyaXQgaXQgICAgKi8NCiAgICAgICAgICAgICAg
cGlubmVkICAgICAgICAgOiAxLCAgIC8qIG11c3QgYWx3YXlzIGJlIG9uIFBN
VSAgKi8NCiAgICAgICAgICAgICAgZXhjbHVzaXZlICAgICAgOiAxLCAgIC8q
IG9ubHkgZ3JvdXAgb24gUE1VICAgICAgKi8NCiAgICAgICAgICAgICAgZXhj
bHVkZV91c2VyICAgOiAxLCAgIC8qIGRvbid0IGNvdW50IHVzZXIgICAgICAg
Ki8NCiAgICAgICAgICAgICAgZXhjbHVkZV9rZXJuZWwgOiAxLCAgIC8qIGRv
bid0IGNvdW50IGtlcm5lbCAgICAgKi8NCiAgICAgICAgICAgICAgZXhjbHVk
ZV9odiAgICAgOiAxLCAgIC8qIGRvbid0IGNvdW50IGh5cGVydmlzb3IgKi8N
CiAgICAgICAgICAgICAgZXhjbHVkZV9pZGxlICAgOiAxLCAgIC8qIGRvbid0
IGNvdW50IHdoZW4gaWRsZSAgKi8NCiAgICAgICAgICAgICAgbW1hcCAgICAg
ICAgICAgOiAxLCAgIC8qIGluY2x1ZGUgbW1hcCBkYXRhICAgICAgKi8NCiAg
ICAgICAgICAgICAgY29tbSAgICAgICAgICAgOiAxLCAgIC8qIGluY2x1ZGUg
Y29tbSBkYXRhICAgICAgKi8NCiAgICAgICAgICAgICAgZnJlcSAgICAgICAg
ICAgOiAxLCAgIC8qIHVzZSBmcmVxLCBub3QgcGVyaW9kICAgKi8NCiAgICAg
ICAgICAgICAgaW5oZXJpdF9zdGF0ICAgOiAxLCAgIC8qIHBlciB0YXNrIGNv
dW50cyAgICAgICAgKi8NCiAgICAgICAgICAgICAgZW5hYmxlX29uX2V4ZWMg
OiAxLCAgIC8qIG5leHQgZXhlYyBlbmFibGVzICAgICAgKi8NCiAgICAgICAg
ICAgICAgdGFzayAgICAgICAgICAgOiAxLCAgIC8qIHRyYWNlIGZvcmsvZXhp
dCAgICAgICAgKi8NCiAgICAgICAgICAgICAgd2F0ZXJtYXJrICAgICAgOiAx
LCAgIC8qIHdha2V1cF93YXRlcm1hcmsgICAgICAgKi8NCiAgICAgICAgICAg
ICAgcHJlY2lzZV9pcCAgICAgOiAyLCAgIC8qIHNraWQgY29uc3RyYWludCAg
ICAgICAgKi8NCiAgICAgICAgICAgICAgbW1hcF9kYXRhICAgICAgOiAxLCAg
IC8qIG5vbi1leGVjIG1tYXAgZGF0YSAgICAgKi8NCiAgICAgICAgICAgICAg
c2FtcGxlX2lkX2FsbCAgOiAxLCAgIC8qIHNhbXBsZV90eXBlIGFsbCBldmVu
dHMgKi8NCiAgICAgICAgICAgICAgZXhjbHVkZV9ob3N0ICAgOiAxLCAgIC8q
IGRvbid0IGNvdW50IGluIGhvc3QgICAgKi8NCiAgICAgICAgICAgICAgZXhj
bHVkZV9ndWVzdCAgOiAxLCAgIC8qIGRvbid0IGNvdW50IGluIGd1ZXN0ICAg
Ki8NCiAgICAgICAgICAgICAgX19yZXNlcnZlZF8xICAgOiA0MzsNCg0KICAg
IHVuaW9uIHsNCiAgICAgICAgX191MzIgd2FrZXVwX2V2ZW50czsgICAgLyog
d2FrZXVwIGV2ZXJ5IG4gZXZlbnRzICovDQogICAgICAgIF9fdTMyIHdha2V1
cF93YXRlcm1hcms7IC8qIGJ5dGVzIGJlZm9yZSB3YWtldXAgICAqLw0KICAg
IH07DQoNCiAgICBfX3UzMiAgICAgYnBfdHlwZTsgICAgICAgICAgLyogYnJl
YWtwb2ludCB0eXBlICovDQoNCiAgICB1bmlvbiB7DQogICAgICAgIF9fdTY0
IGJwX2FkZHI7ICAgICAgICAgIC8qIGJyZWFrcG9pbnQgYWRkcmVzcyAqLw0K
ICAgICAgICBfX3U2NCBjb25maWcxOyAgICAgICAgICAvKiBleHRlbnNpb24g
b2YgY29uZmlnICovDQogICAgfTsNCg0KICAgIHVuaW9uIHsNCiAgICAgICAg
X191NjQgYnBfbGVuOyAgICAgICAgICAgLyogYnJlYWtwb2ludCBsZW5ndGgg
Ki8NCiAgICAgICAgX191NjQgY29uZmlnMjsgICAgICAgICAgLyogZXh0ZW5z
aW9uIG9mIGNvbmZpZzEgKi8NCiAgICB9Ow0KICAgIF9fdTY0ICAgICBicmFu
Y2hfc2FtcGxlX3R5cGU7ICAgLyogZW51bSBicmFuY2hfc2FtcGxlX3R5cGUg
Ki8NCn07DQouZmkNCi5pbg0KDQpUaGUgZmllbGRzIG9mIHRoZQ0KLkkgcGVy
Zl9ldmVudF9hdHRyDQpzdHJ1Y3R1cmUgYXJlIGRlc2NyaWJlZCBpbiBtb3Jl
IGRldGFpbCBiZWxvdy4NCg0KLlRQDQouSSB0eXBlDQpUaGlzIGZpZWxkIHNw
ZWNpZmllcyB0aGUgb3ZlcmFsbCBldmVudCB0eXBlLg0KSXQgaGFzIG9uZSBv
ZiB0aGUgZm9sbG93aW5nIHZhbHVlczoNCi5SUw0KLlRQDQouQiBQRVJGX1RZ
UEVfSEFSRFdBUkUNClRoaXMgaW5kaWNhdGVzIG9uZSBvZiB0aGUgImdlbmVy
YWxpemVkIiBoYXJkd2FyZSBldmVudHMgcHJvdmlkZWQNCmJ5IHRoZSBrZXJu
ZWwuDQpTZWUgdGhlDQouSSBjb25maWcNCmZpZWxkIGRlZmluaXRpb24gZm9y
IG1vcmUgZGV0YWlscy4NCi5UUA0KLkIgUEVSRl9UWVBFX1NPRlRXQVJFDQpU
aGlzIGluZGljYXRlcyBvbmUgb2YgdGhlIHNvZnR3YXJlLWRlZmluZWQgZXZl
bnRzIHByb3ZpZGVkIGJ5IHRoZSBrZXJuZWwNCihldmVuIGlmIG5vIGhhcmR3
YXJlIHN1cHBvcnQgaXMgYXZhaWxhYmxlKS4NCi5UUA0KLkIgUEVSRl9UWVBF
X1RSQUNFUE9JTlQNClRoaXMgaW5kaWNhdGVzIGEgdHJhY2Vwb2ludA0KcHJv
dmlkZWQgYnkgdGhlIGtlcm5lbCB0cmFjZXBvaW50IGluZnJhc3RydWN0dXJl
Lg0KLlRQDQouQiBQRVJGX1RZUEVfSFdfQ0FDSEUNClRoaXMgaW5kaWNhdGVz
IGEgaGFyZHdhcmUgY2FjaGUgZXZlbnQuDQpUaGlzIGhhcyBhIHNwZWNpYWwg
ZW5jb2RpbmcsIGRlc2NyaWJlZCBpbiB0aGUNCi5JIGNvbmZpZw0KZmllbGQg
ZGVmaW5pdGlvbi4NCi5UUA0KLkIgUEVSRl9UWVBFX1JBVw0KVGhpcyBpbmRp
Y2F0ZXMgYSAicmF3IiBpbXBsZW1lbnRhdGlvbi1zcGVjaWZpYyBldmVudCBp
biB0aGUNCi5JUiBjb25maWcgIiBmaWVsZC4iDQouVFANCi5CUiBQRVJGX1RZ
UEVfQlJFQUtQT0lOVCAiIChTaW5jZSBMaW51eCAyLjYuMzMpIg0KVGhpcyBp
bmRpY2F0ZXMgYSBoYXJkd2FyZSBicmVha3BvaW50IGFzIHByb3ZpZGVkIGJ5
IHRoZSBDUFUuDQpCcmVha3BvaW50cyBjYW4gYmUgcmVhZC93cml0ZSBhY2Nl
c3NlcyB0byBhbiBhZGRyZXNzIGFzIHdlbGwgYXMNCmV4ZWN1dGlvbiBvZiBh
biBpbnN0cnVjdGlvbiBhZGRyZXNzLg0KLlRQDQouUkIgImR5bmFtaWMgUE1V
Ig0KU2luY2UgTGludXggMi42LjM5LA0KLkJSIHBlcmZfZXZlbnRfb3Blbigp
DQpjYW4gc3VwcG9ydCBtdWx0aXBsZSBQTVVzLg0KVG8gZW5hYmxlIHRoaXMs
IGEgdmFsdWUgZXhwb3J0ZWQgYnkgdGhlIGtlcm5lbCBjYW4gYmUgdXNlZCBp
biB0aGUNCi5JIHR5cGUNCmZpZWxkIHRvIGluZGljYXRlIHdoaWNoIFBNVSB0
byB1c2UuDQpUaGUgdmFsdWUgdG8gdXNlIGNhbiBiZSBmb3VuZCBpbiB0aGUg
c3lzZnMgZmlsZXN5c3RlbToNCnRoZXJlIGlzIGEgc3ViZGlyZWN0b3J5IHBl
ciBQTVUgaW5zdGFuY2UgdW5kZXINCi5JUiAvc3lzL2RldmljZXMgLg0KSW4g
ZWFjaCBzdWItZGlyZWN0b3J5IHRoZXJlIGlzIGENCi5JIHR5cGUNCmZpbGUg
d2hvc2UgY29udGVudCBpcyBhbiBpbnRlZ2VyIHRoYXQgY2FuIGJlIHVzZWQg
aW4gdGhlDQouSSB0eXBlDQpmaWVsZC4NCkZvciBpbnN0YW5jZSwNCi5JIC9z
eXMvZGV2aWNlcy9jcHUvdHlwZQ0KY29udGFpbnMgdGhlIHZhbHVlIGZvciB0
aGUgY29yZSBDUFUgUE1VLCB3aGljaCBpcyB1c3VhbGx5IDQuDQouUkUNCg0K
LlRQDQouSSAic2l6ZSINClRoZSBzaXplIG9mIHRoZQ0KLkkgcGVyZl9ldmVu
dF9hdHRyDQpzdHJ1Y3R1cmUgZm9yIGZvcndhcmQvYmFja3dhcmQgY29tcGF0
aWJpbGl0eS4NClNldCB0aGlzIHVzaW5nDQouSSBzaXplb2Yoc3RydWN0IHBl
cmZfZXZlbnRfYXR0cikNCnRvIGFsbG93IHRoZSBrZXJuZWwgdG8gc2VlDQp0
aGUgc3RydWN0IHNpemUgYXQgdGhlIHRpbWUgb2YgY29tcGlsYXRpb24uDQoN
ClRoZSByZWxhdGVkIGRlZmluZQ0KLkIgUEVSRl9BVFRSX1NJWkVfVkVSMA0K
aXMgc2V0IHRvIDY0OyB0aGlzIHdhcyB0aGUgc2l6ZSBvZiB0aGUgZmlyc3Qg
cHVibGlzaGVkIHN0cnVjdC4NCi5CIFBFUkZfQVRUUl9TSVpFX1ZFUjENCmlz
IDcyLCBjb3JyZXNwb25kaW5nIHRvIHRoZSBhZGRpdGlvbiBvZiBicmVha3Bv
aW50cyBpbiBMaW51eCAyLjYuMzMuDQouQiBQRVJGX0FUVFJfU0laRV9WRVIy
DQppcyA4MCBjb3JyZXNwb25kaW5nIHRvIHRoZSBhZGRpdGlvbiBvZiBicmFu
Y2ggc2FtcGxpbmcgaW4gTGludXggMy40Lg0KDQouVFANCi5JICJjb25maWci
DQpUaGlzIHNwZWNpZmllcyB3aGljaCBldmVudCB5b3Ugd2FudCwgaW4gY29u
anVuY3Rpb24gd2l0aA0KdGhlDQouSSB0eXBlDQpmaWVsZC4NClRoZQ0KLklS
IGNvbmZpZzEgIiBhbmQgIiBjb25maWcyDQpmaWVsZHMgYXJlIGFsc28gdGFr
ZW4gaW50byBhY2NvdW50IGluIGNhc2VzIHdoZXJlIDY0IGJpdHMgaXMgbm90
DQplbm91Z2ggdG8gZnVsbHkgc3BlY2lmeSB0aGUgZXZlbnQuDQpUaGUgZW5j
b2Rpbmcgb2YgdGhlc2UgZmllbGRzIGFyZSBldmVudCBkZXBlbmRlbnQuDQoN
ClRoZSBtb3N0IHNpZ25pZmljYW50IGJpdCAoYml0IDYzKSBvZg0KLkkgY29u
ZmlnDQpzaWduaWZpZXMgQ1BVLXNwZWNpZmljIChyYXcpIGNvdW50ZXIgY29u
ZmlndXJhdGlvbiBkYXRhOw0KaWYgdGhlIG1vc3Qgc2lnbmlmaWNhbnQgYml0
IGlzIHVuc2V0LCB0aGUgbmV4dCA3IGJpdHMgYXJlIGFuIGV2ZW50DQp0eXBl
IGFuZCB0aGUgcmVzdCBvZiB0aGUgYml0cyBhcmUgdGhlIGV2ZW50IGlkZW50
aWZpZXIuDQoNClRoZXJlIGFyZSB2YXJpb3VzIHdheXMgdG8gc2V0IHRoZQ0K
LkkgY29uZmlnDQpmaWVsZCB0aGF0IGFyZSBkZXBlbmRlbnQgb24gdGhlIHZh
bHVlIG9mIHRoZSBwcmV2aW91c2x5DQpkZXNjcmliZWQNCi5JIHR5cGUNCmZp
ZWxkLg0KV2hhdCBmb2xsb3dzIGFyZSB2YXJpb3VzIHBvc3NpYmxlIHNldHRp
bmdzIGZvcg0KLkkgY29uZmlnDQpzZXBhcmF0ZWQgb3V0IGJ5DQouSVIgdHlw
ZSAuDQoNCklmDQouSSB0eXBlDQppcw0KLkJSIFBFUkZfVFlQRV9IQVJEV0FS
RSAsDQp3ZSBhcmUgbWVhc3VyaW5nIG9uZSBvZiB0aGUgZ2VuZXJhbGl6ZWQg
aGFyZHdhcmUgQ1BVIGV2ZW50cy4NCk5vdCBhbGwgb2YgdGhlc2UgYXJlIGF2
YWlsYWJsZSBvbiBhbGwgcGxhdGZvcm1zLg0KU2V0DQouSSBjb25maWcNCnRv
IG9uZSBvZiB0aGUgZm9sbG93aW5nOg0KLlJTIDEyDQouVFANCi5CIFBFUkZf
Q09VTlRfSFdfQ1BVX0NZQ0xFUw0KVG90YWwgY3ljbGVzLg0KQmUgd2FyeSBv
ZiB3aGF0IGhhcHBlbnMgZHVyaW5nIENQVSBmcmVxdWVuY3kgc2NhbGluZw0K
LlRQDQouQiBQRVJGX0NPVU5UX0hXX0lOU1RSVUNUSU9OUw0KUmV0aXJlZCBp
bnN0cnVjdGlvbnMuDQpCZSBjYXJlZnVsLCB0aGVzZSBjYW4gYmUgYWZmZWN0
ZWQgYnkgdmFyaW91cw0KaXNzdWVzLCBtb3N0IG5vdGFibHkgaGFyZHdhcmUg
aW50ZXJydXB0IGNvdW50cw0KLlRQDQouQiBQRVJGX0NPVU5UX0hXX0NBQ0hF
X1JFRkVSRU5DRVMNCkNhY2hlIGFjY2Vzc2VzLg0KVXN1YWxseSB0aGlzIGlu
ZGljYXRlcyBMYXN0IExldmVsIENhY2hlIGFjY2Vzc2VzIGJ1dCB0aGlzIG1h
eQ0KdmFyeSBkZXBlbmRpbmcgb24geW91ciBDUFUuDQpUaGlzIG1heSBpbmNs
dWRlIHByZWZldGNoZXMgYW5kIGNvaGVyZW5jeSBtZXNzYWdlczsgYWdhaW4g
dGhpcw0KZGVwZW5kcyBvbiB0aGUgZGVzaWduIG9mIHlvdXIgQ1BVLg0KLlRQ
DQouQiBQRVJGX0NPVU5UX0hXX0NBQ0hFX01JU1NFUw0KQ2FjaGUgbWlzc2Vz
Lg0KVXN1YWxseSB0aGlzIGluZGljYXRlcyBMYXN0IExldmVsIENhY2hlIG1p
c3NlczsgdGhpcyBpcyBpbnRlbmRlZCB0byBiZQ0KdXNlZCBpbiBjb25qdW5j
dGlvbiB3aXRoIHRoZQ0KLkIgUEVSRl9DT1VOVF9IV19DQUNIRV9SRUZFUkVO
Q0VTDQpldmVudCB0byBjYWxjdWxhdGUgY2FjaGUgbWlzcyByYXRlcy4NCi5U
UA0KLkIgUEVSRl9DT1VOVF9IV19CUkFOQ0hfSU5TVFJVQ1RJT05TDQpSZXRp
cmVkIGJyYW5jaCBpbnN0cnVjdGlvbnMuDQpQcmlvciB0byBMaW51eCAyLjYu
MzQsIHRoaXMgdXNlZA0KdGhlIHdyb25nIGV2ZW50IG9uIEFNRCBwcm9jZXNz
b3JzLg0KLlRQDQouQiBQRVJGX0NPVU5UX0hXX0JSQU5DSF9NSVNTRVMNCk1p
c3ByZWRpY3RlZCBicmFuY2ggaW5zdHJ1Y3Rpb25zLg0KLlRQDQouQiBQRVJG
X0NPVU5UX0hXX0JVU19DWUNMRVMNCkJ1cyBjeWNsZXMsIHdoaWNoIGNhbiBi
ZSBkaWZmZXJlbnQgZnJvbSB0b3RhbCBjeWNsZXMuDQouVFANCi5CUiBQRVJG
X0NPVU5UX0hXX1NUQUxMRURfQ1lDTEVTX0ZST05URU5EICIgKFNpbmNlIExp
bnV4IDMuMCkiDQpTdGFsbGVkIGN5Y2xlcyBkdXJpbmcgaXNzdWUuDQouVFAN
Ci5CUiBQRVJGX0NPVU5UX0hXX1NUQUxMRURfQ1lDTEVTX0JBQ0tFTkQgICIg
KFNpbmNlIExpbnV4IDMuMCkiDQpTdGFsbGVkIGN5Y2xlcyBkdXJpbmcgcmV0
aXJlbWVudC4NCi5UUA0KLkJSIFBFUkZfQ09VTlRfSFdfUkVGX0NQVV9DWUNM
RVMgICIgKFNpbmNlIExpbnV4IDMuMykiDQpUb3RhbCBjeWNsZXM7IG5vdCBh
ZmZlY3RlZCBieSBDUFUgZnJlcXVlbmN5IHNjYWxpbmcuDQouUkUNCi5JUA0K
SWYNCi5JIHR5cGUNCmlzDQouQlIgUEVSRl9UWVBFX1NPRlRXQVJFICwNCndl
IGFyZSBtZWFzdXJpbmcgc29mdHdhcmUgZXZlbnRzIHByb3ZpZGVkIGJ5IHRo
ZSBrZXJuZWwuDQpTZXQNCi5JIGNvbmZpZw0KdG8gb25lIG9mIHRoZSBmb2xs
b3dpbmc6DQouUlMgMTINCi5UUA0KLkIgUEVSRl9DT1VOVF9TV19DUFVfQ0xP
Q0sNClRoaXMgcmVwb3J0cyB0aGUgQ1BVIGNsb2NrLCBhIGhpZ2gtcmVzb2x1
dGlvbiBwZXItQ1BVIHRpbWVyLg0KLlRQDQouQiBQRVJGX0NPVU5UX1NXX1RB
U0tfQ0xPQ0sNClRoaXMgcmVwb3J0cyBhIGNsb2NrIGNvdW50IHNwZWNpZmlj
IHRvIHRoZSB0YXNrIHRoYXQgaXMgcnVubmluZy4NCi5UUA0KLkIgUEVSRl9D
T1VOVF9TV19QQUdFX0ZBVUxUUw0KVGhpcyByZXBvcnRzIHRoZSBudW1iZXIg
b2YgcGFnZSBmYXVsdHMuDQouVFANCi5CIFBFUkZfQ09VTlRfU1dfQ09OVEVY
VF9TV0lUQ0hFUw0KVGhpcyBjb3VudHMgY29udGV4dCBzd2l0Y2hlcy4NClVu
dGlsIExpbnV4IDIuNi4zNCwgdGhlc2Ugd2VyZSBhbGwgcmVwb3J0ZWQgYXMg
dXNlci1zcGFjZQ0KZXZlbnRzLCBhZnRlciB0aGF0IHRoZXkgYXJlIHJlcG9y
dGVkIGFzIGhhcHBlbmluZyBpbiB0aGUga2VybmVsLg0KLlRQDQouQiBQRVJG
X0NPVU5UX1NXX0NQVV9NSUdSQVRJT05TDQpUaGlzIHJlcG9ydHMgdGhlIG51
bWJlciBvZiB0aW1lcyB0aGUgcHJvY2Vzcw0KaGFzIG1pZ3JhdGVkIHRvIGEg
bmV3IENQVS4NCi5UUA0KLkIgUEVSRl9DT1VOVF9TV19QQUdFX0ZBVUxUU19N
SU4NClRoaXMgY291bnRzIHRoZSBudW1iZXIgb2YgbWlub3IgcGFnZSBmYXVs
dHMuDQpUaGVzZSBkaWQgbm90IHJlcXVpcmUgZGlzayBJL08gdG8gaGFuZGxl
Lg0KLlRQDQouQiBQRVJGX0NPVU5UX1NXX1BBR0VfRkFVTFRTX01BSg0KVGhp
cyBjb3VudHMgdGhlIG51bWJlciBvZiBtYWpvciBwYWdlIGZhdWx0cy4NClRo
ZXNlIHJlcXVpcmVkIGRpc2sgSS9PIHRvIGhhbmRsZS4NCi5UUA0KLkJSIFBF
UkZfQ09VTlRfU1dfQUxJR05NRU5UX0ZBVUxUUyAiIChTaW5jZSBMaW51eCAy
LjYuMzMpIg0KVGhpcyBjb3VudHMgdGhlIG51bWJlciBvZiBhbGlnbm1lbnQg
ZmF1bHRzLg0KVGhlc2UgaGFwcGVuIHdoZW4gdW5hbGlnbmVkIG1lbW9yeSBh
Y2Nlc3NlcyBoYXBwZW47IHRoZSBrZXJuZWwNCmNhbiBoYW5kbGUgdGhlc2Ug
YnV0IGl0IHJlZHVjZXMgcGVyZm9ybWFuY2UuDQpUaGlzIG9ubHkgaGFwcGVu
cyBvbiBzb21lIGFyY2hpdGVjdHVyZXMgKG5ldmVyIG9uIHg4NikuDQouVFAN
Ci5CUiBQRVJGX0NPVU5UX1NXX0VNVUxBVElPTl9GQVVMVFMgIiAoU2luY2Ug
TGludXggMi42LjMzKSINClRoaXMgY291bnRzIHRoZSBudW1iZXIgb2YgZW11
bGF0aW9uIGZhdWx0cy4NClRoZSBrZXJuZWwgc29tZXRpbWVzIHRyYXBzIG9u
IHVuaW1wbGVtZW50ZWQgaW5zdHJ1Y3Rpb25zDQphbmQgZW11bGF0ZXMgdGhl
bSBmb3IgdXNlcnNwYWNlLg0KVGhpcyBjYW4gbmVnYXRpdmVseSBpbXBhY3Qg
cGVyZm9ybWFuY2UuDQouUkUNCi5SRQ0KDQoNCi5SUw0KSWYNCi5JIHR5cGUN
CmlzDQouQlIgUEVSRl9UWVBFX1RSQUNFUE9JTlQgLA0KdGhlbiB3ZSBhcmUg
bWVhc3VyaW5nIGtlcm5lbCB0cmFjZXBvaW50cy4NClRoZSB2YWx1ZSB0byB1
c2UgaW4NCi5JIGNvbmZpZw0KY2FuIGJlIG9idGFpbmVkIGZyb20gdW5kZXIg
ZGVidWdmcw0KLkkgdHJhY2luZy9ldmVudHMvKi8qL2lkDQppZiBmdHJhY2Ug
aXMgZW5hYmxlZCBpbiB0aGUga2VybmVsLg0KDQouUkUNCg0KLlJTDQpJZg0K
LkkgdHlwZQ0KaXMNCi5CUiBQRVJGX1RZUEVfSFdfQ0FDSEUgLA0KdGhlbiB3
ZSBhcmUgbWVhc3VyaW5nIGEgaGFyZHdhcmUgQ1BVIGNhY2hlIGV2ZW50Lg0K
VG8gY2FsY3VsYXRlIHRoZSBhcHByb3ByaWF0ZQ0KLkkgY29uZmlnDQp2YWx1
ZSB1c2UgdGhlIGZvbGxvd2luZyBlcXVhdGlvbjoNCi5SUyA0DQoubmYNCg0K
ICAgIChwZXJmX2h3X2NhY2hlX2lkKSB8IChwZXJmX2h3X2NhY2hlX29wX2lk
IDw8IDgpIHwNCiAgICAocGVyZl9od19jYWNoZV9vcF9yZXN1bHRfaWQgPDwg
MTYpDQouZmkNCi5QDQp3aGVyZQ0KLkkgcGVyZl9od19jYWNoZV9pZA0KaXMg
b25lIG9mOg0KLlJTDQouVFANCi5CIFBFUkZfQ09VTlRfSFdfQ0FDSEVfTDFE
DQpmb3IgbWVhc3VyaW5nIExldmVsIDEgRGF0YSBDYWNoZQ0KLlRQDQouQiBQ
RVJGX0NPVU5UX0hXX0NBQ0hFX0wxSQ0KZm9yIG1lYXN1cmluZyBMZXZlbCAx
IEluc3RydWN0aW9uIENhY2hlDQouVFANCi5CIFBFUkZfQ09VTlRfSFdfQ0FD
SEVfTEwNCmZvciBtZWFzdXJpbmcgTGFzdC1MZXZlbCBDYWNoZQ0KLlRQDQou
QiBQRVJGX0NPVU5UX0hXX0NBQ0hFX0RUTEINCmZvciBtZWFzdXJpbmcgdGhl
IERhdGEgVExCDQouVFANCi5CIFBFUkZfQ09VTlRfSFdfQ0FDSEVfSVRMQg0K
Zm9yIG1lYXN1cmluZyB0aGUgSW5zdHJ1Y3Rpb24gVExCDQouVFANCi5CIFBF
UkZfQ09VTlRfSFdfQ0FDSEVfQlBVDQpmb3IgbWVhc3VyaW5nIHRoZSBicmFu
Y2ggcHJlZGljdGlvbiB1bml0DQouVFANCi5CUiBQRVJGX0NPVU5UX0hXX0NB
Q0hFX05PREUgIiAoU2luY2UgTGludXggMy4wKSINCmZvciBtZWFzdXJpbmcg
bG9jYWwgbWVtb3J5IGFjY2Vzc2VzDQouUkUNCg0KLlANCmFuZA0KLkkgcGVy
Zl9od19jYWNoZV9vcF9pZA0KaXMgb25lIG9mDQouUlMNCi5UUA0KLkIgUEVS
Rl9DT1VOVF9IV19DQUNIRV9PUF9SRUFEDQpmb3IgcmVhZCBhY2Nlc3Nlcw0K
LlRQDQouQiBQRVJGX0NPVU5UX0hXX0NBQ0hFX09QX1dSSVRFDQpmb3Igd3Jp
dGUgYWNjZXNzZXMNCi5UUA0KLkIgUEVSRl9DT1VOVF9IV19DQUNIRV9PUF9Q
UkVGRVRDSA0KZm9yIHByZWZldGNoIGFjY2Vzc2VzDQouUkUNCg0KLlANCmFu
ZA0KLkkgcGVyZl9od19jYWNoZV9vcF9yZXN1bHRfaWQNCmlzIG9uZSBvZg0K
LlJTDQouVFANCi5CIFBFUkZfQ09VTlRfSFdfQ0FDSEVfUkVTVUxUX0FDQ0VT
Uw0KdG8gbWVhc3VyZSBhY2Nlc3Nlcw0KLlRQDQouQiBQRVJGX0NPVU5UX0hX
X0NBQ0hFX1JFU1VMVF9NSVNTDQp0byBtZWFzdXJlIG1pc3Nlcw0KLlJFDQou
UkUNCg0KSWYNCi5JIHR5cGUNCmlzDQouQlIgUEVSRl9UWVBFX1JBVyAsDQp0
aGVuIGEgY3VzdG9tICJyYXciDQouSSBjb25maWcNCnZhbHVlIGlzIG5lZWRl
ZC4NCk1vc3QgQ1BVcyBzdXBwb3J0IGV2ZW50cyB0aGF0IGFyZSBub3QgY292
ZXJlZCBieSB0aGUgImdlbmVyYWxpemVkIiBldmVudHMuDQpUaGVzZSBhcmUg
aW1wbGVtZW50YXRpb24gZGVmaW5lZDsgc2VlIHlvdXIgQ1BVIG1hbnVhbCAo
Zm9yIGV4YW1wbGUNCnRoZSBJbnRlbCBWb2x1bWUgM0IgZG9jdW1lbnRhdGlv
biBvciB0aGUgQU1EIEJJT1MgYW5kIEtlcm5lbCBEZXZlbG9wZXINCkd1aWRl
KS4NClRoZSBsaWJwZm00IGxpYnJhcnkgY2FuIGJlIHVzZWQgdG8gdHJhbnNs
YXRlIGZyb20gdGhlIG5hbWUgaW4gdGhlDQphcmNoaXRlY3R1cmFsIG1hbnVh
bHMgdG8gdGhlIHJhdyBoZXggdmFsdWUNCi5CUiBwZXJmX2V2ZW50X29wZW4g
KCkNCmV4cGVjdHMgaW4gdGhpcyBmaWVsZC4NCg0KSWYNCi5JIHR5cGUNCmlz
DQouQlIgUEVSRl9UWVBFX0JSRUFLUE9JTlQgLA0KdGhlbiBsZWF2ZQ0KLkkg
Y29uZmlnDQpzZXQgdG8gemVyby4NCkl0cyBwYXJhbWV0ZXJzIGFyZSBzZXQg
aW4gb3RoZXIgcGxhY2VzLg0KLlJFDQouVFANCi5JUiBzYW1wbGVfcGVyaW9k
ICIsICIgc2FtcGxlX2ZyZXENCkEgInNhbXBsaW5nIiBjb3VudGVyIGlzIG9u
ZSB0aGF0IGdlbmVyYXRlcyBhbiBpbnRlcnJ1cHQNCmV2ZXJ5IE4gZXZlbnRz
LCB3aGVyZSBOIGlzIGdpdmVuIGJ5DQouSVIgc2FtcGxlX3BlcmlvZCAuDQpB
IHNhbXBsaW5nIGNvdW50ZXIgaGFzDQouSVIgc2FtcGxlX3BlcmlvZCAiID4g
MC4iDQpUaGUNCi5JIHNhbXBsZV90eXBlDQpmaWVsZCBjb250cm9scyB3aGF0
IGRhdGEgaXMgcmVjb3JkZWQgb24gZWFjaCBpbnRlcnJ1cHQuDQoNCi5JIHNh
bXBsZV9mcmVxDQpjYW4gYmUgdXNlZCBpZiB5b3Ugd2lzaCB0byB1c2UgZnJl
cXVlbmN5IHJhdGhlciB0aGFuIHBlcmlvZC4NCkluIHRoaXMgY2FzZSB5b3Ug
c2V0IHRoZQ0KLkkgZnJlcQ0KZmxhZy4NClRoZSBrZXJuZWwgd2lsbCBhZGp1
c3QgdGhlIHNhbXBsaW5nIHBlcmlvZA0KdG8gdHJ5IGFuZCBhY2hpZXZlIHRo
ZSBkZXNpcmVkIHJhdGUuDQpUaGUgcmF0ZSBvZiBhZGp1c3RtZW50IGlzIGEN
CnRpbWVyIHRpY2suDQoNCg0KLlRQDQouSSAic2FtcGxlX3R5cGUiDQpUaGUg
dmFyaW91cyBiaXRzIGluIHRoaXMgZmllbGQgc3BlY2lmeSB3aGljaCB2YWx1
ZXMgdG8gaW5jbHVkZQ0KaW4gdGhlIG92ZXJmbG93IHBhY2tldHMuDQpUaGV5
IHdpbGwgYmUgcmVjb3JkZWQgaW4gYSByaW5nLWJ1ZmZlciwNCndoaWNoIGlz
IGF2YWlsYWJsZSB0byB1c2VyLXNwYWNlIHVzaW5nDQouQlIgbW1hcCAoMiku
DQpUaGUgb3JkZXIgaW4gd2hpY2ggdGhlIHZhbHVlcyBhcmUgc2F2ZWQgaW4g
dGhlDQpvdmVyZmxvdyBwYWNrZXRzIGFzIGRvY3VtZW50ZWQgaW4gdGhlIE1N
QVAgTGF5b3V0IHN1YnNlY3Rpb24gYmVsb3c7DQppdCBpcyBub3QgdGhlDQou
SSAiZW51bSBwZXJmX2V2ZW50X3NhbXBsZV9mb3JtYXQiDQpvcmRlci4NCi5S
Uw0KLlRQDQouQiBQRVJGX1NBTVBMRV9JUA0KaW5zdHJ1Y3Rpb24gcG9pbnRl
cg0KLlRQDQouQiBQRVJGX1NBTVBMRV9USUQNCnRocmVhZCBpZA0KLlRQDQou
QiBQRVJGX1NBTVBMRV9USU1FDQp0aW1lDQouVFANCi5CIFBFUkZfU0FNUExF
X0FERFINCmFkZHJlc3MNCi5UUA0KLkIgUEVSRl9TQU1QTEVfUkVBRA0KW1Rv
IGJlIGRvY3VtZW50ZWRdDQouVFANCi5CIFBFUkZfU0FNUExFX0NBTExDSEFJ
Tg0KW1RvIGJlIGRvY3VtZW50ZWRdDQouVFANCi5CIFBFUkZfU0FNUExFX0lE
DQpbVG8gYmUgZG9jdW1lbnRlZF0NCi5UUA0KLkIgUEVSRl9TQU1QTEVfQ1BV
DQpbVG8gYmUgZG9jdW1lbnRlZF0NCi5UUA0KLkIgUEVSRl9TQU1QTEVfUEVS
SU9EDQpbVG8gYmUgZG9jdW1lbnRlZF0NCi5UUA0KLkIgUEVSRl9TQU1QTEVf
U1RSRUFNX0lEDQpbVG8gYmUgZG9jdW1lbnRlZF0NCi5UUA0KLkIgUEVSRl9T
QU1QTEVfUkFXDQpbVG8gYmUgZG9jdW1lbnRlZF0NCi5UUA0KLkJSIFBFUkZf
U0FNUExFX0JSQU5DSF9TVEFDSyAiIChTaW5jZSBMaW51eCAzLjQpIg0KW1Rv
IGJlIGRvY3VtZW50ZWRdDQouUkUNCg0KLlRQDQouSVIgInJlYWRfZm9ybWF0
Ig0KVGhpcyBmaWVsZCBzcGVjaWZpZXMgdGhlIGZvcm1hdCBvZiB0aGUgZGF0
YSByZXR1cm5lZCBieQ0KLkJSIHJlYWQgKDIpDQpvbiBhDQouQlIgcGVyZl9l
dmVudF9vcGVuKCkNCmZpbGUgZGVzY3JpcHRvci4NCi5SUw0KLlRQDQouQiBQ
RVJGX0ZPUk1BVF9UT1RBTF9USU1FX0VOQUJMRUQNCkFkZHMgdGhlIDY0LWJp
dCAidGltZV9lbmFibGVkIiBmaWVsZC4NClRoaXMgY2FuIGJlIHVzZWQgdG8g
Y2FsY3VsYXRlIGVzdGltYXRlZCB0b3RhbHMgaWYNCnRoZSBQTVUgaXMgb3Zl
cmNvbW1pdHRlZCBhbmQgbXVsdGlwbGV4aW5nIGlzIGhhcHBlbmluZy4NCi5U
UA0KLkIgUEVSRl9GT1JNQVRfVE9UQUxfVElNRV9SVU5OSU5HDQpBZGRzIHRo
ZSA2NC1iaXQgInRpbWVfcnVubmluZyIgZmllbGQuDQpUaGlzIGNhbiBiZSB1
c2VkIHRvIGNhbGN1bGF0ZSBlc3RpbWF0ZWQgdG90YWxzIGlmDQp0aGUgUE1V
IGlzIG92ZXJjb21taXR0ZWQgYW5kICBtdWx0aXBsZXhpbmcgaXMgaGFwcGVu
aW5nLg0KLlRQDQouQiBQRVJGX0ZPUk1BVF9JRA0KQWRkcyBhIDY0LWJpdCB1
bmlxdWUgdmFsdWUgdGhhdCBjb3JyZXNwb25kcyB0byB0aGUgZXZlbnQtZ3Jv
dXAuDQouVFANCi5CIFBFUkZfRk9STUFUX0dST1VQDQpBbGxvd3MgYWxsIGNv
dW50ZXIgdmFsdWVzIGluIGFuIGV2ZW50LWdyb3VwIHRvIGJlIHJlYWQgd2l0
aCBvbmUgcmVhZC4NCi5SRQ0KDQouVFANCi5JUiAiZGlzYWJsZWQiDQpUaGUN
Ci5JIGRpc2FibGVkDQpiaXQgc3BlY2lmaWVzIHdoZXRoZXIgdGhlIGNvdW50
ZXIgc3RhcnRzIG91dCBkaXNhYmxlZCBvciBlbmFibGVkLg0KSWYgZGlzYWJs
ZWQsIHRoZSBldmVudCBjYW4gbGF0ZXIgYmUgZW5hYmxlZCBieQ0KLkJSIGlv
Y3RsICgyKSwNCi5CUiBwcmN0bCAoMiksDQpvcg0KLklSIGVuYWJsZV9vbl9l
eGVjIC4NCg0KLlRQDQouSVIgImluaGVyaXQiDQpUaGUNCi5JIGluaGVyaXQN
CmJpdCBzcGVjaWZpZXMgdGhhdCB0aGlzIGNvdW50ZXIgc2hvdWxkIGNvdW50
IGV2ZW50cyBvZiBjaGlsZA0KdGFza3MgYXMgd2VsbCBhcyB0aGUgdGFzayBz
cGVjaWZpZWQuDQpUaGlzIG9ubHkgYXBwbGllcyB0byBuZXcgY2hpbGRyZW4s
IG5vdCB0byBhbnkgZXhpc3RpbmcgY2hpbGRyZW4gYXQNCnRoZSB0aW1lIHRo
ZSBjb3VudGVyIGlzIGNyZWF0ZWQgKG5vciB0byBhbnkgbmV3IGNoaWxkcmVu
IG9mDQpleGlzdGluZyBjaGlsZHJlbikuDQoNCkluaGVyaXQgZG9lcyBub3Qg
d29yayBmb3Igc29tZSBjb21iaW5hdGlvbnMgb2YNCi5JUiByZWFkX2Zvcm1h
dCBzLA0Kc3VjaCBhcw0KLkJSIFBFUkZfRk9STUFUX0dST1VQIC4NCg0KLlRQ
DQouSVIgInBpbm5lZCINClRoZQ0KLkkgcGlubmVkDQpiaXQgc3BlY2lmaWVz
IHRoYXQgdGhlIGNvdW50ZXIgc2hvdWxkIGFsd2F5cyBiZSBvbiB0aGUgQ1BV
IGlmIGF0IGFsbA0KcG9zc2libGUuDQpJdCBvbmx5IGFwcGxpZXMgdG8gaGFy
ZHdhcmUgY291bnRlcnMgYW5kIG9ubHkgdG8gZ3JvdXAgbGVhZGVycy4NCklm
IGEgcGlubmVkIGNvdW50ZXIgY2Fubm90IGJlIHB1dCBvbnRvIHRoZSBDUFUg
KGUuZy4sIGJlY2F1c2UgdGhlcmUgYXJlDQpub3QgZW5vdWdoIGhhcmR3YXJl
IGNvdW50ZXJzIG9yIGJlY2F1c2Ugb2YgYSBjb25mbGljdCB3aXRoIHNvbWUg
b3RoZXINCmV2ZW50KSwgdGhlbiB0aGUgY291bnRlciBnb2VzIGludG8gYW4g
J2Vycm9yJyBzdGF0ZSwgd2hlcmUgcmVhZHMNCnJldHVybiBlbmQtb2YtZmls
ZSAoaS5lLiwNCi5CUiByZWFkICgyKQ0KcmV0dXJucyAwKSB1bnRpbCB0aGUg
Y291bnRlciBpcyBzdWJzZXF1ZW50bHkgZW5hYmxlZCBvciBkaXNhYmxlZC4N
Cg0KLlRQDQouSVIgImV4Y2x1c2l2ZSINClRoZQ0KLkkgZXhjbHVzaXZlDQpi
aXQgc3BlY2lmaWVzIHRoYXQgd2hlbiB0aGlzIGNvdW50ZXIncyBncm91cCBp
cyBvbiB0aGUgQ1BVLA0KaXQgc2hvdWxkIGJlIHRoZSBvbmx5IGdyb3VwIHVz
aW5nIHRoZSBDUFUncyBjb3VudGVycy4NCkluIHRoZSBmdXR1cmUgdGhpcyBt
YXkgYWxsb3cgbW9uaXRvcmluZyBwcm9ncmFtcyB0bw0Kc3VwcG9ydCBQTVUg
ZmVhdHVyZXMgdGhhdCBuZWVkIHRvIHJ1biBhbG9uZSBzbyB0aGF0IHRoZXkg
ZG8gbm90DQpkaXNydXB0IG90aGVyIGhhcmR3YXJlIGNvdW50ZXJzLg0KDQou
VFANCi5JUiAiZXhjbHVkZV91c2VyIg0KSWYgdGhpcyBiaXQgaXMgc2V0LCB0
aGUgY291bnQgZXhjbHVkZXMgZXZlbnRzIHRoYXQgaGFwcGVuIGluIHVzZXIt
c3BhY2UuDQoNCi5UUA0KLklSICJleGNsdWRlX2tlcm5lbCINCklmIHRoaXMg
Yml0IGlzIHNldCwgdGhlIGNvdW50IGV4Y2x1ZGVzIGV2ZW50cyB0aGF0IGhh
cHBlbiBpbiBrZXJuZWwtc3BhY2UuDQoNCi5UUA0KLklSICJleGNsdWRlX2h2
Ig0KSWYgdGhpcyBiaXQgaXMgc2V0LCB0aGUgY291bnQgZXhjbHVkZXMgZXZl
bnRzIHRoYXQgaGFwcGVuIGluIHRoZQ0KaHlwZXJ2aXNvci4NClRoaXMgaXMg
bWFpbmx5IGZvciBQTVVzIHRoYXQgaGF2ZSBidWlsdC1pbiBzdXBwb3J0IGZv
ciBoYW5kbGluZyB0aGlzDQooc3VjaCBhcyBQT1dFUikuDQpFeHRyYSBzdXBw
b3J0IGlzIG5lZWRlZCBmb3IgaGFuZGxpbmcgaHlwZXJ2aXNvciBtZWFzdXJl
bWVudHMgb24gbW9zdA0KbWFjaGluZXMuDQoNCi5UUA0KLklSICJleGNsdWRl
X2lkbGUiDQpJZiBzZXQsIGRvbid0IGNvdW50IHdoZW4gdGhlIENQVSBpcyBp
ZGxlLg0KDQouVFANCi5JUiAibW1hcCINClRoZQ0KLkkgbW1hcA0KYml0IGVu
YWJsZXMgcmVjb3JkaW5nIG9mIGV4dHJhIGluZm9ybWF0aW9uIHRvIGENCm1t
YXAnZCByaW5nLWJ1ZmZlci4NClRoaXMgaXMNCmRlc2NyaWJlZCBiZWxvdyBp
biBzdWJzZWN0aW9uIE1NQVAgTGF5b3V0Lg0KDQouVFANCi5JUiAiY29tbSIN
ClRoZQ0KLkkgY29tbQ0KYml0IGVuYWJsZXMgdHJhY2tpbmcgb2YgcHJvY2Vz
cyBjb21tYW5kIG5hbWUgYXMgbW9kaWZpZWQgYnkgdGhlDQouSVIgZXhlYyAo
MikNCmFuZA0KLklSIHByY3RsIChQUl9TRVRfTkFNRSkNCnN5c3RlbSBjYWxs
cy4NClVuZm9ydHVuYXRlbHkgZm9yIHRvb2xzLA0KdGhlcmUgaXMgbm8gd2F5
IHRvIGRpc3Rpbmd1aXNoIG9uZSBzeXN0ZW0gY2FsbCB2ZXJzdXMgdGhlIG90
aGVyLg0KDQouVFANCi5JUiAiZnJlcSINCklmIHRoaXMgYml0IGlzIHNldCwg
dGhlbg0KLkkgc2FtcGxlX2ZyZXF1ZW5jeQ0Kbm90DQouSSBzYW1wbGVfcGVy
aW9kDQppcyB1c2VkIHdoZW4gc2V0dGluZyB1cCB0aGUgc2FtcGxpbmcgaW50
ZXJ2YWwuDQoNCi5UUA0KLklSICJpbmhlcml0X3N0YXQiDQpUaGlzIGJpdCBl
bmFibGVzIHNhdmluZyBvZiBldmVudCBjb3VudHMgb24gY29udGV4dCBzd2l0
Y2ggZm9yDQppbmhlcml0ZWQgdGFza3MuDQpUaGlzIGlzIG9ubHkgbWVhbmlu
Z2Z1bCBpZiB0aGUNCi5JIGluaGVyaXQNCmZpZWxkIGlzIHNldC4NCg0KLlRQ
DQouSVIgImVuYWJsZV9vbl9leGVjIg0KSWYgdGhpcyBiaXQgaXMgc2V0LCBh
IGNvdW50ZXIgaXMgYXV0b21hdGljYWxseQ0KZW5hYmxlZCBhZnRlciBhIGNh
bGwgdG8NCi5CUiBleGVjICgyKS4NCg0KLlRQDQouSVIgInRhc2siDQpJZiB0
aGlzIGJpdCBpcyBzZXQsIHRoZW4NCmZvcmsvZXhpdCBub3RpZmljYXRpb25z
IGFyZSBpbmNsdWRlZCBpbiB0aGUgcmluZyBidWZmZXIuDQoNCi5UUA0KLklS
ICJ3YXRlcm1hcmsiDQpJZiBzZXQsIGhhdmUgYSBzYW1wbGluZyBpbnRlcnJ1
cHQgaGFwcGVuIHdoZW4gd2UgY3Jvc3MgdGhlDQp3YWtldXBfd2F0ZXJtYXJr
IGJvdW5kYXJ5Lg0KDQouVFANCi5JUiAicHJlY2lzZV9pcCIgIiAoU2luY2Ug
TGludXggMi42LjM1KSINClRoaXMgY29udHJvbHMgdGhlIGFtb3VudCBvZiBz
a2lkLg0KU2tpZCBpcyBob3cgbWFueSBpbnN0cnVjdGlvbnMNCmV4ZWN1dGUg
YmV0d2VlbiBhbiBldmVudCBvZiBpbnRlcmVzdCBoYXBwZW5pbmcgYW5kIHRo
ZSBrZXJuZWwNCmJlaW5nIGFibGUgdG8gc3RvcCBhbmQgcmVjb3JkIHRoZSBl
dmVudC4NClNtYWxsZXIgc2tpZCBpcw0KYmV0dGVyIGFuZCBhbGxvd3MgbW9y
ZSBhY2N1cmF0ZSByZXBvcnRpbmcgb2Ygd2hpY2ggZXZlbnRzDQpjb3JyZXNw
b25kIHRvIHdoaWNoIGluc3RydWN0aW9ucywgYnV0IGhhcmR3YXJlIGlzIG9m
dGVuIGxpbWl0ZWQNCndpdGggaG93IHNtYWxsIHRoaXMgY2FuIGJlLg0KDQpU
aGUgdmFsdWVzIG9mIHRoaXMgYXJlIHRoZSBmb2xsb3dpbmc6DQouUlMNCi5U
UA0KMCAtDQouQiBTQU1QTEVfSVANCmNhbiBoYXZlIGFyYml0cmFyeSBza2lk
DQouVFANCjEgLQ0KLkIgU0FNUExFX0lQDQptdXN0IGhhdmUgY29uc3RhbnQg
c2tpZA0KLlRQDQoyIC0NCi5CIFNBTVBMRV9JUA0KcmVxdWVzdGVkIHRvIGhh
dmUgMCBza2lkDQouVFANCjMgLQ0KLkIgU0FNUExFX0lQDQptdXN0IGhhdmUg
MCBza2lkLg0KU2VlIGFsc28NCi5CUiBQRVJGX1JFQ09SRF9NSVNDX0VYQUNU
X0lQIC4NCi5SRQ0KDQouVFANCi5JUiAibW1hcF9kYXRhIiAiIChTaW5jZSBM
aW51eCAyLjYuMzYpIg0KSW5jbHVkZSBtbWFwIGV2ZW50cyBpbiB0aGUgcmlu
Z19idWZmZXIuDQoNCi5UUA0KLklSICJzYW1wbGVfaWRfYWxsIiAiIChTaW5j
ZSBMaW51eCAyLjYuMzgpIg0KSWYgc2V0LCB0aGVuIGFsbCBzYW1wbGUgSUQg
aW5mbyAoVElELCBUSU1FLCBJRCwgQ1BVLCBTVFJFQU1fSUQpDQp3aWxsIGJl
IHByb3ZpZGVkLg0KDQouVFANCi5JUiAiZXhjbHVkZV9ob3N0IiAiIChTaW5j
ZSBMaW51eCAzLjIpIg0KRG8gbm90IG1lYXN1cmUgdGltZSBzcGVudCBpbiBW
TSBob3N0DQoNCi5UUA0KLklSICJleGNsdWRlX2d1ZXN0IiAiIChTaW5jZSBM
aW51eCAzLjIpIg0KRG8gbm90IG1lYXN1cmUgdGltZSBzcGVudCBpbiBWTSBn
dWVzdA0KDQoNCi5UUA0KLklSICJ3YWtldXBfZXZlbnRzIiAiLCAiICJ3YWtl
dXBfd2F0ZXJtYXJrIg0KVGhpcyB1bmlvbiBzZXRzIGhvdyBtYW55IGV2ZW50
cw0KLlJJICggd2FrZXVwX2V2ZW50cyApDQpvciBieXRlcw0KLlJJICggd2Fr
ZXVwX3dhdGVybWFyayApDQpoYXBwZW4gYmVmb3JlIGFuIG92ZXJmbG93IHNp
Z25hbCBoYXBwZW5zLg0KV2hpY2ggb25lIGlzIHVzZWQgaXMgc2VsZWN0ZWQg
YnkgdGhlDQouSSB3YXRlcm1hcmsNCmJpdGZsYWcuDQoNCi5UUA0KLklSICJi
cF90eXBlIiAiIChTaW5jZSBMaW51eCAyLjYuMzMpIg0KVGhpcyBjaG9vc2Vz
IHRoZSBicmVha3BvaW50IHR5cGUuDQpJdCBpcyBvbmUgb2Y6DQouUlMNCi5U
UA0KLkJSIEhXX0JSRUFLUE9JTlRfRU1QVFkNCm5vIGJyZWFrcG9pbnQNCi5U
UA0KLkJSIEhXX0JSRUFLUE9JTlRfUg0KY291bnQgd2hlbiB3ZSByZWFkIHRo
ZSBtZW1vcnkgbG9jYXRpb24NCi5UUA0KLkJSIEhXX0JSRUFLUE9JTlRfVw0K
Y291bnQgd2hlbiB3ZSB3cml0ZSB0aGUgbWVtb3J5IGxvY2F0aW9uDQouVFAN
Ci5CUiBIV19CUkVBS1BPSU5UX1JXDQpjb3VudCB3aGVuIHdlIHJlYWQgb3Ig
d3JpdGUgdGhlIG1lbW9yeSBsb2NhdGlvbg0KLlRQDQouQlIgSFdfQlJFQUtQ
T0lOVF9YDQpjb3VudCB3aGVuIHdlIGV4ZWN1dGUgY29kZSBhdCB0aGUgbWVt
b3J5IGxvY2F0aW9uDQoNCi5MUA0KVGhlIHZhbHVlcyBjYW4gYmUgY29tYmlu
ZWQgdmlhIGEgYml0d3NpZSBvciwgYnV0IHRoZQ0KY29tYmluYXRpb24gb2YN
Ci5CIEhXX0JSRUFLUE9JTlRfUg0Kb3INCi5CIEhXX0JSRUFLUE9JTlRfVw0K
d2l0aA0KLkIgSFdfQlJFQUtQT0lOVF9YDQppcyBub3QgYWxsb3dlZC4NCi5S
RQ0KDQouVFANCi5JUiAiYnBfYWRkciIgIiAoU2luY2UgTGludXggMi42LjMz
KSINCi5JIGJwX2FkZHINCmFkZHJlc3Mgb2YgdGhlIGJyZWFrcG9pbnQuDQpG
b3IgZXhlY3V0aW9uIGJyZWFrcG9pbnRzIHRoaXMgaXMgdGhlIG1lbW9yeSBh
ZGRyZXNzIG9mIHRoZSBpbnN0cnVjdGlvbg0Kb2YgaW50ZXJlc3Q7IGZvciBy
ZWFkIGFuZCB3cml0ZSBicmVha3BvaW50cyBpdCBpcyB0aGUgbWVtb3J5IGFk
ZHJlc3MNCm9mIHRoZSBtZW1vcnkgbG9jYXRpb24gb2YgaW50ZXJlc3QuDQoN
Ci5UUA0KLklSICJjb25maWcxIiAiIChTaW5jZSBMaW51eCAyLjYuMzkpIg0K
LkkgY29uZmlnMQ0KaXMgdXNlZCBmb3Igc2V0dGluZyBldmVudHMgdGhhdCBu
ZWVkIGFuIGV4dHJhIHJlZ2lzdGVyIG9yIG90aGVyd2lzZQ0KZG8gbm90IGZp
dCBpbiB0aGUgcmVndWxhciBjb25maWcgZmllbGQuDQpSYXcgT0ZGQ09SRV9F
VkVOVFMgb24gTmVoYWxlbS9XZXN0bWVyZS9TYW5keUJyaWRnZSB1c2UgdGhp
cyBmaWVsZA0Kb24gMy4zIGFuZCBsYXRlciBrZXJuZWxzLg0KDQouVFANCi5J
UiAiYnBfbGVuIiAiIChTaW5jZSBMaW51eCAyLjYuMzMpIg0KLkkgYnBfbGVu
DQppcyB0aGUgbGVuZ3RoIG9mIHRoZSBicmVha3BvaW50IGJlaW5nIG1lYXN1
cmVkIGlmDQouSSB0eXBlDQppcw0KLkJSIFBFUkZfVFlQRV9CUkVBS1BPSU5U
IC4NCk9wdGlvbnMgYXJlDQouQlIgSFdfQlJFQUtQT0lOVF9MRU5fMSAsDQou
QlIgSFdfQlJFQUtQT0lOVF9MRU5fMiAsDQouQlIgSFdfQlJFQUtQT0lOVF9M
RU5fNCAsDQouQlIgSFdfQlJFQUtQT0lOVF9MRU5fOCAuDQpGb3IgYW4gZXhl
Y3V0aW9uIGJyZWFrcG9pbnQsIHNldCB0aGlzIHRvDQouSVIgc2l6ZW9mKGxv
bmcpIC4NCg0KLlRQDQouSVIgImNvbmZpZzIiICIgKFNpbmNlIExpbnV4IDIu
Ni4zOSkiDQoNCi5JIGNvbmZpZzINCmlzIGEgZnVydGhlciBleHRlbnNpb24g
b2YgdGhlDQouSSBjb25maWcxDQpmaWVsZC4NCg0KLlRQDQouSVIgImJyYW5j
aF9zYW1wbGVfdHlwZSIgIiAoU2luY2UgTGludXggMy40KSINClRoaXMgaXMg
dXNlZCB3aXRoIHRoZSBDUFVzIGhhcmR3YXJlIGJyYW5jaCBzYW1wbGluZywg
aWYgYXZhaWxhYmxlLg0KSXQgY2FuIGhhdmUgb25lIG9mIHRoZSBmb2xsb3dp
bmcgdmFsdWVzOg0KLlJTDQouVFANCi5CIFBFUkZfU0FNUExFX0JSQU5DSF9V
U0VSDQpCcmFuY2ggdGFyZ2V0IGlzIGluIHVzZXIgc3BhY2UNCi5UUA0KLkIg
UEVSRl9TQU1QTEVfQlJBTkNIX0tFUk5FTA0KQnJhbmNoIHRhcmdldCBpcyBp
biBrZXJuZWwgc3BhY2UNCi5UUA0KLkIgUEVSRl9TQU1QTEVfQlJBTkNIX0hW
DQpCcmFuY2ggdGFyZ2V0IGlzIGluIGh5cGVydmlzb3INCi5UUA0KLkIgUEVS
Rl9TQU1QTEVfQlJBTkNIX0FOWQ0KQW55IGJyYW5jaCB0eXBlLg0KLlRQDQou
QiBQRVJGX1NBTVBMRV9CUkFOQ0hfQU5ZX0NBTEwNCkFueSBjYWxsIGJyYW5j
aA0KLlRQDQouQiBQRVJGX1NBTVBMRV9CUkFOQ0hfQU5ZX1JFVFVSTg0KQW55
IHJldHVybiBicmFuY2gNCi5UUA0KLkJSIFBFUkZfU0FNUExFX0JSQU5DSF9J
TkRfQ0FMTA0KSW5kaXJlY3QgY2FsbHMNCi5UUA0KLkJSIFBFUkZfU0FNUExF
X0JSQU5DSF9QTE1fQUxMDQpVc2VyLCBrZXJuZWwsIGFuZCBodg0KLlJFDQoN
Cg0KLlNTICJNTUFQIExheW91dCINCg0KV2hlbiB1c2luZw0KLkJSIHBlcmZf
ZXZlbnRfb3BlbigpDQppbiBzYW1wbGVkIG1vZGUsIGFzeW5jaHJvbm91cyBl
dmVudHMNCihsaWtlIGNvdW50ZXIgb3ZlcmZsb3cgb3INCi5CIFBST1RfRVhF
Qw0KbW1hcCB0cmFja2luZykNCmFyZSBsb2dnZWQgaW50byBhIHJpbmctYnVm
ZmVyLg0KVGhpcyByaW5nLWJ1ZmZlciBpcyBjcmVhdGVkIGFuZCBhY2Nlc3Nl
ZCB0aHJvdWdoDQouQlIgbW1hcCAoMikuDQoNClRoZSBtbWFwIHNpemUgc2hv
dWxkIGJlIDErMl5uIHBhZ2VzLCB3aGVyZSB0aGUgZmlyc3QgcGFnZSBpcyBh
DQptZXRhZGF0YSBwYWdlDQouSVIgKCAic3RydWN0IHBlcmZfZXZlbnRfbW1h
cF9wYWdlIiApDQp0aGF0IGNvbnRhaW5zIHZhcmlvdXMNCmJpdHMgb2YgaW5m
b3JtYXRpb24gc3VjaCBhcyB3aGVyZSB0aGUgcmluZy1idWZmZXIgaGVhZCBp
cy4NCg0KQmVmb3JlIGtlcm5lbCAyLjYuMzksIHRoZXJlIGlzIGEgYnVnIHRo
YXQgbWVhbnMgeW91IG11c3QgYWxsb2NhdGUgYSBtbWFwDQpyaW5nIGJ1ZmZl
ciB3aGVuIHNhbXBsaW5nIGV2ZW4gaWYgeW91IGRvIG5vdCBwbGFuIHRvIGFj
Y2VzcyBpdC4NCg0KVGhlIHN0cnVjdHVyZSBvZiB0aGUgZmlyc3QgbWV0YWRh
dGEgbW1hcCBwYWdlIGlzIGFzIGZvbGxvd3M6DQoNCi5pbiArNG4NCi5uZg0K
c3RydWN0IHBlcmZfZXZlbnRfbW1hcF9wYWdlIHsNCiAgICBfX3UzMiB2ZXJz
aW9uOyAgICAgICAgICAvKiB2ZXJzaW9uIG51bWJlciBvZiB0aGlzIHN0cnVj
dHVyZSAgICovDQogICAgX191MzIgY29tcGF0X3ZlcnNpb247ICAgLyogbG93
ZXN0IHZlcnNpb24gdGhpcyBpcyBjb21wYXQgd2l0aCAqLw0KICAgIF9fdTMy
IGxvY2s7ICAgICAgICAgICAgIC8qIHNlcWxvY2sgZm9yIHN5bmNocm9uaXph
dGlvbiAgICAgICAgKi8NCiAgICBfX3UzMiBpbmRleDsgICAgICAgICAgICAv
KiBoYXJkd2FyZSBjb3VudGVyIGlkZW50aWZpZXIgICAgICAgICovDQogICAg
X19zNjQgb2Zmc2V0OyAgICAgICAgICAgLyogYWRkIHRvIGhhcmR3YXJlIGNv
dW50ZXIgdmFsdWUgICAgICAqLw0KICAgIF9fdTY0IHRpbWVfZW5hYmxlZDsg
ICAgIC8qIHRpbWUgZXZlbnQgYWN0aXZlICAgICAgICAgICAgICAgICAgKi8N
CiAgICBfX3U2NCB0aW1lX3J1bm5pbmc7ICAgICAvKiB0aW1lIGV2ZW50IG9u
IENQVSAgICAgICAgICAgICAgICAgICovDQogICAgdW5pb24gew0KICAgICAg
ICBfX3U2NCAgIGNhcGFiaWxpdGllczsNCiAgICAgICAgX191NjQgICBjYXBf
dXNyX3RpbWUgIDogMSwNCiAgICAgICAgICAgICAgICBjYXBfdXNyX3JkcG1j
IDogMSwNCiAgICB9Ow0KICAgIF9fdTE2ICAgcG1jX3dpZHRoOw0KICAgIF9f
dTE2ICAgdGltZV9zaGlmdDsNCiAgICBfX3UzMiAgIHRpbWVfbXVsdDsNCiAg
ICBfX3U2NCAgIHRpbWVfb2Zmc2V0Ow0KICAgIF9fdTY0ICAgX19yZXNlcnZl
ZFsxMjBdOyAgIC8qIFBhZCB0byAxayAgICAgICAgICAgICAgICAqLw0KICAg
IF9fdTY0ICAgZGF0YV9oZWFkOyAgICAgICAgIC8qIGhlYWQgaW4gdGhlIGRh
dGEgc2VjdGlvbiAqLw0KICAgIF9fdTY0ICAgZGF0YV90YWlsOyAgICAgICAg
IC8qIHVzZXItc3BhY2Ugd3JpdHRlbiB0YWlsICAqLw0KfQ0KLmZpDQouaW4N
Cg0KDQoNClRoZSBmb2xsb3dpbmcgbG9va3MgYXQgdGhlIGZpZWxkcyBpbiB0
aGUNCi5JIHBlcmZfZXZlbnRfbW1hcF9wYWdlDQpzdHJ1Y3R1cmUgaW4gbW9y
ZSBkZXRhaWwuDQoNCi5SUw0KDQouVFANCi5JIHZlcnNpb24NClZlcnNpb24g
bnVtYmVyIG9mIHRoaXMgc3RydWN0dXJlLg0KDQouVFANCi5JIGNvbXBhdF92
ZXJzaW9uDQpUaGUgbG93ZXN0IHZlcnNpb24gdGhpcyBpcyBjb21wYXRpYmxl
IHdpdGguDQoNCi5UUA0KLkkgbG9jaw0KQSBzZXFsb2NrIGZvciBzeW5jaHJv
bml6YXRpb24uDQoNCi5UUA0KLkkgaW5kZXg7DQpBIHVuaXF1ZSBoYXJkd2Fy
ZSBjb3VudGVyIGlkZW50aWZpZXIuDQoNCi5UUA0KLkkgb2Zmc2V0DQouXCIg
RklYTUUgY2xhcmlmeQ0KQWRkIHRoaXMgdG8gaGFyZHdhcmUgY291bnRlciB2
YWx1ZT8/DQoNCi5UUA0KLkkgdGltZV9lbmFibGVkDQpUaW1lIHRoZSBldmVu
dCB3YXMgYWN0aXZlLg0KDQouVFANCi5JIHRpbWVfcnVubmluZw0KVGltZSB0
aGUgZXZlbnQgd2FzIHJ1bm5pbmcuDQoNCi5UUA0KLkkgY2FwX3Vzcl90aW1l
DQpVc2VyIHRpbWUgY2FwYWJpbGl0eQ0KDQouVFANCi5JIGNhcF91c3JfcmRw
bWMNCklmIHRoZSBoYXJkd2FyZSBzdXBwb3J0cyB1c2VyLXNwYWNlIHJlYWQg
b2YgcGVyZm9ybWFuY2UgY291bnRlcnMNCndpdGhvdXQgc3lzY2FsbCAodGhp
cyBpcyB0aGUgInJkcG1jIiBpbnN0cnVjdGlvbiBvbiB4ODYpLCB0aGVuDQp0
aGUgZm9sbG93aW5nIGNvZGUgY2FuIGJlIHVzZWQgdG8gZG8gYSByZWFkOg0K
DQouaW4gKzRuDQoubmYNCnUzMiBzZXEsIHRpbWVfbXVsdCwgdGltZV9zaGlm
dCwgaWR4LCB3aWR0aDsNCnU2NCBjb3VudCwgZW5hYmxlZCwgcnVubmluZzsN
CnU2NCBjeWMsIHRpbWVfb2Zmc2V0Ow0KczY0IHBtYyA9IDA7DQoNCmRvIHsN
CiAgICBzZXEgPSBwY1wtPmxvY2s7DQogICAgYmFycmllcigpOw0KICAgIGVu
YWJsZWQgPSBwY1wtPnRpbWVfZW5hYmxlZDsNCiAgICBydW5uaW5nID0gcGNc
LT50aW1lX3J1bm5pbmc7DQoNCiAgICBpZiAocGNcLT5jYXBfdXNyX3RpbWUg
JiYgZW5hYmxlZCAhPSBydW5uaW5nKSB7DQogICAgICAgIGN5YyA9IHJkdHNj
KCk7DQogICAgICAgIHRpbWVfb2Zmc2V0ID0gcGNcLT50aW1lX29mZnNldDsN
CiAgICAgICAgdGltZV9tdWx0ICAgPSBwY1wtPnRpbWVfbXVsdDsNCiAgICAg
ICAgdGltZV9zaGlmdCAgPSBwY1wtPnRpbWVfc2hpZnQ7DQogICAgfQ0KDQog
ICAgaWR4ID0gcGNcLT5pbmRleDsNCiAgICBjb3VudCA9IHBjXC0+b2Zmc2V0
Ow0KDQogICAgaWYgKHBjXC0+Y2FwX3Vzcl9yZHBtYyAmJiBpZHgpIHsNCiAg
ICAgICAgd2lkdGggPSBwY1wtPnBtY193aWR0aDsNCiAgICAgICAgcG1jID0g
cmRwbWMoaWR4IFwtIDEpOw0KICAgIH0NCg0KICAgIGJhcnJpZXIoKTsNCn0g
d2hpbGUgKHBjXC0+bG9jayAhPSBzZXEpOw0KLmZpDQouaW4NCg0KDQoNCi5U
UA0KLkkgcG1jX3dpZHRoDQpJZg0KLklSIGNhcF91c3JfcmRwbWMgLA0KdGhp
cyBmaWVsZCBwcm92aWRlcyB0aGUgYml0LXdpZHRoIG9mIHRoZSB2YWx1ZQ0K
cmVhZCB1c2luZyB0aGUgcmRwbWMgb3IgZXF1aXZhbGVudCBpbnN0cnVjdGlv
bi4NClRoaXMgY2FuIGJlIHVzZWQgdG8gc2lnbiBleHRlbmQgdGhlIHJlc3Vs
dCBsaWtlOg0KDQouaW4gKzRuDQoubmYNCnBtYyA8PD0gNjQgXC0gcG1jX3dp
ZHRoOw0KcG1jID4+PSA2NCBcLSBwbWNfd2lkdGg7IC8vIHNpZ25lZCBzaGlm
dCByaWdodA0KY291bnQgKz0gcG1jOw0KLmZpDQouaW4NCg0KDQouVFANCi5J
UiB0aW1lX3NoaWZ0ICIsICIgdGltZV9tdWx0ICIsICIgdGltZV9vZmZzZXQN
Cg0KSWYNCi5JUiBjYXBfdXNyX3RpbWUgLA0KdGhlc2UgZmllbGRzIGNhbiBi
ZSB1c2VkIHRvIGNvbXB1dGUgdGhlIHRpbWUNCmRlbHRhIHNpbmNlIHRpbWVf
ZW5hYmxlZCAoaW4gbnMpIHVzaW5nIHJkdHNjIG9yIHNpbWlsYXIuDQoubmYN
Cg0KICAgIHU2NCBxdW90LCByZW07DQogICAgdTY0IGRlbHRhOw0KICAgIHF1
b3QgPSAoY3ljID4+IHRpbWVfc2hpZnQpOw0KICAgIHJlbSA9IGN5YyAmICgo
MSA8PCB0aW1lX3NoaWZ0KSBcLSAxKTsNCiAgICBkZWx0YSA9IHRpbWVfb2Zm
c2V0ICsgcXVvdCAqIHRpbWVfbXVsdCArDQogICAgICAgICAgICAoKHJlbSAq
IHRpbWVfbXVsdCkgPj4gdGltZV9zaGlmdCk7DQouZmkNCg0KV2hlcmUgdGlt
ZV9vZmZzZXQsdGltZV9tdWx0LHRpbWVfc2hpZnQgYW5kIGN5YyBhcmUgcmVh
ZCBpbiB0aGUNCnNlcWNvdW50IGxvb3AgZGVzY3JpYmVkIGFib3ZlLg0KVGhp
cyBkZWx0YSBjYW4gdGhlbiBiZSBhZGRlZCB0bw0KZW5hYmxlZCBhbmQgcG9z
c2libGUgcnVubmluZyAoaWYgaWR4KSwgaW1wcm92aW5nIHRoZSBzY2FsaW5n
Og0KLm5mDQoNCiAgICBlbmFibGVkICs9IGRlbHRhOw0KICAgIGlmIChpZHgp
DQogICAgICAgIHJ1bm5pbmcgKz0gZGVsdGE7DQogICAgcXVvdCA9IGNvdW50
IC8gcnVubmluZzsNCiAgICByZW0gID0gY291bnQgJSBydW5uaW5nOw0KICAg
IGNvdW50ID0gcXVvdCAqIGVuYWJsZWQgKyAocmVtICogZW5hYmxlZCkgLyBy
dW5uaW5nOw0KLmZpDQoNCi5UUA0KLkkgZGF0YV9oZWFkDQpUaGlzIHBvaW50
cyB0byB0aGUgaGVhZCBvZiB0aGUgZGF0YSBzZWN0aW9uLg0KT24gU01QLWNh
cGFibGUgcGxhdGZvcm1zLCBhZnRlciByZWFkaW5nIHRoZSBkYXRhX2hlYWQg
dmFsdWUsDQp1c2VyLXNwYWNlIHNob3VsZCBpc3N1ZSBhbiBybWIoKS4NCg0K
LlRQDQouSSBkYXRhX3RhaWw7DQpXaGVuIHRoZSBtYXBwaW5nIGlzDQouQlIg
UFJPVF9XUklURSAsDQp0aGUgZGF0YV90YWlsIHZhbHVlIHNob3VsZCBiZSB3
cml0dGVuIGJ5DQp1c2Vyc3BhY2UgdG8gcmVmbGVjdCB0aGUgbGFzdCByZWFk
IGRhdGEuDQpJbiB0aGlzIGNhc2UgdGhlIGtlcm5lbCB3aWxsIG5vdCBvdmVy
LXdyaXRlIHVucmVhZCBkYXRhLg0KDQouUkUNCg0KDQpUaGUgZm9sbG93aW5n
IDJebiByaW5nLWJ1ZmZlciBwYWdlcyBoYXZlIHRoZSBsYXlvdXQgZGVzY3Jp
YmVkIGJlbG93Lg0KDQpJZg0KLkkgcGVyZl9ldmVudF9hdHRyLnNhbXBsZV9p
ZF9hbGwNCmlzIHNldCwgdGhlbiBhbGwgZXZlbnQgdHlwZXMgd2lsbA0KaGF2
ZSB0aGUgc2FtcGxlX3R5cGUgc2VsZWN0ZWQgZmllbGRzIHJlbGF0ZWQgdG8g
d2hlcmUvd2hlbiAoaWRlbnRpdHkpDQphbiBldmVudCB0b29rIHBsYWNlIChU
SUQsIFRJTUUsIElELCBDUFUsIFNUUkVBTV9JRCkgZGVzY3JpYmVkIGluDQou
QiBQRVJGX1JFQ09SRF9TQU1QTEUNCmJlbG93LCBpdCB3aWxsIGJlIHN0YXNo
ZWQganVzdCBhZnRlciB0aGUNCnBlcmZfZXZlbnRfaGVhZGVyIGFuZCB0aGUg
ZmllbGRzIGFscmVhZHkgcHJlc2VudCBmb3IgdGhlIGV4aXN0aW5nDQpmaWVs
ZHMsIGkuZS4sIGF0IHRoZSBlbmQgb2YgdGhlIHBheWxvYWQuDQpUaGF0IHdh
eSBhIG5ld2VyIHBlcmYuZGF0YQ0KZmlsZSB3aWxsIGJlIHN1cHBvcnRlZCBi
eSBvbGRlciBwZXJmIHRvb2xzLCB3aXRoIHRoZXNlIG5ldyBvcHRpb25hbA0K
ZmllbGRzIGJlaW5nIGlnbm9yZWQuDQoNClRoZSBtbWFwIHZhbHVlcyBzdGFy
dCB3aXRoIGEgaGVhZGVyOg0KDQouaW4gKzRuDQoubmYNCnN0cnVjdCBwZXJm
X2V2ZW50X2hlYWRlciB7DQogICAgX191MzIgICB0eXBlOw0KICAgIF9fdTE2
ICAgbWlzYzsNCiAgICBfX3UxNiAgIHNpemU7DQp9Ow0KLmZpDQouaW4NCg0K
QmVsb3csIHdlIGRlc2NyaWJlIHRoZQ0KLkkgcGVyZl9ldmVudF9oZWFkZXIN
CmZpZWxkcyBpbiBtb3JlIGRldGFpbC4NCg0KLlRQDQouSSB0eXBlDQpUaGUN
Ci5JIHR5cGUNCnZhbHVlIGlzIG9uZSBvZiB0aGUgYmVsb3cuDQpUaGUgdmFs
dWVzIGluIHRoZSBjb3JyZXNwb25kaW5nIHJlY29yZCAodGhhdCBmb2xsb3dz
IHRoZSBoZWFkZXIpDQpkZXBlbmQgb24gdGhlDQouSSB0eXBlDQpzZWxlY3Rl
ZCBhcyBzaG93bi4NCg0KLlJTDQouVFANCi5CIFBFUkZfUkVDT1JEX01NQVAN
ClRoZSBNTUFQIGV2ZW50cyByZWNvcmQgdGhlDQouQiBQUk9UX0VYRUMNCm1h
cHBpbmdzIHNvIHRoYXQgd2UgY2FuIGNvcnJlbGF0ZQ0KdXNlcnNwYWNlIElQ
cyB0byBjb2RlLg0KVGhleSBoYXZlIHRoZSBmb2xsb3dpbmcgc3RydWN0dXJl
Og0KDQouaW4gKzRuDQoubmYNCnN0cnVjdCB7DQogICAgc3RydWN0IHBlcmZf
ZXZlbnRfaGVhZGVyIGhlYWRlcjsNCiAgICB1MzIgICAgcGlkLCB0aWQ7DQog
ICAgdTY0ICAgIGFkZHI7DQogICAgdTY0ICAgIGxlbjsNCiAgICB1NjQgICAg
cGdvZmY7DQogICAgY2hhciAgIGZpbGVuYW1lW107DQp9Ow0KLmluDQoNCi5U
UA0KLkIgUEVSRl9SRUNPUkRfTE9TVA0KVGhpcyByZWNvcmQgaW5kaWNhdGVz
IHdoZW4gZXZlbnRzIGFyZSBsb3N0Lg0KDQouaW4gKzRuDQoubmYNCnN0cnVj
dCB7DQogICAgc3RydWN0IHBlcmZfZXZlbnRfaGVhZGVyIGhlYWRlcjsNCiAg
ICB1NjQgaWQ7DQogICAgdTY0IGxvc3Q7DQp9Ow0KLmZpDQouaW4NCg0KLlRQ
DQouQiBQRVJGX1JFQ09SRF9DT01NDQpUaGlzIHJlY29yZCBpbmRpY2F0ZXMg
YSBjaGFuZ2UgaW4gdGhlIHByb2Nlc3MgbmFtZS4NCg0KLmluICs0bg0KLm5m
DQpzdHJ1Y3Qgew0KICAgIHN0cnVjdCBwZXJmX2V2ZW50X2hlYWRlciBoZWFk
ZXI7DQogICAgdTMyIHBpZCwgdGlkOw0KICAgIGNoYXIgY29tbVtdOw0KfTsN
Ci5maQ0KLmluDQoNCi5UUA0KLkIgUEVSRl9SRUNPUkRfRVhJVA0KVGhpcyBy
ZWNvcmQgaW5kaWNhdGVzIGEgcHJvY2VzcyBleGl0IGV2ZW50Lg0KDQouaW4g
KzRuDQoubmYNCnN0cnVjdCB7DQogICAgc3RydWN0IHBlcmZfZXZlbnRfaGVh
ZGVyIGhlYWRlcjsNCiAgICB1MzIgcGlkLCBwcGlkOw0KICAgIHUzMiB0aWQs
IHB0aWQ7DQogICAgdTY0IHRpbWU7DQp9Ow0KLmZpDQouaW4NCg0KLlRQDQou
QlIgUEVSRl9SRUNPUkRfVEhST1RUTEUgIiwgIiBQRVJGX1JFQ09SRF9VTlRI
Uk9UVExFDQpUaGlzIHJlY29yZCBpbmRpY2F0ZXMgYSB0aHJvdHRsZS91bnRo
cm90dGxlIGV2ZW50Lg0KDQouaW4gKzRuDQoubmYNCnN0cnVjdCB7DQogICAg
c3RydWN0IHBlcmZfZXZlbnRfaGVhZGVyIGhlYWRlcjsNCiAgICB1NjQgdGlt
ZTsNCiAgICB1NjQgaWQ7DQogICAgdTY0IHN0cmVhbV9pZDsNCn07DQouZmkN
Ci5pbg0KDQouVFANCi5CIFBFUkZfUkVDT1JEX0ZPUksNClRoaXMgcmVjb3Jk
IGluZGljYXRlcyBhIGZvcmsgZXZlbnQuDQoNCi5pbiArNG4NCi5uZg0Kc3Ry
dWN0IHsNCiAgICBzdHJ1Y3QgcGVyZl9ldmVudF9oZWFkZXIgaGVhZGVyOw0K
ICAgIHUzMiBwaWQsIHBwaWQ7DQogICAgdTMyIHRpZCwgcHRpZDsNCiAgICB1
NjQgdGltZTsNCn07DQouZmkNCi5pbg0KDQouVFANCi5CIFBFUkZfUkVDT1JE
X1JFQUQNClRoaXMgcmVjb3JkIGluZGljYXRlcyBhIHJlYWQgZXZlbnQuDQoN
Ci5pbiArNG4NCi5uZg0Kc3RydWN0IHsNCiAgICBzdHJ1Y3QgcGVyZl9ldmVu
dF9oZWFkZXIgaGVhZGVyOw0KICAgIHUzMiBwaWQsIHRpZDsNCiAgICBzdHJ1
Y3QgcmVhZF9mb3JtYXQgdmFsdWVzOw0KfTsNCi5maQ0KLmluDQoNCi5UUA0K
LkIgUEVSRl9SRUNPUkRfU0FNUExFDQpUaGlzIHJlY29yZCBpbmRpY2F0ZXMg
YSBzYW1wbGUuDQoNCi5pbiArNG4NCi5uZg0Kc3RydWN0IHsNCiAgICBzdHJ1
Y3QgcGVyZl9ldmVudF9oZWFkZXIgaGVhZGVyOw0KICAgIHU2NCAgIGlwOyAg
ICAgICAgICAvKiBpZiBQRVJGX1NBTVBMRV9JUCAgICAgICovDQogICAgdTMy
ICAgcGlkLCB0aWQ7ICAgIC8qIGlmIFBFUkZfU0FNUExFX1RJRCAgICAgKi8N
CiAgICB1NjQgICB0aW1lOyAgICAgICAgLyogaWYgUEVSRl9TQU1QTEVfVElN
RSAgICAqLw0KICAgIHU2NCAgIGFkZHI7ICAgICAgICAvKiBpZiBQRVJGX1NB
TVBMRV9BRERSICAgICovDQogICAgdTY0ICAgaWQ7ICAgICAgICAgIC8qIGlm
IFBFUkZfU0FNUExFX0lEICAgICAgKi8NCiAgICB1NjQgICBzdHJlYW1faWQ7
IC8qIGlmIFBFUkZfU0FNUExFX1NUUkVBTV9JRCAqLw0KICAgIHUzMiAgIGNw
dSwgcmVzOyAgICAvKiBpZiBQRVJGX1NBTVBMRV9DUFUgICAgICovDQogICAg
dTY0ICAgcGVyaW9kOyAgICAgIC8qIGlmIFBFUkZfU0FNUExFX1BFUklPRCAg
Ki8NCiAgICBzdHJ1Y3QgcmVhZF9mb3JtYXQgdjsgLyogaWYgUEVSRl9TQU1Q
TEVfUkVBRCAqLw0KICAgIHU2NCAgIG5yOyAgICAgICAgLyogaWYgUEVSRl9T
QU1QTEVfQ0FMTENIQUlOICovDQogICAgdTY0ICAgaXBzW25yXTsgICAvKiBp
ZiBQRVJGX1NBTVBMRV9DQUxMQ0hBSU4gKi8NCiAgICB1MzIgICBzaXplOyAg
ICAgICAgLyogaWYgUEVSRl9TQU1QTEVfUkFXICAgICAqLw0KICAgIGNoYXIg
IGRhdGFbc2l6ZV07ICAvKiBpZiBQRVJGX1NBTVBMRV9SQVcgICAgICovDQog
ICAgdTY0ICAgZnJvbTsgICAvKiBpZiBQRVJGX1NBTVBMRV9CUkFOQ0hfU1RB
Q0sgKi8NCiAgICB1NjQgICB0bzsgICAgIC8qIGlmIFBFUkZfU0FNUExFX0JS
QU5DSF9TVEFDSyAqLw0KICAgIHU2NCAgIGZsYWdzOyAgLyogaWYgUEVSRl9T
QU1QTEVfQlJBTkNIX1NUQUNLICovDQogICAgdTY0ICAgbGJyW25yXTsvKiBp
ZiBQRVJGX1NBTVBMRV9CUkFOQ0hfU1RBQ0sgKi8NCn07DQouZmkNCi5pbg0K
DQpUaGUgUkFXIHJlY29yZCBkYXRhIGlzIG9wYXF1ZSB3aXRoIHJlc3BlY3Qg
dG8gdGhlIEFCSS4NClRoZSBBQkkgZG9lc24ndCBtYWtlIGFueSBwcm9taXNl
cyB3aXRoIHJlc3BlY3QgdG8gdGhlIHN0YWJpbGl0eQ0Kb2YgaXRzIGNvbnRl
bnQsIGl0IG1heSB2YXJ5IGRlcGVuZGluZw0Kb24gZXZlbnQsIGhhcmR3YXJl
LCBhbmQga2VybmVsIHZlcnNpb24uDQoNCi5SRQ0KDQoNCi5UUA0KLkkgbWlz
Yw0KVGhlDQouSSBtaXNjDQpmaWVsZCBpcyBvbmUgb2YgdGhlIGZvbGxvd2lu
ZzoNCi5SUw0KLlRQDQouQiBQRVJGX1JFQ09SRF9NSVNDX0NQVU1PREVfTUFT
Sw0KW1RvIGJlIGRvY3VtZW50ZWRdDQouVFANCi5CIFBFUkZfUkVDT1JEX01J
U0NfQ1BVTU9ERV9VTktOT1dODQpbVG8gYmUgZG9jdW1lbnRlZF0NCi5UUA0K
LkIgUEVSRl9SRUNPUkRfTUlTQ19LRVJORUwNCltUbyBiZSBkb2N1bWVudGVk
XQ0KLlRQDQouQiBQRVJGX1JFQ09SRF9NSVNDX1VTRVINCltUbyBiZSBkb2N1
bWVudGVkXQ0KLlRQDQouQiBQRVJGX1JFQ09SRF9NSVNDX0hZUEVSVklTT1IN
CltUbyBiZSBkb2N1bWVudGVkXQ0KLlRQDQouQiBQRVJGX1JFQ09SRF9NSVND
X0dVRVNUX0tFUk5FTA0KW1RvIGJlIGRvY3VtZW50ZWRdDQouVFANCi5CIFBF
UkZfUkVDT1JEX01JU0NfR1VFU1RfVVNFUg0KW1RvIGJlIGRvY3VtZW50ZWRd
DQouVFANCi5CIFBFUkZfUkVDT1JEX01JU0NfRVhBQ1RfSVANClRoaXMgaW5k
aWNhdGVzIHRoYXQgdGhlIGNvbnRlbnQgb2YNCi5CIFBFUkZfU0FNUExFX0lQ
DQpwb2ludHMNCnRvIHRoZSBhY3R1YWwgaW5zdHJ1Y3Rpb24gdGhhdCB0cmln
Z2VyZWQgdGhlIGV2ZW50Lg0KU2VlIGFsc28NCi5JUiBwZXJmX2V2ZW50X2F0
dHIucHJlY2lzZV9pcCAuDQoNCi5SRQ0KDQouVFANCi5JIHNpemUNClRoaXMg
aW5kaWNhdGVzIHRoZSBzaXplIG9mIHRoZSByZWNvcmQuDQoNCg0KLlNTICJT
aWduYWwgT3ZlcmZsb3ciDQoNCkNvdW50ZXJzIGNhbiBiZSBzZXQgdG8gc2ln
bmFsIHdoZW4gYSB0aHJlc2hvbGQgaXMgY3Jvc3NlZC4NClRoaXMgaXMgc2V0
IHVwIHVzaW5nIHRyYWRpdGlvbmFsIHRoZQ0KLkJSIHBvbGwgKDIpLA0KLkJS
IHNlbGVjdCAoMiksDQouQlIgZXBvbGwgKDIpDQphbmQNCi5CUiBmY250bCAo
MiksDQpzeXN0ZW0gY2FsbHMuDQoNCk5vcm1hbGx5LCBhIG5vdGlmaWNhdGlv
biBpcyBnZW5lcmF0ZWQgZm9yIGV2ZXJ5IHBhZ2UgZmlsbGVkLCBob3dldmVy
DQpvbmUgY2FuIGFkZGl0aW9uYWxseSBzZXQNCi5JIHBlcmZfZXZlbnRfYXR0
ci53YWtldXBfZXZlbnRzDQp0byBnZW5lcmF0ZSBvbmUgZXZlcnkgc28gbWFu
eSBjb3VudGVyIG92ZXJmbG93IGV2ZW50cy4NCg0KLlNTICJSZWFkaW5nIFJl
c3VsdHMiDQpPbmNlIGENCi5CUiBwZXJmX2V2ZW50X29wZW4oKQ0KZmlsZSBk
ZXNjcmlwdG9yICBoYXMgYmVlbiBvcGVuZWQsIHRoZSB2YWx1ZXMNCm9mIHRo
ZSBldmVudHMgY2FuIGJlIHJlYWQgZnJvbSB0aGUgZmlsZSBkZXNjcmlwdG9y
Lg0KVGhlIHZhbHVlcyB0aGF0IGFyZSB0aGVyZSBhcmUgc3BlY2lmaWVkIGJ5
IHRoZQ0KLkkgcmVhZF9mb3JtYXQNCmZpZWxkIGluIHRoZSBhdHRyIHN0cnVj
dHVyZSBhdCBvcGVuIHRpbWUuDQoNCklmIHlvdSBhdHRlbXB0IHRvIHJlYWQg
aW50byBhIGJ1ZmZlciB0aGF0IGlzIG5vdCBiaWcgZW5vdWdoIHRvIGhvbGQg
dGhlDQpkYXRhLCBhbiBlcnJvciBpcyByZXR1cm5lZA0KLklSICggRU5PU1BD
ICkuDQoNCkhlcmUgaXMgdGhlIGxheW91dCBvZiB0aGUgZGF0YSByZXR1cm5l
ZCBieSBhIHJlYWQuDQoNCklmDQouQiBQRVJGX0ZPUk1BVF9HUk9VUA0Kd2Fz
IHNwZWNpZmllZCB0byBhbGxvdyByZWFkaW5nIGFsbCBldmVudHMgaW4gYSBn
cm91cCBhdCBvbmNlOg0KDQouaW4gKzRuDQoubmYNCnN0cnVjdCB7DQogICAg
dTY0IG5yOyAgICAgICAgICAgICAvKiBUaGUgbnVtYmVyIG9mIGV2ZW50cyAq
Lw0KICAgIHU2NCB0aW1lX2VuYWJsZWQ7ICAgLyogaWYgUEVSRl9GT1JNQVRf
VE9UQUxfVElNRV9FTkFCTEVEICovDQogICAgdTY0IHRpbWVfcnVubmluZzsg
ICAvKiBpZiBQRVJGX0ZPUk1BVF9UT1RBTF9USU1FX1JVTk5JTkcgKi8NCiAg
ICBzdHJ1Y3Qgew0KICAgICAgICB1NjQgdmFsdWU7ICAgICAgLyogVGhlIHZh
bHVlIG9mIHRoZSBldmVudCAqLw0KICAgICAgICB1NjQgaWQ7ICAgICAgICAg
LyogaWYgUEVSRl9GT1JNQVRfSUQgKi8NCiAgICB9IHZhbHVlc1tucl07DQp9
Ow0KLmZpDQouaW4NCg0KSWYNCi5CIFBFUkZfRk9STUFUX0dST1VQDQp3YXMN
Ci5JIG5vdA0Kc3BlY2lmaWVkLCB0aGVuIHRoZSByZWFkIHZhbHVlcyBsb29r
IGFzIGZvbGxvd2luZzoNCg0KLmluICs0bg0KLm5mDQpzdHJ1Y3Qgew0KICAg
IHU2NCB2YWx1ZTsgICAgICAgICAvKiBUaGUgdmFsdWUgb2YgdGhlIGV2ZW50
ICovDQogICAgdTY0IHRpbWVfZW5hYmxlZDsgIC8qIGlmIFBFUkZfRk9STUFU
X1RPVEFMX1RJTUVfRU5BQkxFRCAqLw0KICAgIHU2NCB0aW1lX3J1bm5pbmc7
ICAvKiBpZiBQRVJGX0ZPUk1BVF9UT1RBTF9USU1FX1JVTk5JTkcgKi8NCiAg
ICB1NjQgaWQ7ICAgICAgICAgICAgLyogaWYgUEVSRl9GT1JNQVRfSUQgKi8N
Cn07DQouZmkNCi5pbg0KDQpUaGUgdmFsdWVzIHJlYWQgYXJlIGRlc2NyaWJl
ZCBpbiBtb3JlIGRldGFpbCBiZWxvdy4NCi5SUw0KLlRQDQouSSBucg0KVGhl
IG51bWJlciBvZiBldmVudHMgaW4gdGhpcyBmaWxlIGRlc2NyaXB0b3IuDQpP
bmx5IGF2YWlsYWJsZSBpZg0KLkIgUEVSRl9GT1JNQVRfR1JPVVANCndhcyBz
cGVjaWZpZWQuDQoNCi5UUA0KLklSIHRpbWVfZW5hYmxlZCAiLCAiIHRpbWVf
cnVubmluZw0KVG90YWwgdGltZSB0aGUgZXZlbnQgd2FzIGVuYWJsZWQgYW5k
IHJ1bm5pbmcuDQpOb3JtYWxseSB0aGVzZSBhcmUgdGhlIHNhbWUuDQpJZiBt
b3JlIGV2ZW50cyBhcmUgc3RhcnRlZA0KdGhhbiBhdmFpbGFibGUgY291bnRl
ciBzbG90cyBvbiB0aGUgUE1VLCB0aGVuIG11bHRpcGxleGluZw0KaGFwcGVu
cyBhbmQgZXZlbnRzIG9ubHkgcnVuIHBhcnQgb2YgdGhlIHRpbWUuDQpJbiB0
aGF0IGNhc2UgdGhlDQouSSB0aW1lX2VuYWJsZWQNCmFuZA0KLkkgdGltZSBy
dW5uaW5nDQp2YWx1ZXMgY2FuIGJlIHVzZWQgdG8gc2NhbGUgYW4gZXN0aW1h
dGVkIHZhbHVlIGZvciB0aGUgY291bnQuDQoNCi5UUA0KLkkgdmFsdWUNCkFu
IHVuc2lnbmVkIDY0LWJpdCB2YWx1ZSBjb250YWluaW5nIHRoZSBjb3VudGVy
IHJlc3VsdC4NCg0KLlRQDQouSSBpZA0KQSBnbG9iYWxseSB1bmlxdWUgdmFs
dWUgZm9yIHRoaXMgcGFydGljdWxhciBldmVudCwgb25seSB0aGVyZSBpZg0K
LkIgUEVSRl9GT1JNQVRfSUQNCndhcyBzcGVjaWZpZWQgaW4gcmVhZF9mb3Jt
YXQuDQoNCi5SRQ0KDQoNCg0KDQouUkUNCg0KLlNTICJyZHBtYyBpbnN0cnVj
dGlvbiINClN0YXJ0aW5nIHdpdGggTGludXggMy40IG9uIHg4NiwgeW91IGNh
biB1c2UgdGhlDQouSSByZHBtYw0KaW5zdHJ1Y3Rpb24gdG8gZ2V0IGxvdy1s
YXRlbmN5IHJlYWRzIHdpdGhvdXQgaGF2aW5nIHRvIGVudGVyIHRoZSBrZXJu
ZWwuDQoNCg0KLlNTICJwZXJmX2V2ZW50IGlvY3RsIGNhbGxzIg0KLlBQDQpW
YXJpb3VzIGlvY3RscyBhY3Qgb24NCi5CUiBwZXJmX2V2ZW50X29wZW4oKQ0K
ZmlsZSBkZXNjcmlwdG9ycw0KLlwiIEZJWE1FIHRoZSBhcmd1bWVudHMgZm9y
IHRoZXNlIGlvY3RsKCkgb3BlcmF0aW9ucyBuZWVkIHRvIGJlIGRlc2NyaWJl
ZA0KLlRQDQouQiBQRVJGX0VWRU5UX0lPQ19FTkFCTEUNCkVuYWJsZXMgYW4g
aW5kaXZpZHVhbCBjb3VudGVyIG9yIGNvdW50ZXIgZ3JvdXAuDQoNCi5UUA0K
LkIgUEVSRl9FVkVOVF9JT0NfRElTQUJMRQ0KRGlzYWJsZXMgYW4gaW5kaXZp
ZHVhbCBjb3VudGVyIG9yIGNvdW50ZXIgZ3JvdXAuDQoNCkVuYWJsaW5nIG9y
IGRpc2FibGluZyB0aGUgbGVhZGVyIG9mIGEgZ3JvdXAgZW5hYmxlcyBvciBk
aXNhYmxlcyB0aGUNCmVudGlyZSBncm91cDsgdGhhdCBpcywgd2hpbGUgdGhl
IGdyb3VwIGxlYWRlciBpcyBkaXNhYmxlZCwgbm9uZSBvZiB0aGUNCmNvdW50
ZXJzIGluIHRoZSBncm91cCB3aWxsIGNvdW50Lg0KRW5hYmxpbmcgb3IgZGlz
YWJsaW5nIGEgbWVtYmVyIG9mIGEgZ3JvdXAgb3RoZXIgdGhhbiB0aGUgbGVh
ZGVyIG9ubHkNCmFmZmVjdHMgdGhhdCBjb3VudGVyOyBkaXNhYmxpbmcgYSBu
b24tbGVhZGVyDQpzdG9wcyB0aGF0IGNvdW50ZXIgZnJvbSBjb3VudGluZyBi
dXQgZG9lc24ndCBhZmZlY3QgYW55IG90aGVyIGNvdW50ZXIuDQoNCi5UUA0K
LkIgUEVSRl9FVkVOVF9JT0NfUkVGUkVTSA0KTm9uLWluaGVyaXRlZCBvdmVy
ZmxvdyBjb3VudGVycyBjYW4gdXNlIHRoaXMNCnRvIGVuYWJsZSBhIGNvdW50
ZXIgZm9yICducicgZXZlbnRzLCBhZnRlciB3aGljaCBpdCBnZXRzIGRpc2Fi
bGVkIGFnYWluLg0KLlwiIEZJWE1FIHRoZSBmb2xsb3dpbmcgbmVlZHMgY2xh
cmlmaWNhdGlvbi9jb25maXJtYXRpb24NCkkgdGhpbmsgdGhlIGdvYWwgb2Yg
SU9DX1JFRlJFU0ggaXMgbm90IHRvIHJlbG9hZCB0aGUgcGVyaW9kIGJ1dCBz
aW1wbHkgdG8NCmFkanVzdCB0aGUgbnVtYmVyIG9mIGV2ZW50cyBiZWZvcmUg
dGhlIG5leHQgbm90aWZpY2F0aW9ucy4NCg0KLlRQDQouQiBQRVJGX0VWRU5U
X0lPQ19SRVNFVA0KUmVzZXQgdGhlIGV2ZW50IGNvdW50IHRvIHplcm8uDQpU
aGlzIG9ubHkgcmVzZXRzIHRoZSBjb3VudHM7IHRoZXJlIGlzIG5vIHdheSB0
byByZXNldCB0aGUNCm11bHRpcGxleGluZw0KLkkgdGltZV9lbmFibGVkDQpv
cg0KLkkgdGltZV9ydW5uaW5nDQp2YWx1ZXMuDQpXaGVuIHNlbnQgdG8gYSBn
cm91cCBsZWFkZXIsIG9ubHkNCnRoZSBsZWFkZXIgaXMgcmVzZXQgKGNoaWxk
IGV2ZW50cyBhcmUgbm90KS4NCg0KLlRQDQouQiBQRVJGX0VWRU5UX0lPQ19Q
RVJJT0QNCklPQ19QRVJJT0QgaXMgdGhlIGNvbW1hbmQgdG8gdXBkYXRlIHRo
ZSBwZXJpb2Q7IGl0DQpkb2VzIG5vdCB1cGRhdGUgdGhlIGN1cnJlbnQgcGVy
aW9kIGJ1dCBpbnN0ZWFkIGRlZmVycyB1bnRpbCBuZXh0Lg0KDQouVFANCi5C
IFBFUkZfRVZFTlRfSU9DX1NFVF9PVVRQVVQNClRoaXMgdGVsbHMgdGhlIGtl
cm5lbCB0byByZXBvcnQgZXZlbnQgbm90aWZpY2F0aW9ucyB0byB0aGUgc3Bl
Y2lmaWVkDQpmaWxlIGRlc2NyaXB0b3IgcmF0aGVyIHRoYW4gdGhlIGRlZmF1
bHQgb25lLg0KVGhlIGZpbGUgZGVzY3JpcHRvcnMgbXVzdCBhbGwgYmUgb24g
dGhlIHNhbWUgQ1BVLg0KDQouVFANCi5CUiBQRVJGX0VWRU5UX0lPQ19TRVRf
RklMVEVSICIgKFNpbmNlIExpbnV4IDIuNi4zMykiDQpUaGlzIGFkZHMgYW4g
ZnRyYWNlIGZpbHRlciB0byB0aGlzIGV2ZW50Lg0KDQouU1MgIlVzaW5nIHBy
Y3RsIg0KQSBwcm9jZXNzIGNhbiBlbmFibGUgb3IgZGlzYWJsZSBhbGwgdGhl
IGNvdW50ZXIgZ3JvdXBzIHRoYXQgYXJlDQphdHRhY2hlZCB0byBpdCB1c2lu
ZyB0aGUNCi5CUiBwcmN0bCAoMikNCi5CIFBSX1RBU0tfUEVSRl9FVkVOVFNf
RU5BQkxFDQphbmQNCi5CIFBSX1RBU0tfUEVSRl9FVkVOVFNfRElTQUJMRQ0K
b3BlcmF0aW9ucy4NClRoaXMgYXBwbGllcyB0byBhbGwgY291bnRlcnMgb24g
dGhlIGN1cnJlbnQgcHJvY2Vzcywgd2hldGhlciBjcmVhdGVkIGJ5DQp0aGlz
IHByb2Nlc3Mgb3IgYnkgYW5vdGhlciwgYW5kIGRvZXMgbm90IGFmZmVjdCBh
bnkgY291bnRlcnMgdGhhdCB0aGlzDQpwcm9jZXNzIGhhcyBjcmVhdGVkIG9u
IG90aGVyIHByb2Nlc3Nlcy4NCkl0IG9ubHkgZW5hYmxlcyBvciBkaXNhYmxl
cw0KdGhlIGdyb3VwIGxlYWRlcnMsIG5vdCBhbnkgb3RoZXIgbWVtYmVycyBp
biB0aGUgZ3JvdXBzLg0KDQouU1MgL3Byb2Mvc3lzL2tlcm5lbC9wZXJmX2V2
ZW50X3BhcmFub2lkDQoNClRoZQ0KLkkgL3Byb2Mvc3lzL2tlcm5lbC9wZXJm
X2V2ZW50X3BhcmFub2lkDQpmaWxlIGNhbiBiZSBzZXQgdG8gcmVzdHJpY3Qg
YWNjZXNzIHRvIHRoZSBwZXJmb3JtYW5jZSBjb3VudGVycy4NCjINCm1lYW5z
IG5vIG1lYXN1cmVtZW50cyBhbGxvd2VkLA0KMQ0KbWVhbnMgbm9ybWFsIGNv
dW50ZXIgYWNjZXNzLA0KMA0KbWVhbnMgeW91IGNhbiBhY2Nlc3MgQ1BVLXNw
ZWNpZmljIGRhdGEsIGFuZA0KXC0xDQptZWFucyBubyByZXN0cmljdGlvbnMu
DQoNClRoZSBleGlzdGVuY2Ugb2YgdGhlDQouSSBwZXJmX2V2ZW50X3BhcmFu
b2lkDQpmaWxlIGlzIHRoZSBvZmZpY2lhbCBtZXRob2QgZm9yIGRldGVybWlu
aW5nIGlmIGEga2VybmVsIHN1cHBvcnRzDQouQlIgcGVyZl9ldmVudF9vcGVu
KCkuDQoNCi5TSCAiUkVUVVJOIFZBTFVFIg0KLkJSIHBlcmZfZXZlbnRfb3Bl
biAoKQ0KcmV0dXJucyB0aGUgbmV3IGZpbGUgZGVzY3JpcHRvciwgb3IgXC0x
IGlmIGFuIGVycm9yIG9jY3VycmVkDQooaW4gd2hpY2ggY2FzZSwNCi5JIGVy
cm5vDQppcyBzZXQgYXBwcm9wcmlhdGVseSkuDQouU0ggRVJST1JTDQouVFAN
Ci5CIEVJTlZBTA0KUmV0dXJuZWQgaWYgdGhlIHNwZWNpZmllZCBldmVudCBp
cyBub3QgYXZhaWxhYmxlLg0KLlRQDQouQiBFTk9TUEMNClByaW9yIHRvIExp
bnV4IDMuMywgaWYgdGhlcmUgd2FzIG5vIGNvdW50ZXIgcm9vbSwNCi5CIEVO
T1NQQw0Kd2FzIHJldHVybmVkLg0KTGludXMgZGlkIG5vdCBsaWtlIHRoaXMs
IGFuZCB0aGlzIHdhcyBjaGFuZ2VkIHRvDQouQlIgRUlOVkFMIC4NCi5CIEVO
T1NQQw0KaXMgc3RpbGwgcmV0dXJuZWQgaWYgeW91IHRyeSB0byByZWFkIHJl
c3VsdHMgaW50bw0KdG9vIHNtYWxsIGEgYnVmZmVyLg0KDQouU0ggVkVSU0lP
Tg0KDQouQlIgcGVyZl9ldmVudF9vcGVuICgpDQp3YXMgaW50cm9kdWNlZCBp
biBMaW51eCAyLjYuMzEgYnV0IHdhcyBjYWxsZWQNCi5CUiBwZXJmX2NvdW50
ZXJfb3BlbiAoKSAuDQpJdCB3YXMgcmVuYW1lZCBpbiBMaW51eCAyLjYuMzIu
DQoNCi5TSCBDT05GT1JNSU5HIFRPDQoNClRoaXMgY2FsbCBpcyBzcGVjaWZp
YyB0byBMaW51eA0KYW5kIHNob3VsZCBub3QgYmUgdXNlZCBpbiBwcm9ncmFt
cyBpbnRlbmRlZCB0byBiZSBwb3J0YWJsZS4NCg0KLlNIIE5PVEVTDQpHbGli
YyBkb2VzIG5vdCBwcm92aWRlIGEgd3JhcHBlciBmb3IgdGhpcyBzeXN0ZW0g
Y2FsbDsgY2FsbCBpdCB1c2luZw0KLkJSIHN5c2NhbGwgKDIpLg0KDQpUaGUg
b2ZmaWNpYWwgd2F5IG9mIGtub3dpbmcgaWYNCi5CUiBwZXJmX2V2ZW50X29w
ZW4oKQ0Kc3VwcG9ydCBpcyBlbmFibGVkIGlzIGNoZWNraW5nDQpmb3IgdGhl
IGV4aXN0ZW5jZSBvZiB0aGUgZmlsZQ0KLkkgL3Byb2Mvc3lzL2tlcm5lbC9w
ZXJmX2V2ZW50X3BhcmFub2lkDQoNCi5TSCBCVUdTDQoNClRoZQ0KLkIgRl9T
RVRPV05fRVgNCm9wdGlvbiB0bw0KLklSIGZjbnRsICgyKQ0KaXMgbmVlZGVk
IHRvIHByb3Blcmx5IGdldCBvdmVyZmxvdyBzaWduYWxzIGluIHRocmVhZHMu
DQpUaGlzIHdhcyBpbnRyb2R1Y2VkIGluIExpbnV4IDIuNi4zMi4NCg0KUHJp
b3IgdG8gTGludXggMi42LjMzIChhdCBsZWFzdCBmb3IgeDg2KSB0aGUga2Vy
bmVsIGRpZCBub3QgY2hlY2sNCmlmIGV2ZW50cyBjb3VsZCBiZSBzY2hlZHVs
ZWQgdG9nZXRoZXIgdW50aWwgcmVhZCB0aW1lLg0KVGhlIHNhbWUgaGFwcGVu
cyBvbiBhbGwga25vd24ga2VybmVscyBpZiB0aGUgTk1JIHdhdGNoZG9nIGlz
IGVuYWJsZWQuDQpUaGlzIG1lYW5zIHRvIHNlZSBpZiBhIGdpdmVuIHNldCBv
ZiBldmVudHMgd29ya3MgeW91IGhhdmUgdG8NCi5CUiBwZXJmX2V2ZW50X29w
ZW4gKCksDQpzdGFydCwgdGhlbiByZWFkIGJlZm9yZSB5b3Uga25vdyBmb3Ig
c3VyZSB5b3UNCmNhbiBnZXQgdmFsaWQgbWVhc3VyZW1lbnRzLg0KDQpQcmlv
ciB0byBMaW51eCAyLjYuMzQgZXZlbnQgY29uc3RyYWludHMgd2VyZSBub3Qg
ZW5mb3JjZWQgYnkgdGhlIGtlcm5lbC4NCkluIHRoYXQgY2FzZSwgc29tZSBl
dmVudHMgd291bGQgc2lsZW50bHkgcmV0dXJuICIwIiBpZiB0aGUga2VybmVs
DQpzY2hlZHVsZWQgdGhlbSBpbiBhbiBpbXByb3BlciBjb3VudGVyIHNsb3Qu
DQoNClByaW9yIHRvIExpbnV4IDIuNi4zNCB0aGVyZSB3YXMgYSBidWcgd2hl
biBtdWx0aXBsZXhpbmcgd2hlcmUgdGhlDQp3cm9uZyByZXN1bHRzIGNvdWxk
IGJlIHJldHVybmVkLg0KDQpLZXJuZWxzIGZyb20gTGludXggMi42LjM1IHRv
IExpbnV4IDIuNi4zOSBjYW4gcXVpY2tseSBjcmFzaCB0aGUga2VybmVsIGlm
DQoiaW5oZXJpdCIgaXMgZW5hYmxlZCBhbmQgbWFueSB0aHJlYWRzIGFyZSBz
dGFydGVkLg0KDQpQcmlvciB0byBMaW51eCAyLjYuMzUsDQouQiBQRVJGX0ZP
Uk1BVF9HUk9VUA0KZGlkIG5vdCB3b3JrIHdpdGggYXR0YWNoZWQgcHJvY2Vz
c2VzLg0KDQpJbiBvbGRlciBMaW51eCAyLjYgdmVyc2lvbnMsDQpyZWZyZXNo
aW5nIGFuIGV2ZW50IGdyb3VwIGxlYWRlciByZWZyZXNoZWQgYWxsIHNpYmxp
bmdzLA0KYW5kIHJlZnJlc2hpbmcgd2l0aCBhIHBhcmFtZXRlciBvZiAwIGVu
YWJsZWQgaW5maW5pdGUgcmVmcmVzaC4NClRoaXMgYmVoYXZpb3IgaXMgdW5z
dXBwb3J0ZWQgYW5kIHNob3VsZCBub3QgYmUgcmVsaWVkIG9uLg0KDQpUaGVy
ZSBpcyBhIGJ1ZyBpbiB0aGUga2VybmVsIGNvZGUgYmV0d2Vlbg0KTGludXgg
Mi42LjM2IGFuZCBMaW51eCAzLjAgdGhhdCBpZ25vcmVzIHRoZQ0KIndhdGVy
bWFyayIgZmllbGQgYW5kIGFjdHMgYXMgaWYgYSB3YWtldXBfZXZlbnQNCndh
cyBjaG9zZW4gaWYgdGhlIHVuaW9uIGhhcyBhDQpub24temVybyB2YWx1ZSBp
biBpdC4NCg0KQWx3YXlzIGRvdWJsZS1jaGVjayB5b3VyIHJlc3VsdHMhICBW
YXJpb3VzIGdlbmVyYWxpemVkIGV2ZW50cw0KaGF2ZSBoYWQgd3JvbmcgdmFs
dWVzLg0KRm9yIGV4YW1wbGUsIHJldGlyZWQgYnJhbmNoZXMgbWVhc3VyZWQN
CnRoZSB3cm9uZyB0aGluZyBvbiBBTUQgbWFjaGluZXMgdW50aWwgTGludXgg
Mi42LjM1Lg0KDQouU0ggRVhBTVBMRQ0KVGhlIGZvbGxvd2luZyBpcyBhIHNo
b3J0IGV4YW1wbGUgdGhhdCBtZWFzdXJlcyB0aGUgdG90YWwNCmluc3RydWN0
aW9uIGNvdW50IG9mIGEgY2FsbCB0byBwcmludGYoKS4NCi5uZg0KDQojaW5j
bHVkZSA8c3RkbGliLmg+DQojaW5jbHVkZSA8c3RkaW8uaD4NCiNpbmNsdWRl
IDx1bmlzdGQuaD4NCiNpbmNsdWRlIDxzdHJpbmcuaD4NCiNpbmNsdWRlIDxz
eXMvaW9jdGwuaD4NCiNpbmNsdWRlIDxsaW51eC9wZXJmX2V2ZW50Lmg+DQoj
aW5jbHVkZSA8YXNtL3VuaXN0ZC5oPg0KDQpsb25nIHBlcmZfZXZlbnRfb3Bl
biggc3RydWN0IHBlcmZfZXZlbnRfYXR0ciAqaHdfZXZlbnQsIHBpZF90IHBp
ZCwNCiAgICAgICAgICAgICAgICAgICAgICBpbnQgY3B1LCBpbnQgZ3JvdXBf
ZmQsIHVuc2lnbmVkIGxvbmcgZmxhZ3MgKQ0Kew0KICAgIGludCByZXQ7DQoN
CiAgICByZXQgPSBzeXNjYWxsKCBfX05SX3BlcmZfZXZlbnRfb3BlbiwgaHdf
ZXZlbnQsIHBpZCwgY3B1LA0KICAgICAgICAgICAgICAgICAgIGdyb3VwX2Zk
LCBmbGFncyApOw0KICAgIHJldHVybiByZXQ7DQp9DQoNCg0KaW50DQptYWlu
KGludCBhcmdjLCBjaGFyICoqYXJndikNCnsNCg0KICAgIHN0cnVjdCBwZXJm
X2V2ZW50X2F0dHIgcGU7DQogICAgbG9uZyBsb25nIGNvdW50Ow0KICAgIGlu
dCBmZDsNCg0KICAgIG1lbXNldCgmcGUsIDAsIHNpemVvZihzdHJ1Y3QgcGVy
Zl9ldmVudF9hdHRyKSk7DQogICAgcGUudHlwZSA9IFBFUkZfVFlQRV9IQVJE
V0FSRTsNCiAgICBwZS5zaXplID0gc2l6ZW9mKHN0cnVjdCBwZXJmX2V2ZW50
X2F0dHIpOw0KICAgIHBlLmNvbmZpZyA9IFBFUkZfQ09VTlRfSFdfSU5TVFJV
Q1RJT05TOw0KICAgIHBlLmRpc2FibGVkID0gMTsNCiAgICBwZS5leGNsdWRl
X2tlcm5lbCA9IDE7DQogICAgcGUuZXhjbHVkZV9odiA9IDE7DQoNCiAgICBm
ZCA9IHBlcmZfZXZlbnRfb3BlbigmcGUsIDAsIFwtMSwgXC0xLCAwKTsNCiAg
ICBpZiAoZmQgPCAwKSB7DQogICAgICAgZnByaW50ZihzdGRlcnIsICJFcnJv
ciBvcGVuaW5nIGxlYWRlciAlbGx4XFxuIiwgcGUuY29uZmlnKTsNCiAgICB9
DQoNCiAgICBpb2N0bChmZCwgUEVSRl9FVkVOVF9JT0NfUkVTRVQsIDApOw0K
ICAgIGlvY3RsKGZkLCBQRVJGX0VWRU5UX0lPQ19FTkFCTEUsIDApOw0KDQog
ICAgcHJpbnRmKCJNZWFzdXJpbmcgaW5zdHJ1Y3Rpb24gY291bnQgZm9yIHRo
aXMgcHJpbnRmXFxuIik7DQoNCiAgICBpb2N0bChmZCwgUEVSRl9FVkVOVF9J
T0NfRElTQUJMRSwgMCk7DQogICAgcmVhZChmZCwgJmNvdW50LCBzaXplb2Yo
bG9uZyBsb25nKSk7DQoNCiAgICBwcmludGYoIlVzZWQgJWxsZCBpbnN0cnVj
dGlvbnNcXG4iLCBjb3VudCk7DQoNCiAgICBjbG9zZShmZCk7DQp9DQouZmkN
Cg0KLlNIICJTRUUgQUxTTyINCi5CUiBmY250bCAoMiksDQouQlIgbW1hcCAo
MiksDQouQlIgb3BlbiAoMiksDQouQlIgcHJjdGwgKDIpLA0KLkJSIHJlYWQg
KDIpDQo=

--8323329-940803195-1351006515=:24986--
