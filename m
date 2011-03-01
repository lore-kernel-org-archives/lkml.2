Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab1CAPgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:36:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:48296 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab1CAPf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:35:59 -0500
Subject: Re: [PATCH] perf_events: update PEBS event constraints
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ming.m.lin@intel.com,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com
In-Reply-To: <4d6d079f.9104df0a.5a71.ffffda78@mx.google.com>
References: <4d6d079f.9104df0a.5a71.ffffda78@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 16:37:27 +0100
Message-ID: <1298993847.5226.872.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 15:50 +0200, Stephane Eranian wrote:
> +static void intel_ds_init_pebs_constraints(void)
> +{
> +       /*
> +        * we only know hwo to deal with Family 6
> +        */
> +       if (boot_cpu_data.x86 != 6) {
> +               x86_pmu.pebs = 0;
> +               return;
> +       }
> +
> +       switch (boot_cpu_data.x86_model) {
> +       case 14: /* 65 nm core solo/duo, "Yonah" */
> +               /* do not have PEBS */
> +               x86_pmu.pebs = 0;
> +               break;
> +
> +       case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
> +       case 22: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
> +       case 23: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
> +       case 29: /* six-core 45 nm xeon "Dunnington" */
> +               x86_pmu.pebs_constraints = intel_core_pebs_events;
> +               pr_cont("(Core2), ");
> +               break;
> +
> +       case 26: /* 45 nm nehalem, "Bloomfield" */
> +       case 30: /* 45 nm nehalem, "Lynnfield" */
> +       case 46: /* 45 nm nehalem-ex, "Beckton" */
> +               x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
> +               pr_cont("(Nehalem), ");
> +               break;
> +
> +       case 28: /* Atom */
> +               x86_pmu.pebs_constraints = intel_atom_pebs_events;
> +               pr_cont("(Atom), ");
> +               break;
> +
> +       case 37: /* 32 nm nehalem, "Clarkdale" */
> +       case 44: /* 32 nm nehalem, "Gulftown" */
> +               x86_pmu.pebs_constraints = intel_westmere_pebs_events;
> +               pr_cont("(Westmere), ");
> +               break;
> +
> +       default:
> +               printk(KERN_CONT "PEBS not yet supported for model %d,",
> +                      boot_cpu_data.x86_model);
> +               x86_pmu.pebs = 0;
> +       }
> +} 

Right so you mentioned you had something like this, but could we please
use the one model switch in perf_event_intel.c and not replicate that,
otherwise its too easy to miss a model someplace.



