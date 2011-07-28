Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab1G1Byy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 21:54:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:9852 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab1G1Bys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 21:54:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=Twf9mA+VQLIY4Wfko24+N0gFzkB16xsgU3jEHHmMtYWyRGhemBsTzMejhWgZjB8oc
	+axECo8F2GJVgzXynDsUg==
Date: Wed, 27 Jul 2011 18:54:18 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/3] tmpfs radix_tree: locate_item to speed up swapoff
In-Reply-To: <20110727162819.b595e442.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1107271801450.9888@sister.anvils>
References: <alpine.LSU.2.00.1107191549540.1593@sister.anvils> <alpine.LSU.2.00.1107191553040.1593@sister.anvils> <20110727162819.b595e442.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, Andrew Morton wrote:
> On Tue, 19 Jul 2011 15:54:23 -0700 (PDT)
> Hugh Dickins <hughd@google.com> wrote:
> 
> > We have already acknowledged that swapoff of a tmpfs file is slower
> > than it was before conversion to the generic radix_tree: a little
> > slower there will be acceptable, if the hotter paths are faster.
> > 
> > But it was a shock to find swapoff of a 500MB file 20 times slower
> > on my laptop, taking 10 minutes; and at that rate it significantly
> > slows down my testing.
> 
> So it used to take half a minute?  That was already awful.

Yes, awful, half a minute on 3.0 (and everything before it back to
around 2.4.10 I imagine).  But no complaints have reached my ears for
years: it's as if I'm the only one to notice (pray I'm not opening a
floodgate with that remark).

> Why?  Was it IO-bound?  It doesn't sound like it.

No, not IO-bound at all.  One of the alternatives I did try was to
readahead the IO, but that was just irrelevant: it's the poor cpu
searching through (old or new) radix tree memory to find each
matching swap entry, one after another.

We've always taken the view, that until someone complains, leave
swapoff simple and slow, rather than being a little cleverer about
it, using more memory for hashes or batching the lookups.

And I don't think we'd want to get into making it cleverer now.
I expect we shall want to move away from putting swap entries, which
encode final disk destination, in page tables and tmpfs trees: we'll
want another layer of indirection, so we can shuffle swap around
between fast and slow devices, without troubling the rest of mm.

Rik pointed out that swapoff then comes down to just the IO: with a
layer of indirection in there, a swapcache page can be valid without
disk backing, without having to fix up page tables and tmpfs trees.

> 
> > Now, most of that turned out to be overhead from PROVE_LOCKING and
> > PROVE_RCU: without those it was only 4 times slower than before;
> > and more realistic tests on other machines don't fare as badly.
> 
> What's unrealistic about doing swapoff of a 500MB tmpfs file?

It's not unrealistic, but it happened to be a simple artificial test
I did for this; my usual swap testing appeared not to suffer so badly,
though there was still a noticeable and tiresome slowdown.

> 
> Also, confused.  You're talking about creating a regular file on tmpfs
> and then using that as a swapfile?

No, that is and must be prohibited (the lack of bmap used to catch
that case, now lack of readpage catches it sooner).  With tmpfs pages
pushed out to swap, it's not a good idea to have your swap on tmpfs!

> If so, that's a kernel-hacker-curiosity only?

No, this is just the usual business of the pages of a tmpfs file being
pushed out to swap under memory pressure.  Then later swapoff bringing
them back into memory, and connecting them back to the tmpfs file.

> 
> > I've tried a number of things to improve it, including tagging the
> > swap entries, then doing lookup by tag: I'd expected that to halve
> > the time, but in practice it's erratic, and often counter-productive.
> > 
> > The only change I've so far found to make a consistent improvement,
> > is to short-circuit the way we go back and forth, gang lookup packing
> > entries into the array supplied, then shmem scanning that array for the
> > target entry.  Scanning in place doubles the speed, so it's now only
> > twice as slow as before (or three times slower when the PROVEs are on).
> > 
> > So, add radix_tree_locate_item() as an expedient, once-off, single-caller
> > hack to do the lookup directly in place.  #ifdef it on CONFIG_SHMEM and
> > CONFIG_SWAP, as much to document its limited applicability as save space
> > in other configurations.  And, sadly, #include sched.h for cond_resched().
> > 
> 
> How much did that 10 minutes improve?

To 1 minute: still twice as slow as before.  I believe that's because of
the smaller nodes and greater height of the generic radix tree.  I ought
to experiment with a bigger RADIX_TREE_MAP_SHIFT to verify that belief
(though I don't think tmpfs swapoff would justify raising it): will do.

Hugh
