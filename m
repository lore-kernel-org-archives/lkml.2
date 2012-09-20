Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2ITVxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:53:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53175 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2ITVxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:53:18 -0400
Date: Thu, 20 Sep 2012 14:53:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 01/26] block: Convert integrity to bvec_alloc_bs(),
 and a bugfix
Message-ID: <20120920215313.GE7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-2-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347322957-25260-2-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 10, 2012 at 05:22:12PM -0700, Kent Overstreet wrote:
> This adds a pointer to the bvec array to struct bio_integrity_payload,
> instead of the bvecs always being inline; then the bvecs are allocated
> with bvec_alloc_bs().
> 
> This is needed eventually for immutable bio vecs - immutable bvecs
> aren't useful if we still have to copy them, hence the need for the
> pointer. Less code is always nice too, though.
> 
> Also fix an amusing bug in bio_integrity_split() - struct bio_pair
> doesn't have the integrity bvecs after the bio_integrity_payloads, so
> there was a buffer overrun. The code was confusing pointers with arrays.

Aside from what Martin and Vivek already pointed out, it generally
looks okay to me but here are some thoughts.

I'm quite doubtful how much we're gaining by this complex set of slabs
and mempools approach compared to just using kmalloc + one mempool for
the largest size.  I can't think of anything to be gained in terms of
cacheline hotness.  In terms of memory usage too, we're proabably
introducing more fragmentation with all the different slabs.

Jens, what are you thoughts?  For forward progress guarantee, single
mempool per bioset serving the largest one is enough and we can
significantly simplify the whole bioset thing.

Thanks.

-- 
tejun
