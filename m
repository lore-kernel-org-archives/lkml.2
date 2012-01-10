Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab2AJVwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 16:52:46 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:24306 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202Ab2AJVwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 16:52:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtkKAAiwDE95LbVq/2dsb2JhbABCq1KBB4EGgXIBAQUyASMjEAgDGC4UJQMhE75pE4sdYwSVC4kfiTA
Date: Wed, 11 Jan 2012 08:52:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
Message-ID: <20120110215240.GA24410@dastard>
References: <20120109171639.GA9359@infradead.org>
 <20120109173010.GX23916@ZenIV.linux.org.uk>
 <CA+55aFwikQQrpGoyxvY+y=B8NfKBSdcAnKME+xZh+N1TQfp8LA@mail.gmail.com>
 <20120109205907.GE4198@dastard>
 <CA+55aFxN+Yh_M=P8cVbGcuHGo+PgcXm1bOFAJQ-5_euqU9LOww@mail.gmail.com>
 <20120110013434.GA23916@ZenIV.linux.org.uk>
 <CA+55aFzGe6sG0QotpqGpmNJ-HXqMxR5ocmXzvO2wdN_-MnARfA@mail.gmail.com>
 <CAJfpegu6BrLbmMSbf0QnKRe5rq0HgZYtYBEW8F+qehZC9GpQ8w@mail.gmail.com>
 <CA+55aFxszjhj5MatYe_KXJ=vYyf-05kzBbtmY1vgoGUio0DXuQ@mail.gmail.com>
 <CAJfpegszrDO112d9A3PLsMY1+NnRpqFoLzODABnMq_VZq=DWFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJfpegszrDO112d9A3PLsMY1+NnRpqFoLzODABnMq_VZq=DWFw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 05:22:22PM +0100, Miklos Szeredi wrote:
> On Tue, Jan 10, 2012 at 5:00 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Tue, Jan 10, 2012 at 2:05 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >>
> >> I tested Dave's patch and the bug can still be easily reproduced.
> >>
> >> And that's to be expected, as the intermediate "being on the lru"
> >> state that Dave's patch eliminates doesn't play a fundamental part in
> >> the mechanism of the livelock.  It does eliminate one trylock, but
> >> that's not the one critical to this bug (removing it is a very good
> >> idea anyway).
> >>
> >> The critical trylock here is the one in dentry_kill() which tries to
> >> lock the parent.
> >
> > Ok. Here's your patch munged for current -git. You've got most of a
> > changelog, can you send this out with the right subject and a
> > sign-off, and re-test with the current git just to make sure.
> 
> See the one with the subject "vfs: fix shrink_dcache_parent()
> livelock" I sent out a bit earlier.
> 
> You didn't quite get it right: the flag now needs to be set in
> select_parent() not prune_dcache_sb().
> 
> I think prune_dcache_sb() doesn't need this logic (although it
> wouldn't hurt either) because that one is called from the slab
> shrinkers and those are protected from being run multiple times in
> parallel, I hope.

Shrinkers can be called in parallel by memory reclaim on different
CPUs. The only thing serialising them is the LRU locks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
