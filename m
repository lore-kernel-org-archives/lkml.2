Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab2EYQY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 12:24:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44246 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309Ab2EYQY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 12:24:26 -0400
Message-ID: <4FBFB237.50007@gmail.com>
Date: Fri, 25 May 2012 09:24:23 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Alexander Sverdlin <asv@sysgo.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney@caviumnetworks.com>,
        Venkat Subbiah <venkat.subbiah@cavium.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Possible race in request_irq() (__setup_irq())
References: <4FB39EDA.3030807@sysgo.com> <alpine.LFD.2.02.1205161512270.3231@ionos> <4FBF90B9.7010902@sysgo.com>
In-Reply-To: <4FBF90B9.7010902@sysgo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 07:01 AM, Alexander Sverdlin wrote:
> Hello Thomas, David, Venkat,
>
> On 05/16/2012 03:44 PM, Thomas Gleixner wrote:
>> Your irq is using handle_percpu_irq() as the flow handler.
>>
>> handle_percpu_irq() is a special flow handler which does not take the
>> irq descriptor lock for performance reasons. It's a single interrupt
>> number which has a percpu dev_id and can be handled on all cores in
>> parallel.
>>
>> The interrupts need to be marked as such and requested with
>> request_percpu_irq(). Those interrupts are either marked as
>> NOAUTOENABLE or set up by the low level setup code, which runs on the
>> boot cpu with interrupt enabled.
>>
>> Those interrupts are marked as percpu and can only be requested with
>> request_percpu_irq().
>>
>
> Could someone comment please, why exactly this happens in current linux-next for Octeon:
>
> In arch/mips/cavium-octeon/octeon-irq.c MBOX IRQs are set up to be handled by handle_percpu_irq():
>
> static void __init octeon_irq_init_ciu(void)
> {
> ...
> 	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MBOX0, 0, 32, chip_mbox, handle_percpu_irq);
> 	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MBOX1, 0, 33, chip_mbox, handle_percpu_irq);
>
> But in arch/mips/cavium-octeon/smp.c it's requested as normal IRQ:
>
> void octeon_prepare_cpus(unsigned int max_cpus)
> {
> ...
> 	if (request_irq(OCTEON_IRQ_MBOX0, mailbox_interrupt,
> 			IRQF_PERCPU | IRQF_NO_THREAD, "SMP-IPI",
> 			mailbox_interrupt)) {
> 		panic("Cannot request_irq(OCTEON_IRQ_MBOX0)");
> 	}
>
> Is it a bug, or some kind of special case?
>

Probably a bug.  But it works, so it has never been an issue.

Patches to bring this code more in line with current Linux irq orthodoxy 
would receive prompt review.  Especially if there were an explanation of 
some problem they were fixing.

David Daney
