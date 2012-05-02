Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab2EBPVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 11:21:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab2EBPVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 11:21:47 -0400
Message-ID: <4FA150F6.9090604@redhat.com>
Date: Wed, 02 May 2012 11:21:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: andi.kleen@intel.com, tim.c.chen@linux.intel.com, jeremy@goop.org,
        chrisw@sous-sol.org, akataria@vmware.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        paul.gortmaker@windriver.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/flush_tlb: try flush_tlb_single one by one in
 flush_tlb_range
References: <1335603006-2572-2-git-send-email-alex.shi@intel.com> <1335603006-2572-3-git-send-email-alex.shi@intel.com>
In-Reply-To: <1335603006-2572-3-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2012 04:50 AM, Alex Shi wrote:
> x86 has no flush_tlb_range support in instruction level. Currently the
> flush_tlb_range just implemented by flushing all page table. That is not
> the best solution for all scenarios. In fact, if we just use 'invlpg' to
> flush few lines from TLB, we can get the performance gain from later
> remain TLB lines accessing.
>
> But the 'invlpg' instruction costs much of time. Its execution time can
> compete with cr3 rewriting, and even a bit more on SNB CPU.
>
> So, on a 512 4KB TLB entries CPU, the balance points is at:
> 512 * 100ns(assumed TLB refill cost) =
> x(TLB flush entries) * 140ns(assumed invlpg cost)
>
> Here, x is about 360, that is about 5/8 of 512 entries.
>
> But with the mysterious CPU pre-fetcher and page miss handler Unit, the
> assumed TLB refill cost is far lower then 100ns in sequential access. And
> 2 HT siblings in one core makes the memory access more faster if they are
> accessing the same memory. So, in the patch, I just do the change when
> the target entries is less than 1/16 of whole active tlb entries.
> Actually, I have no data support for the percentage '1/16', so any
> suggestions are welcomed.

The numbers speak for themselves, 1/16th seems to work
fine on current generation CPUs.

> +
> +#define FLUSHALL_BAR	16

However, since this is a somewhat arbitrary number, it
would be good to accompany this #define with a multi-line
comment explaining your reasoning for choosing this number.

That will make it easy to re-evaluate in the future, if neeeded.
