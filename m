Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab0DGPyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:54:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581Ab0DGPyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:54:08 -0400
Message-ID: <4BBCAA5B.7080603@redhat.com>
Date: Wed, 07 Apr 2010 11:52:59 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
References: <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org> <20100406195459.554265e7@annuminas.surriel.com> <20100407151357.FB7E.A69D9226@jp.fujitsu.com> <20100407105454.2e7ab9bf@annuminas.surriel.com> <alpine.LFD.2.00.1004070827140.3487@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004070827140.3487@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 11:30 AM, Linus Torvalds wrote:

> I've said this now _three_ times, but let me repeat once more:
>
>   - the locking rules for that anon_vma_chain are very unclear. I _think_
>     you mean for them to be "mmap_sem held for writing, _or_ mmap_sem held
>     for reading and page_table_lock held", but nowhere is that actually
>     documented.

> Why is it so hard for you to just admit that? Especially after you
> yourself got it wrong.

You are right, the idea was to continue use the locking that
the anon_vma code was already using, without introducing any
new locking with the anon_vma patches.

However, it has become clear that this is no longer possible,
due to the need to hold a secondary lock across anon_vma_clone,
when we come from a code path that holds the mmap_sem for read.

>> +		merge_vma = find_mergeable_anon_vma(vma);
>> +		if (merge_vma) {
>> +			int ret;
>> +			spin_lock(&mm->page_table_lock);
>> +			ret = anon_vma_clone(vma, merge_vma);
>> +			if (!ret)
>> +				vma->anon_vma = merge_vma->anon_vma;
>> +			spin_unlock(&mm->page_table_lock);
>> +			return ret;
>> +		}
>
> Rik, the above is obviously total crap.
>
> anon_vma_clone() needs to allocate memory, and it does so with GFP_KERNEL.
> You can't do that with a spinlock held.

Looks like we'll either have to introduce a per-mm semaphore for
the same_vma anon_vma chains, or move the complexity of solving
this bug to anon_vma_merge, where we can ensure that the resulting
VMA has the sum of the anon_vmas of each VMA.
