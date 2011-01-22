Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab1AVWWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 17:22:23 -0500
Received: from smtp-out.google.com ([216.239.44.51]:37274 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1AVWWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 17:22:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=MHXap+mNUujT4UaxaXhJw5pnPexv2m3+dPZyVVEOVvitjfBFjbe1Dt6VaaQe+lW5iR
         XxKfH5ufzJyvW5Icbkdw==
Date: Sat, 22 Jan 2011 14:22:10 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Robin Holt <holt@sgi.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: shmget limited by SHMEM_MAX_BYTES to 0x4020010000 bytes
 (Resend).
In-Reply-To: <AANLkTikG9ud-hpXaLjLcv6+j9O00guhcZTa=OPs9PX4A@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1101221304240.1822@sister.anvils>
References: <20110122153033.GR2912@sgi.com> <20110122153459.GF3306@sgi.com> <AANLkTikG9ud-hpXaLjLcv6+j9O00guhcZTa=OPs9PX4A@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1687950602-1295734937=:1822"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1687950602-1295734937=:1822
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 22 Jan 2011, Linus Torvalds wrote:
> On Sat, Jan 22, 2011 at 7:34 AM, Robin Holt <holt@sgi.com> wrote:
> > I have a customer system with 12 TB of memory. =A0The customer is tryin=
g
> > to do a shmget() call with size of 4TB and it fails due to the check in
> > shmem_file_setup() against SHMEM_MAX_BYTES which is 0x4020010000.
> >
> > I have considered a bunch of options and really do not know which
> > direction I should take this.

One question to ask first, does the customer use swap?  If not,
then that limit and all the indexing and swap-related stuff in
mm/shmem.c is just pointless overhead - that remains because I
never got around to putting in the appropriate #ifdef CONFIG_SWAPs
(which would require some rearrangement to avoid too much ugliness).

If the customer does not use swap, then just work through it putting
in #ifdef CONFIG_SWAPs to remove the need for that limit, and go no
further.

> >
> > I could add a third level and fourth level with a similar 1/4 size bein=
g
> > the current level of indirection, and the next quarter being a next lev=
el.
> > That would get me closer, but not all the way there.
>=20
> Ugh.
>=20
> How about just changing the indexing to use a bigger page allocation?
> Right now it uses PAGE_CACHE_SIZE and ENTRIES_PER_PAGE, but as far as
> I can tell, the indexing logic is entirely independent from PAGE_SIZE
> and PAGE_CACHE_SIZE, and could just use its own SHM_INDEX_PAGE_SIZE or
> something.

That's a very sensible suggestion, for a quick measure to satisfy the
customer.

>=20
> That would allow increasing the indexing capability fairly easily, no?
> No actual change to the (messy) algorithm at all, just make the block
> size for the index pages bigger.

Yes, I've no inclination to revisit that messy algorithm myself.
(I admit it was me who made it a lot messier, in enabling highmem
on those index pages.)

>=20
> Sure, it means that you now require multipage allocations in
> shmem_dir_alloc(), but that doesn't sound all that hard. The code is
> already set up to try to handle it (because we have that conceptual
> difference between PAGE_SIZE and PAGE_CACHE_SIZE, even though the two
> end up being the same).

I did once try to get PAGE_SIZE versus PAGE_CACHE_SIZE right in that
file, I think it even got some testing when ChristophL had a patch to
raise PAGE_CACHE_SIZE.  But I don't promise that it will provide a
reliable guide as is.

>=20
> NOTE! I didn't look very closely at the details, there may be some
> really basic reason why the above is a completely idiotic idea.

It's not at all idiotic.  But I feel a lot more confident to rely
upon order:1 pages being available than order:2 pages.  Order:2 pages
for the index will give you more than you need, 16TB I think; whereas
order:1 pages will only take you to 2TB.

If the customer won't be needing larger than 4TB for a while, then
I'd be inclined to add in a hack to limit maximum swap size (see
maxpages in SYSCALL_DEFINE2(swapon,,,,) in mm/swapfile.c), so the
swp_entry_t is sure to fit in 32-bits even on 64-bit architecture -
then you can pack twice as many into the lowest level of the index.

And save yourself some time by doing this only for 64-bit, so you
don't have to bother about all those kmap_atomics, which would only
be covering a half or a quarter of your higher order page.

>=20
> The alternative (and I think it might be a good alternative) is to get
> rid of the shmem magic indexing entirely, and rip all the code out and
> replace it with something that uses the generic radix tree functions.
> Again, I didn't actually look at the code enough to judge whether that
> would be the most painful effort ever or even possible at all.

Yes, that's what I've really wanted to do for a long time now,
so in part why I've never bothered to CONFIG_SWAPify mm/shmem.c.

What I want is to use the very same radix tree that find_lock_page()
is using: where a page is present, the usual struct page *; where it's
swapped out, the swp_entry_t (or perhaps a pointer into the swap_map).
It seems wasteful to have two trees when one should be enough.

If that can be done without uglifying or duplicating too many fundamental
interfaces, then I think it's the way to go.  It's good for the people
with small memory, it's good for the people with large memory, it's
good for the people with no swap.

But not quite so good for the 32-bit highmem swap people: when a
file is entirely swapped out, the current shmem index resides in
highmem, and the pagecache radix tree gets freed up; whereas with
this proposed change, the lowmem radix tree would have to remain.

That has deterred me until recently, but I think we're now far
enough into 64-bit to afford that regression on 32-bit highmem.

However, I don't think your customer should wait for me!

Hugh
--8323584-1687950602-1295734937=:1822--
