Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934423Ab2JXH2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 03:28:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34415 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934402Ab2JXH2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 03:28:36 -0400
MIME-Version: 1.0
In-Reply-To: <1351058350-9159-2-git-send-email-zheng.z.yan@intel.com>
References: <1351058350-9159-1-git-send-email-zheng.z.yan@intel.com>
	<1351058350-9159-2-git-send-email-zheng.z.yan@intel.com>
Date: Wed, 24 Oct 2012 09:28:34 +0200
Message-ID: <CABPqkBRMo9o8bujM+aCqh-hWqVz1-Y1G_15Oovv+15SMBbK=aA@mail.gmail.com>
Subject: Re: [PATCH V2 1/7] perf, x86: Reduce lbr_sel_map size
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 7:59 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>
> The index of lbr_sel_map is bit value of perf branch_sample_type.
> By using bit shift as index, we can reduce lbr_sel_map size.
>
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.h           |  4 +++
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c | 50 ++++++++++++++----------------
>  include/uapi/linux/perf_event.h            | 42 +++++++++++++++++--------
>  3 files changed, 56 insertions(+), 40 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index d3b3bb7..ea6749a 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -412,6 +412,10 @@ struct x86_pmu {
>         struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
>  };
>
> +enum {
> +       PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE = PERF_SAMPLE_BRANCH_MAX_SHIFT,
> +};
> +
What's the point on the extraneous definition?

