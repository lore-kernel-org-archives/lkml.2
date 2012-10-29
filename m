Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2J2UVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:21:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:5828 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab2J2UVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:21:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,673,1344236400"; 
   d="scan'208";a="234228123"
Subject: Re: [PATCH] x86/ioapic: Fix the vector_irq[] is corrupted randomly
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, yinghai@kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Oct 2012 13:24:04 -0700
In-Reply-To: <1351527341.15558.1445.camel@cliu38-desktop-build>
References: <1351527341.15558.1445.camel@cliu38-desktop-build>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1351542245.12459.39.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 00:15 +0800, Chuansheng Liu wrote:
> Not all irq chips are IO-APIC chip.
> 
> In our system, there are many demux GPIO interrupts except for the
> io-apic chip interrupts, and these GPIO interrupts are belonged
> to other irq chips, the chip data is not type of struct irq_cfg
> either.
> 
> But in function __setup_vector_irq(), it listed all allocated irqs,
> and presume all irq chip is ioapic_chip and the chip data is type
> of struct irq_cfg, it possibly causes the vector_irq is corrupted
> randomly.
> 
> For example, one irq 258 is not io-apic chip irq, in __setup_vector_irq(),
> the chip data is forced to be used as struct irq_cfg, then the value
> cfg->domain and cfg->vector are wrong to be used to write vector_irq:
> 		vector = cfg->vector;
> 		per_cpu(vector_irq, cpu)[vector] = irq;
> 
> This patch use the .flags to identify if the irq chip is io-apic.

I have a feeling that your gpio driver is abusing the 'chip_data' in the
struct irq_data. Shouldn't the driver be using 'handler_data' instead?

>From include/linux/irq.h:
 * @handler_data:       per-IRQ data for the irq_chip methods
 * @chip_data:          platform-specific per-chip private data for the chip
 *                      methods, to allow shared chip implementations

Also, how are these routed to the processors and the mechanism of the
vector assignment for these irq's? I presume irq_cfg is needed for the
setup and the interrupt migration from one cpu to another.

What am I missing?

thanks,
suresh

