Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab2IQVJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 17:09:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56417 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab2IQVJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 17:09:02 -0400
Date: Mon, 17 Sep 2012 14:08:58 -0700
From: Kent Overstreet <koverstreet@google.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        tj@kernel.org
Subject: Re: [dm-devel] [PATCH v2 01/26] block: Convert integrity to
 bvec_alloc_bs(), and a bugfix
Message-ID: <20120917210858.GC14492@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-2-git-send-email-koverstreet@google.com>
 <20120911203643.GC17113@redhat.com>
 <20120911220750.GM19739@google.com>
 <yq1wqzzrpy1.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1wqzzrpy1.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 03:39:18PM -0400, Martin K. Petersen wrote:
> >>>>> "Kent" == Kent Overstreet <koverstreet@google.com> writes:
> 
> Kent,
> 
> Kent> To fix the bug first, I'd have to reorder struct bio_pair and then
> Kent> just delete two lines of code from bio_integrity_split(). But the
> Kent> reordering is unnecessary with the refactoring.
> 
> Well, a bug is a bug and the fix needs to go into stable. So we will
> need a patch that does not depend on your changes.

Alright, good point.

> I don't have a problem with adding a pointer so clones can point to the
> parent's vector. But embedding the vector into the bip was a feature.
> If you check the git log you'll see that originally I did use separate
> vector allocations.

Looks like that was 7878cba9f0037f5599004b03a1260b32d9050360 - If I
follow your commit message your primary goal was to back the bip vecs by
a per bio set mempool?

I didn't break that (excepting the issue Vivek noted) - but it is true
that my patch adds another allocation (when nr_vecs > BIP_INLINE_VECS,
anyways).

I don't know how big of a deal you think that extra allocation is. If
you're against it, this patch isn't really necessary for the immutable
bvecs I'm working on - just need it if we want integrity bvecs to be
shared like regular bvecs will be.

Something else I noticed is bio_integrity_add_page() doesn't merge bvecs
when possible, like the regular bio_add_page(). If changing it to merge
bvecs wouldn't break anything, then probably most integrity bvecs would
be under BIP_INLINE_VECS.

Thoughts?
