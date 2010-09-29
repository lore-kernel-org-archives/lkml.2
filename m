Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab0I2PdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 11:33:13 -0400
Received: from smtp-out.google.com ([74.125.121.35]:8567 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab0I2PdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 11:33:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WfnN6k1AksKMSbLExRQYZ+kYf7GNlzTugeiWUbeVD98xgEypt3tvXc9srxmBlBJyHo
         ANtiyhBnyrfUIzhtESyw==
MIME-Version: 1.0
In-Reply-To: <20100929152745.GC9440@lenovo>
References: <20100915162034.GO13563@erda.amd.com>
	<tip-63e6be6d98e1a2bcdca86872b67052e51ab6afa1@git.kernel.org>
	<AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com>
	<20100929125301.GG13563@erda.amd.com>
	<20100929125453.GH13563@erda.amd.com>
	<AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com>
	<AANLkTi=WYU2=4Hu7tb+TSrhJw9K9du19_KjMcG3ij=qn@mail.gmail.com>
	<20100929150140.GK13563@erda.amd.com>
	<20100929151253.GL13563@erda.amd.com>
	<20100929152745.GC9440@lenovo>
Date: Wed, 29 Sep 2010 17:33:07 +0200
Message-ID: <AANLkTikvYreYiyCbGeG02j+r4dWVLRH7BqeeG9O=VTNN@mail.gmail.com>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

There is something else bothering me with cpuc->running.

It is not reset outside of the interrupt handler. So what if
event scheduling shuffles things around and an event is
moved somewhere else. Don't you need to clear the
cpuc->running[idx] for the old counter index?


On Wed, Sep 29, 2010 at 5:27 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Wed, Sep 29, 2010 at 05:12:53PM +0200, Robert Richter wrote:
>> On 29.09.10 17:01:40, Robert Richter wrote:
>> > Right, I wasn't remembering correctly, it was P6 and core. And yes, P4
>> > requires the fix. Will send a patch for this.
>>
>> Ok, Cyrill is sending the patch.
>>
>> Thanks,
>>
>> -Robert
>>
>
> Managed to implement it earlier then I thought.
>
>  Cyrill
> ---
> Subject: [PATCH -tip] perf, x86: Handle in flight IRQs on P4 platform
>
> Stephane reported we've missed to guard P4 platform
> against spurious in-flight performance IRQs. Fix it.
>
> [ the patch is a complement to commit 63e6be6d98e1 ]
>
> Reported-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Robert Richter <robert.richter@amd.com>
> CC: Lin Ming <ming.m.lin@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_p4.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -904,8 +904,12 @@ static int p4_pmu_handle_irq(struct pt_r
>        for (idx = 0; idx < x86_pmu.num_counters; idx++) {
>                int overflow;
>
> -               if (!test_bit(idx, cpuc->active_mask))
> +               if (!test_bit(idx, cpuc->active_mask)) {
> +                       /* catch in-flight IRQs */
> +                       if (__test_and_clear_bit(idx, cpuc->running))
> +                               handled++;
>                        continue;
> +               }
>
>                event = cpuc->events[idx];
>                hwc = &event->hw;
>
