Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab2DCGD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 02:03:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60884 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2DCGD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 02:03:28 -0400
Message-ID: <4F7A92AB.5010809@openvz.org>
Date: Tue, 03 Apr 2012 10:03:23 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Pallipadi Venkatesh <venki@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [x86 PAT PATCH 0/2] x86 PAT vm_flag code refactoring
References: <20120331170947.7773.46399.stgit@zurg> <1333413969-30761-1-git-send-email-suresh.b.siddha@intel.com>
In-Reply-To: <1333413969-30761-1-git-send-email-suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> Konstantin,
>
> On Sat, 2012-03-31 at 21:09 +0400, Konstantin Khlebnikov wrote:
>> v2: Do not use batched pfn reserving for single-page VMA. This is not optimal
>> and breaks something, because I see glitches on the screen with i915/drm driver.
>> With this version glitches are gone, and I see the same regions in
>> /sys/kernel/debug/x86/pat_memtype_list as before patch. So, please review this
>> carefully, probably I'm wrong somewhere, or I have triggered some hidden bug.
>
> Actually it is not a hidden bug. In the original code, we were setting
> VM_PFN_AT_MMAP only for remap_pfn_range() but not for the vm_insert_pfn().
> Also the value of 'vm_pgoff' depends on the driver/mmap_region() in the case of
> vm_insert_pfn(). But with your proposed code, you were setting
> the VM_PAT for the single-page VMA also and end-up using wrong vm_pgoff in
> untrack_pfn_vma().

But I set correct vma->vm_pgoff together with VM_PAT. But, it shouldn't work if vma is expandable...

>
> We can simplify the track/untrack pfn routines and can remove the
> dependency on vm_pgoff completely. Am appending a patch which does this
> and also modified your x86 PAT patch based on this. Can you please
> check and if you are ok, merge these bits with the rest of your patches.

Ok, I'll checks this.

>
> thanks,
> suresh
> ---
>
> Konstantin Khlebnikov (1):
>    mm, x86, PAT: rework linear pfn-mmap tracking
>
> Suresh Siddha (1):
>    x86, pat: remove the dependency on 'vm_pgoff' in track/untrack pfn
>      vma routines
>
>   arch/x86/mm/pat.c             |   38 ++++++++++++++++++++++++--------------
>   include/asm-generic/pgtable.h |    4 ++--
>   include/linux/mm.h            |   15 +--------------
>   mm/huge_memory.c              |    7 +++----
>   mm/memory.c                   |   15 ++++++++-------
>   5 files changed, 38 insertions(+), 41 deletions(-)
>

