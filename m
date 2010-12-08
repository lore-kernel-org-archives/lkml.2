Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0LHX60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:58:26 -0500
Received: from smtp-out.google.com ([74.125.121.35]:24115 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0LHX6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:58:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g0zXV9blCUIniSbRi36kjiYTygm7JQJjDWogctQyOk28D2seWgoSc2n3TUq5l8ePku
         yS0FenCyrHJbVLcLDKaw==
MIME-Version: 1.0
In-Reply-To: <20101208152740.ac449c3d.akpm@linux-foundation.org>
References: <1291335412-16231-1-git-send-email-walken@google.com>
	<1291335412-16231-2-git-send-email-walken@google.com>
	<20101208152740.ac449c3d.akpm@linux-foundation.org>
Date: Wed, 8 Dec 2010 15:58:21 -0800
Message-ID: <AANLkTikYZi0=c+yM1p8H18u+9WVbsQXjAinUWyNt7x+t@mail.gmail.com>
Subject: Re: [PATCH 1/6] mlock: only hold mmap_sem in shared mode when
 faulting in pages
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 3:27 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> Currently mlock() holds mmap_sem in exclusive mode while the pages get
>> faulted in. In the case of a large mlock, this can potentially take a
>> very long time, during which various commands such as 'ps auxw' will
>> block. This makes sysadmins unhappy:
>>
>> real    14m36.232s
>> user    0m0.003s
>> sys     0m0.015s
>>(output from 'time ps auxw' while a 20GB file was being mlocked without
>> being previously preloaded into page cache)
>
> The kernel holds down_write(mmap_sem) for 14m36s?

Yes...

[... patch snipped off ...]

> Am I correct in believing that we'll still hold down_read(mmap_sem) for
> a quarter hour?

Yes, patch 1/6 changes the long hold time to be in read mode instead
of write mode, which is only a band-aid. But, this prepares for patch
5/6, which releases mmap_sem whenever there is contention on it or
when blocking on disk reads.

> We don't need to hold mmap_sem at all while faulting in those pages,
> do we?  We could just do
>
>        for (addr = start, addr < end; addr += PAGE_SIZE)
>                get_user(x, addr);
>
> and voila.  If the pages are in cache and the ptes are set up then that
> will be *vastly* faster than the proposed code.  If the get_user()
> takes a minor fault then it'll be slower.  If it's a major fault then
> the difference probably doesn't matter much.

get_user wouldn't suffice if the page is already mapped in, as we need
to mark it as PageMlocked. Also, we need to skip IO and PFNMAP
regions. I don't think you can make things much simpler than what I
ended up with.

> But whatever.  Is this patchset a half-fix, and should we rather be
> looking for a full-fix?

I think the series fully fixes the mlock() and mlockall() cases, which
has been the more pressing use case for us.

Even then, there are still cases where we could still observe long
mmap_sem hold times - fundamentally, every place that calls
get_user_pages (or do_mmap, in the mlockall MCL_FUTURE case) with a
large page range may create such problems. From the looks of it, most
of these places wouldn't actually care if the mmap_sem got dropped in
the middle of the operation, but a general fix will have to involve
looking at all the call sites to be sure.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
