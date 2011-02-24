Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab1BXQye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 11:54:34 -0500
Received: from smtp-out.google.com ([74.125.121.67]:57096 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab1BXQyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 11:54:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LBCdYrhBLlqTNNFSlQqDWPTGGd9SFeYxRk9qePH7p4y/KfvaS7zhDskEouv8dE5Y+S
         ZQCsWr6dxwVVAJjjsGzw==
MIME-Version: 1.0
In-Reply-To: <1298555968.2220.15.camel@localhost>
References: <1298555968.2220.15.camel@localhost>
Date: Thu, 24 Feb 2011 17:53:25 +0100
Message-ID: <AANLkTimSbgaeeNJ+SSW4gMdYV=c+L=mavJAqDgiLRuCQ@mail.gmail.com>
Subject: Re: [PATCH -tip] perf: x86, add SandyBridge support
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p1OGsjrp019631

Lin,

On Thu, Feb 24, 2011 at 2:59 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Adds SandyBridge support to perf.
>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |  111 ++++++++++++++++++++++++++++++++
>  1 files changed, 111 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 084b383..4a132c9 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -76,6 +76,15 @@ static struct event_constraint intel_westmere_event_constraints[] =
>        EVENT_CONSTRAINT_END
>  };
>
> +static struct event_constraint intel_snb_event_constraints[] =
> +{
> +       FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
> +       FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
> +       /* FIXED_EVENT_CONSTRAINT(0x013c, 2), CPU_CLK_UNHALTED.REF */
> +       INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
> +       EVENT_CONSTRAINT_END
> +};
> +

There are more constraints than these, unfortunately. I have been
trying to get Intel
to make them public...

