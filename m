Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1CCAPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 19:15:12 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:59726 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab1CCAPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 19:15:10 -0500
Message-ID: <4D6EDD88.4080906@kernel.dk>
Date: Wed, 02 Mar 2011 19:15:04 -0500
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Anton Altaparmakov <aia21@cam.ac.uk>, Christoph Hellwig <hch@lst.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        George Spelvin <linux@horizon.com>
Subject: Re: a major regression in recent kernels? - was: Re: Null pointer
  OOPS in sync_inodes_sb+0xa9/0x104
References: <20110302034417.4954.qmail@science.horizon.com> <023AB542-CCF0-4436-8594-51132FEA8070@cam.ac.uk> <AANLkTi=eWdUjgTB2iWOB7YxOtm9f9a9Ux2uCghR=KTgN@mail.gmail.com>
In-Reply-To: <AANLkTi=eWdUjgTB2iWOB7YxOtm9f9a9Ux2uCghR=KTgN@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-02 13:31, Linus Torvalds wrote:
> Hmm. Adding some more people to the cc - in particular Jens. I'm not
> sure that he'd be on the fsdevel list (although maybe he is).
> 
> The whole "backing_dev_info" has been a total disaster. The thing is
> crap. It violates all the normal kernel memory management rules ("Thou
> shalt use reference counts and free only when it goes to zero") and
> the whole thing has been a constant source of "oh, that driver didn't
> set it, but we changed all the code to require it to be correct".
> 
> And the reason we set it to NULL when the device goes away is exactly
> that it's not ref-counted correctly, so we really _have_ to set it to
> NULL, because it's not going to be around.
> 
> (And the reverse of that is why all kernel data structures should use
> refcounts, and not some external lifetime notion)
> 
> Gaah. The caller has already done the check for a NULL s_bdi:
> 
>         /*
>          * This should be safe, as we require bdi backing to actually
>          * write out data in the first place
>          */
>         if (!sb->s_bdi || sb->s_bdi == &noop_backing_dev_info)
>                 return 0;
> 
> before it calls into "sync_inodes_sb(sb);", but since that stupid
> disconnect event can happen at any time, that doesn't protect
> anything. The s_bdi field clearly just becomes NULL after the check.
> 
> Jens? This was introduced in 592b09a42fc3 ("backing-dev: ensure that a
> removed bdi no longer has super_block referencing it") over a year
> ago, but the _real_ problem goes back all the way to commit
> 32a88aa1b6df which introduced that broken "s_bdi" without refcounts to
> begin with.
> 
> Guys, any idea on how to fix this? The hacky way might be to introduce
> a dummy backing_dev_info and instead of setting s_bdi to NULL, we set
> it to the dummy one that doesn't do anything. It's still hacky as
> hell, though. The real problem really is that having pointers to
> structures without refcounts is just _always_ wrong.
> 
> See Documentation/CodingStyle: "Chapter 11: Data structures":
> 
>   "Remember: if another thread can find your data structure, and you don't
>    have a reference count on it, you almost certainly have a bug."
> 
> wiser words have seldom been spoken.

Agree, from the ->s_bdi point of view it has been and is a mess. I guess
the hope was to avoid adding real reference counting for the bdi. I just
took a quick look at it, and I don't think it'll be too problematic to
add. The bdi is mostly just a settings container.

We already pretty much have a dummy backing_dev_info,
default_backing_dev_info. 2.6.38 and stable backport would be to use
that and going forward ensure we probably reference the bdi when it's
attached to the super block.

I've got a flight coming up tomorrow, I'll cook up both patches for
this.


-- 
Jens Axboe

