Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0ECSkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 14:40:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab0ECSkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 14:40:07 -0400
Message-ID: <4BDF1840.7020601@redhat.com>
Date: Mon, 03 May 2010 14:38:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: akpm@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 1/2] mm: Take all anon_vma locks in anon_vma_lock
References: <20100503121743.653e5ecc@annuminas.surriel.com> <20100503121847.7997d280@annuminas.surriel.com> <alpine.LFD.2.00.1005030940490.5478@i5.linux-foundation.org> <4BDEFF9E.6080508@redhat.com> <alpine.LFD.2.00.1005030958140.5478@i5.linux-foundation.org> <4BDF0ECC.5080902@redhat.com> <alpine.LFD.2.00.1005031111170.5478@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005031111170.5478@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2010 02:19 PM, Linus Torvalds wrote:
> On Mon, 3 May 2010, Rik van Riel wrote:
>>
>> One problem is that we cannot find the VMAs (multiple) from
>> the page, except by walking the anon_vma_chain.same_anon_vma
>> list.  At the very least, that list requires locking, done
>> by the anon_vma.lock.
>
> But that's exactly what we do in rmap_walk() anyway.

Mel's original patch adds trylock & retry all code to rmap_walk
and a few other places:

http://lkml.org/lkml/2010/4/26/321

I submitted my patch 1/2 as an alternative, because these repeated
trylocks are pretty complex and easy to accidentally break when
changes to other VM code are made.

>> A forkbomb could definately end up getting slowed down by
>> this patch.  Is there any real workload out there that just
>> forks deeper and deeper from the parent process, without
>> calling exec() after a generation or two?
>
> Heh. AIM7. Wasn't that why we merged the multiple anon_vma's in the first
> place?

AIM7, like sendmail, apache or postgresql, is only 2 deep.

>>> So again, my gut feel is that if the lock just were in the vma itself,
>>> then the "normal" users would have just one natural lock, while the
>>> special case users (rmap_walk_anon) would have to lock each vma it
>>> traverses. That would seem to be the more natural way to lock things.
>>
>> However ... there's still the issue of page_lock_anon_vma
>> in try_to_unmap_anon.
>
> Do we care?
>
> We've not locked them all there, and we've historically not cares about
> the rmap list being "perfect", have we?

Well, try_to_unmap_anon walks just one page, and has the anon_vma
for that page locked.

Having said that, for pageout we do indeed not care about getting
it perfect.

> So I _think_ it's just the migration case (and apparently potentially the
> hugepage case) that wants _exact_ information. Which is why I suggest the
> onus of the extra locking should be on _them_, not on the regular code.

It's a matter of cost vs complexity.  IMHO the locking changes in
the lowest overhead patches (Mel's) are quite complex and could end
up being hard to maintain in the future.  I wanted to introduce
something a little simpler, with hopefully minimal overhead.

But hey, that's just my opinion - what matters is that the bug gets
fixed somehow.  If you prefer the more complex but slightly lower
overhead patches from Mel, that's fine too.

-- 
All rights reversed