>  static struct event_constraint intel_gen_event_constraints[] =
>  {
>        FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
> @@ -89,6 +98,97 @@ static u64 intel_pmu_event_map(int hw_event)
>        return intel_perfmon_event_map[hw_event];
>  }
>
> +static __initconst const u64 snb_hw_cache_event_ids
> +                               [PERF_COUNT_HW_CACHE_MAX]
> +                               [PERF_COUNT_HW_CACHE_OP_MAX]
> +                               [PERF_COUNT_HW_CACHE_RESULT_MAX] =
> +{
> + [ C(L1D) ] = {
> +       [ C(OP_READ) ] = {
> +               [ C(RESULT_ACCESS) ] = 0xf1d0, /* MEM_UOP_RETIRED.LOADS        */
> +               [ C(RESULT_MISS)   ] = 0x0151, /* L1D.REPLACEMENT              */
> +       },
> +       [ C(OP_WRITE) ] = {
> +               [ C(RESULT_ACCESS) ] = 0xf2d0, /* MEM_UOP_RETIRED.STORES       */
> +               [ C(RESULT_MISS)   ] = 0x0851, /* L1D.ALL_M_REPLACEMENT        */
> +       },
> +       [ C(OP_PREFETCH) ] = {
> +               [ C(RESULT_ACCESS) ] = 0x0,
> +               [ C(RESULT_MISS)   ] = 0x024e, /* HW_PRE_REQ.DL1_MISS          */
> +       },
> + },
> + [ C(L1I ) ] = {
> +       [ C(OP_READ) ] = {
> +               [ C(RESULT_ACCESS) ] = 0x0,
> +               [ C(RESULT_MISS)   ] = 0x0280, /* ICACHE.MISSES */
> +       },
> +       [ C(OP_WRITE) ] = {
> +               [ C(RESULT_ACCESS) ] = -1,
> +               [ C(RESULT_MISS)   ] = -1,
> +       },
> +       [ C(OP_PREFETCH) ] = {
> +               [ C(RESULT_ACCESS) ] = 0x0,
> +               [ C(RESULT_MISS)   ] = 0x0,
> +       },
> + },
> + [ C(LL  ) ] = {
> +       [ C(OP_READ) ] = {
> +               [ C(RESULT_ACCESS) ] = 0x04d1, /* MEM_LOAD_UOPS_RETIRED.LLC_HIT */
> +               [ C(RESULT_MISS)   ] = 0x0,
> +       },
> +       [ C(OP_WRITE) ] = {
> +               [ C(RESULT_ACCESS) ] = 0x0424, /* L2_RQSTS.RFO_HITS */
> +               [ C(RESULT_MISS)   ] = 0x0824, /* L2_RQSTS.RFO_MISS */
> +       },
> +       [ C(OP_PREFETCH) ] = {
> +               [ C(RESULT_ACCESS) ] = 0x4f2e, /* L3_LAT_CACHE.REFERENCE       */
> +               [ C(RESULT_MISS)   ] = 0x412e, /* L3_LAT_CACHE.MISS            */
> +       },
> + },
> + [ C(DTLB) ] = {
> +       [ C(OP_READ) ] = {
> +               [ C(RESULT_ACCESS) ] = 0x01d0, /* MEM_UOP_RETIRED.LOADS */
> +               [ C(RESULT_MISS)   ] = 0x0108, /* DTLB_LOAD_MISSES.CAUSES_A_WALK */
> +       },
> +       [ C(OP_WRITE) ] = {
> +               [ C(RESULT_ACCESS) ] = 0x02d0, /* MEM_UOP_RETIRED.STORES */
> +               [ C(RESULT_MISS)   ] = 0x0149, /* DTLB_STORE_MISSES.MISS_CAUSES_A_WALK */
> +       },
> +       [ C(OP_PREFETCH) ] = {
> +               [ C(RESULT_ACCESS) ] = 0x0,
> +               [ C(RESULT_MISS)   ] = 0x0,
> +       },
> + },
> + [ C(ITLB) ] = {
> +       [ C(OP_READ) ] = {
> +               [ C(RESULT_ACCESS) ] = 0x1085, /* ITLB_MISSES.STLB_HIT         */
> +               [ C(RESULT_MISS)   ] = 0x0185, /* ITLB_MISSES.CAUSES_A_WALK    */
> +       },
> +       [ C(OP_WRITE) ] = {
> +               [ C(RESULT_ACCESS) ] = -1,
> +               [ C(RESULT_MISS)   ] = -1,
> +       },
> +       [ C(OP_PREFETCH) ] = {
> +               [ C(RESULT_ACCESS) ] = -1,
> +               [ C(RESULT_MISS)   ] = -1,
> +       },
> + },
> + [ C(BPU ) ] = {
> +       [ C(OP_READ) ] = {
> +               [ C(RESULT_ACCESS) ] = 0x00c4, /* BR_INST_RETIRED.ALL_BRANCHES */
> +               [ C(RESULT_MISS)   ] = 0x00c5, /* BR_MISP_RETIRED.ALL_BRANCHES */
> +       },Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> +       [ C(OP_WRITE) ] = {
> +               [ C(RESULT_ACCESS) ] = -1,
> +               [ C(RESULT_MISS)   ] = -1,
> +       },
> +       [ C(OP_PREFETCH) ] = {
> +               [ C(RESULT_ACCESS) ] = -1,
> +               [ C(RESULT_MISS)   ] = -1,
> +       },
> + },
> +};
> +
>  static __initconst const u64 westmere_hw_cache_event_ids
>                                [PERF_COUNT_HW_CACHE_MAX]
>                                [PERF_COUNT_HW_CACHE_OP_MAX]
> @@ -1062,6 +1162,17 @@ static __init int intel_pmu_init(void)
>                pr_cont("Westmere events, ");
>                break;
>
> +       case 42: /* SandyBridge */
> +               memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
> +                      sizeof(hw_cache_event_ids));
> +
> +               intel_pmu_lbr_init_nhm();
> +
> +               x86_pmu.event_constraints = intel_snb_event_constraints;
> +               x86_pmu.enable_all = intel_pmu_nhm_enable_all;

I don't see the errata that would justify using the Nehalem workaround
enable_all
function here.
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
