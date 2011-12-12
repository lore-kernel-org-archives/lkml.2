Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab1LLTZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:25:07 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63711 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1LLTZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:25:05 -0500
MIME-Version: 1.0
In-Reply-To: <20111212191531.GA23874@tiehlicka.suse.cz>
References: <1323466526.27746.29.camel@joe2Laptop> <1323470921-12931-1-git-send-email-kosaki.motohiro@gmail.com>
 <20111212132616.GB15249@tiehlicka.suse.cz> <20111212191531.GA23874@tiehlicka.suse.cz>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 12 Dec 2011 14:24:43 -0500
Message-ID: <CAHGf_=o2C6YniR4+3FAVVZNYb+D=9brkdLgzoRVH95ppPQCgtQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm: simplify find_vma_prev
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Shaohua Li <shaohua.li@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Why have you removed this guard? Previously we had pprev==NULL and
>> returned mm->mmap.
>> This seems like a semantic change without any explanation. Could you
>> clarify?
>
> Scratch that. I have misread the code. find_vma will return mm->mmap if
> the given address is bellow all vmas. Sorry about noise.
>
> The only concern left would be the caching. Are you sure this will not
> break some workloads which benefit from mmap_cache usage and would
> interfere with find_vma_prev callers now? Anyway this could be fixed
> trivially.

Here is callers list.

find_vma_prev     115 arch/ia64/mm/fault.c      vma =
find_vma_prev(mm, address, &prev_vma);
find_vma_prev     183 arch/parisc/mm/fault.c    vma =
find_vma_prev(mm, address, &prev_vma);
find_vma_prev     229 arch/tile/mm/hugetlbpage.c                vma =
find_vma_prev(mm, addr, &prev_vma);
find_vma_prev     336 arch/x86/mm/hugetlbpage.c                 if
(!(vma = find_vma_prev(mm, addr, &prev_vma)))
find_vma_prev     388 mm/madvise.c      vma =
find_vma_prev(current->mm, start, &prev);
find_vma_prev     642 mm/mempolicy.c    vma = find_vma_prev(mm, start, &prev);
find_vma_prev     388 mm/mlock.c        vma =
find_vma_prev(current->mm, start, &prev);
find_vma_prev     265 mm/mprotect.c     vma =
find_vma_prev(current->mm, start, &prev);

In short, find_find_prev() is only used from page fault, madvise, mbind, mlock
and mprotect. And page fault is only performance impact callsite because other
don't used frequently on regular workload.

So, I wouldn't say, this patch has zero negative impact, but I think
it is enough
small and benefit is enough much.

Thanks.
