Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1GPPDo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 11:03:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55289 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab1GPPDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 11:03:41 -0400
Message-ID: <4E21A841.9010005@gmail.com>
Date: Sat, 16 Jul 2011 11:03:29 -0400
From: Shan Hai <haishan.bai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: David Laight <David.Laight@ACULAB.COM>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com, dhowells@redhat.com,
        paulus@samba.org, tglx@linutronix.de, walken@google.com,
        linuxppc-dev@lists.ozlabs.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Fixup write permission of TLB on powerpc e500 core
References: <AE90C24D6B3A694183C094C60CF0A2F6D8ADFC@saturn3.aculab.com>	 <4E205D96.7010109@gmail.com> <1310775649.25044.5.camel@pasglop>
In-Reply-To: <1310775649.25044.5.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2011 08:20 PM, Benjamin Herrenschmidt wrote:
> On Fri, 2011-07-15 at 11:32 -0400, Shan Hai wrote:
>> I agree with you, the problem could be triggered by accessing
>> any user space page which has kernel read only permission
>> in the page fault disabled context, the problem also affects
>> architectures which depend on SW dirty/young tracking as
>> stated by Benjamin in this thread.
>>
>> In the e500 case, the commit 6cfd8990e27d3a491c1c605d6cbc18a46ae51fef
>> removed the write permission fixup from TLB miss handlers and left it to
>> generic code, so it might be right time to fixup the write permission here
>> in the generic code.
> But we can't. The must not modify the PTE from an interrupt context and
> the "atomic" variants of user accesses can be called in such contexts.
>
> I think the problem is that we try to actually do things other than just
> "peek" at user memory (for backtraces etc...) but actually useful things
> in page fault disabled contexts. That's bad and various archs mm were
> designed with the assumption that this never happens.
>

Yes I understood, the *here* above means 'generic code' like futex code,
I am sorry for my ambiguous description.

> If the futex case is seldom here, we could probably find a way to work
> around in that specific case.
>

That's what my patch wants to do.

> However, I -still- don't understand why gup didn't fixup the write
> permission. gup doesn't set dirty ?
>

Yep, gup doesn't set dirty, because when the page fault
occurs on the kernel accessing a user page which is
read only to the kernel the following conditions hold,
- the page is present, because its a shared page
- the page is writable, because demand paging
     sets up the pte for the current  process to so

The follow_page() called in the __get_user_page()
returns non NULL to its caller on the above mentioned
present and writable page, so the gup(.write=1) has no
chance to set pte dirty by calling handle_mm_fault

Thanks
Shan Hai
s
> Cheers,
> Ben.
>
>

