Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab1LWDYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 22:24:25 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59483 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab1LWDYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 22:24:21 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <4EF1B85F.7060105@redhat.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Fri, 23 Dec 2011 08:50:04 +0530
Message-ID: <877h1o9dp7.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11122303-3864-0000-0000-000000A2384C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 12:43:43 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 12/21/2011 12:39 PM, Nikunj A Dadhania wrote:
> > On Mon, 19 Dec 2011 12:23:26 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > * Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com> wrote:
> > > 
> > > So could we please approach this from the benchmarked workload 
> > > angle first? The highest improvement is in ebizzy:
> > > 
> > > >     ebizzy 2vm (improved 15 times, i.e. 1520%)
> > > 
> > > What's behind this huge speedup? Does ebizzy use user-space 
> > > spinlocks perhaps? Could we do something on the user-space side 
> > > to get a similar speedup?
> > > 
> > This is from the perf run on the host:
> >
> > Baseline:
> >
> > 16.22%         qemu-kvm  [kvm_intel]    [k] free_kvm_area
> >  8.27%         qemu-kvm  [kvm]          [k] start_apic_timer
> >  7.53%         qemu-kvm  [kvm]          [k] kvm_put_guest_fpu
> >
> > Gang:
> >
> > 24.44%         qemu-kvm  [kvm_intel]    [k] free_kvm_area
> > 13.42%         qemu-kvm  [kvm]          [k] start_apic_timer 
> >  9.91%         qemu-kvm  [kvm]          [k] kvm_put_guest_fpu
> >
> > Ingo, Avi, I am not getting anything obvious from this. Any ideas?
> >

Here some interesting perf reports from inside the guest:

Baseline:
  29.79%   ebizzy  [kernel.kallsyms]   [k] native_flush_tlb_others
  18.70%   ebizzy  libc-2.12.so        [.] __GI_memcpy
   7.23%   ebizzy  [kernel.kallsyms]   [k] get_page_from_freelist
   5.38%   ebizzy  [kernel.kallsyms]   [k] __do_page_fault
   4.50%   ebizzy  [kernel.kallsyms]   [k] ____pagevec_lru_add
   3.58%   ebizzy  [kernel.kallsyms]   [k] default_send_IPI_mask_logical
   3.26%   ebizzy  [kernel.kallsyms]   [k] native_flush_tlb_single
   2.82%   ebizzy  [kernel.kallsyms]   [k] handle_pte_fault
   2.16%   ebizzy  [kernel.kallsyms]   [k] kunmap_atomic
   2.10%   ebizzy  [kernel.kallsyms]   [k] _spin_unlock_irqrestore
   1.90%   ebizzy  [kernel.kallsyms]   [k] down_read_trylock
   1.65%   ebizzy  [kernel.kallsyms]   [k] __mem_cgroup_commit_charge.clone.4
   1.60%   ebizzy  [kernel.kallsyms]   [k] up_read
   1.24%   ebizzy  [kernel.kallsyms]   [k] __alloc_pages_nodemask

Gang:
  22.53%   ebizzy  libc-2.12.so       [.] __GI_memcpy
   9.73%   ebizzy  [kernel.kallsyms]  [k] ____pagevec_lru_add
   8.22%   ebizzy  [kernel.kallsyms]  [k] get_page_from_freelist
   7.80%   ebizzy  [kernel.kallsyms]  [k] default_send_IPI_mask_logical
   7.68%   ebizzy  [kernel.kallsyms]  [k] native_flush_tlb_others
   6.22%   ebizzy  [kernel.kallsyms]  [k] __do_page_fault
   5.54%   ebizzy  [kernel.kallsyms]  [k] native_flush_tlb_single
   4.44%   ebizzy  [kernel.kallsyms]  [k] _spin_unlock_irqrestore
   2.90%   ebizzy  [kernel.kallsyms]  [k] kunmap_atomic
   2.78%   ebizzy  [kernel.kallsyms]  [k] __mem_cgroup_commit_charge.clone.4
   2.76%   ebizzy  [kernel.kallsyms]  [k] handle_pte_fault
   2.16%   ebizzy  [kernel.kallsyms]  [k] __mem_cgroup_uncharge_common
   1.59%   ebizzy  [kernel.kallsyms]  [k] down_read_trylock
   1.43%   ebizzy  [kernel.kallsyms]  [k] up_read

I see the main difference between both the reports is:
native_flush_tlb_others.

Regards
Nikunj

