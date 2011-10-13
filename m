Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab1JMOw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:52:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42539 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab1JMOwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:52:55 -0400
MIME-Version: 1.0
In-Reply-To: <20111013040656.GE893@mgross-G62>
References: <CACVXFVOkwX+974=eEY5UPysXN-t9Adg6=Wn0Ts4m0vT5zQaw3g@mail.gmail.com>
	<20111013040656.GE893@mgross-G62>
Date: Thu, 13 Oct 2011 22:52:55 +0800
Message-ID: <CACVXFVNc8jgK6kb+BaOYxeh26yBmEV5q51ZsK1=V=A1JkMU99w@mail.gmail.com>
Subject: Re: [Question] PM-QoS: PM_QOS_CPU_DMA_LATENCY == interrupt latency?
From: Ming Lei <tom.leiming@gmail.com>
To: markgross@thegnar.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <mgross@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 13, 2011 at 12:06 PM, mark gross <markgross@thegnar.org> wrote:
> On Mon, Oct 10, 2011 at 10:31:34PM +0800, Ming Lei wrote:
>> Hi,
>>
>> Looks like it is a bit difficult to understand PM_QOS_CPU_DMA_LATENCY
>> from the words' meaning.
>>
>> After searching from google, I don't find some useful information about
>> the root cause for introducing PM_QOS_CPU_DMA_LATENCY. I understand
>> it is very similar to interrupt latency. Also from the comment for
>> omap_pm_set_max_mpu_wakeup_lat in file[1], the description is basically same
>> with interrupt latency.
>
> its the amount of time the CPU can take to wake up and feed a DMA
> engine.  Its a bit more general than interrupt latency.

Maybe interrupt or wake up latency is more general than cpu dma
latency, since interrupt/wake up latency should include this kind of
DMA case.

But the latency name does not matter, what maters is below idea.

>> From comments of pm_qos_add_request usages in drivers, it can be understood
>> as interrupt latency too, IMO.
>
> The original 2 issues that drove its predecessor implementation where
> DMA'ing data to the original intel wifi device.  If the CPU snoozed too
> long the wifi device would get lost and network would suffer.

If the original 2 issues are only related slow cpu snooping in deep idle
state, maybe it is enough to keep one cpu(suppose CPU0) to obey the
constraint, then only let CPU0 handle IRQ from the devices, so the
other CPUs may be allowed to enter deep idle state.

>
> The other one was something to do with generating audio pops if the cpu
> didn't keep some audio buffer that was getting DMA'd to something from
> underflowing.

>From the old comment for audio case[1], we can see the below:

- * An example announcer of latency is an audio driver that knowns it
- * will get an interrupt when the hardware has 200 usec of samples
- * left in the DMA buffer; in that case the driver can set a latency
- * constraint of, say, 150 usec.

so the audio case may be a wake up or interrupt latency, and maybe
it is possible to apply the constraint on only one CPU which will be
responsible for handling audio irq.

Anyway, it is just a rough idea for discussion. If it is doable, I think
it should make sense because multiple core CPU is very popular
in current application from server, laptop, desktop to tablet.

>
>>
>> So, could we think that PM_QOS_CPU_DMA_LATENCY is interrupt latency?
> nope.

[1], commit f011e2e2df3393c16b0fdc48e855e909b7e021ee
Author: Mark Gross <mgross@linux.intel.com>
Date:   Mon Feb 4 22:30:09 2008 -0800

    latency.c: use QoS infrastructure



thanks,
-- 
Ming Lei
