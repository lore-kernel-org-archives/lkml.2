Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab2EJHxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:53:41 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:54013 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068Ab2EJHxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:53:40 -0400
Date: Thu, 10 May 2012 09:53:25 +0200
From: Borislav Petkov <bp@amd64.org>
To: Alex Shi <alex.shi@intel.com>
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, riel@redhat.com,
        luto@mit.edu, avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/7] x86/flush_tlb: try flush_tlb_single one by one in
 flush_tlb_range
Message-ID: <20120510075325.GB30055@aftab.osrc.amd.com>
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
> ---

[ … ]

> +#define FLUSHALL_BAR	16
> +
> +void flush_tlb_range(struct vm_area_struct *vma,
> +				   unsigned long start, unsigned long end)
> +{
> +	struct mm_struct *mm;
> +
> +	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB) {
> +		flush_tlb_mm(vma->vm_mm);
> +		return;
> +	}
> +
> +	preempt_disable();
> +	mm = vma->vm_mm;
> +	if (current->active_mm == mm) {
> +		if (current->mm) {
> +			unsigned long addr, vmflag = vma->vm_flags;
> +			unsigned act_entries, tlb_entries = 0;
> +
> +			if (vmflag & VM_EXEC)
> +				tlb_entries = tlb_lli_4k[ENTRIES];
> +			else
> +				tlb_entries = tlb_lld_4k[ENTRIES];
> +
> +			act_entries = tlb_entries > mm->total_vm ?
> +					mm->total_vm : tlb_entries;

Ok, question:

we're comparing TLB size with the amount of pages mapped by this mm
struct. AFAICT, that doesn't mean that all those mapped pages do have
respective entries in the TLB, does it?

If so, then the actual entries number is kinda inaccurate, no? We don't
really know how many TLB entries actually belong to this mm struct. Or am I
missing something?

> +			if ((end - start)/PAGE_SIZE > act_entries/FLUSHALL_BAR)

Oh, in a later patch you do this:

+                       if ((end - start) >> PAGE_SHIFT >
+                                       act_entries >> tlb_flushall_factor)

and the tlb_flushall_factor factor is 5 or 6 but the division by 16
(FLUSHALL_BAR) was a >> 4. So, is this to assume that it is not 16 but
actually more than 32 or even 64 TLB entries where a full TLB flush
makes sense and one-by-one if less?

> +				local_flush_tlb();
> +			else {
> +				for (addr = start; addr <= end;
> +						addr += PAGE_SIZE)
> +					__flush_tlb_single(addr);
> +
> +				if (cpumask_any_but(mm_cpumask(mm),
> +					smp_processor_id()) < nr_cpu_ids)
> +					flush_tlb_others(mm_cpumask(mm), mm,
> +								start, end);
> +				preempt_enable();
> +				return;
> +			}
> +		} else {
> +			leave_mm(smp_processor_id());
> +		}
> +	}
> +	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
> +		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
>  	preempt_enable();

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
