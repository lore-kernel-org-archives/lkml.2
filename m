Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab2JZNuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 09:50:32 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53391 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab2JZNub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 09:50:31 -0400
Date: Fri, 26 Oct 2012 15:50:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 26/31] sched, numa, mm: Add fault driven placement and
 migration policy
Message-ID: <20121026135024.GA11640@gmail.com>
References: <20121025121617.617683848@chello.nl>
 <20121025124834.467791319@chello.nl>
 <CA+55aFwJdn8Kz9UByuRfGNtf9Hkv-=8xB+WRd47uHZU1YMagZw@mail.gmail.com>
 <20121026071532.GC8141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026071532.GC8141@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> [
>   task_numa_work() performance side note:
> 
>   We are also *very* close to be able to use down_read() instead
>   of down_write() in the sampling-unmap code in 
>   task_numa_work(), as it should be safe in theory to call 
>   change_protection(PROT_NONE) in parallel - but there's one 
>   regression that disagrees with this theory so we use 
>   down_write() at the moment.
> 
>   Maybe you could help us there: can you see a reason why the
>   change_prot_none()->change_protection() call in
>   task_numa_work() can not occur in parallel to a page fault in
>   another thread on another CPU? It should be safe - yet if we 
>   change it I can see occasional corruption of user-space state: 
>   segfaults and register corruption.
> ]

Oh, just found the reason:

the ptep_modify_prot_start()/modify()/commit() sequence is 
SMP-unsafe - it has to be done under the mmap_sem write-locked.

It is safe against *hardware* updates to the PTE, but not safe 
against itself.

This is apparently a hidden cost of paravirt, it is forcing that 
weird sequence and thus the down_write() ...

Thanks,

	Ingo
