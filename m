Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032261Ab2CPIak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:30:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53988 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030462Ab2CPIae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:30:34 -0400
MIME-Version: 1.0
In-Reply-To: <201203102353.24218.rjw@sisk.pl>
References: <13197479.540821330911965933.JavaMail.weblogic@epv6ml06>
	<20120308034722.GA10286@envy17>
	<CAJ0PZbTfw1U8raiwiNX14x+jnaWa7ptAgpaaTJgCCZKZU24TDg@mail.gmail.com>
	<201203102353.24218.rjw@sisk.pl>
Date: Fri, 16 Mar 2012 17:30:33 +0900
Message-ID: <CAJ0PZbQ0itn68PCK9aYQZRT5VabvDChJm-+h1pDfkiO_afB1QA@mail.gmail.com>
Subject: Re: [PATCH v3] PM / QoS: Introduce new classes: DMA-Throughput and DVFS-Latency
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: markgross@thegnar.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Dave Jones <mavej@redhat.com>, linux-pm@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 7:53 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, March 09, 2012, MyungJoo Ham wrote:
>> On Thu, Mar 8, 2012 at 12:47 PM, mark gross <markgross@thegnar.org> wrote:
>> > On Wed, Mar 07, 2012 at 02:02:01PM +0900, MyungJoo Ham wrote:
>> >> 1. CPU_DMA_THROUGHPUT
>> ...
>> >> 2. DVFS_LATENCY
>> >
>> > The cpu_dma_throughput looks ok to me.  I do however; wonder about the
>> > dvfs_lat_pm_qos.  Should that knob be exposed to user mode?  Does that
>> > matter so much?  why can't dvfs_lat use the cpu_dma_lat?
>> >
>> > BTW I'll be out of town for the next 10 days and probably will not get
>> > to this email account until I get home.
>> >
>> > --mark
>> >
>>
>> 1. Should DVFS Latency be exposed to user mode?
>>
>> It would depend on the policy of the given system; however, yes, there
>> are systems that require a user interface for DVFS Latency.
>> With the example of user input response (response to user click,
>> typing, touching, and etc), a user program (probably platform s/w or
>> middleware) may input QoS requests. Besides, when a new "application"
>> is starting, such "middleware" may want faster responses from DVFS
>> mechanisms.
>
> But this is a global knob, isn't it?  And it seems that a per-device one
> is needed rather than that?
>
> It also applies to your CPU_DMA_THROUGHPUT thing, doesn't it?


Yes, the two are global knobs. And both the two control multiple
devices simultaneously, not just a single device. I suppose per-device
QoS is appropriate for QoS requests directed to a single device. Am I
right about this one?


Let's assume that, in an example system, we have devfreq on GPU,
memory-Interface, and main bus and CPUfreq (Exynos5 will have them all
seperated).

If we use per-device QoS for DVFS LATENCY, in order to control the
DVFS response latency, we will need to make QoS requests to all the
four devices independently, not to the global DVFS LATENCY QOS CLASS.
There, we could have a shared single QoS request list for these four
DVFS devices, saying that the DVFS response should be done in "50ms"
after a sudden utilization increase.

We may be able to use "dev_pm_qos_add_notifier()" for a virtual device
representing "DVFS Latency" or "DMA Throughput" and let the GPU, CPU,
main-bus, and memory-interface listen to the events from the virtual
device. Hmm..., do you recommend this approach? creating a device
representing "DVFS" as a whole (both CPUFreq and device drivers of
devfreq).

CPU_DMA_THROUGHPUT is quite similar as CPU_DMA_LATENCY. However, we
think it is addtionally needed because many IPs (in-SoC devices) need
to specify its DMA usage in "kbytes/sec", not "usecs/ops". For
example, a video-decoding chip device driver may say it requires
"750000kbytes/sec" for 1080p60, "300000kbytes/sec" for 720p60, and so
on, which affects CPUfreq, memory-interface, and main-bus at the same
time.

