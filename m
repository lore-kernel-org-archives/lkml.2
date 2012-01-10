Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab2AJQP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:15:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41923 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab2AJQPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:15:25 -0500
Date: Tue, 10 Jan 2012 16:15:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
Message-ID: <20120110161516.GB23916@ZenIV.linux.org.uk>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
 <20120109171639.GA9359@infradead.org>
 <20120109173010.GX23916@ZenIV.linux.org.uk>
 <CA+55aFwikQQrpGoyxvY+y=B8NfKBSdcAnKME+xZh+N1TQfp8LA@mail.gmail.com>
 <20120109205907.GE4198@dastard>
 <CA+55aFxN+Yh_M=P8cVbGcuHGo+PgcXm1bOFAJQ-5_euqU9LOww@mail.gmail.com>
 <20120110013434.GA23916@ZenIV.linux.org.uk>
 <CA+55aFzGe6sG0QotpqGpmNJ-HXqMxR5ocmXzvO2wdN_-MnARfA@mail.gmail.com>
 <CAJfpegu6BrLbmMSbf0QnKRe5rq0HgZYtYBEW8F+qehZC9GpQ8w@mail.gmail.com>
 <CA+55aFxszjhj5MatYe_KXJ=vYyf-05kzBbtmY1vgoGUio0DXuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxszjhj5MatYe_KXJ=vYyf-05kzBbtmY1vgoGUio0DXuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 08:00:30AM -0800, Linus Torvalds wrote:
> On Tue, Jan 10, 2012 at 2:05 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > I tested Dave's patch and the bug can still be easily reproduced.
> >
> > And that's to be expected, as the intermediate "being on the lru"
> > state that Dave's patch eliminates doesn't play a fundamental part in
> > the mechanism of the livelock. ?It does eliminate one trylock, but
> > that's not the one critical to this bug (removing it is a very good
> > idea anyway).
> >
> > The critical trylock here is the one in dentry_kill() which tries to
> > lock the parent.
> 
> Ok. Here's your patch munged for current -git. You've got most of a
> changelog, can you send this out with the right subject and a
> sign-off, and re-test with the current git just to make sure.
> 
> Al, do you want to handle this or should I take it directly?

I'll pick it once Miklos posts it.

> I'm assuming nobody has any objections to Miklos' patch?

I'm fine with it.

ObGrrr: I'm down to two remaining d_alloc_root() callers and while
neither is buggy per se, looking around a bit has turned up breakage
in both cases ;-/  (coda lookup treating OOM in new_inode() as
"not found" rather than -ENOMEM and hfs+ mount not bothering to check
if allocation *or* disk IO might fail, with very ugly results)...
