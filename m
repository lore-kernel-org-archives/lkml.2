Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab0ETIK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 04:10:28 -0400
Received: from smtp-out.google.com ([74.125.121.35]:17159 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab0ETIKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 04:10:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=VmLq9l07E0yAe1wfu3Y0TE7WtxmOdgwul4G8cH8x6XQoxmGpmoKUVA7vabda+S9Ex
	17CVqdgmyO8d9frIN3kDQ==
MIME-Version: 1.0
In-Reply-To: <1274304024-6551-2-git-send-email-robert.richter@amd.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
	 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
Date: Thu, 20 May 2010 10:10:19 +0200
Message-ID: <AANLkTiniEWKJIrbTSZQ0jBXps75WVQbvGSXVyUVttJ7P@mail.gmail.com>
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the 
	type of a raw sample
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

I still don't understand why you need all of this to encode IBS.
I still believe that with attr.config there is plenty of bits to choose
from. I do understand the need for PERF_SAMPLE_RAW. I think
there is no other way.

You simply need to pick an encoding to mark the config as IBS. You
need two bits for this: 00 regular counters, 01 IBS Fetch, 10 IBS op.
Regular counters use 43 bits, IBS fetch uses 58, IBS op uses 52.
So you could use bits 62-63 for instance. You don't need to encode
the sampling period in attr.config for either IBS. You can use
attr.sample_period, so you free up 16 bits.

I understand that IBS may evolve and thus may use more bits. But
you still have at least 16 bits of margin.

Users and tools would rely on an library to provide the event encoding.
No need to come up with some raw hex number on the cmdline.

On Wed, May 19, 2010 at 11:20 PM, Robert Richter <robert.richter@amd.com> wrote:
> This patch introduces a method to specify the type of a raw sample.
> This can be used to setup hardware events other than generic
> performance counters by passing special config data to the pmu. The
> config data can be interpreted different from generic events and thus
> can be used for other purposes.
>
> The raw_type attribute is an extension of the ABI. It reuses the
> unused bp_type space for this. Generic performance counters can be
> setup by setting the raw_type attribute to null. Thus special raw
> events must have a type other than null.
>
> Raw types can be defined as needed for cpu models or architectures.
> To keep backward compatibility all architectures must return an error
> for an event with a raw_type other than null that is not supported.
>
> E.g., raw_type can be used to setup IBS on an AMD cpu. IBS is not
> common to pmu features from other vendors or architectures. The pmu
> must be setup with a special config value. Sample data is returned in
> a certain format back to the userland. An IBS event is created by
> setting a raw event and encoding the IBS type in raw_type. The pmu
> handles this raw event then and passes raw sample data back.
>
> Raw type could be architecure specific, e.g. for x86:
>
> enum perf_raw_type {
>        PERF_RAW_PERFCTR                        = 0,
>        PERF_RAW_IBS_FETCH                      = 1,
>        PERF_RAW_IBS_OP                         = 2,
>
>        PERF_RAW_MAX,
> };
>
> Null is the architecture's default, meaning for x86 a perfctr.
>
> Maybe the raw type definition could also be part of the ABI with one
> definition for all architectures.
>
> To use raw events with perf, the raw event syntax could be suffixed by
> the type (as for breakpoints):
>
>   -e rNNN[:TYPE]
>
> Example:
>
>  perf record -e r186A:1          # ... meaning IBS fetch, cycle count 100000
>  perf record -e r0:1 -c 100000   # ... the same
>
> Or with named types:
>
>  perf record -e r186A:IBS_FETCH ...
>  perf record -e r0:IBS_FETCH -c 100000 ...
>
> This solution has a number of advantages: A raw event type may be
> specified without to encode the type in the config value. The attr
> flags are not 'polluted'. We can follow the already existing
> breakpoint concept in syntax and encoding.
>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/arm/kernel/perf_event.c             |    5 +++++
>  arch/powerpc/kernel/perf_event.c         |    2 ++
>  arch/powerpc/kernel/perf_event_fsl_emb.c |    2 ++
>  arch/sh/kernel/perf_event.c              |    2 ++
>  arch/x86/kernel/cpu/perf_event.c         |    5 ++++-
>  arch/x86/kernel/cpu/perf_event_amd.c     |    3 +++
>  arch/x86/kernel/cpu/perf_event_intel.c   |    3 +++
>  arch/x86/kernel/cpu/perf_event_p4.c      |    5 +++++
>  include/linux/perf_event.h               |    5 ++++-
>  9 files changed, 30 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index 9e70f20..73d680c 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -388,6 +388,11 @@ __hw_perf_event_init(struct perf_event *event)
>        } else if (PERF_TYPE_HW_CACHE == event->attr.type) {
>                mapping = armpmu_map_cache_event(event->attr.config);
>        } else if (PERF_TYPE_RAW == event->attr.type) {
> +               if (event->attr.raw_type) {
> +                       pr_debug("invalid raw type %x\n",
> +                                event->attr.raw_type);
> +                       return -EINVAL;
> +               }
>                mapping = armpmu->raw_event(event->attr.config);
>        } else {
>                pr_debug("event type %x not supported\n", event->attr.type);
> diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
> index 43b83c3..c8fb3cf 100644
> --- a/arch/powerpc/kernel/perf_event.c
> +++ b/arch/powerpc/kernel/perf_event.c
> @@ -1036,6 +1036,8 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
>                        return ERR_PTR(err);
>                break;
>        case PERF_TYPE_RAW:
> +               if (event->attr.raw_type)
> +                       return ERR_PTR(-EINVAL);
>                ev = event->attr.config;
>                break;
>        default:
> diff --git a/arch/powerpc/kernel/perf_event_fsl_emb.c b/arch/powerpc/kernel/perf_event_fsl_emb.c
> index 369872f..7547e96 100644
> --- a/arch/powerpc/kernel/perf_event_fsl_emb.c
> +++ b/arch/powerpc/kernel/perf_event_fsl_emb.c
> @@ -452,6 +452,8 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
>                break;
>
>        case PERF_TYPE_RAW:
> +               if (event->attr.raw_type)
> +                       return ERR_PTR(-EINVAL);
>                ev = event->attr.config;
>                break;
>
> diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
> index 81b6de4..482cf48 100644
> --- a/arch/sh/kernel/perf_event.c
> +++ b/arch/sh/kernel/perf_event.c
> @@ -142,6 +142,8 @@ static int __hw_perf_event_init(struct perf_event *event)
>
>        switch (attr->type) {
>        case PERF_TYPE_RAW:
> +               if (attr->raw_type)
> +                       return -EINVAL;
>                config = attr->config & sh_pmu->raw_event_mask;
>                break;
>        case PERF_TYPE_HW_CACHE:
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index fd4db0d..3539b53 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -449,8 +449,11 @@ static int x86_setup_perfctr(struct perf_event *event)
>                        return -EOPNOTSUPP;
>        }
>
> -       if (attr->type == PERF_TYPE_RAW)
> +       if (attr->type == PERF_TYPE_RAW) {
> +               if (attr->raw_type)
> +                       return -EINVAL;
>                return 0;
> +       }
>
>        if (attr->type == PERF_TYPE_HW_CACHE)
>                return set_ext_hw_attr(hwc, attr);
> diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> index 611df11..87e5ae4 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> @@ -121,6 +121,9 @@ static int amd_pmu_hw_config(struct perf_event *event)
>        if (event->attr.type != PERF_TYPE_RAW)
>                return 0;
>
> +       if (event->attr.raw_type)
> +               return -EINVAL;
> +
>        event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
>
>        return 0;
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index fdbc652..d15faf5 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -770,6 +770,9 @@ static int intel_pmu_hw_config(struct perf_event *event)
>        if (event->attr.type != PERF_TYPE_RAW)
>                return 0;
>
> +       if (event->attr.raw_type)
> +               return -EINVAL;
> +
>        if (!(event->attr.config & ARCH_PERFMON_EVENTSEL_ANY))
>                return 0;
>
> diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
> index 87e1803..1001892 100644
> --- a/arch/x86/kernel/cpu/perf_event_p4.c
> +++ b/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -437,6 +437,11 @@ static int p4_hw_config(struct perf_event *event)
>                event->hw.config = p4_set_ht_bit(event->hw.config);
>
>        if (event->attr.type == PERF_TYPE_RAW) {
> +               /* only raw perfctr config supported */
> +               if (event->attr.raw_type) {
> +                       rc = -EINVAL;
> +                       goto out;
> +               }
>
>                /* user data may have out-of-bound event index */
>                evnt = p4_config_unpack_event(event->attr.config);
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index fe50347..f9d2d5e 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -222,7 +222,10 @@ struct perf_event_attr {
>                __u32           wakeup_watermark; /* bytes before wakeup   */
>        };
>
> -       __u32                   bp_type;
> +       union {
> +               __u32           bp_type;
> +               __u32           raw_type;
> +       };
>        __u64                   bp_addr;
>        __u64                   bp_len;
>  };
> --
> 1.7.1
>
>
>
