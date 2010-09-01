Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0IAL3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 07:29:20 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37865 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751384Ab0IAL3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 07:29:19 -0400
Date: Wed, 1 Sep 2010 07:29:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: [RFC] Common Trace Format Requirements (v1.3)
Message-ID: <20100901112915.GA32715@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 07:25:17 up 221 days, 14:02,  4 users,  load average: 0.06, 0.20,
	0.53
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I am re-sending this trace format requirements document to LKML, because it
looks like the too long recipient list caught their spam filter.)

Hi,

  The goal of the present document is to propose a trace format that will suit
the needs of the embedded, telecom, high-performance and kernel communities. It
starts by doing an overview of the trace format, tracer and trace analyzer
requirements to consider for a Common Trace Format proposal.

This is a follow-up on what I presented at LinuxCon 2010:
"Efficient Trace Format for System-Wide Tracing"

http://www.efficios.com/linuxcon2010 (slides)

Feedback is welcome!

Thanks,

     Mathieu


This document includes requirements from:

Steven Rostedt <rostedt@goodmis.org>
Dominique Toupin <dominique.toupin@ericsson.com>
Aaron Spear <aaron_spear@mentor.com>
Philippe Maisonneuve <Philippe.Maisonneuve@windriver.com>
Felix Burton <Felix.Burton@windriver.com>
Andrew McDermott <Andrew.McDermott@windriver.com>
Multi-Core Association Tool Infrastructure Workgroup
   (http://www.multicore-association.org/workgroup/tiwg.php)


* Trace Format Requirements

  These are requirements on the trace format itself. This section discusses the
layout of data in the trace, explaining the rationale behind the choices. The
rationale for the trace format choices may refer to the tracer and trace
analyzer requirements stated below. This section starts by presenting the common
trace model, and then specifies the requirements of an instance of this model
specifically tailored to efficient kernel- and user-space tracing requirements.


1) Architecture

This high-level model is meant to be an industry-wide, common model, fulfilling
the tracing requirements. It is meant to be application-, architecture-, and
language-agnostic.

1.1) Core model

- Event

An event is an information record contained within the trace.

  - Events must be in physical order within a section
  - Event type (numeric identifier: maps to metadata)
    - Unique ID assigned within a section.
  - Event payload
    - Variable event size
    - Size limitations: maximum event size should be configurable.
    - Size information available through metadata.
    - Support various data alignment for architectures, standards, and
      languages:
      - Natural alignment of data for architectures with slow non-aligned
        writes.
      - Packed layout of headers for architecture with efficient non-aligned
        writes.

- Section

A section within the trace can be thought of as the ELF sections in a ELF
binary. They contain a sequence of physically contiguous event records.

  - Multi-level section identifier
    - e.g.: section name / CPU number
  - Contains a subset of event types

- Metadata

Metadata is the description of the setting of the environment of the
application. Defines the basic types of the domains. Will define the mapping
between the event, and the type of the event fields. The metadata scope (what it
describes) is a whole trace, which consists of one or many sections.

The metadata can be either contained in the trace (better usability for telecom
scenarios) or added alongside the trace data by a separate module (for DSP
scenarios). Metadata checksumming and/or versioning can be used to ensure
consistency between sections and metadata in the latter.

  - Trace version
    - Major number (increment breaks compabilility)
    - Minor number (increment keeps compatibility)
  - Describe the invariant properties of the environment where the trace was
    generated.
    - Contain unique domain identifier (kernel, process ID and timestamp,
      hypervisor)
    - Describes the runtime environment.
    - Report target bitness
    - Report target byte order
    - Data types (see section 1.2 Extensions below)
  - Architecture-agnostic (text-based)
  - Ought to be parsed with a regular grammar
  - Mapping to event types, e.g. (section, event) tuples, with:
      ( section identifier, event numerical identifier )
  - Description of event context fields (per section)
  - Can be streamed along with the trace as a trace section
  - Support dynamic addition of events while trace is active (module loading)
  - Metadata section should be efficient and reliable. Additional information
    could be kept in separate sections, outside of metadata.
  - Metadata description language not imposed by standard


1.2) Extensions (optional capabilities)

- Event
  - Optional context (thread id, virtual cpu id, execution mode (irq/bh/thread),
                      CPU/board/node id, event ordering identifier, timestamp,
                      current hardware performance counter information, event
                      size)
    - Optional ordering capability across sections:
      - Ordering identifier required for trace containing many event streams
      - Either timestamp-based or based on unique sequence numbers
    - Optional time-flow capability: per-event timestamps

- Section
  - Optional context applying to all events contained in that section
    (thread id, virtual cpu id, execution mode (irq/bh/thread), CPU/board/node
     id)
  - Support piece-wise compression
  - Support checksumming

