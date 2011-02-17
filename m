Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab1BQC4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 21:56:06 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61472 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab1BQC4B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:56:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kn6TYEtrFSNKqSIHzI5SU/j74Il8iMFheE4SRI2flowKKBMxpP555vm77Khl88/Jqd
         3gxqi/mxxyUn3ybr2qqYcusNF+XH81tRgVSJ8ecgGCkGbFpeSBRVEvdLqj0BwJYJClPI
         ZvbMi/VJcJpykG2w3ze8LnUJUOHgHQ1ydLeE0=
MIME-Version: 1.0
In-Reply-To: <20110216115701.3956.qmail@science.horizon.com>
References: <AANLkTikLVMNQzmugH-ORc89_ZouX6zWvG-tHSf1QoVf3@mail.gmail.com>
	<20110216115701.3956.qmail@science.horizon.com>
Date: Thu, 17 Feb 2011 12:56:00 +1000
Message-ID: <AANLkTimh61U2WC1U0uwYmK0U4TvdkCLM6NcYoAju6tp0@mail.gmail.com>
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
From: Dave Airlie <airlied@gmail.com>
To: George Spelvin <linux@horizon.com>
Cc: gorcunov@gmail.com, a.p.zijlstra@chello.nl, dzickus@redhat.com,
        eranian@google.com, linux-kernel@vger.kernel.org, ming.m.lin@intel.com,
        mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> It's appended below for your convenience.  Are you using this
> unsuccessfully?

This patch quoted below fixes it for me.

No more spurious NMIs on my P4.

Tested-by: Dave Airlie <airlied@redhat.com>

>
>
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: [PATCH] perf, x86: P4 PMU -- Fix unflagged overflows test
>
> A couple of people have reported an unknown NMI issue on p4 pmu.
> This patch should fix it.
>
> Reported-by: George Spelvin <linux@horizon.com>
> Reported-by: Meelis Roos <mroos@linux.ee>
> Reported-by: Don Zickus <dzickus@redhat.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Lin Ming <ming.m.lin@intel.com>
> CC: Don Zickus <dzickus@redhat.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/include/asm/perf_event_p4.h |    1 +
>  arch/x86/kernel/cpu/perf_event_p4.c  |   11 ++++++++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
>
> Index: linux-2.6.tip/arch/x86/include/asm/perf_event_p4.h
> ===================================================================
> --- linux-2.6.tip.orig/arch/x86/include/asm/perf_event_p4.h
> +++ linux-2.6.tip/arch/x86/include/asm/perf_event_p4.h
> @@ -22,6 +22,7 @@
>
>  #define ARCH_P4_CNTRVAL_BITS   (40)
>  #define ARCH_P4_CNTRVAL_MASK   ((1ULL << ARCH_P4_CNTRVAL_BITS) - 1)
> +#define ARCH_P4_UNFLAGGED_BIT  ((1ULL) << (ARCH_P4_CNTRVAL_BITS - 1))
>
>  #define P4_ESCR_EVENT_MASK     0x7e000000U
>  #define P4_ESCR_EVENT_SHIFT    25
> Index: linux-2.6.tip/arch/x86/kernel/cpu/perf_event_p4.c
> ===================================================================
> --- linux-2.6.tip.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.tip/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -770,9 +770,14 @@ static inline int p4_pmu_clear_cccr_ovf(
>                return 1;
>        }
>
> -       /* it might be unflagged overflow */
> -       rdmsrl(hwc->event_base + hwc->idx, v);
> -       if (!(v & ARCH_P4_CNTRVAL_MASK))
> +       /*
> +        * at some circumstances the overflow might issue NMI but did
> +        * not set P4_CCCR_OVF bit so since a counter holds a negative value
> +        * we simply check for high bit being set, if it's cleared it means
> +        * the counter has reached zero value and continued counting before
> +        * real NMI signal was received
> +        */
> +       if (!(v & ARCH_P4_UNFLAGGED_BIT))
>                return 1;
>
>        return 0;
>
