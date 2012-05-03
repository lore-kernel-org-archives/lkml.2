Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2ECL04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 07:26:56 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:53789 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2ECL0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 07:26:53 -0400
Message-ID: <4FA26B6E.408@linux.vnet.ibm.com>
Date: Thu, 03 May 2012 19:26:38 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
References: <4F9776D2.7020506@linux.vnet.ibm.com> <4F9777A4.208@linux.vnet.ibm.com> <20120426234535.GA5057@amt.cnet> <4F9A3445.2060305@linux.vnet.ibm.com> <20120427145213.GB28796@amt.cnet> <4F9B89D9.9060307@linux.vnet.ibm.com> <20120501013459.GB10142@amt.cnet> <4FA0C607.5010002@linux.vnet.ibm.com> <20120502210701.GA12604@amt.cnet>
In-Reply-To: <20120502210701.GA12604@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12050311-4790-0000-0000-0000027468FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 05:07 AM, Marcelo Tosatti wrote:


>> 'entry' is not a problem since it is from atomically read-write as
>> mentioned above, i need change this code to:
>>
>> 		/*
>> 		 * Optimization: for pte sync, if spte was writable the hash
>> 		 * lookup is unnecessary (and expensive). Write protection
>> 		 * is responsibility of mmu_get_page / kvm_sync_page.
>> 		 * Same reasoning can be applied to dirty page accounting.
>> 		 */
>> 		if (!can_unsync && is_writable_pte(entry) /* Use 'entry' instead of '*sptep'. */
>> 			goto set_pte
>>    ......
>>
>>
>>          if (is_writable_pte(entry) && !is_writable_pte(spte)) /* Use 'spte' instead of '*sptep'. */
>>                  kvm_flush_remote_tlbs(vcpu->kvm);
> 
> What is of more importance than the ability to verify that this or that
> particular case are ok at the moment is to write code in such a way that
> its easy to verify that it is correct.
> 
> Thus the suggestion above:
> 
> "scattered all over (as mentioned before, i think a pattern of read spte
> once, work on top of that, atomically write and then deal with results
> _everywhere_ (where mmu lock is held) is more consistent."
> 


Marcelo, thanks for your time to patiently review/reply my mail.

I am confused with ' _everywhere_ ', it means all of the path read/update
spte? why not only verify the path which depends on is_writable_pte()?

For the reason of "its easy to verify that it is correct"? But these
paths are safe since it is not care PT_WRITABLE_MASK at all. What these
paths care is the Dirty-bit and Accessed-bit are not lost, that is why
we always treat the spte as "volatile" if it is can be updated out of
mmu-lock.

For the further development? We can add the delta comment for
is_writable_pte() to warn the developer use it more carefully.

It is also very hard to verify spte everywhere. :(

Actually, the current code to care PT_WRITABLE_MASK is just for
tlb flush, may be we can fold it into mmu_spte_update.
[
  There are tree ways to modify spte, present -> nonpresent, nonpresent -> present,
  present -> present.

  But we only need care present -> present for lockless.
]

/*
 * return true means we need flush tlbs caused by changing spte from writeable
 * to read-only.
 */
bool mmu_update_spte(u64 *sptep, u64 spte)
{
	u64 last_spte, old_spte = *sptep;
	bool flush = false;

	last_spte = xchg(sptep, spte);

	if ((is_writable_pte(last_spte) ||
	      spte_has_updated_lockless(old_spte, last_spte)) &&
	         !is_writable_pte(spte) )
		flush = true;

	.... track Drity/Accessed bit ...


	return flush		
}

Furthermore, the style of "if (spte-has-changed) goto beginning" is feasible
in set_spte since this path is a fast path. (i can speed up mmu_need_write_protect)


