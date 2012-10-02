Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab2JBU7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 16:59:20 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40435 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab2JBUwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 16:52:53 -0400
Date: Tue, 2 Oct 2012 13:52:50 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk,
        "Martin K. Petersen" <martin.petersen@oracle.com>, tj@kernel.org
Subject: Re: [dm-devel] [PATCH v3 02/26] block: Convert integrity to
 bvec_alloc_bs()
Message-ID: <20121002205249.GR26488@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-3-git-send-email-koverstreet@google.com>
 <20121002151202.GE758@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002151202.GE758@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 11:12:02AM -0400, Vivek Goyal wrote:
> On Mon, Sep 24, 2012 at 03:34:42PM -0700, Kent Overstreet wrote:
> > This adds a pointer to the bvec array to struct bio_integrity_payload,
> > instead of the bvecs always being inline; then the bvecs are allocated
> > with bvec_alloc_bs().
> 
> Ok, you are introducing bio_vec pointer in this patch. May be we can
> do it earlier so that we take care of bio pair related issue.

I was just trying to make the bugfix patch small, since people
complained about too much stuff being done in one patch.

> > Changed bvec_alloc_bs() and bvec_free_bs() to take a pointer to a
> > mempool instead of the bioset, so that bio integrity can use a different
> > mempool for its bvecs, and thus avoid a potential deadlock.
> 
> If you are taking mempool as input, then bvec_alloc_bs() name does not
> make sense, as I think the very fact "bs" in the name their suggests
> that you are taking a pointer to bio set (and not mempool).
> 
> Given the fact that bio_vec pool for integrity inside bio set, why not
> take additional boolean/enum argument to function bvec_alloc_bs() and
> that argument can tell whehter to allocate bvec from which bvec pool.

Eww, boolean arguments are always bad. 

You are right about bvec_alloc_bs() being misnamed now... honestly it
doesn't bother me, but it should probably just be renamed to
bvec_alloc().

Much prefer the mempool arg to a boolean, though.

> > This is eventually for immutable bio vecs - immutable bvecs aren't
> > useful if we still have to copy them, hence the need for the pointer.
> > Less code is always nice too, though.
> 
> Can you explain a bit more about immutable bio vecs. I know there was
> some discussion and I missed it. So either point me to right mail thread
> or just explain a bit more what are immutable bio vecs, how we are
> planning to use these.

http://article.gmane.org/gmane.linux.kernel.bcache.devel/890

That's my writeup - Tejun and I have been talking about this for ages,
and then Martin Petersen independently brought it up recently and that
was when I decided to just dive in and do it - but they'd probably have
their own ideas about what it's good for. (Tejun wants to reduce the
number of different scatter/gather list implementations).

> Is it about during split we don't want to copy bio vecs and that's why we
> need a pointer so that newly created bio/bip can point to parent's bio_vec?

That's one reason. It enables efficient arbitrary bio splitting, which
enables a whole host of cleanups and simplifications (I've deleted ~1500
lines of code in my tree).

Also, the fact that bv_len and bv_offset are modified is a pain; the
owner of the bio can't use them after the bio has completed, if it
needed to know what memory the bio pointed to it's got to store that
somewhere else. This fixes that.

It's a real pain for error handling in stacking block drivers - if they
want to be able to retry the bio, they have to clone not just the bio
itself but the entire bvec.
