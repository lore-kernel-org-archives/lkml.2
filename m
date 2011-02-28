Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab1B1JQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:16:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:34365 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1B1JQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:16:19 -0500
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1298877772.4937.25.camel@minggr.sh.intel.com>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Feb 2011 10:15:59 +0100
Message-ID: <1298884559.2428.10083.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 15:22 +0800, Lin Ming wrote:
> This patch adds basic SandyBridge support, including hardware cache
> events and PEBS events support.
> 
> LLC-* hareware cache events don't work for now, it depends on the
> offcore patches.

What's the status of those, Stephane reported some problems last I
remember?


>  #define INTEL_EVENT_CONSTRAINT(c, n)	\
>  	EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
> +#define INTEL_EVENT_CONSTRAINT2(c, n)	\
> +	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)

That's a particularly bad name, how about something like

INTEL_UEVENT_CONSTRAINT or somesuch.

> @@ -702,7 +738,13 @@ static void intel_ds_init(void)
>  			printk(KERN_CONT "PEBS fmt1%c, ", pebs_type);
>  			x86_pmu.pebs_record_size = sizeof(struct pebs_record_nhm);
>  			x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
> -			x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
> +			switch (boot_cpu_data.x86_model) {
> +			case 42: /* SandyBridge */
> +				x86_pmu.pebs_constraints = intel_snb_pebs_events;
> +				break;
> +			default:
> +				x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
> +			}
>  			break;
>  
>  		default:

We already have this massive model switch right after this function,
might as well move the pebs constraint assignment there.
