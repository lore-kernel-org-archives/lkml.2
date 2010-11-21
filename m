Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab0KUMqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 07:46:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50274 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab0KUMqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 07:46:22 -0500
Message-ID: <8e9ff9280b0c4a059bc82b5c4a629897.squirrel@www.firstfloor.org>
In-Reply-To: <1290340877.2245.124.camel@localhost>
References: <1290340877.2245.124.camel@localhost>
Date: Sun, 21 Nov 2010 13:46:21 +0100
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: "Andi Kleen" <andi@firstfloor.org>
To: "Lin Ming" <ming.m.lin@intel.com>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
        "Stephane Eranian" <eranian@google.com>,
        "Andi Kleen" <andi@firstfloor.org>,
        "lkml" <linux-kernel@vger.kernel.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Arjan van de Ven" <arjan@infradead.org>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> 2. Uncore pmu NMI handling
>
> All the 4 cores are programmed to receive uncore counter overflow
> interrupt. The NMI handler(running on 1 of the 4 cores) handle all
> counters enabled by all 4 cores.

Really for uncore monitoring there is no need to use an NMI handler.
You can't profile a core anyways, so you can just delay the reporting
a little bit. It may simplify the code to not use one here
and just use an ordinary handler.

In general since there is already much trouble with overloaded
NMI events avoiding new NMIs is a good idea.



> +
> +static struct node_hw_events *uncore_events[MAX_NUMNODES];

Don't declare static arrays with MAX_NUMNODES, that number can be
very large and cause unnecessary bloat. Better use per CPU data or similar
(e.g. with  alloc_percpu)

> +	/*
> +	 * The hw event starts counting from this event offset,
> +	 * mark it to be able to extra future deltas:
> +	 */
> +	local64_set(&hwc->prev_count, (u64)-left);

Your use of local* seems dubious. That is only valid if it's really
all on the same CPU. Is that really true?

> +static int uncore_pmu_add(struct perf_event *event, int flags)
> +{
> +	int node = numa_node_id();

this should be still package id

> +	/* Check CPUID signatures: 06_1AH, 06_1EH, 06_1FH */
> +	model = eax.split.model | (eax.split.ext_model << 4);
> +	if (eax.split.family != 6 || (model != 0x1A && model != 0x1E && model !=
> 0x1F))
> +		return;

You can just get that from boot_cpu_data, no need to call cpuid

> +#include <linux/perf_event.h>
> +#include <linux/capability.h>
> +#include <linux/notifier.h>
> +#include <linux/hardirq.h>
> +#include <linux/kprobes.h>
> +#include <linux/module.h>
> +#include <linux/kdebug.h>
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
> +#include <linux/slab.h>
> +#include <linux/highmem.h>
> +#include <linux/cpu.h>
> +#include <linux/bitops.h>

Do you really need all these includes?


-Andi
