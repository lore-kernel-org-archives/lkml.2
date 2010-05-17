Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0EQSYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:24:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab0EQSYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:24:13 -0400
Message-ID: <4BF18995.6070008@redhat.com>
Date: Mon, 17 May 2010 15:23:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bluesmoke-devel@lists.sourceforge.net,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
       Brent Young <brent.young@intel.com>
Subject: Hardware Error Kernel Mini-Summit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the last LF Collaboration Summit, we've done a mini-summit [1],
intended to improve the hardware error detection in kernel, currently
provided by MCE and EDAC subsystems.

The idea of this mini-summit came up after Thomas Gleixner and Ingo
Molnar suggestions that edac and mce should converge into an error
subsystem.

I'm enclosing the minutes of the meeting, in order to allow it to be
reviewed by other kernel hackers that are interested on the theme but
unfortunately couldn't come to the meeting.

Btw, during the meeting, it were decided that EDAC ML could better work
if moved to vger, so I'm copying here both the old and the new edac
mailing lists.

[1] http://events.linuxfoundation.org/lfcs2010/edac

---


	I Hardware Error Kernel Mini-Summit
	===================================
				April, 15 - San Francisco, CA, US
				2010 Linux Foundation Collaboration Summit

Attendees:
	Ben Woodard   - Red Hat
	Brent Young   - Intel
	Doug Thompson - LLNL
	Mark Grondona - LLNL
	Matt Domsch   - Dell
	Mauro Chehab  - Red Hat
	Tony Luck     - Intel

After some initial description of the current state of error
handling in Linux, we moved to work on requirements and high
level design of the system going forward.

Requirements
============

First and foremost is that end-users (presumably system administrators)
need notification of the hardware component that is the source of each
error.  Ideally this should include "silk screen" markings so that the
user can identify which component is at fault.

Other requirements may vary amongst different types of end users, but
include:
+ Minimal disruption to system performance when logging corrected errors.
+ Assurance that h/w error detection mechanisms are correctly configured
  and enabled.
+ System topology information

Wit respect to System topology, it was poined that LLNL is concerned about
being sure that ECC is enabled, as some BIOS'es lied about that in the past.
Also, memory topology information is needed to allow matching the silk 
screen labels from the hardware with each reported DIMM.


Design - dividing the problem into logical layers
=================================================

It was agreed that a hardware error driver should be mapped on those layers:

	[Userspace API]
	[core layer]
	[Low level drivers]

At the lowest level is the task of collecting error information from
hardware and/or firmware (LLNL call this "harvesting").  There is
already wide diversity between architectures, and even platforms
within the same architecture. So it make sense for there to be some
low level, platform specific, drivers that collect data in whatever
way they can - and present it to some "core" layer in the kernel
that will provide abstraction/uniformity to higher levels of the
software stack.

Matt Domsch pointed out that the 4.0a version of the ACPI specification
includes a chapter on "APEI" - features drawn from the WHEA (Windows
Hardware Error Architecture). These features are already implemented
by some BIOS vendors - and will become more widespread.  When this
is present (and determined to be correctly implemented) it makes
sense to use this for error harvesting. When it isn't (e.g. on
architectures not graced with ACPI support) a more traditional
memory controller driver that reads chipset registers can be used
instead.

In the middle layer - we just waved our hands a bit and said that there
was some generic core code.  Doug volunteered to re-factor other code
to create this.

The middle layer should provide ways to map some number of parameters to
a FRU (field replaceable unit). 
	f(a,b,c,d) => FRU
some examples could be:
        f( CPU socket, MC, channel, DIMM) => memory FRU
        f( phy addr) => memory FRU
        f( ? ) => processor FRU

The FRU is the most important thing from the customer or system
administrator's perspective. For example, they are not terribly
interested in the memory hierarchy or the way that the machine is put
together, that is really only interesting to hardware engineers. After
the machine is bought, when they have an error they are most concerned
with finding the component that they need to replace to get the machine
fully operational again.

Some of the challenges that make this mapping difficult are:
Mirrored memory
     1. Hot spare memory
     2. Logical vs. physical DIMMs
     3. Interleaved memory
     4. complicated memory like mainframes have.
     5. Uncertainty in where the error actually is. In other words there 
