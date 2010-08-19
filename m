Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab0HSLYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 07:24:39 -0400
Received: from smtp-out.google.com ([74.125.121.35]:58989 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab0HSLYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 07:24:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=esTmP1LwTaUbvRp0/O9IeG0hB/LXUFfq/9GeB9rXdyNl2PKtIxrI421J5PrN89okE
	R+HEPuNuhnddBDLDGt2CA==
MIME-Version: 1.0
In-Reply-To: <1282215916.1926.4696.camel@laptop>
References: <AANLkTimdnYjDsr4GYgw=M74hH0hzyRDeb7WqfiE8-BT1@mail.gmail.com>
	<1282215916.1926.4696.camel@laptop>
Date: Thu, 19 Aug 2010 13:24:35 +0200
Message-ID: <AANLkTincTDeVtekXkt+CnEix73d9rjEZUT4TJYyQGcdw@mail.gmail.com>
Subject: Re: [BUG] perf_events: NMI watchdog event cannot be throttled
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mackerras <paulus@samba.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        eranian@gmail.com, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, that should probably fix it. Let me try it out.


On Thu, Aug 19, 2010 at 1:05 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-08-18 at 22:26 +0200, Stephane Eranian wrote:
>> Hi,
>>
>> I ran into some issue  with the NMI watchdog not firing in a deadlock
>> situation. After some debugging I found the source of the problem.
>>
>> The NMI watchdog is currently subject, like any other events, to interrupt
>> throttling. The heart of the problem is that if you are deadlocked on a CPU
>> with interrupts masked, the timer interrupt won't fire, therefore the
>> hwc->interrupts
>> field won't be reset. Then, depending on the max sampling rate, you
>> could eventually
>> fail the max interrupt rate test in __pfm_overflow_handler() and
>> perf_events would
>> throttle, i.e., stop, the NMI watchdog event before the 5s delay to panic.
>> Thus, you would never get the panic. I ran into this problem myself.
>>
>> This is a serious issue because perf_events must ensure the watchdog can
>> always fire, regardless of the interrupt masking situation.
>>
>> Look like one way of solving the problem would be to mark the NMI watchdog
>> event as immune to throttling. The event being internal to the kernel we could
>> trust the event setup from perf_event_create_kernel_counter().
>
> Something like so?
>
> ---
>  kernel/watchdog.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 613bc1f..e0fe6e4 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -206,6 +206,9 @@ void watchdog_overflow_callback(struct perf_event *event, int nmi,
>                 struct perf_sample_data *data,
>                 struct pt_regs *regs)
>  {
> +       /* Ensure the watchdog never gets throttled. */
> +       event->hw.interrupts = 0;
> +
>        if (__get_cpu_var(watchdog_nmi_touch) == true) {
>                __get_cpu_var(watchdog_nmi_touch) = false;
>                return;
>
>
