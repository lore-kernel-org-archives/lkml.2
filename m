Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab0HYI2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 04:28:39 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51389 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0HYI2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 04:28:34 -0400
Message-ID: <4C74D420.10505@canonical.com>
Date: Wed, 25 Aug 2010 10:28:16 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Ian Campbell <ijc@hellion.org.uk>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [RFC] mlock/stack guard interaction fixup
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>	<1282391770.29609.1223.camel@localhost.localdomain>	<AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>	<1282460275.11348.865.camel@localhost.localdomain>	<1282462386.11348.871.camel@localhost.localdomain>	<1282470917.11348.891.camel@localhost.localdomain> <20100822172548.GB8957@suse.de>
In-Reply-To: <20100822172548.GB8957@suse.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2010 07:25 PM, Greg KH wrote:
> On Sun, Aug 22, 2010 at 10:55:17AM +0100, Ian Campbell wrote:
>> On Sun, 2010-08-22 at 08:33 +0100, Ian Campbell wrote:
>>> On Sun, 2010-08-22 at 07:57 +0100, Ian Campbell wrote:
>>>> On Sat, 2010-08-21 at 08:48 -0700, Linus Torvalds wrote:
>>>>> On Sat, Aug 21, 2010 at 4:56 AM, Ian Campbell <ijc@hellion.org.uk> wrote:
>>>>>>
>>>>>> I don't know that they are particularly good tests for this change but I
>>>>>> also ran allmodconfig kernel build and ltp on 2.6.35.3+fixes without
>>>>>> issue. Are there any good mlock heavy workloads?
>>>>>
>>>>> mlock itself isn't very interesting, I think more interesting is
>>>>> testing that the doubly linked list handles all the cases correctly.
>>>>> Something that splits mappings, unmaps partial ones etc etc. Running
>>>>> something like Electric Fence is probably a good idea.
>>>>
>>>> EF_DISABLE_BANNER=1 EF_ALLOW_MALLOC_0=1 LD_PRELOAD=libefence.so.0.0 make
>>>>
>>>> craps out pretty quickly with:
>>>>
>>>>           CC      init/main.o
>>>>         
>>>>         ElectricFence Exiting: mprotect() failed: Cannot allocate memory
>>>>         make[1]: *** [init/main.o] Error 255
>>>>         make: *** [init] Error 2
>>>>
>>>> but it does that with 2.6.35.3, 2.6.35.2, 2.6.35.1 and 2.6.35 too so it
>>>> doesn't seem to be breakage relating to any of the stack guard stuff
>>>
>>> I increased the vm.max_map_count sysctl and now things are rolling
>>> along. Will let you know how I get on.
>>
>> So its slow and memory intensive as hell due to efence so my test box is
>> struggling[0] but it has compiled 270+ .o files successfully so I think
>> it's OK from that perspective. I think it'll be quite a while before I
>> can say its passed an allmodconfig under efence though.
>>
>> In the meantime I notice you've committed the patches. Can we get them
>> queued up for stable backports at some point? I appreciate you might
>> want them to bake for a bit longer in 2.6.36-rc first.
>>
>> Greg, we are talking about:
>> 0e8e50e20c837eeec8323bba7dcd25fe5479194c mm: make stack guard page logic use vm_prev pointer
>> 7798330ac8114c731cfab83e634c6ecedaa233d7 mm: make the mlock() stack guard page checks stricter
>> 297c5eee372478fc32fec5fe8eed711eedb13f3d mm: make the vma list be doubly linked
> 
> I must be missing something, but aren't these patches just "cleanups"
> and changing the logic here to be nicer?  Or do they fix real problems
> with the previous stack guard stuff?
> 
> Is it the second one you really need here?
> 

Ok, I saw Greg picking up the new batch which is good as I think the old logic
to expand the stack could give incorrect false positives when being called with
an addr above the lowest stack vma.

There seems only one little piece left. The proc output would likely look like
there are holes in the stack vma. Something like below should fix it. And maybe
then the two checking functions might move to a common header (as the code is
shamelessly borrowed from mlock). Ok, in the case here the addr == vma->vm_addr
check is always true.

-Stefan

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 439fc1f..2e67dac 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -203,6 +203,21 @@ static int do_maps_open(struct inode *inode, struct file *f
        return ret;
 }

+/* Is the vma a continuation of the stack vma above it? */
+static inline int vma_stack_continue(struct vm_area_struct *vma,
+       unsigned long addr)
+{
+       return vma && (vma->vm_end == addr) && (vma->vm_flags & VM_GROWSDOWN);
+}
+
+static inline int stack_guard_page(struct vm_area_struct *vma,
+       unsigned long addr)
+{
+       return (vma->vm_flags & VM_GROWSDOWN) &&
+               (vma->vm_start == addr) &&
+               !vma_stack_continue(vma->vm_prev, addr);
+}
+
 static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 {
        struct mm_struct *mm = vma->vm_mm;
@@ -223,7 +238,7 @@ static void show_map_vma(struct seq_file *m, struct vm_area_

        /* We don't show the stack guard page in /proc/maps */
        start = vma->vm_start;
-       if (vma->vm_flags & VM_GROWSDOWN)
+       if (stack_guard_page(vma, start)
                start += PAGE_SIZE;

        seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",

> thanks,
> 
> greg k-h
> 
> _______________________________________________
> Stable-review mailing list
> Stable-review@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable-review

