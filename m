Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab2FJGfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 02:35:22 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:54650 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab2FJGfV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 02:35:21 -0400
MIME-Version: 1.0
In-Reply-To: <4FD2C6C5.1070900@linaro.org>
References: <1338575387-26972-1-git-send-email-john.stultz@linaro.org>
	<1338575387-26972-4-git-send-email-john.stultz@linaro.org>
	<4FC9235F.5000402@gmail.com>
	<4FC92E30.4000906@linaro.org>
	<4FC9360B.4020401@gmail.com>
	<4FC937AD.8040201@linaro.org>
	<4FC9438B.1000403@gmail.com>
	<4FC94F61.20305@linaro.org>
	<4FCFB4F6.6070308@gmail.com>
	<4FCFEE36.3010902@linaro.org>
	<CAO6Zf6D++8hOz19BmUwQ8iwbQknQRNsF4npP4r-830j04vbj=g@mail.gmail.com>
	<4FD13C30.2030401@linux.vnet.ibm.com>
	<4FD16B6E.8000307@linaro.org>
	<4FD1848B.7040102@gmail.com>
	<4FD2C6C5.1070900@linaro.org>
Date: Sun, 10 Jun 2012 08:35:20 +0200
Message-ID: <CAO6Zf6A_vbuEjPtZEKoUXK83Y_TwE426k-gz41hDJXSvjuwUkw@mail.gmail.com>
Subject: Re: [PATCH 3/3] [RFC] tmpfs: Add FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE
 handlers
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> So maybe the right appraoch give up the per-fs volatile range lru, and try a
> varient of what DaveC and DaveH have suggested: Letting the page based lru
> reclamation handle the selection on a physical page basis, but then zapping
> the entirety of the neighboring range if any one page is reclaimed.  In
> order to try to preserve the range based LRU behavior, activate all the
> pages in the range together when the range is marked volatile.  Since we
> assume ranges are un-touched when volatile, that should preserve LRU purging
> behavior on single node systems and on multi-node systems it will
> approximate fairly closely.
>
> My main concern with this approach is marking and unmarking volatile ranges
> needs to be fast, so I'm worried about the additional overhead of activating
> each of the containing pages on mark_volatile.

(for my education) just to be sure that I got it right. So what you suggest is

(1) to 'deactivate-page' for all the pages in the range upon
mark_volatile. Hence, the pages from the same volatile range are
placed in clusters within their original LRU lists [a] and so

(1.1) the standard per-page reclaim mechanism is more likely to
discard them together;
(1.2) they are also (LRU-style) ordered wrt other volatile ranges (clusters)

[a] it's LRU_INACTIVE_FILE for tmpfs, right? also, the pages can be
from different zones (otoh, at least on x86 HIGH_MEM is likely).

or

(2) somehow remove all the pages from the standard LRU lists (or do
something else) to make sure that that the normal per-page reclaim
procedure can't see them. Then we introduce LRU_VOLATILE (where we
keep whole volatile ranges, not pages) and find the appropriate place
to process it in the reclaim code.

Also, I had another idea (it looks quite hacky though). For (1) above,
we don't necessarily need to touch all the pages... what we can do is
as follows:
- take the first page of the range (or even create a (hacky-hacky) virtual one);
- we need to mark it somehow as belonging to the volatile-reclaim
(modifying page->mapping ?);
- we place it at the beginning of the corresponding LRU_INACTIVE_*
list (hm, more complex if different zones);
  the idea here, is that the standard per-page reclaim code should see
this page before seeing any other page from its range
- once the per-page reclaim code encounters such a page (heh, should
be a low cost check though) - we call into volatile-reclaim...

now, this volatile-reclaim can even purge another volatile range,
because by placing "the page at the beginning of the corresponding
LRU_INACTIVE_* list)" we broke LRU-like behavior for volatile ranges.

>
> The other question I have with this approach is if we're on a system that
> doesn't have swap, it *seems* (not totally sure I understand it yet) the
> tmpfs file pages will be skipped over when we call shrink_lruvec.  So it
> seems we may need to add a new lru_list enum and nr[] entry (maybe
> LRU_VOLATILE?).   So then it may be that when we mark a range as volatile,
> instead of just activating it, we move it to the volatile lru, and then when
> we shrink from that list, we call back to the filesystem to trigger the
> entire range purging.
>

Kind of what I meant with (2) above?

[ I was in a bit of hurry while writing this, so I apologize for
possible confusion... I can elaborate on it more in details later on ]

Thanks,

-- Dmitry
