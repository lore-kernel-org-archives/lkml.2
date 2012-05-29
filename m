Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2E2Hpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:45:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:53580 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab2E2Hpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:45:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158113845"
Message-ID: <4FC47DFE.8020004@intel.com>
Date: Tue, 29 May 2012 15:42:54 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        seto.hidetoshi@jp.fujitsu.com, borislav.petkov@amd.com,
        tony.luck@intel.com, luto@mit.edu, jbeulich@suse.com,
        rostedt@goodmis.org, ak@linux.intel.com, akpm@linux-foundation.org,
        eric.dumazet@gmail.com, akinobu.mita@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/tlb: replace INVALIDATE_TLB_VECTOR by CALL_FUNCTION_VECTOR
References: <1337353963-8294-1-git-send-email-alex.shi@intel.com>  <4FB7004B.4010806@intel.com> <1337955821.9783.208.camel@laptop>
In-Reply-To: <1337955821.9783.208.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 10:23 PM, Peter Zijlstra wrote:

> On Sat, 2012-05-19 at 10:07 +0800, Alex Shi wrote:
>>  
>>  /*
>> - *
>> - * The flush IPI assumes that a thread switch happens in this order:
>> - * [cpu0: the cpu that switches]
>> - * 1) switch_mm() either 1a) or 1b)
>> - * 1a) thread switch to a different mm
>> - * 1a1) cpu_clear(cpu, old_mm->cpu_vm_mask);
>> - *     Stop ipi delivery for the old mm. This is not synchronized with
>> - *     the other cpus, but smp_invalidate_interrupt ignore flush ipis
>> - *     for the wrong mm, and in the worst case we perform a superfluous
>> - *     tlb flush.
>> - * 1a2) set cpu mmu_state to TLBSTATE_OK
>> - *     Now the smp_invalidate_interrupt won't call leave_mm if cpu0
>> - *     was in lazy tlb mode.
>> - * 1a3) update cpu active_mm
>> - *     Now cpu0 accepts tlb flushes for the new mm.
>> - * 1a4) cpu_set(cpu, new_mm->cpu_vm_mask);
>> - *     Now the other cpus will send tlb flush ipis.
>> - * 1a4) change cr3.
>> - * 1b) thread switch without mm change
>> - *     cpu active_mm is correct, cpu0 already handles
>> - *     flush ipis.
>> - * 1b1) set cpu mmu_state to TLBSTATE_OK
>> - * 1b2) test_and_set the cpu bit in cpu_vm_mask.
>> - *     Atomically set the bit [other cpus will start sending flush ipis],
>> - *     and test the bit.
>> - * 1b3) if the bit was 0: leave_mm was called, flush the tlb.
>> - * 2) switch %%esp, ie current
>> - *
>> - * The interrupt must handle 2 special cases:
>> - * - cr3 is changed before %%esp, ie. it cannot use current->{active_,}mm.
>> - * - the cpu performs speculative tlb reads, i.e. even if the cpu only
>> - *   runs in kernel space, the cpu could load tlb entries for user space
>> - *   pages.
>> - *
>> - * The good news is that cpu mmu_state is local to each cpu, no
>> - * write/read ordering problems.
>> - */ 
> 
> It would be nice to update that comment instead of removing it.
> 



How about the following new comments? I changed them to match latest
switch_mm and tlbflush code.
but as to the 'The interrupt must handle 2 special cases' section, I am
wondering if it should be kept, since current tlb flush IPI handler
don't need %%esp at all.

Comments welcome!

-------
/*
 * The flush IPI assumes that a thread switch happens in this order:
 * [cpu0: the cpu that switches]
 * 1) switch_mm() either 1a) or 1b)
 * 1a) thread switch to a different mm
 * 1a1) set cpu_tlbstate to TLBSTATE_OK
 *	Now the tlb flush IPI handler flush_tlb_func won't call leave_mm
 *	if cpu0 was in lazy tlb mode.
 * 1a2) update cpu active_mm
 *	Now cpu0 accepts tlb flushes for the new mm.
 * 1a3) cpu_set(cpu, new_mm->cpu_vm_mask);
 *	Now the other cpus will send tlb flush ipis.
 * 1a4) change cr3.
 * 1a5) cpu_clear(cpu, old_mm->cpu_vm_mask);
 *	Stop ipi delivery for the old mm. This is not synchronized with
 *	the other cpus, but flush_tlb_func ignore flush ipis for the wrong
 *	mm, and in the worst case we perform a superfluous tlb flush.
 * 1b) thread switch without mm change
 *	cpu active_mm is correct, cpu0 already handles
 *	flush ipis.
 * 1b1) set cpu_tlbstate to TLBSTATE_OK
 * 1b2) test_and_set the cpu bit in cpu_vm_mask.
 *	Atomically set the bit [other cpus will start sending flush ipis],
 *	and test the bit.
 * 1b3) if the bit was 0: leave_mm was called, flush the tlb.
 * 2) switch %%esp, ie current
 *
 * The interrupt must handle 2 special cases:
 * - cr3 is changed before %%esp, ie. it cannot use current->{active_,}mm.
 * - the cpu performs speculative tlb reads, i.e. even if the cpu only
 *   runs in kernel space, the cpu could load tlb entries for user space
 *   pages.
 *
 * The good news is that cpu_tlbstate is local to each cpu, no
 * write/read ordering problems.
 */



