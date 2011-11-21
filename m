Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab1KUVjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:39:16 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33397 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1KUVjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:39:15 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1111211559190.24943@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu>
	<tip-ed13ec58bfe0d5dc95f748e6118432cb0fa283cb@git.kernel.org>
	<alpine.DEB.2.00.1111211321390.21667@cl320.eecs.utk.edu>
	<1321901536.28118.20.camel@twins>
	<alpine.DEB.2.00.1111211358570.23676@cl320.eecs.utk.edu>
	<CABPqkBRHW0ZmeqADptvBySLZpi6jc_bEFKoukkA6rtd5o04ziQ@mail.gmail.com>
	<alpine.DEB.2.00.1111211559190.24943@cl320.eecs.utk.edu>
Date: Mon, 21 Nov 2011 22:39:14 +0100
Message-ID: <CABPqkBTfNuY8_rcf-u=kf4V-bv_bZwUAhz3J3Z=wan29=09f9A@mail.gmail.com>
Subject: Re: [tip:perf/urgent] perf/x86: Enable raw event access to Intel
 offcore events
From: Stephane Eranian <eranian@google.com>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 10:04 PM, Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> On Mon, 21 Nov 2011, Stephane Eranian wrote:
>
>> > We have a workaround, but it currently disables kernel multiplexing and a
>> > few other nice features.
>>
>> I don't understand why you have a problem with NMI watchdog. Multiplexing
>> allows you to still measure more events than there are counters.
>
> The PAPI code currently uses FORMAT_GROUP and puts as many events as
> possible in a group.  The way we maximize events in a group is to
> add events until perf_events indicates a failure.
>
Ok, now I understand your problem.

When you submit events (one by one) the kernel does a scheduling simulation
but only taking into account events in the group. The goal is to
verify that the group
is schedulable. It does not look at events from system-wide sessions
(which have priority).
Doing so would be difficult for per-thread because it would have to
look on all CPUs.
Even if it were to do that, that would be no guarantee of
schedulability  because
by the time the group is actually scheduled, you may now have
system-wide session, i.e.,
your group is not scheduled because there aren't enough counters
leftover from system-wide.

The problem you're describing is not specific to X86 and the NMI
watchdog. It applies to
all architectures and has to do with system-wide pinned events vs.
per-thread group schedulability.
The NMI watchdog on X86 is an example of that. But AFAIK, the watchdog
could be supported
on other architectures as well.

One could argue, you could check is NMI is active and assume you have
one fewer counters
during the scheduling simulation. But I think it is a bit more
complicated than that.

To solve this problem (in the general case), you need to know which
counter is taken (or required)
by ALL pinned system-wide events across all CPUs. Once you've
constructed the bitmap, you can
use it as the basis (used_mask) to try and schedule the group events.

That's a best effort algorithm. It does not provide the guarantee, the
group will be schedulable
during its entire lifetime. It simply makes it more likely it will
run, if you assume no changes on
system-wide pinned events from the moment you create the per-thread
group and the time is
starts counting.


> When NMI watchdog is enabled, a counter is stolen.  Yet the perf_events
> code does not account for this.
>
> So say on an AMD machine with 4 counters (3 after one is stolen)
> perf_events lets you add 4 events to an event group, even though only 3
> are available.  It does not report failure upon open or start, only at
> read.  By then it's too late.
>
> We have to work around this, by doing an extra read at open time to verify
> that the event group actually is valid, adding overhead.
>
> Our multiplex code tries to maximize the number of events in a group too.
> Currently PAPI works around this by just not doing kernel multiplexing
> if a NMI watchdog is detected.  There's probably more elegant solutions
> such as checking with a read there too, or not using FORMAT_GROUP at all,
> but since this is an ABI regression I was hoping it would get fixed
> quickly enough that I wouldn't have to construct better workarounds.
>
> Vince
> vweaver1@eecs.utk.edu
>
>
