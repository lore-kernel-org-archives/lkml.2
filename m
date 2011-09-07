Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab1IGRw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:52:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56997 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab1IGRw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:52:26 -0400
Date: Wed, 07 Sep 2011 13:51:10 -0400 (EDT)
Message-Id: <20110907.135110.2069876782156753239.davem@davemloft.net>
To: tglx@linutronix.de
Cc: yong.zhang0@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        joe@perches.com, sparclinux@vger.kernel.org
Subject: Re: [PATCH 20/62] sparc: irq: Remove IRQF_DISABLED
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.02.1109071933080.2723@ionos>
References: <20110907.131217.2301665763990232637.davem@davemloft.net>
	<alpine.LFD.2.02.1109071924510.2723@ionos>
	<alpine.LFD.2.02.1109071933080.2723@ionos>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 07 Sep 2011 10:51:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 7 Sep 2011 19:33:52 +0200 (CEST)

> 
> 
> On Wed, 7 Sep 2011, Thomas Gleixner wrote:
> 
>> On Wed, 7 Sep 2011, David Miller wrote:
>> 
>> > From: Yong Zhang <yong.zhang0@gmail.com>
>> > Date: Wed,  7 Sep 2011 16:10:17 +0800
>> > 
>> > > This flag is a NOOP and can be removed now.
>> > > 
>> > > Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
>> > 
>> > How are things working now, if that is the case?
>> > 
>> > Specifically in the ldc_bind() case, we're passing iRQF_DISABLED here
>> > so that the IRQ is not turned on when we request the IRQ, we later do
>> > enable_irq() on these after we've take the spinlock in this function.
>> > 
>> > The IRQ cannot be allowed to be delivered between the request_irq()
>> > call and the enable_irq() calls.
>> > 
>> > This sequence is necessary to deal with some lock ordering issues.
>> 
>> IRQF_DISABLED was telling the core code that the interrupt must run
>> with interrupts disabled. As we enforced running all handlers with
>> interrupts disabled the flag is meaningless. It was defined as 0
>> anyway.
>> 
>> What you need to prevent that request_irq() enables the interrupt
>> unconditionally, is to set IRQ_NOAUTOEN on the interrupt, which can't
>> be handed in to request_irq(). You want to call
>> 
>>    irq_set_status_flags(irq, IRQ_NOAUTOEN);
>> 
>> for that irq. That tells request_irq() to leave the interrupt disabled
>> and you have to explicitely enable it. That has not changed since we
>> generalized the irq core code back in 2006.
> 
> If that's an issue, then we can create an IRQF_NOAUTOEN flag, which
> can be handed into request_irq().

Actually, the issue is that I wanted the interrupt handler to run with
interrupts disabled.

We had big problems when openning thousands of virtual network
devices, each with their own unique IRQ, and pointed all at the same
cpu, and we'd get IRQ stack overflows.

See commit c58543c869606532c2382f027d6466f4672ea756

So this change to make IRQF_DISABLED a nop has reintroduced this bug.
