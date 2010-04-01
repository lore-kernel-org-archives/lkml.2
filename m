Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab0DAQDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:03:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756697Ab0DAQDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:03:47 -0400
Message-ID: <4BB4C3AB.1060100@redhat.com>
Date: Thu, 01 Apr 2010 19:02:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in mmu_take_all_locks()
References: <1270117906.1653.139.camel@laptop> <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain> <4BB47FC3.1020606@redhat.com> <1270120592.1653.192.camel@laptop> <20100401153645.GP5825@random.random> <4BB4BE44.5070507@redhat.com> <20100401155456.GR5825@random.random>
In-Reply-To: <20100401155456.GR5825@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 06:54 PM, Andrea Arcangeli wrote:
>
>>> The only single reason I'd go for mutexes would be to accommodate
>>> XPMEM requirements once and for all, no other reason.
>>>
>>>        
>> There is also a minor benefit for kvm.  Reduced latency over large mmu
>> operations; code simplification (we now have some
>> copy_from_user_inatomic() that could be simplified).
>>      
> Where exactly is KVM taking these locks?

Not these locks, but if we go all the way and make mmu notifiers 
sleepable, we can convert mmu_lock to a mutex.

> KVM should only call into
> GUP, and GUP itself won't iterate over rmaps either. GUP just walks
> the host pagetables and trigger page faults if the pages aren't
> mapped.

We'll probably deadlock then, gup -> change_pte notifier -> mmu_lock.  
But we can probably work around it.

> I don't see how you're going to remove
> copy_from_user_inatomic() given we don't have vmas and other metadata
> to take those locks. Maybe we can stop calling GUP but even if we take
> the anon_vma mutex/semaphore I think it won't still prevent munmap to
> drop the anon pages from under us (even if it'd stop the VM to unmap
> them through rmap). To freeze the mapping one would need to take
> mmap_sem in write mode in addition to the anon_vma mutex/sem which is
> unlikely a win compared to just gup+copy_from_user_inatomic. So I
> don't see immediate benefits for KVM but maybe I'm missing something
> of course!
>    

I meant replace c_f_u_inatomic() by c_f_u() (that's why the benefit is 
minor - we only simplify the failure path).  Sorry for being unclear.


-- 
error compiling committee.c: too many arguments to function

