Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507Ab2J2Pf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:35:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:42646 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759364Ab2J2PfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:35:22 -0400
Message-ID: <1351524905.24721.33.camel@twins>
Subject: Re: [Patch v1 04/10] perf/x86: add memory profiling via PEBS Load
 Latency
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, ming.m.lin@intel.com
Date: Mon, 29 Oct 2012 16:35:05 +0100
In-Reply-To: <1351523752-4215-5-git-send-email-eranian@google.com>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	 <1351523752-4215-5-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 16:15 +0100, Stephane Eranian wrote:
> +static u64 load_latency_data(u64 status)
> +{
> +       union intel_x86_pebs_dse dse;
> +       u64 val;
> +       int model = boot_cpu_data.x86_model;
> +       int fam = boot_cpu_data.x86;
> +
> +       dse.val = status;
> +
> +       /*
> +        * use the mapping table for bit 0-15
> +        */
> +       val = pebs_data_source[dse.ld_dse];
> +
> +       /*
> +        * Nehalem models do not support TLB, Lock infos
> +        */
> +       if (fam == 0x6 && (model == 26 || model == 30
> +           || model == 31 || model == 46)) {
> +               val |= P(TLB, NA) | P(LOCK, NA);
> +               return val;
> +       }

I'm so 100% sure we'll forget to add a nhm model number if we ever find
we missed one.

Could we either add a classification enum to x86_pmu that is set in the
big model switch on init, or do this with your new constraints flags,
where we have a different flag for NHM_LL vs SNB_LL or so?

Or if all else fails, add a quirk to the Intel Debugstore bits bitfield,
something like pebs_ll_nhm.

> +       /*
> +        * bit 4: TLB access
> +        * 0 = did not miss 2nd level TLB
> +        * 1 = missed 2nd level TLB
> +        */
> +       if (dse.ld_stlb_miss)
> +               val |= P(TLB, MISS) | P(TLB, L2);
> +       else
> +               val |= P(TLB, HIT) | P(TLB,L1) | P(TLB, L2);
> +
> +       /*
> +        * bit 5: locked prefix
> +        */
> +       if (dse.ld_locked)
> +               val |= P(LOCK, LOCKED);
> +
> +       return val;
> +} 
