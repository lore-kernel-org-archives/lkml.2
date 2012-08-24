Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab2HXKiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 06:38:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41716 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab2HXKiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 06:38:08 -0400
Date: Fri, 24 Aug 2012 03:37:34 -0700
From: Kent Overstreet <koverstreet@google.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Peter Osterlund <petero2@telia.com>, Sage Weil <sage@inktank.com>
Subject: Re: [PATCH v6 11/13] block: Rework bio_pair_split()
Message-ID: <20120824103734.GH11977@moria.home.lan>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-12-git-send-email-koverstreet@google.com>
 <20120822210410.GL19212@google.com>
 <yq1y5l5hvpw.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1y5l5hvpw.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 10:25:47PM -0400, Martin K. Petersen wrote:
> >>>>> "Tejun" == Tejun Heo <tj@kernel.org> writes:
> 
> Tejun> I complained about this in the last posting and in the previous
> Tejun> patch.  Please respond.  Martin, are you okay with these
> Tejun> integrity changes?
> 
> I missed the first several iterations of all this while I was out on
> vacation. I'll have to try to wrap my head around the new approach.
> 
> However, I'm not sure I like the overall approach of the new splitting.
> Instead of all this cloning, slicing and dicing of bio_vecs I'd rather
> we bit the bullet and had an offset + length for the vector inside each
> bio. That way we could keep the bio_vec immutable and make clones more
> lightweight since their vecs would always point to the parent. This also
> makes it trivial to split I/Os in the stacking drivers and removes evils
> in the partial completion code path. It would also allow to sever the
> ties between "size of block range operated on" vs. bi_size which we need
> for copy offload, discard, etc.

Agree 110% - making bio_vecs immutable and keeping the offset in the bio
is something I've been talking about for ages, I'd love to see it
happen.

But that's going to be a much more invasive change so if I'm going to do
it (and I am willing to work on it) it's just going to be a bit. This is
really a stopgap solution.

As far as the integrity splitting, it's similar to what the existing dm
code does (main difference is dm already has the bio cloned, my
bio_split() doesn't assume anything about the bio being split). Not sure
how that affects ownership of the integrity data, honestly that part
kind of confuses me.
