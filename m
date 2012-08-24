Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635Ab2HXUxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:53:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58552 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933522Ab2HXUxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:53:08 -0400
Date: Fri, 24 Aug 2012 13:53:03 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, Lars Ellenberg <lars.ellenberg@linbit.com>,
        Peter Osterlund <petero2@telia.com>, Sage Weil <sage@inktank.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v6 11/13] block: Rework bio_pair_split()
Message-ID: <20120824205303.GI21325@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-12-git-send-email-koverstreet@google.com>
 <20120822210410.GL19212@google.com>
 <20120824103049.GG11977@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824103049.GG11977@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 24, 2012 at 03:30:49AM -0700, Kent Overstreet wrote:
> > I complained about this in the last posting and in the previous patch.
> > Please respond.  Martin, are you okay with these integrity changes?
> 
> I did respond. I said more before, but in short the old
> bio_integrity_split() only worked for single page bios, and thus wasn't
> useful even as a starting point.
> 
> What my bio_split() does with the integrity is actually basically what
> dm does (that's the only other place bio_integrity_trim()) is used).

And all those information should be in the patch description.  Imagine
this patch hitting some enterprise deployment, say four years after
now, and causing weird performance regression and someone succeeding
to bisect it down to this commit.  None of us would be remembering
much about this and could in fact be doing something completely
different.  Patches should at least try to record its visible
implications.

This type of information should be always attached to the patch not
only for future references but also to alert reviewers who aren't
necessarily following the whole series and its iterations.

> > Also, given that it's a pair split, it would be nice to somehow
> > indicate that ->split is the earlier half.  Before this change it was
> > pretty clear with ->bio1/2.
> 
> Fixed the comment to indicate that too.

Any chance we can do that with field name?

> commit 5db0562e43099d06ed9488e7ae6bf0a0cc6ef5da
> Author: Kent Overstreet <koverstreet@google.com>
> Date:   Fri Aug 24 03:27:24 2012 -0700
> 
>     block: Rework bio_pair_split()
>     
>     This changes bio_pair_split() to use the new bio_split() underneath.
>     
>     This has two user visible changes: First, it's not restricted to single
>     page bios anymore. Secondly, where before callers used bio1 and bio2 in
>     struct bio_pair, now they use split and orig - this being a result of
>     the new implementation.
>     
>     bio_integrity_split() is removed, as the old bio_pair_split() was the
>     only user; the new bio_split() uses bio_integrity_clone/trim much like
>     the dm code does.

      "which may affect XXX in YYY cases but I think it's okay because ZZZ."

If you aren't that sure,

      "which may affect AAA but I don't think that's a big deal
       because BBB.  This definitely requires Martin's ack."

Thanks.

-- 
tejun
