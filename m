Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab0FNPob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:44:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59309 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab0FNPoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:44:30 -0400
Subject: Re: [PATCH] mtd: Fix bug using smp_processor_id() in preemptible
 ubi_bgt1d kthread
From: Philby John <pjohn@mvista.com>
Reply-To: pjohn@mvista.com
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-mtd@lists.infradead.org, linux-mips@linux-mips.org,
       David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
       Artem Bityutskiy <dedekind1@gmail.com>
In-Reply-To: <20100614150425.GC9550@shareable.org>
References: <1276513457.16642.3.camel@localhost.localdomain>
	 <20100614150425.GC9550@shareable.org>
Content-Type: text/plain
Date: Mon, 14 Jun 2010 21:07:04 +0530
Message-Id: <1276529824.17519.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 16:04 +0100, Jamie Lokier wrote:
> Philby John wrote:
> > mtd: Fix bug using smp_processor_id() in preemptible ubi_bgt1d kthread
> > 
> > On a MIPS Cavium Octeon CN5020 when trying to create a UBI volume,
> > on the NOR flash, the kernel thread ubi_bgt1d calls
> > cfi_amdstd_write_buffers() --> do_write_buffer() -->
> > INVALIDATE_CACHE_UDELAY --> __udelay(). Its __udelay() that calls
> > smp_processor_id() in preemptible code, which you are not supposed to.
> > Fix the problem by disabling preemption.
> 
> The MTD code just calls udelay().
> Are you sure it isn't permitted to call udelay() from preemptible code?
> I think it is fine.


The mips code uses __udelay() where the macro current_cpu_data returns
the actual data structure on a per CPU basis by calling
smp_processor_id(). Since I have enabled CONFIG_DEBUG_PREEMPT, this
would call debug_smp_processor_id(). This function would check

a)if the thread is preemptiable. If preemption is disabled, normal flow.
b)If irqs are disabled, if yes normal flow.
c)if the thread is bound to a single cpu, if yes normal flow
d)or if its an early bootup

None of these condition get satisfied and hence the kernel error
messages are seen. So I think yes for MIPS, udelay() shouldn't be called
in preemptiable code.

> 
> Perhaps MIPS udelay() should be disabling preemption itself,

I will need to investigate this. Will follow up soon.

>  or
> (as x86 does) using raw_smp_processor_id() instead?

I have enabled CONFIG_DEBUG_PREEMPT so this would call
debug_smp_processor_id() instead of raw_smp_processor_id().

>   Or perhaps the x86
> version is a bug because the current CPU might change during the delay loop?
> 

Yes, isn't this a possibility? In that case shouldn't we be using
spin_lock_irqsave() ?

> See git commit 5c1ea08215f1f830dfaf4819a5f22efca41c3832
> "x86: enable preemption in delay"
> 
> I don't think it makes sense to disable preemption in all udelay()
> calls in drivers, so my NAK to this MTD patch.  To workaround,
> consider putting the preempt_disable in MIPS udelay(),

This would definitely work.

>  or using
> raw_smp_processor_id() in it, after reading the above git commit's
> message.

Will look into this.

Thanks
Philby