>  #define x86_add_quirk(func_)                                           \
>  do {                                                                   \
>         static struct x86_pmu_quirk __quirk __initdata = {              \
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> index 31fe046..7d9ae5f 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -61,10 +61,6 @@ enum {
>  #define LBR_FROM_FLAG_INTX     (1ULL << 62)
>  #define LBR_FROM_FLAG_ABORT    (1ULL << 61)
>
> -#define for_each_branch_sample_type(x) \
> -       for ((x) = PERF_SAMPLE_BRANCH_USER; \
> -            (x) < PERF_SAMPLE_BRANCH_MAX; (x) <<= 1)
> -
>  /*
>   * x86control flow change classification
>   * x86control flow changes include branches, interrupts, traps, faults
> @@ -378,14 +374,14 @@ static int intel_pmu_setup_hw_lbr_filter(struct perf_event *event)
>  {
>         struct hw_perf_event_extra *reg;
>         u64 br_type = event->attr.branch_sample_type;
> -       u64 mask = 0, m;
> -       u64 v;
> +       u64 mask = 0, v;
> +       int i;
>
> -       for_each_branch_sample_type(m) {
> -               if (!(br_type & m))
> +       for (i = 0; i < PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE; i++) {

Why not just define for_each_branch_shift()?

> +               if (!(br_type & (1U << i)))
>                         continue;
>
> -               v = x86_pmu.lbr_sel_map[m];
> +               v = x86_pmu.lbr_sel_map[i];
>                 if (v == LBR_NOT_SUPP)
>                         return -EOPNOTSUPP;
>
> @@ -631,33 +627,33 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
>  /*
>   * Map interface branch filters onto LBR filters
>   */
> -static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
> -       [PERF_SAMPLE_BRANCH_ANY]        = LBR_ANY,
> -       [PERF_SAMPLE_BRANCH_USER]       = LBR_USER,
> -       [PERF_SAMPLE_BRANCH_KERNEL]     = LBR_KERNEL,
> -       [PERF_SAMPLE_BRANCH_HV]         = LBR_IGN,
> -       [PERF_SAMPLE_BRANCH_ANY_RETURN] = LBR_RETURN | LBR_REL_JMP
> -                                       | LBR_IND_JMP | LBR_FAR,
> +static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
> +       [PERF_SAMPLE_BRANCH_ANY_SHIFT]          = LBR_ANY,
> +       [PERF_SAMPLE_BRANCH_USER_SHIFT]         = LBR_USER,
> +       [PERF_SAMPLE_BRANCH_KERNEL_SHIFT]       = LBR_KERNEL,
> +       [PERF_SAMPLE_BRANCH_HV_SHIFT]           = LBR_IGN,
> +       [PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT]   = LBR_RETURN | LBR_REL_JMP
> +                                               | LBR_IND_JMP | LBR_FAR,
>         /*
>          * NHM/WSM erratum: must include REL_JMP+IND_JMP to get CALL branches
>          */
> -       [PERF_SAMPLE_BRANCH_ANY_CALL] =
> +       [PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT] =
>          LBR_REL_CALL | LBR_IND_CALL | LBR_REL_JMP | LBR_IND_JMP | LBR_FAR,
>         /*
>          * NHM/WSM erratum: must include IND_JMP to capture IND_CALL
>          */
> -       [PERF_SAMPLE_BRANCH_IND_CALL] = LBR_IND_CALL | LBR_IND_JMP,
> +       [PERF_SAMPLE_BRANCH_IND_CALL_SHIFT] = LBR_IND_CALL | LBR_IND_JMP,
>  };
>
> -static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
> -       [PERF_SAMPLE_BRANCH_ANY]        = LBR_ANY,
> -       [PERF_SAMPLE_BRANCH_USER]       = LBR_USER,
> -       [PERF_SAMPLE_BRANCH_KERNEL]     = LBR_KERNEL,
> -       [PERF_SAMPLE_BRANCH_HV]         = LBR_IGN,
> -       [PERF_SAMPLE_BRANCH_ANY_RETURN] = LBR_RETURN | LBR_FAR,
> -       [PERF_SAMPLE_BRANCH_ANY_CALL]   = LBR_REL_CALL | LBR_IND_CALL
> -                                       | LBR_FAR,
> -       [PERF_SAMPLE_BRANCH_IND_CALL]   = LBR_IND_CALL,
> +static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
> +       [PERF_SAMPLE_BRANCH_ANY_SHIFT]          = LBR_ANY,
> +       [PERF_SAMPLE_BRANCH_USER_SHIFT]         = LBR_USER,
> +       [PERF_SAMPLE_BRANCH_KERNEL_SHIFT]       = LBR_KERNEL,
> +       [PERF_SAMPLE_BRANCH_HV_SHIFT]           = LBR_IGN,
> +       [PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT]   = LBR_RETURN | LBR_FAR,
> +       [PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT]     = LBR_REL_CALL | LBR_IND_CALL
> +                                               | LBR_FAR,
> +       [PERF_SAMPLE_BRANCH_IND_CALL_SHIFT]     = LBR_IND_CALL,
>  };
>
>  /* core */
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index d1ffdb6..4a735be 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -148,20 +148,36 @@ enum perf_event_sample_format {
>   * The branch types can be combined, however BRANCH_ANY covers all types
>   * of branches and therefore it supersedes all the other types.
>   */
> +enum perf_branch_sample_type_shift {
> +       PERF_SAMPLE_BRANCH_USER_SHIFT           = 0, /* user branches */
> +       PERF_SAMPLE_BRANCH_KERNEL_SHIFT         = 1, /* kernel branches */
> +       PERF_SAMPLE_BRANCH_HV_SHIFT             = 2, /* hypervisor branches */
> +
> +       PERF_SAMPLE_BRANCH_ANY_SHIFT            = 3, /* any branch types */
> +       PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT       = 4, /* any call branch */
> +       PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT     = 5, /* any return branch */
> +       PERF_SAMPLE_BRANCH_IND_CALL_SHIFT       = 6, /* indirect calls */
> +       PERF_SAMPLE_BRANCH_ABORT_SHIFT          = 7, /* transaction aborts */
> +       PERF_SAMPLE_BRANCH_INTX_SHIFT           = 8, /* in transaction */
> +       PERF_SAMPLE_BRANCH_NOTX_SHIFT           = 9, /* not in transaction */
> +
> +       PERF_SAMPLE_BRANCH_MAX_SHIFT,           /* non-ABI */
> +};
> +
>  enum perf_branch_sample_type {
> -       PERF_SAMPLE_BRANCH_USER         = 1U << 0, /* user branches */
> -       PERF_SAMPLE_BRANCH_KERNEL       = 1U << 1, /* kernel branches */
> -       PERF_SAMPLE_BRANCH_HV           = 1U << 2, /* hypervisor branches */
> -
> -       PERF_SAMPLE_BRANCH_ANY          = 1U << 3, /* any branch types */
> -       PERF_SAMPLE_BRANCH_ANY_CALL     = 1U << 4, /* any call branch */
> -       PERF_SAMPLE_BRANCH_ANY_RETURN   = 1U << 5, /* any return branch */
> -       PERF_SAMPLE_BRANCH_IND_CALL     = 1U << 6, /* indirect calls */
> -       PERF_SAMPLE_BRANCH_ABORT        = 1U << 7, /* transaction aborts */
> -       PERF_SAMPLE_BRANCH_INTX         = 1U << 8, /* in transaction (flag) */
> -       PERF_SAMPLE_BRANCH_NOTX         = 1U << 9, /* not in transaction (flag) */
> -
> -       PERF_SAMPLE_BRANCH_MAX          = 1U << 10, /* non-ABI */
> +       PERF_SAMPLE_BRANCH_USER         = 1U << PERF_SAMPLE_BRANCH_USER_SHIFT,
> +       PERF_SAMPLE_BRANCH_KERNEL       = 1U << PERF_SAMPLE_BRANCH_KERNEL_SHIFT,
> +       PERF_SAMPLE_BRANCH_HV           = 1U << PERF_SAMPLE_BRANCH_HV_SHIFT,
> +
> +       PERF_SAMPLE_BRANCH_ANY          = 1U << PERF_SAMPLE_BRANCH_ANY_SHIFT,
> +       PERF_SAMPLE_BRANCH_ANY_CALL     = 1U << PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT,
> +       PERF_SAMPLE_BRANCH_ANY_RETURN   = 1U << PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT,
> +       PERF_SAMPLE_BRANCH_IND_CALL     = 1U << PERF_SAMPLE_BRANCH_IND_CALL_SHIFT,
> +       PERF_SAMPLE_BRANCH_ABORT        = 1U << PERF_SAMPLE_BRANCH_ABORT_SHIFT,
> +       PERF_SAMPLE_BRANCH_INTX         = 1U << PERF_SAMPLE_BRANCH_INTX_SHIFT,
> +       PERF_SAMPLE_BRANCH_NOTX         = 1U << PERF_SAMPLE_BRANCH_NOTX_SHIFT,
> +
> +       PERF_SAMPLE_BRANCH_MAX          = 1U << PERF_SAMPLE_BRANCH_MAX_SHIFT,
>  };
>
>  #define PERF_SAMPLE_BRANCH_PLM_ALL \
> --
> 1.7.11.7
>