>
>> 2. Does DVFS Latency matter?
>>
>> Yes, in our experimental sets w/ Exynos4210 (those slapped in Galaxy
>> S2 equivalent; not exactly as I'm not conducted in Android systems,
>> but Tizen), we could see noticable difference w/ bare eyes for
>> user-input responses. When we shortened DVFS polling interval with
>> touches, the touch responses were greatly improved; e.g., losing 10
>> frames into losing 0 or 1 frame for a sudden input rush.
>
> Well, this basically means PM QoS matters, which is kind of obvious.
> It doesn't mean that it can't be implemented in a better way, though.

For DVFS-Latency and DMA-Throughput, I think a normal pm-qos-dev (one
device per one qos knob) isn't appropriate because there are multiple
devices that are required to react simultaneously.

It is possible to let multiple devices react by adding notifiers with
dev_pm_qos_add_notifier(). However, I felt that it wasn't the purpose
of this one and it might get things ugly. Anyway, was allowing
multiple devices to change their frequencies/voltages for a single
per-device QoS list the purpose of dev_pm_qos_add_notifier()?


Just throwing an idea and suggestion if it was the purpose,
I speculate that If we are going to do this (supporting multiple
devices per one qos knob without adding QoS class), we'd better create
"qos class device" in /drivers/qos/ and let those qos class handle
multiple devices depending on a single "qos class". Probably, this
will transform "global PM-QoS class" that notifies related devices
into "QoS class device" that notifies related devices.

>
>> 3. Why not replace DVFS Latency w/ CPU-DMA-Latency/Throughput?
>>
>> When we implement the user-input response enhancement with CPU-DMA QoS
>> requests, the PM-QoS will unconditionally increase CPU and BUS
>> frequencies/voltages with user inputs. However, with many cases it is
>> unnecessary; i.e., a user input means that there will be unexpected
>> changes soon; however, the change does not mean that the load will
>> increase. Thus, allowing DVFS mechanism to evolve faster was enough to
>> shorten the response time and not to increase frequencies and voltages
>> when not needed. There were significant difference in power
>> consumption with this changes if the user inputs were not involving
>> drastic graphics jobs; e.g., typing a text message.
>
> Again, you're arguing for having PM QoS rather than not having it.  You don't
> have to do that. :-)
>
> Generally speaking, I don't think we should add any more PM QoS "classes"
> as defined in pm_qos.h, since they are global and there's only one
> list of requests per class.  While that may be good for CPU power
> management (in an SMP system all CPUs are identical, so the same list of
> requests may be applied to all of them), it generally isn't for I/O
> devices (some of them work in different time scales, for example).
>
> So, for example, most likely, a list of PM QoS requests for storage devices
> shouldn't be applied to input devices (keyboards and mice to be precise) and
> vice versa.
>
> On the other hand, I don't think that applications should access PM QoS
> interfaces associated with individual devices directly, because they may
> not have enough information about the relationships between devices in the
> system.  So, perhaps, there needs to be an interface allowing applications
> to specify their PM QoS expectations in a general way (e.g. "I want <number>
> disk I/O throughput") and a code layer between that interface and device
> drivers translating those expecataions into PM QoS requests for specific
> devices.

With DVFS Latency PM QoS Class, we can say "I want the system to react
in 50ms for any sudden utilization increases.". Without it, we should
say, for example, "CPUFreq/Ondemand should set interval at 25ms,
Devfreq/Bus should set interval at 25ms, and Devfreq/GPU should set
interval at 10ms."

And with CPU Throughput PM QoS Class, we can say "I want 1000000
kbytes/sec DMA transfer". Without it, we should say "Memory-Interface
at 1000000 kbytes/sec, Exynos4412 core should be at least 500MHz, and
Bus should be at least 166MHz".


Thank you.


Cheers!
MyungJoo.


> However, that would require support from subsystems throughout
> the kernel (e.g. if an application wants specific disk I/O throughput,
> we need to figure out what disks are used by that application and apply
> appropriate PM QoS requests to them on behalf of it and that may require
> support from the VFS and the block layer).
>
> I don't really think we have sufficiently understood the problem area yet.
>
> Thanks,
> Rafael
>



-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
