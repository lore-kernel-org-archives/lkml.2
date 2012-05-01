Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab2EAXvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 19:51:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab2EAXvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 19:51:43 -0400
Date: Wed, 2 May 2012 01:51:13 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Jan Kara <jack@suse.cz>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
        linux-mm@kvack.org, mgorman@suse.de, Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH] Describe race of direct read and fork for unaligned
 buffers
Message-ID: <20120501235113.GC22923@redhat.com>
References: <1335778207-6511-1-git-send-email-jack@suse.cz>
 <CAHGf_=qdE3yNw=htuRssfav2pECO1Q0+gWMRTuNROd_3tVrd6Q@mail.gmail.com>
 <CAHGf_=ojhwPUWJR0r+jVgjNd5h_sRrppzJntSpHzxyv+OuBueg@mail.gmail.com>
 <x49ehr4lyw1.fsf@segfault.boston.devel.redhat.com>
 <CAHGf_=rzcfo3OnwT-YsW2iZLchHs3eBKncobvbhTm7B5PE=L-w@mail.gmail.com>
 <x491un3nc7a.fsf@segfault.boston.devel.redhat.com>
 <CAPa8GCCgLUt1EDAy7-O-mo0qir6Bf5Pi3Va1EsQ3ZW5UU=+37g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPa8GCCgLUt1EDAy7-O-mo0qir6Bf5Pi3Va1EsQ3ZW5UU=+37g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick!

On Wed, May 02, 2012 at 01:50:46AM +1000, Nick Piggin wrote:
> KOSAKI-san is correct, I think.
> 
> The race is something like this:
> 
> DIO-read
>     page = get_user_pages()
>                                                         fork()
>                                                             COW(page)
>                                                          touch(page)
>     DMA(page)
>     page_cache_release(page);

Yes. More in general this race happens every time the kernel wrprotect
a writable anon pte, if get_user_pages had a pin on the page while the
pte is being wrprotected.

fork can't just abort (like KSM does) when it notices mapcount <
page_count.

The only way to avoid this, is that somehow the GUP-pinned page should
remain pointed at all times by the pte of the process that pinned the
page (no matter the cows), and that's not happening.

> So whether parent or child touches the page, determines who gets the
> actual DMA target, and who gets the copy.

Correct, so far there are two reproducers, triggering two different
kind of corruption.

The corruption may appear in different ways:

1) we could lose the direct-io read in the parent (if the forked child
does nothing and just quits), that was the basic case in dma_thread.c,
a dummy fork was run just to mark the pte wrprotected

2) the destination of the direct-io read may also become visible to the
child if the child written to the page before the I/O is complete,
leading to random mm corruption in the child

3) it's a direct-io write, then the child could write random data to
disk by accident without noticing, if the DMA wasn't started yet and
the child got the pinned page mapped in the child pte

We had two working fixes for this and personally I'd prefer to apply
them than to document the bug. The probability that who writes code
that can hit the bug is reading the note in the manpage seems pretty
small, especially in the short/mid term. This lkml thread as reminder
may actually have higher chance of being noticed than the manpage
maybe. Nevertheless documenting it is better than nothing if the fixes
aren't applied :). However I'm afraid after we officially document it
the chances of fixing it becomes zero.

> 2 threads are not required, but it makes the race easier to code and a
> larger window, I suspect.
> 
> It can also be hit with a single thread, using AIO.

Yes, it requires running fork in the same process that pinned a page
with GUP, and then writing to a buffer in the same page that is under
the GUP pin before the GUP pin is released.

It's not just direct-io, and not just direct-io read (see point 3).
