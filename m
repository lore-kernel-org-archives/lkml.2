Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab2EYOBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 10:01:33 -0400
Received: from mail1.sysgo.com ([176.9.26.183]:44749 "EHLO mail1.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab2EYOBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 10:01:32 -0400
Message-ID: <4FBF90B9.7010902@sysgo.com>
Date: Fri, 25 May 2012 16:01:29 +0200
From: Alexander Sverdlin <asv@sysgo.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney@caviumnetworks.com>,
        Venkat Subbiah <venkat.subbiah@cavium.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Possible race in request_irq() (__setup_irq())
References: <4FB39EDA.3030807@sysgo.com> <alpine.LFD.2.02.1205161512270.3231@ionos>
In-Reply-To: <alpine.LFD.2.02.1205161512270.3231@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas, David, Venkat,

On 05/16/2012 03:44 PM, Thomas Gleixner wrote:
> Your irq is using handle_percpu_irq() as the flow handler.
> 
> handle_percpu_irq() is a special flow handler which does not take the
> irq descriptor lock for performance reasons. It's a single interrupt
> number which has a percpu dev_id and can be handled on all cores in
> parallel.
> 
> The interrupts need to be marked as such and requested with
> request_percpu_irq(). Those interrupts are either marked as
> NOAUTOENABLE or set up by the low level setup code, which runs on the
> boot cpu with interrupt enabled.
> 
> Those interrupts are marked as percpu and can only be requested with
> request_percpu_irq().
> 

Could someone comment please, why exactly this happens in current linux-next for Octeon:

In arch/mips/cavium-octeon/octeon-irq.c MBOX IRQs are set up to be handled by handle_percpu_irq():

static void __init octeon_irq_init_ciu(void)
{
...
	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MBOX0, 0, 32, chip_mbox, handle_percpu_irq);
	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MBOX1, 0, 33, chip_mbox, handle_percpu_irq);

But in arch/mips/cavium-octeon/smp.c it's requested as normal IRQ:

void octeon_prepare_cpus(unsigned int max_cpus)
{
...
	if (request_irq(OCTEON_IRQ_MBOX0, mailbox_interrupt,
			IRQF_PERCPU | IRQF_NO_THREAD, "SMP-IPI",
			mailbox_interrupt)) {
		panic("Cannot request_irq(OCTEON_IRQ_MBOX0)");
	}

Is it a bug, or some kind of special case?

-- 
Best regards,
Alexander Sverdlin.
