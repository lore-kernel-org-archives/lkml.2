Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1LYPpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 10:45:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab1LYPpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 10:45:41 -0500
Message-ID: <4EF74517.40008@redhat.com>
Date: Sun, 25 Dec 2011 17:45:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com>
In-Reply-To: <4EF701C7.9080907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2011 12:58 PM, Avi Kivity wrote:
> On 12/23/2011 12:36 PM, Ingo Molnar wrote:
> > * Nikunj A Dadhania <nikunj@linux.vnet.ibm.com> wrote:
> >
> > > Here some interesting perf reports from inside the guest:
> > > 
> > > Baseline:
> > >   29.79%   ebizzy  [kernel.kallsyms]   [k] native_flush_tlb_others
> > >   18.70%   ebizzy  libc-2.12.so        [.] __GI_memcpy
> > >    7.23%   ebizzy  [kernel.kallsyms]   [k] get_page_from_freelist
> > >    5.38%   ebizzy  [kernel.kallsyms]   [k] __do_page_fault
> > >    4.50%   ebizzy  [kernel.kallsyms]   [k] ____pagevec_lru_add
> > >    3.58%   ebizzy  [kernel.kallsyms]   [k] default_send_IPI_mask_logical
> > >    3.26%   ebizzy  [kernel.kallsyms]   [k] native_flush_tlb_single
> > >    2.82%   ebizzy  [kernel.kallsyms]   [k] handle_pte_fault
> > >    2.16%   ebizzy  [kernel.kallsyms]   [k] kunmap_atomic
> > >    2.10%   ebizzy  [kernel.kallsyms]   [k] _spin_unlock_irqrestore
> > >    1.90%   ebizzy  [kernel.kallsyms]   [k] down_read_trylock
> > >    1.65%   ebizzy  [kernel.kallsyms]   [k] __mem_cgroup_commit_charge.clone.4
> > >    1.60%   ebizzy  [kernel.kallsyms]   [k] up_read
> > >    1.24%   ebizzy  [kernel.kallsyms]   [k] __alloc_pages_nodemask
> > > 
> > > Gang:
> > >   22.53%   ebizzy  libc-2.12.so       [.] __GI_memcpy
> > >    9.73%   ebizzy  [kernel.kallsyms]  [k] ____pagevec_lru_add
> > >    8.22%   ebizzy  [kernel.kallsyms]  [k] get_page_from_freelist
> > >    7.80%   ebizzy  [kernel.kallsyms]  [k] default_send_IPI_mask_logical
> > >    7.68%   ebizzy  [kernel.kallsyms]  [k] native_flush_tlb_others
> > >    6.22%   ebizzy  [kernel.kallsyms]  [k] __do_page_fault
> > >    5.54%   ebizzy  [kernel.kallsyms]  [k] native_flush_tlb_single
> > >    4.44%   ebizzy  [kernel.kallsyms]  [k] _spin_unlock_irqrestore
> > >    2.90%   ebizzy  [kernel.kallsyms]  [k] kunmap_atomic
> > >    2.78%   ebizzy  [kernel.kallsyms]  [k] __mem_cgroup_commit_charge.clone.4
> > >    2.76%   ebizzy  [kernel.kallsyms]  [k] handle_pte_fault
> > >    2.16%   ebizzy  [kernel.kallsyms]  [k] __mem_cgroup_uncharge_common
> > >    1.59%   ebizzy  [kernel.kallsyms]  [k] down_read_trylock
> > >    1.43%   ebizzy  [kernel.kallsyms]  [k] up_read
> > > 
> > > I see the main difference between both the reports is:
> > > native_flush_tlb_others.
> >
> > So it would be important to figure out why ebizzy gets into so 
> > many TLB flushes and why gang scheduling makes it go away.

<snip>

> The first part appears to be unrelated to ebizzy itself - it's the
> kunmap_atomic() flushing ptes.  It could be eliminated by switching to a
> non-highmem kernel, or by allocating more PTEs for kmap_atomic() and
> batching the flush.

Um, that makes no sense.  I was reading the profile as if it was a
backtrace.

Anyway, google says the ebizzy does a lot of large allocations - and
presumably deallocations - to simulate a database workload, which
explain the large number of tlb flushes.

-- 
error compiling committee.c: too many arguments to function

