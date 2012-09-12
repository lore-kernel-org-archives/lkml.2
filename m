Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab2ILCfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 22:35:54 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:56297 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab2ILCfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 22:35:53 -0400
Message-ID: <504FF4FA.80409@linux.vnet.ibm.com>
Date: Wed, 12 Sep 2012 10:35:38 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 09/12] thp: introduce khugepaged_prealloc_page and khugepaged_alloc_page
References: <5028E12C.70101@linux.vnet.ibm.com> <5028E20C.3080607@linux.vnet.ibm.com> <alpine.LSU.2.00.1209111807030.21798@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1209111807030.21798@eggly.anvils>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091202-7014-0000-0000-000001E17AE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 10:03 AM, Hugh Dickins wrote:
> On Mon, 13 Aug 2012, Xiao Guangrong wrote:
> 
>> They are used to abstract the difference between NUMA enabled and NUMA disabled
>> to make the code more readable
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  mm/huge_memory.c |  166 ++++++++++++++++++++++++++++++++----------------------
>>  1 files changed, 98 insertions(+), 68 deletions(-)
> 
> Hmm, that in itself is not necessarily an improvement.
> 
> I'm a bit sceptical about this patch,
> thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
> in last Thursday's mmotm 2012-09-06-16-46.
> 
> What brought me to look at it was hitting "BUG at mm/huge_memory.c:1842!"
> running tmpfs kbuild swapping load (with memcg's memory.limit_in_bytes
> forcing out to swap), while I happened to have CONFIG_NUMA=y.
> 
> That's the VM_BUG_ON(*hpage) on entry to khugepaged_alloc_page().

I will look into it, thanks for your point it out.

> 
> (If I'm honest, I'll admit I have Michel's "interval trees for anon rmap"
> patches in on top, and so the line number was actually shifted to 1839:
> but I don't believe his patches were in any way involved here, and
> indeed I've not yet found a problem with them: they look very good.)
> 
> I expect the BUG could quite easily be fixed up by making another call
> to khugepaged_prealloc_page() from somewhere to free up the hpage;
> but forgive me if I dislike using "prealloc" to free.
> 
> I do agree with you that the several CONFIG_NUMA ifdefs dotted around
> mm/huge_memory.c are regrettable, but I'm not at all sure that you're
> improving the situation with this patch, which gives misleading names
> to functions and moves the mmap_sem upping out of line.
> 
> I think you need to revisit it: maybe not go so far (leaving a few
> CONFIG_NUMAs behind, if they're not too bad), or maybe go further
> (add a separate function for freeing in the NUMA case, instead of
> using "prealloc").  I don't know what's best: have a play and see.

Sorry for that, i will find a better way to do this.

> 
> That's what I was intending to write yesterday.  But overnight I
> was running with this 9/12 backed out (I think 10,11,12 should be
> independent), and found "BUG at mm/huge_memory.c:1835!" this morning.
> 
> That's the VM_BUG_ON(*hpage) below #else in collapse_huge_page()
> when 9/12 is reverted.
> 
> So maybe 9/12 is just obscuring what was already a BUG, either earlier
> in your series or elsewhere in mmotm (I've never seen it on 3.6-rc or
> earlier releases, nor without CONFIG_NUMA).  I've not spent any time
> looking for it, maybe it's obvious - can you spot and fix it?

Sure, will fix it as soon as possible. Thanks!


