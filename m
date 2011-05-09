Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1EILol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 07:44:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab1EILoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 07:44:39 -0400
Message-ID: <4DC7D37F.9040308@redhat.com>
Date: Mon, 09 May 2011 13:43:59 +0200
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc16 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>,
        agk@redhat.com
Subject: Re: [PATCH] Don't mlock guardpage if the stack is growing up
References: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz> <BANLkTikEpaRZK3X4YReeQAwgcv3HAGUwSw@mail.gmail.com> <alpine.DEB.2.00.1105091246550.32299@artax.karlin.mff.cuni.cz>
In-Reply-To: <alpine.DEB.2.00.1105091246550.32299@artax.karlin.mff.cuni.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 9.5.2011 13:01, Mikulas Patocka napsal(a):
> 
> 
> On Sun, 8 May 2011, Linus Torvalds wrote:
> 
>> On Sun, May 8, 2011 at 11:55 AM, Mikulas Patocka
>> <mikulas@artax.karlin.mff.cuni.cz> wrote:
>>>
>>> This patch fixes lvm2 on PA-RISC (and possibly other architectures with
>>> up-growing stack). lvm2 calculates the number of used pages when locking
>>> and when unlocking and reports an internal error if the numbers mismatch.
>>
>> This patch won't apply on current kernels (including stable) because
>> of commit a1fde08c74e9 that changed the test of "pages" to instead
>> just test "flags & FOLL_MLOCK".
>>
>> That should be trivial to fix up.
>>
>> However, I really don't much like this complex test:
>>
>>>  static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long addr)
>>>  {
>>> -       return (vma->vm_flags & VM_GROWSDOWN) &&
>>> +       return ((vma->vm_flags & VM_GROWSDOWN) &&
>>>                (vma->vm_start == addr) &&
>>> -               !vma_stack_continue(vma->vm_prev, addr);
>>> +               !vma_stack_continue(vma->vm_prev, addr)) ||
>>> +              ((vma->vm_flags & VM_GROWSUP) &&
>>> +               (vma->vm_end == addr + PAGE_SIZE) &&
>>> +               !vma_stack_growsup_continue(vma->vm_next, addr + PAGE_SIZE));
>>>  }
>>
>> in that format. It gets really hard to read, and I think you'd be
>> better off writing it as two helper functions (or macros) for the two
>> cases, and then have
>>
>>   static inline int stack_guard_page(struct vm_area_struct *vma,
>> unsigned long addr)
>>   {
>>     return stack_guard_page_growsdown(vma, addr) ||
>>       stack_guard_page_growsup(vma, addr);
>>   }
>>
>> I'd also like to verify that it doesn't actually generate any extra
>> code for the common case (iirc VM_GROWSUP is 0 for the architectures
>> that don't need it, and so the compiler shouldn't generate any extra
>> code, but I'd like that mentioned and verified explicitly).
>>
>> Hmm?
>>
>> Other than that it looks ok to me.
>>
>> That said, could we please fix LVM to not do that crazy sh*t in the
>> first place? The STACK_GROWSUP case is never going to have a lot of
>> testing, this is just sad.
> 
> LVM reads process maps from /proc/self/maps and locks them with mlock.
> 
> Why it doesn't use mlockall()? Because glibc maps all locales to the 
> process. Glibc packs all locales to a 100MB file and maps that file to 
> every process. Even if the process uses just one locale, glibc maps all.
> 
> So, when LVM used mlockall, it consumed >100MB memory and it caused 
> out-of-memory problems in system installers.
> 
> So, alternate way of locking was added to LVM --- read all maps and lock 
> them, except for the glibc locale file.
> 
> The real fix would be to fix glibc not to map 100MB to every process.
> 

I should add here probably few words.

Glibc knows few more ways around - so it could work only with one locale file
per language, or even without using mmap and allocating them in memory.
Depends on the distribution usually - Fedora decided to combine all locales
into one huge file (>100MB) - Ubuntu/Debian mmaps each locales individually
(usually ~MB)

LVM support both ways - either user may select in lvm.conf to always use
mlockall, or he may switch to use mlock mapping of individual memory areas
where those memory parts, that cannot be executed during suspend state and
cannot cause memory deadlock, are not locked into memory. As a 'bonus' it's
internally used for tracking algorithmic bugs.

Zdenek
