Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab2JRGhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 02:37:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab2JRGhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 02:37:33 -0400
Message-ID: <507FA2B3.3080403@redhat.com>
Date: Thu, 18 Oct 2012 14:33:23 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110904 Red Hat/3.1.14-1.el6_1 Thunderbird/3.1.14
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Flavio Leitner <fbl@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, ianfang.cn@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: kexec/kdump kernel fails to start
References: <20120904143215.5bbbb2a4@obelix.rh>	<CAM_iQpVVCjJ0Bde9RS9Rm-0RJ=CtTyX3eUH45+oaaepvdAvAmQ@mail.gmail.com>	<20120923202727.GA28937@mwanda>	<CAE9FiQX-R1L-0LDZNTbk-a6SUog+=tTrdwcfr0QUczH_PLMMpw@mail.gmail.com>	<20120929071318.GA7444@gmail.com> <CABqxG0czidut37LkwqH2_D44ng-HWHudjgZr9w8csqnGVUT0rA@mail.gmail.com>
In-Reply-To: <CABqxG0czidut37LkwqH2_D44ng-HWHudjgZr9w8csqnGVUT0rA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 10:16 AM, Dave Young wrote:

> On Sat, Sep 29, 2012 at 3:13 PM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> On Sun, Sep 23, 2012 at 1:27 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>>>> On Wed, Sep 05, 2012 at 11:34:25PM +0800, Cong Wang wrote:
>>>>> On Wed, Sep 5, 2012 at 1:32 AM, Flavio Leitner <fbl@redhat.com> wrote:
>>>>>> Hi folks,
>>>>>>
>>>>>> I have system that no longer boots kdump kernel. Basically,
>>>>>>
>>>>>> # echo c > /proc/sysrq-trigger
>>>>>>
>>>>>> to dump a vmcore doesn't work. It just hangs after showing the usual
>>>>>> panic messages. I've bisected the problem and the commit introducing
>>>>>> the issue is the one below.
>>>>>>
>>>>>> Any idea?
>>>>>>
>>>>>> commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8
>>>>>> Author: WANG Cong <xiyou.wangcong@gmail.com>  2012-03-05 20:05:13
>>>>>> Committer: Ingo Molnar <mingo@elte.hu>  2012-03-06 05:38:26
>>>>>> Parent: 550cf00dbc8ee402bef71628cb71246493dd4500 (Merge tag 'mmc-fixes-for-3.3' of git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc)
>>>>>> Child:  a6fca40f1d7f3e232c9de27c1cebbb9f787fbc4f (x86, tlb: Switch cr3 in leave_mm() only when needed)
>>>>>> Branches: master, remotes/origin/master
>>>>>> Follows: v3.3-rc6
>>>>>> Precedes: v3.5-rc1
>>>>>>
>>>>>>     x86/mm: Fix the size calculation of mapping tables
>>>>>
>>>>> There was some attempt to fix this:
>>>>> https://patchwork.kernel.org/patch/1195751/
>>>>>
>>>>> but for some reason it is not accepted.
>>>>
>>>> I filed a bug for this:
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=47881
>>>>
>>>> Is it fixed now?
>>>
>>> that offending patch should be reverted...
>>>
>>> 722bc6b16771ed80871e1fd81c86d3627dda2ac8
>>
>> It does not revert cleanly - could someone send a (kexec
>> tested!) patch with a proper description?
> 
> Hi, ingo
> 
> Besides of commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8,
> below commit also need revert.
> 
> commit bd2753b2dda7bb43c7468826de75f49c6a7e8965
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Wed Jun 6 10:55:40 2012 -0700
> 
>     x86/mm: Only add extra pages count for the first memory range
> during pre-allocation early page table space
> 
>     Robin found this regression:
> 
>     | I just tried to boot an 8TB system.  It fails very early in boot with:
>     | Kernel panic - not syncing: Cannot find space for the kernel page tables
> 
>     git bisect commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8.
> 
>     A git revert of that commit does boot past that point on the 8TB
>     configuration.
> 
>     That commit will add up extra pages for all memory range even
>     above 4g.
> 
>     Try to limit that extra page count adding to first entry only.
> 
>     Bisected-by: Robin Holt <holt@sgi.com>
>     Tested-by: Robin Holt <holt@sgi.com>
>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>     Cc: WANG Cong <xiyou.wangcong@gmail.com>
>     Cc: Linus Torvalds <torvalds@linux-foundation.org>
>     Cc: Andrew Morton <akpm@linux-foundation.org>
>     Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Link: http://lkml.kernel.org/r/CAE9FiQUj3wyzQxtq9yzBNc9u220p8JZ1FYHG7t%3DMOzJ%3D9BZMYA@mail.gmail.com
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> 
> 
> OTOH,  Jacob and Yinghai has better init_memory_mapping
> cleanup patches which are in tip:x86/mm2 already.  Their patches fixes
> this issue
> as well.
> 
> Since kdump does not work for long time since
> 722bc6b16771ed80871e1fd81c86d3627dda2ac8
> Can you or someone else help to get the init_memory_mapping patches merged?
> 
> Or do you still prefer to revert 722bc6b and bd2753b2d?  I think
> stable kernel also need a fix.
> 




