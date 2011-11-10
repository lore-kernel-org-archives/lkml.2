Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935055Ab1KJPJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:09:34 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56026 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933842Ab1KJPJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:09:33 -0500
MIME-Version: 1.0
In-Reply-To: <1320935860.13800.25.camel@twins>
References: <20111107110149.GA5177@quad>
	<1320935860.13800.25.camel@twins>
Date: Thu, 10 Nov 2011 16:09:32 +0100
Message-ID: <CABPqkBS_4TBYUvw_bPbtgpAfp8+vnSRZBYQoSAOKjOYV4GHmXA@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, robert.richter@amd.com, mingo@elte.hu,
        ming.m.lin@intel.com, ak@linux.intel.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAAF9gbl003698

On Thu, Nov 10, 2011 at 3:37 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> Just throwing this out there (hasn't event been compiled etc..).
>
> The idea is to try the fixed counters first so that we don't
> 'accidentally' fill a GP counter with something that could have lived on
> the fixed purpose one and then end up under utilizing the PMU that way.
>
> It ought to solve the most common PMU programming fail on Intel
> thingies.
>
What are the configs for which you have failures on Intel?

I think I can improve my algorithm for fixed counters by treating
them separately and trying fixed counters first any supported
event.

> ---
> Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
> @@ -558,14 +558,22 @@ int x86_schedule_events(struct cpu_hw_ev
>                        if (c->weight != w)
>                                continue;
>
> -                       for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
> +                       if (x86_pmu.num_counters_fixed) {
> +                               j = X86_PMC_IDX_FIXED - 1;
> +                               for_each_set_bit_cont(j, c->idxmsk, X86_PMC_IDX_MAX) {
> +                                       if (!test_bit(k, used_mask))
> +                                               goto assign;
> +                               }
> +                       }
> +
> +                       for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_FIXED) {
>                                if (!test_bit(j, used_mask))
> -                                       break;
> +                                       goto assign;
>                        }
>
> -                       if (j == X86_PMC_IDX_MAX)
> -                               break;
> +                       break;
>
> +assign:
>                        __set_bit(j, used_mask);
>
>                        if (assign)
> Index: linux-2.6/include/linux/bitops.h
> ===================================================================
> --- linux-2.6.orig/include/linux/bitops.h
> +++ linux-2.6/include/linux/bitops.h
> @@ -26,6 +26,12 @@ extern unsigned long __sw_hweight64(__u6
>             (bit) < (size); \
>             (bit) = find_next_bit((addr), (size), (bit) + 1))
>
> +#define for_each_set_bit_cont(bit, addr, size) \
> +       for ((bit) = find_next_bit((addr), (size), (bit) + 1); \
> +            (bit) < (size); \
> +            (bit) = find_next_bit((addr), (size), (bit) + 1))
> +
> +
>  static __inline__ int get_bitmask_order(unsigned int count)
>  {
>        int order;
>
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
