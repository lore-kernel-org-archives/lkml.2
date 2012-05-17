Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab2EQApV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:45:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:13326 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab2EQApT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:45:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="141483423"
Message-ID: <4FB449C1.2020603@intel.com>
Date: Thu, 17 May 2012 08:43:45 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Nick Piggin <npiggin@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        borislav.petkov@amd.com, yinghai@kernel.org, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk, jmorris@namei.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>    <1337072138-8323-7-git-send-email-alex.shi@intel.com>    <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>    <4FB2590C.1050303@intel.com> <1337092577.27694.45.camel@twins>   <1337093840.27694.56.camel@twins> <4FB34D49.1060809@intel.com>  <1337155239.27694.131.camel@twins> <4FB3ACD2.5010900@intel.com> <1337202569.4281.13.camel@twins>
In-Reply-To: <1337202569.4281.13.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 05:09 AM, Peter Zijlstra wrote:

> On Wed, 2012-05-16 at 21:34 +0800, Alex Shi wrote:
>>
>> So, if the minimum change of tlb->start/end can be protected by
>> HAVE_GENERIC_MMU_GATHER, it is safe and harmless, am I right?
>>
> safe yes, but not entirely harmless. A quick look seems to suggest you
> fail for VM_HUGETLB. If your mmu_gather spans a vma with VM_HUGETLB
> you'll do a regular range flush not a full mm flush like the other paths
> do.


Thanks!
Uh, HUGETLB will be found by has_large_page() if THP enabled now. And I
will remove THP cost, then HUGETLB will be deal well. Since the max
number of TLB entries is 512, has_large_page just need execute once just
when the start address is align at HPAGE_SIZE.

IMHO, this patch enabled generic mmu range flush support with just teen
lines. and it is supported well by low level x86 architecture. I like it. :)

> 
> Anyway, I did a quick refresh of my series on a recent -tip tree:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/mmu.git tlb-unify
> 
> With that all you need is to "select HAVE_MMU_GATHER_RANGE" for x86 and
> implement a useful flush_tlb_range().

> 
> In particular, see:
> http://git.kernel.org/?p=linux/kernel/git/peterz/mmu.git;a=commitdiff;h=05e53144177e6242fda404045f50f48114bcf185;hp=2cd7dc710652127522392f4b7ecb5fa6e954941e
> 
> I've slightly changed the code to address an open issue with the
> vm_flags tracking. We now force flush the mmu_gather whenever VM_HUGETLB
> flips because most (all?) archs that look at that flag expect pure huge
> pages and not a mixture.
> 
> I've seem to have misplaced my cross-compiler set, so I've only compiled
> x86-64 for now.


Oh, I also need a cross-compiler for other archs. Thanks reminder!