Just see Yinghai's coments, later init_memory_mapping cleanup
will also address the 4k pages in first 2/4M, so revert them should be better.
https://lkml.org/lkml/2012/9/4/533

Here is a patch for the reverting:
---
x86 mm: Revert find_early_table_space fix

722bc6b16771ed80871e1fd81c86d3627dda2ac8 Try to address the issue that the
first 2/4M should use 4k pages if PSE enabled. but extra counts should only
valid for x86_32. This commit cause kdump regression, kdump kernel hangs happens
with it. 

As Yinghai Lu said they should be reverted. see below post:
https://lkml.org/lkml/2012/9/4/533 

As there's a later fix to above fix which is bd2753b2dda7bb43c7468826de75f49c6a7e8965
So we need revert both of these two commits.

Tested kdump on physical and virutual machines. 

Reverted commits:
commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8
Author: WANG Cong <xiyou.wangcong@gmail.com>
Date:   Mon Mar 5 15:05:13 2012 -0800

    x86/mm: Fix the size calculation of mapping tables
    
    For machines that enable PSE, the first 2/4M memory region still uses
    4K pages, so needs more PTEs in this case, but
    find_early_table_space() doesn't count this.
    
    This patch fixes it.
    
    The bug was found via code review, no misbehavior of the kernel
    was observed.
    
    Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
    Cc: Yinghai Lu <yinghai@kernel.org>
    Cc: Tejun Heo <tj@kernel.org>
    Cc: <ianfang.cn@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Link: http://lkml.kernel.org/n/tip-kq6a00qe33h7c7ais2xsywnh@git.kernel.org
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

commit bd2753b2dda7bb43c7468826de75f49c6a7e8965
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Wed Jun 6 10:55:40 2012 -0700

    x86/mm: Only add extra pages count for the first memory range during pre-allocatio
    
    Robin found this regression:
    
    | I just tried to boot an 8TB system.  It fails very early in boot with:
    | Kernel panic - not syncing: Cannot find space for the kernel page tables
    
    git bisect commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8.
    
    A git revert of that commit does boot past that point on the 8TB
    configuration.
    
    That commit will add up extra pages for all memory range even
    above 4g.
    
    Try to limit that extra page count adding to first entry only.
    
    Bisected-by: Robin Holt <holt@sgi.com>
    Tested-by: Robin Holt <holt@sgi.com>
    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Cc: WANG Cong <xiyou.wangcong@gmail.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/r/CAE9FiQUj3wyzQxtq9yzBNc9u220p8JZ1FYHG7t%3DMOzJ%3D9B
    Signed-off-by: Ingo Molnar <mingo@kernel.org>


Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/mm/init.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- linux-2.6.orig/arch/x86/mm/init.c
+++ linux-2.6/arch/x86/mm/init.c
@@ -29,14 +29,8 @@ int direct_gbpages
 #endif
 ;
 
-struct map_range {
-	unsigned long start;
-	unsigned long end;
-	unsigned page_size_mask;
-};
-
-static void __init find_early_table_space(struct map_range *mr, unsigned long end,
-					  int use_pse, int use_gbpages)
+static void __init find_early_table_space(unsigned long end, int use_pse,
+					  int use_gbpages)
 {
 	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
 	phys_addr_t base;
@@ -61,10 +55,6 @@ static void __init find_early_table_spac
 #ifdef CONFIG_X86_32
 		extra += PMD_SIZE;
 #endif
-		/* The first 2/4M doesn't use large pages. */
-		if (mr->start < PMD_SIZE)
-			extra += mr->end - mr->start;
-
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
 		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -95,6 +85,12 @@ void __init native_pagetable_reserve(u64
 	memblock_reserve(start, end - start);
 }
 
+struct map_range {
+	unsigned long start;
+	unsigned long end;
+	unsigned page_size_mask;
+};
+
 #ifdef CONFIG_X86_32
 #define NR_RANGE_MR 3
 #else /* CONFIG_X86_64 */
@@ -267,7 +263,7 @@ unsigned long __init_refok init_memory_m
 	 * nodes are discovered.
 	 */
 	if (!after_bootmem)
-		find_early_table_space(&mr[0], end, use_pse, use_gbpages);
+		find_early_table_space(end, use_pse, use_gbpages);
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
