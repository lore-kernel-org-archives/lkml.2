Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab1HACKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 22:10:36 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:9957 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402Ab1HACKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 22:10:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhADAM0KNk55LCkBgWdsb2JhbABBp2EVAQEWJiWBQAEBBAE6HCMFCwgDGC4UJQMhE4dsvwUOhVVfBKNx
Date: Mon, 1 Aug 2011 12:09:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfstests 073 regression
Message-ID: <20110801020951.GA12870@dastard>
References: <20110728164105.GA18258@infradead.org>
 <20110729142121.GA21149@localhost>
 <20110730134422.GA1884@infradead.org>
 <20110731151014.GA23106@localhost>
 <20110731234749.GQ5404@dastard>
 <CA+55aFzkb58Gtzgpd3oQgXekpg4APN6jDLNCh=CAMQ0zwyE4kg@mail.gmail.com>
 <20110801012813.GR5404@dastard>
 <CA+55aFwtfUeUn=MuqSEyPiPeC5=k2xK2ULd9-5ShQAJ=4T0CvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwtfUeUn=MuqSEyPiPeC5=k2xK2ULd9-5ShQAJ=4T0CvQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 03:40:20PM -1000, Linus Torvalds wrote:
> On Sun, Jul 31, 2011 at 3:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > IOWs, what I'm asking is whether this "just move the inodes one at a
> > time to a different queue" is just a bandaid for a particular
> > symptom of a deeper problem we haven't realised existed....
> 
> Deeper problems in writeback? Unpossible.

Heh.

But that's exactly why I'd like to understand the problem fully.

> The writeback code has pretty much always been just a collection of
> "bandaids for particular symptoms of deeper problems".  So let's just
> say I'd not be shocked. But what else would you suggest? You could
> just break out of the loop if you can't get the read lock, but while
> the *common* case is likely that a lot of the inodes are on the same
> filesystem, that's certainly not the only possible case.

Right, but in this specific case of executing writeback_inodes_wb(),
we can only be operating on a specific bdi without being told which
sb to flush. If we are told which sb, then we go through
__writeback_inodes_sb() and avoid the grab_super_passive()
altogether because some other thread holds the s_umount lock.

These no-specific-sb cases can come only from
wb_check_background_flush() or wb_check_old_data_flush() which, by
definition, are oppurtunist background asynchronous writeback
executed only when there is no other work to do. Further, if there
is new work queued while they are running, they abort.

Hence if we can't grab the superblock here, it is simply another
case of a "new work pending" interrupt, right? And so aborting the
work is the correct thing to do? Especially as it avoids all the
ordering problems of redirtying inodes and allows the writeback work
to restart (form whatever context it is stared from next time) where
it stopped.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
