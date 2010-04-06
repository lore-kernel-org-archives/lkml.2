Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab0DFUvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 16:51:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52227 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab0DFUva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 16:51:30 -0400
Date: Tue, 6 Apr 2010 22:51:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
Message-ID: <20100406205123.GC20357@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
References: <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>
 <1270571019.1814.163.camel@barrios-desktop>
 <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org>
 <1270572327.1711.3.camel@barrios-desktop>
 <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
 <4BBB69A9.5090906@redhat.com>
 <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
 <20100406120315.53ad7390.akpm@linux-foundation.org>
 <20100406194238.GB20357@a1.tnic>
 <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, Apr 06, 2010 at 01:02:35PM -0700

> So again, I can show that the code has never actually been through the 
> loop. The above code decodes to:
> 
>    0:	3b 56 10             	cmp    0x10(%rsi),%edx
>    3:	73 1e                	jae    0x23
>    5:	48 83 fa f2          	cmp    $0xfffffffffffffff2,%rdx
>    9:	74 18                	je     0x23
>    b:	48 8d 4d cc          	lea    -0x34(%rbp),%rcx
>    f:	4d 89 f8             	mov    %r15,%r8
>   12:	48 89 df             	mov    %rbx,%rdi
>   15:	e8 4d f2 ff ff       	callq  0xfffffffffffff267
>   1a:	41 01 c4             	add    %eax,%r12d
>   1d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
>   21:	74 19                	je     0x3c
>   23:	4d 8b 6d 20          	mov    0x20(%r13),%r13
>   27:	49 83 ed 20          	sub    $0x20,%r13
>   2b:*	49 8b 45 20          	mov    0x20(%r13),%rax     <-- trapping instruction
>   2f:	0f 18 08             	prefetcht0 (%rax)
>   32:	49 8d 45 20          	lea    0x20(%r13),%rax
>   36:	48 39 45 80          	cmp    %rax,-0x80(%rbp)
>   3a:	75 aa                	jne    0xffffffffffffffe6
>   3c:	4c 89 f7             	mov    %r14,%rdi
>   3f:	e8                   	.byte 0xe8
> 
> and in your case, if we had gone through the loop, then %rax would still 
> contain the return value from page_referenced_one(). 
> 
> But %rax is a kernel pointer, and %r12d is 0.
> 
> So again, it's actually anon_vma.head.next that is NULL, not any of the 
> entries on the list itself.
> 
> Now, I can see several cases for this:
> 
>  - the obvious one: anon_vma just wasn't correctly initialized, and is 
>    missing a INIT_LIST_HEAD(&anon_vma->head). That's either a slab bug (we 
>    don't have a whole lot of coverage of constructors), or somebody 
>    allocated an anon_vma without using the anon_vma_cachep.

I've added code to verify this and am suspend/resuming now... Wait a
minute, Linus, you're good! :) :

[  873.083074] PM: Preallocating image memory... 
[  873.254359] NULL anon_vma->head.next, page 2182681

This is the page_to_pfn number.

Now, how do we track back to the place which is missing anon_vma->head
init? Can we use the struct page *page arg to page_referenced_anon()
somehow?

[  873.254654] Pid: 3642, comm: hib.sh Not tainted 2.6.34-rc3-00288-gab195c5-dirty #3
[  873.254904] Call Trace:
[  873.255063]  [<ffffffff810c0c28>] page_referenced+0xd3/0x219
[  873.255212]  [<ffffffff810c5fb0>] ? swapcache_free+0x37/0x3c
[  873.255364]  [<ffffffff810ab782>] shrink_page_list+0x14a/0x477
[  873.255512]  [<ffffffff810aa6e0>] ? isolate_pages_global+0xc4/0x1f0
[  873.255662]  [<ffffffff813f8a76>] ? _raw_spin_unlock_irq+0x30/0x58
[  873.255811]  [<ffffffff810abe06>] shrink_inactive_list+0x357/0x5e5
[  873.255960]  [<ffffffff810ab626>] ? shrink_active_list+0x232/0x244
[  873.256112]  [<ffffffff810ac39e>] shrink_zone+0x30a/0x3d4
[  873.256264]  [<ffffffff810acf79>] do_try_to_free_pages+0x176/0x27f
[  873.256416]  [<ffffffff810ad117>] shrink_all_memory+0x95/0xc4
[  873.256564]  [<ffffffff810aa61c>] ? isolate_pages_global+0x0/0x1f0
[  873.256713]  [<ffffffff81076e4c>] ? count_data_pages+0x65/0x79
[  873.256862]  [<ffffffff810770b3>] hibernate_preallocate_memory+0x1aa/0x2cb
[  873.257036]  [<ffffffff813f4f75>] ? printk+0x41/0x44
[  873.257186]  [<ffffffff81075a53>] hibernation_snapshot+0x36/0x1e1
[  873.257337]  [<ffffffff81075ccc>] hibernate+0xce/0x172
[  873.257485]  [<ffffffff81074a39>] state_store+0x5c/0xd3
[  873.257634]  [<ffffffff81184eff>] kobj_attr_store+0x17/0x19
[  873.257783]  [<ffffffff81125d43>] sysfs_write_file+0x108/0x144
[  873.257932]  [<ffffffff810d560f>] vfs_write+0xb2/0x153
[  873.258084]  [<ffffffff81063bd9>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  873.258237]  [<ffffffff810d5773>] sys_write+0x4a/0x71
[  873.258388]  [<ffffffff810021db>] system_call_fastpath+0x16/0x1b


>  - Related to the above: perhaps the RCU freeing isn't working, or 
>    slub/slab/slob ends up reusing the allocations for something else than 
>    anonvma's, so together with the race _and_ an unlucky re-use, you get 
>    some odd crud.
> 
>    I haven't looked at the kernel config files: do they perhaps share the 
>    same (odd?) SLUB/SLAB/SLOB config?

what is an odd SL[AOU]B config?

>  - anon_vma isn't actually an anonvma at all. 'page->mapping' was crud 
>    with the low bit set. That sounds unlikely, but who knows. The ksm code 
>    sets mapping to "stable_node + PAGE_MAPPING_ANON | PAGE_MAPPING_KSM"
> 
>    Did people have KSM enabled?

Nope, KSM is off here.

-- 
Regards/Gruss,
Boris.