- Metadata
  - Execution environment information
    - Data types available: integer, strings, arrays, sequence, floats,
      structures, maps (aka enumerations), bitfields, ...
      - Describe type alignment.
      - Describe type size.
      - Describe type signedness.
      - Other type examples:
        - gcc "vector" type. (packed data)
          http://gcc.gnu.org/onlinedocs/gcc/Vector-Extensions.html
        - gcc complex type (e.g. complex short, float, double...)
        - gcc _Fract and _Accum http://gcc.gnu.org/wiki/FixedPointArithmetic
          http://gcc.gnu.org/onlinedocs/gcc/Fixed_002dPoint.html
  - Describes trace capabilities, for instance:
    - Event ordering across sections
    - Time flow information
      - In event header
      - Or possibly payload of pre-specified sections and/or events
    - Ability to perform event ordering across traces


2) Linux-specific Model

   (Linux instance, specific to the reference implementation)

Instance of the model specifically tailored to the Linux kernel and C
programs/libraries requirements. Allows for either packed events, or events
aligned following the ISO/C standard.

- Event
  - Payload
    - Initially support ISO C naturally aligned and packed type layouts.

- Each section represented as a trace stream (typically 1 trace stream per cpu
  per section) to allow the tracer to easily append to these sections.
  Identifier: section name / CPU ID
  Each section has a CPU ID identifier in its context information.

- Trace stream
  - Should have no hard-coded limit on size of a file generated by saving the
    trace stream (64 bit file position is fine)
  - Event lost count should be localized. It should apply to a limited time
    interval and to a tracefile, hence to a specific section, so the trace
    analyzer can provide basic information about what kind of events were lost
    and where they were lost in the trace.
  - Should be optionally compressible piece-wise.
  - Optional checksum on the sub-buffer content (except sub-buffer header), with
    a selection of checksum algorithms.
  - Sub-buffer headers should contain a sequence number to help UDP streaming
    reassembly.

- Compact representation
  - Minimize the overhead in terms of disk/network/serial port/memory bandwidth.
  - A compact representation can keep more information in smaller buffers,
    thus needs less memory to keep the same amount of information around.
    Also useful to improve cache locality in flight recorder mode.

- Natural alignment of headers for architectures with slow non-aligned writes.

- Packed layout of headers for architecture with efficient non-aligned writes.

- Should have a 1 to 1 mapping between the memory buffers and the generated
  trace files: allows zero-copy with splice().

- Use target endianness

- Portable across different host target (tracer)/host (analyzer) architectures

- It should be possible to generate metadata from descriptions written in header
  files (extraction with C preprocessor macros is one solution).


* Requirements on the Tracers

Higher-level tracer requirements that seem appropriate to support some of the
trace format requirements stated above.


*Fast*
- Low-overhead
- Handle large trace throughput (multi-GB per minutes)
- Scalable to high number of cores
  - Per-cpu memory buffers
  - Scalability and performance-aware synchronization

*Compact*
- Environments without filesystem
  - Need to buffer events in target RAM to send them in group a host for
    analysis
- Ability to tune the size of buffers and transmission medium to minimize the
  impact on the traced system.
- Streaming (live monitoring)
  - Through sockets (USB, network)
  - Through serial ports
  - There must be a related protocol for streaming this event data.

- Availability of flight recorder (synonym: overwrite) mode
  - Exclusive ownership of reader data.
  - Buffer size should be per group of events.

- Output trace to disk
- Trace buffers available in crash dump to allow post-mortem analysis
- Fine-grained timestamps

- Lockless (lock-free, ideally wait-free; aka starvation-free)

- Buffer introspection: event written, read and lost counts.

- Ability to iteratively narrow the level of details and traced time window
  following an initial high level "state" overview provided by an initial trace
  collecting everything.

- Support kernel module instrumentation

- Standard way(s) for a host to upload/access trace log data from a
  target/JTAG device/simulator/etc.

- Conditional tracing in kernel space.

- Compatibility with power management subsystem (trace collection shall not be a
  reason for waking up a device)

- Well defined and stable trace configuration and control API across kernel
  versions.

- Create and run more than one trace session in parallel at the same time
  - monitoring from system administrators
  - field engineered to troubleshoot a specific problem


* Trace Analyzer Requirements

- Ability to cope with huge traces (> 10 GB)
- Should be possible to do a binary search on the file to find events by time
  at least. (combined with smart indexing/ summary data perhaps)
- File format should be as dense as possible, but not at the expense of
  analysis performance (faster is more important than bigger since disks are
  getting cheaper)
- Must not be required to scan through all events in order to start
  analyzing (by time anyway)
- Support live viewing of trace streams
- Standard description of a trace event context.
  (PERI-XML calls it "Dimensions")
- Manage system-wide event scoping with the following hierarchy:
  (address space identifier, section name, event name)

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
