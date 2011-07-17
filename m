Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab1GQPkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 11:40:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32945 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab1GQPku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 11:40:50 -0400
Message-ID: <4E230270.20209@gmail.com>
Date: Sun, 17 Jul 2011 23:40:32 +0800
From: Shan Hai <haishan.bai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>	 <1310725418.2586.309.camel@twins>  <4E21A526.8010904@gmail.com>	 <1310860194.25044.17.camel@pasglop> <1310900561.13765.22.camel@twins>	 <4E22E4AC.7040600@gmail.com> <1310914117.25044.216.camel@pasglop>
In-Reply-To: <1310914117.25044.216.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2011 10:48 PM, Benjamin Herrenschmidt wrote:
> On Sun, 2011-07-17 at 21:33 +0800, Shan Hai wrote:
>> On ARM you could not protect pages from supervisor-mode writes,
>> isn't it?  That means, all writable user pages are writable for
>> supervisor too, but its not hold for at least x86 and powerpc,
>> x86 and powerpc can be configured to protect pages from
>> supervisor-mode writes.
> That doesn't sound right... how would put_user() work properly then ? A
> cursory glance at the ARM code doesn't show it doing anything "special",
> just stores ... but I might have missing something.
>

That's real for ARM, for the reason put_user() work properly is that
the first time access to the write protected page triggers a page
fault, and the handle_mm_fault() will fix up the write permission
for the kernel, because at this time no one disabled the page fault
as done in the futex case.

>> Think about the following situation,
>> a page fault occurs on the kernel trying to write to a writable shared
>> user page which is read only to the kernel, the following conditions
>> hold,
>> - the page is *present*, because its a shared page
>> - the page is *writable*, because demand paging sets up the pte for
>>       the current process to so
>>
>> The follow_page() called in the __get_user_page() returns non NULL
>> to its caller on the above mentioned *present* and *writable* page,
>> so the gup(.write=1) has no chance to set pte dirty by calling
>> handle_mm_fault,
>> the follow_page() has no knowledge of supervisor-mode write protected
>> pages,
>> that's the culprit in the bug discussed here.
> Right, the problem is with writable pages that have "lost" (or never had
> but usually it's lost, due to swapping for example) their dirty bit, or
> any page that has lost young.
>
>  From what I can tell, we need to either fix those bits from the caller
> of gup (futex code), which sound nasty, or more easily fix those from
> gup itself, possibly under control of flags in the "write" argument to
> avoid breaking code relying on the existing behaviour, expecially vs.
> dirty.
>

So, for the reason the SW tracked dirty/young and supervisor protected
pages has potential effects on not only *futex* but also on other components
of the kernel which might access the non-dirty supervisor protected page,
in my opinion it might be more sensible to fix it from gup instead of fixing
it in the futex.

Thanks
Shan Hai

> Cheers,
> Ben.
>
>

