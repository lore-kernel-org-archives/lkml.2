Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab2J2Pjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:39:45 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59119 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2J2Pjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:39:43 -0400
MIME-Version: 1.0
In-Reply-To: <1351524905.24721.33.camel@twins>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	<1351523752-4215-5-git-send-email-eranian@google.com>
	<1351524905.24721.33.camel@twins>
Date: Mon, 29 Oct 2012 16:39:42 +0100
Message-ID: <CABPqkBTTUJZQJ3_Tte92DKopxZGYJVsaw2tdSea9ZcmpZbx=hA@mail.gmail.com>
Subject: Re: [Patch v1 04/10] perf/x86: add memory profiling via PEBS Load Latency
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 4:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-10-29 at 16:15 +0100, Stephane Eranian wrote:
>> +static u64 load_latency_data(u64 status)
>> +{
>> +       union intel_x86_pebs_dse dse;
>> +       u64 val;
>> +       int model = boot_cpu_data.x86_model;
>> +       int fam = boot_cpu_data.x86;
>> +
>> +       dse.val = status;
>> +
>> +       /*
>> +        * use the mapping table for bit 0-15
>> +        */
>> +       val = pebs_data_source[dse.ld_dse];
>> +
>> +       /*
>> +        * Nehalem models do not support TLB, Lock infos
>> +        */
>> +       if (fam == 0x6 && (model == 26 || model == 30
>> +           || model == 31 || model == 46)) {
>> +               val |= P(TLB, NA) | P(LOCK, NA);
>> +               return val;
>> +       }
>
> I'm so 100% sure we'll forget to add a nhm model number if we ever find
> we missed one.
>
> Could we either add a classification enum to x86_pmu that is set in the
> big model switch on init, or do this with your new constraints flags,
> where we have a different flag for NHM_LL vs SNB_LL or so?
>
Let's add something in x86_pmu. We could, for instance, generalize
x86_pmu.er_flags into x86_pmu.flags. Instead of adding yet another
flag field.

> Or if all else fails, add a quirk to the Intel Debugstore bits bitfield,
> something like pebs_ll_nhm.
>
>> +       /*
>> +        * bit 4: TLB access
>> +        * 0 = did not miss 2nd level TLB
>> +        * 1 = missed 2nd level TLB
>> +        */
>> +       if (dse.ld_stlb_miss)
>> +               val |= P(TLB, MISS) | P(TLB, L2);
>> +       else
>> +               val |= P(TLB, HIT) | P(TLB,L1) | P(TLB, L2);
>> +
>> +       /*
>> +        * bit 5: locked prefix
>> +        */
>> +       if (dse.ld_locked)
>> +               val |= P(LOCK, LOCKED);
>> +
>> +       return val;
>> +}
