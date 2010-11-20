Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab0KTCxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 21:53:00 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64118 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757751Ab0KTCw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 21:52:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rpnxp+AcSfwYE8Y2DSZ81J7UiKOOEflex03mXZn9YDHSGRNACmZNr7zx8no8ICmAn4
         yjL/qqF3zspD72WE6nn/9VsPYH17DU9l8VeUq1WlwFLWZ/VVMcXfFdA0htOTL+MEW0/6
         +7daKZvhNauMQWNhoFqJ3zAsrCQEeZw5NUqsM=
MIME-Version: 1.0
In-Reply-To: <a6a56c8a0426c6e46de1a9361cebcd63.squirrel@www.skyhub.de>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
	<1290154233-28695-2-git-send-email-ying.huang@intel.com>
	<a6a56c8a0426c6e46de1a9361cebcd63.squirrel@www.skyhub.de>
Date: Sat, 20 Nov 2010 10:52:56 +0800
Message-ID: <AANLkTin9AmJbeHOATyK4M8-MmaDGL4XPiVnTG4X=TEkS@mail.gmail.com>
Subject: Re: [PATCH 1/2] Generic hardware error reporting mechanism
From: huang ying <huang.ying.caritas@gmail.com>
To: boris@alien8.de
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 9:56 PM,  <boris@alien8.de> wrote:
> Yes, we need a generic error reporting format. Wait a second, this
> error format structure looks very much like a tracepoint record to me -
> it has common fields and record-specific fields. And we have all that
> infrastructure in the kernel and yet you've decided to reimplement it
> anew. Remind me again why?

You mean "struct trace_entry"? They are quite different on design. The
record format in patch can incorporate multiple sections into one
record, which is meaningful for hardware error reporting. And we do
not need the fancy
"/sys/kernel/debug/tracing/events/<xxx>/<xxx>/format", user space
error daemon only consumes all error record it recognized and blindly
log all other records.

>> The hardware error reporting mechanism designed by the patch
>> integrates well with device model in kernel.  struct dev_herr_info is
>> defined and pointed to by "error" field of struct device.  This is
>> used to hold error reporting related information for each device.  One
>> sysfs directory "error" will be created for each hardware error
>> reporting device.  Some files for error reporting statistics and
>> control are created in sysfs "error" directory.
>
> But all this APEI crap sounds suspiciously bloated

There is no APEI specific code in this patch.

> - why do we need an
> error field for _every_ device on the system? Looks like a bunch of
> hoopla for only a few error types...

Because every device may report hardware errors, but not every device
will do it. So just a pointer is added to "struct device" and
corresponding data structure is only created when needed.

>> For example, the
>> "error" directory for APEI GHES is as follow.
>>
>> /sys/devices/platform/GHES.0/error/logs
>> /sys/devices/platform/GHES.0/error/overflows
>> /sys/devices/platform/GHES.0/error/throttles
>>
>> Where "logs" is number of error records logged; "throttles" is number
>> of error records not logged because the reporting rate is too high;
>> "overflows" is number of error records not logged because there is no
>> space available.
>>
>> Not all devices will report errors, so struct dev_herr_info and sysfs
>> directory/files are only allocated/created for devices explicitly
>> enable it.  So to enumerate the error sources of system, you just need
>> to enumerate "error" directory for each device directory in
>> /sys/devices.
>
> So how do you say which devices should report and which shouldn't report
> errors, from userspace with a tool? Default actions? What if you forget
> to enable error reporting of a device which actually is important?

In general all hardware errors should be reported and logged.

>> One device file (/dev/error/error) which mixed error records from all
>> hardware error reporting devices is created to convey error records
>> from kernel space to user space.  Because hardware devices are dealt
>> with, a device file is the most natural way to do that.  Because
>> hardware error reporting should not hurts system performance, the
>> throughput of the interface should be controlled to a low level (done
>> by user space error daemon), ordinary "read" is sufficient from
>> performance point of view.
>
> Right, so no need for a daemon but who does the read? cat? How are you
> going to collect all those errors? How do you enforce policies?

