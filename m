Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab2ECGXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:23:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34979 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2ECGXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:23:41 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com>
References: <1335788867.29087.19.camel@localhost>
	<20120501110024.GC6649@dhcp-172-17-9-228.mtv.corp.google.com>
	<1335875321.26671.15.camel@localhost>
	<CAPa8GCANv=-c7HsYvDqM+8JqJq6Gr9muxAivU2Ni16x9Ru5EXw@mail.gmail.com>
	<CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com>
Date: Thu, 3 May 2012 16:23:41 +1000
Message-ID: <CAPa8GCDF3nfNpqaftwf3nYu+KCJpE1q-+=Ufko_4zPgfjYGt=w@mail.gmail.com>
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
From: Nick Piggin <npiggin@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jana Saout <jana@saout.de>, Joel Becker <jlbec@evilplan.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 May 2012 15:57, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, May 2, 2012 at 10:02 PM, Nick Piggin <npiggin@gmail.com> wrote:
>> Linus did you see this thread?
>
> I did not..
>
>>Any ideas what is going on?
>
> Note that the discussion about aligned allocations is irrelevant. It
> doesn't matter at all if the pathname allocation is aligned - what
> matters if whether the last *component* of the pathname is aligned or
> not, and that is not going to depend on the allocation alignment.
>
> The word-at-a-time code assumes that no allocation will be the last
> page (whether kmalloc or normal page allocation), which was always
> somewhat optimistic but I thought it would be true on PC's.
>
> And that %rbp value does *not* look like end-of-memory, but maybe
> there is something else than just the CONFIG_DEBUG_PAGEALLOC that
> causes us to punch holes even in the kernel memory map.
>
> Peter, Ingo - do we unmap kernel pages for PAT etc attributes?
>
> Jana, can you send me the whole dmesg for the bootup up to and
> including the oops?
>
> There are multiple ways to fix this, including just marking that
> unaligned word access as being able to take an exception, but I had
> hoped to avoid having to do that. There are alternatives, like always
> padding allocations up by 7 bytes, but those are nasty too. So I'd
> like to understand what triggers this for Jana, it's possible we can
> just work around that particular issue.

Ah, I see what you mean. kmalloc is padded to 8 bytes, but that's
irrelevant if the full string was exactly modulo 8 bytes long, but the
last component starts inside the last 8 bytes.

That seems to exonerate OCFS2 and autofs.

vmalloc of course does guard pages, and that creeps into percpu
data and other things. It's not the case here, but would it be worth
putting a check in to catch that, or is it just a totally insane thing
to pass vmalloc()/percpu_alloc()/etc name string?

Any other strange possible corner cases? If we put a string on stack,
do any architectures use vmalloc or anything strange for stacks?
