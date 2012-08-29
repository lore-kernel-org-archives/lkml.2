Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab2H2Gly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 02:41:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35399 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2H2Glv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 02:41:51 -0400
Date: Tue, 28 Aug 2012 23:41:17 -0700
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: tj@kernel.org, martin.petersen@oracle.com
Subject: [RFC][PATCH] Immutable bio vecs
Message-ID: <20120829064117.GB22214@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I lied about patches. I got something working yesterday, but the
code is ugly and in flux and not _remotely_ complete.

Well, if you want to see actual code, it's up at
http://evilpiepirate.org/git/linux-bcache.git/log/?h=block_stuff-immutable_bio_vecs
http://evilpiepirate.org/git/linux-bcache.git/log/?h=block_stuff-immutable_bio_vecs

Anyways: IMMUTABLE BVECS

This is an idea I've been kicking around for ages, but it turns out it
had occured to other people besides me, so the other day I finally bit
the bullet and started writing code and trying to figure out how to make
it work sanely.

THE PROBLEM:

This mainly (but not exclusively!) affects stacking block devices, in a
variety of ways.

 * Stacking block devices pretty much universally have to split bios.
Bio splitting is inherently problematic when bvecs are mutable.
Primarily when the split isn't aligned on a bvec boundary, but the block
layer adds other difficulties.

 * CLONING/RETRYING
Many stacking block drivers like to handle errors. You know, things like
raid.

Well, mutable bvecs mean they have to clone not just the bio, but the
entire bvec to retry failed IOs. Awesome.

I'm sure this is less of a problem for certain filesystems, but I bet
their error handling code could benefit from this.

 * CONFUSING/INCONSISTENT SEMANTICS
This isn't so much something that immutable bio vecs will solve, but
rather something that has to be solved to make immutable bio vecs work.

Clearly separating the fields in struct bio into things that change
after submission and things that don't, and making the mutable things
mutate consistently has the potential to simplify and clarify a lot of
code.

I've been staring at a _lot_ of block layer code lately.

BENEFITS:

In the shorter term, what this really enables is writing/changing code
in the block layer to be much more incremental/flexible - instead of
going to ridiculous lengths to set things up ahead of time to adhere to
all the concievable limits, we simply handle bios incrementally and just
always make forward progress.

Arbitrary efficient bio splitting means (to pick one thing of many) we
can get rid of merge_bvec_fn. I did that in one of my branches, and I
deleted over 800 lines of code.

800 lines of HORRIBLE HORRIBLE code.

It isn't just stacking block devices that are benefited by this stuff,
normal block drivers should see improvements to, I just haven't spent as
much time with that kind of code. A lot of code related to
merging/counting segments can be gotten rid of, though - and that is
tricky code.

FURTHER OFF:

Something I've heard Tejun complain about (and I agree with) is the
ridiculous number of forms scatter/gather list an IO goes through on the
way down the stack.

By my count, it's as many as 4. Say you're doing aio:

 * kiocb page vector
 * the direct io code has its own page vector
 * struct bio/bvec
 * struct scatterlist

The immutable bvec stuff helps because it helps with lifting the
restrictions on bio sizes; the dio code can just _start_ by allocating a
bio that holds however many pages it needs, instead of creating its own
page vector then looping over that.

I think unifying bvecs and struct scatterlist is feasible too, and this
should help with that. Haven't thought about that one much though.

HOW DO WE GET TO THIS MAGICAL PLACE?

Pain, misery, and the tears of innocent children.

Well, there's a nontrivial amount of nontrivial restructing to do in a
a fair driver coder, but it looks doable and a lot can be done
incrementally.

THE PLAN:

Step 2: Add a field to struct bio - bi_bvec_done.

This is the number of bytes done in the current bvec; starts at 0 and
when bi_bvec_done == bv_len, set it to 0 and increment bi_idx.

That's really the gist of it, but getting to the point where that can be
done without breaking any existing code is going to take awhile.

Step 1: Introduce a bio iterator

struct bvec_iter {
	sector_t		bi_sector;	/* device address in 512 byte
						   sectors */
	unsigned int		bi_size;	/* residual I/O count */

