Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab2EBF2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 01:28:49 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:43252 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab2EBF2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 01:28:47 -0400
Message-ID: <4FA0C607.5010002@linux.vnet.ibm.com>
Date: Wed, 02 May 2012 13:28:39 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
References: <4F9776D2.7020506@linux.vnet.ibm.com> <4F9777A4.208@linux.vnet.ibm.com> <20120426234535.GA5057@amt.cnet> <4F9A3445.2060305@linux.vnet.ibm.com> <20120427145213.GB28796@amt.cnet> <4F9B89D9.9060307@linux.vnet.ibm.com> <20120501013459.GB10142@amt.cnet>
In-Reply-To: <20120501013459.GB10142@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12050205-5816-0000-0000-0000025EF3CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 09:34 AM, Marcelo Tosatti wrote:


> 
> It is getting better, but not yet, there are still reads of sptep
> scattered all over (as mentioned before, i think a pattern of read spte
> once, work on top of that, atomically write and then deal with results
> _everywhere_ (where mmu lock is held) is more consistent.
> 


But we only need care the path which depends on is_writable_pte(), no?

So, where call is_writable_pte() are spte_has_volatile_bits(),
spte_write_protect() and set_spte().

I have changed these functions:
In spte_has_volatile_bits():
 static bool spte_has_volatile_bits(u64 spte)
 {
+	/*
+	 * Always atomicly update spte if it can be updated
+	 * out of mmu-lock.
+	 */
+	if (spte_can_lockless_update(spte))
+		return true;
+

In spte_write_protect():

+	spte = mmu_spte_update(sptep, spte);
+
+	if (is_writable_pte(spte))
+		*flush |= true;
+
The 'spte' is from atomically read-write (xchg).

in set_spte():
 set_pte:
-	mmu_spte_update(sptep, spte);
+	entry = mmu_spte_update(sptep, spte);
 	/*
 	 * If we overwrite a writable spte with a read-only one we
 	 * should flush remote TLBs. Otherwise rmap_write_protect
The 'entry' is also the latest value.

>         /*
>          * If we overwrite a writable spte with a read-only one we
>          * should flush remote TLBs. Otherwise rmap_write_protect
>          * will find a read-only spte, even though the writable spte
>          * might be cached on a CPU's TLB.
>          */
>         if (is_writable_pte(entry) && !is_writable_pte(*sptep))
>                 kvm_flush_remote_tlbs(vcpu->kvm);
> 
> This is inconsistent with the above obviously.
> 


'entry' is not a problem since it is from atomically read-write as
mentioned above, i need change this code to:

		/*
		 * Optimization: for pte sync, if spte was writable the hash
		 * lookup is unnecessary (and expensive). Write protection
		 * is responsibility of mmu_get_page / kvm_sync_page.
		 * Same reasoning can be applied to dirty page accounting.
		 */
		if (!can_unsync && is_writable_pte(entry) /* Use 'entry' instead of '*sptep'. */
			goto set_pte
   ......


         if (is_writable_pte(entry) && !is_writable_pte(spte)) /* Use 'spte' instead of '*sptep'. */
                 kvm_flush_remote_tlbs(vcpu->kvm);

