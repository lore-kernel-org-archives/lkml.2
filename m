Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab2JQFnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:43:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46974 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab2JQFna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:43:30 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <507E4531.1070700@jp.fujitsu.com>
Date: Wed, 17 Oct 2012 14:42:09 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, bhutchings@solarflare.com,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.7] mm, mempolicy: fix printing stack contents in
 numa_maps
References: <20121008150949.GA15130@redhat.com> <CAHGf_=pr1AYeWZhaC2MKN-XjiWB7=hs92V0sH-zVw3i00X-e=A@mail.gmail.com> <alpine.DEB.2.00.1210152055150.5400@chino.kir.corp.google.com> <CAHGf_=rLjQbtWQLDcbsaq5=zcZgjdveaOVdGtBgBwZFt78py4Q@mail.gmail.com> <alpine.DEB.2.00.1210152306320.9480@chino.kir.corp.google.com> <CAHGf_=pemT6rcbu=dBVSJE7GuGWwVFP+Wn-mwkcsZ_gBGfaOsg@mail.gmail.com> <alpine.DEB.2.00.1210161657220.14014@chino.kir.corp.google.com> <alpine.DEB.2.00.1210161714110.17278@chino.kir.corp.google.com> <20121017040515.GA13505@redhat.com> <alpine.DEB.2.00.1210162222100.26279@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210162222100.26279@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/17 14:24), David Rientjes wrote:
> On Wed, 17 Oct 2012, Dave Jones wrote:
>
>> BUG: sleeping function called from invalid context at kernel/mutex.c:269
>> in_atomic(): 1, irqs_disabled(): 0, pid: 8558, name: trinity-child2
>> 3 locks on stack by trinity-child2/8558:
>>   #0: held:     (&p->lock){+.+.+.}, instance: ffff88010c9a00b0, at: [<ffffffff8120cd1f>] seq_lseek+0x3f/0x120
>>   #1: held:     (&mm->mmap_sem){++++++}, instance: ffff88013956f7c8, at: [<ffffffff81254437>] m_start+0xa7/0x190
>>   #2: held:     (&(&p->alloc_lock)->rlock){+.+...}, instance: ffff88011fc64f30, at: [<ffffffff81254f8f>] show_numa_map+0x14f/0x610
>> Pid: 8558, comm: trinity-child2 Not tainted 3.7.0-rc1+ #32
>> Call Trace:
>>   [<ffffffff810ae4ec>] __might_sleep+0x14c/0x200
>>   [<ffffffff816bdf4e>] mutex_lock_nested+0x2e/0x50
>>   [<ffffffff811c43a3>] mpol_shared_policy_lookup+0x33/0x90
>>   [<ffffffff8118d5c3>] shmem_get_policy+0x33/0x40
>>   [<ffffffff811c31fa>] get_vma_policy+0x3a/0x90
>>   [<ffffffff81254fa3>] show_numa_map+0x163/0x610
>>   [<ffffffff81255b10>] ? pid_maps_open+0x20/0x20
>>   [<ffffffff81255980>] ? pagemap_hugetlb_range+0xf0/0xf0
>>   [<ffffffff81255483>] show_pid_numa_map+0x13/0x20
>>   [<ffffffff8120c902>] traverse+0xf2/0x230
>>   [<ffffffff8120cd8b>] seq_lseek+0xab/0x120
>>   [<ffffffff811e6c0b>] sys_lseek+0x7b/0xb0
>>   [<ffffffff816ca088>] tracesys+0xe1/0xe6
>>
>
> Hmm, looks like we need to change the refcount semantics entirely.  We'll
> need to make get_vma_policy() always take a reference and then drop it
> accordingly.  This work sif get_vma_policy() can grab a reference while
> holding task_lock() for the task policy fallback case.
>
> Comments on this approach?

I think this refcounting is better than using task_lock().

Thanks,
-Kame

