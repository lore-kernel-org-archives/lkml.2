Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab0DHAko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 20:40:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371Ab0DHAkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 20:40:43 -0400
Message-ID: <4BBD25A3.60802@redhat.com>
Date: Wed, 07 Apr 2010 20:38:59 -0400
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
References: <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org> <20100406195459.554265e7@annuminas.surriel.com> <20100407151357.FB7E.A69D9226@jp.fujitsu.com> <20100407105454.2e7ab9bf@annuminas.surriel.com> <alpine.LFD.2.00.1004070827140.3487@i5.linux-foundation.org> <4BBCAA5B.7080603@redhat.com> <alpine.LFD.2.00.1004070951330.3487@i5.linux-foundation.org> <alpine.LFD.2.00.1004071415170.3586@i5.linux-foundation.org> <4BBCFE8A.1030602@redhat.com> <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org> <alpine.LFD.2.00.1004071510080.3586@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004071510080.3586@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 06:15 PM, Linus Torvalds wrote:
> On Wed, 7 Apr 2010, Linus Torvalds wrote:
>>
>> In the long run, it would be nicer to actually return an error from the
>> mmap() that fails, but that's more complicated, and as mentioned, it's not
>> what the old code used to do either (since the failure point was always at
>> the page fault stage).
>
> Put another way: I'm not proud of it, but the new code isn't any worse
> than what we used to have, and I think the new code is _fixable_.

Agreed, it is no worse than what we had before.

As to fixable, I supect both situations are fixable.
The new code by getting the error paths right, the
old code by completely bailing out of the page fault
and retrying it (the pageout code should trigger an
OOM kill at some point, if we are really out of memory).

> The easiest way to do that would likely be to pre-allocate the anon_vma
> struct (and anon_vma_chain), and pass it down to anon_vma_prepare. That
> way anon_vma_prepare() itself can never fail, and all we need to do is a
> simple allocation earlier in the call-chain.

That may not work, because we may want to merge the anon_vma
with the anon_vma in an adjacant VMA ... and that adjacant
VMA could be chained onto multiple anon_vmas.

That means allocating a single anon_vma_chain may not be
enough.
