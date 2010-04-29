Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0D2CK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 22:10:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927Ab0D2CKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 22:10:54 -0400
Message-ID: <4BD8EA85.2000209@redhat.com>
Date: Wed, 28 Apr 2010 22:10:13 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH -v3] take all anon_vma locks in anon_vma_lock
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>	 <20100427231007.GA510@random.random>	 <20100428091555.GB15815@csn.ul.ie>	 <20100428153525.GR510@random.random>	 <20100428155558.GI15815@csn.ul.ie>	 <20100428162305.GX510@random.random>	 <20100428134719.32e8011b@annuminas.surriel.com>	 <20100428142510.09984e15@annuminas.surriel.com>	 <20100428161711.5a815fa8@annuminas.surriel.com>	 <20100428165734.6541bab3@annuminas.surriel.com> <y2s28c262361004281728we31e3b9fsd2427aacdc76a9e7@mail.gmail.com>
In-Reply-To: <y2s28c262361004281728we31e3b9fsd2427aacdc76a9e7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2010 08:28 PM, Minchan Kim wrote:
> On Thu, Apr 29, 2010 at 5:57 AM, Rik van Riel<riel@redhat.com>  wrote:
>> Take all the locks for all the anon_vmas in anon_vma_lock, this properly
>> excludes migration and the transparent hugepage code from VMA changes done
>> by mmap/munmap/mprotect/expand_stack/etc...
>>
>> Unfortunately, this requires adding a new lock (mm->anon_vma_chain_lock),
>> otherwise we have an unavoidable lock ordering conflict.  This changes the
>> locking rules for the "same_vma" list to be either mm->mmap_sem for write,
>> or mm->mmap_sem for read plus the new mm->anon_vma_chain lock.  This limits
>> the place where the new lock is taken to 2 locations - anon_vma_prepare and
>> expand_downwards.
>>
>> Document the locking rules for the same_vma list in the anon_vma_chain and
>> remove the anon_vma_lock call from expand_upwards, which does not need it.
>>
>> Signed-off-by: Rik van Riel<riel@redhat.com>
>
> This patch makes things simple. So I like this.
> Actually, I wanted this all-at-once locks approach.
> But I was worried about that how the patch affects AIM 7 workload
> which is cause of anon_vma_chain about scalability by Rik.
> But now Rik himself is sending the patch. So I assume the patch
> couldn't decrease scalability of the workload heavily.

The thing is, the number of anon_vmas attached to a VMA is
small (depth of the tree, so for apache or aim the typical
depth is 2). This N is between 1 and 3.

The problem we had originally is the _width_ of the tree,
where every sibling process was attached to the same anon_vma
and the rmap code had to walk the page tables of all the
processes, for every privately owned page in each child process.
For large server workloads, this N is between a few hundred and
a few thousand.

What matters most at this point is correctness - we need to be
able to exclude rmap walks when messing with a VMA in any way
that breaks lookups, because rmap walks for page migration and
hugepage conversion have to be 100% reliable.

That is not a constraint I had in mind with the original
anon_vma changes, so the code needs to be fixed up now...

I suspect that taking one or two extra spinlocks in the code
paths changed by this patch (mmap/munmap/...) is going to make
a difference at all, since all of those paths are pretty
infrequently taken.

-- 
All rights reversed
