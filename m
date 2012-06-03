Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab2FCLeu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 07:34:50 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57943 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2FCLet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 07:34:49 -0400
Message-ID: <4FCB4B9E.3090508@linux.vnet.ibm.com>
Date: Sun, 03 Jun 2012 17:03:50 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Richard Kuo <rkuo@codeaurora.org>, David Howells <dhowells@redhat.com>,
        Bob Liu <lliubbo@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Richard Weinberger <richard@nod.at>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Matt Turner <mattst88@gmail.com>, nikunj@linux.vnet.ibm.com
Subject: Re: [PATCH 01/27] smpboot: Provide a generic method to boot secondary
 processors
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091008.31979.93586.stgit@srivatsabhat.in.ibm.com> <4FC8B0F7.3060705@linux.vnet.ibm.com> <20120603085359.GE16829@zhy>
In-Reply-To: <20120603085359.GE16829@zhy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12060301-7014-0000-0000-0000014EF9B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2012 02:23 PM, Yong Zhang wrote:

> On Fri, Jun 01, 2012 at 05:39:27PM +0530, Srivatsa S. Bhat wrote:
>> +void __cpuinit smpboot_start_secondary(void *arg)
>> +{
>> +	unsigned int cpu;
>> +
>> +	/*
>> +	 * SMP booting is extremely fragile in some architectures. So run
>> +	 * the cpu initialization code first before anything else.
>> +	 */
>> +	__cpu_pre_starting(arg);
>> +
>> +	preempt_disable();
>> +	cpu = smp_processor_id();
>> +
>> +	/* Invoke the CPU_STARTING notifier callbacks */
>> +	notify_cpu_starting(cpu);
>> +
>> +	__cpu_pre_online(arg);
>> +
>> +	/* Set the CPU in the cpu_online_mask */
>> +	set_cpu_online(cpu, true);
>> +
>> +	__cpu_post_online(arg);
>> +
> 
> Seems it worth to catch incorrect irq state here:
> 
> 	WARN_ON_ONCE(!irqs_disabled());
> 


That's a good point! But unfortunately we can't do that just yet.
Because, some architectures have explicit comments that say that
irqs must be enabled at a certain point in time, or have something
special than just a local_irq_enable(), and hence fall under the
__cpu_post_online() function when converted to this model.

Examples: ARM (patch 26) and ia64 (patch 15)

Unless the maintainers give a go-ahead to change them, I don't
think it would be safe.. (I have added the Notes section to each
patch to get the attention of the maintainers to such issues).

Regards,
Srivatsa S. Bhat

> 
>> +	/* Enable local interrupts now */
>> +	local_irq_enable();
>> +
>> +	wmb();
>> +	cpu_idle();
>> +
>> +	/* We should never reach here! */
>> +	BUG();
>> +}


