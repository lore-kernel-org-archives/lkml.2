Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab0KLRXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:23:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:33896 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab0KLRXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:23:45 -0500
Subject: Re: [PATCH 1/2] perf-events: Add support for supplementary event
 registers v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu, fweisbec@gmail.com,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
References: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 12 Nov 2010 18:23:50 +0100
Message-ID: <1289582630.2084.331.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 17:55 +0100, Andi Kleen wrote:
>  static struct event_constraint *
> +intel_percore_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
> +{
> +       struct hw_perf_event *hwc = &event->hw;
> +       unsigned int e = hwc->config & ARCH_PERFMON_EVENTSEL_EVENT;
> +       struct event_constraint *c;
> +       struct intel_percore *pc;
> +
> +       if (!x86_pmu.percore_constraints)
> +               return NULL;
> +
> +       for (c = x86_pmu.percore_constraints; c->cmask; c++) { 
> +               if (e != c->code)
> +                       continue;
> +
> +               c = NULL;
> +
> +               /*
> +                * Allocate resource per core.
> +                * Currently only one such per core resource can be allocated.
> +                */
> +               pc = cpuc->per_core;
> +               if (!pc)
> +                       break;
> +               raw_spin_lock(&pc->lock);
> +               if (pc->ref > 0) {
> +                       /* Allow identical settings */
> +                       if (hwc->config == pc->config &&
> +                           hwc->extra_reg == pc->extra_reg &&
> +                           hwc->extra_config == pc->extra_config) {

Hrmm,. this doesn't really scale right wrt multiple extra_regs.

You made the extra_regs thing fairly extensible, but the above doesn't
really work well if there's multiple extra regs (say OFFCORE and
LBR_CONFIG -- possibly even the two OFFCORE regs present on westmere).

It basically needs a per-core state for each extra_reg possible.

> +                               pc->ref++;
> +                               cpuc->percore_used = 1;
> +                       } else {
> +                               /* Deny due to conflict */
> +                               c = &emptyconstraint;
> +                       }
> +               } else {
> +                       pc->config = hwc->config;
> +                       pc->extra_reg = hwc->extra_reg;
> +                       pc->extra_config = hwc->extra_config;
> +                       pc->ref = 1;
> +                       cpuc->percore_used = 1;
> +               }
> +               raw_spin_unlock(&pc->lock);
> +               return c;
> +       }
> +
> +       return NULL;
> +} 
