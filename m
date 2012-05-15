Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab2EOBHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:07:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:28814 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757560Ab2EOBHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:07:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="140645745"
Message-ID: <4FB1AC03.2070407@intel.com>
Date: Tue, 15 May 2012 09:06:11 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
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
Subject: Re: [PATCH v4 3/7] x86/flush_tlb: try flush_tlb_single one by one
 in flush_tlb_range
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com> <1336626013-28413-4-git-send-email-alex.shi@intel.com> <20120510084213.GD30055@aftab.osrc.amd.com> <4FAB84B6.7060706@intel.com> <4FAE18D0.6050001@intel.com> <20120513111328.GD28863@aftab.osrc.amd.com>
In-Reply-To: <20120513111328.GD28863@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> --
> 
> Oh well, enough games :-).
> 




Thanks for your input. but actually, total 3 labels doesn't looks good.
Maybe the following lines can meet your expectation.

---
void __flush_tlb_range(struct mm_struct *mm, unsigned long start,
				unsigned long end, unsigned long vmflag)
{
	unsigned long addr;
	unsigned act_entries, tlb_entries = 0;

	preempt_disable();
	if (current->active_mm != mm)
		goto flush_all;

	if (!current->mm) {
		leave_mm(smp_processor_id());
		goto flush_all;
	}

	if (end == TLB_FLUSH_ALL ||
			tlb_flushall_shift == (u16)TLB_FLUSH_ALL) {
		local_flush_tlb();
		goto flush_all;
	}

	if (vmflag & VM_EXEC)
		tlb_entries = tlb_lli_4k[ENTRIES];
	else
		tlb_entries = tlb_lld_4k[ENTRIES];
	act_entries = mm->total_vm > tlb_entries ? tlb_entries : mm->total_vm;

	if ((end - start) >> PAGE_SHIFT > act_entries >> tlb_flushall_shift)
		local_flush_tlb();
	else {
		if (has_large_page(mm, start, end)) {
			local_flush_tlb();
			goto flush_all;
		}
		for (addr = start; addr <= end;	addr += PAGE_SIZE)
			__flush_tlb_single(addr);

		if (cpumask_any_but(mm_cpumask(mm),
				smp_processor_id()) < nr_cpu_ids)
			flush_tlb_others(mm_cpumask(mm), mm, start, end);
		preempt_enable();
		return;
	}

flush_all:
	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
	preempt_enable();
}


