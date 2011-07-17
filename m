Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab1GQNdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 09:33:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63974 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab1GQNdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 09:33:49 -0400
Message-ID: <4E22E4AC.7040600@gmail.com>
Date: Sun, 17 Jul 2011 21:33:32 +0800
From: Shan Hai <haishan.bai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>	 <1310725418.2586.309.camel@twins>  <4E21A526.8010904@gmail.com>	 <1310860194.25044.17.camel@pasglop> <1310900561.13765.22.camel@twins>
In-Reply-To: <1310900561.13765.22.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2011 07:02 PM, Peter Zijlstra wrote:
> On Sun, 2011-07-17 at 09:49 +1000, Benjamin Herrenschmidt wrote:
>> In the meantime, other than rewriting the futex code to not require
>> those in-atomic accesses (can't it just access the pages via the linear
>> mapping and/or kmap after the gup ?),
> That'll wreck performance on things like ARM and SPARC that have to deal
> with cache aliasing.
>
>>   all I see would be a way to force
>> dirty and young after gup, with appropriate locks, or a variant of gup
>> (via a flag ?) to require it to do so.
> Again, _WHY_ isn't gup(.write=1) a complete write fault? Its supposed to
> be, it needs to break COW, do dirty page tracking and call page_mkwrite.
> I'm still thinking this e500 stuff is smoking crack.
>
> ARM has no hardware dirty bit either, and yet it works for them. I can't
> exactly tell how because I got lost in there, but it does, again,
> suggest e500 is on crack.

Ok, the following feature of the architecture causes failure of
gup(.write=1) on dirtying pages,
- allows pages to be protected from supervisor-mode writes

On ARM you could not protect pages from supervisor-mode writes,
isn't it?  That means, all writable user pages are writable for
supervisor too, but its not hold for at least x86 and powerpc,
x86 and powerpc can be configured to protect pages from
supervisor-mode writes.

Think about the following situation,
a page fault occurs on the kernel trying to write to a writable shared
user page which is read only to the kernel, the following conditions hold,
- the page is *present*, because its a shared page
- the page is *writable*, because demand paging sets up the pte for
     the current process to so

The follow_page() called in the __get_user_page() returns non NULL
to its caller on the above mentioned *present* and *writable* page,
so the gup(.write=1) has no chance to set pte dirty by calling 
handle_mm_fault,
the follow_page() has no knowledge of supervisor-mode write protected pages,
that's the culprit in the bug discussed here.

Thanks
Shan Hai