	unsigned int		bi_idx;		/* current index into bvl_vec */
};

To this gets add bi_bvec_done later.

Initially, I just shoved those fields from struct bio into that struct,
and added a bi_iter field to struct bio - that was just a mass renaming.

This struct bvec_iter is more than just shuffling things around though,
it becomes the only way for driver code to do anything with the bvecs.

IMPLICATIONS:

The big one is that it is no longer possible for code to just poke into
bi_io_vec, without going through the abstractions. You can't use bv_len
or bv_offset on the first bvec without consulting bi_bvec_done, but you
also can't use bv_len on the _last_ bvec.

The reason for this is non aligned splits; if we split we can't modify
the bvec so the last bvec in the first split is going to have a bv_len
that has more bytes than belong to the bio.

So the only way to use the bvec is to iterate from the start,
decrementing bi_size as you go along - bi_size, _not_ bi_vcnt is what
tells you when you're done.

But with the bvec_iter we can construct a new bio_for_each_segment()
that works pretty much just like the old one:

#define __bio_for_each_segment(bvl, bio, iter, start)			\
	for (iter = start, bvl = bio_iovec_iter(bio, iter);		\
	     bvl.bv_len = min(bvl.bv_len, iter.bi_size),		\
		iter.bi_size;						\
	     iter.bi_size -= bvl.bv_len, iter.bi_idx++,			\
		bvl = *__bio_iovec_iter(bio, iter))

#define bio_for_each_segment(bvl, bio, iter)				\
	__bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)

I'm not including the definition of bio_iovec_iter, but it just returns
a bio_vec (a literal struct, not a pointer) that represents the start of
the bvec array, after taking into account bi_bvec_done.

So from the caller's perspective, they now just use a struct bvec to
iterate, not a pointer - and they use a struct bvec_iter instead of an
integer. For most callers it's a trivial conversion (I've already
converted all uses in my tree).

The non trivial conversions are basically any driver code that looks
into bi_io_vec directly. Besides bi_bvec_done, arbitrary splitting means
that when a driver gets a bio bi_idx may not be 0 - that is a major
concern, it turns out; because of that it just isn't reasonable or safe
for driver code to munge about in bi_io_vec directly.

Everything's got to be converted over to standard abstractions, which is
definitely going to require new utility code in fs/bio.c for various
types of cloning and whatnot (really to complement what's already
there).

So far, it seems the best way to find all the nontrivial stuff to
convert is to just grep around for bi_idx:

$ git grep bi_idx|wc -l
80

Not that bad... almost exactly half in drivers/md.

WHAT ABOUT THE IMMUTABLE BVEC ARRAY ITSELF?

Well, it turns out when we've got all this done, there actually doesn't
seem to be much code that modifies bi_idx or the bvec array itself -
that stuff is pretty well centralized/abstracted.

In practice it's mostly done from blk_update_request()/req_bio_endio()
in blk-core.c, which just does the obvious/simple thing as far as
consistently incrementing/decrementing all the various fields.

I abstracted this out into a new function, bio_advance() - this nicely
simplified blk_update_request(), and bio_advance() is going to be useful
elsewhere.

bio_advance() just takes a bio and some number of sectors to increment
the iterator by - aside from bi_bvec_done and the fields in the bvec
array, bi_size/bi_sector mean exactly what they used to and a bio is
complete when bi_size == 0.

This is really awesome for the new splitting code. That is the coolest
part of all this, if you ask me:

struct bio *split = bio_clone_bioset(bio, gfp, bio_set);
split->bi_size = sectors << 9;
bio_advance(bio, sectors);

Except 2 lines of code for the bio integrity stuff, that is the _entire_
new implementation of arbitrary bio splitting, and I'm going to get rid
of the extra bits for bio integrity too.

So anyways, I'm making excellent progress but I doubt I'm going to be
able to finish 100% of this on my own. I can do everything in the core
block layer code - including the stuff for merging/counting segments,
which is nasty - but for driver code I think I'm going to need help from
people working in the relevant areas to finish this stuff off.
