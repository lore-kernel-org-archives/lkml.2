Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab1HAFwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 01:52:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:8237 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab1HAFwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 01:52:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,298,1309762800"; 
   d="scan'208";a="34122006"
Date: Mon, 1 Aug 2011 13:52:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfstests 073 regression
Message-ID: <20110801055212.GB21021@localhost>
References: <20110728164105.GA18258@infradead.org>
 <20110729142121.GA21149@localhost>
 <20110730134422.GA1884@infradead.org>
 <20110731151014.GA23106@localhost>
 <20110731234749.GQ5404@dastard>
 <CA+55aFzkb58Gtzgpd3oQgXekpg4APN6jDLNCh=CAMQ0zwyE4kg@mail.gmail.com>
 <20110801012813.GR5404@dastard>
 <CA+55aFwtfUeUn=MuqSEyPiPeC5=k2xK2ULd9-5ShQAJ=4T0CvQ@mail.gmail.com>
 <20110801020951.GA12870@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801020951.GA12870@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 10:09:51AM +0800, Dave Chinner wrote:
> On Sun, Jul 31, 2011 at 03:40:20PM -1000, Linus Torvalds wrote:
> > On Sun, Jul 31, 2011 at 3:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > IOWs, what I'm asking is whether this "just move the inodes one at a
> > > time to a different queue" is just a bandaid for a particular
> > > symptom of a deeper problem we haven't realised existed....
> > 
> > Deeper problems in writeback? Unpossible.
> 
> Heh.
> 
> But that's exactly why I'd like to understand the problem fully.
> 
> > The writeback code has pretty much always been just a collection of
> > "bandaids for particular symptoms of deeper problems".  So let's just
> > say I'd not be shocked. But what else would you suggest? You could
> > just break out of the loop if you can't get the read lock, but while
> > the *common* case is likely that a lot of the inodes are on the same
> > filesystem, that's certainly not the only possible case.
> 
> Right, but in this specific case of executing writeback_inodes_wb(),
> we can only be operating on a specific bdi without being told which
> sb to flush. If we are told which sb, then we go through
> __writeback_inodes_sb() and avoid the grab_super_passive()
> altogether because some other thread holds the s_umount lock.
> 
> These no-specific-sb cases can come only from
> wb_check_background_flush() or wb_check_old_data_flush() which, by
> definition, are oppurtunist background asynchronous writeback
> executed only when there is no other work to do. Further, if there
> is new work queued while they are running, they abort.

There is another type of work that won't abort: the one that started
by __bdi_start_writeback() and I'd call it "nr_pages" work since its
termination condition is simply nr_pages and nothing more. It's not
the for_background or for_kupdate works that will abort as soon as
other works are queued. 

Here I listed the two conditions for the deadlock (missing the 3rd
one: the read-write-read lock):

http://lkml.org/lkml/2011/7/31/63

In particular, the deadlock, once triggered, does not depend on how
large nr_pages is. It can be fixed by either of

1) the flusher abort the work early
2) the flusher don't busy retry the inode(s)

In the other email, I proposed to fix (2) for now and then do (1) in
future:

: So I'd propose this patch as the reasonable fix for 3.1. In long term,
: we may further consider make the nr_pages works give up temporarily
: when there comes a sync work, which could eliminate lots of
: redirty_tail()s at this point.

> Hence if we can't grab the superblock here, it is simply another
> case of a "new work pending" interrupt, right? And so aborting the
> work is the correct thing to do? Especially as it avoids all the
> ordering problems of redirtying inodes and allows the writeback work
> to restart (form whatever context it is stared from next time) where
> it stopped.

The long term solution (2) I proposed is actually the same as your
proposal to abort the work :)

Thanks,
Fengguang
