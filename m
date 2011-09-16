Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab1IPIUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 04:20:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38991 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754423Ab1IPIUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 04:20:06 -0400
Message-ID: <4E7306C8.4050809@arm.com>
Date: Fri, 16 Sep 2011 09:20:24 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 1/3] genirq: add support for per-cpu dev_id interrupts
References: <1316105551-17505-1-git-send-email-marc.zyngier@arm.com> <1316105551-17505-2-git-send-email-marc.zyngier@arm.com> <CAHXqBFKOQNOePc00yuzfotrYP6wT0ue_CJfv7rKdC+gEkomunA@mail.gmail.com>
In-Reply-To: <CAHXqBFKOQNOePc00yuzfotrYP6wT0ue_CJfv7rKdC+gEkomunA@mail.gmail.com>
X-Enigmail-Version: 1.2.1
X-OriginalArrivalTime: 16 Sep 2011 08:20:00.0634 (UTC) FILETIME=[6D8DB5A0:01CC7449]
X-MC-Unique: 111091609200208901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michał,

On 15/09/11 22:36, Michał Mirosław wrote:
> 2011/9/15 Marc Zyngier <marc.zyngier@arm.com>:
> [...]
>> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
>> index a103732..f9b7fa3 100644
>> --- a/include/linux/interrupt.h
>> +++ b/include/linux/interrupt.h
>> @@ -95,6 +95,7 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
>>  * @flags:     flags (see IRQF_* above)
>>  * @name:      name of the device
>>  * @dev_id:    cookie to identify the device
>> + * @percpu_dev_id:     cookie to identify the device
>>  * @next:      pointer to the next irqaction for shared interrupts
>>  * @irq:       interrupt number
>>  * @dir:       pointer to the proc/irq/NN/name entry
>> @@ -104,17 +105,20 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
>>  * @thread_mask:       bitmask for keeping track of @thread activity
>>  */
>>  struct irqaction {
> [...]
>> +       void                    *dev_id;
>> +#ifdef CONFIG_IRQ_PERCPU_DEVID
>> +       void __percpu           *percpu_dev_id;
>> +#endif
> 
> Those two can share the memory (in a anonymous union), if I read the
> idea correctly.

That was the initial implementation, and everything was fine until I
tried gcc 4.4.1. Having an anonymous union breaks static initialization
of the structure.

Try the following:
$ cat x.c
struct foo {
	int a;
	union {
		int b1;
		void * b2;
	};
	int c;
};

struct foo bar = {
	.a  = 1,
	.b1 = 0,
	.c  = 2,
};

$ gcc -c -Wall x.c
x.c:13: error: unknown field ‘b1’ specified in initializer
x.c:13: warning: missing braces around initializer
x.c:13: warning: (near initialization for ‘bar.<anonymous>’)

GCC 4.6 seem fine though. Haven't tried anything in between.

A possible solution would be to name the union and fix all the accesses
to .dev_id. Ugly at best...

Cheers,

	M.
-- 
Jazz is not dead. It just smells funny...

