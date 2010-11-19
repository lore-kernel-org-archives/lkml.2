Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0KSN4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 08:56:19 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52543 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab0KSN4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 08:56:16 -0500
Message-ID: <a6a56c8a0426c6e46de1a9361cebcd63.squirrel@www.skyhub.de>
In-Reply-To: <1290154233-28695-2-git-send-email-ying.huang@intel.com>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
    <1290154233-28695-2-git-send-email-ying.huang@intel.com>
Date: Fri, 19 Nov 2010 14:56:12 +0100 (CET)
Subject: Re: [PATCH 1/2] Generic hardware error reporting mechanism
From: boris@alien8.de
To: "Huang Ying" <ying.huang@intel.com>
Cc: "Len Brown" <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        "Andi Kleen" <andi@firstfloor.org>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, "Peter Zijlstra" <peterz@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Ingo Molnar" <mingo@elte.hu>,
        "Mauro Carvalho Chehab" <mchehab@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>,
        "Thomas Gleixner" <tglx@linutronix.de>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Putting aside the fact that you've ignored all the requests from the
last round...

On Fri, Nov 19, 2010 at 04:10:32PM +0800, Huang Ying wrote:
> There are many hardware error detecting and reporting components in
> kernel, including x86 Machine Check, PCIe AER, EDAC, APEI GHES
> etc. Each one has its error reporting implementation, including user
> space interface, error record format, in kernel buffer, etc. This
> patch provides a generic hardware error reporting mechanism to reduce
> the duplicated effort and add more common services.
>
>
> A highly extensible generic hardware error record data structure is
> defined to accommodate various hardware error information from various
> hardware error sources. The overall structure of error record is as
> follow:
>
>   -----------------------------------------------------------------
>   | rcd hdr | sec 1 hdr | sec 1 data | sec 2 hdr | sec2 data | ...
>   -----------------------------------------------------------------
>
> Several error sections can be incorporated into one error record to
> accumulate information from multiple hardware components related to
> one error.  For example, for an error on a device on the secondary
> side of a PCIe bridge, it is useful to record error information from
> the PCIe bridge and the PCIe device.  Multiple section can be used to
> hold both the cooked and the raw error information.  So that the
> abstract information can be provided by the cooked one and no
> information will be lost because the raw one is provided too.
>
> There are "reversion" (rev) and "length" field in record header and
> "type" and "length" field in section header, so the user space error
> daemon can skip unrecognized error record or error section.  This
> makes old version error daemon can work with the newer kernel.
>
> New error section type can be added to support new error type, error
> sources.

Yes, we need a generic error reporting format. Wait a second, this
error format structure looks very much like a tracepoint record to me -
it has common fields and record-specific fields. And we have all that
infrastructure in the kernel and yet you've decided to reimplement it
anew. Remind me again why?

> The hardware error reporting mechanism designed by the patch
> integrates well with device model in kernel.  struct dev_herr_info is
> defined and pointed to by "error" field of struct device.  This is
> used to hold error reporting related information for each device.  One
> sysfs directory "error" will be created for each hardware error
> reporting device.  Some files for error reporting statistics and
> control are created in sysfs "error" directory.

But all this APEI crap sounds suspiciously bloated - why do we need an
error field for _every_ device on the system? Looks like a bunch of
hoopla for only a few error types...

> For example, the
> "error" directory for APEI GHES is as follow.
>
> /sys/devices/platform/GHES.0/error/logs
> /sys/devices/platform/GHES.0/error/overflows
> /sys/devices/platform/GHES.0/error/throttles
>
> Where "logs" is number of error records logged; "throttles" is number
> of error records not logged because the reporting rate is too high;
> "overflows" is number of error records not logged because there is no
> space available.
>
> Not all devices will report errors, so struct dev_herr_info and sysfs
> directory/files are only allocated/created for devices explicitly
> enable it.  So to enumerate the error sources of system, you just need
> to enumerate "error" directory for each device directory in
> /sys/devices.

So how do you say which devices should report and which shouldn't report
errors, from userspace with a tool? Default actions? What if you forget
to enable error reporting of a device which actually is important?

> One device file (/dev/error/error) which mixed error records from all
> hardware error reporting devices is created to convey error records
> from kernel space to user space.  Because hardware devices are dealt
> with, a device file is the most natural way to do that.  Because
> hardware error reporting should not hurts system performance, the
> throughput of the interface should be controlled to a low level (done
> by user space error daemon), ordinary "read" is sufficient from
> performance point of view.

Right, so no need for a daemon but who does the read? cat? How are you
going to collect all those errors? How do you enforce policies? How
do you inject errors? How do you perform actions based on the error
type like disabling or reconfiguring a hw device based on the errors it
generates?

> The patch provides common services for hardware error reporting
> devices too.
>
> A lock-less hardware error record allocator is provided.  So for
> hardware error that can be ignored (such as corrected errors), it is
> not needed to pre-allocate the error record or allocate the error
> record on stack.  Because the possibility for two hardware parts to go
> error simultaneously is very small, one big unified memory pool for
> hardware errors is better than one memory pool or buffer for each
> device.

Yet another bloat winner. Why do we need a memory allocator for error
records? You either get a single critical error which shuts down the
system and you log it to persistent storage, if possible, or you work at
those uncritical errors one at a time.

IOW, do you have a real-life usecase which justifies the dire need for a
lockless memory allocator specifically for hw errors?

> After filling in all necessary fields in hardware error record, the
> error reporting is quite straightforward, just calling
> herr_record_report, parameters are the error record itself and the
> corresponding struct device.
>
> Hardware errors may burst, for example, same hardware errors may be
> reported at high rate within a short interval, this will use up all
> pre-allocated memory for error reporting, so that other hardware
> errors come from same or different hardware device can not be logged.
> To deal with this issue, a throttle algorithm is implemented.  The
> logging rate for errors come from one hardware error device is
> throttled based on the available pre-allocated memory for error
> reporting.  In this way we can log as many kinds of errors as possible
> comes from as many devices as possible.
>
>
> This patch is designed by Andi Kleen and Huang Ying.
>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> ---
>  drivers/Kconfig               |    2
>  drivers/Makefile              |    1
>  drivers/base/Makefile         |    1
>  drivers/base/herror.c         |   98 ++++++++
>  drivers/herror/Kconfig        |    5
>  drivers/herror/Makefile       |    1
>  drivers/herror/herr-core.c    |  488
++++++++++++++++++++++++++++++++++++++++++
>  include/linux/Kbuild          |    1
>  include/linux/device.h        |   14 +
>  include/linux/herror.h        |   35 +++
>  include/linux/herror_record.h |  100 ++++++++
>  kernel/Makefile               |    1
>  12 files changed, 747 insertions(+)
>  create mode 100644 drivers/base/herror.c
>  create mode 100644 drivers/herror/Kconfig
>  create mode 100644 drivers/herror/Makefile
>  create mode 100644 drivers/herror/herr-core.c
>  create mode 100644 include/linux/herror.h
>  create mode 100644 include/linux/herror_record.h

And as it was said a countless times already, this whole thing, if at
all accepted should go to drivers/edac/ or drivers/ras/ or whatever.

-- 
Regards/Gruss,
Boris.

