Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab2EJImh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:42:37 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:54170 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472Ab2EJIm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:42:28 -0400
Date: Thu, 10 May 2012 10:42:13 +0200
From: Borislav Petkov <bp@amd64.org>
To: Alex Shi <alex.shi@intel.com>
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, borislav.petkov@amd.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/7] x86/flush_tlb: try flush_tlb_single one by one in
 flush_tlb_range
Message-ID: <20120510084213.GD30055@aftab.osrc.amd.com>
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
 <1336626013-28413-4-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336626013-28413-4-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 01:00:09PM +0800, Alex Shi wrote:
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
> 	(512 - X) * 100ns(assumed TLB refill cost) =
> 		X(TLB flush entries) * 100ns(assumed invlpg cost)
> 
> Here, X is 256, that is 1/2 of 512 entries.
> 
> But with the mysterious CPU pre-fetcher and page miss handler Unit, the
> assumed TLB refill cost is far lower then 100ns in sequential access. And
> 2 HT siblings in one core makes the memory access more faster if they are
> accessing the same memory. So, in the patch, I just do the change when
> the target entries is less than 1/16 of whole active tlb entries.
> Actually, I have no data support for the percentage '1/16', so any
> suggestions are welcomed.
> 
> As to hugetlb, guess due to smaller page table, and smaller active TLB
> entries, I didn't see benefit via my benchmark, so no optimizing now.
> 
> My macro benchmark show in ideal scenarios, the performance improves 70
> percent in reading. And in worst scenario, the reading/writing
> performance is similar with unpatched 3.4-rc4 kernel.
> 
> Here is the reading data on my 2P * 4cores *HT NHM EP machine, with THP
> 'always':
> 
> multi thread testing, '-t' paramter is thread number:
> 	       	        with patch   unpatched 3.4-rc4
> ./mprotect -t 1           14ns		24ns
> ./mprotect -t 2           13ns		22ns
> ./mprotect -t 4           12ns		19ns
> ./mprotect -t 8           14ns		16ns
> ./mprotect -t 16          28ns		26ns
> ./mprotect -t 32          54ns		51ns
> ./mprotect -t 128         200ns		199ns
> 
> Single process with sequencial flushing and memory accessing:
> 
> 		       	with patch   unpatched 3.4-rc4
> ./mprotect		    7ns			11ns
> ./mprotect -p 4096  -l 8 -n 10240
> 			    21ns		21ns
> 
> I also tried other benchmarks on Intel core2/NHM/SNB EP and NHM EX machine.
> No clear performance change on specjbb2005 with openjdk, and oltp reading.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>

[ … ]

> +
> +#define FLUSHALL_BAR	16
> +

Btw, you can save a bunch of indenting on this function, let me add
the final version here from the whole patchset so I can comment on it
easier:

> void __flush_tlb_range(struct mm_struct *mm, unsigned long start,
>                                 unsigned long end, unsigned long vmflag)
> {
>         preempt_disable();
>         if (current->active_mm == mm) {

	if (current->active_mm != mm)
		goto flush_all;

Now this whole piece below can move one indentation level to the left.

Then you can do:

	if (!current->mm)
		goto leave;

and add the "leave" label below.

Now you're saving yet another indentation level, bringing the meat of
the function at 1st indentation level, which is cool and gives you much
more room so that you don't have to linebreak longer statements.

>                 if (current->mm) {
>                         unsigned long addr;
>                         unsigned long act_entries, tlb_entries = 0;
> 
>                         if (end == TLB_FLUSH_ALL ||
>                                 tlb_flushall_factor == (u16)TLB_FLUSH_ALL) {
>                                 local_flush_tlb();
>                                 goto flush_all;
>                         }
>                         if (vmflag & VM_EXEC)
>                                 tlb_entries = tlb_lli_4k[ENTRIES];
>                         else
>                                 tlb_entries = tlb_lld_4k[ENTRIES];
>                         act_entries = min(mm->total_vm, tlb_entries);
> 
>                         if ((end - start) >> PAGE_SHIFT >
>                                         act_entries >> tlb_flushall_factor)
>                                 local_flush_tlb();
>                         else {
>                                 if (has_large_page(mm, start, end)) {
>                                         local_flush_tlb();
>                                         goto flush_all;
>                                 }
>                                 for (addr = start; addr <= end;
>                                                 addr += PAGE_SIZE)
>                                         __flush_tlb_single(addr);
> 
>                                 if (cpumask_any_but(mm_cpumask(mm),
>                                         smp_processor_id()) < nr_cpu_ids)
>                                         flush_tlb_others(mm_cpumask(mm), mm,
>                                                                 start, end);
>                                 preempt_enable();
>                                 return;
>                         }
>                 } else {
>                         leave_mm(smp_processor_id());
>                 }
>         }

 leave:
	leave_mm(smp_processor_id());

> flush_all:
>         if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
>                 flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
>         preempt_enable();
> }

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
