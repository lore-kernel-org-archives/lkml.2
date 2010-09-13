Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab0IMTW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:22:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46294 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab0IMTWz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:22:55 -0400
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20100913191729.GA6440@console-pimps.org>
References: <20100914000613.51fdba90.sfr@canb.auug.org.au>
	 <20100913191729.GA6440@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 21:22:42 +0200
Message-ID: <1284405762.2275.422.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 20:17 +0100, Matt Fleming wrote:
> 3f6da390 ("perf: Rework and fix the arch CPU-hotplug hooks") introduced
> this breakage. sh_pmu_setup() is missing an opening curly brace, e.g.
> 
> diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
> index cf39c48..036f7a9 100644
> --- a/arch/sh/kernel/perf_event.c
> +++ b/arch/sh/kernel/perf_event.c
> @@ -338,7 +338,7 @@ static struct pmu pmu = {
>  };
>  
>  static void sh_pmu_setup(int cpu)
> -
> +{
>         struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
>  
>         memset(cpuhw, 0, sizeof(struct cpu_hw_events)); 


Gah, that's actually breakage from b0a873ebbf8 (perf: Register PMU
implementations), which has the below fudge:


+static struct pmu pmu = {
+       .event_init     = sh_pmu_event_init,
+       .enable         = sh_pmu_enable,
+       .disable        = sh_pmu_disable,
+       .read           = sh_pmu_read,
+};
+
 static void sh_pmu_setup(int cpu)
-{
+
        struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
 
        memset(cpuhw, 0, sizeof(struct cpu_hw_events));


Ingo, could you back-merge this?
