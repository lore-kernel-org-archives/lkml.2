Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2EMLNp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 07:13:45 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39779 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2EMLNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 07:13:44 -0400
Date: Sun, 13 May 2012 13:13:28 +0200
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
Message-ID: <20120513111328.GD28863@aftab.osrc.amd.com>
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
 <1336626013-28413-4-git-send-email-alex.shi@intel.com>
 <20120510084213.GD30055@aftab.osrc.amd.com>
 <4FAB84B6.7060706@intel.com>
 <4FAE18D0.6050001@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAE18D0.6050001@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2012 at 04:01:20PM +0800, Alex Shi wrote:
> I tried this, found too many goto and label is worse than line breaking. :(

I know exactly what you're saying, I just tried it too. It looks pretty
ugly and unreadable.

Maybe you can carve out the meat of the function into another helper,
see below.

Dunno, it kinda looks ok if I haven't fat-fingered all the return paths
and it could use a bunch of comments and maybe even better naming to
explain what happens:

---
static bool __flush_tlb_range(unsigned int cpu, struct mm_struct *mm,
                              unsigned long start, unsigned long end,
                              unsigned long vmflag)
{
        unsigned long addr;
        unsigned long act_entries, tlb_entries = 0;

        if (end == TLB_FLUSH_ALL || tlb_flushall_factor == (u16)TLB_FLUSH_ALL)
                goto flush_out;

        tlb_entries = (vmflag & VM_EXEC ? tlb_lli_4k[ENTRIES]
                                        : tlb_lld_4k[ENTRIES]);

        act_entries = min(mm->total_vm, tlb_entries);

        if ((end - start) >> PAGE_SHIFT > act_entries >> tlb_flushall_factor)
                goto flush_out;

        if (has_large_page(mm, start, end))
                goto flush_out;

        for (addr = start; addr <= end; addr += PAGE_SIZE)
                __flush_tlb_single(addr);

        if (cpumask_any_but(mm_cpumask(mm), cpu) < nr_cpu_ids)
                flush_tlb_others(mm_cpumask(mm), mm, start, end);

        return true;

 flush_out:
        local_flush_tlb();
        return false;
}

void _flush_tlb_range(struct mm_struct *mm, unsigned long start,
                                unsigned long end, unsigned long vmflag)
{
        unsigned int cpu = smp_processor_id();

        preempt_disable();

        if (current->active_mm != mm)
                goto flush_all;

        if (!current->mm) {
                leave_mm(cpu);
                goto flush_all;
        }

        if (__flush_tlb_range(cpu, mm, start, end, vmflag))
                goto out;

 flush_all:
        if (cpumask_any_but(mm_cpumask(mm), cpu) < nr_cpu_ids)
                flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);

 out:
        preempt_enable();
}
--

Oh well, enough games :-).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