Some summary hardware error information can be put into printk. Error
daemon is needed because we need not only log the the error but the
predictive recovery. If you really have no daemon, cat can be used to
log the error. I don't fully understand your words, you want to
enforce policies without error daemon?

> How do you inject errors?

We can use another device file to inject error, for example
/dev/error/error_inject. Just write the needed information to this
file. The format can be same as the error record defined as above,
because it is highly extensible.

> How do you perform actions based on the error
> type like disabling or reconfiguring a hw device based on the errors it
> generates?

These are policies and will be done in user space error daemon. For
some emergency error recovery actions, we will do it in kernel.

>> The patch provides common services for hardware error reporting
>> devices too.
>>
>> A lock-less hardware error record allocator is provided.  So for
>> hardware error that can be ignored (such as corrected errors), it is
>> not needed to pre-allocate the error record or allocate the error
>> record on stack.  Because the possibility for two hardware parts to go
>> error simultaneously is very small, one big unified memory pool for
>> hardware errors is better than one memory pool or buffer for each
>> device.
>
> Yet another bloat winner. Why do we need a memory allocator for error
> records?

The point is lockless not the memory allocator. The lockless memory
allocator is not hardware error reporting specific, it can be used by
other part of the kernel too.

> You either get a single critical error which shuts down the
> system and you log it to persistent storage, if possible, or you work at
> those uncritical errors one at a time.

Uncritical errors can be reported in NMI handler too. So we need
lockless data structure for them.

> IOW, do you have a real-life usecase which justifies the dire need for a
> lockless memory allocator specifically for hw errors?

No. not special for hw errors. It can be used by other part of kernel.

>> After filling in all necessary fields in hardware error record, the
>> error reporting is quite straightforward, just calling
>> herr_record_report, parameters are the error record itself and the
>> corresponding struct device.
>>
>> Hardware errors may burst, for example, same hardware errors may be
>> reported at high rate within a short interval, this will use up all
>> pre-allocated memory for error reporting, so that other hardware
>> errors come from same or different hardware device can not be logged.
>> To deal with this issue, a throttle algorithm is implemented.  The
>> logging rate for errors come from one hardware error device is
>> throttled based on the available pre-allocated memory for error
>> reporting.  In this way we can log as many kinds of errors as possible
>> comes from as many devices as possible.
>>
>>
>> This patch is designed by Andi Kleen and Huang Ying.
>>
>> Signed-off-by: Huang Ying <ying.huang@intel.com>
>> Reviewed-by: Andi Kleen <ak@linux.intel.com>
>> ---
>>  drivers/Kconfig               |    2
>>  drivers/Makefile              |    1
>>  drivers/base/Makefile         |    1
>>  drivers/base/herror.c         |   98 ++++++++
>>  drivers/herror/Kconfig        |    5
>>  drivers/herror/Makefile       |    1
>>  drivers/herror/herr-core.c    |  488
> ++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/Kbuild          |    1
>>  include/linux/device.h        |   14 +
>>  include/linux/herror.h        |   35 +++
>>  include/linux/herror_record.h |  100 ++++++++
>>  kernel/Makefile               |    1
>>  12 files changed, 747 insertions(+)
>>  create mode 100644 drivers/base/herror.c
>>  create mode 100644 drivers/herror/Kconfig
>>  create mode 100644 drivers/herror/Makefile
>>  create mode 100644 drivers/herror/herr-core.c
>>  create mode 100644 include/linux/herror.h
>>  create mode 100644 include/linux/herror_record.h
>
> And as it was said a countless times already, this whole thing, if at
> all accepted should go to drivers/edac/ or drivers/ras/ or whatever.

You think drivers/herror is not a good name? We can rename it to
"drivers/ras" if that is the consensus.

Best Regards,
Huang Ying
