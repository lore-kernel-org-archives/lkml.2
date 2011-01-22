Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917Ab1AVP7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 10:59:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750800Ab1AVP7d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 10:59:33 -0500
MIME-Version: 1.0
In-Reply-To: <20110122153459.GF3306@sgi.com>
References: <20110122153033.GR2912@sgi.com> <20110122153459.GF3306@sgi.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 22 Jan 2011 07:59:11 -0800
Message-ID: <AANLkTikG9ud-hpXaLjLcv6+j9O00guhcZTa=OPs9PX4A@mail.gmail.com>
Subject: Re: shmget limited by SHMEM_MAX_BYTES to 0x4020010000 bytes (Resend).
To: Robin Holt <holt@sgi.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 7:34 AM, Robin Holt <holt@sgi.com> wrote:
> I have a customer system with 12 TB of memory.  The customer is trying
> to do a shmget() call with size of 4TB and it fails due to the check in
> shmem_file_setup() against SHMEM_MAX_BYTES which is 0x4020010000.
>
> I have considered a bunch of options and really do not know which
> direction I should take this.
>
> I could add a third level and fourth level with a similar 1/4 size being
> the current level of indirection, and the next quarter being a next level.
> That would get me closer, but not all the way there.

Ugh.

How about just changing the indexing to use a bigger page allocation?
Right now it uses PAGE_CACHE_SIZE and ENTRIES_PER_PAGE, but as far as
I can tell, the indexing logic is entirely independent from PAGE_SIZE
and PAGE_CACHE_SIZE, and could just use its own SHM_INDEX_PAGE_SIZE or
something.

That would allow increasing the indexing capability fairly easily, no?
No actual change to the (messy) algorithm at all, just make the block
size for the index pages bigger.

Sure, it means that you now require multipage allocations in
shmem_dir_alloc(), but that doesn't sound all that hard. The code is
already set up to try to handle it (because we have that conceptual
difference between PAGE_SIZE and PAGE_CACHE_SIZE, even though the two
end up being the same).

NOTE! I didn't look very closely at the details, there may be some
really basic reason why the above is a completely idiotic idea.

The alternative (and I think it might be a good alternative) is to get
rid of the shmem magic indexing entirely, and rip all the code out and
replace it with something that uses the generic radix tree functions.
Again, I didn't actually look at the code enough to judge whether that
would be the most painful effort ever or even possible at all.

                     Linus
