Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab2FGKSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:18:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:52283 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2FGKSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:18:52 -0400
Message-ID: <1339064319.23343.13.camel@twins>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com
Date: Thu, 07 Jun 2012 12:18:39 +0200
In-Reply-To: <20120607071531.GA4849@quad>
References: <20120607071531.GA4849@quad>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 09:15 +0200, Stephane Eranian wrote:
> +static int check_pebs_quirks(void)
> +{
> +       int uversion = cpu_data(smp_processor_id()).microcode;
> +       int model = cpu_data(smp_processor_id()).x86_model;
> +
> +       /* do not have PEBS to begin with */
> +       if (!x86_pmu.pebs)
> +               return 0;
> +
> +       /*
> +        * check ucode version for SNB, SNB-EP
> +        */
> +       if ((model == 42 || model == 45) && uversion < 0x28) {
> +               pr_warn("SandyBridge PEBS unavailable due to CPU erratum, "
> +                       " update microcode (was 0x%x, needs at least 0x28).\n",
> +                       uversion);
> +               return -ENOTSUPP;
> +       }
> +       return 0;
> +}
> +
>  static int intel_pmu_hw_config(struct perf_event *event)
>  {
>         int ret = x86_pmu_hw_config(event);
> @@ -1401,8 +1422,14 @@ static int intel_pmu_hw_config(struct perf_event *event)
>         if (ret)
>                 return ret;
>  
> -       if (event->attr.precise_ip && x86_pmu.pebs_aliases)
> -               x86_pmu.pebs_aliases(event);
> +       if (event->attr.precise_ip) {
> +
> +               if (check_pebs_quirks())
> +                       return -ENOTSUPP;

This will only warn about the PEBS issue once you try and use a PEBS
counter. Shouldn't we do this on boot? IOW. put check_pebs_quirks()
inside the existing quirk code instead of here?

> +
> +               if (x86_pmu.pebs_aliases)
> +                       x86_pmu.pebs_aliases(event);
> +       }
>  
>         if (intel_pmu_needs_lbr_smpl(event)) {
>                 ret = intel_pmu_setup_lbr_filter(event);
> @@ -1714,13 +1741,6 @@ static __init void intel_clovertown_quirk(void)
>         x86_pmu.pebs_constraints = NULL;
>  }
