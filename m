Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2KGKqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:46:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab2KGKqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:46:10 -0500
Message-ID: <509A3C7E.9040809@redhat.com>
Date: Wed, 07 Nov 2012 05:48:30 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/19] mm: numa: Create basic numa page hinting infrastructure
References: <1352193295-26815-1-git-send-email-mgorman@suse.de> <1352193295-26815-9-git-send-email-mgorman@suse.de> <50995DD2.8000200@redhat.com> <20121107103839.GT8218@suse.de>
In-Reply-To: <20121107103839.GT8218@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 05:38 AM, Mel Gorman wrote:
> On Tue, Nov 06, 2012 at 01:58:26PM -0500, Rik van Riel wrote:
>> On 11/06/2012 04:14 AM, Mel Gorman wrote:
>>> Note: This patch started as "mm/mpol: Create special PROT_NONE
>>> 	infrastructure" and preserves the basic idea but steals *very*
>>> 	heavily from "autonuma: numa hinting page faults entry points" for
>>> 	the actual fault handlers without the migration parts.	The end
>>> 	result is barely recognisable as either patch so all Signed-off
>>> 	and Reviewed-bys are dropped. If Peter, Ingo and Andrea are ok with
>>> 	this version, I will re-add the signed-offs-by to reflect the history.
>>>
>>> In order to facilitate a lazy -- fault driven -- migration of pages, create
>>> a special transient PAGE_NUMA variant, we can then use the 'spurious'
>>> protection faults to drive our migrations from.
>>>
>>> Pages that already had an effective PROT_NONE mapping will not be detected
>>
>> The patch itself is good, but the changelog needs a little
>> fix. While you are defining _PAGE_NUMA to _PAGE_PROTNONE on
>> x86, this may be different on other architectures.
>>
>> Therefore, the changelog should refer to PAGE_NUMA, not
>> PROT_NONE.
>>
>
> Fair point. I still want to record the point that PROT_NONE will not
> generate the faults though. How about this?
>
>      In order to facilitate a lazy -- fault driven -- migration of pages, create
>      a special transient PAGE_NUMA variant, we can then use the 'spurious'
>      protection faults to drive our migrations from.
>
>      The meaning of PAGE_NUMA depends on the architecture but on x86 it is
>      effectively PROT_NONE. In this case, PROT_NONE mappings will not be detected
>      to generate these 'spurious' faults for the simple reason that we cannot
>      distinguish them on their protection bits, see pte_numa(). This isn't
>      a problem since PROT_NONE (and possible PROT_WRITE with dirty tracking)
>      aren't used or are rare enough for us to not care about their placement.

Actual PROT_NONE mappings will not generate these NUMA faults
for the reason that the page fault code checks the permission
on the VMA (and will throw a segmentation fault on actual
PROT_NONE mappings), before it ever calls handle_mm_fault.

