Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab0JLW0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 18:26:32 -0400
Received: from www.tglx.de ([62.245.132.106]:55013 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab0JLW0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 18:26:31 -0400
Date: Wed, 13 Oct 2010 00:26:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] x86: Sanitize apb timer interrupt handling
In-Reply-To: <20101012151230.00000402@unknown>
Message-ID: <alpine.LFD.2.00.1010130020250.2909@localhost6.localdomain6>
References: <tip-a5ef2e70405c8a9ee380b5ff33a008c75454791f@git.kernel.org> <20101012142000.00001358@unknown> <alpine.LFD.2.00.1010122327260.2909@localhost6.localdomain6> <20101012151230.00000402@unknown>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010, Jacob Pan wrote:

> Thomas Gleixner Tue, 12 Oct 2010 23:28:19 +0200 (CEST)
> >On Tue, 12 Oct 2010, Jacob Pan wrote:
> >
> >> 
> >> >x86: Sanitize apb timer interrupt handling
> >> >
> >> >Disable the interrupt in CPU_DEAD where it belongs.
> >> My main concern is the performance cost. The power management code for
> >> Moorestown system make use of the cpu hotplug code (disable_nonboot_cpus)
> >> but much more frequently. The system low power states are call S0 idle
> >> state (s0ix).
> >> 
> >> Leaving the irq enabled at the chip and desc level between S0ix states
> >> might give some performance benefit. That was my original thought.
> >> Will it cause problems?
> >
> >Errm. I merily moved it to the place where it should be. You do the
> >disable/enable dance already today.
> >
> I think I only do disable/enable at the timer HW level today during cpu hp
> notification, not calling disable_irq(). Am i missing something?

apbt_setup_irq()
{
 ...
 
--->	disable_irq(adev->irq);
	desc->status |= IRQ_MOVE_PCNTXT;
	irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
	/* APB timer irqs are set up as mp_irqs, timer is edge triggerred */
	set_irq_chip_and_handler_name(adev->irq, chip, handle_edge_irq, "edge");
--->	enable_irq(adev->irq);
	if (system_state == SYSTEM_BOOTING)
 ...
}

So that's a disable/enable pair on every cpu hotplug, right ?

Now I moved the disable to CPU_DEAD where it belongs and the enable
stayed at the same place.

Thanks,

	tglx
