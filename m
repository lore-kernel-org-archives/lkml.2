Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab0DIIBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 04:01:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62572 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab0DIIBN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 04:01:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eYcjYCslTyaptw2SPyfzcUZe7lGYem70vB2LwXZJyLU4HMJojR/wYaJ3sTMbKc1NwP
         fCkS2GEcBMYCQsQJhl7gpZ44gZwJTGNPJKm/Wn0Go1WCD2Cz9czdsNfrPXSIRL+e1S5K
         WVD7j66bhyVxxtPrNZt7IqwEiXuCY+0w8x1wk=
MIME-Version: 1.0
In-Reply-To: <20100409160252.80E6.A69D9226@jp.fujitsu.com>
References: <20100409150335.80E3.A69D9226@jp.fujitsu.com>
	 <20100409154730.e9945cbc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100409160252.80E6.A69D9226@jp.fujitsu.com>
Date: Fri, 9 Apr 2010 17:01:11 +0900
Message-ID: <n2x28c262361004090101ufa54ff03zc9a94c8808841206@mail.gmail.com>
Subject: Re: [PATCH 02/13] mm: Revalidate anon_vma in page_lock_anon_vma()
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kosaki.

On Fri, Apr 9, 2010 at 4:29 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> Hmm, I think following.
>>
>> Assume a page is ANON and SwapCache, and it has only one reference.
>> Consider it's read-only mapped and cause do_wp_page().
>> page_mapcount(page) == 1 here.
>>
>>     CPU0                          CPU1
>>
>> 1. do_wp_page()
>> 2. .....
>> 3. replace anon_vma.     anon_vma = lock_page_anon_vma()
>>
>> So, lock_page_anon_vma() may have lock on wrong anon_vma, here.(mapcount=1)
>>
>> 4. modify pte to writable.        do something...
>>
>> After lock, in CPU1, a pte of estimated address by vma_address(vma, page)
>> containes pfn of the page and page_check_address() will success.
>>
>> I'm not sure how this is dangerouns.
>> But it's possible that CPU1 cannot notice there was anon_vma replacement.
>> And modifies pte withoug holding anon vma's lock which the code believes
>> it's holded.
>
>
> Hehe, page_referenced() already can take unstable VM_LOCKED value. So,
> In worst case we make false positive pageout, but it's not disaster.

OFF-TOPIC:

I think you pointed out good thing, too. :)

You mean although application call mlock of any vma, few pages on the vma can
be swapout by race between mlock and reclaim?

Although it's not disaster, apparently it breaks API.
Man page
" mlock() and munlock()
  mlock()  locks pages in the address range starting at addr and
continuing for len bytes. All pages that contain a part of the
specified address range are guaranteed to be resident in RAM when the
call returns  successfully;  the pages are guaranteed to stay in RAM
until later unlocked."

Do you have a plan to solve such problem?

And how about adding simple comment about that race in page_referenced_one?
Could you send the patch?




-- 
Kind regards,
Minchan Kim
