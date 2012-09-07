Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092Ab2IGXZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 19:25:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39840 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604Ab2IGXZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 19:25:35 -0400
Date: Fri, 7 Sep 2012 16:25:31 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Jens Axboe <axboe@kernel.dk>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v10 4/8] block: Add bio_reset()
Message-ID: <20120907232531.GF16360@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
 <1346970902-10931-5-git-send-email-koverstreet@google.com>
 <50494F1A.4080207@kernel.dk>
 <20120907205823.GD16360@google.com>
 <504A6D57.1030607@kernel.dk>
 <504A6FF5.3090603@kernel.dk>
 <20120907222522.GE16360@google.com>
 <504A78B0.8010105@kernel.dk>
 <20120907231433.GE10309@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907231433.GE10309@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 12:14:33AM +0100, Alasdair G Kergon wrote:
> As I indicated already in this discussion, dm started to use
> merge_bvec_fn as a cheap way of avoiding splitting and this improved
> overall efficiency.  Often it's better to pay the small price of calling
> that function to ensure the bio is created the right size in the first
> place so it won't have to get split later.

When I say cheap, I mean _cheap_:

split = bio_clone_bioset(bio, gfp_flags, bs);

bio_advance(bio, sectors << 9);
split->bi_iter.bi_size = sectors << 9;

And the clone doesn't copy the bvecs - split->bi_io_vec ==
bio->bi_io_vec.

> I'm as yet unconvinced that removing merge_bvec_fn would be an overall
> win.  Some of Kent's other changes that make splitting cheaper will
> improve the balance in some situations, but that might be handled by
> simplifying the merge_bvec_fn calculations in those situations.
> (Or changing the mechanism to avoid repeating performing the mapping
> when it hasn't changed.)

The current situation is what causes you to repeatedly do the mapping
lookup, since you'll often get contiguous bios that don't need to be
split at the mapping level (because of other requirements of the
underlying devices or because implementing merge_bvec_fn correctly was
too hard).

Splitting only when required is going to _improve_ that.

> IOW Any proposal to remove merge_bvec_fn from dm needs careful 
> evaluation to ensure it doesn't introduce any significant
> performance regressions for some sets of users.

There's also the 1000+ lines of deleted code to consider. In my
immutable bvec branch I've deleted over 400 lines of code, and that's
without actually trying to delete code. Getting rid of merge_bvec_fn
deletes another 800 lines of code on top of that.

CPU wise, there won't be any performance regressions. The only cause for
concern I can think of is where the upper layer could've made use of
partial completions - i.e. it submitted a 1 mb bio instead of a bunch of
128k bios, but it could've made use of that first 128k if it went to a
different device and completed sooner.

Only thing I know of that'd be affected by that though is readahead, and
I have a couple ideas for easily solving that if it actually becomes an
issue.
