Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab2EYOXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 10:23:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46857 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab2EYOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 10:23:48 -0400
Subject: Re: [PATCH] x86/tlb: replace INVALIDATE_TLB_VECTOR by
 CALL_FUNCTION_VECTOR
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        seto.hidetoshi@jp.fujitsu.com, borislav.petkov@amd.com,
        tony.luck@intel.com, luto@mit.edu, jbeulich@suse.com,
        rostedt@goodmis.org, ak@linux.intel.com, akpm@linux-foundation.org,
        eric.dumazet@gmail.com, akinobu.mita@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <4FB7004B.4010806@intel.com>
References: <1337353963-8294-1-git-send-email-alex.shi@intel.com>
	 <4FB7004B.4010806@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 16:23:41 +0200
Message-ID: <1337955821.9783.208.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-19 at 10:07 +0800, Alex Shi wrote:
>  
>  /*
> - *
> - * The flush IPI assumes that a thread switch happens in this order:
> - * [cpu0: the cpu that switches]
> - * 1) switch_mm() either 1a) or 1b)
> - * 1a) thread switch to a different mm
> - * 1a1) cpu_clear(cpu, old_mm->cpu_vm_mask);
> - *     Stop ipi delivery for the old mm. This is not synchronized with
> - *     the other cpus, but smp_invalidate_interrupt ignore flush ipis
> - *     for the wrong mm, and in the worst case we perform a superfluous
> - *     tlb flush.
> - * 1a2) set cpu mmu_state to TLBSTATE_OK
> - *     Now the smp_invalidate_interrupt won't call leave_mm if cpu0
> - *     was in lazy tlb mode.
> - * 1a3) update cpu active_mm
> - *     Now cpu0 accepts tlb flushes for the new mm.
> - * 1a4) cpu_set(cpu, new_mm->cpu_vm_mask);
> - *     Now the other cpus will send tlb flush ipis.
> - * 1a4) change cr3.
> - * 1b) thread switch without mm change
> - *     cpu active_mm is correct, cpu0 already handles
> - *     flush ipis.
> - * 1b1) set cpu mmu_state to TLBSTATE_OK
> - * 1b2) test_and_set the cpu bit in cpu_vm_mask.
> - *     Atomically set the bit [other cpus will start sending flush ipis],
> - *     and test the bit.
> - * 1b3) if the bit was 0: leave_mm was called, flush the tlb.
> - * 2) switch %%esp, ie current
> - *
> - * The interrupt must handle 2 special cases:
> - * - cr3 is changed before %%esp, ie. it cannot use current->{active_,}mm.
> - * - the cpu performs speculative tlb reads, i.e. even if the cpu only
> - *   runs in kernel space, the cpu could load tlb entries for user space
> - *   pages.
> - *
> - * The good news is that cpu mmu_state is local to each cpu, no
> - * write/read ordering problems.
> - */ 

It would be nice to update that comment instead of removing it.