are times when the most that the hardware is able to know is that the 
problem appears to be on DIMM[1-3]. How to portray that to the user is 
one topic that was never resolved.
     6. Right now the memory controller is the only one that has this
information because it had to know this information when it setup the
memory controller and this information is currently only available to
BIOS writers.

The FRU needs to be broader than just DIMMs, it can be any field 
replaceable component. Some examples beginning with 
/sys/devices/system/EDAC/:
     * UP machine:        ...MC/DIMM[0-4]/CSROW
     * SMP machine: .      ..MC/MC[x]/DIMM[0-4]/CSROW
     * Nehalem EP, AMD:    ..MC/MC[x]/CHAN[y]/DIMM
      * Nehalem EX:          NODE[z]/MC[x]/CHAN[y]/RISER[a]/DIMM

In these directories there will be at least an attribute named 'ce' and 
'ue' attributes 

The uppper layer presents error data to user-space.  The EDAC model of
a forest of /sys attribute files based on csrows within DIMMs used to
provide both error counts for each object as well as topology information.

Andi Kleen's /dev/mcelog has met with strong opposition from Ingo Molnar
and Thomas Gleixner.  They suggested that the "performance event" mechanism
has already been extended to report numerous non-performance related
kernel events - and it would be a logical extension to include hardware
error events too.  LLNL representatives said they could code to any
reporting methodology.

Some discussion on how performance events are managed by the kernel
and the options available to user programs to register interest in
events followed.  One potential challenge is that the kernel hooks
that log events will silently drop events when there are no processes
registered to collect data.  This will require some cleverness to work
out how to log data from fatal errors that caused a system reboot - as
these must be discovered and cleared from hardware registers before any
userspace code is running.

Other notes
===========
The ACPI4.0a specification also documents an error injection interface.
When supported in a BIOS (and, as usual, assuming it is correctly
implemented) this should allow for more widespread testing of the
error handling code.  It may provide some limited assurance that
hardware error detection features are enabled.

Both HPC (High Performance Computing) and FSA (Financial Services) users
have performance requirements that are intolerant of interruption by
SMI code running in the BIOS.  When these interruptions extend for
milli-seconds: cluster performance suffers or trade executions miss
the profit window.  Going forward there are rules/recommendations
(I'm not sure how strict) that SMI interrupts should limit themselves
to 200 micro seconds.  It is unclear whether SMI that adds this much
latency to the error harvesting overhead will cause noticeable problems
to either HPC or FSA customers. The lack of clarity is mostly because
h/w error logging is just one of many reasons why a processor may take
an SMI interrupt, and it is unknown whether hardware errors would make
up a significant percentage of total SMI events.

There is an immediate need for error reporting on NHM-EP class systems.
Mauro will work on cleaning up his EDAC code for these to be included
in some RHEL 5.x update.  Less certainty on whether this will be suitable
for 6.x series.

In the specific case of Nehalem-EX, it seems that the low level driver
won't be able to use direct access to the memory controller registers, 
since the uncore now uses a register index/value pair to read or write 
from the memory controller. The same pair is also used by BIOS to control 
the hardware. With this design, race conditions between BIOS and the OS 
may happen, So, even reading data from the Memory Controller registers 
is not possible. So, it will need to use some logic to communicate via 
BIOS, probably via ACPI 4.0 APEI.

The Bluesmoke mailing list hosted at sourceforge has been overrun by
spammers.  Doug will talk to admins at vger.kernel.org to ask them to
host a new list there.

Next Steps
==========

It as agreed that the next steps will be:

1) Write a summary of the meeting - responsible: Ben Woodward;

2) After having the summary reviewed, produce an email to be sent to to 
LKML, in order to get upstream comments, especially from Thomas and 
Ingo - responsible: Mauro Carvalho Chehab;

3) Write EDAC core changes - responsible: Doug Thompson (EDAC maintainer);

4) Port i7core_edac (Nehalem and Nehalem-EP) to the new EDAC core structs 
(the name of the driver will likely be changed, as it works not only with 
i7 core chips) - Responsible: Mauro Carvalho Chehab;

5) Write a driver for Nehalem-EX using the new EDAC core - Responsible: 
Tony Luck.

