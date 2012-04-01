Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab2DAQqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:46:51 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:44021 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab2DAQqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:46:49 -0400
Message-ID: <4F788675.6060604@tilera.com>
Date: Sun, 1 Apr 2012 12:46:45 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v3] arch/tile: support multiple huge page sizes dynamically
References: <201203302018.q2UKIFH5020745@farm-0012.internal.tilera.com> <CAJd=RBCoLNB+iRX1shKGAwSbE8PsZXyk9e3inPTREcm2kk3nXA@mail.gmail.com> <201203311334.q2VDYGiL005854@farm-0012.internal.tilera.com> <CAJd=RBDEAMgDviSwugt7dHKPGXCCF5jQSDtHdXvt5VnSBmK3bA@mail.gmail.com> <201203311612.q2VGCqPA012710@farm-0012.internal.tilera.com> <CAJd=RBDqQ2jwxyVgn-WwoJfu0vOs9YUHfKxkcqUczr=cnk+8wg@mail.gmail.com>
In-Reply-To: <CAJd=RBDqQ2jwxyVgn-WwoJfu0vOs9YUHfKxkcqUczr=cnk+8wg@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/2012 8:33 AM, Hillf Danton wrote:
> On Sat, Mar 31, 2012 at 3:37 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>> This change adds support for a new "super" bit in the PTE, and a
>> new arch_make_huge_pte() method called from make_huge_pte().
>> The Tilera hypervisor sees the bit set at a given level of the page
>> table and gangs together 4, 16, or 64 consecutive pages from
>> that level of the hierarchy to create a larger TLB entry.
>>
>> One extra "super" page size can be specified at each of the
>> three levels of the page table hierarchy on tilegx, using the
>> "hugepagesz" argument on the boot command line.  A new hypervisor
>> API is added to allow Linux to tell the hypervisor how many PTEs
>> to gang together at each level of the page table.
>>
>> To allow pre-allocating huge pages larger than the buddy allocator
>> can handle, this change modifies the Tilera bootmem support to
>> put all of memory on tilegx platforms into bootmem.
>>
>> As part of this change I eliminate the vestigial CONFIG_HIGHPTE
>> support, which never worked anyway, and eliminate the hv_page_size()
>> API in favor of the standard vma_kernel_pagesize() API.
>>
>> Reviewed-by: Hillf Danton <dhillf@gmail.com>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
>> ---
>> This version of the patch adds a generic no-op definition to
>> <linux/hugetlb.h> if "arch_make_huge_pte" is not #defined.  I'm following
>> Linus's model in https://lkml.org/lkml/2012/1/19/443 which says you create
>> the inline, then "#define func func" to indicate that the function exists.
>>
>> Hillf, let me know if you want to provide an Acked-by, or I'll leave it
>> as Reviewed-by.  I'm glad you didn't like the v2 patch;
>>
> Frankly I like this work, if merged, many tile users benefit.
>
> And a few more words,
> 1, the Reviewed-by tag does not match what I did, really, and
> over 98% of this work should be reviewed by tile gurus IMO.

I can split this into two patches, one with your Reviewed-by: (just the
include/asm-generic/hugetlb.h and mm/hugetlb.c parts), and one without (the
arch/tile stuff).  As it happens, I am the tile guru for this code :-)

> 2, this work was delivered in a monolithic huge patch, and it is hard
> to be reviewed. The rule of thumb is to split it into several parts, then
> reviewers read a good story, chapter after another.

Yes.  I put it all together because it's all inter-dependent; there's no
piece of it that's useful in isolation, though as you've observed, there is
at least one piece that's helpfully reviewed separately.

So does it make sense for me to push the two resulting changes through the
tile tree?  I'd like to ask Linus to pull this stuff for 3.4 (I know, I'm
late in the cycle for that), but obviously it's not much use without the
part that you reviewed.  I imagine that if I'm pushing it through my tree,
it might be more appropriate to have an Acked-by than a Reviewed-by from
you, perhaps? What do you think?

Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

