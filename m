Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab1A0VZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 16:25:01 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38885 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab1A0VZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 16:25:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BEs+Wkb6c8iLCz/p59Ci5gZgMgOSclYzizikGO48WoYbw9JkKd46e6RqMH5Pnye53a
         h3hWQ8AUNezpPprDh0g3kaLKWMZKx1Va2m1TLDpuYOdjuvuGJK6srEzyo/OXl3QQivEM
         CXWuoz5XBpbZcmbD9PfwwScvOWlTszWiWicWY=
MIME-Version: 1.0
In-Reply-To: <4D41A651020000780002ED36@vpn.id2.novell.com>
References: <4D416D9A.9010603@huawei.com>
	<4D41A651020000780002ED36@vpn.id2.novell.com>
Date: Fri, 28 Jan 2011 08:24:58 +1100
Message-ID: <AANLkTikhoG4fgXjD9hS9yB+BVqeF3GXtTHiQVMn0n5TS@mail.gmail.com>
Subject: Re: One (possible) x86 get_user_pages bug
From: Nick Piggin <npiggin@gmail.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: Xiaowei Yang <xiaowei.yang@huawei.com>, Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fanhenglong@huawei.com,
        Kaushik Barde <kbarde@huawei.com>, Kenneth Lee <liguozhu@huawei.com>,
        linqaingmin <linqiangmin@huawei.com>, wangzhenguo@huawei.com,
        Wu Fengguang <fengguang.wu@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 3:07 AM, Jan Beulich <JBeulich@novell.com> wrote:
>>>> On 27.01.11 at 14:05, Xiaowei Yang <xiaowei.yang@huawei.com> wrote:
>> We created a scenario to reproduce the bug:
>> ----------------------------------------------------------------
>> // proc1/proc1.2 are 2 threads sharing one page table.
>> // proc1 is the parent of proc2.
>>
>> proc1               proc2          proc1.2
>> ...                 ...            // in gup_pte_range()
>> ...                 ...            pte = gup_get_pte()
>> ...                 ...            page1 = pte_page(pte)  // (1)
>> do_wp_page(page1)   ...            ...
>> ...                 exit_map()     ...
>> ...                 ...            get_page(page1)        // (2)
>> -----------------------------------------------------------------
>>
>> do_wp_page() and exit_map() cause page1 to be released into free list
>> before get_page() in proc1.2 is called. The longer the delay between
>> (1)&(2), the easier the BUG_ON shows.
>
> Other than responded initially, I don't this can happen outside
> of Xen: do_wp_page() won't reach page_cache_release() when
> gup_pte_range() is running for the same mm on another CPU,
> since it can't get past ptep_clear_flush() (waiting for the CPU
> in get_user_pages_fast() to re-enable interrupts).

Yeah, this cannot happen on native.


>> An experimental patch is made to prevent the PTE being modified in the
>> middle of gup_pte_range(). The BUG_ON disappears afterward.
>>
>> However, from the comments embedded in gup.c, it seems deliberate to
>> avoid the lock in the fast path. The question is: if so, how to avoid
>> the above scenario?
>
> Nick, based on your doing of the initial implementation, would
> you be able to estimate whether disabling get_user_pages_fast()
> altogether for Xen would be performing measurably worse than
> adding the locks (but continuing to avoid acquiring mm->mmap_sem)
> as suggested by Xiaowei? That's of course only if the latter is correct
> at all, of which I haven't fully convinced myself yet.

You must have some way to guarantee existence of Linux page
tables when you walk them in order to resolve a TLB refill.

x86 does this with IPI and hardware fill that is atomic WRT interrupts.
So fast gup can disable interrupts to walk page tables, I don't think it
is fragile it is absolutely tied to the system ISA (of course that can
change, but as Peter said, other things will have to change).

Other architectures use RCU for this, so fast gup uses a lockless-
pagecache-alike protcol for that.

If Xen is not using IPIs for flush, it should use whatever locks or
synchronization its TLB refill is using.

Thanks,
Nick
