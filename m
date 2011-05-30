Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab1E3N2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:28:16 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59853
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297Ab1E3N2P convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:28:15 -0400
Subject: Re: [PATCH 2/3] perf_events: fix validation of events using an
 extra reg (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
        ming.m.lin@intel.com
In-Reply-To: <20110523161252.GA11607@quad>
References: <20110523161252.GA11607@quad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 30 May 2011 15:11:14 +0200
Message-ID: <1306761074.1200.2975.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 18:12 +0200, Stephane Eranian wrote:
> +static struct cpu_hw_events *allocate_fake_cpuc(void)
> +{
> +       struct cpu_hw_events *cpuc;
> +       int cpu = smp_processor_id();
> +
> +       cpuc = kzalloc(sizeof(*cpuc), GFP_KERNEL);
> +       if (!cpuc)
> +               return ERR_PTR(-ENOMEM);
> +
> +       /* only needed, if we have extra_regs */
> +       if (x86_pmu.extra_regs) {
> +               cpuc->shared_regs = allocate_shared_regs(cpu);
> +               if (!cpuc->shared_regs)
> +                       goto error;
> +       }
> +       return cpuc;
> +error:
> +       free_fake_cpuc(cpuc);
> +       return ERR_PTR(-ENOMEM);
> +} 

Ingo found a case where that use of allocate_shared_regs() failed to
compile but didn't provide a .config. I suspect its CONFIG_CPU_SUP_INTEL
and the below should fix it. I will try to push that again later today.

---
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 41178c8..cf90e31 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1528,4 +1623,9 @@ static int intel_pmu_init(void)
 	return 0;
 }
 
+static struct intel_shared_regs *allocate_shared_regs(int cpu)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_CPU_SUP_INTEL */

