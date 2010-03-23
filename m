Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab0CWKzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 06:55:37 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:55625 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab0CWKze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 06:55:34 -0400
Date: Tue, 23 Mar 2010 16:25:29 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v1 0/10] Uprobes patches.
Message-ID: <20100323105529.GA16818@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
 <20100322213836.56a82d34.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100322213836.56a82d34.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

> 
> > This patchset implements Uprobes which enables you to dynamically break
> > into any routine in a user space application and collect information
> > non-disruptively.
> 
> What's missing here is a description of why all this is useful. 
> Presumably much of the functionality which this feature offers can be
> done wholly in userspace.  So I think it would be useful if you were to
> carefully explain the thinking here - what the value is, how people
> will use it, why it needs to be done in-kernel, etc.  Right now if I
> was asked "why did you merge that", I'd say "gee, I dunno".  I say that
> a lot.  Knowing all of this would perhaps help me to understand your
> thinking regarding ftrace integration.

Main motivations for uprobes 
- non-disruptive tracing.
Current ptrace based mechanisms generally involve signals and stopped
threads. Also it involves context switching between the tracer and
tracee. The delay and involvement of signals can result in problems seen
in production systems not seen while tracing. Uprobes tracing wouldnt
involve signals, context switches between tracer and tracee.

- Multithreaded support.
Current ptrace based mechanisms for tracing apps use single stepping
inline, i.e they copy back the original instruction on hitting a breakpoint.
In such mechanisms tracers have to stop all the threads on a breakpoint hit
or tracers will not be able to handle all hits to the location of
interest. Uprobes uses execution out of line, where the instruction to
be traced is analysed at the time of breakpoint insertion and a copy of
instruction is stored at a different location.  On breakpoint hit,
uprobes jumps to that copied location and singlesteps the same
instruction and does the necessary fixups post singlestepping.

- Tracing multiple applications:
A uprobe based tracer would be able to trace multiple (similar or
different) applications. This could be very useful in understanding how
different applications are interacting with each other.

- Multiple tracers for an application:
Multiple uprobes based tracer could work in unison to trace an
application. There could one tracer that could be interested in generic
events for a particular set of process. While there could be another
tracer that is just interested in one specific event of a particular
process thats part of the previous set of process.

- Corelating events from kernels and userspace.
Uprobes could be used with other tools like kprobes, tracepoints or as
part of higher level tools like perf to give a consolidated set of
events from kernel and userspace.
In future we could look at a single backtrace showing application,
library and kernel calls.


We are looking at providing a perf interface for uprobes.
Last year based on inputs from Christoph and Roland, Frank and I had
developed a prototype gdbstub which used uprobes to insert/remove
breakpoints.

Uprobes has been used to make use of dtrace style application markers
already present in applications 

If community is favourable, we could have a syscall to insert/remove
breakpoints so that gdb or other debuggers could benefit. Here is some
discussion on this idea (http://lkml.org/lkml/2010/1/26/344)

> The code itself is positioned as non-x86-specific, but the
> implementation is x86-only.  It would be nice to get some confirmation
> that other architectures can successfully use the core code.  But that
> will be hard to arrange, so probably crossing our fingers is the best
> approach here.

We do have some bits for Powerpc and S390 though they are not updated to
the current bits. So I know core code can work with other architectures.
Once the core code gets merged, I will work to get these other
architectures to use core code.

> 
> The code scares me a bit from the "how can malicious people exploit it"
> point of view.  Breaking into other users programs/memory, causing the
> kernel to scribble on itself, causing unbound memory consumption, etc. 
> No specific issues that I can point at, just vague fear.

Users of uprobes could use capabilities to restrict who can trace a
process. Currently we restrict the area allocated for the slots to be
one page. We could also look at restricting the number of processes that
could be uprobed at a time. 
Do you have ideas on what other measures we could take?

> 
> Do we know that exiting userspace will never ever already be using int3?

User_bkpt layer (and hence uprobes) will not insert breakpoints if a
breakpoint already exists at that address. If the user program traps on
a int3 that is not inserted by user_bkpt/uprobes, then user_bkpt/uprobes
will allow not handle such int3. uprobes only handles breakpoints that
it has inserted.

> 
> What happens if I run this code in 2016 on a CPU which has new opcodes
> which this code didn't know about?

user_bkpt is based on x86 instruction decoder. Based on how the x86
instruction decoder handles the opcodes, we would have to update the
good set of instructions for userspace. This good set of instructions is
currently maintained in user_bkpt layer. However Masami was proposing
using bits in inat instruction table to know if the instructions are
valid and boostable. Once that gets implemented, uprobes maintainance
for newcodes would mostly be moved to x86 instruction decoder.

However this might vary for other architectures.

> 
> When uprobes was being pushed five-odd years ago, it did all sorts of
> hair-raising things to avoid COWing shared pages.  Lots of reasons were
> given why it *had* to avoid COW.  But now it COWs.  What were those
> reasons why COW was unacceptable, and what changed?
> 

Some of the ideas put forth by the community including you made us
rethink that COW was probably better. This also influenced us from
moving from a file/executable based approach to a process based
approach. I am hopeful of implementing a file based tracing on a process
based uprobes. The details are still to be hashed out.

http://lkml.indiana.edu/hypermail/linux/kernel/0603.2/1821.html
lists your mail where you suggested a process based tracing over a
file/executable based tracing.

Reasons listed then for not doing a COW
- Tracing instructions in a page thats not yet loaded will result in a
  new page being loaded into memory immediately.
- Tracing same code in shared libraries could result in multiple copies
  of the same page being loaded into memory.

So not using COW probably means we will have more pages loaded into
memory but as pointed out by you and others in community, its probably
simpler and cleaner. 

Infact what we are doing is not COW but a background page replacement as
was suggested by Linus, Peter and Mel. I.e, we explicitly make a copy of
the page, modify it and then update the page tables to reflect the new
page. (http://lkml.org/lkml/2010/1/27/89)

Please let me know if there is anything that I can clarify.

--
Thanks and Regards
Srikar
