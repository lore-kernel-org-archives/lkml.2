Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab1KGOI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:08:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:53883 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab1KGOI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:08:57 -0500
Subject: Re: [PATCHv2 6/9] perf: expose perf capability to other modules.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Date: Mon, 07 Nov 2011 15:07:50 +0100
In-Reply-To: <1320323618-10375-7-git-send-email-gleb@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
	 <1320323618-10375-7-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320674870.18053.37.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 14:33 +0200, Gleb Natapov wrote:
> @@ -1580,6 +1580,8 @@ __init int intel_pmu_init(void)
>         x86_pmu.num_counters            = eax.split.num_counters;
>         x86_pmu.cntval_bits             = eax.split.bit_width;
>         x86_pmu.cntval_mask             = (1ULL << eax.split.bit_width) - 1;
> +       x86_pmu.events_mask             = ebx;
> +       x86_pmu.events_mask_len         = eax.split.mask_length;
>  
>         /*
>          * Quirk: v2 perfmon does not report fixed-purpose events, so
> @@ -1651,6 +1653,7 @@ __init int intel_pmu_init(void)
>                          * architectural event which is often completely bogus:
>                          */
>                         intel_perfmon_event_map[PERF_COUNT_HW_BRANCH_MISSES] = 0x7f89;
> +                       x86_pmu.events_mask &= ~0x40;
>  
>                         pr_cont("erratum AAJ80 worked around, ");
>                 } 

It might make sense to introduce cpuid10_ebx or so, also I think the
removal of the branch-miss-retired event is either unwanted or
incomplete. As seen software already expects that bit to be set, even
though its known broken.

At the very least add a full ebx iteration to disable unsupported events
in the intel-v1 case.
